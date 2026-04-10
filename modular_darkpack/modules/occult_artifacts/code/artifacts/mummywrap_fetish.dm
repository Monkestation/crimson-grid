/obj/item/vtm_artifact/mummywrap_fetish
	true_name = "Mummywrap Fetish"
	true_desc = "Passive health regeneration."
	icon_state = "m_fetish"
	var/last_regen = 0
	research_value = 10

/obj/item/vtm_artifact/mummywrap_fetish/process(delta_time)
	. = ..()
	if(identified && owner)
		if(last_regen+60 < world.time)
			last_regen = world.time
			owner.heal_storyteller_health(dots_to_heal = 1, heal_aggravated = FALSE, heal_scars = TRUE, heal_blood = TRUE)
