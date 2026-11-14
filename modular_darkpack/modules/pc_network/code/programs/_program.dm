/datum/pc_program
	var/name = "Program"
	var/icon_state = "generic"
	var/obj/machinery/computer/pc/computer
	var/tgui_id = "PcGeneric"
	var/datum/weakref/tap
	var/tap_until = 0

/datum/pc_program/New(obj/machinery/computer/pc/host)
	computer = host

/datum/pc_program/ui_data(mob/user)
	return list()

/datum/pc_program/proc/get_carried_photos(mob/user)
	var/list/found = list()
	if(!user)
		return found
	for(var/obj/item/photo/P in user.get_all_contents())
		if(!P.picture?.picture_image)
			continue
		found += P
		if(length(found) >= 10)
			break
	return found

///all programs clean the same and this shouldn't just be a raw call because of nulls and future proof
/datum/pc_program/proc/clean_text(raw, max_len)
	if(!istext(raw))
		return ""
	return trim(copytext_char(raw, 1, max_len + 1))

/datum/pc_program/proc/notify_tap(datum/bank_account/payer, datum/bank_account/payee, amount)

/datum/pc_program/proc/get_lock_reason(mob/living/user)
	return null

/datum/pc_program/proc/get_ui_assets()
	return
