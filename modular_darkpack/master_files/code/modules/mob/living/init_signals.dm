/mob/living/register_init_signals()
	. = ..()
	RegisterSignal(src, COMSIG_ENTER_AREA, PROC_REF(update_zone_hud)) // AREAS - (Zone hud)
	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_OBFUSCATED), PROC_REF(make_invisible)) // POWERS - (Obfuscate Discipline)
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_OBFUSCATED), PROC_REF(make_visible)) // POWERS - (Obfuscate Discipline)
	RegisterSignal(src, COMSIG_MOB_CTRL_SHIFT_CLICKED, PROC_REF(attempt_guestbook_add))
	RegisterSignal(src, COMSIG_MOB_REQUESTING_SCREENTIP_NAME_FROM_USER, PROC_REF(name_override))

/// For Guestbooks.
/mob/living/proc/name_override(datum/source, list/returned_name, obj/item/held_item, mob/living/carbon/human/hovered)
	SIGNAL_HANDLER

	if(!ishuman(hovered))
		return NONE
	if(source == hovered)
		returned_name[1] = real_name
		return SCREENTIP_NAME_SET

	var/known_name = GET_GUESTBOOK_NAME(src, hovered)
	returned_name[1] = known_name ? "[known_name]" : "[hovered.name]"
	return SCREENTIP_NAME_SET
