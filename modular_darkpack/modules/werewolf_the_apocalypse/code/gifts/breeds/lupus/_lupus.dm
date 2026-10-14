/datum/action/cooldown/power/gift/hares_leap
	name = "Hare's Leap"
	desc = {"The player makes a reflexive Strength + Athletics roll (difficulty 7) to activate this Gift.
	If successful, the character's leaping distances are doubled for a scene — or tripled for a single turn with the expenditure of a Willpower point"}
	button_icon_state = "hares_leap"
	rank = 1

/datum/action/cooldown/power/gift/hares_leap/Activate(atom/target)
	var/mob/living/living_owner = astype(owner)
	if(!living_owner)
		return FALSE

	. = ..()
	var/datum/storyteller_roll/gift/hares_leap/roll_datum = new()
	if(roll_datum.st_roll(living_owner) != ROLL_SUCCESS)
		return TRUE

	var/jump_mod = 2
	if(living_owner.prompt_burn_willpower())
		jump_mod = 3

	living_owner.apply_status_effect(/datum/status_effect/hares_leap, jump_mod)


/datum/storyteller_roll/gift/hares_leap
	bumper_text = /datum/action/cooldown/power/gift/hares_leap::name
	applicable_stats = list(STAT_STRENGTH, STAT_ATHLETICS)
	difficulty = 7
	roll_output_type = ROLL_FLAG_ROLLER


/datum/status_effect/hares_leap
	id = "hares_leap"
	duration = 1 SCENES
	status_type = STATUS_EFFECT_REPLACE
	alert_type = /atom/movable/screen/alert/status_effect/gift/hares_leap
	var/jump_modifier = 2

/datum/status_effect/hares_leap/on_creation(mob/living/new_owner, jump_modifier = 2)
	. = ..()
	src.jump_modifier = jump_modifier

/atom/movable/screen/alert/status_effect/gift/hares_leap
	name = /datum/action/cooldown/power/gift/hares_leap::name
	desc = /datum/action/cooldown/power/gift/hares_leap::desc
	overlay_state = /datum/action/cooldown/power/gift/hares_leap::button_icon_state


/datum/action/cooldown/power/gift/predators_arsenal
	name = "Predator's Arsenal"
	desc = {"One of the most unnerving aspects of the Homid shape is its lack of proper weapons.
	This Gift remedies that problem (while still retaining much of the Homid shape's ability to blend in with the human world),
	granting the Garou battle-ready claws and teeth in Homid form."}
	button_icon_state = "predators_arsenal"
	rank = 1

/datum/action/cooldown/power/gift/predators_arsenal/Activate(atom/target)
	var/mob/living/living_owner = astype(owner)
	if(!living_owner)
		return FALSE

	. = ..()

	living_owner.apply_status_effect(/datum/status_effect/predators_arsenal)

/datum/status_effect/predators_arsenal
	id = "predators_arsenal"
	duration = 1 SCENES
	status_type = STATUS_EFFECT_REPLACE
	alert_type = /atom/movable/screen/alert/status_effect/gift/predators_arsenal
	var/list/datum/weakref/affected_bodyparts
	var/datum/storyteller_roll/predators_arsenal_examine/roll_datum

/datum/status_effect/predators_arsenal/on_apply()
	. = ..()

	var/mob/living/carbon/carbon_owner = astype(owner)
	if(!carbon_owner)
		return FALSE

	for(var/obj/item/bodypart/limb as anything in carbon_owner.bodyparts)
		if(!istype(limb, /obj/item/bodypart/arm) && !istype(limb, /obj/item/bodypart/leg))
			continue

		LAZYADD(affected_bodyparts, WEAKREF(limb))
		limb.unarmed_sharpness = SHARP_EDGED
		limb.unarmed_attack_effect = ATTACK_EFFECT_CLAW // This will grant them a bonus 2 dice on attacks

	RegisterSignal(owner, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/datum/status_effect/predators_arsenal/on_remove()
	. = ..()
	for(var/datum/weakref/limb_weakref in affected_bodyparts)
		var/obj/item/bodypart/limb = limb_weakref.resolve()
		if(!limb)
			continue
		limb.unarmed_sharpness = limb::unarmed_sharpness
		limb.unarmed_attack_effect = limb::unarmed_attack_effect

	LAZYCLEARLIST(affected_bodyparts)
	UnregisterSignal(owner, COMSIG_ATOM_EXAMINE)

/datum/status_effect/predators_arsenal/proc/on_examine(atom/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	if(!roll_datum)
		roll_datum = new()

	var/roll_result = roll_datum.st_roll(user, source)
	if(roll_result == ROLL_SUCCESS)
		examine_list += span_warning("[source.p_They()] [source.p_have()] sharp, long claws for hands and [source.p_their()] voice has a strange distortion")


/atom/movable/screen/alert/status_effect/gift/predators_arsenal
	name = /datum/action/cooldown/power/gift/predators_arsenal::name
	desc = /datum/action/cooldown/power/gift/predators_arsenal::desc
	overlay_state = /datum/action/cooldown/power/gift/predators_arsenal::button_icon_state


/datum/storyteller_roll/predators_arsenal_examine
	bumper_text = "examine"
	difficulty = 9
	applicable_stats = list(STAT_PERCEPTION, STAT_ALERTNESS)
	roll_output_type = ROLL_FLAG_ROLLER
	roll_output_type_on_fail = ROLL_FLAG_TARGET

	reroll_cooldown = 1 SCENES
