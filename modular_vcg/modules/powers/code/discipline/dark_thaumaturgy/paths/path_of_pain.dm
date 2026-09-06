/datum/discipline/path/pain
	name = "Path of Pain"
	desc = "A path of Dark Thaumaturgy that allows the manipulation of pain. Violates Masquerade."
	icon = 'modular_vcg/modules/paths/icons/paths.dmi'
	icon_state = "pain"
	power_type = /datum/discipline_power/dark_thaumaturgy/path/pain

/datum/discipline_power/dark_thaumaturgy/path/pain
	name = "Dark Thaumaturgy: Path of Pain Power Name"
	desc = "Dark Thaumaturgy: Path of Pain Power Description"

	activate_sound = 'modular_darkpack/modules/powers/sounds/thaum.ogg'

	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_TORPORED
	aggravating = TRUE
	hostile = TRUE
	violates_masquerade = FALSE
	range = 7

	cooldown_length = 3 TURNS
	var/success_count

/datum/storyteller_roll/path_of_pain
	applicable_stats = list(STAT_PERMANENT_WILLPOWER)
	numerical = TRUE
	roll_output_type = ROLL_PRIVATE_AND_TARGET

/datum/discipline_power/dark_thaumaturgy/path/pain/activate(atom/target)
	. = ..()
	success_count = SSroll.storyteller_roll_datum(owner, target, /datum/storyteller_roll/path_of_pain, difficulty = (level + 3))
	if(success_count < 0)
		owner.visible_message(span_notice("[owner] twitches in agony, scratching their skin."), \
			span_notice("You twitch in agony, scratching your skin."))
		pain_botch_effect()
		return TRUE
	else if(success_count == 0)
		to_chat(owner, span_notice("Your magic fizzles out!"))
		return TRUE
	return FALSE

/datum/discipline_power/dark_thaumaturgy/path/pain/proc/pain_botch_effect()
	owner.apply_status_effect(/datum/status_effect/pain_botch)

/datum/discipline_power/dark_thaumaturgy/path/pain/numbing
	name = "Numbing"
	desc = "Become one with pain, ignoring the negative effects of pain as you become wounded."

	level = 1
	aggravating = FALSE
	hostile = FALSE
	duration_length = 1 SCENES

/datum/discipline_power/dark_thaumaturgy/path/pain/numbing/activate(atom/target)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_PREVENT_HEALTH_UPDATES, PATH_OF_PAIN_TRAIT)
	ADD_TRAIT(owner, TRAIT_AGEUSIA, PATH_OF_PAIN_TRAIT)
	ADD_TRAIT(owner, TRAIT_IGNORESLOWDOWN, PATH_OF_PAIN_TRAIT)
	ADD_TRAIT(owner, TRAIT_NOSOFTCRIT, PATH_OF_PAIN_TRAIT)
	ADD_TRAIT(owner, TRAIT_NOHARDCRIT, PATH_OF_PAIN_TRAIT)
	owner.visible_message(span_notice("[owner] twitches in pleasure!"), \
			span_notice("You twitch in pleasure!"))

/datum/discipline_power/dark_thaumaturgy/path/pain/numbing/deactivate(atom/target)
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_PREVENT_HEALTH_UPDATES, PATH_OF_PAIN_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_AGEUSIA, PATH_OF_PAIN_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_IGNORESLOWDOWN, PATH_OF_PAIN_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_NOSOFTCRIT, PATH_OF_PAIN_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_NOHARDCRIT, PATH_OF_PAIN_TRAIT)

/datum/discipline_power/dark_thaumaturgy/path/pain/anguish
	name = "Anguish"
	desc = "Infict pain upon another, causing them to writhe in agony."
	level = 2
	range = 1
	target_type = TARGET_MOB
	aggravating = FALSE
	grouped_powers = list(
		/datum/discipline_power/dark_thaumaturgy/path/pain/shattering,
		/datum/discipline_power/dark_thaumaturgy/path/pain/agony_within,
		/datum/discipline_power/dark_thaumaturgy/path/pain/hundred_deaths
	)

/datum/discipline_power/dark_thaumaturgy/path/pain/anguish/activate(mob/living/target)
	if(..())
		return
	var/stamina_loss = success_count TTRPG_DAMAGE
	target.apply_damage(stamina_loss, STAMINA)
	target.visible_message(span_notice("[target] grabs their chest in pain!"), \
			span_notice("You grab your chest, feeling burning pain!"))
	if(HAS_TRAIT(owner, TRAIT_PAIN_BOTCH))
		owner.apply_damage(stamina_loss, STAMINA)
		owner.visible_message(span_notice("[owner] grabs their chest in pain!"), \
			span_notice("You grab your chest, feeling burning pain!"))

/datum/discipline_power/dark_thaumaturgy/path/pain/shattering
	name = "Shattering"
	desc = "Inflict sigificant wounds upon another, causing them true pain."
	level = 3
	target_type = TARGET_MOB
	grouped_powers = list(
		/datum/discipline_power/dark_thaumaturgy/path/pain/anguish,
		/datum/discipline_power/dark_thaumaturgy/path/pain/agony_within,
		/datum/discipline_power/dark_thaumaturgy/path/pain/hundred_deaths
	)

/datum/discipline_power/dark_thaumaturgy/path/pain/shattering/activate(mob/living/target)
	if(..())
		return
	owner.apply_damage(1 TTRPG_DAMAGE, BRUTE)
	var/will_resist = SSroll.storyteller_roll_datum(target, target, /datum/storyteller_roll/path_of_pain, difficulty = 6)
	target.apply_damage(max(0, (success_count - will_resist)) TTRPG_DAMAGE, BRUTE)
	playsound(target, "sound/effects/wounds/crack1.ogg", 50)
	target.visible_message(span_warning("[target]'s body does a horrifying cracking sound!"), \
			span_warning("You hear a horrifying cracking sound coming from your body!"))
	if(HAS_TRAIT(owner, TRAIT_PAIN_BOTCH))
		owner.apply_damage(success_count TTRPG_DAMAGE, BRUTE)
		playsound(owner, "sound/effects/wounds/crack2.ogg", 50)
		owner.visible_message(span_warning("[owner]'s body does a horrifying cracking sound!"), \
			span_warning("You hear a horrifying cracking sound coming from your body!"))

/datum/discipline_power/dark_thaumaturgy/path/pain/agony_within
	name = "Agony Within"
	desc = "At some personal cost, inflict great pain upon another."
	target_type = TARGET_MOB
	grouped_powers = list(
		/datum/discipline_power/dark_thaumaturgy/path/pain/anguish,
		/datum/discipline_power/dark_thaumaturgy/path/pain/shattering,
		/datum/discipline_power/dark_thaumaturgy/path/pain/hundred_deaths
	)

/datum/discipline_power/dark_thaumaturgy/path/pain/agony_within/activate(mob/living/target)
	if(..())
		return
	var/list/damage_choices = list(0, 10, 20, 30, 40)
	var/self_mutilation_bonus = tgui_input_list(owner, "How much damage will you deal to yourself? (This will make the roll harder for target)", "Agony Within", damage_choices)
	if(!self_mutilation_bonus)
		self_mutilation_bonus = 0
	self_mutilation_bonus /= 10
	owner.apply_damage(self_mutilation_bonus TTRPG_DAMAGE, BRUTE)
	success_count += self_mutilation_bonus
	var/will_success_count = SSroll.storyteller_roll_datum(target, target, /datum/storyteller_roll/path_of_pain, difficulty = 6+self_mutilation_bonus)
	var/will_endure = floor(will_success_count / 2)
	target.apply_damage(max(0, (success_count - will_endure)) TTRPG_DAMAGE, BRUTE)
	playsound(target, 'sound/items/weapons/whip.ogg', 50)
	target.visible_message(span_warning("Blood-thorn threads tear [target]'s flesh!"), \
			span_warning("Blood-thorn threads tear your flesh!"))
	if(HAS_TRAIT(owner, TRAIT_PAIN_BOTCH))
		owner.apply_damage(success_count TTRPG_DAMAGE, BRUTE)
		playsound(owner, 'sound/items/weapons/whip.ogg', 50)
		owner.visible_message(span_warning("Blood-thorn threads tear [owner]'s flesh!"), \
			span_warning("Blood-thorn threads tear your flesh!"))
	// There should be fortitude soak too but it's not implemented on cg and I'm not coding it

/datum/discipline_power/dark_thaumaturgy/path/pain/hundred_deaths
	name = "Hundred Deaths"
	desc = "Tear flesh from bones, crush bones, and rip internal organs with a single glance or word"
	level = 5
	target_type = TARGET_MOB
	grouped_powers = list(
		/datum/discipline_power/dark_thaumaturgy/path/pain/anguish,
		/datum/discipline_power/dark_thaumaturgy/path/pain/shattering,
		/datum/discipline_power/dark_thaumaturgy/path/pain/agony_within,
	)

/datum/discipline_power/dark_thaumaturgy/path/pain/hundred_deaths/activate(mob/living/target)
	var/will_success = SSroll.storyteller_roll_datum(owner, owner, /datum/storyteller_roll/path_of_pain, difficulty = 6)
	if(will_success <= 0)
		return
	owner.apply_damage(1 LETHAL_TTRPG_DAMAGE, AGGRAVATED)
	if(..())
		return
	target.apply_damage(success_count LETHAL_TTRPG_DAMAGE, AGGRAVATED)
	target.visible_message(span_warning("Deep cuts appear all over [target]'s body!"), \
			span_warning("Deep cuts appear all over your body, causing immense pain!"))
	target.emote("scream")
	if(HAS_TRAIT(owner, TRAIT_PAIN_BOTCH))
		owner.apply_damage(success_count LETHAL_TTRPG_DAMAGE, AGGRAVATED)
		owner.visible_message(span_warning("Deep cuts appear all over [owner]'s body!"), \
			span_warning("Deep cuts appear all over your body, causing immense pain!"))
		owner.emote("scream")
	// There should be fortitude soak too but it's not implemented on cg and I'm not coding it
