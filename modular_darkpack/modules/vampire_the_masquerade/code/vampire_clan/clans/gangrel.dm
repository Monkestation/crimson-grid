/datum/subsplat/vampire_clan/gangrel
	name = "Gangrel"
	id = VAMPIRE_CLAN_GANGREL
	desc = "Often closer to beasts than other vampires, the Gangrel style themselves apex predators. These Ferals prowl the wilds as easily as the urban jungle, and no clan of vampires can match their ability to endure, survive, and thrive in any environment. Often fiercely territorial, their shapeshifting abilities even give the undead pause. The Gangrel are survivalists, wanderers, and Predators, deeply tied to their instincts and the Beast. Though the Clan officially left the Camarilla years ago, enough Elder Gangrel remain within it to still maintain influence. Gangrel tend to avoid rigid politics, preferring independence and practical strength over status. Their curse causes animalistic features to manifest after frenzy, slowly making them appear less human."
	icon = "gangrel"
	curse = "Start with lower humanity."
	roleplay_level = "Beginner Friendly"
	sense_the_sin_text = "is unable to control their impulses."
	clan_disciplines = list(
		/datum/discipline/animalism,
		/datum/discipline/fortitude,
		/datum/discipline/protean
	)
	male_clothes = /obj/item/clothing/under/vampire/gangrel
	female_clothes = /obj/item/clothing/under/vampire/gangrel/female
	clan_marks = list(
		/datum/bodypart_overlay/simple/clan_mark/beast_legs,
		/datum/bodypart_overlay/simple/clan_mark/beast_tail,
		/datum/bodypart_overlay/simple/clan_mark/beast_tail_and_legs,
	)

/datum/subsplat/vampire_clan/gangrel/city
	name = "City Gangrel"
	desc = "The City Gangrel, a Sabbat bloodline of the traditional Gangrel bloodline, are commonly in urban environments, utilizing their seperate disciplines of Celerity (speed) and Obfuscate (supernatural ability to hide), to stalk alleyways, rooftops, and sewer systems for their next feast of blood alongside their Sabbat pack-mates."
	id = VAMPIRE_CLAN_CITY_GANGREL
	icon = "city_gangrel"
	roleplay_level = "Beginner Friendly"
	clan_disciplines = list(
		/datum/discipline/celerity,
		/datum/discipline/obfuscate,
		/datum/discipline/protean
	)
