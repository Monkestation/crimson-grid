#define COMBAT_COOLDOWN_LENGTH 45 SECONDS
#define REVEAL_COOLDOWN_LENGTH 15 SECONDS

/datum/discipline/obfuscate
	name = "Obfuscate"
	desc = "Makes you less noticable for living and un-living beings."
	icon_state = "obfuscate"
	power_type = /datum/discipline_power/obfuscate

/datum/discipline_power/obfuscate
	name = "Obfuscate power name"
	desc = "Obfuscate power description"

	activate_sound = 'modular_darkpack/modules/deprecated/sounds/obfuscate_activate.ogg'
	deactivate_sound = 'modular_darkpack/modules/deprecated/sounds/obfuscate_deactivate.ogg'

	var/static/list/aggressive_signals = list(
		COMSIG_MOB_ATTACK_HAND,
		COMSIG_MOB_FIRED_GUN,
		COMSIG_MOB_THROW,
		COMSIG_PROJECTILE_PREHIT,
		COMSIG_ATOM_ATTACKBY,
		COMSIG_MOB_ITEM_ATTACK,
		COMSIG_LIVING_GRAB
	)

/datum/discipline_power/obfuscate/proc/on_discipline_activation(datum/source, datum/discipline_power/activated_power, atom/target)
	SIGNAL_HANDLER

	if(istype(activated_power, /datum/discipline_power/obfuscate))
		return

	to_chat(owner, span_danger("Your Obfuscation falls away as you focus your blood on another discipline!"))
	try_deactivate(direct = TRUE)

	deltimer(cooldown_timer)
	cooldown_timer = addtimer(CALLBACK(src, PROC_REF(cooldown_expire)), COMBAT_COOLDOWN_LENGTH, TIMER_STOPPABLE | TIMER_DELETE_ME)

/datum/discipline_power/obfuscate/proc/on_talk(datum/source, list/speech_args)
	SIGNAL_HANDLER

	// This is a soft reveal as only as you would only be revealed to the person next to you. (which we are missing implementation of rn)
	if(speech_args[SPEECH_MODS][WHISPER_MODE] == MODE_WHISPER)
		return

	to_chat(owner, span_danger("Your Obfuscation falls away as you reveal yourself!"))
	try_deactivate(direct = TRUE)

	deltimer(cooldown_timer)
	cooldown_timer = addtimer(CALLBACK(src, PROC_REF(cooldown_expire)), COMBAT_COOLDOWN_LENGTH, TIMER_STOPPABLE | TIMER_DELETE_ME)

/datum/discipline_power/obfuscate/proc/on_combat_signal(datum/source)
	SIGNAL_HANDLER

	to_chat(owner, span_danger("Your Obfuscation falls away as you reveal yourself!"))
	try_deactivate(direct = TRUE)

	deltimer(cooldown_timer)
	cooldown_timer = addtimer(CALLBACK(src, PROC_REF(cooldown_expire)), COMBAT_COOLDOWN_LENGTH, TIMER_STOPPABLE | TIMER_DELETE_ME)

/datum/discipline_power/obfuscate/proc/is_seen_check()
	for (var/mob/living/viewer in oviewers(DEFAULT_SIGHT_DISTANCE, owner))
		//cats cannot stop you from Obfuscating
		if (!istype(viewer, /mob/living/carbon) && !viewer.client)
			continue

		//the corpses are not watching you
		if (viewer.is_blind() || (viewer.stat >= UNCONSCIOUS))
			continue

		to_chat(owner, span_warning("You cannot use [src] while you're being observed!"))
		return FALSE

	return TRUE

//CLOAK OF SHADOWS
/datum/discipline_power/obfuscate/cloak_of_shadows
	name = "Cloak of Shadows"
	desc = "Meld into the shadows and stay unnoticed so long as you draw no attention."

	level = 1
	check_flags = DISC_CHECK_CAPABLE
	vitae_cost = 0

	toggled = TRUE

	grouped_powers = list(
		/datum/discipline_power/obfuscate/unseen_presence,
		/datum/discipline_power/obfuscate/vanish_from_the_minds_eye,
		/datum/discipline_power/obfuscate/cloak_the_gathering
	)

/datum/discipline_power/obfuscate/cloak_of_shadows/pre_activation_checks()
	. = ..()
	return is_seen_check()

/datum/discipline_power/obfuscate/cloak_of_shadows/activate()
	. = ..()
	RegisterSignals(owner, aggressive_signals, PROC_REF(on_combat_signal))
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(handle_move))
	RegisterSignal(owner, COMSIG_POWER_ACTIVATE, PROC_REF(on_discipline_activation))
	RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(on_talk))

	for(var/mob/living/carbon/human/npc/NPC in GLOB.npc_list)
		if (NPC.danger_source == owner)
			NPC.danger_source = null
	ADD_TRAIT(owner, TRAIT_OBFUSCATED, OBFUSCATE_TRAIT)

/datum/discipline_power/obfuscate/cloak_of_shadows/deactivate()
	. = ..()
	UnregisterSignal(owner, aggressive_signals)
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(owner, list(COMSIG_POWER_ACTIVATE, COMSIG_MOB_SAY))

	REMOVE_TRAIT(owner, TRAIT_OBFUSCATED, OBFUSCATE_TRAIT)

/datum/discipline_power/obfuscate/cloak_of_shadows/proc/handle_move(datum/source, atom/moving_thing, dir)
	SIGNAL_HANDLER

	to_chat(owner, span_danger("Your [src] falls away as you move from your position!"))
	try_deactivate(direct = TRUE)

	deltimer(cooldown_timer)
	cooldown_timer = addtimer(CALLBACK(src, PROC_REF(cooldown_expire)), REVEAL_COOLDOWN_LENGTH, TIMER_STOPPABLE | TIMER_DELETE_ME)

//UNSEEN PRESENCE
/datum/discipline_power/obfuscate/unseen_presence
	name = "Unseen Presence"
	desc = "Move among the crowds without ever being noticed. Achieve invisibility."

	level = 2
	check_flags = DISC_CHECK_CAPABLE
	vitae_cost = 0

	toggled = TRUE

	grouped_powers = list(
		/datum/discipline_power/obfuscate/cloak_of_shadows,
		/datum/discipline_power/obfuscate/vanish_from_the_minds_eye,
		/datum/discipline_power/obfuscate/cloak_the_gathering
	)

/datum/discipline_power/obfuscate/unseen_presence/pre_activation_checks()
	. = ..()
	return is_seen_check()

/datum/discipline_power/obfuscate/unseen_presence/activate()
	. = ..()
	RegisterSignals(owner, aggressive_signals, PROC_REF(on_combat_signal))
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(handle_move))
	RegisterSignal(owner, COMSIG_POWER_ACTIVATE, PROC_REF(on_discipline_activation))
	RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(on_talk))

	for(var/mob/living/carbon/human/npc/NPC in GLOB.npc_list)
		if (NPC.danger_source == owner)
			NPC.danger_source = null

	ADD_TRAIT(owner, TRAIT_OBFUSCATED, OBFUSCATE_TRAIT)

/datum/discipline_power/obfuscate/unseen_presence/deactivate()
	. = ..()
	UnregisterSignal(owner, aggressive_signals)
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(owner, list(COMSIG_POWER_ACTIVATE, COMSIG_MOB_SAY))

	REMOVE_TRAIT(owner, TRAIT_OBFUSCATED, OBFUSCATE_TRAIT)

//remove this when Mask of a Thousand Faces is made tabletop accurate
/datum/discipline_power/obfuscate/unseen_presence/proc/handle_move(datum/source, atom/moving_thing, dir)
	SIGNAL_HANDLER

	if (owner.move_intent != MOVE_INTENT_WALK)
		to_chat(owner, span_danger("Your [src] falls away as you move too quickly!"))
		try_deactivate(direct = TRUE)

		deltimer(cooldown_timer)
		cooldown_timer = addtimer(CALLBACK(src, PROC_REF(cooldown_expire)), REVEAL_COOLDOWN_LENGTH, TIMER_STOPPABLE | TIMER_DELETE_ME)

//MASK OF A THOUSAND FACES
/datum/discipline_power/obfuscate/mask_of_a_thousand_faces
	name = "Mask of a Thousand Faces"
	desc = "Be noticed, but incorrectly. Hide your identity but nothing else."

	level = 3
	check_flags = DISC_CHECK_CAPABLE
	vitae_cost = 0 // vitae cost handled in activate()

	toggled = TRUE
	grouped_powers = list(
		/datum/discipline_power/obfuscate/cloak_of_shadows,
		/datum/discipline_power/obfuscate/unseen_presence,
		/datum/discipline_power/obfuscate/vanish_from_the_minds_eye,
		/datum/discipline_power/obfuscate/cloak_the_gathering
	)
	var/datum/splat/vampire/kindred/owner_splat
	var/datum/dna/original_dna
	var/original_name
	var/original_sprite
	var/original_sprite_greyscale
	var/list/cached_targets

//mask of a thousand faces is supposed to have varying levels of success based on successes rolled
/datum/discipline_power/obfuscate/mask_of_a_thousand_faces/proc/store_target_in_list(mob/examiner, atom/examined)
	SIGNAL_HANDLER
	if(!ishuman(examined) || examined == owner)
		return

	var/mob/living/carbon/human/target = examined
	var/image/target_image = image(target)
	to_chat(owner, span_info("You get a good look at your target and memorize their features."))
	LAZYSET(cached_targets, target.name, list("image" = target_image, "target" = target))

/datum/discipline_power/obfuscate/mask_of_a_thousand_faces/post_gain()
	. = ..()
	RegisterSignal(owner, COMSIG_MOB_EXAMINATE, PROC_REF(store_target_in_list))

/datum/discipline_power/obfuscate/mask_of_a_thousand_faces/pre_activation_checks()
	owner_splat = get_kindred_splat(owner)
	if(!LAZYLEN(cached_targets))
		to_chat(owner, span_warning("You haven't gotten a good look at anyone - so you can't mimic anyone's face!"))
		return FALSE

	if(!is_seen_check())
		return FALSE

	var/roll = SSroll.storyteller_roll(owner.st_get_stat(STAT_MANIPULATION) + owner.st_get_stat(STAT_PERFORMANCE), 7, owner)
	if(roll == ROLL_SUCCESS)
		return TRUE

	to_chat(owner, span_warning("You fail to focus your mind on the disguise."))
	return FALSE

/datum/discipline_power/obfuscate/mask_of_a_thousand_faces/activate()
	. = ..()

	var/list/display_targets = list()
	for(var/target_name in cached_targets)
		display_targets[target_name] = cached_targets[target_name]["image"]

	var/chosen_name = show_radial_menu(owner, owner, display_targets, radius = 40, require_near = TRUE, tooltips = TRUE)
	if(!chosen_name)
		try_deactivate(direct = TRUE)
		return

	var/mob/living/carbon/human/target = cached_targets[chosen_name]["target"]

	if(!target)
		to_chat(owner, span_warning("You can't recall [chosen_name]'s features clearly enough!"))
		try_deactivate(direct = TRUE)
		return

	var/appearance_difference = target.st_get_stat(STAT_APPEARANCE) - owner.st_get_stat(STAT_APPEARANCE)
	owner.adjust_blood_pool(-max(appearance_difference, 1))

	if(!original_dna)
		original_dna = new /datum/dna()
		owner.dna.copy_dna(original_dna, 0)
		original_name = owner.name
		if(owner_splat.clan?.alt_sprite)
			original_sprite = owner_splat.clan.alt_sprite
			original_sprite_greyscale = owner_splat.clan.alt_sprite_greyscale
		else
			original_sprite = SPECIES_HUMAN
			original_sprite_greyscale = TRUE

	target.dna.copy_dna(owner.dna, 0)
	var/datum/splat/vampire/kindred/target_splat = get_kindred_splat(target)
	if(target_splat?.clan?.alt_sprite)
		owner.set_body_sprite(target_splat.clan.alt_sprite, target_splat.clan.alt_sprite_greyscale, TRUE)
	else
		if(owner_splat.clan && (TRAIT_MASQUERADE_VIOLATING_FACE in owner_splat.clan.clan_traits))
			REMOVE_TRAIT(owner, TRAIT_MASQUERADE_VIOLATING_FACE, CLAN_TRAIT)
		if(owner_splat.clan && (TRAIT_MASQUERADE_VIOLATING_EYES in owner_splat.clan.clan_traits))
			REMOVE_TRAIT(owner, TRAIT_MASQUERADE_VIOLATING_EYES, CLAN_TRAIT)
		owner.set_body_sprite(SPECIES_HUMAN, TRUE, TRUE)

	owner.updateappearance(mutcolor_update = TRUE)
	to_chat(owner, span_notice("You assume the appearance of [target.name]."))

	for(var/mob/living/carbon/human/npc/NPC in GLOB.npc_list)
		if (NPC.danger_source == owner)
			NPC.danger_source = null

/datum/discipline_power/obfuscate/mask_of_a_thousand_faces/deactivate()
	. = ..()
	original_dna.copy_dna(owner.dna, 0)
	owner.name = original_name

	if(owner_splat.clan && (TRAIT_MASQUERADE_VIOLATING_FACE in owner_splat.clan.clan_traits))
		ADD_TRAIT(owner, TRAIT_MASQUERADE_VIOLATING_FACE, CLAN_TRAIT)
	if(owner_splat.clan && (TRAIT_MASQUERADE_VIOLATING_EYES in owner_splat.clan.clan_traits))
		ADD_TRAIT(owner, TRAIT_MASQUERADE_VIOLATING_EYES, CLAN_TRAIT)

	owner.set_body_sprite(original_sprite, original_sprite_greyscale, TRUE)
	owner.updateappearance(mutcolor_update = TRUE)
	to_chat(owner, span_notice("You assume your original form."))

//VANISH FROM THE MIND'S EYE
/datum/discipline_power/obfuscate/vanish_from_the_minds_eye
	name = "Vanish from the Mind's Eye"
	desc = "Disappear from plain view, and possibly wipe your past presence from recollection."

	level = 4
	check_flags = DISC_CHECK_CAPABLE
	vitae_cost = 0 //No Vitae cost

	toggled = TRUE

	grouped_powers = list(
		/datum/discipline_power/obfuscate/cloak_of_shadows,
		/datum/discipline_power/obfuscate/unseen_presence,
		/datum/discipline_power/obfuscate/cloak_the_gathering
	)

/datum/discipline_power/obfuscate/vanish_from_the_minds_eye/pre_activation_checks(atom/target)
	var/roll = SSroll.storyteller_roll(owner.st_get_stat(STAT_CHARISMA) + owner.st_get_stat(STAT_STEALTH), 6, owner)
	if(roll == ROLL_SUCCESS)
		return TRUE
	return FALSE

/datum/discipline_power/obfuscate/vanish_from_the_minds_eye/activate()
	. = ..()
	RegisterSignals(owner, aggressive_signals, PROC_REF(on_combat_signal))
	RegisterSignal(owner, COMSIG_POWER_ACTIVATE, PROC_REF(on_discipline_activation))
	RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(on_talk))

	for(var/mob/living/carbon/human/npc/NPC in GLOB.npc_list)
		if (NPC.danger_source == owner)
			NPC.danger_source = null
	if(prob(1))
		SEND_SIGNAL(SSmasquerade, COMSIG_PLAYER_MASQUERADE_REINFORCE, owner)

	ADD_TRAIT(owner, TRAIT_OBFUSCATED, OBFUSCATE_TRAIT)

/datum/discipline_power/obfuscate/vanish_from_the_minds_eye/deactivate()
	. = ..()
	UnregisterSignal(owner, aggressive_signals)
	UnregisterSignal(owner, list(COMSIG_POWER_ACTIVATE, COMSIG_MOB_SAY))

	REMOVE_TRAIT(owner, TRAIT_OBFUSCATED, OBFUSCATE_TRAIT)

//CLOAK THE GATHERING
/datum/discipline_power/obfuscate/cloak_the_gathering
	name = "Cloak the Gathering"
	desc = "Hide yourself and others, scheme in peace."

	level = 5
	check_flags = DISC_CHECK_CAPABLE
	vitae_cost = 0

	toggled = TRUE

	grouped_powers = list(
		/datum/discipline_power/obfuscate/cloak_of_shadows,
		/datum/discipline_power/obfuscate/unseen_presence,
		/datum/discipline_power/obfuscate/vanish_from_the_minds_eye,
	)

/datum/discipline_power/obfuscate/cloak_the_gathering/activate()
	. = ..()
	RegisterSignals(owner, aggressive_signals, PROC_REF(on_combat_signal))
	RegisterSignal(owner, COMSIG_POWER_ACTIVATE, PROC_REF(on_discipline_activation))
	RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(on_talk))

	for(var/mob/living/carbon/human/npc/NPC in GLOB.npc_list)
		if (NPC.danger_source == owner)
			NPC.danger_source = null
	ADD_TRAIT(owner, TRAIT_OBFUSCATED, OBFUSCATE_TRAIT)

/datum/discipline_power/obfuscate/cloak_the_gathering/deactivate()
	. = ..()
	UnregisterSignal(owner, aggressive_signals)
	UnregisterSignal(owner, list(COMSIG_POWER_ACTIVATE, COMSIG_MOB_SAY))

	REMOVE_TRAIT(owner, TRAIT_OBFUSCATED, OBFUSCATE_TRAIT)

#undef COMBAT_COOLDOWN_LENGTH
#undef REVEAL_COOLDOWN_LENGTH
