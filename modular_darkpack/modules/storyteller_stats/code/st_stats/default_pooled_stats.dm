/datum/st_stat/pooled/permanent_willpower
	name = "Permanent Willpower"
	description = "A character's inner drive and competence at overcoming unfavorable odds. Used for Rolls."
	freebie_point_cost = FREEBIE_COST_WILLPOWER
	stat_flags = AFFECTS_STATS

/datum/st_stat/pooled/temporary_willpower
	name = "Temporary Willpower"
	description = "A character's inner drive and competence at overcoming unfavorable odds. Used for spendature."
	editable = FALSE


/// Prompts the user to burn an amount of willpower then returns the amount spent.
/mob/living/proc/prompt_burn_willpower(amount = 1)
	if(st_get_stat(STAT_TEMPORARY_WILLPOWER) < amount)
		return 0
	var/choices = list(
		"Burn Willpower" = image(icon = 'modular_darkpack/modules/storyteller_stats/icons/assets.dmi', icon_state = "willpower"),
		"No" = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_no"),
	)

	var/chosen_option = show_radial_menu(src, src, choices, radius = 36, tooltips = TRUE)
	if(chosen_option == "Burn Willpower")
		st_change_stat(STAT_TEMPORARY_WILLPOWER, -amount)
		to_chat(src, span_warning("You burn [amount] willpower."))
		return amount

	return 0
