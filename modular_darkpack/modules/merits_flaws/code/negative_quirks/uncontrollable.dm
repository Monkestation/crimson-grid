//Clanbook: Brujah Revised (69)
/datum/quirk/darkpack/uncontrollable
	name = "Uncontrollable"
	desc = {"Rage and passion constantly war in the soul of a
		volatile Brujah. Perhaps you were ill tempered before
		the Embrace, or perhaps your Brujah lineage awakened
		some latent fury. In any case, even more so than your
		clanmates, you are prone to frenzy. Difficulties to
		resist frenzy are always 10 for this character. Prepare
		for a short, hellish ride."}
	value = -5
	mob_trait = TRAIT_UNCONTROLLABLE
	icon = FA_ICON_HEART_CRACK
	allowed_splats = list(SPLAT_KINDRED)
	included_clans = list(VAMPIRE_CLAN_BRUJAH)
	quirk_flags = QUIRK_HIDE_FROM_SCAN //CRIMSON GRID EDIT ADD | PR: MAKE MEDICAL RECORDS NOT MASQ BREACHY | CHANGE: ADDED THIS TO PREVENT IT FROM BEING SEEN IN COMS
