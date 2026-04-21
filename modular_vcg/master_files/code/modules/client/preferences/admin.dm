/datum/preference/toggle/admin
	abstract_type = /datum/preference/toggle/admin

/datum/preference/toggle/admin/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	return is_admin(preferences.parent)

/datum/preference/toggle/admin/auto_browser_inspect
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	default_value = FALSE
	savefile_key = "auto_browser_inspect"
	savefile_identifier = PREFERENCE_PLAYER
