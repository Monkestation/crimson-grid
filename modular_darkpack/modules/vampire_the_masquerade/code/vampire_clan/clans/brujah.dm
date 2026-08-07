/datum/subsplat/vampire_clan/brujah
	name = "Brujah"
	id = VAMPIRE_CLAN_BRUJAH
	desc = "The Brujah are a clan of radicals and troublemakers, embracing those willing to put someone in their place if the situation calls for it. Most see themselves as warriors with a cause, and these Rebels are guided by their passions, strength, and dedication to their ideals - whatever those may be. The Brujah are rebels, philosophers, and revolutionaries who have recently been starting to join the Anarchs in droves, leaving the Camarilla behind. While many still sympathize with the Camarilla, especially Elders, and are still officially seen as a Camarilla Clan, Brujah within the city often walk a careful line between dissent and duty. They are infamous for their tempers, as their curse makes resisting frenzy far more difficult than for most Kindred."
	icon = "brujah"
	curse = "Increased frenzy chances and time."
	roleplay_level = "Beginner Friendly"
	sense_the_sin_text = "is cursed to anger for their shame at carthage.."
	clan_disciplines = list(
		/datum/discipline/celerity,
		/datum/discipline/potence,
		/datum/discipline/presence
	)
	clan_traits = list(
		TRAIT_DIFFICULT_FRENZY
	)
	male_clothes = /obj/item/clothing/under/vampire/brujah
	female_clothes = /obj/item/clothing/under/vampire/brujah/female
	subsplat_keys = /obj/item/vamp/keys/brujah


/datum/subsplat/vampire_clan/brujah/psychomania_effect(mob/living/target, mob/living/owner)
	to_chat(target, span_warning("You see visions of an underground stone monument weeping blood."))
	target.playsound_local(target, "modular_darkpack/modules/powers/sounds/daimonion_laughs/demonlaugh3.ogg", 50, FALSE)
	to_chat(target, span_cult("THE BEAST RAGES AGAINST THIS VISION!!"))
