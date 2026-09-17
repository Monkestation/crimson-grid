/datum/subsplat/vampire_clan/baali
	name = "Baali"
	id = VAMPIRE_CLAN_BAALI
	desc = "The Baali are a bloodline of vampires associated with demon worship. Because of their affinity with the unholy, the Baali are particularly vulnerable to holy iconography, holy ground and holy water. They are highly vulnerable to True Faith."
	icon = "baali"
	curse = "Fear of the Religion."
	sense_the_sin_text = "is scared of the lord's presence."
	clan_disciplines = list(
		/datum/discipline/obfuscate,
		/datum/discipline/presence,
		/datum/discipline/daimoinon
	)

	subsplat_traits = list(
		TRAIT_REPELLED_BY_HOLINESS
	)
	male_clothes = /obj/item/clothing/under/vampire/baali
	female_clothes = /obj/item/clothing/under/vampire/baali/female
	enlightenment = TRUE
	whitelisted = TRUE
	subsplat_keys = /obj/item/vamp/keys/baali

/datum/subsplat/vampire_clan/baali/psychomania_effect(mob/living/target, mob/living/owner)
	to_chat(target, span_notice("The sacred icons appearing before you lack the true substance of faith"))
	new /datum/hallucination/delusion(target, TRUE, "repent", 200, 0)
	to_chat(owner, span_notice("Your illusions are easily dispelled by [target]"))
