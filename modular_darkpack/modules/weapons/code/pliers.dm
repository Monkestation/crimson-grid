/obj/item/wirecutters/pliers
	name = "dental pliers"
	desc = "Meant for taking out teeth."
	icon = 'modular_darkpack/modules/weapons/icons/pliers.dmi'
	icon_state = "neat_ripper"
	lefthand_file = 'modular_darkpack/modules/weapons/icons/melee_lefthand.dmi'
	righthand_file = 'modular_darkpack/modules/weapons/icons/melee_righthand.dmi'
	inhand_icon_state = "neat_ripper"
	toolspeed = 2 //isn't meant for cutting wires
	var/permanent = FALSE // If pulling fangs lasts for the entire ROUND or not.

/obj/item/wirecutters/pliers/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	var/mob/living/carbon/human/target = astype(interacting_with)
	if(!target)
		return NONE
	if (target.is_mouth_covered())
		user.visible_message(user, span_warning("[user] can't pull out [target]'s teeth because their mouth is covered!"))
		return ITEM_INTERACT_BLOCKING
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_warning("You can't bring yourself to pull out [target]'s teeth! You don't want to harm anyone."))
		return ITEM_INTERACT_BLOCKING
	else
		user.visible_message(span_warning("[user] takes [src] straight to the [target]'s teeth!"), span_warning("You take [src] straight to the [target]'s teeth!"))
		if(!do_after(user, 3 SECONDS, target))
			return ITEM_INTERACT_BLOCKING // Prevents thwacking if you move during the do_after.
		user.do_attack_animation(target)
		target.emote("scream")
		target.apply_damage(15, BRUTE, BODY_ZONE_HEAD) // Deal brute because we're ripping teeth out right now.
		var/should_spawn_tooth = FALSE
		if (get_kindred_splat(target) && !HAS_TRAIT(target, TRAIT_DULLFANGS)) // If the target is kindred, yank their fangs out and apply a status effect. If they have dull fangs, treat them like a human.
			if(permanent) // If the pliers are permanent, apply the permanent dull fangs status effect. Otherwise, just apply the regular one.
				target.apply_status_effect(STATUS_EFFECT_DULL_FANGS_PERMANENT)
				visible_message(span_warning("[user] rips out [target]'s canines! It doesn't look like they'll be growing back anytime soon..."))
			else
				user.visible_message(span_warning("[user] rips out [target]'s canines!"), span_warning("You rip out [target]'s canines!"))
				target.apply_status_effect(STATUS_EFFECT_DULL_FANGS)
			should_spawn_tooth = TRUE
		else // If they aren't kindred/have dull fangs, just give an alternate message instead of the fang specific one.
			user.visible_message(span_warning("[user] rips out one of [target]'s teeth!"), span_warning("You rip out one of [target]'s teeth!"))
			if(!HAS_TRAIT(target, TRAIT_TOOTH_PULLED) && !HAS_TRAIT(target, TRAIT_DULLFANGS)) // Only spawn 1~ tooth per person
				should_spawn_tooth = TRUE
				ADD_TRAIT(target, TRAIT_TOOTH_PULLED, TRAIT_GENERIC)

		if(should_spawn_tooth)
			var/obj/item/tooth/pulled/tooth = new(interacting_with.loc)
			var/datum/splat/our_splat = target.get_primary_splat()
			if(our_splat?.tooth_fingerprint)
				tooth.owners_splat = our_splat.id
			user.put_in_hands(tooth)

	return ITEM_INTERACT_SUCCESS

/obj/item/wirecutters/pliers/bad
	name = "pliers"
	desc = "Meant for pulling wires but you could definitely crush something with these."
	icon_state = "ripper"
	inhand_icon_state = "ripper"
	toolspeed = 1.2 //is an actual tool but can't actually cut
	permanent = TRUE


/obj/item/tooth
	name = "tooth"
	desc = "A human tooth."
	icon_state = "tooth"
	icon = 'modular_darkpack/modules/weapons/icons/tooth.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/tooth_onfloor.dmi')
	/// Splat ID of the user whom it was pulled from (if it has a visable diffrence in teeth)
	var/owners_splat
	var/datum/storyteller_roll/tooth_investigation/examine_roll

/obj/item/tooth/pulled
	desc = "The recently pulled tooth of a poor sod."

/obj/item/tooth/pulled/examine(mob/user)
	. = ..()
	if(!examine_roll)
		examine_roll = new()
	var/roll_result = examine_roll.st_roll(user, src, using_item = src)
	if(roll_result == ROLL_SUCCESS)
		if(owners_splat)
			var/datum/splat/splat_type = GLOB.splat_list[owners_splat]
			. += span_notice("Your fairly confident its a tooth from a [splat_type::name].")
			to_chat(user, )
		else
			. += span_notice("You fairly confident its a normal human tooth.")
	else
		. += span_notice("You dont notice anything abnormal about it.")

/datum/storyteller_roll/tooth_investigation
	difficulty = 8
	applicable_stats = list(STAT_PERCEPTION, STAT_OCCULT)
	reroll_cooldown = 1 SCENES
