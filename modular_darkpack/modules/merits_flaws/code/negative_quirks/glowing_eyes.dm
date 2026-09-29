// VTM pg. 482
/datum/quirk/darkpack/glowing_eyes
	name = "Glowing Eyes"
	desc = {"You have the stereotypical glowing eyes of vampire legend, giving you a -1 difficulty when intimidating mortals.
		However, you MUST constantly disguise your condition, and the glow impairs your vision."}
	ttrpg_sources = list(/datum/source_book/vtm20 = 482)
	icon = FA_ICON_EYE
	value = -3
	gain_text = span_notice("Your eyes glow with an unnatural light!")
	lose_text = span_notice("The light in your eyes fades.")
	failure_message = span_notice("The light in your eyes fades.")
	mob_trait = TRAIT_GLOWING_EYES
	allowed_splats = list(SPLAT_KINDRED)
	excluded_clans = list(VAMPIRE_CLAN_KIASYD)// They already have masq violating eyes!
	quirk_flags = QUIRK_HIDE_FROM_SCAN //CRIMSON GRID EDIT ADD | PR: MAKE MEDICAL RECORDS NOT MASQ BREACHY | CHANGE: ADDED THIS TO PREVENT IT FROM BEING SEEN IN COMS
	/// Determines whether eyes glow outright or reflect light in the dark.
	var/is_reflective = FALSE

/*You have the stereotypical glowing eyes of vampire
legend, which gives you a -1 difficulty on Intimidation
rolls when you’re dealing with mortals. However, the
tradeoffs are many; you must constantly disguise your
condition (no, contacts don’t cut it); the glow impairs
your vision and puts you at +1 difficulty on all sight
based rolls (including the use of ranged weapons); and
the radiance emanating from your eye sockets makes
it difficult to hide (+2 difficulty to Stealth rolls) in the
dark.*/

/datum/quirk/darkpack/glowing_eyes/add(client/client_source)
	. = ..()
	var/mob/living/carbon/human/human_holder = astype(quirk_holder)
	if(!human_holder)
		return
	ADD_TRAIT(quirk_holder, TRAIT_LUMINESCENT_EYES, QUIRK_TRAIT)

	if(!is_reflective) // If we're using the vampire version
		human_holder.st_add_stat_mod(STAT_PERCEPTION, -1, "Glowing Eyes") // I guess this works. what would count as a sight-based roll is beyond me rn
		ADD_TRAIT(quirk_holder, TRAIT_MASQUERADE_VIOLATING_EYES, QUIRK_TRAIT)
	else // If we're not
		var/obj/item/organ/eyes/eyes_organ = human_holder.get_organ_slot(ORGAN_SLOT_EYES)
		eyes_organ?.flash_protect = max(eyes_organ?.flash_protect-1, FLASH_PROTECTION_HYPER_SENSITIVE)

	var/obj/item/clothing/glasses/vampire/sun/new_glasses = new(human_holder.loc) // Give them glasses so they aren't immediately breaching on spawn or anything
	human_holder.equip_to_appropriate_slot(new_glasses, TRUE)

/datum/quirk/darkpack/glowing_eyes/remove()
	. = ..()
	var/mob/living/carbon/human/human_holder = astype(quirk_holder)
	if(!human_holder)
		return
	REMOVE_TRAIT(quirk_holder, TRAIT_LUMINESCENT_EYES, QUIRK_TRAIT)

	if(!is_reflective) // If we're using the vampire version
		human_holder.st_remove_stat_mod(STAT_PERCEPTION, "Glowing Eyes")
		REMOVE_TRAIT(quirk_holder, TRAIT_MASQUERADE_VIOLATING_EYES, QUIRK_TRAIT)
	else // If we're not
		var/obj/item/organ/eyes/eyes_organ = human_holder.get_organ_slot(ORGAN_SLOT_EYES)
		eyes_organ?.flash_protect = min(eyes_organ?.flash_protect+1, FLASH_PROTECTION_WELDER_HYPER_SENSITIVE)
		quirk_holder.remove_status_effect(/datum/status_effect/glowing_eyes_warning)
		quirk_holder.remove_status_effect(/datum/status_effect/glowing_eyes_full)

/datum/quirk/darkpack/glowing_eyes/reflective // subtyped for organization
	name = "Reflective Eyes"
	desc = {"Your eyes reflect light in darkness. Whether you have a tapetum lucidum, exotic contact lenses, or some other condition, you'll frighten those you encounter in the dark.
		This may even violate the laws your kind set to stay unknown if you are seen in the dark."}
	value = -1
	gain_text = span_notice("Your eyes reflect the light around you.")
	lose_text = span_notice("The light in your eyes fades.")
	failure_message = span_notice("Your eyes glint for a moment, then fade.")
	quirk_flags = QUIRK_PROCESSES
	mob_trait = null
	allowed_splats = null
	forbidden_splats = list(SPLAT_KINDRED)
	is_reflective = TRUE

/datum/quirk/darkpack/glowing_eyes/reflective/add(client/client_source)
	. = ..()
	RegisterSignal(quirk_holder, COMSIG_MOVABLE_MOVED, PROC_REF(on_holder_moved))

/datum/quirk/darkpack/glowing_eyes/reflective/remove()
	. = ..()
	UnregisterSignal(quirk_holder, COMSIG_MOVABLE_MOVED)

/datum/quirk/darkpack/glowing_eyes/reflective/process(seconds_per_tick)
	eye_light_status()

/datum/quirk/darkpack/glowing_eyes/reflective/proc/on_holder_moved(mob/living/source, atom/old_loc, dir, forced, list/old_locs)
	SIGNAL_HANDLER
	eye_light_status()

/datum/quirk/darkpack/glowing_eyes/reflective/proc/eye_light_status()
	if(quirk_holder.IsSleeping() || quirk_holder.IsUnconscious() || quirk_holder.is_eyes_covered())
		quirk_holder.remove_status_effect(/datum/status_effect/glowing_eyes_warning)
		quirk_holder.remove_status_effect(/datum/status_effect/glowing_eyes_full)
		return

	var/turf/holder_turf = get_turf(quirk_holder)
	var/light_amount = round(holder_turf.get_lumcount(), 0.01)
	switch(light_amount)
		if(0 to 0.2)
			quirk_holder.apply_status_effect(/datum/status_effect/glowing_eyes_full)
			if(quirk_holder.has_status_effect(/datum/status_effect/glowing_eyes_warning))
				quirk_holder.remove_status_effect(/datum/status_effect/glowing_eyes_warning)
		if(0.21 to 0.53)
			quirk_holder.apply_status_effect(/datum/status_effect/glowing_eyes_warning)
			if(quirk_holder.has_status_effect(/datum/status_effect/glowing_eyes_full))
				quirk_holder.remove_status_effect(/datum/status_effect/glowing_eyes_full)
		if(0.54 to 1)
			quirk_holder.remove_status_effect(/datum/status_effect/glowing_eyes_warning)
			quirk_holder.remove_status_effect(/datum/status_effect/glowing_eyes_full)

/datum/status_effect/glowing_eyes_warning
	id = "glowing_eyes_warning"
	status_type = STATUS_EFFECT_UNIQUE
	duration = STATUS_EFFECT_PERMANENT
	tick_interval = 3 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/glowing_eyes_warning

/datum/status_effect/glowing_eyes_warning/on_creation(mob/living/new_owner, ...)
	. = ..()
	linked_alert?.update_appearance(UPDATE_OVERLAYS)

/atom/movable/screen/alert/status_effect/glowing_eyes_warning
	name = "Strange Eyes"
	desc = "Your unnatural eyes are starting to catch the light. Find somewhere brighter or cover them before a someone notices."
	icon = 'modular_darkpack/modules/deprecated/icons/hud/screen_alert.dmi'
	icon_state = "template"

/atom/movable/screen/alert/status_effect/glowing_eyes_warning/update_overlays()
	. = ..()
	var/mutable_appearance/glow = mutable_appearance('icons/mob/human/human_eyes.dmi', "eyes_glow_gs")
	var/mob/living/carbon/human/human_owner = astype(owner)
	var/obj/item/organ/eyes/eyes_organ = human_owner.get_organ_slot(ORGAN_SLOT_EYES)
	glow.color = eyes_organ?.eye_color_left || COLOR_WHITE // could be more robust *shrug
	glow.transform = matrix() * 2
	glow.pixel_y = -16
	. += glow

/datum/status_effect/glowing_eyes_full
	id = "glowing_eyes_full"
	status_type = STATUS_EFFECT_UNIQUE
	duration = STATUS_EFFECT_PERMANENT
	tick_interval = 3 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/glowing_eyes_full

/datum/status_effect/glowing_eyes_full/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_MASQUERADE_VIOLATING_EYES, QUIRK_TRAIT)

/datum/status_effect/glowing_eyes_full/on_creation(mob/living/new_owner, ...)
	. = ..()
	linked_alert?.update_appearance(UPDATE_OVERLAYS)

/atom/movable/screen/alert/status_effect/glowing_eyes_full
	name = "Strange Eyes"
	desc = "Your unnatural eyes are catching the light intensely now. Find somewhere brighter or cover them before a someone notices."
	icon = 'modular_darkpack/modules/deprecated/icons/hud/screen_alert.dmi'
	icon_state = "template"

/atom/movable/screen/alert/status_effect/glowing_eyes_full/update_overlays()
	. = ..()
	var/mutable_appearance/glow = mutable_appearance('icons/mob/human/human_eyes.dmi', "eyes_mothglow_gs")
	var/mob/living/carbon/human/human_owner = astype(owner)
	var/obj/item/organ/eyes/eyes_organ = human_owner.get_organ_slot(ORGAN_SLOT_EYES)
	glow.color = eyes_organ?.eye_color_left || COLOR_WHITE // could be more robust *shrug
	glow.transform = matrix() * 2
	glow.pixel_y = -16
	. += glow
