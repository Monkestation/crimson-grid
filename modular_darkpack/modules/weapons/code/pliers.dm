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
	if(!istype(interacting_with, /mob/living/carbon/human))
		return NONE
	var/mob/living/carbon/human/target = interacting_with
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
		if (get_kindred_splat(target) && !HAS_TRAIT(target, TRAIT_DULLFANGS)) // If the target is kindred, yank their fangs out and apply a status effect. If they have dull fangs, treat them like a human.
			if(permanent) // If the pliers are permanent, apply the permanent dull fangs status effect. Otherwise, just apply the regular one.
				target.apply_status_effect(STATUS_EFFECT_DULL_FANGS_PERMANENT)
				visible_message(span_warning("[user] rips out [target]'s canines! It doesn't look like they'll be growing back anytime soon..."))
				return ITEM_INTERACT_SUCCESS
			else
				user.visible_message(span_warning("[user] rips out [target]'s canines!"), span_warning("You rip out [target]'s canines!"))
				target.apply_status_effect(STATUS_EFFECT_DULL_FANGS)
				return ITEM_INTERACT_SUCCESS
		else // If they aren't kindred/have dull fangs, just give an alternate message instead of the fang specific one.
			user.visible_message(span_warning("[user] rips out one of [target]'s teeth!"), span_warning("You rip out one of [target]'s teeth!"))
			return ITEM_INTERACT_SUCCESS

/obj/item/wirecutters/pliers/bad
	name = "pliers"
	desc = "Meant for pulling wires but you could definitely crush something with these."
	icon_state = "ripper"
	inhand_icon_state = "ripper"
	toolspeed = 1.2 //is an actual tool but can't actually cut
	permanent = TRUE
