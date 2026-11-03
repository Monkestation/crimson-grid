/obj/ritual_rune/abyss/pierce_the_veil
	name = "pierce the veil"
	desc = "Through the use of this ritual and by creating orbs of shadow in your hand and staring into them, your eyes turn a deep, abyssal black, giving you Darksight."
	icon_state = "rune9"
	word = "Shadow encase my sight."
	cost = 1
	level = 1
	var/datum/action/innate/darkvision/darkvision_action

/obj/ritual_rune/abyss/pierce_the_veil/complete()
	. = ..()
	var/mob/living/carbon/human/H = last_activator
	to_chat(H, span_notice("Darkness floods your vision, then recedes - the ritual was a success."))
	darkvision_action = new(H)
	darkvision_action.Grant(H)
	qdel(src)

/datum/action/innate/darkvision
	name = "Darkvision"
	desc = "Turns your eyes a deep, abyssal black, granting you the ability to see in darkness."
	button_icon = 'modular_darkpack/modules/ritual_abyss_mysticism/icons/pierce_the_veil.dmi'
	button_icon_state = "darkvision_off"

/datum/action/innate/darkvision/Activate()
	var/mob/living/carbon/human/H = owner
	var/obj/item/organ/eyes/owners_eyes = H.get_organ_by_type(/obj/item/organ/eyes)
	ADD_TRAIT(H, TRAIT_TRUE_NIGHT_VISION, type)
	ADD_TRAIT(H, TRAIT_MASQUERADE_VIOLATING_EYES, type)
	ADD_TRAIT(H, TRAIT_ABYSSAL_EYES, type)
	owners_eyes?.refresh()
	H.add_eye_color(COLOR_BLACK, EYE_COLOR_DISC)
	active = TRUE
	button_icon_state = "darkvision_on"
	build_all_button_icons(force = TRUE)

/datum/action/innate/darkvision/Deactivate()
	var/mob/living/carbon/human/H = owner
	var/obj/item/organ/eyes/owners_eyes = H.get_organ_by_type(/obj/item/organ/eyes)
	REMOVE_TRAIT(H, TRAIT_TRUE_NIGHT_VISION, type)
	REMOVE_TRAIT(H, TRAIT_MASQUERADE_VIOLATING_EYES, type)
	REMOVE_TRAIT(H, TRAIT_ABYSSAL_EYES, type)
	owners_eyes?.refresh()
	H.remove_eye_color(EYE_COLOR_DISC)
	active = FALSE
	button_icon_state = "darkvision_off"
	build_all_button_icons(force = TRUE)

/obj/ritual_rune/abyss/pierce_the_veil/ritual_failure()
	. = ..()
	to_chat(last_activator, span_warning("The shadows slip through your fingers..."))
	qdel(src)

/obj/ritual_rune/abyss/pierce_the_veil/ritual_botch()
	. = ..()
	var/mob/living/carbon/human/H = last_activator
	var/obj/item/organ/eyes/owners_eyes = H.get_organ_by_type(/obj/item/organ/eyes)
	ADD_TRAIT(H, TRAIT_TRUE_NIGHT_VISION, "pierce_the_veil_botch")
	ADD_TRAIT(H, TRAIT_MASQUERADE_VIOLATING_EYES, "pierce_the_veil_botch")
	ADD_TRAIT(H, TRAIT_ABYSSAL_EYES, "pierce_the_veil_botch")
	owners_eyes?.refresh()
	H.add_eye_color(COLOR_BLACK, EYE_COLOR_DISC)
	to_chat(H, span_userdanger("The ritual backfires! Your eyes become inky black pits of shadow, and your vision cuts through the darkness."))
	qdel(src)
