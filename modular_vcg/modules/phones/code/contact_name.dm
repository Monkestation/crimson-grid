// Opsec level: allows characters to set their preferred contact display name under Character Lore. Blank uses their actual character name.

/datum/preference/text/phone_contact_name
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL // Character Lore page
	savefile_identifier = PREFERENCE_CHARACTER // per character, not per account
	savefile_key = "phone_contact_name" // TSX will not find this if the name doesn't match so changing it will cause everything from before to be lost
	maximum_value_length = MAX_NAME_LEN // Contact ID can be no longer than character names (42 char)

// Follow same validation rules as character names to avoid badness

/datum/preference/text/phone_contact_name/deserialize(input, datum/preferences/preferences)
	return reject_bad_name("[input]") || ""

/datum/preference/text/phone_contact_name/is_valid(value, datum/preferences/preferences)
	return istext(value) && (!length(value) || !isnull(reject_bad_name(value)))

/datum/preference/text/phone_contact_name/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences) // doesn't apply to mob, phone reads it directly so we just skip here
	return FALSE
