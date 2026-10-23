/**
 * Thaumaturgical Sense
 *
 * Combined discipline of Auspex 2 and Thaumaturgy 1
 * But since we don't have any system for combined disciplines implemented
 * We have it as a merit (temporarily)
 *
 */
/datum/quirk/darkpack/thaumaturgical_sense
	name = "Thaumaturgical Sight"
	desc = "Combined discipline of Auspex and Thaumaturgy, this allows the user can see magical auras, \
		similar to how one would with Aura Perception. \
		Information you gain about the subject depends on the amount of successes. \
		You must have at least two dots in Auspex and one dot in Thaumaturgy to use it."
	value = 2
	ttrpg_sources = list(/datum/source_book/vtm20/lotc = 220)
	icon = FA_ICON_EYE
	allowed_splats = list(SPLAT_KINDRED)
	included_clans = list(VAMPIRE_CLAN_TREMERE)
	quirk_flags = QUIRK_HIDE_FROM_SCAN

/datum/quirk/darkpack/thaumaturgical_sense/add_to_holder(mob/living/new_holder, quirk_transfer = FALSE, client/client_source, unique = TRUE, announce = TRUE)
	var/thaum_dots = new_holder?.get_discipline_dots(/datum/discipline/thaumaturgy)
	var/auspex_dots = new_holder?.get_discipline_dots(/datum/discipline/auspex)
	if(thaum_dots < 1 || auspex_dots < 2)
		to_chat(new_holder, span_warning("[failure_message]"))
		return FALSE
	return ..()

/datum/quirk/darkpack/thaumaturgical_sense/add(client/client_source)
	var/datum/action/cooldown/thaumaturgical_sense/action = new()
	action.Grant(quirk_holder)

/datum/storyteller_roll/thaumaturgical_sense
	difficulty = 8
	applicable_stats = list(STAT_PERCEPTION, STAT_OCCULT)
	numerical = TRUE
	roll_output_type = ROLL_FLAG_ROLLER

/datum/action/cooldown/thaumaturgical_sense
	name = "Thaumaturgical Sight"
	desc = "With this ability, the user can see magical auras, similar to how one would with Aura Perception.\
		Kindred stained with blood magic or magical artifacts will be highlighted."
	button_icon = 'modular_darkpack/modules/powers/icons/actions.dmi'
	button_icon_state = "thaumaturgy"
	background_icon = 'modular_darkpack/master_files/icons/mob/actions/backgrounds.dmi'
	background_icon_state = "bg_default"
	overlay_icon_state = null
	cooldown_time = 8 SECONDS

	/// List of all images currently on our screen
	var/list/all_images = list()
	/// Range of our sense
	var/sense_range = 10

	/// List of things related to thaumaturgy (also count in things like artifacts)
	var/static/list/thaumaturgy_items = typecacheof(list(
		/obj/ritual_rune/thaumaturgy,
		/obj/item/occult_artifact/vampire,
		/obj/item/thaumaturgy_scroll,
		/obj/item/blood_hunt,
		/obj/item/path_spellbook,
		/obj/item/ritual_tome/arcane,
		/obj/item/occult_book,
	))

/datum/action/cooldown/thaumaturgical_sense/Activate(atom/target)
	. = ..()
	var/roll_result = SSroll.storyteller_roll_datum(owner, roll_datum = /datum/storyteller_roll/thaumaturgical_sense)
	owner.emote("stare")
	if(roll_result < 1)
		to_chat(owner, span_warning("You fail to detect any magic in the area!"))
		return
	do_pulse(roll_result)

/// Checks for atoms in range and checks if they are magical
/datum/action/cooldown/thaumaturgical_sense/proc/do_pulse(success_count)
	for(var/atom/checked_atom in orange(sense_range, get_turf(owner)))
		if(!isobj(checked_atom) && !isliving(checked_atom))
			continue
		find_magic_source(checked_atom, success_count)

/// Determines if item is magical on its own, is stored inside contents of an atom, or if living mob has a magical discipline
/datum/action/cooldown/thaumaturgical_sense/proc/find_magic_source(atom/target, success_count)
	if(determine_magic_item(target))
		return

	// Check if our contents have items
	for(var/thing as anything in target.get_all_contents())
		if(determine_magic_item(thing, target))
			break
		continue

	if(!isliving(target))
		return

	handle_living(target, success_count)

	return

/// Handles checking for magic disciplines and comparing paths at higher success counts
/datum/action/cooldown/thaumaturgical_sense/proc/handle_living(mob/living/target, success_count)
	// Don't bother if they have no thaum at all
	if(!target.get_discipline(/datum/discipline/thaumaturgy))
		return

	// We won't be able to precisely tell what magic they know if we have less than 3 successes
	// Only sense it's presense
	if(success_count < 3)
		show_image(target)
		return

	var/datum/splat/vampire/kindred/vampire = get_kindred_splat(owner)
	var/datum/splat/vampire/kindred/vampire_target = get_kindred_splat(target)
	if(!vampire || !vampire_target)
		return

	var/list/our_known_paths = list()
	// Store all paths we currently know to compare them
	for(var/datum/action/discipline/disc_action as anything in vampire.powers)
		var/datum/discipline/discipline = disc_action.discipline
		if(!istype(discipline, /datum/discipline/thaumaturgy) && !istype(discipline, /datum/discipline/path))
			continue
		our_known_paths += discipline.type

	for(var/datum/action/discipline/their_disc_action as anything in vampire_target.powers)
		var/datum/discipline/their_discipline = their_disc_action.discipline
		if(!istype(their_discipline, /datum/discipline/thaumaturgy) && !istype(their_discipline, /datum/discipline/path))
			continue
		if(!(their_discipline.type in our_known_paths))
			// If we have five or more successes we can recognize the path without knowing it
			if(success_count < 5)
				to_chat(owner, span_cult("[target] seems to know path you can't recognize!"))
				continue

		to_chat(owner, span_cult("[target] seems to know [their_discipline.name]!"))

	show_image(target)

/// Checks if item is in the typecache of magical items or is enchanted by a ritual, passes a color depending on the source of magic stain
/datum/action/cooldown/thaumaturgical_sense/proc/determine_magic_item(atom/target, atom/object_owner)
	// The checks could probably be done better but it works for now
	// It's possible we can use get_magic_sources() instead, but a lot of items checked lack the effect
	if(is_type_in_typecache(target, thaumaturgy_items))
		return show_image(target, object_owner)

	// Check for enchantments too
	var/datum/component/thaum_enchantment = target.GetComponent(/datum/component/blood_theft) || target.GetComponent(/datum/component/burning_blade)
	if(thaum_enchantment)
		return show_image(target, object_owner)

	return FALSE

/// Makes client actually see the image and animates it to pulse
/datum/action/cooldown/thaumaturgical_sense/proc/show_image(atom/input, atom/object_owner)
	if(!owner.client)
		return
	var/image/final_image = generate_image(input, object_owner)
	owner.client.images += final_image
	all_images += final_image
	animate(final_image, alpha = 255, time = 0.5 SECONDS)
	animate(alpha = 0, time = 2.5 SECONDS)

	addtimer(CALLBACK(src, PROC_REF(delete_images)), 3 SECONDS)

	return TRUE

/// Remove images from client and list of our images
/datum/action/cooldown/thaumaturgical_sense/proc/delete_images()
	if(!isliving(owner))
		return
	var/mob/living/living_owner = owner
	for(var/our_image as anything in all_images)
		living_owner.client?.images -= our_image
		all_images -= our_image
		qdel(our_image)

/// Actually generate our image
/datum/action/cooldown/thaumaturgical_sense/proc/generate_image(atom/input, atom/object_owner)
	var/image/final_image = new
	final_image.layer += ABOVE_MOB_LAYER
	final_image.plane = ABOVE_LIGHTING_PLANE
	final_image.loc = object_owner ? object_owner : input
	final_image.alpha = 0
	final_image.appearance_flags |= RESET_COLOR|KEEP_APART
	if(ishuman(input) && !object_owner)
		var/mutable_appearance/magic_image = mutable_appearance('modular_darkpack/modules/powers/icons/auras.dmi', "old_aura", ABOVE_MOB_LAYER + 1, owner, ABOVE_LIGHTING_PLANE)
		magic_image.color = COLOR_RED
		final_image.add_overlay(magic_image)
	else
		final_image.add_filter(name = "magic_rays", priority = 1, params = list(
			type = "rays",
			size = 15,
			color = COLOR_RED,
		))

	final_image.add_filter("magic_glow", 1, gauss_blur_filter(1))

	return final_image
