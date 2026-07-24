/datum/preference/choiced/country_of_origin
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "country_of_origin"
	can_randomize = FALSE

/datum/preference/choiced/country_of_origin/init_possible_values()
	return list(
		"Afghanistan", "Albania", "Algeria", "American Samoa", "Andorra", "Angola", "Antigua and Barbuda", "Argentina", "Armenia", "Australia", "Austria", "Azerbaijan", "Bahamas",
		"Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia", "Bosnia and Herzegovina", "Botswana", "Brazil", "Brunei", "Bulgaria", "Burkina Faso",
		"Burundi", "Cambodia", "Cameroon", "Canada", "Cape Verde", "Cayman Islands", "Central African Republic", "Chad", "Chile", "China", "Colombia", "Comoros", "Democratic Republic of the Congo",
		"Republic of the Congo", "Costa Rica", "Côte d'Ivoire", "Croatia", "Cuba", "Curaçao", "Cyprus", "Czech Republic", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "East Timor",
		"Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia", "Faroe Islands", "Fiji", "Finland", "France", "French Polynesia", "Gabon", "Gambia", "Georgia", "Germany",
		"Ghana", "Greece", "Greenland", "Grenada", "Guam", "Guatemala", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Honduras", "Hong Kong", "Hungary", "Iceland", "India", "Indonesia", "Iran", "Iraq", "Ireland",
		"Israel", "Italy", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "North Korea", "South Korea", "Kosovo", "Kuwait", "Kyrgyzstan", "Laos", "Latvia", "Lebanon", "Lesotho", "Liberia",
		"Libya", "Liechtenstein", "Lithuania", "Luxembourg", "Macedonia", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Mauritania", "Mauritius", "Mexico",
		"Micronesia", "Moldova", "Monaco", "Mongolia", "Montenegro", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru", "Nepal", "Netherlands", "New Zealand", "Nicaragua", "Niger", "Nigeria", "Northern Mariana Islands",
		"Norway", "Oman", "Pakistan", "Palau", "State of Palestine", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Poland", "Portugal", "Puerto Rico", "Qatar", "Romania", "Russia",
		"Rwanda", "Saint Kitts and Nevis", "Saint Lucia", "Saint Vincent and the Grenadines", "Samoa", "San Marino", "Sao Tome and Principe", "Saudi Arabia", "Senegal", "Serbia", "Seychelles", "Sierra Leone",
		"Singapore", "Sint Maarten", "Slovakia", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "Spain", "Sri Lanka", "Sudan", "South Sudan", "Suriname", "Swaziland", "Sweden", "Switzerland", "Syria",
		"Taiwan", "Tajikistan", "Tanzania", "Thailand", "Togo", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom",
		"United States", "Uruguay", "Uzbekistan", "Vanuatu", "Vatican City", "Venezuela", "Vietnam", "British Virgin Islands", "U.S. Virgin Islands", "Yemen", "Zambia", "Zimbabwe"
	)

/datum/preference/choiced/country_of_origin/create_default_value()
	return "United States"

/datum/preference/choiced/country_of_origin/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/choiced/state_of_origin
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "state_of_origin"
	can_randomize = FALSE

/datum/preference/choiced/state_of_origin/init_possible_values()
	return list(
		"Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia",
		"Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland",
		"Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey",
		"New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina",
		"South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming",
		"District of Columbia", "Puerto Rico", "Guam", "U.S. Virgin Islands", "American Samoa", "Northern Mariana Islands"
	)

/datum/preference/choiced/state_of_origin/create_default_value()
	return "California"

/datum/preference/choiced/state_of_origin/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/choiced/state_of_origin/is_accessible(datum/preferences/preferences)
	. = ..()
	if(!.)
		return FALSE
	var/country = preferences.read_preference(/datum/preference/choiced/country_of_origin)
	return (country == "United States")

/datum/preference/choiced/country_of_origin/apply_to_human(mob/living/carbon/human/target, value)
	var/static/list/country_language_map
	if(!country_language_map)
		country_language_map = list(
			// spanish-speaking countries
			"Argentina" = list(/datum/language/spanish),
			"Bolivia" = list(/datum/language/spanish),
			"Chile" = list(/datum/language/spanish),
			"Colombia" = list(/datum/language/spanish),
			"Costa Rica" = list(/datum/language/spanish),
			"Cuba" = list(/datum/language/spanish),
			"Dominican Republic" = list(/datum/language/spanish),
			"Ecuador" = list(/datum/language/spanish),
			"El Salvador" = list(/datum/language/spanish),
			"Equatorial Guinea" = list(/datum/language/spanish),
			"Guatemala" = list(/datum/language/spanish),
			"Honduras" = list(/datum/language/spanish),
			"Mexico" = list(/datum/language/spanish),
			"Nicaragua" = list(/datum/language/spanish),
			"Panama" = list(/datum/language/spanish),
			"Paraguay" = list(/datum/language/spanish),
			"Peru" = list(/datum/language/spanish),
			"Puerto Rico" = list(/datum/language/spanish),
			"Spain" = list(/datum/language/spanish),
			"Uruguay" = list(/datum/language/spanish),
			"Venezuela" = list(/datum/language/spanish),
			// arabic/middle eastern countries
			"Algeria" = list(/datum/language/arabic),
			"Bahrain" = list(/datum/language/arabic),
			"Comoros" = list(/datum/language/arabic),
			"Djibouti" = list(/datum/language/arabic),
			"Egypt" = list(/datum/language/arabic),
			"Iraq" = list(/datum/language/arabic),
			"Jordan" = list(/datum/language/arabic),
			"Lebanon" = list(/datum/language/arabic),
			"Libya" = list(/datum/language/arabic),
			"Mauritania" = list(/datum/language/arabic),
			"Morocco" = list(/datum/language/arabic),
			"Oman" = list(/datum/language/arabic),
			"Kuwait" = list(/datum/language/arabic),
			"Qatar" = list(/datum/language/arabic),
			"Saudi Arabia" = list(/datum/language/arabic),
			"Somalia" = list(/datum/language/arabic),
			"State of Palestine" = list(/datum/language/arabic),
			"Sudan" = list(/datum/language/arabic),
			"Syria" = list(/datum/language/arabic),
			"Tunisia" = list(/datum/language/arabic),
			"United Arab Emirates" = list(/datum/language/arabic),
			"Yemen" = list(/datum/language/arabic),
			// farsi + arabic
			"Afghanistan" = list(/datum/language/farsi, /datum/language/arabic),
			"Iran" = list(/datum/language/farsi, /datum/language/arabic),
			"Tajikistan" = list(/datum/language/farsi, /datum/language/arabic),
			// french-speaking countries
			"Belgium" = list(/datum/language/french),
			"Benin" = list(/datum/language/french),
			"Burkina Faso" = list(/datum/language/french),
			"Cameroon" = list(/datum/language/french),
			"Central African Republic" = list(/datum/language/french),
			"Chad" = list(/datum/language/french),
			"Côte d'Ivoire" = list(/datum/language/french),
			"Democratic Republic of the Congo" = list(/datum/language/french),
			"France" = list(/datum/language/french),
			"French Polynesia" = list(/datum/language/french),
			"Gabon" = list(/datum/language/french),
			"Guinea" = list(/datum/language/french),
			"Haiti" = list(/datum/language/french),
			"Luxembourg" = list(/datum/language/french),
			"Madagascar" = list(/datum/language/french),
			"Mali" = list(/datum/language/french),
			"Mauritius" = list(/datum/language/french),
			"Monaco" = list(/datum/language/french),
			"Niger" = list(/datum/language/french),
			"Republic of the Congo" = list(/datum/language/french),
			"Rwanda" = list(/datum/language/french),
			"Senegal" = list(/datum/language/french),
			"Seychelles" = list(/datum/language/french),
			"Togo" = list(/datum/language/french),
			// german-speaking countries
			"Austria" = list(/datum/language/german),
			"Germany" = list(/datum/language/german),
			"Liechtenstein" = list(/datum/language/german),
			"Switzerland" = list(/datum/language/german),
			// russian-speaking countries
			"Belarus" = list(/datum/language/russian),
			"Kazakhstan" = list(/datum/language/russian),
			"Kyrgyzstan" = list(/datum/language/russian),
			"Russia" = list(/datum/language/russian),
			"Turkmenistan" = list(/datum/language/russian),
			"Uzbekistan" = list(/datum/language/russian),
			// italian-speaking countries
			"Italy" = list(/datum/language/italian),
			"San Marino" = list(/datum/language/italian),
			// korean
			"North Korea" = list(/datum/language/korean),
			"South Korea" = list(/datum/language/korean),
			// greek
			"Cyprus" = list(/datum/language/greek),
			"Greece" = list(/datum/language/greek),
			// mandarin
			"China" = list(/datum/language/mandarin),
			"Singapore" = list(/datum/language/mandarin),
			"Taiwan" = list(/datum/language/mandarin),
			"Japan" = list(/datum/language/japanese),
			"Poland" = list(/datum/language/polish),
			"Czech Republic" = list(/datum/language/czech),
			"Ukraine" = list(/datum/language/ukrainian, /datum/language/russian),
			"Armenia" = list(/datum/language/armenian),
			"Israel" = list(/datum/language/hebrew),
			"Hong Kong" = list(/datum/language/mandarin, /datum/language/cantonese),
			"Philippines" = list(/datum/language/tagalog),
			"Ireland" = list(/datum/language/irish),
			"Vatican City" = list(/datum/language/latin),
		)
	var/list/languages = country_language_map[value]
	if(!languages)
		return
	for(var/language_type in languages)
		if(!target.has_language(language_type))
			target.grant_language(language_type, SPOKEN_LANGUAGE|UNDERSTOOD_LANGUAGE, source = "country_of_origin")
