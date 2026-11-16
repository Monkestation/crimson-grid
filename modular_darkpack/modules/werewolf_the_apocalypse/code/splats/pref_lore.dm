/datum/splat/werewolf/kinfolk/prepare_human_for_preview(mob/living/carbon/human/human)
	human.set_haircolor("#C3BA88", update = FALSE)
	human.set_eye_color("B2B2B2", "B2B2B2")
	human.set_hairstyle("Bangs (Diagonal Alt)", update = TRUE)
	human.undershirt = "Shirt (Ian)"
	human.update_body()

// note - we have unused desc vars on splats
/datum/splat/werewolf/kinfolk/get_splat_description()
	return "Kinfolk, sometimes called Gallain or just Kin, are those humans and wild animals who are related to the Fera and are not prone to the Delirium, but who are not actual shapeshifters themselves."

/datum/splat/werewolf/kinfolk/get_splat_lore()
	return list(
		"Despite being far better able to interact with their breed (species) than Garou of the same breed, neither human nor animal kinfolk belong purely to their respective species. Human kinfolk generally had a bit more spirituality and connection to nature, being slightly of the wolf, than did the masses of humanity. Animal kinfolk had more cognizance than their non-Kin fellows and thus had a bit of human in them, separating them from other wolves to a degree.\n\nKinfolk are related by varying degrees to the Garou by blood, but do not possess the spiritual component necessary to undergo the First Change. They are divided into two breeds, human or wolf (or appropriate animal species for kinfolk of Fera), which are not to be confused with the homid or lupus breeds that are specific to Gaia's chosen. No kinfolk possess Rage, nor are they blessed by Luna or Helios with an Auspice.\n\nThis lack of favor also means that they're immune to the effects that silver (or gold for some fera) has on their true breed kin. Gaia does favor kinfolk above normal humans (and animals), thus some exceptional Kinfolk learn rudimentary Gifts, and a very small minority are blessed with Gnosis to use greater Gifts. The Children of Gaia are exceptional to the rest of the tribes for their general endorsement of their kinfolk learning healing and social gifts."
	)

/datum/splat/werewolf/shifter/garou/prepare_human_for_preview(mob/living/carbon/human/human)
	human.set_haircolor("#502D15", update = FALSE)
	human.set_hairstyle("Long Hair 3", update = TRUE)
	human.undershirt = "Shirt (Alien)"
	human.update_body()

/datum/splat/werewolf/shifter/garou/get_splat_description()
	return "The Werewolves of the World of Darkness. They are shapeshifting warriors created by Gaia to defend the natural world against corruption, decay, and supernatural evil (though some, like the Black Spiral Dancers, now serve said evil). Fiercely territorial and almost always violently hostile toward vampires, they are among the more dangerous creatures encountered in the World of Darkness.\n\nTo most Kindred, Garou are terrifying forces of nature whose presence beyond the city limits represents sudden violence, righteous fury, and almost certain death."

/datum/splat/werewolf/shifter/garou/get_splat_lore()
	return list(
		"Garou have a robust mythology regarding their existence and connection to nature and the earth, following the creation myth and metaphysics of Gaia and the Triat, the three primary Gods of their mythology.\n\nThe Triat consists of the Wyld, Weaver, and Wyrm, representing creation, order, and destruction, respectively. The Garou regard themselves as the chosen protectors of Gaia, who they believe to be the literal Earth, blessed by Luna, the spirit of the moon, who gives them their spiritual strength as well as their infamous weakness to silver.\n\nThe oral tradition of the Garou holds that the Triat were once in balance, creating harmony in reality and with Gaia, but have fallen into disharmony, as the Apocalypse quickly approaches in the modern age of pollution, mass industrialization, and rampant exploitation of the natural resources of Gaia. The Weaver, representing Order, is stronger than it's ever been due to the rise of humanity and modern civilization, and consequently, the destructive capacity of the Wyrm also grows as the Earth is plundered, and the Wyld's influence retreats, throwing the Triat into disorder.\n\nMany tribes of the Garou have different perspectives on this oral history and what must be done to prevent the Apocalypse - the day when the Wyrm, the destructive force of the Triat, overpowers the Weaver and is allowed to destroy and consume unchecked.",
	)

/datum/splat/werewolf/shifter/garou/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = FA_ICON_DOG,
			SPECIES_PERK_NAME = "Shapeshifting",
			SPECIES_PERK_DESC = "Garou can shift between 5 diffrent forms that grant them bonuses.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = FA_ICON_BAND_AID,
			SPECIES_PERK_NAME = "Passive healing",
			SPECIES_PERK_DESC = "Garou have a strong passive healing while outside of their breed form.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = FA_ICON_MOON,
			SPECIES_PERK_NAME = "Silver weakness",
			SPECIES_PERK_DESC = "Silver weapons are unable to be soaked in non-breedforms and causes loss of Gnosis.",
		),
	)

	return to_add

/datum/splat/werewolf/shifter/corax/prepare_human_for_preview(mob/living/carbon/human/human)
	human.set_haircolor("#241e1c", update = FALSE)
	human.set_hairstyle("Long Over Eye", update = TRUE)
	human.undershirt = "Shirt (Black)"
	human.update_body()

/datum/splat/werewolf/shifter/corax/get_splat_description()
	return "Messengers of Gaia, children of Raven, and scions of Helios; the wereravens travel accross the globe, guided by their innate curiosity and insatiable thirst for gossip. \nThey are renowned for their ability to gather useful intelligence, and the difficulty of making them stop talking."

/datum/splat/werewolf/shifter/corax/get_splat_lore()
	return list(
		"The Corax, or were-ravens, are one of the few, if not the only, group of shape-shifters who remain on good terms with the Garou after the War of Rage, an ancient war between the Garou and nearly all other kinds of shape-shifters.\n\nBelieving themselves to be blessed by Helios, the spirit of the Sun, who acts as their patron much as the Garou consider Luna to be theirs, the Corax use these good terms and synchronicity with the Garou to travel and gather intelligence, unafraid of the attacks and aggression of the Garou.\n\nWhile Corax do have Rage as the Garou do, their Rage is rarely developed and thus the Corax are not known for the kind of violent outbursts that plague the Garou.\n\nMuch as the Garou have a legendary weakness to silver due to their blessed nature by the moon-spirit Luna, the Corax have a similar weakness to gold on account of their blessing by Helios.",
	)

/datum/splat/werewolf/shifter/corax/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = FA_ICON_CROW,
			SPECIES_PERK_NAME = "Shapeshifting",
			SPECIES_PERK_DESC = "Corax can shift between 3 diffrent forms that grant them bonuses.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = FA_ICON_BAND_AID,
			SPECIES_PERK_NAME = "Passive healing",
			SPECIES_PERK_DESC = "Corax have a strong passive healing while outside of their breed form.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = FA_ICON_SUN,
			SPECIES_PERK_NAME = "Gold weakness",
			SPECIES_PERK_DESC = "Gold weapons is unable to be soaked in non-breedforms and causes loss of Gnosis.",
		),
	)

	return to_add
