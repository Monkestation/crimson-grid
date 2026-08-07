#define HEAL_BASHING_LETHAL_DAMAGE 30
#define HEAL_AGGRAVATED_DAMAGE 6

/datum/discipline/bloodheal
	name = "Bloodheal"
	desc = "Use the power of your Vitae to mend your flesh."
	icon_state = "bloodheal"
	power_type = /datum/discipline_power/bloodheal
	selectable = FALSE

/datum/storyteller_roll/bloodheal
	bumper_text = "Bloodheal"
	difficulty = 8
	applicable_stats = list(STAT_STAMINA, STAT_SURVIVAL)
	roll_output_type = ROLL_PRIVATE

/datum/discipline_power/bloodheal
	name = "Bloodheal power name"
	desc = "Bloodheal power description"

	activate_sound = 'modular_darkpack/modules/vampire_the_masquerade/sounds/bloodhealing.ogg'

	level = 1
	check_flags = DISC_CHECK_TORPORED
	vitae_cost = 1

	violates_masquerade = FALSE

	cooldown_length = 1 TURNS

	grouped_powers = list(
		/datum/discipline_power/bloodheal/one,
		/datum/discipline_power/bloodheal/two,
		/datum/discipline_power/bloodheal/three,
		/datum/discipline_power/bloodheal/four,
		/datum/discipline_power/bloodheal/five,
		/datum/discipline_power/bloodheal/six,
		/datum/discipline_power/bloodheal/seven,
		/datum/discipline_power/bloodheal/eight,
		/datum/discipline_power/bloodheal/nine,
		/datum/discipline_power/bloodheal/ten
	)

	var/datum/storyteller_roll/bloodheal/bloodheal_roll

/datum/discipline_power/bloodheal/pre_activation_checks(atom/target)
	. = ..()
	if(do_after(owner, 1 TURNS, timed_action_flags = DO_AFTER_CHECK_NEXT_MOVE | IGNORE_INCAPACITATED))
		return TRUE
	if(!bloodheal_roll)
		bloodheal_roll = new()
	var/roll_result = bloodheal_roll.st_roll(owner, src)
	to_chat(owner, span_warning("You break your concentration..."))
	switch(roll_result)
		if(ROLL_SUCCESS)
			to_chat(owner, span_notice("But you succeed in mending your wounds."))
			return TRUE
		if(ROLL_FAILURE)
			to_chat(owner, span_warning("And fail to harness your blood."))
			return FALSE
		if(ROLL_BOTCH)
			to_chat(owner, span_danger("And worsen your wounds."))
			owner.adjust_blood_pool(-1)
			owner.apply_damage(1 TTRPG_DAMAGE, BRUTE)
			return FALSE

/datum/discipline_power/bloodheal/activate()
	. = ..()

	//normal bashing/lethal damage
	owner.heal_ordered_damage(HEAL_BASHING_LETHAL_DAMAGE * vitae_cost, list(BRUTE, TOX, OXY, STAMINA))

	if(length(owner.all_wounds))
		for (var/i in 1 to min(vitae_cost, length(owner.all_wounds)))
			var/datum/wound/wound = owner.all_wounds[i]
			wound.remove_wound()

	//aggravated damage
	owner.heal_ordered_damage(HEAL_AGGRAVATED_DAMAGE * vitae_cost, list(BURN, AGGRAVATED))

	//brain damage and traumas healing
	var/obj/item/organ/brain/brain = owner.get_organ_slot(ORGAN_SLOT_BRAIN)
	if (brain)
		brain.apply_organ_damage(-HEAL_BASHING_LETHAL_DAMAGE * vitae_cost)

		for (var/i in 1 to min(vitae_cost, length(brain.get_traumas_type())))
			var/datum/brain_trauma/healing_trauma = pick(brain.get_traumas_type())
			brain.cure_trauma_type(healing_trauma, resilience = TRAUMA_RESILIENCE_WOUND)

	// Let core species logic handle restoring/healing organs so missing eyes are rebuilt correctly.
	owner.regenerate_organs()
	var/obj/item/organ/eyes/eyes = owner.get_organ_slot(ORGAN_SLOT_EYES)
	if (!eyes)
		var/eyes_type = owner.dna?.species?.get_mutant_organ_type_for_slot(ORGAN_SLOT_EYES) || /obj/item/organ/eyes
		eyes = new eyes_type()
		eyes.Insert(owner, special = TRUE, movement_flags = DELETE_IF_REPLACED)
	owner.cure_blind(NO_EYES)
	if(!owner.has_quirk(/datum/quirk/item_quirk/blindness))
		owner.cure_blind(QUIRK_TRAIT)
	owner.cure_blind(EYE_DAMAGE)
	owner.cure_blind(EYE_SCARRING_TRAIT)
	owner.cure_nearsighted(QUIRK_TRAIT)
	owner.cure_nearsighted(EYE_DAMAGE)
	if (eyes)
		eyes.fix_scar(LEFT_EYE_SCAR)
		eyes.fix_scar(RIGHT_EYE_SCAR)
	owner.remove_status_effect(/datum/status_effect/temporary_blindness)
	owner.remove_status_effect(/datum/status_effect/eye_blur)

	if(get_kindred_splat(owner) && length(owner.get_missing_limbs()))
		owner.regenerate_limbs()
		violates_masquerade = TRUE

	//healing too quickly attracts attention
	if (violates_masquerade)
		owner.visible_message(
			span_warning("[owner]'s wounds heal with unnatural speed!"),
			span_warning("Your wounds visibly heal with unnatural speed!")
		)

	//update UI
	owner.update_damage_overlays()
	owner.update_health_hud()

/datum/discipline_power/bloodheal/spend_resources()
	adjust_vitae_cost()

	. = ..()

/datum/discipline_power/bloodheal/proc/adjust_vitae_cost()
	vitae_cost = initial(vitae_cost)
	//tally up damage
	var/total_bashing_lethal_damage = owner.get_brute_loss() + owner.get_tox_loss() + owner.get_oxy_loss()
	var/total_aggravated_damage = owner.get_agg_loss() + owner.get_fire_loss()

	//lower blood expenditure to what's necessary
	var/vitae_to_heal_bashing_lethal = ceil(total_bashing_lethal_damage / HEAL_BASHING_LETHAL_DAMAGE)
	var/vitae_to_heal_aggravated = ceil(total_aggravated_damage / HEAL_AGGRAVATED_DAMAGE)

	var/vitae_needed = max(vitae_to_heal_bashing_lethal, vitae_to_heal_aggravated)

	//vitae used to heal is the smaller of max vitae expenditure and what's needed to heal the damage
	vitae_cost = max(min(vitae_cost, vitae_needed), 1)

	//healing is a masquerade breach if it's done at level 3 and above
	if (vitae_cost > 2)
		violates_masquerade = TRUE
	else
		violates_masquerade = FALSE

//BLOODHEAL 1
/datum/discipline_power/bloodheal/one
	name = "Minor Bloodheal"
	desc = "Slowly mend your undead flesh."

	level = 1
	vitae_cost = 1

	violates_masquerade = FALSE

//BLOODHEAL 2
/datum/discipline_power/bloodheal/two
	name = "Bloodheal"
	desc = "Mend your undead flesh."

	level = 2
	vitae_cost = 2

	violates_masquerade = FALSE

//BLOODHEAL 3
/datum/discipline_power/bloodheal/three
	name = "Quick Bloodheal"
	desc = "Mend your undead flesh with unnatural speed."

	level = 3
	vitae_cost = 3

	violates_masquerade = TRUE

//BLOODHEAL 4
/datum/discipline_power/bloodheal/four
	name = "Major Bloodheal"
	desc = "Heal even the most grievous wounds in short order."

	level = 4
	vitae_cost = 4

	violates_masquerade = TRUE

//BLOODHEAL 5
/datum/discipline_power/bloodheal/five
	name = "Greater Bloodheal"
	desc = "Regrow entire bodyparts without breaking a sweat."

	level = 5
	vitae_cost = 5

	violates_masquerade = TRUE

//BLOODHEAL 6
/datum/discipline_power/bloodheal/six
	name = "Grand Bloodheal"
	desc = "Regrow entire bodyparts without breaking a sweat."

	level = 6
	vitae_cost = 6

	violates_masquerade = TRUE

//BLOODHEAL 7
/datum/discipline_power/bloodheal/seven
	name = "Grand Bloodheal"
	desc = "Reconstitute your body from near nothing."

	level = 7
	vitae_cost = 7

	violates_masquerade = TRUE

//BLOODHEAL 8
/datum/discipline_power/bloodheal/eight
	name = "Godlike Bloodheal"
	desc = "On the edge of Final Death, let your blood explode outwards and recreate you."

	level = 8
	vitae_cost = 8

	violates_masquerade = TRUE

//BLOODHEAL 9
/datum/discipline_power/bloodheal/nine
	name = "Surpassing Bloodheal"
	desc = "Even as a titanic beast, you could restore your physical form in short order."

	level = 9
	vitae_cost = 9

	violates_masquerade = TRUE

//BLOODHEAL 10
/datum/discipline_power/bloodheal/ten
	name = "Ascended Bloodheal"
	desc = "So long as you have access to blood, you cannot die. Your curse will not allow it."

	level = 10
	vitae_cost = 10

	violates_masquerade = TRUE

#undef HEAL_BASHING_LETHAL_DAMAGE
#undef HEAL_AGGRAVATED_DAMAGE
