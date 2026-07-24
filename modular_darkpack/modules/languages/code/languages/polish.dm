/datum/language/polish
	name = "Polish"
	desc = "A West Slavic language spoken by people from Poland and its diaspora."
	key = "P"
	flags = LANGUAGE_TONGUELESS_SPEECH
	space_chance = 45
	syllables = list(
		"tak", "nie", "ja", "ty", "on", "ona", "my", "wy", "oni",
		"do", "na", "za", "pod", "przy", "od", "po", "i", "ale", "czy",
		"co", "jak", "gdzie", "kto", "kiedy", "dob", "rze", "slaw", "wol",
		"noc", "dzien", "miasto", "dom", "ser", "ce", "glow", "wa", "rze",
		"sz", "cz", "rz", "dz", "dzy", "ski", "ska", "wicz", "czyk", "ak",
		"ek", "ow", "owa", "nik", "ny", "na", "lo", "ko", "wie", "cie"
	)
	icon_state = "polish"
	default_priority = 90

	mutual_understanding = list(
		/datum/language/czech = 45,
		/datum/language/ukrainian = 60,
		/datum/language/russian = 15,
		/datum/language/common = 10,
	)

	restricted = FALSE
