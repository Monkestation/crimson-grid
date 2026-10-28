// "Ownership" of an object is impossible to determine so fingerpints were used instead
/datum/action/cooldown/power/gift/beat_of_the_heartdrum
	name = "Beat of the Heart-Drum"
	desc = {"The werewolf becomes an inescapable hunter, drawn ever onward by the beat of his prey's heart until that heart grows still."}
	button_icon_state = "beat_of_the_heartdrum"
	rank = 1
	gnosis_cost = 1

/datum/action/cooldown/power/gift/beat_of_the_heartdrum/Activate(atom/target)
	var/mob/living/living_owner = astype(owner)
	if(!living_owner)
		return FALSE

	/// Non-assoc list while we build a list so we dont have to filter for our own mob every time and can standerdize the name check.
	var/list/temp_valid_targets = list()
	var/list/valid_targets = list()
	// Tasted blood
	for(var/datum/weakref/blood_ref in living_owner.mobs_tasted_blood_of)
		var/mob/blood_guy = blood_ref.resolve()
		if(blood_guy)
			temp_valid_targets |= blood_guy

	var/obj/item/held_item = living_owner.get_active_held_item()
	if(held_item)
		// Ownership (fingerprints)
		var/list/prints = GET_ATOM_FINGERPRINTS(held_item)
		if(prints)
			for(var/mob/living/carbon/to_check as anything in GLOB.carbon_list)
				if(prints[md5(to_check.dna?.unique_identity)])
					temp_valid_targets |= to_check

		// Sample of the victum
		var/datum/reagent/blood/blood = held_item.reagents?.has_reagent(/datum/reagent/blood, check_subtypes = TRUE)
		var/datum/weakref/donor_ref = blood?.data["donor"]
		var/mob/living/carbon/human/blood_owner = donor_ref?.resolve()
		if(blood_owner)
			temp_valid_targets |= blood_owner
		var/mob/last_owner = held_item.get_last_inserted_owner()
		if(last_owner)
			temp_valid_targets |= last_owner

	for(var/mob/guy in temp_valid_targets)
		if(guy == living_owner)
			continue
		valid_targets[GET_GUESTBOOK_NAME(living_owner, guy)] = guy

	if(!length(valid_targets))
		to_chat(owner, span_notice("You cant think of any targets you could track at this current moment. Try holding a sample of a target or something they have touched."))
		return FALSE


	var/list/choices = list()
	for(var/name, entry in valid_targets)
		var/mob/valid_target = entry

		var/image/target_image = image(icon = valid_target.icon, icon_state = valid_target.icon_state)
		target_image.overlays = valid_target.overlays

		choices[name] = target_image

	var/tracking_name = show_radial_menu(owner, owner, choices, radius = 40, tooltips = TRUE, autopick_single_option = FALSE)

	if(!tracking_name)
		return

	. = ..()

	var/datum/storyteller_roll/gift/beat_of_the_heartdrum/roll_datum = new()
	var/roll_successes = roll_datum.st_roll(owner, target)
	if(roll_successes <= 0)
		return TRUE

	to_chat(owner, span_notice("Tracking [tracking_name]"))
	// Would normally be days but thats commical and 1 day is already the entire round.
	living_owner.apply_status_effect(/datum/status_effect/beat_of_the_heartdrum, valid_targets[tracking_name], roll_successes HOURS)


/datum/status_effect/beat_of_the_heartdrum
	id = "beat_of_the_heartdrum"
	duration = 1 SCENES
	tick_interval = 2 SECONDS
	status_type = STATUS_EFFECT_REPLACE

	alert_type = /atom/movable/screen/alert/status_effect/gift/beat_of_the_heartdrum
	var/datum/weakref/hunting_ref

/datum/status_effect/beat_of_the_heartdrum/on_creation(mob/living/new_owner, mob/living/target, duration = 1 SCENES)
	src.duration = duration
	hunting_ref = WEAKREF(target)
	. = ..()

/datum/status_effect/beat_of_the_heartdrum/tick(seconds_between_ticks)
	if(!owner.client)
		return

	var/mob/living/target = hunting_ref.resolve()
	if(!target?.heart_is_beating())
		return

	var/dist = get_dist_euclidean(owner, target) || 0
	var/dist_modifier = clamp(dist * 2 - world.maxx / world.maxx, 0.1, 1)
	var/sound_volume = 100 * dist_modifier
	SEND_SOUND(owner, sound('sound/effects/singlebeat.ogg', volume = sound_volume))

	var/turf/current_turf = get_step_towards(owner, target)
	var/image/blip_image = image(icon = 'icons/effects/effects.dmi', icon_state = "blip", layer = HIGH_PIPE_LAYER, loc = current_turf)
	SET_PLANE(blip_image, GAME_PLANE, current_turf)
	blip_image.alpha = 255 * dist_modifier

	current_turf.flick_overlay(blip_image, list(owner.client), 0.6 SECONDS)


/atom/movable/screen/alert/status_effect/gift/beat_of_the_heartdrum
	name = /datum/action/cooldown/power/gift/beat_of_the_heartdrum::name
	desc = /datum/action/cooldown/power/gift/beat_of_the_heartdrum::desc
	overlay_state = /datum/action/cooldown/power/gift/beat_of_the_heartdrum::button_icon_state
	clickable_glow = TRUE

/atom/movable/screen/alert/status_effect/gift/beat_of_the_heartdrum/Click(location, control, params)
	. = ..()
	to_chat(owner, span_notice("You dispel [name]."))
	qdel(attached_effect)

/datum/storyteller_roll/gift/beat_of_the_heartdrum
	bumper_text = "Beat of the Heart-Drum"
	applicable_stats = list(STAT_PERCEPTION, STAT_SURVIVAL)
	difficulty = 7
	numerical = TRUE


/// Returns the last mob we would be considered a "sample" off.
/obj/item/proc/get_last_inserted_owner()
	return

/obj/item/organ/get_last_inserted_owner()
	return last_owner?.resolve()

/obj/item/bodypart/get_last_inserted_owner()
	return last_owner?.resolve()
