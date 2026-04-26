// **************************************************************** DEFLECTION OF THE WOODEN DOOM *************************************************************

//Deflection of the Wooden Doom ritual
//Protects you from being staked for a single hit. Is it useful? Marginally. But it is a level 1 rite.
/obj/ritual_rune/thaumaturgy/deflection_stake
	name = "deflection of the wooden doom"
	desc = "Shield your heart and splinter the enemy stake. Requires a stake."
	icon_state = "rune7"
	word = "Splinter, shatter, break the wooden doom."
	level = 1
	sacrifices = list(/obj/item/vampire_stake)

/obj/ritual_rune/thaumaturgy/deflection_stake/complete()
	. = ..()
	for(var/mob/living/carbon/human/H in loc)
		if(!HAS_TRAIT(H, TRAIT_STAKE_RESISTANT))
			ADD_TRAIT(H, TRAIT_STAKE_RESISTANT, MAGIC_TRAIT)
			qdel(src)
		color = rgb(255,0,0)
		activated = TRUE
