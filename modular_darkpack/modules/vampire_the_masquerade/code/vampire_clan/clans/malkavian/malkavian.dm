/datum/subsplat/vampire_clan/malkavian
	name = "Malkavian"
	id = VAMPIRE_CLAN_MALKAVIAN
	desc = "Derided as Lunatics by other vampires, the Blood of the Malkavians lets them perceive and foretell truths hidden from others. Like the �wise madmen� of poetry their fractured perspective stems from seeing too much of the world at once, from understanding too deeply, and feeling emotions that are just too strong to bear."
	icon = "malkavian"
	curse = "Insanity."
	sense_the_sin_text = "frightens people near them."
	clan_disciplines = list(
		/datum/discipline/auspex,
		/datum/discipline/dementation,
		/datum/discipline/obfuscate
	)
	male_clothes = /obj/item/clothing/under/vampire/malkavian
	female_clothes = /obj/item/clothing/under/vampire/malkavian/female
	subsplat_keys = /obj/item/vamp/keys/malkav
	var/list/mob/living/madness_network

/datum/subsplat/vampire_clan/malkavian/on_gain(mob/living/carbon/human/gaining_mob, datum/splat/gaining_splat, joining_round)
	. = ..()

	var/datum/action/cooldown/malk_hivemind/hivemind = new(gaining_mob)
	var/datum/action/cooldown/malk_speech/malk_font = new(gaining_mob)
	hivemind.Grant(gaining_mob)
	malk_font.Grant(gaining_mob)
	gaining_mob.add_quirk(/datum/quirk/darkpack/derangement)

	// Madness Network handling
	LAZYADD(madness_network, gaining_mob)
	RegisterSignal(gaining_mob, COMSIG_MOB_SAY, PROC_REF(handle_say), override = TRUE)
	RegisterSignal(gaining_mob, COMSIG_MOVABLE_HEAR, PROC_REF(handle_hear), override = TRUE)

/datum/subsplat/vampire_clan/malkavian/on_lose(mob/living/carbon/human/losing_mob)
	. = ..()

	for (var/datum/action/cooldown/malkavian_action in losing_mob.actions)
		if (!istype(malkavian_action, /datum/action/cooldown/malk_hivemind) && !istype(malkavian_action, /datum/action/cooldown/malk_speech))
			continue
		malkavian_action.Remove(losing_mob)

	// Remove Madness Network
	LAZYREMOVE(madness_network, losing_mob)
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
	for (var/mob/living/malkavian in madness_network)
		to_chat(malkavian, span_ghostalert(message))

/datum/action/cooldown/malk_hivemind
	name = "Hivemind"
	desc = "Talk"
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
	var/new_thought = tgui_input_text(clicker, "Malkavian Hivemind")
	if(!new_thought)
		return
	StartCooldown()
	clan_malkavian.say_in_madness_network(new_thought)
	message_admins("[ADMIN_LOOKUPFLW(usr)] said \"[new_thought]\" through the Madness Network.")
	log_game("[key_name(usr)] said \"[new_thought]\" through the Madness Network.")

/datum/action/cooldown/malk_speech
	name = "Madness Speech"
	desc = "Unleash your innermost thoughts"
	button_icon = 'modular_darkpack/master_files/icons/hud/actions.dmi'
	button_icon_state = "malk_speech"
	check_flags = AB_CHECK_CONSCIOUS
	vampiric = TRUE
	cooldown_time = 5 SECONDS

/datum/action/cooldown/malk_speech/Trigger(mob/clicker, trigger_flags, atom/target)
	. = ..()
	var/malkavian_spans = list("singing", "bold")
	var/mad_speak = tgui_input_text(clicker, "Malkavian Speech", encode = FALSE)
	if(CAN_BYPASS_FILTER(clicker) ? null : is_ic_filtered(mad_speak))
		//before we inadvertently obfuscate the message to pass filters, filter it first.
		//as funny as malkavians saying "amogus" would be, the filter also includes slurs... how unfortunate.
		to_chat(clicker, span_warning("That message contained a word prohibited in IC chat! Consider reviewing the server rules.\n<span replaceRegex='show_filtered_ic_chat'>\"[mad_speak]\"</span>"))
		SSblackbox.record_feedback("tally", "ic_blocked_words", 1, lowertext(config.ic_filter_regex.match))
		return
	if(!mad_speak)
		return
	StartCooldown()
	mad_speak = spooky_font_replace(mad_speak) // replace some letters to make the font more closely resemble that of vtm: bloodlines' malkavian dialogue
	clicker.say(mad_speak, spans = list(malkavian_spans))

/datum/subsplat/vampire_clan/malkavian/psychomania_effect(mob/living/target, mob/living/owner)
	target.playsound_local(target, "modular_darkpack/modules/powers/sounds/daimonion_laughs/malklaugh.ogg", 50, FALSE)
	target.Paralyze(6 SECONDS)
	target.visible_message(span_warning("[target] repeatedly bashes their head against the ground"), span_cult("THE WHISPERS ARE OVERTAKING ME"))
	target.apply_damage(50, BRUTE, BODY_ZONE_HEAD)
