/datum/splat/vampire/ghoul/prepare_human_for_preview(mob/living/carbon/human/human)
	human.set_haircolor("#ac151d", update = FALSE)
	human.set_hairstyle("Long Fringe", update = TRUE)
	human.set_eye_color("#2D4118")
	human.undershirt = "Tank Top (Fire)"
	human.update_body()

/datum/splat/vampire/ghoul/get_splat_description()
	return "Mortals sustained and bound by vampiric vitae, gaining unnatural vitality, eternal youth, and an emotional dependency on their domitors. Some serve willingly out of vitae-afflicted love, loyalty, or ambition, while others remain trapped by addiction in their inescapable blood bond.\n\nAcross the World, ghouls act as bodyguards, servants, agents, and intermediaries for Kindred across every sect and faction. Though stronger than ordinary humans and able to act in daytime, they remain vulnerable to the whims and politics of Kindred Society and their masters."

// Pulled straight from the wiki https://whitewolf.fandom.com/wiki/Ghoul_(VTM)
/datum/splat/vampire/ghoul/get_splat_lore()
	return list(
		"Feed just about any living creature a little vampire blood and it becomes a Ghoul, at least temporarily. In VTM, ghouls are omnipresent servants, easily created, and heavily abused - although networks do exist to assist them in escaping their masters. A ghoul's emotions run to extremes with the heady drug of vitae in his veins, not to mention the Blood Bond - such a creature often falls prey to great rages and disturbing cravings. The name \"ghouls\" was not chosen at random."
	)

/datum/splat/vampire/ghoul/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = FA_ICON_DROPLET,
			SPECIES_PERK_NAME = "The Bond",
			SPECIES_PERK_DESC = "Ghouls are frequently found bound by blood to do the deeds of their master.",
		),
	)

	return to_add
