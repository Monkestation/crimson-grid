/datum/discipline/thanatosis
	name = "Thanatosis"
	desc = "Offers control over your own rotted body"
	icon_state = "thanatosis"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/thanatosis

/datum/discipline_power/thanatosis
	name = "Thanatosis power name"
	desc = "Thanatosis power description"

//HAG'S WRINKLES
/datum/discipline_power/thanatosis/hag_wrinkles
	name = "Hag's Wrinkles"
	desc = "Morph your flesh to allow you to store items inside your skin."

	level = 1
	check_flags = DISC_CHECK_CONSCIOUS
	vitae_cost = 1

	activate_sound = 'modular_darkpack/modules/ritual_necromancy/sounds/necromancy1on.ogg'
	deactivate_sound = 'modular_darkpack/modules/ritual_necromancy/sounds/necromancy1off.ogg'

	cancelable = TRUE
	duration_length = 1 HOURS
	var/datum/storyteller_roll/hags_wrinkles/hags_wrinkles_roll

/datum/storyteller_roll/hags_wrinkles
	bumper_text = "hag's wrinkles"
	applicable_stats = list(STAT_STAMINA, STAT_SUBTERFUGE)
	roll_output_type = ROLL_PRIVATE

/obj/item/implant/storage/thanatosis
	name = "hag's wrinkles"
	desc = "Your skin has numerous folds, convenient pockets for items you may want to conceal"

/datum/discipline_power/thanatosis/hag_wrinkles/pre_activation_checks()
	. = ..()
	if(!hags_wrinkles_roll)
		hags_wrinkles_roll = new()
	var/roll = hags_wrinkles_roll.st_roll(owner, owner)
	if(roll == ROLL_SUCCESS)
		return TRUE
	else
		return FALSE

/datum/discipline_power/thanatosis/hag_wrinkles/activate()
	. = ..()
	var/obj/item/implant/storage/thanatosis/imp = new()
	imp.implant(owner, owner)


/datum/discipline_power/thanatosis/hag_wrinkles/deactivate()
	. = ..()
	for(var/obj/item/implant/storage/thanatosis/imp in owner.implants)
		imp.removed(owner)

//PUTREFACTION
/datum/discipline_power/thanatosis/putrefaction
	name = "Putrefaction"
	desc = "Use your power over rot and decay to deal damage and cause muscle and bone decay inside your target."

	level = 2
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND | DISC_CHECK_IMMOBILE
	target_type = TARGET_LIVING
	vitae_cost = 1

	effect_sound = 'modular_darkpack/modules/ritual_necromancy/sounds/necromancy2.ogg'

	violates_masquerade = TRUE

	range = 1
	cooldown_length = 5 SECONDS
	var/successes
	var/datum/storyteller_roll/putrefaction/putrefaction_roll

/datum/storyteller_roll/putrefaction/putrefaction_roll
	bumper_text = "putrefaction"
	applicable_stats = list(STAT_DEXTERITY, STAT_MEDICINE)
	numerical = TRUE
	roll_output_type = ROLL_PRIVATE_AND_TARGET

/datum/discipline_power/thanatosis/putrefaction/pre_activation_checks(mob/living/target)
	. = ..()
	if(!putrefaction_roll)
		putrefaction_roll = new()
	var/fortitudelevel
	var/datum/splat/vampire/kindred/kindred_splat = get_kindred_splat(target)
	if(kindred_splat)
		var/datum/discipline/fortitude/fortitude_check = kindred_splat.get_discipline(/datum/discipline/fortitude)
		if(fortitude_check)
			fortitudelevel = fortitude_check.level


	putrefaction_roll.difficulty = (target.st_get_stat(STAT_STAMINA) + fortitudelevel)
	successes = putrefaction_roll.st_roll(owner, target)

	if(successes > 0)
		return TRUE
	else
		to_chat(owner, span_warning("Putrefaction has failed to affect [target]!"))
		return FALSE

/datum/discipline_power/thanatosis/putrefaction/activate(mob/living/target)
	. = ..()
	target.adjust_brute_loss(successes * 25)
	target.apply_status_effect(STATUS_EFFECT_PUTREFACTION, owner)

//ASHES TO ASHES
/mob/living/basic/samedi_ash_pile
	name = "ash pile"
	desc = "Ashes to ashes, dust to dust, and into space."
	icon = 'icons/obj/debris.dmi'
	icon_state = "ash"
	icon_living = "ash"
	speed = 2 //'the character cannot move'
	maxHealth = 1000
	health = 1000
	melee_damage_lower = 1
	melee_damage_upper = 1
	attack_verb_continuous = "splashes"
	attack_verb_simple = "splash"

/datum/action/cooldown/spell/shapeshift/samedi_ash
	name = "Ashes to Ashes"
	desc = "Turn into ash to hide."
	button_icon = 'modular_darkpack/modules/vampire_the_masquerade/icons/vampire_clans.dmi'
	button_icon_state = "thanatosis"
	background_icon = 'modular_darkpack/master_files/icons/mob/actions/backgrounds.dmi'
	background_icon_state = "bg_discipline"
	spell_requirements = NONE
	cooldown_time = 5 SECONDS
	revert_on_death = TRUE
	die_with_shapeshifted_form = FALSE
	possible_shapes = list(/mob/living/basic/samedi_ash_pile)
	convert_damage = TRUE
	convert_damage_type = BRUTE

/datum/discipline_power/thanatosis/ashes_to_ashes
	name = "Ashes to Ashes"
	desc = "Turn into ash to hide."

	level = 3
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND | DISC_CHECK_IMMOBILE
	vitae_cost = 2

	activate_sound = 'modular_darkpack/modules/ritual_necromancy/sounds/necromancy3.ogg'

	violates_masquerade = TRUE
	toggled = TRUE
	cancelable = TRUE
	duration_length = 0
	cooldown_length = 1 TURNS

	var/datum/action/cooldown/spell/shapeshift/samedi_ash/dust_transformation

/datum/discipline_power/thanatosis/ashes_to_ashes/activate()
	. = ..()
	if(dust_transformation)
		CRASH("[src] somehow already has a spell?")
	owner.drop_all_held_items()
	dust_transformation = new(owner.mind)
	dust_transformation.Grant(owner)
	dust_transformation.Activate(owner)
	RegisterSignal(owner, COMSIG_LIVING_RETURNED_FROM_SHAPESHIFT, PROC_REF(deactivate))

/datum/discipline_power/thanatosis/ashes_to_ashes/deactivate()
	UnregisterSignal(owner, COMSIG_LIVING_RETURNED_FROM_SHAPESHIFT)
	. = ..()
	dust_transformation.Remove(owner)
	QDEL_NULL(dust_transformation)
	owner.Stun(1.5 SECONDS)
	owner.do_jitter_animation(30)


//WITHERING
/datum/discipline_power/thanatosis/withering
	name = "Withering"
	desc = "Instantly wither an opponent's body with a mere touch, causing a limb to wither to pieces."

	level = 4
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND | DISC_CHECK_IMMOBILE
	target_type = TARGET_LIVING
	range = 1
	willpower_cost = 1
	vitae_cost = 0

	effect_sound = 'modular_darkpack/modules/ritual_necromancy/sounds/necromancy4.ogg'

	aggravating = TRUE
	hostile = TRUE
	violates_masquerade = TRUE

	cooldown_length = 1 TURNS
	var/successes
	var/datum/storyteller_roll/withering/withering_roll

/datum/storyteller_roll/withering
	bumper_text = "withering"
	applicable_stats = list(STAT_MANIPULATION, STAT_MEDICINE)
	numerical = TRUE
	roll_output_type = ROLL_PRIVATE_AND_TARGET

/datum/discipline_power/thanatosis/withering/pre_activation_checks(mob/living/target)
	. = ..()
	if(!withering_roll)
		withering_roll = new()
	var/fortitudelevel
	var/datum/splat/vampire/kindred/kindred_splat = get_kindred_splat(target)
	if(kindred_splat)
		var/datum/discipline/fortitude/fortitude_check = kindred_splat.get_discipline(/datum/discipline/fortitude)
		if(fortitude_check)
			fortitudelevel = fortitude_check.level

	withering_roll.difficulty = (target.st_get_stat(STAT_STAMINA) + fortitudelevel)
	successes = withering_roll.st_roll(owner, target)

	if(successes > 0)
		return TRUE
	else
		to_chat(owner, span_warning("Withering has failed to affect [target]!"))
		return FALSE

/datum/discipline_power/thanatosis/withering/activate(mob/living/target)
	. = ..()

	if((successes >= 1) && (successes < 3))
		target.adjust_stamina_loss(60)
	else if(successes >= 3)
		//this ability used to call dismember on chest and head bodyparts. this was an instant round removal, so i changed it so that it just takes away limbs if targeting head or chest
		if(iscarbon(target))
			var/mob/living/carbon/deady = target
			var/obj/item/bodypart/target_part = deady.get_bodypart(check_zone(owner.zone_selected))
			var/list/limb_priority = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
			var/obj/item/bodypart/chosen_part
			//if they have a limb selected that isnt chest or head
			if(target_part && !istype(target_part, /obj/item/bodypart/chest) && !istype(target_part, /obj/item/bodypart/head))
				chosen_part = target_part
			//then pick from limb_priority
			else
				for(var/zone in limb_priority)
					var/obj/item/bodypart/limb = deady.get_bodypart(zone)
					if(limb)
						chosen_part = limb
						break
			if(chosen_part)
				target.visible_message(span_danger("[target]'s [chosen_part.name] withers into nothingness!"), span_userdanger("YOUR <b>[chosen_part.name]</b> WITHERS INTO NOTHING!"))
				chosen_part.dismember(BURN)
			else
				target.visible_message(span_danger("[target]'s body withers under the curse!"), span_userdanger("YOUR BODY WITHERS UNDER THE CURSE!"))
				target.adjust_brute_loss(150)
		else
			target.adjust_brute_loss(150)

//NECROSIS
/datum/discipline_power/thanatosis/necrosis
	name = "Necrosis"
	desc = "Cause advanced decay in your victim - similar to Putrefaction, but with much stronger decay."

	level = 5
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND | DISC_CHECK_IMMOBILE
	target_type = TARGET_HUMAN
	vitae_cost = 2
	range = 1
	effect_sound = 'modular_darkpack/modules/ritual_necromancy/sounds/necromancy5.ogg'

	aggravating = TRUE
	hostile = TRUE
	violates_masquerade = TRUE

	cooldown_length = 5 SECONDS
	var/successes
	var/datum/storyteller_roll/necrosis/necrosis_roll

/datum/storyteller_roll/necrosis
	bumper_text = "necrosis"
	applicable_stats = list(STAT_DEXTERITY, STAT_MEDICINE)
	numerical = TRUE
	roll_output_type = ROLL_PRIVATE_AND_TARGET

/datum/discipline_power/thanatosis/necrosis/pre_activation_checks(mob/living/carbon/human/target)
	. = ..()
	if(!necrosis_roll)
		necrosis_roll = new()
	var/fortitudelevel
	var/mob/living/carbon/human/vampire = target
	var/datum/splat/vampire/kindred/kindred_splat = get_kindred_splat(vampire)
	if(kindred_splat)
		var/datum/discipline/fortitude/fortitude_check = kindred_splat.get_discipline(/datum/discipline/fortitude)
		if(fortitude_check)
			fortitudelevel = fortitude_check.level

	necrosis_roll.difficulty = (target.st_get_stat(STAT_STAMINA) + fortitudelevel)
	successes = necrosis_roll.st_roll(owner, target)

	if(successes > 0)
		return TRUE
	else
		to_chat(owner, span_warning("Necrosis has failed to affect [target]!"))
		return FALSE

/datum/discipline_power/thanatosis/necrosis/activate(mob/living/carbon/human/target)
	. = ..()
	target.adjust_brute_loss(3 TTRPG_DAMAGE)

	if(successes <= 1)
		to_chat(owner, span_warning("Necrosis has failed to affect [target]!"))
		return
	switch(successes)
		if(1)
			return
		if(2)
			target.apply_status_effect(STATUS_EFFECT_PUTREFACTION, owner)
		if(3)
			target.apply_status_effect(STATUS_EFFECT_PUTREFACTION, owner)
			if(iscarbon(target))
				for(var/i in target.bodyparts)
					var/obj/item/bodypart/bodypart = i
					var/datum/wound/burn/flesh/moderate/burnt = new
					burnt.apply_wound(bodypart)
		if(4)
			target.apply_status_effect(STATUS_EFFECT_PUTREFACTIONTWO, owner)
			if(iscarbon(target))
				for(var/i in target.bodyparts)
					var/obj/item/bodypart/bodypart = i
					var/datum/wound/burn/flesh/severe/burnt = new
					burnt.apply_wound(bodypart)
		if(5)
			target.apply_status_effect(STATUS_EFFECT_PUTREFACTIONTHREE, owner)
			if(iscarbon(target))
				for(var/i in target.bodyparts)
					var/obj/item/bodypart/bodypart = i
					var/datum/wound/burn/flesh/critical/burnt = new
					burnt.apply_wound(bodypart)
		else
			target.apply_status_effect(STATUS_EFFECT_PUTREFACTIONFOUR, owner)
			if(iscarbon(target))
				for(var/i in target.bodyparts)
					var/obj/item/bodypart/bodypart = i
					var/datum/wound/burn/flesh/critical/burnt = new
					burnt.apply_wound(bodypart)
