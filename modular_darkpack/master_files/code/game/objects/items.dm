/obj/item
	///How strong must we be to break this item on resist? (also cuffs and such)
	///Set to null to disallow breaking.
	var/cuff_break_strength_needed = null

	// ONFLOOR_ICONS
	var/onflooricon
	var/onflooricon_state

	var/masquerade_violating

	// STORYTELLR_STATS
	var/datum/st_stat/st_attack_ability = STAT_DEXTERITY
	var/datum/st_stat/st_attack_attribute = STAT_MELEE
	var/attack_difficulty = 6
	var/datum/st_stat/st_damage_stat = STAT_STRENGTH
