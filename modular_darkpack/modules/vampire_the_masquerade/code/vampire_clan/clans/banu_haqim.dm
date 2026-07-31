/datum/subsplat/vampire_clan/banu_haqim
	name = "Banu Haqim Warrior"
	id = VAMPIRE_CLAN_BANU_HAQIM
	desc = "Banu Haqim, also known as Assamites, are traditionally seen by Western Kindred as dangerous assassins and diablerists, but in truth they are guardians, warriors, and scholars who seek to distance themselves from the Jyhad. The Banu Haqim are the newest clan admitted into the Camarilla, following a major schism caused by the awakening of the Methuselah Ur-Shulgi. Across Kindred society they remain outsiders struggling to secure stable political footing, despite sometimes holding a fragile Primogen position supported largely by the Ventrue. The Warrior caste are the judges, assassins, and soldiers of Clan Banu Haqim. In many cities, most Warrior defectors who joined the Camarilla are viewed as outsiders, caught between loyalty to their clan and rejection of Ur-Shulgi's hardline vision. Like all Banu Haqim, their curse twists their relationship with Kindred vitae, giving them an unnatural hunger for the blood of other Vampires, often leading to diablerie."
	icon = "banu_haqim"
	curse = "Blood Addiction."
	roleplay_level = "Intermediate"
	sense_the_sin_text = "sees themselves as absolute judgement."
	clan_disciplines = list(
		/datum/discipline/celerity,
		/datum/discipline/obfuscate,
		/datum/discipline/quietus
	)
	clan_traits = list(
		TRAIT_VITAE_ADDICTION
	)
	male_clothes = /obj/item/clothing/under/vampire/bandit
	female_clothes = /obj/item/clothing/under/vampire/bandit
	subsplat_keys = /obj/item/vamp/keys/banuhaqim

/datum/subsplat/vampire_clan/banu_haqim/psychomania_effect(mob/living/target, mob/living/owner)
	to_chat(target, span_cult("An overwhelming presence manifests around me.."))
	new /obj/effect/client_image_holder/baali_demon/banu(get_turf(target), list(target))

/datum/subsplat/vampire_clan/banu_haqim/vizier
	name = "Banu Haqim Vizier"
	desc = "The Banu Haqim are the newest clan admitted into the Camarilla, following a major schism caused by the awakening of the Methuselah Ur-Shulgi. In San Francisco they remain outsiders struggling to secure stable political footing, despite holding a fragile Primogen position supported largely by the Ventrue. The Viziers are the scholars, diplomats, and advisors of Clan Banu Haqim, valuing intellect and careful judgment over open violence. Many of the Banu Haqim who defected to the Camarilla are Viziers, fearing Ur-Shulgi's fanaticism. Like all Banu Haqim, their curse leaves them burdened with a dangerous thirst for Kindred blood and the temptation of diablerie, though the added curse of their caste furthermore drives them into obsessive fixation on their studies, crafts, or personal pursuits."
	id = VAMPIRE_CLAN_BANU_HAQIM_VIZIER
	icon = "banu_haqim_vizier"
	roleplay_level = "Advanced"
	curse = "Obsessive nature."
	clan_disciplines = list(
		/datum/discipline/celerity,
		/datum/discipline/auspex,
		/datum/discipline/quietus
	)
	clan_traits =  list()
