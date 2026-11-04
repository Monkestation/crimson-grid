/datum/quirk/darkpack/thaumaturgically_inept
	name = "Thaumaturgically Inept"
	desc = "Something about you refuses to respond to Thaumaturgy. It just doesn't work for you. Thaumaturgy will be completely removed when joining the game."
	value = -5
	icon = FA_ICON_BAN
	allowed_splats = list(SPLAT_KINDRED)
	included_clans = list(VAMPIRE_CLAN_TREMERE)
	quirk_flags = QUIRK_HIDE_FROM_SCAN //CRIMSON GRID EDIT ADD | PR: MAKE MEDICAL RECORDS NOT MASQ BREACHY | CHANGE: ADDED THIS TO PREVENT IT FROM BEING SEEN IN COMS

/datum/quirk/darkpack/thaumaturgically_inept/add(client/client_source)
	var/datum/splat/vampire/kindred/kindred_splat = get_kindred_splat(quirk_holder)
	if(!kindred_splat)
		return
	kindred_splat.remove_power(/datum/discipline/thaumaturgy)
