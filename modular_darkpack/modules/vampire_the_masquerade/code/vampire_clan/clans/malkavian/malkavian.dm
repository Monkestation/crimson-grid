GLOBAL_LIST_EMPTY(madness_network)

/datum/subsplat/vampire_clan/malkavian
	name = "Malkavian"
	ru_name = "Малкавиан"
	id = VAMPIRE_CLAN_MALKAVIAN
	desc = "Другие вампиры пренебрежительно зовут их Безумцами, но Кровь малкавиан позволяет видеть и предрекать истины, скрытые от остальных. Как у мудрых безумцев из стихов, их расколотый взгляд на мир - оттого, что они видят слишком много сразу, понимают слишком глубоко и чувствуют слишком сильно, чтобы это вынести. Малкавиане прокляты сверхъестественным сумасшествием, которое дарит им тревожные озарения, видения и предчувствия. В большинстве своём они верны Камарилье и служат ей провидцами, манипуляторами, пророками и шутами разом. С тех пор как Великая Шутка была обращена вспять, в клан вернулось Помешательство, хотя некоторые по загадочной причине до сих пор владеют Доминированием (см. клан \"Малкавиан (Доминирование)\"). Каждый малкавианин страдает собственным психическим расстройством, которое определяет, каким он видит мир."
	icon = "malkavian"
	curse = "Сумасшествие."
	roleplay_level = "Высокий"
	sense_the_sin_text = "пугает тех, кто рядом."
	clan_disciplines = list(
		/datum/discipline/auspex,
		/datum/discipline/dementation,
		/datum/discipline/obfuscate,
	)
	male_clothes = /obj/item/clothing/under/vampire/malkavian
	female_clothes = /obj/item/clothing/under/vampire/malkavian/female
	subsplat_keys = /obj/item/vamp/keys/malkav

/datum/subsplat/vampire_clan/malkavian/dominate
	name = "Dominate Malkavian"
	ru_name = "Малкавиан (Доминирование)"
	id = VAMPIRE_CLAN_DOMINATE_MALKAVIAN
	icon = "dominate_malkavian"
	roleplay_level = "Для новичков"
	clan_disciplines = list(
		/datum/discipline/auspex,
		/datum/discipline/dominate,
		/datum/discipline/obfuscate,
	)

/datum/subsplat/vampire_clan/malkavian/on_gain(mob/living/carbon/human/gaining_mob, datum/splat/gaining_splat, joining_round)
	. = ..()
	var/datum/action/cooldown/malk_hivemind/hivemind = new(gaining_mob)
	hivemind.Grant(gaining_mob)
	var/datum/action/cooldown/malk_speech/malk_font = new(gaining_mob)
	malk_font.Grant(gaining_mob)

	gaining_mob.add_quirk(/datum/quirk/darkpack/derangement)

	if(!isdummy(gaining_mob)) // CORVAX EDIT ADD - preview mannequins don't join the network
		GLOB.madness_network += gaining_mob
	RegisterSignal(gaining_mob, COMSIG_MOB_SAY, PROC_REF(handle_say))
	RegisterSignal(gaining_mob, COMSIG_MOVABLE_HEAR, PROC_REF(handle_hear))

/datum/subsplat/vampire_clan/malkavian/on_lose(mob/living/carbon/human/losing_mob)
	. = ..()

	for (var/datum/action/cooldown/malkavian_action in losing_mob.actions)
		if (!istype(malkavian_action, /datum/action/cooldown/malk_hivemind) && !istype(malkavian_action, /datum/action/cooldown/malk_speech))
			continue
		malkavian_action.Remove(losing_mob)

	losing_mob.remove_quirk(/datum/quirk/darkpack/derangement)

	GLOB.madness_network -= losing_mob
	UnregisterSignal(losing_mob, COMSIG_MOB_SAY)
	UnregisterSignal(losing_mob, COMSIG_MOVABLE_HEAR)

/datum/subsplat/vampire_clan/malkavian/proc/handle_say(mob/living/source, list/speech_args)
	SIGNAL_HANDLER

	if (!prob(20))
		return

	say_in_madness_network(speech_args[SPEECH_MESSAGE])

/datum/subsplat/vampire_clan/malkavian/proc/handle_hear(mob/living/source, list/hearing_args)
	SIGNAL_HANDLER

	if(!prob(3))
		return

	say_in_madness_network(hearing_args[HEARING_RAW_MESSAGE])

/datum/subsplat/vampire_clan/malkavian/proc/say_in_madness_network(message)
	for (var/mob/living/malkavian in GLOB.madness_network)
		to_chat(malkavian, span_ghostalert(message))

/datum/action/cooldown/malk_hivemind
	name = "Сеть Безумия"
	desc = "Обратиться к собратьям через Сеть Безумия."
	button_icon = 'modular_darkpack/master_files/icons/hud/actions.dmi'
	button_icon_state = "hivemind"
	check_flags = AB_CHECK_CONSCIOUS
	vampiric = TRUE
	cooldown_time = 5 SECONDS

/datum/action/cooldown/malk_hivemind/Trigger(mob/clicker, trigger_flags, atom/target)
	. = ..()
	var/mob/living/carbon/human/malk = clicker
	if (!malk.is_clan(/datum/subsplat/vampire_clan/malkavian))
		return
	var/datum/subsplat/vampire_clan/malkavian/clan_malkavian = malk.get_clan()
	var/new_thought = tgui_input_text(clicker, "Что прошептать в Сеть Безумия?")
	if(!new_thought)
		return
	StartCooldown()
	clan_malkavian.say_in_madness_network(new_thought)
	message_admins("[ADMIN_LOOKUPFLW(usr)] said \"[new_thought]\" through the Madness Network.")
	log_game("[key_name(usr)] said \"[new_thought]\" through the Madness Network.")

/datum/action/cooldown/malk_speech
	name = "Речь безумца"
	desc = "Выпустить наружу самые сокровенные мысли."
	button_icon = 'modular_darkpack/master_files/icons/hud/actions.dmi'
	button_icon_state = "malk_speech"
	check_flags = AB_CHECK_CONSCIOUS
	vampiric = TRUE
	cooldown_time = 5 SECONDS

/datum/action/cooldown/malk_speech/Trigger(mob/clicker, trigger_flags, atom/target)
	. = ..()
	var/malkavian_spans = list("singing", "bold")
	var/mad_speak = tgui_input_text(clicker, "Что произнесёт ваше безумие?", encode = FALSE)
	if(CAN_BYPASS_FILTER(clicker) ? null : is_ic_filtered(mad_speak))
		//before we inadvertently obfuscate the message to pass filters, filter it first.
		//as funny as malkavians saying "amogus" would be, the filter also includes slurs... how unfortunate.
		to_chat(clicker, span_warning("В сообщении есть слово, запрещённое в IC-чате! Советуем перечитать правила сервера.\n<span replaceRegex='show_filtered_ic_chat'>\"[mad_speak]\"</span>"))
		SSblackbox.record_feedback("tally", "ic_blocked_words", 1, LOWER_TEXT(config.ic_filter_regex.match))
		return
	if(!mad_speak)
		return
	StartCooldown()
	mad_speak = spooky_font_replace(mad_speak) // replace some letters to make the font more closely resemble that of vtm: bloodlines' malkavian dialogue
	clicker.say(mad_speak, spans = list(malkavian_spans))

/datum/subsplat/vampire_clan/malkavian/psychomania_effect(mob/living/target, mob/living/owner)
	// CRIMSON GRID ADD: DARK THAUMATURGY. BEFORE:
	/* target.playsound_local(target, "modular_darkpack/modules/powers/sounds/daimonion_laughs/malklaugh.ogg", 50, FALSE)
	target.Paralyze(6 SECONDS)
	target.visible_message(span_warning("[target] repeatedly bashes their head against the ground"), span_cult("THE WHISPERS ARE OVERTAKING ME"))
	target.apply_damage(50, BRUTE, BODY_ZONE_HEAD) */
	to_chat(target, span_cult("ЗВЕРЬ ВОПИТ В МОЕЙ ГОЛОВЕ: БЕГИ"))
	new /obj/effect/client_image_holder/baali_demon(get_turf(target), list(target))
	// CRIMSON GRID ADD END: DARK THAUMATURGY
