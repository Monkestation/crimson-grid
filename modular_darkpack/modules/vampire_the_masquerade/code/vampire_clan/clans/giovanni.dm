/datum/subsplat/vampire_clan/giovanni
	name = "Giovanni"
	id = VAMPIRE_CLAN_GIOVANNI
	desc = "The Giovanni are the usurpers of Clan Cappadocian and one of the youngest clans. The Giovanni has historically been both a clan and a family. They Embrace almost exclusively within their family, and are heavily focused on the goals of money and necromantic power."
	icon = "giovanni"
	curse = "Extremely painful bites that injure their quarry causing them to scream in pain and perhaps die, while other Clan's bites lull their victims into a pleasurable, foggy trance."
	sense_the_sin_text = "never considers any action too great for their family."
	clan_disciplines = list(
		/datum/discipline/potence,
		/datum/discipline/dominate,
		/datum/discipline/necromancy
	)
	clan_traits = list(
		TRAIT_PAINFUL_VAMPIRE_KISS
	)
	male_clothes = /obj/item/clothing/under/vampire/suit
	female_clothes = /obj/item/clothing/under/vampire/suit/female

/datum/subsplat/vampire_clan/giovanni/on_join_round(mob/living/carbon/human/joining)
	. = ..()
	joining.grant_language(/datum/language/italian)

/datum/subsplat/vampire_clan/giovanni/psychomania_effect(mob/living/target, mob/living/owner)
	to_chat(target, span_cult("A sense of profound dread enters you as soundless words enter your mind"))
	target.playsound_local(target, "modular_darkpack/modules/powers/sounds/daimonion_laughs/eldritchlaugh.ogg", 50, FALSE)
	new /obj/effect/client_image_holder/baali_demon/spectre(get_turf(target), list(target))
