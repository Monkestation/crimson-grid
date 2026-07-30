/datum/splat/vampire/kindred/prepare_human_for_preview(mob/living/carbon/human/human)
	human.set_haircolor("#333333", update = FALSE)
	human.set_hairstyle("Undercut Left", update = TRUE)
	human.set_eye_color("#ff0000")
	human.undershirt = "T-Shirt (Red)"
	human.update_body()
	human.equipOutfit(/datum/outfit/job/vampire/prince, TRUE)

// note - we have unused desc vars on splats
/datum/splat/vampire/kindred/get_splat_description()
	return "Immortal predators cursed to live in the night, these vampires survive on human blood while hiding their existence behind the facade they call the Masquerade. Divided by clans, sects, and rivalries, they wage endless political and ideological wars beneath the surface of mortal society.\n\nThough officially under the Camarilla, many cities also harbour Anarchs, Sabbat, and independent factions in an uneasy balance constantly threatened by each other, outside forces and internal fighting alike. Every Kindred struggles against the primal urges of the Beast within them, with bloody frenzy and decline into monstrosity only ever one mistake away."

// Pulled straight from the wiki https://whitewolf.fandom.com/wiki/Vampire_(WOD)
/datum/splat/vampire/kindred/get_splat_lore()
	return list(
		"The blood-drinkers who stalk the World of Darkness mostly call themselves Kindred, licks, or Cainites. The term \"vampire\" seems déclassé to the habitués of Elysium and the theorists of Anarch utopia, reminiscent of cheesy Hammer sequels and tourist-friendly reactionary folklore. However, those Embraced in recent decades increasingly use the term among themselves (\"taking the v-word back\"), establishing their claim to this status despite the thinness of their Blood.",
	)

/datum/splat/vampire/kindred/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
			SPECIES_PERK_ICON = FA_ICON_BOOK_DEAD,
			SPECIES_PERK_NAME = "Kindred Clans",
			SPECIES_PERK_DESC = "Kindred belong to many clans, which you are able to choose in the preferences, all with their own special abilities and weaknesses!",
		),
	)

	return to_add

/*
// Vampire blood is special, so it needs to be handled with its own entry.
/datum/splat/vampire/kindred/create_pref_blood_perks()
	var/list/to_add = list()

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "tint",
		SPECIES_PERK_NAME = "Example Negative Perk",
		SPECIES_PERK_DESC = "Lorem Ipsum",
	))

	return to_add
*/

// There isn't a "Minor Undead" biotype, so we have to explain it in an override (see: dullahans)
/datum/splat/vampire/kindred/create_pref_biotypes_perks()
	var/list/to_add = list()

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_SKULL,
		SPECIES_PERK_NAME = "Minor Undead",
		SPECIES_PERK_DESC = "[name] are minor undead. \
			Minor undead enjoy some of the perks of being dead, like \
			not needing to breathe or eat, but do not get many of the \
			environmental immunities involved with being fully undead.",
	))

	return to_add
