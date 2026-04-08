/datum/discipline/obeah
	name = "Obeah"
	desc = "Use your third eye in healing or protecting needs."
	icon_state = "obeah"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/obeah

/datum/discipline_power/obeah
	name = "Valeren power name"
	desc = "Valeren power description"

	activate_sound = 'modular_darkpack/modules/powers/sounds/obeah.ogg'

/datum/discipline_power/obeah/sense_vitality
	name = "Sense Vitality"
	desc = "Allows you to determine the vitality of a target."
	level = 1
	check_flags = DISC_CHECK_CAPABLE
	target_type = TARGET_HUMAN | TARGET_SELF
	range = 1
	cooldown_length = 3 TURNS
	duration_length = 1 TURNS
	activate_sound = null
	vitae_cost = 0
	var/successes = 0

	var/msg_creature = "" // what kinda phreak they is
	var/msg_damage = ""
	var/msg_blood = ""
	var/msg_disease = ""
	var/msg_mental = ""
	var/datum/storyteller_roll/sense_vitality/vitality_roll // defined in valeren.dm

/datum/discipline_power/obeah/sense_vitality/pre_activation_checks(mob/living/target)
	. = ..()
	if(!vitality_roll)
		vitality_roll = new()
	successes = vitality_roll.st_roll(owner, target)
	if(successes >= 1)
		return TRUE
	else
		return FALSE

/datum/discipline_power/obeah/sense_vitality/proc/blood_read(mob/living/carbon/human/target)
	var/blood_volume = target.get_blood_volume(apply_modifiers = TRUE)
	switch(blood_volume)
		if(BLOOD_VOLUME_EXCESS to INFINITY)
			return "Their veins are engorged to the point of rupture."
		if(BLOOD_VOLUME_MAXIMUM to BLOOD_VOLUME_EXCESS)
			return "They are heavily overloaded with blood."
		if(BLOOD_VOLUME_SAFE to BLOOD_VOLUME_MAXIMUM)
			return "Their blood volume is healthy."
		if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
			return "Their blood is lower than normal."
		if(BLOOD_VOLUME_RISKY to BLOOD_VOLUME_OKAY)
			return "Their blood volume is dangerously low."
		if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_RISKY)
			return "Dangerously low blood."
		if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
			return "They are nearly void of blood altogether. Death comes for them soon without immediate intervention."
		else
			return "They are completely exsanguinated."

/datum/discipline_power/obeah/sense_vitality/proc/damage_severity(damage)
	if(damage < 30)
		return "some"
	if(damage < 50)
		return "moderate"
	return "heavy"

/datum/discipline_power/obeah/sense_vitality/ui_state(mob/user)
	return GLOB.always_state

/datum/discipline_power/obeah/sense_vitality/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	var/datum/asset/valeren_files = get_asset_datum(/datum/asset/simple/valeren_assets)
	if(user.client)
		valeren_files.send(user.client)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new /datum/tgui(user, src, "Valeren")
		ui.open()

/datum/discipline_power/obeah/sense_vitality/ui_data(mob/living/user)
	var/list/data = list()
	data["creature"] = msg_creature
	data["damage"] = msg_damage
	data["blood"] = msg_blood
	data["disease"] = msg_disease
	data["mental"] = msg_mental
	return data

/datum/discipline_power/obeah/sense_vitality/activate(mob/living/target)
	. = ..()
	msg_creature = ""
	msg_damage = ""
	msg_blood = ""
	msg_disease = ""
	msg_mental = ""

	// on one success, identify their splat
	var/creature_type = "a mortal"
	if(get_kindred_splat(target))
		creature_type = "kindred"
	else if(get_ghoul_splat(target))
		creature_type = "a ghoul"
	else if(isavatar(target) || isobserver(target)) // because salubri spend all their time in the clinic anyway. they'll use this on ghosts
		creature_type = "a wraith"
	msg_creature = "[target] is [creature_type]."

	// on two successes, identify their damage
	if(successes >= 2)
		var/brute = target.get_brute_loss()
		var/burn = target.get_fire_loss()
		var/tox = target.get_tox_loss()
		var/oxy = target.get_oxy_loss()
		var/agg = target.get_agg_loss()
		var/list/damage_parts = list()
		if(brute > 0)
			damage_parts += "[damage_severity(brute)] bruising"
		if(burn > 0)
			damage_parts += "[damage_severity(burn)] burns"
		if(tox > 0)
			damage_parts += "[damage_severity(tox)] toxin damage"
		if(oxy > 0)
			damage_parts += "[damage_severity(oxy)] oxygen deprivation"
		if(agg > 0)
			damage_parts += "[damage_severity(agg)] supernatural wounds"
		msg_damage = length(damage_parts) ? "They bear [english_list(damage_parts)]." : "They appear uninjured."

	// on three successes, detect their bloodpool, if any exists
	if(successes >= 3)
		msg_blood = "[blood_read(target)] [round(target.bloodpool / target.maxbloodpool * 100)]% of Blood Pool remaining."

	// on four, display any diseases they might have
	if(successes >= 4)
		var/list/datum/disease/diseases = target.get_static_viruses()
		if(LAZYLEN(diseases))
			var/list/disease_names = list()
			for(var/datum/disease/D in diseases)
				disease_names += D.name
			msg_disease = "Detected [english_list(disease_names)] in their blood."
		else
			msg_disease = "Found no diseases in their blood."
		var/list/mental_conditions = list()
		if(target.has_quirk(/datum/quirk/insanity))
			mental_conditions += "insanity"
		if(target.has_quirk(/datum/quirk/darkpack/derangement))
			mental_conditions += "an incurable derangement"
		if(length(mental_conditions))
			msg_mental = "[english_list(mental_conditions)] clouds their mind."

	ui_interact(owner)
	to_chat(owner, span_notice("[msg_creature] \n[msg_damage] \n[msg_blood] \n[msg_disease] \n[msg_mental]"))

/datum/discipline_power/obeah/sense_vitality/deactivate()
	. = ..()

/datum/discipline_power/obeah/anesthetic_touch
	name = "Anesthetic Touch"
	desc = "Soothe your patient's pain, or place a mortal into peaceful slumber."
	level = 2
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND
	target_type = TARGET_LIVING
	range = 1
	cooldown_length = 3 TURNS
	var/sleep_duration_length = 10 TURNS
	var/soothe_duration_length = 1 SCENES
	var/successes = 0
	var/datum/storyteller_roll/anesthetic_touch/touch_roll // these are defined in valeren.dm
	var/datum/storyteller_roll/anesthetic_touch/unwilling/touch_roll_unwilling

/datum/discipline_power/obeah/anesthetic_touch/pre_activation_checks(mob/living/target)
	. = ..()
	var/datum/storyteller_roll/anesthetic_touch/roll_to_use
	if(target.combat_mode)
		if(!touch_roll_unwilling)
			touch_roll_unwilling = new()
		roll_to_use = touch_roll_unwilling
	else
		if(!touch_roll)
			touch_roll = new()
		roll_to_use = touch_roll
	successes = roll_to_use.st_roll(owner, target)
	if(successes >= 1)
		return TRUE
	else
		return FALSE

/datum/discipline_power/obeah/anesthetic_touch/activate(mob/living/target)
	. = ..()
	var/list/choices = list(
		"Soothe Pain" = icon('icons/mob/actions/actions_spells.dmi', "statue"),
		"Put To Sleep" = icon('icons/mob/actions/actions_spells.dmi', "blind"),
	)
	var/chosen_option = show_radial_menu(owner, target, choices, radius = 38, require_near = TRUE)
	switch(chosen_option)
		if("Soothe Pain")
			ADD_TRAIT(target, TRAIT_IGNORESLOWDOWN, type)
			addtimer(CALLBACK(src, PROC_REF(end_soothe_pain), target), (successes TURNS) + soothe_duration_length)
		if("Put To Sleep")
			if(get_kindred_splat(target))
				to_chat(owner, span_warning("You can't put a Kindred to sleep with this power!"))
				return TRUE
			target.SetSleeping(sleep_duration_length + (successes TURNS)) // 50 seconds + successes in turns
			target.adjust_blood_pool(1) // restores a BP to the target, but if this gets abused, maybe make this depend on successes
	return TRUE

/datum/discipline_power/obeah/anesthetic_touch/proc/end_soothe_pain(mob/living/target)
	REMOVE_TRAIT(target, TRAIT_IGNORESLOWDOWN, type)

/datum/discipline_power/obeah/corpore_sano
	name = "Corpore Sano"
	desc = "Lay hands on your patient and heal their wounds."

	level = 3
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND | DISC_CHECK_IMMOBILE
	target_type = TARGET_LIVING
	range = 1

	violates_masquerade = TRUE
	cooldown_length = 1 TURNS

/datum/discipline_power/obeah/corpore_sano/activate(atom/target)
	. = ..()
	var/mob/living/living_target = target
	if(living_target.get_agg_loss() && (owner.bloodpool >= 1))
		owner.adjust_blood_pool(-1)
		living_target.heal_storyteller_health(dots_to_heal = 1, heal_aggravated = TRUE, heal_scars = TRUE, heal_blood = TRUE)
	else
		living_target.heal_storyteller_health(dots_to_heal = 1, heal_aggravated = FALSE, heal_scars = TRUE, heal_blood = TRUE)

// Radius - the length of the line you draw from the central point of a circle towards any point of the outer boundary, which in geometry is called the circumference.
#define SHEPHERDS_WATCH_RADIUS 3
/datum/discipline_power/obeah/shepherds_watch
	name = "Shepherd's Watch"
	desc = "Create a supernatural barrier to protect yourself from harm."

	level = 4
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND | DISC_CHECK_IMMOBILE
	violates_masquerade = TRUE
	cooldown_length = 1 TURNS
	duration_length = 1 TURNS
	willpower_cost = 2
	cancelable = TRUE
	var/datum/proximity_monitor/advanced/shepherds_watch/area_of_effect

/datum/discipline_power/obeah/shepherds_watch/activate(atom/target)
	. = ..()
	area_of_effect = new(owner, SHEPHERDS_WATCH_RADIUS)
	for(var/mob/living/mob_living in range(SHEPHERDS_WATCH_RADIUS, owner))
		area_of_effect.ignored_mobs |= mob_living

/datum/discipline_power/obeah/shepherds_watch/duration_expire(atom/target)
	clear_duration_timer()
	owner.update_action_buttons()
	if(!check_discipline_flags())
		deactivate(owner, FALSE)
		return
	do_duration(owner)

/datum/discipline_power/obeah/shepherds_watch/deactivate(atom/target, direct)
	. = ..()
	QDEL_NULL(area_of_effect)

#undef SHEPHERDS_WATCH_RADIUS

/datum/discipline_power/obeah/unburden_the_bestial_soul
	name = "Unburden The Bestial Soul"
	desc = "Draw out a Kindred's soul and heal it of impurities."

	level = 5
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND | DISC_CHECK_IMMOBILE
	violates_masquerade = TRUE
	cooldown_length = 1 TURNS
	vitae_cost = 2
	target_type = TARGET_LIVING
	range = 1
	var/datum/storyteller_roll/unburden_the_bestial_soul/discipline_roll

/datum/storyteller_roll/unburden_the_bestial_soul
	bumper_text = "unburden the bestial soul"
	applicable_stats = list(STAT_INTELLIGENCE, STAT_EMPATHY)
	difficulty = 8
	roll_output_type = ROLL_PRIVATE_AND_TARGET

/datum/discipline_power/obeah/unburden_the_bestial_soul/activate(atom/target)
	. = ..()
	var/mob/living/carbon/carbon_target = target
	if(!carbon_target)
		return
	var/obj/item/organ/brain/target_brain = carbon_target.get_organ_by_type(/obj/item/organ/brain)
	var/list/gotten_traumas = target_brain.traumas
	if(carbon_target.has_quirk(/datum/quirk/darkpack/derangement))
		gotten_traumas += "Derangement"
	var/chosen_derangement = tgui_input_list(owner, "Choose a trauma to cure", "Traumas", gotten_traumas)
	if(!chosen_derangement)
		to_chat(owner, span_notice("You fail to find any traumas."))
		return
	var/datum/storyteller_roll/unburden_the_bestial_soul/discipline_roll = new()
	var/success = discipline_roll.st_roll(owner, target)
	switch(success)
		if(ROLL_BOTCH)
			var/obj/item/organ/brain/owner_brain = owner.get_organ_by_type(/obj/item/organ/brain)
			if(chosen_derangement == "Derangement")
				owner.add_quirk(/datum/quirk/darkpack/derangement)
			else
				owner_brain.gain_trauma_type(chosen_derangement, TRAUMA_RESILIENCE_MAGIC)
			to_chat(owner, span_bolddanger("You fail to alleviate [target]'s [chosen_derangement] as your own brain inherits it!"))
		if(ROLL_FAILURE)
			to_chat(owner, span_danger("You fail to alleviate [target]'s [chosen_derangement]."))
		if(ROLL_SUCCESS)
			if(chosen_derangement == "Derangement")
				carbon_target.remove_quirk(/datum/quirk/darkpack/derangement)
			else
				target_brain.cure_trauma_type(chosen_derangement, TRAUMA_RESILIENCE_MAGIC)
			to_chat(owner, span_notice("You succesfully alleviate [target]'s [chosen_derangement]."))

