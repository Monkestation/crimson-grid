/datum/discipline/path/pain
	name = "Path of Pain"
	desc = "A path of Dark Thaumaturgy that allows the manipulation of pain. Violates Masquerade."
	icon = 'modular_vcg/modules/paths/icons/paths.dmi'
	icon_state = "pain"
	power_type = /datum/discipline_power/dark_thaumaturgy/path/pain


/datum/discipline_power/dark_thaumaturgy/path/pain
	name = "Dark Thaumaturgy: Path of Pain power name"
	desc = "Dark Thaumaturgy: Path of Pain description"

	activate_sound = 'modular_darkpack/modules/powers/sounds/thaum.ogg'

	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_TORPORED
	aggravating = TRUE
	hostile = TRUE
	violates_masquerade = FALSE
	range = 7

	cooldown_length = 3 TURNS
	var/success_roll
	var/use_counter = 0

/datum/storyteller_roll/path/pain
	applicable_stats = list(STAT_TEMPORARY_WILLPOWER)
	numerical = TRUE

/datum/discipline_power/dark_thaumaturgy/path/pain/pre_activation_checks(atom/target)
	. = ..()
	success_roll = SSroll.storyteller_roll_datum(owner, target, /datum/storyteller_roll/path/pain, 0, difficulty = (level + 3), STAT_OCCULT, FALSE)
	if(success_roll <= 0)
		owner.visible_message(span_notice("You see [owner] shudder in pain, their whole body jerking."), span_danger("You shudder in pain, your body shaking."))
		pain_botch_effect()
		return FALSE
	return TRUE

/datum/discipline_power/dark_thaumaturgy/path/pain/activate(atom/target)
	. = ..()
	if(owner.has_status_effect(/datum/status_effect/pain_botch))
		use_counter++
		if(use_counter == 3)
			owner.remove_status_effect(/datum/status_effect/pain_botch)
			use_counter = 0

/datum/discipline_power/dark_thaumaturgy/path/pain/numbing
	name = "Numbing"
	desc = "Become one with pain, ignoring the negative effects of pain as you become wounded."
	level = 1
	toggled = TRUE
	duration_length = 45 SECONDS
	grouped_powers = list(
		/datum/discipline_power/dark_thaumaturgy/path/pain/anguish,
		/datum/discipline_power/dark_thaumaturgy/path/pain/shattering,
		/datum/discipline_power/dark_thaumaturgy/path/pain/agony_within,
		/datum/discipline_power/dark_thaumaturgy/path/pain/hundred_deaths
	)

/datum/discipline_power/dark_thaumaturgy/path/pain/numbing/activate(atom/target)
	. = ..()
	if(HAS_TRAIT(owner, TRAIT_PAIN_BOTCH))
		owner.apply_damage(50, STAMINA)
	ADD_TRAIT(owner, TRAIT_IGNORESLOWDOWN, MAGIC_TRAIT)
	owner.visible_message(span_notice("[owner] twitches in pleasure!"), span_warning("You twitch in pleasure!"))

/datum/discipline_power/dark_thaumaturgy/path/pain/numbing/deactivate(atom/target)
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_IGNORESLOWDOWN, MAGIC_TRAIT)

/datum/discipline_power/dark_thaumaturgy/path/pain/anguish
	name = "Anguish"
	desc = "Infict pain upon another, causing them to writhe in agony."
	level = 2
	range = 1
	target_type = TARGET_MOB
	grouped_powers = list(
		/datum/discipline_power/dark_thaumaturgy/path/pain/numbing,
		/datum/discipline_power/dark_thaumaturgy/path/pain/shattering,
		/datum/discipline_power/dark_thaumaturgy/path/pain/agony_within,
		/datum/discipline_power/dark_thaumaturgy/path/pain/hundred_deaths
	)


/datum/discipline_power/dark_thaumaturgy/path/pain/anguish/activate(atom/target)
	. = ..()
	var/stamina_loss = min(success_roll * 12.5, 75)
	var/mob/living/tar = target
	tar.apply_damage(stamina_loss, STAMINA)
	tar.visible_message(span_notice("[target] grabs their chest in pain!"), span_danger("You grab your heart, feeling burning pain!"))
	if(HAS_TRAIT(owner, TRAIT_PAIN_BOTCH))
		owner.apply_damage(stamina_loss, STAMINA)
		owner.visible_message(span_notice("[owner] grabs their chest in pain!"), span_danger("You grab your heart, feeling burning pain!"))


/datum/discipline_power/dark_thaumaturgy/path/pain/shattering
	name = "Shattering"
	desc = "Inflict sigificant wounds upon another, causing them true pain."
	level = 3
	target_type = TARGET_MOB
	grouped_powers = list(
		/datum/discipline_power/dark_thaumaturgy/path/pain/anguish,
		/datum/discipline_power/dark_thaumaturgy/path/pain/numbing,
		/datum/discipline_power/dark_thaumaturgy/path/pain/agony_within,
		/datum/discipline_power/dark_thaumaturgy/path/pain/hundred_deaths
	)

	var/brute_loss = 25
	var/willpower_resist


/datum/discipline_power/dark_thaumaturgy/path/pain/shattering/activate(atom/target)
	. = ..()
	brute_loss = clamp(success_roll * 12.5, 12.5, 75)
	willpower_resist = SSroll.storyteller_roll_datum(target, target, /datum/storyteller_roll/path/pain, 0, 6, STAT_TEMPORARY_WILLPOWER, TRUE)
	owner.apply_damage(12.5, BRUTE)
	var/mob/living/tar = target
	tar.apply_damage(brute_loss/willpower_resist, BRUTE)
	tar.visible_message(span_warning("You hear [tar]'s bones crunch!"), span_danger("You hear your bones crunch!"))
	playsound(tar, "sound/effects/wounds/crack1.ogg", 50)
	if(HAS_TRAIT(owner, TRAIT_PAIN_BOTCH))
		willpower_resist = SSroll.storyteller_roll_datum(owner, owner, /datum/storyteller_roll/path/pain, 0, 6, STAT_TEMPORARY_WILLPOWER, TRUE)
		owner.apply_damage(brute_loss/willpower_resist, BRUTE)
		owner.visible_message(span_warning("You hear [owner]'s bones crunch!"), span_danger("You hear your bones crunch!"))
		playsound(owner, "sound/effects/wounds/crack2.ogg", 50)

/datum/discipline_power/dark_thaumaturgy/path/pain/agony_within
	name = "Agony Within"
	desc = "At some personal cost, inflict great pain upon another."
	target_type = TARGET_MOB
	grouped_powers = list(
		/datum/discipline_power/dark_thaumaturgy/path/pain/anguish,
		/datum/discipline_power/dark_thaumaturgy/path/pain/shattering,
		/datum/discipline_power/dark_thaumaturgy/path/pain/numbing,
		/datum/discipline_power/dark_thaumaturgy/path/pain/hundred_deaths
	)

	var/success_roll_buff = 0
	var/success_roll_defender = 0
	var/success_roll_total = 0
	var/total_health_loss


/datum/discipline_power/dark_thaumaturgy/path/pain/agony_within/pre_activation_checks(atom/target)
	. = ..()
	total_health_loss = round(owner.maxHealth - owner.health, 0.01)
	if(total_health_loss < 1)
		to_chat(owner, span_warning("You're not suffering from pain enough to use this ability!"))
		owner.bloodpool += 1
		return FALSE
	return TRUE

/datum/discipline_power/dark_thaumaturgy/path/pain/agony_within/activate(atom/target)
	. = ..()

	total_health_loss = round(owner.maxHealth - owner.health, 0.01)

	success_roll_buff = clamp(success_roll+max(1, total_health_loss), 0, 10)

	success_roll_defender = SSroll.storyteller_roll_datum(target, target, /datum/storyteller_roll/path/pain, 0, 6, STAT_TEMPORARY_WILLPOWER, TRUE)

	success_roll_total = max(0, success_roll_buff - floor(max(0, success_roll_defender/2)))

	var/mob/living/tar = target

	tar.apply_damage(12.5*success_roll_total, BRUTE)

	tar.visible_message(span_warning("You hear [tar]'s spine snap!"), span_danger("You hear your spine snap!"))

	playsound(tar, "sound/effects/wounds/crack1.ogg", 50)
	if(HAS_TRAIT(owner, TRAIT_PAIN_BOTCH))
		success_roll_defender = SSroll.storyteller_roll_datum(owner, owner, /datum/storyteller_roll/path/pain, 0, 6, STAT_TEMPORARY_WILLPOWER, TRUE)

		success_roll_total = max(0, success_roll_buff - floor(max(0, success_roll_defender/2)))

		owner.apply_damage(12.5*success_roll_total, BRUTE)

		owner.visible_message(span_warning("You hear [owner]'s spine snap!"), span_danger("You hear your spine snap!"))

		playsound(owner, "sound/effects/wounds/crack2.ogg", 50)

/datum/discipline_power/dark_thaumaturgy/path/pain/hundred_deaths
	name = "Hundred Deaths"
	desc = "Tear flesh from bones, crush bones, and rip internal organs with a single glance or word"
	level = 5
	target_type = TARGET_MOB
	grouped_powers = list(
		/datum/discipline_power/dark_thaumaturgy/path/pain/anguish,
		/datum/discipline_power/dark_thaumaturgy/path/pain/shattering,
		/datum/discipline_power/dark_thaumaturgy/path/pain/agony_within,
		/datum/discipline_power/dark_thaumaturgy/path/pain/numbing
	)

	var/success_needed = 0
	var/total_brute = 0

/datum/discipline_power/dark_thaumaturgy/path/pain/hundred_deaths/activate(atom/target)
	. = ..()
	success_needed = SSroll.storyteller_roll_datum(target, target, /datum/storyteller_roll/path/pain, 0, 6, STAT_TEMPORARY_WILLPOWER, TRUE)
	if(success_needed <= 0)
		to_chat(owner, span_warning("You fail to inflict enough wounds to yourself to use that ability!"))
		owner.do_jitter_animation(3 SECONDS)
		return
	owner.apply_damage(12.5, BRUTE)
	total_brute = clamp(12.5*success_needed, 12.5, 125)
	var/mob/living/tar = target
	tar.apply_damage(total_brute, BRUTE)
	if(iscarbon(tar))
		var/mob/living/carbon/C = tar
		C.apply_status_effect(/datum/status_effect/hundred_deaths)
	playsound(tar, "sound/effects/wounds/crack1.ogg", 50)
	if(HAS_TRAIT(owner, TRAIT_PAIN_BOTCH))
		owner.apply_damage(total_brute, BRUTE)
		owner.apply_status_effect(/datum/status_effect/hundred_deaths)
		playsound(owner, "sound/effects/wounds/crack2.ogg", 50)
