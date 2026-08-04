/datum/subsplat/vampire_clan/nosferatu
	name = "Nosferatu"
	id = VAMPIRE_CLAN_NOSFERATU
	desc = "The Nosferatu wear their curse on the outside. Their bodies horribly twisted and deformed through the Embrace, they lurk on the fringes of most cities, acting as spies and brokers of information. Using animals and their own supernatural capacity to hide, nothing escapes the eyes of the so-called Sewer Rats. The Nosferatu are hideously deformed by their embrace, and survive through secrecy and information trading. In many cities they remain closely associated with the Camarilla, though many may operate in other Sects, independently or maintain connections across sect lines. They are first and foremost loyal to their Clan, regardless of Sect. Their curse permanently twists them into monstrous forms incapable of passing as human."
	icon = "nosferatu"
	curse = "Masquerade-violating appearance."
	roleplay_level = "Intermediate"
	sense_the_sin_text = "is entranced by that which is unknown."
	alt_sprite = "nosferatu"
	clan_disciplines = list(
		/datum/discipline/animalism,
		/datum/discipline/potence,
		/datum/discipline/obfuscate
	)
	clan_traits = list(
		TRAIT_MASQUERADE_VIOLATING_FACE,
		TRAIT_VENTCRAWLER_ALWAYS,
		TRAIT_TRUE_NIGHT_VISION //CRIMSON GRID ADDITION - NOSFERATU GET NIGHT VISION

	)
	male_clothes = /obj/item/clothing/under/vampire/nosferatu
	female_clothes = /obj/item/clothing/under/vampire/nosferatu/female
	clan_marks = list(/datum/bodypart_overlay/simple/clan_mark/nosferatu_ears)
	default_accessory = /datum/bodypart_overlay/simple/clan_mark/nosferatu_ears
	subsplat_keys = /obj/item/vamp/keys/nosferatu

//CRIMSON GRID ADDITION - NOSFERATU GET NIGHT VISION
/datum/subsplat/vampire_clan/nosferatu/on_gain(mob/living/carbon/human/gaining_mob, datum/splat/gaining_splat, joining_round)
	. =  ..()
	gaining_mob.update_sight()

/datum/subsplat/vampire_clan/nosferatu/on_lose(mob/living/carbon/human/losing_mob)
	. = ..()
	if(!QDELETED(losing_mob))
		losing_mob.update_sight()
