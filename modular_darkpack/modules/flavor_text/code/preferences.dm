///////////////////////////////////////////////////////////////////////////

/datum/preference/text/headshot
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "headshot"
	maximum_value_length = MAX_MESSAGE_LEN
	///How much time between the informational chat messages?
	var/cooldown_duration = 1 MINUTES
	///Handles the informational chat message timer.
	COOLDOWN_DECLARE(headshot_cooldown)
	///Assoc list of ckeys and their links, used to cut down on chat spam
	var/static/list/stored_links = list()
	var/static/link_regex = regex("files.catbox.moe|images2.imgbox.com|i.gyazo.com")
	var/static/list/valid_extensions = list("jpg", "png", "jpeg") // Regex works fine, if you know how it works

/datum/preference/text/headshot/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target?.dna.features[EXAMINE_DNA_HEADSHOT] = value

/datum/preference/text/headshot/is_valid(value)
	if(!length(value))
		return TRUE

	var/find_index = findtext(value, "https://")
	if(find_index != 1)
		to_chat(usr, span_warning("Your link must be https!"))
		return

	if(!findtext(value, "."))
		to_chat(usr, span_warning("Invalid link!"))
		return
	var/list/value_split = splittext(value, ".")

	// extension will always be the last entry
	var/extension = value_split[length(value_split)]
	if(!(lowertext(extension) in valid_extensions))
		to_chat(usr, span_warning("The image must be one of the following extensions: '[english_list(valid_extensions)]'"))
		return

	find_index = findtext(value, link_regex)
	if(find_index != 9)
		to_chat(usr, span_warning("The image must be hosted on one of the following sites: 'Gyazo (i.gyazo.com), Catbox (catbox.moe), Imgbox (images2.imgbox.com)'"))
		return

	if(stored_links[usr.ckey] && stored_links[usr.ckey][type] != value && COOLDOWN_FINISHED(src, headshot_cooldown))
		COOLDOWN_START(src, headshot_cooldown, cooldown_duration)
		to_chat(usr, span_notice("Please use a SFW image of the head and shoulder area to maintain immersion level. Think of it as a headshot for your ID. Lastly, [span_bold("do not use a real life photo or use any image that is less than serious.")]"))
		to_chat(usr, span_notice("If the photo doesn't show up properly in-game, ensure that it's a direct image link that opens properly in a browser."))
		to_chat(usr, span_notice("Keep in mind that the photo will be downsized to 250x250 pixels, so the more square the photo, the better it will look."))
		log_game("[usr] has set their Headshot image to '[value]'.")

	apply_headshot(value)
	return TRUE

/datum/preference/text/headshot/proc/apply_headshot(value)
	if(isnull(stored_links[usr?.ckey]))
		stored_links[usr?.ckey] = list()
	stored_links[usr?.ckey][type] = value
	return TRUE

///////////////////////////////////////////////////////////////////////////

/datum/preference/text/flavor_text
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "flavor_text"
	maximum_value_length = MAX_FLAVOR_LEN

/datum/preference/text/flavor_text/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.features[EXAMINE_DNA_FLAVOR_TEXT] = value

///////////////////////////////////////////////////////////////////////////

/datum/preference/text/nsfw_flavor_text
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "nsfw_flavor_text"
	maximum_value_length = MAX_FLAVOR_LEN

/datum/preference/text/nsfw_flavor_text/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(CONFIG_GET(flag/nsfw_content))
		target.dna.features[EXAMINE_DNA_NSFW_FLAVOR_TEXT] = value

/datum/preference/text/nsfw_flavor_text/is_accessible(datum/preferences/preferences)
	. = ..()
	if(!.)
		return FALSE

	if(CONFIG_GET(flag/nsfw_content) && preferences.read_preference(/datum/preference/toggle/nsfw_content_pref))
		return TRUE

	return FALSE

///////////////////////////////////////////////////////////////////////////

/datum/preference/text/character_notes
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "character_notes"
	maximum_value_length = MAX_FLAVOR_LEN

/datum/preference/text/character_notes/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.features[EXAMINE_DNA_CHARACTER_NOTES] = value

///////////////////////////////////////////////////////////////////////////

/datum/preference/text/ooc_notes
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "ooc_notes"
	maximum_value_length = MAX_FLAVOR_LEN

/datum/preference/text/ooc_notes/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(CONFIG_GET(flag/nsfw_content))
		target.dna.features[EXAMINE_DNA_OOC_NOTES] = value

/datum/preference/text/ooc_notes/is_accessible(datum/preferences/preferences)
	. = ..()
	if(!.)
		return FALSE

	if(CONFIG_GET(flag/nsfw_content) && preferences.read_preference(/datum/preference/toggle/nsfw_content_pref))
		return TRUE

	return FALSE
