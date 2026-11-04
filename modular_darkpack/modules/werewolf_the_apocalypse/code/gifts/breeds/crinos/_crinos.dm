/**
 * The Garou knows the trick of shedding and growing fur at an alarming rate.
 * This Gift makes the Garou especially difficult to grapple successfully; opponents find themselves
 * holding tufts of fur instead of their target. The Garou can also slide through tight spaces
 * using his shedding fur as natural lubrication. A lizard-spirit or snake-spirit teaches this Gift.
 *
 * The Garou may use his slick outer coating to avoid being grappled.
 * With a successful Dexterity + Primal-Urge roll (difficulty 7), he can free himself
 * from any successful grappling attack. The fur also reduces by two the werewolf’s difficulty
 * whenever he squeezes through tight spaces or slips restraints, such as handcuffs.
 *
 */
/datum/action/cooldown/power/gift/shed
	name = "Shed"
	desc = "The Garou knows the trick of shedding and growing fur at an alarming rate."
	button_icon_state = "shed"
	rank = 1
	cooldown_time = 1 TURNS
	var/datum/storyteller_roll/gift/shed/roll

/datum/action/cooldown/power/gift/shed/New()
	. = ..()
	roll = new()

/datum/action/cooldown/power/gift/shed/Destroy()
	QDEL_NULL(roll)
	return ..()

/datum/action/cooldown/power/gift/shed/Activate(atom/target)
	var/mob/living/carbon/carbon_owner = astype(owner)
	if(!carbon_owner)
		return FALSE // eh

	if(!carbon_owner.pulledby && !carbon_owner.handcuffed && !carbon_owner.legcuffed)
		to_chat(carbon_owner, span_warning("No one is grappling or restraining you, all this would amount to is theatrics."))
		return FALSE

	. = ..()

	var/roll_result = roll.st_roll(carbon_owner, bonus_added = PRIMAL_URGE_PLACEHOLDER)
	if(roll_result != ROLL_SUCCESS)
		return TRUE

	carbon_owner.apply_status_effect(/datum/status_effect/shed)
	return TRUE


/datum/status_effect/shed
	id = "shed"
	duration = 1 SCENES // duration higher than gift CD. we just refresh

	status_type = STATUS_EFFECT_REPLACE

	alert_type = /atom/movable/screen/alert/status_effect/gift/shed

/datum/status_effect/shed/on_apply()
	var/mob/living/carbon/carbon_owner = astype(owner)
	if(!carbon_owner)
		return FALSE // eh

	. = ..()

	if(carbon_owner.pulledby)
		to_chat(carbon_owner, span_notice("You shed your fur, and [carbon_owner.pulledby] loses [carbon_owner.pulledby.p_their()] grip on you!"))
		carbon_owner.pulledby.stop_pulling()
	if(carbon_owner.handcuffed || carbon_owner.legcuffed)
		to_chat(carbon_owner, span_notice("You shed your fur, using the slick coating as lubrication to slip out of your restraints."))
		carbon_owner.uncuff()

/atom/movable/screen/alert/status_effect/gift/shed
	name = /datum/action/cooldown/power/gift/shed::name
	desc = "The shedding fur reduces the difficulty of slipping restraints by two."
	overlay_state = /datum/action/cooldown/power/gift/shed::button_icon_state


/datum/storyteller_roll/gift/shed
	bumper_text = "shedding fur"
	difficulty = 7
	applicable_stats = list(STAT_DEXTERITY)
