/datum/subsplat/vampire_clan/old_clan_tzimisce
	name = "Old Clan Tzimisce"
	id = VAMPIRE_CLAN_OLD_CLAN_TZIMISCE
	desc = "The Old Clan Tzimisce are a small group of Fiends who predate the use of fleshcrafting. They regard Vicissitude as a disease of the soul, and refuse to learn or employ it. In most other respects, though, they resemble the rest of the Clan."
	icon = "old_clan_tzimisce"
	curse = "Grounded to material domain."
	clan_disciplines = list(
		/datum/discipline/auspex,
		/datum/discipline/animalism,
		/datum/discipline/dominate
	)
	male_clothes = /obj/item/clothing/under/vampire/sport
	female_clothes = /obj/item/clothing/under/vampire/red
	enlightenment = TRUE
	//restricted_disciplines = list(/datum/discipline/vicissitude)
	whitelisted = FALSE
	subsplat_keys = /obj/item/vamp/keys/old_clan_tzimisce

/datum/subsplat/vampire_clan/old_clan_tzimisce/on_join_round(mob/living/carbon/human/joining)
	. = ..()

	var/obj/item/ground_heir/heirloom = new(get_turf(joining))
	var/list/slots = list(
		LOCATION_LPOCKET = ITEM_SLOT_LPOCKET,
		LOCATION_RPOCKET = ITEM_SLOT_RPOCKET,
		LOCATION_BACKPACK = ITEM_SLOT_BACK,
		LOCATION_HANDS = ITEM_SLOT_HANDS
	)
	joining.equip_in_one_of_slots(heirloom, slots, FALSE)
	joining.AddComponent(/datum/component/needs_home_soil, heirloom)
