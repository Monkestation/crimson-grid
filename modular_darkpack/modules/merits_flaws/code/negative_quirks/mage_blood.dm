/datum/quirk/darkpack/mage_blood
	name = "Mage Blood"
	desc = "Your blood is so tied to magic that you find you are unable to use any Discipline apart from Thaumaturgy and it's associated Paths. Any discipline that isn't Thaumaturgy will be removed when joining the game."
	value = -5
	icon = FA_ICON_MAGIC_WAND_SPARKLES
	allowed_splats = list(SPLAT_KINDRED)
	included_clans = list(VAMPIRE_CLAN_TREMERE)
	quirk_flags = QUIRK_HIDE_FROM_SCAN //CRIMSON GRID EDIT ADD | PR: MAKE MEDICAL RECORDS NOT MASQ BREACHY | CHANGE: ADDED THIS TO PREVENT IT FROM BEING SEEN IN COMS

/datum/quirk/darkpack/mage_blood/add(client/client_source)
	var/datum/splat/vampire/kindred/kindred_splat = get_kindred_splat(quirk_holder)
	if(!kindred_splat)
		return
	for(var/datum/action/discipline/action as anything in kindred_splat.powers)
		// Unselectable Disciplines have special handling (e.g. Bloodheal) and are excluded
		if(!istype(action.discipline, /datum/discipline/thaumaturgy) && action.discipline.selectable)
			kindred_splat.remove_power(action.discipline.type)

