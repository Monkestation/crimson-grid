/obj/item/organ/on_mob_insert(mob/living/carbon/organ_owner, special, movement_flags)
	. = ..()
	last_owner = WEAKREF(organ_owner)
