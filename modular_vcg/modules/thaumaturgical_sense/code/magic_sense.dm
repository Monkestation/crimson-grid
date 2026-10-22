/datum/action/cooldown/thaumaturgical_sense
	name = "Thaumaturgical Sense"
	button_icon = 'modular_darkpack/modules/powers/icons/actions.dmi'
	button_icon_state = "thaumaturgy"
	background_icon = 'modular_darkpack/master_files/icons/mob/actions/backgrounds.dmi'
	background_icon_state = "bg_discipline"
	overlay_icon_state = null
	cooldown_time = 8 SECONDS

	var/list/all_images = list()
	var/sense_range = 10

	var/static/list/thaumaturgy_items = typecacheof(list(
		/obj/ritual_rune/thaumaturgy,
		/obj/item/occult_artifact/vampire,
		/obj/item/thaumaturgy_scroll,
		/obj/item/blood_hunt,
		/obj/item/path_spellbook,
		/obj/item/ritual_tome/arcane,
	))
	var/static/list/necromancy_items = typecacheof(list(
		/obj/ritual_rune/necromancy,
		/obj/item/ritual_tome/necromancy,
	))

/datum/action/cooldown/thaumaturgical_sense/Activate(atom/target)
	. = ..()
	do_pulse()
	owner.emote("stare")

/datum/action/cooldown/thaumaturgical_sense/proc/do_pulse()
	for(var/atom/checked_atom in orange(sense_range, get_turf(owner)))
		if(!isobj(checked_atom) && !isliving(checked_atom))
			continue
		find_magic_source(checked_atom)

/datum/action/cooldown/thaumaturgical_sense/proc/find_magic_source(atom/target)
	if(determine_magic_item(target))
		return

	// Check if our contents have items
	for(var/thing as anything in target.contents)
		if(determine_magic_item(thing, target))
			break
		continue

	if(!isliving(target))
		return FALSE

	var/mob/living/living_target = target
	// Thaum takes priority
	if(living_target.get_discipline(/datum/discipline/thaumaturgy))
		return show_image(target, COLOR_RED)
	else if(living_target.get_discipline(/datum/discipline/necromancy))
		return show_image(target, COLOR_GREEN)

	return FALSE

/datum/action/cooldown/thaumaturgical_sense/proc/determine_magic_item(atom/target, atom/object_owner)
	// The checks could probably be done better but it works for now
	// Could be flag on the objects maybe?
	if(is_type_in_typecache(target, thaumaturgy_items))
		return show_image(target, COLOR_RED, object_owner)
	else if(is_type_in_typecache(target, necromancy_items))
		return show_image(target, COLOR_GREEN, object_owner)
	else
		// Check for enchantments too
		var/datum/component/thaum_enchantment = GetComponent(/datum/component/blood_theft) || GetComponent(/datum/component/burning_blade)
		if(thaum_enchantment)
			return show_image(target, COLOR_RED, object_owner)

	return FALSE

/datum/action/cooldown/thaumaturgical_sense/proc/show_image(atom/input, color, atom/object_owner)
	if(!owner.client)
		return
	var/image/final_image = generate_image(input, color, object_owner)
	owner.client.images += final_image
	all_images += final_image
	animate(final_image, alpha = 255, time = 0.5 SECONDS, loop = -1)
	animate(alpha = 0, time = 2.5 SECONDS)

	addtimer(CALLBACK(src, PROC_REF(delete_images)), 3 SECONDS)

	return TRUE

/datum/action/cooldown/thaumaturgical_sense/proc/delete_images()
	if(!isliving(owner))
		return
	var/mob/living/living_owner = owner
	for(var/our_image as anything in all_images)
		living_owner.client?.images -= our_image
		all_images -= our_image
		qdel(our_image)

/datum/action/cooldown/thaumaturgical_sense/proc/generate_image(atom/input, magic_color, atom/object_owner)
	var/image/final_image = new
	final_image.layer += ABOVE_MOB_LAYER
	final_image.plane = ABOVE_LIGHTING_PLANE
	final_image.loc = object_owner ? object_owner : input
	final_image.alpha = 0
	final_image.appearance_flags |= RESET_COLOR|KEEP_APART
	if(ishuman(input) && !object_owner)
		var/mutable_appearance/diablerie_image = mutable_appearance('modular_darkpack/modules/powers/icons/auras.dmi', "old_aura", ABOVE_MOB_LAYER + 1, owner, ABOVE_LIGHTING_PLANE)
		diablerie_image.color = magic_color
		final_image.add_overlay(diablerie_image)
	else
		final_image.add_filter(name = "ray", priority = 1, params = list(
			type = "rays",
			size = 15,
			color = magic_color,
		))

	final_image.add_filter("aura_glow", 1, gauss_blur_filter(1))

	return final_image
