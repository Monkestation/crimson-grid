/datum/discipline_power/vicissitude/bonecrafting/post_gain()
	. = ..()
	var/obj/item/organ/cyberimp/arm/toolkit/tzimisce/arm_blade = new()
	arm_blade.Insert(owner)
