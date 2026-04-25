/datum/admin_discipline_editor
	var/target_ckey = ""
	var/selected_slot = 0
	var/datum/preferences/target_prefs = null
	var/loaded_offline = FALSE
	var/not_found = FALSE
	var/list/discipline_cache = null

/datum/admin_discipline_editor/Destroy()
	if(loaded_offline)
		QDEL_NULL(target_prefs)
	target_prefs = null
	return ..()

/datum/admin_discipline_editor/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AdminDisciplineEditor")
		ui.open()

/datum/admin_discipline_editor/ui_state(mob/user)
	return ADMIN_STATE(R_ADMIN)

/datum/admin_discipline_editor/ui_data(mob/user)
	var/list/data = list()
	data["target_ckey"] = target_ckey
	data["selected_slot"] = selected_slot
	data["not_found"] = not_found
	data["is_trusted"] = target_prefs?.discipline_trusted || FALSE
	data["character_slots"] = list()
	data["discipline_levels"] = list()
	data["clan_disciplines"] = list()
	data["disciplines"] = build_discipline_cache()
	data["discipline_validation"] = null
	data["character_name"] = null
	data["character_age"] = null
	data["immortal_age"] = null
	data["clan_name"] = null
	data["splat_name"] = null
	data["flavor_text"] = null
	data["headshot"] = null

	var/list/connected = list()
	var/list/invalid_ckeys = list()
	var/list/trusted_ckeys = list()
	for(var/ckey in GLOB.directory)
		var/client/C = GLOB.directory[ckey]
		if(!C || !C.mob)
			continue
		connected += ckey
		if(C.prefs?.discipline_trusted)
			trusted_ckeys += ckey
		if(ishuman(C.mob))
			var/list/validation = validate_mob_sheet(C.mob)
			if(validation && !validation["valid"])
				invalid_ckeys += ckey
	data["connected_ckeys"] = connected
	data["invalid_ckeys"] = invalid_ckeys
	data["trusted_ckeys"] = trusted_ckeys

	if(target_prefs)
		var/list/profiles = target_prefs.create_character_profiles()
		for(var/i in 1 to target_prefs.max_save_slots)
			if(profiles[i])
				data["character_slots"] += list(list("slot" = i, "name" = profiles[i]))

		if(selected_slot > 0)
			data["character_name"] = target_prefs.read_preference(/datum/preference/name/real_name)
			data["character_age"] = target_prefs.read_preference(/datum/preference/numeric/age)
			data["immortal_age"] = target_prefs.read_preference(/datum/preference/numeric/immortal_age)
			data["flavor_text"] = target_prefs.read_preference(/datum/preference/text/flavor_text)
			data["headshot"] = target_prefs.read_preference(/datum/preference/text/headshot)

			var/splat_path = target_prefs.read_preference(/datum/preference/choiced/splats)
			if(ispath(splat_path, /datum/splat))
				var/datum/splat/splat_proto = GLOB.splat_prototypes[splat_path]
				data["splat_name"] = splat_proto?.name
			else
				data["splat_name"] = "Human"

			var/list/clan_discs = list()
			for(var/disc_path in target_prefs.discipline_levels)
				data["discipline_levels"]["[disc_path]"] = target_prefs.discipline_levels[disc_path]

			var/clan_value = target_prefs.read_preference(/datum/preference/choiced/subsplat/vampire_clan)
			if(clan_value)
				var/datum/subsplat/vampire_clan/clan_datum = get_vampire_clan(clan_value)
				if(clan_datum)
					data["clan_name"] = clan_datum.name
					for(var/disc_type in clan_datum.clan_disciplines)
						if(ispath(disc_type, /datum/discipline))
							var/disc_str = "[disc_type]"
							data["clan_disciplines"] += disc_str
							clan_discs += disc_str

			data["discipline_validation"] = validate_discipline_sheet(target_prefs.discipline_levels, clan_discs, target_prefs.discipline_trusted)

	return data

/datum/admin_discipline_editor/proc/build_discipline_cache()
	if(discipline_cache)
		return discipline_cache

	discipline_cache = list()
	for(var/discipline_type in subtypesof(/datum/discipline))
		var/datum/discipline/discipline = new discipline_type
		if(!discipline.selectable)
			qdel(discipline)
			continue
		if(ispath(discipline_type, /datum/discipline/path))
			qdel(discipline)
			continue
		var/list/disc_data = list()
		disc_data["name"] = discipline.name
		disc_data["desc"] = discipline.desc
		disc_data["max_level"] = discipline.max_selectable_level || length(discipline.all_powers)
		disc_data["rarity"] = (discipline_type in RARE_DISCIPLINE_TYPES) ? "rare" : "common"
		disc_data["icon"] = initial(discipline.icon)
		disc_data["icon_state"] = discipline.icon_state
		discipline_cache["[discipline_type]"] = disc_data
		qdel(discipline)

	return discipline_cache

/datum/admin_discipline_editor/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("search_ckey")
			var/search = params["ckey"]
			if(!search)
				return FALSE
			search = ckey(search)
			not_found = !load_target(search)
			log_admin_private("[key_name_admin(ui.user)] searched for [search] in the discipline UI.")
			return TRUE

		if("select_slot")
			if(!target_prefs)
				return FALSE
			var/slot = round(text2num(params["slot"]))
			if(!slot)
				return FALSE
			slot = clamp(slot, 1, target_prefs.max_save_slots)
			target_prefs.load_character(slot)
			target_prefs.default_slot = slot
			selected_slot = slot
			return TRUE

		if("set_discipline_level")
			if(!target_prefs || !selected_slot)
				return FALSE
			var/disc_path = params["discipline"]
			var/new_level = text2num(params["level"])
			if(!disc_path || isnull(new_level))
				return FALSE
			new_level = round(new_level)
			if(new_level < 0 || new_level > 5)
				return FALSE
			if(new_level == 0)
				target_prefs.discipline_levels -= disc_path
			else
				target_prefs.discipline_levels[disc_path] = new_level
			var/client/target_client = GLOB.directory[target_ckey]
			if(target_client?.mob && ishuman(target_client.mob))
				var/mob/living/carbon/human/target_mob = target_client.mob
				var/discipline_path = text2path(disc_path)
				if(new_level == 0)
					target_mob.remove_st_power(discipline_path) // so admins can remove disciplines immediately by setting them to 0
				else if(!target_mob.change_st_power_level(discipline_path, new_level))
					target_mob.give_st_power(discipline_path, new_level) // and add them immediately, too
			var/character_name = target_prefs.read_preference(/datum/preference/name/real_name)
			target_prefs.save_character()
			message_admins("[key_name_admin(ui.user)] set [disc_path] to level [new_level] for [ADMIN_LOOKUPFLW(target_ckey)]'s character [character_name]).")
			log_admin("[key_name_admin(ui.user)] set [disc_path] to level [new_level] for [ADMIN_LOOKUPFLW(target_ckey)]'s character [character_name]).")
			return TRUE

		if("toggle_trusted")
			if(!target_prefs)
				return FALSE
			target_prefs.discipline_trusted = !target_prefs.discipline_trusted
			target_prefs.save_preferences()
			message_admins("[ui.user] [target_prefs.discipline_trusted ? "granted" : "revoked"] trusted discipline whitelist for [ADMIN_LOOKUPFLW(target_ckey)].")
			return TRUE

/datum/admin_discipline_editor/proc/load_target(search_ckey)
	if(loaded_offline && target_prefs)
		qdel(target_prefs)
		target_prefs = null
		loaded_offline = FALSE

	target_ckey = search_ckey
	selected_slot = 0

	var/client/found_client = GLOB.directory[search_ckey]
	if(found_client?.prefs)
		target_prefs = found_client.prefs
		loaded_offline = FALSE
		selected_slot = target_prefs.default_slot
		return TRUE
	var/prefs_path = "data/player_saves/[search_ckey[1]]/[search_ckey]/preferences.json"
	if(!fexists(prefs_path))
		return FALSE
	var/datum/client_interface/mock = new
	mock.ckey = search_ckey
	mock.key = search_ckey
	var/datum/preferences/offline_prefs = new(mock)
	offline_prefs.load_character(1)
	offline_prefs.default_slot = 1
	target_prefs = offline_prefs
	loaded_offline = TRUE
	selected_slot = 1
	return TRUE

ADMIN_VERB(discipline_menu, R_ADMIN, "Discipline Menu", "Edit a player's disciplines.", ADMIN_CATEGORY_SECOND_CITY)
	var/datum/admin_discipline_editor/editor = new
	editor.ui_interact(user.mob)
	BLACKBOX_LOG_ADMIN_VERB("Discipline Menu")
