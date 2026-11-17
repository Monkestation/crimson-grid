// Alter the properties of the crafted Szlachta and add to Crafter's Beastmaster List
/mob/living/basic/szlachta/on_craft_completion(list/components, datum/crafting_recipe/current_recipe, atom/crafter)
	. = ..()
	var/mob/living/carbon/human/szlachta_owner = astype(crafter)
	if (!szlachta_owner)
		return
	QDEL_NULL(ai_controller)
	ai_controller = new /datum/ai_controller/basic_controller/beastmaster_summon(src)
	AddElement(/datum/element/ai_retaliate)
	playsound(loc, 'sound/effects/changeling_absorb/changeling_absorb5.ogg', 15, vary = TRUE)
	szlachta_owner.add_beastmaster_minion(src)
