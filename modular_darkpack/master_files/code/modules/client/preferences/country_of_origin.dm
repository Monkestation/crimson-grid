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
		"Micronesia", "Moldova", "Monaco", "Mongolia", "Montenegro", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru", "Nepal", "Netherlands", "New Zealand", "Nicaragua", /*"Niger", "Nigeria",*/ "Northern Mariana Islands",
		"Norway", "Oman", "Pakistan", "Palau", "State of Palestine", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Poland", "Portugal", "Puerto Rico", "Qatar", "Romania", "Russia",
		"Rwanda", "Saint Kitts and Nevis", "Saint Lucia", "Saint Vincent and the Grenadines", "Samoa", "San Marino", "Sao Tome and Principe", "Saudi Arabia", "Senegal", "Serbia", "Seychelles", "Sierra Leone",
		"Singapore", "Sint Maarten", "Slovakia", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "Spain", "Sri Lanka", "Sudan", "South Sudan", "Suriname", "Swaziland", "Sweden", "Switzerland", "Syria",
		"Taiwan", "Tajikistan", "Tanzania", "Thailand", "Togo", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom",
		"United States", "Uruguay", "Uzbekistan", "Vanuatu", "Vatican City", "Venezuela", "Vietnam", "British Virgin Islands", "U.S. Virgin Islands", "Yemen", "Zambia", "Zimbabwe"
	)

/datum/preference/choiced/country_of_origin/create_informed_default_value(datum/preferences/preferences)
	if(prob(90)) //most people are gonna be from the USA
		return ..()
	return pick(cached_values)

/datum/preference/choiced/country_of_origin/create_default_value()
	return "United States"

/datum/preference/choiced/country_of_origin/compile_constant_data()
	var/list/data = ..()
	data[CHOICED_PREFERENCE_DISPLAY_NAMES] = ru_country_names()
	return data

/datum/preference/choiced/country_of_origin/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.country_of_origin = value
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
			// "Niger" = list(/datum/language/french),
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
			target.grant_language(language_type, SPOKEN_LANGUAGE|UNDERSTOOD_LANGUAGE, source = "province_of_origin")

/datum/preference/choiced/state_of_origin
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "state_of_origin"
	priority = /datum/preference/choiced/country_of_origin::priority + 0.1
	can_randomize = FALSE
	must_be_accessible = TRUE

/datum/preference/choiced/state_of_origin/init_possible_values()
	return list(
		"Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia",
		"Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland",
		"Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey",
		"New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina",
		"South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming",
		"District of Columbia", "Puerto Rico", "Guam", "U.S. Virgin Islands", "American Samoa", "Northern Mariana Islands"
	)

/datum/preference/choiced/state_of_origin/create_informed_default_value(datum/preferences/preferences)
	if(prob(80))
		return ..()
	return pick(cached_values)

/datum/preference/choiced/state_of_origin/create_default_value()
	return "California"

/datum/preference/choiced/state_of_origin/compile_constant_data()
	var/list/data = ..()
	data[CHOICED_PREFERENCE_DISPLAY_NAMES] = ru_us_state_names()
	return data

/datum/preference/choiced/state_of_origin/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.country_of_origin = "United States, [value]"

/datum/preference/choiced/state_of_origin/is_accessible(datum/preferences/preferences)
	. = ..()
	if(!.)
		return FALSE
	var/country = preferences.read_preference(/datum/preference/choiced/country_of_origin)
	return (country == "United States")

/datum/preference/choiced/province_of_origin
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "province_of_origin"
	priority = /datum/preference/choiced/country_of_origin::priority + 0.1
	can_randomize = FALSE
	must_be_accessible = TRUE

/datum/preference/choiced/province_of_origin/init_possible_values()
	return list(
		"British Columbia", "Alberta", "Saskatchewan", "Manitoba", "Ontario", "Quebec", "New Brunswick",
		"Nova Scotia", "Prince Edward Island", "Newfoundland and Labrador", "Yukon", "Northwest Territories",
		"Nunvaut",
	)

/datum/preference/choiced/province_of_origin/create_informed_default_value(datum/preferences/preferences)
	if(prob(50))
		return ..()
	return pick(cached_values)

/datum/preference/choiced/province_of_origin/create_default_value()
	return "Ontario"

/datum/preference/choiced/province_of_origin/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.country_of_origin = "Canada, [value]"
	var/static/list/province_language_map
	if(!province_language_map)
		province_language_map = list(
			// french-speaking provinces
			"Quebec" = list(/datum/language/french),
			"New Brunswick" = list(/datum/language/french),
			"Yukon" = list(/datum/language/french),
		)
	var/list/languages = province_language_map[value]
	if(!languages)
		return
	for(var/language_type in languages)
		if(!target.has_language(language_type))
			target.grant_language(language_type, SPOKEN_LANGUAGE|UNDERSTOOD_LANGUAGE, source = "country_of_origin")

/datum/preference/choiced/province_of_origin/is_accessible(datum/preferences/preferences)
	. = ..()
	if(!.)
		return FALSE
	var/country = preferences.read_preference(/datum/preference/choiced/country_of_origin)
	return (country == "Canada")

/datum/preference/choiced/nation_of_origin
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "nation_of_origin"
	priority = /datum/preference/choiced/country_of_origin::priority + 0.1
	can_randomize = FALSE
	must_be_accessible = TRUE

/datum/preference/choiced/nation_of_origin/init_possible_values()
	return list(
		"England", "Wales", "Scotland", "Northern Ireland"
	)

/datum/preference/choiced/nation_of_origin/create_informed_default_value(datum/preferences/preferences)
	if(prob(50))
		return ..()
	return pick(cached_values)

/datum/preference/choiced/nation_of_origin/create_default_value()
	return "England"

/datum/preference/choiced/nation_of_origin/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.country_of_origin = "United Kingdom, [value]"
	var/static/list/nation_language_map
	if(!nation_language_map)
		nation_language_map = list(
			"Wales" = list(/datum/language/welsh),
			"Scotland" = list(/datum/language/scottish),
			"Northern Ireland" = list(/datum/language/irish),
		)
	var/list/languages = nation_language_map[value]
	if(!languages)
		return
	for(var/language_type in languages)
		if(!target.has_language(language_type))
			target.grant_language(language_type, SPOKEN_LANGUAGE|UNDERSTOOD_LANGUAGE, source = "country_of_origin")

/datum/preference/choiced/nation_of_origin/is_accessible(datum/preferences/preferences)
	. = ..()
	if(!.)
		return FALSE
	var/country = preferences.read_preference(/datum/preference/choiced/country_of_origin)
	return (country == "United Kingdom")

/// Stored country value -> name shown to the player
/proc/ru_country_names()
	var/static/list/names
	if(!names)
		names = list(
			"Afghanistan" = "Афганистан",
			"Albania" = "Албания",
			"Algeria" = "Алжир",
			"American Samoa" = "Американское Самоа",
			"Andorra" = "Андорра",
			"Angola" = "Ангола",
			"Antigua and Barbuda" = "Антигуа и Барбуда",
			"Argentina" = "Аргентина",
			"Armenia" = "Армения",
			"Australia" = "Австралия",
			"Austria" = "Австрия",
			"Azerbaijan" = "Азербайджан",
			"Bahamas" = "Багамские Острова",
			"Bahrain" = "Бахрейн",
			"Bangladesh" = "Бангладеш",
			"Barbados" = "Барбадос",
			"Belarus" = "Беларусь",
			"Belgium" = "Бельгия",
			"Belize" = "Белиз",
			"Benin" = "Бенин",
			"Bermuda" = "Бермудские Острова",
			"Bhutan" = "Бутан",
			"Bolivia" = "Боливия",
			"Bosnia and Herzegovina" = "Босния и Герцеговина",
			"Botswana" = "Ботсвана",
			"Brazil" = "Бразилия",
			"Brunei" = "Бруней",
			"Bulgaria" = "Болгария",
			"Burkina Faso" = "Буркина-Фасо",
			"Burundi" = "Бурунди",
			"Cambodia" = "Камбоджа",
			"Cameroon" = "Камерун",
			"Canada" = "Канада",
			"Cape Verde" = "Кабо-Верде",
			"Cayman Islands" = "Каймановы Острова",
			"Central African Republic" = "Центральноафриканская Республика",
			"Chad" = "Чад",
			"Chile" = "Чили",
			"China" = "Китай",
			"Colombia" = "Колумбия",
			"Comoros" = "Коморы",
			"Democratic Republic of the Congo" = "Демократическая Республика Конго",
			"Republic of the Congo" = "Республика Конго",
			"Costa Rica" = "Коста-Рика",
			"Côte d'Ivoire" = "Кот-д'Ивуар",
			"Croatia" = "Хорватия",
			"Cuba" = "Куба",
			"Curaçao" = "Кюрасао",
			"Cyprus" = "Кипр",
			"Czech Republic" = "Чехия",
			"Denmark" = "Дания",
			"Djibouti" = "Джибути",
			"Dominica" = "Доминика",
			"Dominican Republic" = "Доминиканская Республика",
			"East Timor" = "Восточный Тимор",
			"Ecuador" = "Эквадор",
			"Egypt" = "Египет",
			"El Salvador" = "Сальвадор",
			"Equatorial Guinea" = "Экваториальная Гвинея",
			"Eritrea" = "Эритрея",
			"Estonia" = "Эстония",
			"Ethiopia" = "Эфиопия",
			"Faroe Islands" = "Фарерские острова",
			"Fiji" = "Фиджи",
			"Finland" = "Финляндия",
			"France" = "Франция",
			"French Polynesia" = "Французская Полинезия",
			"Gabon" = "Габон",
			"Gambia" = "Гамбия",
			"Georgia" = "Грузия",
			"Germany" = "Германия",
			"Ghana" = "Гана",
			"Greece" = "Греция",
			"Greenland" = "Гренландия",
			"Grenada" = "Гренада",
			"Guam" = "Гуам",
			"Guatemala" = "Гватемала",
			"Guinea" = "Гвинея",
			"Guinea-Bissau" = "Гвинея-Бисау",
			"Guyana" = "Гайана",
			"Haiti" = "Гаити",
			"Honduras" = "Гондурас",
			"Hong Kong" = "Гонконг",
			"Hungary" = "Венгрия",
			"Iceland" = "Исландия",
			"India" = "Индия",
			"Indonesia" = "Индонезия",
			"Iran" = "Иран",
			"Iraq" = "Ирак",
			"Ireland" = "Ирландия",
			"Israel" = "Израиль",
			"Italy" = "Италия",
			"Jamaica" = "Ямайка",
			"Japan" = "Япония",
			"Jordan" = "Иордания",
			"Kazakhstan" = "Казахстан",
			"Kenya" = "Кения",
			"Kiribati" = "Кирибати",
			"North Korea" = "Северная Корея",
			"South Korea" = "Южная Корея",
			"Kosovo" = "Косово",
			"Kuwait" = "Кувейт",
			"Kyrgyzstan" = "Киргизия",
			"Laos" = "Лаос",
			"Latvia" = "Латвия",
			"Lebanon" = "Ливан",
			"Lesotho" = "Лесото",
			"Liberia" = "Либерия",
			"Libya" = "Ливия",
			"Liechtenstein" = "Лихтенштейн",
			"Lithuania" = "Литва",
			"Luxembourg" = "Люксембург",
			"Macedonia" = "Македония",
			"Madagascar" = "Мадагаскар",
			"Malawi" = "Малави",
			"Malaysia" = "Малайзия",
			"Maldives" = "Мальдивы",
			"Mali" = "Мали",
			"Malta" = "Мальта",
			"Marshall Islands" = "Маршалловы Острова",
			"Mauritania" = "Мавритания",
			"Mauritius" = "Маврикий",
			"Mexico" = "Мексика",
			"Micronesia" = "Микронезия",
			"Moldova" = "Молдавия",
			"Monaco" = "Монако",
			"Mongolia" = "Монголия",
			"Montenegro" = "Черногория",
			"Morocco" = "Марокко",
			"Mozambique" = "Мозамбик",
			"Myanmar" = "Мьянма",
			"Namibia" = "Намибия",
			"Nauru" = "Науру",
			"Nepal" = "Непал",
			"Netherlands" = "Нидерланды",
			"New Zealand" = "Новая Зеландия",
			"Nicaragua" = "Никарагуа",
			// "Niger" = "Нигер",
			// "Nigeria" = "Нигерия",
			"Northern Mariana Islands" = "Северные Марианские острова",
			"Norway" = "Норвегия",
			"Oman" = "Оман",
			"Pakistan" = "Пакистан",
			"Palau" = "Палау",
			"State of Palestine" = "Палестина",
			"Panama" = "Панама",
			"Papua New Guinea" = "Папуа - Новая Гвинея",
			"Paraguay" = "Парагвай",
			"Peru" = "Перу",
			"Philippines" = "Филиппины",
			"Poland" = "Польша",
			"Portugal" = "Португалия",
			"Puerto Rico" = "Пуэрто-Рико",
			"Qatar" = "Катар",
			"Romania" = "Румыния",
			"Russia" = "Россия",
			"Rwanda" = "Руанда",
			"Saint Kitts and Nevis" = "Сент-Китс и Невис",
			"Saint Lucia" = "Сент-Люсия",
			"Saint Vincent and the Grenadines" = "Сент-Винсент и Гренадины",
			"Samoa" = "Самоа",
			"San Marino" = "Сан-Марино",
			"Sao Tome and Principe" = "Сан-Томе и Принсипи",
			"Saudi Arabia" = "Саудовская Аравия",
			"Senegal" = "Сенегал",
			"Serbia" = "Сербия",
			"Seychelles" = "Сейшельские Острова",
			"Sierra Leone" = "Сьерра-Леоне",
			"Singapore" = "Сингапур",
			"Sint Maarten" = "Синт-Мартен",
			"Slovakia" = "Словакия",
			"Slovenia" = "Словения",
			"Solomon Islands" = "Соломоновы Острова",
			"Somalia" = "Сомали",
			"South Africa" = "ЮАР",
			"Spain" = "Испания",
			"Sri Lanka" = "Шри-Ланка",
			"Sudan" = "Судан",
			"South Sudan" = "Южный Судан",
			"Suriname" = "Суринам",
			"Swaziland" = "Свазиленд",
			"Sweden" = "Швеция",
			"Switzerland" = "Швейцария",
			"Syria" = "Сирия",
			"Taiwan" = "Тайвань",
			"Tajikistan" = "Таджикистан",
			"Tanzania" = "Танзания",
			"Thailand" = "Таиланд",
			"Togo" = "Того",
			"Tonga" = "Тонга",
			"Trinidad and Tobago" = "Тринидад и Тобаго",
			"Tunisia" = "Тунис",
			"Turkey" = "Турция",
			"Turkmenistan" = "Туркмения",
			"Tuvalu" = "Тувалу",
			"Uganda" = "Уганда",
			"Ukraine" = "Украина",
			"United Arab Emirates" = "ОАЭ",
			"United Kingdom" = "Великобритания",
			"United States" = "США",
			"Uruguay" = "Уругвай",
			"Uzbekistan" = "Узбекистан",
			"Vanuatu" = "Вануату",
			"Vatican City" = "Ватикан",
			"Venezuela" = "Венесуэла",
			"Vietnam" = "Вьетнам",
			"British Virgin Islands" = "Британские Виргинские острова",
			"U.S. Virgin Islands" = "Виргинские острова США",
			"Yemen" = "Йемен",
			"Zambia" = "Замбия",
			"Zimbabwe" = "Зимбабве",
		)
	return names

/// Stored US state value -> name shown to the player
/proc/ru_us_state_names()
	var/static/list/names
	if(!names)
		names = list(
			"Alabama" = "Алабама",
			"Alaska" = "Аляска",
			"Arizona" = "Аризона",
			"Arkansas" = "Арканзас",
			"California" = "Калифорния",
			"Colorado" = "Колорадо",
			"Connecticut" = "Коннектикут",
			"Delaware" = "Делавэр",
			"Florida" = "Флорида",
			"Georgia" = "Джорджия",
			"Hawaii" = "Гавайи",
			"Idaho" = "Айдахо",
			"Illinois" = "Иллинойс",
			"Indiana" = "Индиана",
			"Iowa" = "Айова",
			"Kansas" = "Канзас",
			"Kentucky" = "Кентукки",
			"Louisiana" = "Луизиана",
			"Maine" = "Мэн",
			"Maryland" = "Мэриленд",
			"Massachusetts" = "Массачусетс",
			"Michigan" = "Мичиган",
			"Minnesota" = "Миннесота",
			"Mississippi" = "Миссисипи",
			"Missouri" = "Миссури",
			"Montana" = "Монтана",
			"Nebraska" = "Небраска",
			"Nevada" = "Невада",
			"New Hampshire" = "Нью-Гэмпшир",
			"New Jersey" = "Нью-Джерси",
			"New Mexico" = "Нью-Мексико",
			"New York" = "Нью-Йорк",
			"North Carolina" = "Северная Каролина",
			"North Dakota" = "Северная Дакота",
			"Ohio" = "Огайо",
			"Oklahoma" = "Оклахома",
			"Oregon" = "Орегон",
			"Pennsylvania" = "Пенсильвания",
			"Rhode Island" = "Род-Айленд",
			"South Carolina" = "Южная Каролина",
			"South Dakota" = "Южная Дакота",
			"Tennessee" = "Теннесси",
			"Texas" = "Техас",
			"Utah" = "Юта",
			"Vermont" = "Вермонт",
			"Virginia" = "Виргиния",
			"Washington" = "Вашингтон",
			"West Virginia" = "Западная Виргиния",
			"Wisconsin" = "Висконсин",
			"Wyoming" = "Вайоминг",
			"District of Columbia" = "Округ Колумбия",
			"Puerto Rico" = "Пуэрто-Рико",
			"Guam" = "Гуам",
			"U.S. Virgin Islands" = "Виргинские острова США",
			"American Samoa" = "Американское Самоа",
			"Northern Mariana Islands" = "Северные Марианские острова",
		)
	return names
