/obj/ritual_rune/dark/curse_of_oedipus
	name = "curse of oedipus"
	desc = "Completely blinds your target"
	icon_state = "rune6"
	word = "OED'IPI"
	level = 1
	sacrifices = list(/obj/item/flashlight/flare/candle) // There's no incense

/obj/ritual_rune/dark/curse_of_oedipus/complete()
	. = ..()
	if(ishuman(usr))
		var/mob/living/carbon/human/user = usr
		var/target_name = tgui_input_text(user, "Choose target name:", "Curse Rune")
		if(!target_name || !user.Adjacent(src)) // Check if user is still nearby
			to_chat(user, span_warning("You must specify a target and remain close to the rune!"))
			return
		for(var/mob/living/carbon/human/human_target in GLOB.player_list)
			if(human_target.real_name == target_name)
				var/duration = (5 - human_target.st_get_stat(STAT_STAMINA)) SCENES
				if(duration <= 0)
					log_combat(last_activator, human_target, "Failed Curse of Oedipus")
					to_chat(user, span_warning("The target is too strong, the rite fails to take hold."))
					qdel(src)
					return
				human_target.apply_status_effect(/datum/status_effect/curse_of_oedipus, duration)
				log_combat(last_activator, human_target, "Curse of Oedipus")
				playsound(human_target.loc, 'modular_darkpack/modules/powers/sounds/thaum.ogg', 50, FALSE)
		to_chat(user, span_warning("There's no such target, the rite fails to take hold."))
		qdel(src)
