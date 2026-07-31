/datum/subsplat/vampire_clan/toreador
	name = "Toreador"
	id = VAMPIRE_CLAN_TOREADOR
	desc = "Known for their seductive nature, enthralling demeanor, and eloquent grace to the point of obsession, Toreador vampires Embrace artists and lovers into their ranks, forever trying to stir their own deadened hearts. Supernaturally graceful and charming, the Divas are always looking for the next thrill, leaving a detritus of discarded lovers and victims in their wake. The Toreador are lovers of beauty and anything artistic, who are common in Kindred high society. Strongly aligned with the Camarilla, they concern themselves with culture and influence. Some are patrons of the arts, while others obsess over modern trends and fleeting sensations. Anything can be art, if the Toreador regards it as such. Their curse causes them to become dangerously entranced by beauty and emotion."
	icon = "toreador"
	curse = "Doubled humanity changes."
	roleplay_level = "Beginner Friendly"
	sense_the_sin_text = "is obsessive to a fault."
	clan_disciplines = list(
		/datum/discipline/auspex,
		/datum/discipline/celerity,
		/datum/discipline/presence
	)
	clan_traits = list(
		TRAIT_SENSITIVE_HUMANITY
	)
	male_clothes = /obj/item/clothing/under/vampire/toreador
	female_clothes = /obj/item/clothing/under/vampire/toreador/female
	subsplat_keys = /obj/item/vamp/keys/toreador

/datum/subsplat/vampire_clan/toreador/psychomania_effect(mob/living/target, mob/living/owner)
	target.playsound_local(target, "modular_darkpack/modules/powers/sounds/daimonion_laughs/demonlaugh2.ogg", 50, FALSE)
	new /datum/hallucination/fire(target, TRUE)
	to_chat(target, span_cult("FLAMES ENGULF MY BEAUTY"))
	target.Paralyze(5 SECONDS)
