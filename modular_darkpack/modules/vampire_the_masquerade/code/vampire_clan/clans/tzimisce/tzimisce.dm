/datum/subsplat/vampire_clan/tzimisce
	name = "Tzimisce"
	id = VAMPIRE_CLAN_TZIMISCE
	desc = "If someone were to call a Tzimisce inhuman and sadistic, the Tzimisce would probably commend them for their perspicacity, and then demonstrate that their mortal definition of sadism was laughably inadequate. The Tzimisce have left the human condition behind gladly, and now focus on transcending the limitations of the vampiric state. At a casual glance or a brief conversation, a Tzimisce appears to be one of the more pleasant vampires. Polite, intelligent, and inquisitive, they seem a stark contrast to the howling Sabbat mobs or even the apparently more humane Brujah or Nosferatu. However, upon closer inspection, it becomes clear that this is merely a mask hiding something alien and monstrous."
	curse = "Grounded to material domain."
	icon = "tzimisce"
	clan_disciplines = list(
		/datum/discipline/auspex,
		/datum/discipline/animalism,
		/datum/discipline/vicissitude

	)
	male_clothes = /obj/item/clothing/under/vampire/sport
	female_clothes = /obj/item/clothing/under/vampire/red
	enlightenment = TRUE
	clan_marks = list(
		/datum/bodypart_overlay/simple/clan_mark/spines,
		/datum/bodypart_overlay/simple/clan_mark/spines_slim,
		/datum/bodypart_overlay/simple/clan_mark/animal_skull,
	)

/datum/subsplat/vampire_clan/tzimisce/psychomania_effect(mob/living/target, mob/living/owner)
	target.playsound_local(target, "modular_darkpack/modules/powers/sounds/daimonion_laughs/demonlaugh3.ogg", 50, FALSE)
	to_chat(target, span_cult("I SEE VISIONS OF FLAME ENGULFING MY DOMAIN"))
	new /datum/hallucination/fire(target, TRUE)
	target.Paralyze(6 SECONDS)

/datum/subsplat/vampire_clan/tzimisce/on_join_round(mob/living/carbon/human/joining)
	. = ..()
	sense_the_sin_text = "[joining.name] is consumed by a singular desire."
	var/obj/item/ground_heir/heirloom = new(get_turf(joining))
	var/list/slots = list(
		LOCATION_LPOCKET = ITEM_SLOT_LPOCKET,
		LOCATION_RPOCKET = ITEM_SLOT_RPOCKET,
		LOCATION_BACKPACK = ITEM_SLOT_BACK,
		LOCATION_HANDS = ITEM_SLOT_HANDS
	)
	joining.equip_in_one_of_slots(heirloom, slots, FALSE)
	joining.AddComponent(/datum/component/needs_home_soil, heirloom)

/datum/movespeed_modifier/centipede
	multiplicative_slowdown = -0.6
