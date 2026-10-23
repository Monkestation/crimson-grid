/datum/quirk/darkpack/thaumaturgical_sense
	name = "Thaumaturgical Sense"
	desc = "todo"
	value = 2
	icon = FA_ICON_EYE
	allowed_splats = list(SPLAT_KINDRED)
	included_clans = list(VAMPIRE_CLAN_TREMERE)
	quirk_flags = QUIRK_HIDE_FROM_SCAN

/datum/quirk/darkpack/thaumaturgical_sense/add_to_holder(mob/living/new_holder, quirk_transfer = FALSE, client/client_source, unique = TRUE, announce = TRUE)
	var/thaum_dots = new_holder.get_discipline_dots(/datum/discipline/thaumaturgy)
	var/auspex_dots = new_holder.get_discipline_dots(/datum/discipline/auspex)
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

/datum/action/cooldown/thaumaturgical_sense
	name = "Thaumaturgical Sense"
	button_icon = 'modular_darkpack/modules/powers/icons/actions.dmi'
	button_icon_state = "thaumaturgy"
	background_icon = 'modular_darkpack/master_files/icons/mob/actions/backgrounds.dmi'
	background_icon_state = "bg_discipline"
	overlay_icon_state = null
	cooldown_time = 8 SECONDS

	/// List of all images currently on our screen
	var/list/all_images = list()
	var/sense_range = 10

	/// List of things related to thaumaturgy (also count in things like artifacts)
	var/static/list/thaumaturgy_items = typecacheof(list(
		/obj/ritual_rune/thaumaturgy,
		/obj/item/occult_artifact/vampire,
		/obj/item/thaumaturgy_scroll,
		/obj/item/blood_hunt,
		/obj/item/path_spellbook,
		/obj/item/ritual_tome/arcane,
	))

/datum/action/cooldown/thaumaturgical_sense/Activate(atom/target)
	. = ..()
	var/roll_result = SSroll.storyteller_roll_datum(owner, roll_datum = /datum/storyteller_roll/thaumaturgical_sense, numerical = TRUE)
	var/precise = FALSE
	if(roll_result < 1)
		return
	if(roll_result >= 3)
		precise = TRUE
	do_pulse(precise)
	owner.emote("stare")

/// Checks for atoms in range and checks if they are magical
/datum/action/cooldown/thaumaturgical_sense/proc/do_pulse(precise)
	for(var/atom/checked_atom in orange(sense_range, get_turf(owner)))
		if(!isobj(checked_atom) && !isliving(checked_atom))
			continue
		find_magic_source(checked_atom, precise)

/// Determines if item is magical on its own, is stored inside contents of an atom, or if living mob has a magical discipline
/datum/action/cooldown/thaumaturgical_sense/proc/find_magic_source(atom/target, precise)
	if(determine_magic_item(target))
		return

	// Check if our contents have items
	for(var/thing as anything in target.contents)
		if(determine_magic_item(thing, target))
			break
		continue

	if(!isliving(target))
		return

	handle_living(target, precise)

	return

/datum/action/cooldown/thaumaturgical_sense/proc/handle_living(mob/living/target, precise)
	if(!target.get_discipline(/datum/discipline/thaumaturgy))
		return

	if(precise)
		to_chat(owner, span_cult("[target] has stains of Thaumaturgy!"))

	show_image(target)

/// Checks if item is in the typecache of magical items or is enchanted by a ritual, passes a color depending on the source of magic stain
/datum/action/cooldown/thaumaturgical_sense/proc/determine_magic_item(atom/target, atom/object_owner)
	// The checks could probably be done better but it works for now
	// It's possible we can use get_magic_sources() instead, but a lot of items checked lack the effect
	if(is_type_in_typecache(target, thaumaturgy_items))
		return show_image(target, object_owner)
	else
		// Check for enchantments too
		var/datum/component/thaum_enchantment = GetComponent(/datum/component/blood_theft) || GetComponent(/datum/component/burning_blade)
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
		var/mutable_appearance/diablerie_image = mutable_appearance('modular_darkpack/modules/powers/icons/auras.dmi', "old_aura", ABOVE_MOB_LAYER + 1, owner, ABOVE_LIGHTING_PLANE)
		diablerie_image.color = COLOR_RED
		final_image.add_overlay(diablerie_image)
	else
		final_image.add_filter(name = "ray", priority = 1, params = list(
			type = "rays",
			size = 15,
			color = COLOR_RED,
		))

	final_image.add_filter("aura_glow", 1, gauss_blur_filter(1))

	return final_image
