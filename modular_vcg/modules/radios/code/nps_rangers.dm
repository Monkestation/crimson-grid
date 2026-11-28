/obj/item/radio/headset/darkpack/nps_rangers
	name = "\improper Ranger radio"
	icon_state = "pp25"
	radio_network = NETWORK_NPS_RANGERS
	COOLDOWN_DECLARE(emergency_cooldown)

/obj/item/radio/headset/darkpack/nps_rangers/Initialize(mapload)
	. = ..()
	set_frequency(FREQ_NPS_RANGERS)
	radio_id = rand(1, 999) // Doesn't have a transceiver, and random ID makes sure it can't get linked to a different one. IDs can theoretically clash, but this won't break anything and is very unlikely in the first place, so fixing that probably isn't worth it.

/obj/item/radio/headset/darkpack/nps_rangers/examine(mob/user)
	. = ..()
	var/turf/current_turf = get_turf(src)
	. += span_info("GPS Location: " + english_list(list(current_turf.x, current_turf.y, current_turf.z), and_text = ", "))
	. += span_notice("It has a red button on the side to call for backup. It can be activated with [EXAMINE_HINT("Ctrl-Shift-Click")].")

/obj/item/radio/headset/darkpack/nps_rangers/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = NONE
	if(isnull(held_item))
		context[SCREENTIP_CONTEXT_CTRL_SHIFT_LMB] = "Activate Emergency Backup Call"
		return CONTEXTUAL_SCREENTIP_SET

/obj/item/radio/headset/darkpack/nps_rangers/click_ctrl_shift(mob/user) // Mirrors police radio implementation. Ranger transceiver would not be on our map, so it simply sends alerts directly.
	var/confirmation_popup = tgui_alert(user, "Are you sure you want to send an emergency backup call?", "Emergency Backup Call", list("Cancel", "Confirm"))
	if(confirmation_popup != "Confirm")
		return
	if(!COOLDOWN_FINISHED(src, emergency_cooldown))
		balloon_alert(user, "busy!")
		return
	if(radio_network != NETWORK_NPS_RANGERS)
		balloon_alert(user, "unconnected!")
		return
	user.balloon_alert_to_viewers("beep!", "activated!")
	var/turf/location = get_turf(src)
	talk_into(src, span_red("10-33 - EMERGENCY - UNIT [radio_id] REQUIRES BACKUP AT: [english_list(list(location.x, location.y, location.z, get_area_name(location, TRUE)), and_text = ", ")]."), FREQ_NPS_RANGERS, list(SPAN_ROBOT, SPAN_COMMAND)) // Sends message directly because no transceiver for simplicity.

	var/datum/signal/subspace/radio/signal = new(FREQ_NPS_RANGERS, list())
	INVOKE_ASYNC(signal, TYPE_PROC_REF(/datum/signal/subspace/radio, send_to_receivers))
	log_message("NPS Rangers emergency alarm triggered at: [english_list(list(location.x, location.y, location.z, get_area_name(location, TRUE)), and_text = ", ")]", LOG_PDA)
	COOLDOWN_START(src, emergency_cooldown, 30 SECONDS)

/obj/machinery/telecomms/allinone/public/Initialize(mapload)
	. = ..()
	freq_listening |= FREQ_NPS_RANGERS
	frequency_infos["[FREQ_NPS_RANGERS]"] = list(
		"name" = RADIO_CHANNEL_NPS_RANGERS,
		"color" = RADIO_COLOR_NPS_RANGERS
	)
