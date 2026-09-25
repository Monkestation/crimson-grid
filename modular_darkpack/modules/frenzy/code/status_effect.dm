/datum/client_colour/frenzy
	priority = CLIENT_COLOR_IMPORTANT_PRIORITY
	color = COLOR_LIGHT_GRAYISH_RED

/datum/status_effect/frenzy	//Generic attack frenzy
	id = "frenzy"
	duration = STATUS_EFFECT_PERMANENT
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/frenzy
	var/datum/weakref/frenzy_target_ref
	var/datum/weakref/frenzy_overlay_ref
	var/seconds_alone = 0
	var/frenzy_traits = list(TRAIT_IN_FRENZY, TRAIT_NOSOFTCRIT, TRAIT_ANALGESIA, TRAIT_CANNOT_FOCUS, TRAIT_ILLITERATE)

/datum/status_effect/frenzy/on_apply()
	owner.apply_status_effect(/datum/status_effect/grouped/see_no_names, TRAIT_STATUS_EFFECT(id))
	owner.apply_status_effect(/datum/status_effect/grouped/static_look, TRAIT_STATUS_EFFECT(id))
	owner.add_blocked_language(subtypesof(/datum/language), language_flags = UNDERSTOOD_LANGUAGE, source = id)
	owner.add_traits(frenzy_traits, TRAIT_STATUS_EFFECT(id))
	return TRUE

/datum/status_effect/frenzy/on_creation(mob/living/new_owner, atom/frenzy_target)
	. = ..()
	if(!.)
		return
	new_owner.add_client_colour(/datum/client_colour/frenzy, FRENZY_TRAIT)

	if(frenzy_target)
		frenzy_overlay_ref = WEAKREF(frenzy_target.add_alt_appearance(
			/datum/atom_hud/alternate_appearance/basic/one_person,
			"frenzy_target",
			image(icon = 'modular_darkpack/modules/frenzy/icons/frenzy_overlay.dmi', icon_state = "frenzy_overlay", loc = frenzy_target),
			null,
			new_owner,
		))
		frenzy_target_ref = WEAKREF(frenzy_target)

/datum/status_effect/frenzy/on_remove()
	var/datum/atom_hud/hud = frenzy_overlay_ref?.resolve()
	if(hud)
		qdel(hud)
	QDEL_NULL(frenzy_overlay_ref)
	owner.remove_client_colour(FRENZY_TRAIT)
	owner.remove_status_effect(/datum/status_effect/grouped/see_no_names, TRAIT_STATUS_EFFECT(id))
	owner.remove_status_effect(/datum/status_effect/grouped/static_look, TRAIT_STATUS_EFFECT(id))
	owner.remove_blocked_language(subtypesof(/datum/language), language_flags = UNDERSTOOD_LANGUAGE, source = id)
	owner.remove_traits(frenzy_traits, TRAIT_STATUS_EFFECT(id))
	var/mob/living/carbon/carbon_owner = astype(owner)
	carbon_owner?.exit_frenzy_mode()
	return ..()

/datum/status_effect/frenzy/tick(seconds_between_ticks)
	. = ..()

	// If left alone for an extended time, frenzies can end on their own
	if(locate(/mob/living/carbon/human) in oview(DEFAULT_SIGHT_DISTANCE, owner))
		seconds_alone = 0
	// If our target is nearby, keep frenzying (a human or even a fire)
	else if(frenzy_target_ref?.resolve() in view(DEFAULT_SIGHT_DISTANCE, owner))
		seconds_alone = 0
	else
		seconds_alone += seconds_between_ticks

	if(seconds_alone >= 15)
		qdel(src)

/datum/status_effect/frenzy/vampire_hunger
	id = "hunger frenzy"
	frenzy_traits = list(TRAIT_IN_FRENZY, TRAIT_NOSOFTCRIT, TRAIT_ANALGESIA, TRAIT_CANNOT_FOCUS, TRAIT_ILLITERATE, TRAIT_PERMAFANGS, TRAIT_STRONG_GRABBER)

/datum/status_effect/frenzy/flee	//Generic fleeing frenzy
	id = "fleeing frenzy"
	frenzy_traits = list(TRAIT_IN_FRENZY, TRAIT_NOSOFTCRIT, TRAIT_ANALGESIA, TRAIT_CANNOT_FOCUS, TRAIT_ILLITERATE, TRAIT_PACIFISM)

/atom/movable/screen/alert/status_effect/frenzy
	name = "Frenzy"
	desc = "FRENZY."
	icon = 'modular_darkpack/modules/deprecated/icons/hud/screen_alert.dmi'
	icon_state = "fear"

