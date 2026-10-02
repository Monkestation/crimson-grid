/datum/action/cooldown/blood_power
	name = "Blood Power"
	desc = "Use vitae to gain supernatural abilities."
	button_icon = 'modular_darkpack/modules/powers/icons/actions.dmi'
	button_icon_state = "bloodpower"
	background_icon = 'modular_darkpack/master_files/icons/mob/actions/backgrounds.dmi'
	background_icon_state = "bg_discipline"
	check_flags = AB_CHECK_HANDS_BLOCKED | AB_CHECK_IMMOBILE | AB_CHECK_LYING | AB_CHECK_CONSCIOUS
	cooldown_time = 1 TURNS
	vampiric = TRUE

	/// How much the ability costs to activate per "turn"
	var/bp_per_turns = 1
	var/stat_buff_amount = 1
	// Activated for two "turns" as 5 seconds is acctually pretty short. Opens to door to let players set how long they are declaring it active for.
	/// How many "turns" its activated for. Multiplies the blood cost.
	var/turns_activated = 2
	var/datum/armor/old_armor
	var/list/obj/item/bodypart/strengthened_limbs

/datum/action/cooldown/blood_power/IsAvailable(feedback)
	. = ..()

	if (HAS_TRAIT(owner, TRAIT_TORPOR))
		if (feedback)
			owner.balloon_alert(owner, "in Torpor!")
		return FALSE

	if (!ishuman(owner))
		if (feedback)
			owner.balloon_alert(owner, "not human!")
		return FALSE

	var/mob/living/carbon/human/human_owner = owner
	if (human_owner.bloodpool < current_bp_cost(human_owner))
		if (feedback)
			SEND_SOUND(human_owner, sound('modular_darkpack/modules/deprecated/sounds/need_blood.ogg', volume = 75))
			owner.balloon_alert(owner, "not enough BLOOD!")
		return FALSE

/datum/action/cooldown/blood_power/Activate(mob/living/target)
	cooldown_time = turns_activated TURNS

	. = ..()

	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/human_owner = owner

	playsound(usr, 'modular_darkpack/modules/vampire_the_masquerade/sounds/bloodhealing.ogg', 50, FALSE)
	to_chat(human_owner, span_notice("You use blood to become more powerful."))

	// DARKPACK TODO - This can be represented by having stam do anything
	old_armor = human_owner.physiology.armor
	human_owner.physiology.armor = old_armor.generate_new_with_modifiers(list(MELEE = 15, BULLET = 15))

	human_owner.st_add_stat_mod(STAT_STRENGTH, stat_buff_amount, "blood_power")
	human_owner.st_add_stat_mod(STAT_DEXTERITY, stat_buff_amount, "blood_power")
	human_owner.st_add_stat_mod(STAT_STAMINA, stat_buff_amount, "blood_power")

	human_owner.adjust_blood_pool(-current_bp_cost(human_owner))

	human_owner.add_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown)

	addtimer(CALLBACK(src, PROC_REF(end_bloodpower)), cooldown_time)

/datum/action/cooldown/blood_power/proc/current_bp_cost(mob/living/carbon/human/human_owner)
	var/cost = bp_per_turns * turns_activated * stat_buff_amount
	if(HAS_TRAIT(human_owner, TRAIT_HUNGRY))
		cost = round(cost * 1.5)
	cost = round(cost * human_owner.blood_efficiency)
	return cost

/datum/action/cooldown/blood_power/proc/end_bloodpower()
	if (!owner || !ishuman(owner))
		return

	var/mob/living/carbon/human/human_owner = owner
	to_chat(human_owner, span_warning("You feel like your <b>BLOOD</b> power slowly decreases."))

	human_owner.physiology.armor = old_armor

	human_owner.st_remove_stat_mod(STAT_STRENGTH, "blood_power")
	human_owner.st_remove_stat_mod(STAT_DEXTERITY, "blood_power")
	human_owner.st_remove_stat_mod(STAT_STAMINA, "blood_power")

	human_owner.remove_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown)

/datum/action/cooldown/blood_power/proc/set_usage()
	var/turns = tgui_input_number(owner, "Set turns ([1 TURNS / 10] seconds per turn) to use blood for.", "Set Bloodpower Turns", turns_activated, TURNS_PER_SCENE, 1)
	if(turns)
		turns_activated = turns
	var/datum/splat/vampire/kindred/kindred_splat = get_kindred_splat(owner)
	if(!kindred_splat)
		return
	// Realising this is reimplenting very similar behavior to discs and could possibly just be typed under it.
	var/max_buff_amount = kindred_splat.vitae_spending_rate
	if(max_buff_amount <= 1) // No reason to prompt them if they only have one option
		return
	stat_buff_amount = clamp(stat_buff_amount, 0, max_buff_amount)
	var/stat_buff_input = tgui_input_number(owner, "Set amount of dice to add for usage. (Max based on your generation)", "Set Buff Bonus", stat_buff_amount, max_buff_amount, 1)
	if(stat_buff_input)
		stat_buff_amount = stat_buff_input

// DARKPACK TODO - (Refactor. Both this and discs should prob just have a subtype for /action_button)
/atom/movable/screen/movable/action_button/Click(location, control, params)
	if(istype(linked_action, /datum/action/cooldown/blood_power))
		var/list/modifiers = params2list(params)

		//increase on right click, decrease on shift right click
		if(LAZYACCESS(modifiers, RIGHT_CLICK))
			var/datum/action/cooldown/blood_power/bp_action = linked_action
			bp_action.set_usage()
			return
		//TODO: middle click to swap loadout
	. = ..()
