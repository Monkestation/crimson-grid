/mob/living/basic/avatar
	name = "ghost"
	desc = "A malevolent spirit."
	icon = 'icons/mob/simple/mob.dmi'
	icon_state = "ghost"
	mob_biotypes = MOB_SPIRIT
	incorporeal_move = INCORPOREAL_MOVE_AVATAR
	invisibility = INVISIBILITY_REVENANT
	see_invisible = INVISIBILITY_REVENANT
	health = INFINITY // You cant kill a ghost
	maxHealth = INFINITY
	plane = GHOST_PLANE
	sight = SEE_SELF
	throwforce = 0

	friendly_verb_continuous = "touches"
	friendly_verb_simple = "touch"
	response_help_continuous = "passes through"
	response_help_simple = "pass through"
	response_disarm_continuous = "swings through"
	response_disarm_simple = "swing through"
	response_harm_continuous = "punches through"
	response_harm_simple = "punch through"
	unsuitable_atmos_damage = 0
	damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 0, STAMINA = 0, OXY = 0)
	habitable_atmos = null
	minimum_survivable_temperature = 0
	maximum_survivable_temperature = INFINITY
	mob_flags = MOB_HAS_SCREENTIPS_NAME_OVERRIDE
	mobility_flags = MOBILITY_MOVE
	status_flags = NONE
	density = FALSE
	move_resist = MOVE_FORCE_OVERPOWERING
	mob_size = MOB_SIZE_TINY
	movement_type = GROUND | FLYING
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	speed = 1
	hud_type = /datum/hud/avatar

/mob/living/basic/avatar/Initialize(mapload)
	. = ..()

	var/mob/body = loc
	if(ismob(body))
		gender = body.gender
		mind = body.mind //we don't transfer the mind but we keep a reference to it.

	abstract_move(get_turf(body))

	AddElement(/datum/element/movetype_handler)

	ADD_TRAIT(src, TRAIT_HEAR_THROUGH_DARKNESS, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_GOOD_HEARING, INNATE_TRAIT)
	RegisterSignal(src, COMSIG_MOB_REQUESTING_SCREENTIP_NAME_FROM_USER, PROC_REF(name_override))

/mob/living/basic/avatar/Destroy()
	UnregisterSignal(src, COMSIG_MOB_REQUESTING_SCREENTIP_NAME_FROM_USER)
	return ..()

//We don't want to update the current var
//But we will still carry a mind.
/mob/living/basic/avatar/mind_initialize()
	return

/mob/living/basic/avatar/can_perform_action(atom/target, action_bitflags)
	return FALSE

/mob/living/basic/avatar/can_hold_items(obj/item/I)
	return FALSE

/// For Guestbooks.
/mob/living/basic/avatar/proc/name_override(datum/source, list/returned_name, obj/item/held_item, mob/living/carbon/human/hovered)
	SIGNAL_HANDLER

	if(!ishuman(hovered))
		return NONE
	if(source == hovered)
		returned_name[1] = real_name
		return SCREENTIP_NAME_SET

	var/known_name = GET_GUESTBOOK_NAME(src, hovered)
	returned_name[1] = known_name ? "[known_name]" : "[hovered.name]"
	return SCREENTIP_NAME_SET
