#define BREACH_WORD_FILES list(\
	"modular_darkpack/modules/masquerade/config/breach_word.txt",\
	"modular_darkpack/modules/masquerade/config/breach_word_ru.txt",\
)
#define BREACH_WORD_LETTERS "a-zа-я"
#define BREACH_WORD_CHARS "a-zа-я0-9_"
// BYOND fails with "regexp too big" on one regex for the whole list
#define BREACH_REGEX_MAX_LENGTH 1500

SUBSYSTEM_DEF(masquerade)
	name = "Masquerade"
	ss_flags = SS_NO_FIRE

	var/masquerade_level = MASQUERADE_MAX_LEVEL
	var/list/masquerade_breachers
	var/static/list/regex/masquerade_breaching_phrase_regexes

	// The round is soon to be declared ending. Scarey sounds during this.
	var/ending = FALSE
	var/roundend_started = FALSE

/datum/controller/subsystem/masquerade/Initialize()
	masquerade_breachers = new()
	masquerade_breaching_phrase_regexes = compile_breach_word_regexes(BREACH_WORD_FILES)
	RegisterSignal(src, COMSIG_PLAYER_MASQUERADE_REINFORCE, PROC_REF(player_masquerade_reinforce))
	return SS_INIT_SUCCESS

/// A word ending in "*" also matches with any letters after it, other words match whole
/datum/controller/subsystem/masquerade/proc/compile_breach_word_regexes(list/files)
	var/list/regexes = list()
	var/list/patterns = list()
	var/patterns_length = 0
	for(var/file in files)
		for(var/line in world.file2list(file))
			line = normalize_breach_text(trim(line))
			if(!line || copytext(line, 1, 2) == "#")
				continue
			var/pattern = breach_word_pattern(line)
			if(patterns.len && patterns_length + length_char(pattern) > BREACH_REGEX_MAX_LENGTH)
				regexes += breach_words_regex(patterns)
				patterns = list()
				patterns_length = 0
			patterns += pattern
			patterns_length += length_char(pattern) + 1
	if(patterns.len)
		regexes += breach_words_regex(patterns)
	return regexes

/datum/controller/subsystem/masquerade/proc/breach_word_pattern(entry)
	var/list/words = list()
	for(var/word in splittext(entry, " "))
		if(!word)
			continue
		if(length(word) > 1 && copytext_char(word, -1) == "*")
			words += "[REGEX_QUOTE(copytext_char(word, 1, -1))]\[[BREACH_WORD_LETTERS]\]*"
		else
			words += REGEX_QUOTE(word)
	return jointext(words, "\[ -\]+")

/datum/controller/subsystem/masquerade/proc/breach_words_regex(list/patterns)
	return regex("(?<!\[[BREACH_WORD_CHARS]\])(?:[jointext(patterns, "|")])(?!\[[BREACH_WORD_CHARS]\])", "i")

/datum/controller/subsystem/masquerade/proc/is_breaching_phrase(message)
	if(!message)
		return FALSE
	message = normalize_breach_text(message)
	for(var/regex/breaching_phrase_regex as anything in masquerade_breaching_phrase_regexes)
		if(findtext(message, breaching_phrase_regex))
			return TRUE
	return FALSE

/datum/controller/subsystem/masquerade/proc/normalize_breach_text(text)
	return replacetext(LOWER_TEXT(text), "ё", "е")

// Used for the status menu's masquerade breach text.
/datum/controller/subsystem/masquerade/proc/get_description()
	var/return_list = ""
	switch(masquerade_level)
		if(0)
			return_list += "МАСКАРАД РУХНУЛ: "
		if(1 to 9)
			return_list += "ГРУБЕЙШИЕ НАРУШЕНИЯ: "
		if(10 to 14)
			return_list += "ЗАМЕТНЫЕ НАРУШЕНИЯ: "
		if(15 to 20)
			return_list += "ПОДОЗРЕНИЯ: "
		else
			return_list += "СТАБИЛЕН: "
	return_list += "[masquerade_level]/[MASQUERADE_MAX_LEVEL]"
	return return_list

/*
 * Reinforces a specific player's masquerade and changes the global masquerade level accordingly.
 *
 * source - The object or mob that saw the masquerade breach.
 * player_breacher - The player which caused the masquerade breach.
 * reason - Optional, the reason for the breach. For example,
 */
/datum/controller/subsystem/masquerade/proc/masquerade_reinforce(atom/source, mob/living/player_breacher)
	. = FALSE
	for(var/masquerade_breach in masquerade_breachers)
		var/breach_sources = masquerade_breach[2]

		var/source_matches = FALSE
		// breach_sources can be a list if there is more than one blood skull, handle for that
		if(islist(breach_sources))
			source_matches = (source in breach_sources)
		else
			source_matches = (source == breach_sources)

		if(source_matches)
			masquerade_breachers -= list(masquerade_breach)
			masquerade_level = min(MASQUERADE_MAX_LEVEL, masquerade_level + 1)
			player_breacher.masquerade_score = min(5, player_breacher.masquerade_score + 1)
			. = TRUE
			break
	if(player_breacher.masquerade_score == 5) //Doesn't matter if they weren't in one of these lists.
		GLOB.veil_breakers_list -= player_breacher
		GLOB.masquerade_breakers_list -= player_breacher
		GLOB.supernatural_breakers_list -= player_breacher

	/*
	var/datum/splat/werewolf/werewolf_splat = get_werewolf_splat(player_breacher)
	if(istype(werewolf_splat))
		werewolf_splat.adjust_renown(pick(RENOWN_HONOR, RENOWN_GLORY, RENOWN_WISDOM), 1)
	*/

	save_persistent_masquerade(player_breacher)
	return .

/*
 * Breaches a specific player's masquerade and changes the global masquerade level accordingly.
 *
 * source - The object or mob that saw the masquerade breach.
 * player_breacher - The player which caused the masquerade breach.
 * reason - The reason for the breach. For example,
 */
/datum/controller/subsystem/masquerade/proc/masquerade_breach(atom/source, mob/living/player_breacher)
	log_game("[player_breacher] has caused a masquerade breach in front of [source]")
	var/pre_breach_score = player_breacher.masquerade_score
	if(pre_breach_score == 0)
		return
	player_breacher.masquerade_score = max(0, player_breacher.masquerade_score - 1)
	masquerade_breachers += list(list(player_breacher, source))
	track_breach_party(player_breacher) // CORVAX EDIT ADD
	track_breach_party(source) // CORVAX EDIT ADD
	if(get_vampire_splat(player_breacher))
		GLOB.masquerade_breakers_list |= player_breacher
		GLOB.supernatural_breakers_list |= player_breacher
	else if(get_werewolf_splat(player_breacher))
		GLOB.veil_breakers_list |= player_breacher
		GLOB.supernatural_breakers_list |= player_breacher
	//Only lower the global masq if the player's breach score is actually reduced by 1
	if(pre_breach_score > player_breacher.masquerade_score)
		masquerade_level = max(0, masquerade_level - 1)

	/*
	var/datum/splat/werewolf/werewolf_splat = get_werewolf_splat(player_breacher)
	if(istype(werewolf_splat))
		werewolf_splat.adjust_renown(pick(RENOWN_HONOR, RENOWN_GLORY, RENOWN_WISDOM), -1)
	*/

	save_persistent_masquerade(player_breacher)
	check_roundend_condition()

// Used for adding logging messages to every logging_machine in GLOB.loggin_machines
/datum/controller/subsystem/masquerade/proc/log_phone_message(message, obj/phone_source)
	for(var/obj/machinery/logging_machine/logging_machine as anything in GLOB.logging_machines)
		logging_machine.saved_logs += list(list(message, WEAKREF(phone_source))) // CORVAX EDIT CHANGE - every phone used in a call stayed referenced. ORIGINAL: list(list(message, phone_source))

// Save the player's masquerade level to their character sheet.
/datum/controller/subsystem/masquerade/proc/save_persistent_masquerade(mob/living/player_breacher)
	var/mob/living/carbon/human/human_breacher = player_breacher
	if(!istype(human_breacher))
		return
	human_breacher.write_preference_midround(/datum/preference/numeric/masquerade, player_breacher.masquerade_score)

// This is for clearing the round's masquerade because a player matrix'd
/datum/controller/subsystem/masquerade/proc/matrix_masquerade_breacher(mob/living/player_breacher, update_preferences)
	for(var/masquerade_breach in masquerade_breachers)
		if((player_breacher in masquerade_breach))
			masquerade_breachers -= list(masquerade_breach)
			masquerade_level = min(MASQUERADE_MAX_LEVEL, masquerade_level + 1)
	GLOB.masquerade_breakers_list -= player_breacher
	GLOB.veil_breakers_list -= player_breacher
	GLOB.supernatural_breakers_list -= player_breacher
	if(update_preferences)
		save_persistent_masquerade(player_breacher)

// This is for checking if a joined player should be on the breachers list.
/datum/controller/subsystem/masquerade/proc/masquerade_breacher_check(mob/living/player_breacher)
	if(player_breacher.masquerade_score < 5)
		if(get_vampire_splat(player_breacher))
			GLOB.masquerade_breakers_list |= player_breacher
			GLOB.supernatural_breakers_list |= player_breacher
		else if(get_werewolf_splat(player_breacher))
			GLOB.veil_breakers_list |= player_breacher
			GLOB.supernatural_breakers_list |= player_breacher
	else
		GLOB.masquerade_breakers_list -= player_breacher
		GLOB.veil_breakers_list -= player_breacher
		GLOB.supernatural_breakers_list -= player_breacher

/datum/controller/subsystem/masquerade/proc/player_masquerade_reinforce(datum/source, mob/living/player_breacher)
	SIGNAL_HANDLER

	for(var/masquerade_breach in masquerade_breachers)
		var/list/masquerade_breach_list = masquerade_breach
		if(islist(masquerade_breach_list[2])) //If its the skull list, then its a long term masq breach. Clear it.
			for(var/atom/list_object as anything in masquerade_breach_list[2])
				SSmasquerade.masquerade_reinforce(list_object, masquerade_breach_list[1])
				return
		else
			var/atom/object = masquerade_breach_list[2]
			SEND_SIGNAL(object, COMSIG_MASQUERADE_REINFORCE, player_breacher)
			return

// A check for if we should be ending the round.
/datum/controller/subsystem/masquerade/proc/check_roundend_condition()
	if((masquerade_level != 0) || ending)
		return
	ending = TRUE
	for(var/player in GLOB.player_list)
		SEND_SOUND(player, 'modular_darkpack/modules/masquerade/sound/masquerade_failure.ogg') //Alerting them of their demise.
	addtimer(CALLBACK(src, PROC_REF(end_round)), 65 SECONDS)
	SSweather.run_weather(/datum/weather/particle/rain_storm/blood)

// Ending the actual round.
/datum/controller/subsystem/masquerade/proc/end_round()
	for(var/masquerade_breach in masquerade_breachers)
		var/list/masquerade_breach_list = masquerade_breach
		if(islist(masquerade_breach_list[2])) //If its the skull list, then its a long term masq breach. Clear it.
			for(var/atom/list_object as anything in masquerade_breach_list[2])
				SSmasquerade.masquerade_reinforce(list_object, masquerade_breach_list[1])
		else
			var/atom/object = masquerade_breach_list[2]
			SEND_SIGNAL(object, COMSIG_ALL_MASQUERADE_REINFORCE)

	GLOB.canon_event = FALSE
	roundend_started = TRUE

#undef BREACH_WORD_FILES
#undef BREACH_WORD_LETTERS
#undef BREACH_WORD_CHARS
#undef BREACH_REGEX_MAX_LENGTH
