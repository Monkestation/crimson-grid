/datum/language/russian
	name = "Russian"
	desc = "The language of Mother Russia."
	key = "r"
	flags = LANGUAGE_TONGUELESS_SPEECH
	space_chance = 40
	syllables = list(
		"da", "net", "blin", "suka", "ho", "ya", "ty", "on", "ona", "vy", "oni",
		"mo", "do", "po", "na", "za", "ot", "pod", "mi", "vi", "re", "ko", "vo",
		"lo", "bo", "go", "ni", "ra", "va", "ka", "pa", "ga", "la", "ba", "ma",
		"so", "sto", "pro", "chto", "zlo", "dro", "pra", "svo", "kto", "ili",
		"ova", "e", "ya", "on", "to", "vo", "da", "ne", "no", "li", "mu", "ko",
		"me", "te", "chi", "sha", "ska", "ski", "ova", "cha", "nya", "rya", "zha"
	)
	icon_state = "russian"
	default_priority = 90

	mutual_understanding = list(
		/datum/language/polish = 35,
		/datum/language/czech = 20,
		/datum/language/ukrainian = 60,
		/datum/language/common = 10,
	)

	restricted = FALSE

// Overides so the BODA machine uses real russian
/datum/language_holder/spinwarder
	understood_languages = list(
		/datum/language/common = list(LANGUAGE_ATOM),
		/datum/language/russian = list(LANGUAGE_ATOM),
	)
	spoken_languages = list(
		/datum/language/common = list(LANGUAGE_ATOM),
		/datum/language/russian = list(LANGUAGE_ATOM),
	)
	selected_language = /datum/language/russian

/datum/language_holder/spinwarder_exclusive
	understood_languages = list(
		/datum/language/russian = list(LANGUAGE_ATOM),
	)
	spoken_languages = list(
		/datum/language/russian = list(LANGUAGE_ATOM),
	)
	selected_language = /datum/language/russian
