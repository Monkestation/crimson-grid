#define COMBAT_COOLDOWN_LENGTH 45 SECONDS
#define REVEAL_COOLDOWN_LENGTH 15 SECONDS

/datum/discipline/obfuscate
	name = "Сокрытие"
	desc = {"Позволяет ускользать от внимания и живых, и не-мёртвых.
● Плащ теней: пассивно
●● Незримое присутствие: пассивно
●●● Маска тысячи лиц: Манипуляция + Исполнение (сложность 7)
●●●● Исчезновение из виду: Обаяние + Скрытность (сложность 6)
●●●●● Тайное собрание: пассивно"}
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

	to_chat(owner, span_danger("Сокрытие спадает: вы направили силу крови на другую Дисциплину!"))
	try_deactivate(direct = TRUE)

	deltimer(cooldown_timer)
	cooldown_timer = addtimer(CALLBACK(src, PROC_REF(cooldown_expire)), COMBAT_COOLDOWN_LENGTH, TIMER_STOPPABLE | TIMER_DELETE_ME)

/datum/discipline_power/obfuscate/proc/on_talk(datum/source, list/speech_args)
	SIGNAL_HANDLER

	// This is a soft reveal as only as you would only be revealed to the person next to you. (which we are missing implementation of rn)
	if(speech_args[SPEECH_MODS][WHISPER_MODE] == MODE_WHISPER)
		return

	to_chat(owner, span_danger("Сокрытие спадает: вы выдали себя!"))
	try_deactivate(direct = TRUE)

	deltimer(cooldown_timer)
	cooldown_timer = addtimer(CALLBACK(src, PROC_REF(cooldown_expire)), COMBAT_COOLDOWN_LENGTH, TIMER_STOPPABLE | TIMER_DELETE_ME)

/datum/discipline_power/obfuscate/proc/on_combat_signal(datum/source)
	SIGNAL_HANDLER

	to_chat(owner, span_danger("Сокрытие спадает: вы выдали себя!"))
	try_deactivate(direct = TRUE)

	deltimer(cooldown_timer)
	cooldown_timer = addtimer(CALLBACK(src, PROC_REF(cooldown_expire)), COMBAT_COOLDOWN_LENGTH, TIMER_STOPPABLE | TIMER_DELETE_ME)

/datum/discipline_power/obfuscate/proc/is_seen_check()
	for (var/mob/living/viewer in oviewers(DEFAULT_SIGHT_DISTANCE, owner))
		//cats cannot stop you from Obfuscating
		if (!istype(viewer, /mob/living/carbon) && !viewer.client)
			continue

		//the corpses are not watching you
		if (viewer.is_blind() || IS_UNCONSCIOUS(viewer))
			continue

		to_chat(owner, span_warning("Пока на вас смотрят, скрыться не выйдет!"))
		return FALSE

	return TRUE

//CLOAK OF SHADOWS
/datum/discipline_power/obfuscate/cloak_of_shadows
	name = "Плащ теней"
	desc = "Слейтесь с тенями: вас не заметят, пока вы ничем не привлекаете внимания."

	level = 1
	check_flags = DISC_CHECK_CAPABLE
	vitae_cost = 0

	toggled = TRUE

	grouped_powers = list(
		/datum/discipline_power/obfuscate/unseen_presence,
		/datum/discipline_power/obfuscate/vanish_from_the_minds_eye,
		/datum/discipline_power/obfuscate/cloak_the_gathering
	)
	frenzy_usable = FALSE

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

	to_chat(owner, span_danger("Вы сдвинулись с места - [src] больше вас не скрывает!"))
	try_deactivate(direct = TRUE)

	deltimer(cooldown_timer)
	cooldown_timer = addtimer(CALLBACK(src, PROC_REF(cooldown_expire)), REVEAL_COOLDOWN_LENGTH, TIMER_STOPPABLE | TIMER_DELETE_ME)

//UNSEEN PRESENCE
/datum/discipline_power/obfuscate/unseen_presence
	name = "Незримое присутствие"
	desc = "Идите сквозь толпу, не попадаясь никому на глаза. Вы становитесь невидимы."

	level = 2
	check_flags = DISC_CHECK_CAPABLE
	vitae_cost = 0
	frenzy_usable = FALSE

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
		to_chat(owner, span_danger("Вы движетесь слишком быстро - [src] рассеивается!"))
		try_deactivate(direct = TRUE)

		deltimer(cooldown_timer)
		cooldown_timer = addtimer(CALLBACK(src, PROC_REF(cooldown_expire)), REVEAL_COOLDOWN_LENGTH, TIMER_STOPPABLE | TIMER_DELETE_ME)

//MASK OF A THOUSAND FACES
/datum/discipline_power/obfuscate/mask_of_a_thousand_faces
	name = "Маска тысячи лиц"
	desc = "Вас видят, но принимают за другого. Скрывает личность - и только её."

	level = 3
	check_flags = DISC_CHECK_CAPABLE
	vitae_cost = 0 // vitae cost handled in activate()
	frenzy_usable = FALSE

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
	to_chat(owner, span_info("Вы внимательно всматриваетесь в чужое лицо и запоминаете его черты."))
	LAZYSET(cached_targets, GET_GUESTBOOK_NAME_TRUE(examiner, target), TRUE) // CORVAX EDIT CHANGE - only the count is used, the stored image and mob hard deleted every examined human. ORIGINAL: list("image" = image(target), "target" = target)

/datum/discipline_power/obfuscate/mask_of_a_thousand_faces/post_gain()
	. = ..()
	RegisterSignal(owner, COMSIG_MOB_EXAMINATE, PROC_REF(store_target_in_list))

/datum/discipline_power/obfuscate/mask_of_a_thousand_faces/post_loss()
	UnregisterSignal(owner, COMSIG_MOB_EXAMINATE)

/datum/discipline_power/obfuscate/mask_of_a_thousand_faces/pre_activation_checks()
	owner_splat = get_kindred_splat(owner)
	if(!LAZYLEN(cached_targets))
		to_chat(owner, span_warning("Вы ещё ни к кому как следует не присмотрелись - копировать некого!"))
		return FALSE

	if(!is_seen_check())
		return FALSE

	var/roll = SSroll.storyteller_roll_datum(owner, difficulty = 7, applic_stats = list(STAT_MANIPULATION, STAT_PERFORMANCE))
	if(roll == ROLL_SUCCESS)
		return TRUE

	to_chat(owner, span_warning("Сосредоточиться на чужом облике не получается."))
	return FALSE

/datum/discipline_power/obfuscate/mask_of_a_thousand_faces/activate()
	. = ..()
	var/mob/living/carbon/human/target = owner?.mind?.guestbook.pick_known_guy(owner)

	if(!istype(target))
		to_chat(owner, span_warning("Вы не можете достаточно ясно вспомнить черты [target.declent_ru(GENITIVE)]!"))
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
		if(owner_splat.clan && (TRAIT_MASQUERADE_VIOLATING_FACE in owner_splat.clan.subsplat_traits))
			REMOVE_TRAIT(owner, TRAIT_MASQUERADE_VIOLATING_FACE, SUBSPLAT_TRAIT)
		if(owner_splat.clan && (TRAIT_MASQUERADE_VIOLATING_EYES in owner_splat.clan.subsplat_traits))
			REMOVE_TRAIT(owner, TRAIT_MASQUERADE_VIOLATING_EYES, SUBSPLAT_TRAIT)
		if(original_sprite == "rotten4" || original_sprite == "rotten3")
			REMOVE_TRAIT(owner, TRAIT_MASQUERADE_VIOLATING_FACE, MAGIC_TRAIT)
		owner.set_body_sprite(SPECIES_HUMAN, TRUE, TRUE)

	owner.updateappearance(mutcolor_update = TRUE)
	to_chat(owner, span_notice("Теперь вы выглядите как [target.name]."))

	for(var/mob/living/carbon/human/npc/NPC in GLOB.npc_list)
		if (NPC.danger_source == owner)
			NPC.danger_source = null

/datum/discipline_power/obfuscate/mask_of_a_thousand_faces/deactivate()
	. = ..()
	original_dna.copy_dna(owner.dna, 0)
	owner.name = original_name

	if(owner_splat.clan && (TRAIT_MASQUERADE_VIOLATING_FACE in owner_splat.clan.subsplat_traits))
		ADD_TRAIT(owner, TRAIT_MASQUERADE_VIOLATING_FACE, SUBSPLAT_TRAIT)
	if(owner_splat.clan && (TRAIT_MASQUERADE_VIOLATING_EYES in owner_splat.clan.subsplat_traits))
		ADD_TRAIT(owner, TRAIT_MASQUERADE_VIOLATING_EYES, SUBSPLAT_TRAIT)
	if(original_sprite == "rotten4" || original_sprite == "rotten3")
		ADD_TRAIT(owner, TRAIT_MASQUERADE_VIOLATING_FACE, MAGIC_TRAIT)

	owner.set_body_sprite(original_sprite, original_sprite_greyscale, TRUE)
	owner.updateappearance(mutcolor_update = TRUE)
	to_chat(owner, span_notice("Вы возвращаете себе прежний облик."))

//VANISH FROM THE MIND'S EYE
/datum/discipline_power/obfuscate/vanish_from_the_minds_eye
	name = "Исчезновение из виду"
	desc = "Исчезните прямо у всех на глазах - и, быть может, сотрите из чужой памяти то, что вообще здесь были."

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
	var/roll = SSroll.storyteller_roll_datum(owner, applic_stats = list(STAT_CHARISMA, STAT_STEALTH))
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
	name = "Тайное собрание"
	desc = "Скройте себя и своих спутников - и плетите интриги без лишних глаз."

	level = 5
	check_flags = DISC_CHECK_CAPABLE
	vitae_cost = 0
	frenzy_usable = FALSE

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
