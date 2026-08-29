/datum/preference/numeric/height
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_key = "height"
	savefile_identifier = PREFERENCE_CHARACTER
	priority = PREFERENCE_PRIORITY_WORLD_OF_DARKNESS
	minimum = HUMAN_HEIGHT_DWARF    // 6 would be like. 4'10
	maximum = HUMAN_HEIGHT_TALLEST  // 18 would be like... 6'8 or 6'10?
	step = 2

/datum/preference/numeric/height/create_default_value()
	return HUMAN_HEIGHT_MEDIUM  // 12 or 5'10 or 5'11 idk

/datum/preference/numeric/height/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.set_mob_height(value)

/datum/preference/numeric/height/compile_constant_data()
	var/list/data = ..()
	var/list/height_labels = list()
	for(var/i in minimum to maximum)
		var/total_inches = 58 + ((i - 6) * 2) // min is 58 inches (4'10) and each step is 2 inches so each step should increase by 2, 7 for example is 60
		var/feet = round(total_inches / 12)
		var/inches = total_inches % 12
		height_labels["[i]"] = "[feet]'[inches]\""
	data["height_labels"] = height_labels
	return data
