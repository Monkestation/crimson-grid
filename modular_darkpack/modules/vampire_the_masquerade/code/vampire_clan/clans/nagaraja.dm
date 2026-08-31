/datum/subsplat/vampire_clan/nagaraja
	name = "Nagaraja"
	id = VAMPIRE_CLAN_NAGARAJA
	desc = "The Nagaraja are a mysterious bloodline, created through a ritual rather than having any Antediluvian to call their own. They are feared and reviled for both their expertise in the arts of necromancy, and their hunger for flesh."
	curse = "Instead of consuming blood like most kindred, the Nagaraja are only able to subsist off of the flesh and viscera of their prey, earning the nickname of 'Flesh-Eaters' among their bretheren."
	icon = "nagaraja"
	sense_the_sin_text = "hungers for flesh"
	clan_disciplines = list(
		/datum/discipline/auspex,
		/datum/discipline/dominate,
		/datum/discipline/necromancy
	)
	subsplat_traits = list(TRAIT_ORGANOVORE)
	male_clothes = /obj/item/clothing/under/vampire/emo
	female_clothes = /obj/item/clothing/under/vampire/emo
	whitelisted = FALSE

/datum/subsplat/vampire_clan/nagaraja/on_gain(mob/living/carbon/human/gaining_mob, datum/splat/gaining_splat, joining_round)
	. = ..()
	var/obj/item/ritual_tome/necromancy/necrotome = new()
	var/list/slots = list(
		LOCATION_LPOCKET = ITEM_SLOT_LPOCKET,
		LOCATION_RPOCKET = ITEM_SLOT_RPOCKET,
		LOCATION_BACKPACK = ITEM_SLOT_BACK,
		LOCATION_HANDS = ITEM_SLOT_HANDS
	)
	gaining_mob.equip_in_one_of_slots(necrotome, slots, FALSE)
