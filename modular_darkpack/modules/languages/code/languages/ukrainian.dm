/datum/language/ukrainian
	name = "Ukrainian"
	desc = "An East Slavic language spoken by people from Ukraine and its diaspora."
	key = "U"
	flags = LANGUAGE_TONGUELESS_SPEECH
	space_chance = 45
	syllables = list(
		"tak", "ni", "ya", "ty", "vin", "vona", "my", "vy", "vony",
		"do", "na", "za", "pid", "pro", "vid", "po", "ta", "i", "ale",
		"sho", "yak", "de", "khto", "koly", "chomu", "dobre", "slava",
		"volya", "mir", "nich", "den", "misto", "selo", "rid", "dim",
		"ser", "tse", "ko", "lyu", "bo", "ro", "ho", "lo", "va", "na",
		"zha", "cha", "sha", "tsya", "nya", "lya", "ri", "ski", "ova",
		"enko", "iv", "ych", "yuk", "chuk", "vich", "sky", "ska"
	)
	icon_state = "ukrainian"
	default_priority = 90

	mutual_understanding = list(
		/datum/language/polish = 60,
		/datum/language/czech = 20,
		/datum/language/russian = 60,
		/datum/language/common = 10,
	)

	restricted = FALSE
