/datum/quirk/darkpack/betrayers_mark
	name = "Betrayer's Mark"
	desc = "A mystical 'T' is branded onto your forehead - a mark that you, as a member of Clan Tremere, have undertaken the Vaulderie. Visible only to other Tremere, this mark brands you as Antitribu. While you may re-integrate with the clan, or may even have this mark in spite of your never having done the Vaulderie and always having been loyal, this Mark makes others of your Clan extremely wary of you."
	value = -3
	mob_trait = TRAIT_BETRAYERS_MARK
	gain_text = span_notice("A mystical 'T' is branded onto your forehead. The Mark of the Betrayer")
	lose_text = span_notice("The 'T' on your forehead appears to fade... oh no... NOT AGAIN!!!") // look up what happened to the antitribu tremeres in 1998
	icon = FA_ICON_T
	allowed_splats = list(SPLAT_KINDRED)
	included_clans = list(VAMPIRE_CLAN_TREMERE)
	failure_message = "The 'T' on your forehead appears to fade... oh no... NOT AGAIN!!!"
	quirk_flags = QUIRK_HIDE_FROM_SCAN //CRIMSON GRID EDIT ADD | PR: MAKE MEDICAL RECORDS NOT MASQ BREACHY | CHANGE: ADDED THIS TO PREVENT IT FROM BEING SEEN IN COMS
