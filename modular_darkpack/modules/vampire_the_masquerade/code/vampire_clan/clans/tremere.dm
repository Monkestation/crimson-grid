/datum/subsplat/vampire_clan/tremere
	name = "Tremere"
	id = VAMPIRE_CLAN_TREMERE
	desc = "The arcane Clan Tremere were once a house of mortal mages who sought immortality but found only undeath. As vampires, they've perfected ways to bend their own blood to their will, employing their sorceries to master and ensorcel both the mortal and vampire world. Their power makes them valuable, but few vampires trust their scheming ways. The Tremere are secretive gatherers of occult knowledge and blood sorcerers. They are bound tightly to the Pyramid, a structure of bonds binding every member of the Clan to the Inner Circle and their will. Tremere are expected to place the clan's interests above their own, though some manage to defect to House Carna, become infernal demon-worshippers seeking forbidden power, independence, or even the Sabbat. Their curse causes blood bonds to affect them far more intensely than other Kindred."
	icon = "tremere"
	curse = "Blood-bonds affecting the Tremere are far stronger."
	roleplay_level = "Advanced"
	sense_the_sin_text = "has a sense of perfectionism by their own actions."
	clan_disciplines = list(
		/datum/discipline/auspex,
		/datum/discipline/dominate,
		/datum/discipline/thaumaturgy
	)
	male_clothes = /obj/item/clothing/under/vampire/tremere
	female_clothes = /obj/item/clothing/under/vampire/tremere/female

/datum/subsplat/vampire_clan/tremere/psychomania_effect(mob/living/target, mob/living/owner)
	to_chat(target, span_cult("Blood pours out from my body, manifesting into a grotesque form"))
	new /obj/effect/client_image_holder/baali_demon/tremere(get_turf(target), list(target))
