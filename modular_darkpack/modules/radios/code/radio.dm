// Base radio type we use for our custom behaviors.
/obj/item/radio/headset/darkpack
	name = "\improper P25 radio"
	desc = "A portable radio headset operating on the P25 digital standard."
	icon = 'modular_darkpack/modules/radios/icons/radio.dmi'
	icon_state = "p25"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/radios/icons/onfloor.dmi')
	freqlock = RADIO_FREQENCY_LOCKED

// Military Radio
/obj/item/radio/headset/darkpack/military
	name = "military radio"
	radio_network = NETWORK_MILITARY

/obj/item/radio/headset/darkpack/military/Initialize(mapload)
	. = ..()
	set_frequency(FREQ_MILITARY)
	radio_id = rand(1, 999) // Since we wont have a tranceiver for these, we're just auto-assigning a random ID. This isn't foolproof.

/obj/item/radio/headset/darkpack/pmc
	name = "military radio"
	radio_network = NETWORK_ENDRON

/obj/item/radio/headset/darkpack/pmc/Initialize(mapload)
	. = ..()
	set_frequency(FREQ_ENDRON)
	AddElement(/datum/element/earhealing)
	AddComponent(/datum/component/wearertargeting/earprotection) //Allows for explosive fuckups to not fuck up communication
	radio_id = rand(1, 999) // Since we wont have a tranceiver for these, we're just auto-assigning a random ID. This isn't foolproof.

// Police Radio get a special button to call for backup.
/obj/item/radio/headset/darkpack/police
	name = "police radio"
	icon_state = "pp25"
	COOLDOWN_DECLARE(emergency_cooldown)

/obj/item/radio/headset/darkpack/police/examine(mob/user)
	. = ..()
	var/turf/current_turf = get_turf(src)
	. += span_info("GPS Location: " + english_list(list(current_turf.x, current_turf.y, current_turf.z), and_text = ", "))
	. += span_notice("It has a red button on the side to call for backup. It can be activated with [EXAMINE_HINT("Ctrl-Shift-Click")].")

/obj/item/radio/headset/darkpack/police/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = NONE
	if(isnull(held_item))
		context[SCREENTIP_CONTEXT_CTRL_SHIFT_LMB] = "Activate Emergency Backup Call"
		return CONTEXTUAL_SCREENTIP_SET

/obj/item/radio/headset/darkpack/police/click_ctrl_shift(mob/user)
	var/confirmation_popup = tgui_alert(user, "Are you sure you want to send an emergency backup call?", "Emergency Backup Call", list("Cancel", "Confirm"))
	if(confirmation_popup != "Confirm")
		return
	if(!COOLDOWN_FINISHED(src, emergency_cooldown))
		balloon_alert(user, "busy!")
		return
	if(radio_network != NETWORK_POLICE)
		balloon_alert(user, "unconnected!")
		return
	user.balloon_alert_to_viewers("beep!", "activated!")
	SEND_SIGNAL(SSdcs, COMSIG_GLOB_REPORT_CRIME, CRIME_EMERGENCY, get_turf(src))
	COOLDOWN_START(src, emergency_cooldown, 30 SECONDS)
