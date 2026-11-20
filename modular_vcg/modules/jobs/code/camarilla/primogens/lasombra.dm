/datum/job/vampire/primogen_lasombra
	minimal_generation = 10
	minimum_immortal_age = 100

/datum/outfit/job/vampire/primogen_lasombra/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(H.mind)
		H.mind.set_holy_role(HOLY_ROLE_DEACON)
