/datum/subsplat/vampire_clan/samedi
	name = "Samedi"
	id = VAMPIRE_CLAN_SAMEDI
	desc = "A rare bloodline of Corpse Walkers based from their enigmatic founder simply called the Baron Samedi."
	curse = "Extremely rotten dead form. Akin to a walking zombie."
	icon = "samedi"
	clan_disciplines = list(
		/datum/discipline/obfuscate,
		/datum/discipline/fortitude,
		/datum/discipline/thanatosis
	)
	alt_sprite = "rotten4"
	subsplat_traits = list(
		TRAIT_MASQUERADE_VIOLATING_FACE
	)
	whitelisted = TRUE

/datum/subsplat/vampire_clan/samedi/on_gain(mob/living/carbon/human/gaining_mob, datum/splat/gaining_splat, joining_round)
	. = ..()
	gaining_mob.rot_body(4)
