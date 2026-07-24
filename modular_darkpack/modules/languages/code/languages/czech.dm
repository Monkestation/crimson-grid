/datum/language/czech
	name = "Czech"
	desc = "A West Slavic language spoken by people from Czechia and its diaspora."
	key = "C"
	flags = LANGUAGE_TONGUELESS_SPEECH
	space_chance = 45
	syllables = list(
		"ano", "ne", "ja", "ty", "on", "ona", "my", "vy", "oni",
		"do", "na", "za", "pod", "pred", "od", "po", "a", "ale", "co",
		"jak", "kde", "kdo", "kdy", "proc", "dob", "re", "slav", "vol",
		"noc", "den", "mesto", "dum", "srd", "ce", "hla", "va", "pra",
		"br", "ch", "sh", "zh", "sky", "ska", "ek", "ova", "ik", "nik",
		"cek", "ka", "ko", "lo", "mi", "ro", "sti", "vek", "ny", "na"
	)
	icon_state = "czech"
	default_priority = 90

	mutual_understanding = list(
		/datum/language/polish = 45,
		/datum/language/ukrainian = 20,
		/datum/language/russian = 10,
		/datum/language/german = 10,
		/datum/language/common = 10,
	)

	restricted = FALSE
