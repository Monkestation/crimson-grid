GLOBAL_DATUM_INIT(cd_burn_permissions, /datum/cd_burn_permissions, new)

#define CD_BURN_PERMISSION_FILE "data/cd_burn_approved.json"
#define CD_BURN_DENY_COOLDOWN (5 MINUTES)

/datum/cd_burn_permissions
	/// ckey = TRUE
	var/list/approved = list()
	/// ckey = world.time the request was made
	var/list/pending = list()
	/// ckey = world.time when they may ask again
	var/list/denied_until = list()

/datum/cd_burn_permissions/New()
	. = ..()
	load()

/datum/cd_burn_permissions/proc/load()
	if(!fexists(CD_BURN_PERMISSION_FILE))
		return
	var/raw = file2text(CD_BURN_PERMISSION_FILE)
	if(!raw)
		return
	var/list/entries = json_decode(raw)
	if(!islist(entries))
		return
	for(var/entry in entries)
		approved[ckey(entry)] = TRUE

/datum/cd_burn_permissions/proc/save()
	var/list/entries = list()
	for(var/entry in approved)
		entries += entry
	fdel(CD_BURN_PERMISSION_FILE)
	text2file(json_encode(entries), CD_BURN_PERMISSION_FILE)

/datum/cd_burn_permissions/proc/get_status(mob/user)
	if(!user)
		return "none"
	if(user.client?.holder)
		return "approved"
	var/key = user.ckey
	if(!key)
		return "none"
	if(approved[key])
		return "approved"
	if(pending[key])
		return "pending"
	if(denied_until[key] > world.time)
		return "denied"
	return "none"

/datum/cd_burn_permissions/proc/has_permission(mob/user)
	return get_status(user) == "approved"

/datum/cd_burn_permissions/proc/request(mob/user)
	if(get_status(user) != "none")
		return FALSE
	var/key = user.ckey
	pending[key] = world.time
	message_admins("<span class='adminnotice'>CD BURNER: [key_name_admin(user)] is requesting permission to burn CDs. \
		<a href='?src=[REF(src)];approve=[key]'>Approve</a> | \
		<a href='?src=[REF(src)];deny=[key]'>Deny</a></span>")
	return TRUE

/datum/cd_burn_permissions/proc/resolve(target, approve, mob/admin)
	target = ckey(target)
	if(!pending[target])
		to_chat(admin, span_warning("That request has already been handled."))
		return FALSE
	pending -= target

	var/mob/requester = get_mob_by_ckey(target)
	if(approve)
		approved[target] = TRUE
		save()
		message_admins("[key_name_admin(admin)] approved CD burning for [target].")
		log_admin("[key_name(admin)] approved CD burning for [target].")
		if(requester)
			to_chat(requester, span_notice("An admin approved your request to burn CDs."))
	else
		denied_until[target] = world.time + CD_BURN_DENY_COOLDOWN
		message_admins("[key_name_admin(admin)] denied CD burning for [target].")
		log_admin("[key_name(admin)] denied CD burning for [target].")
		if(requester)
			to_chat(requester, span_warning("An admin denied your request to burn CDs."))
	return TRUE

/datum/cd_burn_permissions/proc/revoke(target, mob/admin)
	target = ckey(target)
	if(!approved[target])
		return FALSE
	approved -= target
	save()
	message_admins("[key_name_admin(admin)] revoked CD burning for [target].")
	log_admin("[key_name(admin)] revoked CD burning for [target].")
	return TRUE

/datum/cd_burn_permissions/Topic(href, list/href_list)
	. = ..()
	if(.)
		return
	if(!check_rights(R_ADMIN))
		return
	if(href_list["approve"])
		resolve(href_list["approve"], TRUE, usr)
	else if(href_list["deny"])
		resolve(href_list["deny"], FALSE, usr)

ADMIN_VERB(manage_cd_burners, R_ADMIN, "Manage CD Burners", "Grant or revoke permission to burn CDs.", ADMIN_CATEGORY_GAME)
	var/choice = tgui_input_list(user, "What would you like to do?", "CD Burner Permissions", list("Grant", "Revoke"))
	if(!choice)
		return

	var/datum/cd_burn_permissions/perms = GLOB.cd_burn_permissions
	if(choice == "Grant")
		var/target = ckey(tgui_input_text(user, "Ckey to grant burning permission:", "Grant"))
		if(!target)
			return
		perms.approved[target] = TRUE
		perms.pending -= target
		perms.save()
		message_admins("[key_name_admin(user)] granted CD burning to [target].")
		log_admin("[key_name(user)] granted CD burning to [target].")
	else
		var/list/keys = list()
		for(var/entry in perms.approved)
			keys += entry
		if(!length(keys))
			to_chat(user, span_notice("Nobody has CD burning permission."))
			return
		var/target = tgui_input_list(user, "Revoke permission from:", "Revoke", keys)
		if(target)
			perms.revoke(target, user.mob)

#undef CD_BURN_DENY_COOLDOWN
#undef CD_BURN_PERMISSION_FILE
