/datum/language/spanish
	name = "Español"
	desc = "A romantic and widely spoken world language."
	key = "e"
	flags = LANGUAGE_TONGUELESS_SPEECH
	space_chance = 40
	syllables = list(
		"cha", "che", "chi", "cho", "chu", "lla", "lle", "lli", "llo", "llu",
		"ña", "ñe", "ño", "ñi", "nu", "que", "qui", "ro", "ri", "rá",
		"to", "te", "ta", "lo", "la", "po", "pe", "pa", "mo", "ma",
		"no", "na", "su", "sa", "le", "li", "ca", "ce", "ci", "co",
		"de", "di", "du", "go", "gu", "ve", "va", "bo", "ba", "lu",
		"re", "ru", "fi", "fo", "fa", "ya", "yo", "za", "zo", "ze"
	)
	icon_state = "spanish"
	default_priority = 90

	mutual_understanding = list(
		/datum/language/italian = 75,
		/datum/language/common = 25,
		/datum/language/latin = 10,
	)

	restricted = FALSE
