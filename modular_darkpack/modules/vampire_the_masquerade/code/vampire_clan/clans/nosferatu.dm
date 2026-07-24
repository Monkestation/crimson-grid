/datum/subsplat/vampire_clan/nosferatu
	name = "Nosferatu"
	id = VAMPIRE_CLAN_NOSFERATU
	desc = "The Nosferatu wear their curse on the outside. Their bodies horribly twisted and deformed through the Embrace, they lurk on the fringes of most cities, acting as spies and brokers of information. Using animals and their own supernatural capacity to hide, nothing escapes the eyes of the so-called Sewer Rats."
	icon = "nosferatu"
	curse = "Masquerade-violating appearance."
	sense_the_sin_text = "is entranced by that which is unknown."
	alt_sprite = "nosferatu"
	clan_disciplines = list(
		/datum/discipline/animalism,
		/datum/discipline/potence,
		/datum/discipline/obfuscate
	)
	clan_traits = list(
		TRAIT_MASQUERADE_VIOLATING_FACE,
		TRAIT_VENTCRAWLER_ALWAYS
	)
	male_clothes = /obj/item/clothing/under/vampire/nosferatu
	female_clothes = /obj/item/clothing/under/vampire/nosferatu/female
	clan_marks = list(/datum/bodypart_overlay/simple/clan_mark/nosferatu_ears)
	default_accessory = /datum/bodypart_overlay/simple/clan_mark/nosferatu_ears
	subsplat_keys = /obj/item/vamp/keys/nosferatu

