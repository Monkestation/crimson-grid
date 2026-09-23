#define BASHING_LETHAL_PROTECTION 15
#define AGGRAVATED_PROTECTION 10

/datum/status_effect/fortitude
	// All IDs are the same to prevent stacking multiple Fortitude statuses
	id = "fortitude"
	status_type = STATUS_EFFECT_REPLACE
	alert_type = null

	var/armor_type

/datum/status_effect/fortitude/on_apply()
	. = ..()
	if (!.)
		return

	if (ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		human_owner.physiology.armor = human_owner.physiology.armor.add_other_armor(armor_type)

/datum/status_effect/fortitude/on_remove()
	. = ..()

	if (ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		human_owner.physiology.armor = human_owner.physiology.armor.subtract_other_armor(armor_type)

// Status effect ranks
/datum/status_effect/fortitude/one
	armor_type = /datum/armor/fortitude1

/datum/armor/fortitude1
	acid = 1 * AGGRAVATED_PROTECTION
	bio = 1 * AGGRAVATED_PROTECTION
	bomb = 1 * BASHING_LETHAL_PROTECTION
	bullet = 1 * BASHING_LETHAL_PROTECTION
	consume = 1 * BASHING_LETHAL_PROTECTION
	energy = 1 * BASHING_LETHAL_PROTECTION
	laser = 1 * BASHING_LETHAL_PROTECTION
	fire = 1 * AGGRAVATED_PROTECTION
	melee = 1 * BASHING_LETHAL_PROTECTION
	wound = 1 * BASHING_LETHAL_PROTECTION

/datum/status_effect/fortitude/two
	armor_type = /datum/armor/fortitude2

/datum/armor/fortitude2
	acid = 2 * AGGRAVATED_PROTECTION
	bio = 2 * AGGRAVATED_PROTECTION
	bomb = 2 * BASHING_LETHAL_PROTECTION
	bullet = 2 * BASHING_LETHAL_PROTECTION
	consume = 2 * BASHING_LETHAL_PROTECTION
	energy = 2 * BASHING_LETHAL_PROTECTION
	laser = 2 * BASHING_LETHAL_PROTECTION
	fire = 2 * AGGRAVATED_PROTECTION
	melee = 2 * BASHING_LETHAL_PROTECTION
	wound = 2 * BASHING_LETHAL_PROTECTION

/datum/status_effect/fortitude/three
	armor_type = /datum/armor/fortitude3

/datum/armor/fortitude3
	acid = 3 * AGGRAVATED_PROTECTION
	bio = 3 * AGGRAVATED_PROTECTION
	bomb = 3 * BASHING_LETHAL_PROTECTION
	bullet = 3 * BASHING_LETHAL_PROTECTION
	consume = 3 * BASHING_LETHAL_PROTECTION
	energy = 3 * BASHING_LETHAL_PROTECTION
	laser = 3 * BASHING_LETHAL_PROTECTION
	fire = 3 * AGGRAVATED_PROTECTION
	melee = 3 * BASHING_LETHAL_PROTECTION
	wound = 3 * BASHING_LETHAL_PROTECTION

/datum/status_effect/fortitude/four
	armor_type = /datum/armor/fortitude4

/datum/armor/fortitude4
	acid = 4 * AGGRAVATED_PROTECTION
	bio = 4 * AGGRAVATED_PROTECTION
	bomb = 4 * BASHING_LETHAL_PROTECTION
	bullet = 4 * BASHING_LETHAL_PROTECTION
	consume = 4 * BASHING_LETHAL_PROTECTION
	energy = 4 * BASHING_LETHAL_PROTECTION
	laser = 4 * BASHING_LETHAL_PROTECTION
	fire = 4 * AGGRAVATED_PROTECTION
	melee = 4 * BASHING_LETHAL_PROTECTION
	wound = 4 * BASHING_LETHAL_PROTECTION

/datum/status_effect/fortitude/five
	armor_type = /datum/armor/fortitude5

/datum/armor/fortitude5
	acid = 5 * AGGRAVATED_PROTECTION
	bio = 5 * AGGRAVATED_PROTECTION
	bomb = 5 * BASHING_LETHAL_PROTECTION
	bullet = 5 * BASHING_LETHAL_PROTECTION
	consume = 5 * BASHING_LETHAL_PROTECTION
	energy = 5 * BASHING_LETHAL_PROTECTION
	laser = 5 * BASHING_LETHAL_PROTECTION
	fire = 5 * AGGRAVATED_PROTECTION
	melee = 5 * BASHING_LETHAL_PROTECTION
	wound = 5 * BASHING_LETHAL_PROTECTION

#undef BASHING_LETHAL_PROTECTION
#undef AGGRAVATED_PROTECTION
