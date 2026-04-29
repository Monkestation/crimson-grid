/datum/job_department/citizen
	department_name = DEPARTMENT_CITIZEN
	department_bitflags = DEPARTMENT_BITFLAG_CITIZEN
	// Don't add department_head! citizens names should not be in bold.

/// A special prince only department, for use by the preferences menu
/datum/job_department/prince
	department_name = DEPARTMENT_PRINCE
	department_bitflags = DEPARTMENT_BITFLAG_PRINCE
	department_head = /datum/job/vampire/prince

/datum/job_department/camarilla
	department_name = DEPARTMENT_CAMARILLA
	department_bitflags = DEPARTMENT_BITFLAG_CAMARILLA
	department_head = /datum/job/vampire/prince
	department_experience_type = EXP_TYPE_CAMARILLA
	display_order = 1
	label_class = "camarilla"
	ui_color = "#6681a5"

/datum/job_department/church
	department_name = DEPARTMENT_CHURCH
	department_bitflags = DEPARTMENT_BITFLAG_CHURCH
	department_head = /datum/job/vampire/prince
	department_experience_type = EXP_TYPE_CHURCH
	display_order = 1
	label_class = "church"
	ui_color = "#8c66a5"

/datum/job_department/clinic
	department_name = DEPARTMENT_CLINIC
	department_bitflags = DEPARTMENT_BITFLAG_CLINIC
	department_head = /datum/job/vampire/primogen_malkavian
	department_experience_type = EXP_TYPE_CLINIC
	display_order = 1
	label_class = "clinic"
	ui_color = "#6681a5"

/datum/job_department/anarch
	department_name = DEPARTMENT_ANARCH
	department_bitflags = DEPARTMENT_BITFLAG_ANARCH
	department_head = /datum/job/vampire/baron
	department_experience_type = EXP_TYPE_ANARCH
	display_order = 1
	label_class = "anarch"
	ui_color = "#a56666"

/datum/job_department/supply
	department_name = DEPARTMENT_SUPPLY
	department_bitflags = DEPARTMENT_BITFLAG_SUPPLY
	department_head = /datum/job/vampire/dealer
	department_experience_type = EXP_TYPE_WAREHOUSE
	display_order = 1
	label_class = "supply"
	ui_color = "#a58866"

/datum/job_department/strip_club
	department_name = DEPARTMENT_STRIP_CLUB
	department_bitflags = DEPARTMENT_BITFLAG_STRIP_CLUB
	department_head = /datum/job/vampire/primogen_toreador
	department_experience_type = EXP_TYPE_CLUB
	display_order = 1
	label_class = "strip_club"
	ui_color = "#a566a5ff"

/datum/job_department/giovanni
	department_name = DEPARTMENT_GIOVANNI
	department_bitflags = DEPARTMENT_BITFLAG_GIOVANNI
	department_head = /datum/job/vampire/capo
	department_experience_type = EXP_TYPE_GIOVANNI
	display_order = 1
	label_class = "giovanni"
	ui_color = "#66a569ff"

/datum/job_department/police
	department_name = DEPARTMENT_POLICE
	department_bitflags = DEPARTMENT_BITFLAG_POLICE
	department_head = /datum/job/vampire/police_captain
	department_experience_type = EXP_TYPE_POLICE
	display_order = 1
	label_class = "police"
	ui_color = "#6a6288ff"

/datum/job_department/sabbat
	department_name = DEPARTMENT_SABBAT
	department_bitflags = DEPARTMENT_BITFLAG_SABBAT
	department_head = /datum/job/vampire/sabbatductus
	department_experience_type = EXP_TYPE_SABBAT
	display_order = 1
	label_class = "sabbat"
	ui_color = "#4e4e4eff"

/datum/job_department/chantry
	department_name = DEPARTMENT_CHANTRY
	department_bitflags = DEPARTMENT_BITFLAG_CHANTRY
	department_head = /datum/job/vampire/regent
	department_experience_type = EXP_TYPE_CHANTRY
	display_order = 1
	label_class = "chantry"
	ui_color = "#a56666ff"

/datum/job_department/manor
	department_name = DEPARTMENT_MANOR
	department_bitflags = DEPARTMENT_BITFLAG_MANOR
	department_head = /datum/job/vampire/voivode
	department_experience_type = EXP_TYPE_MANOR
	display_order = 1
	label_class = "manor"
	ui_color = "#a066a5ff"

/datum/job_department/city_services
	department_name = DEPARTMENT_CITY_SERVICES
	department_bitflags = DEPARTMENT_BITFLAG_CITY_SERVICES

/datum/job_department/gaia
	department_name = DEPARTMENT_GAIA
	department_bitflags = DEPARTMENT_BITFLAG_GAIA
	department_head = /datum/job/vampire/councillor
	department_experience_type = EXP_TYPE_GAIA
	display_order = 1
	label_class = "gaia"
	ui_color = "#b4bd64"

/datum/job_department/pentex
	department_name = DEPARTMENT_PENTEX
	department_bitflags = DEPARTMENT_BITFLAG_PENTEX
	department_head = /datum/job/vampire/branch_lead
	department_experience_type = EXP_TYPE_SPIRAL
	display_order = 1
	label_class = "pentex"
	ui_color = COLOR_ENDRON_GREEN

// CRIMSON EDIT ADD - Hunters
/datum/job_department/society_of_leopold
	department_name = DEPARTMENT_SOCIETY_OF_LEOPOLD
	department_bitflags = DEPARTMENT_BITFLAG_SOCIETY_OF_LEOPOLD
	department_head = /datum/job/vampire/abbe
	department_experience_type = EXP_TYPE_CHURCH
	display_order = 1
	label_class = "society"
	ui_color = "#fff022"
// CRIMSON EDIT ADD - Hunters
