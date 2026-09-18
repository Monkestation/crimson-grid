/datum/preference/external_choiced/clan_mark
	savefile_key = "clan_mark"
	savefile_identifier = PREFERENCE_CHARACTER
	priority = PREFERENCE_PRIORITY_REQUIRES_SUBSPLAT
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_inherent_trait = TRAIT_VTM_CLANS

/datum/preference/external_choiced/clan_mark/has_relevant_feature(datum/preferences/preferences)
	. = ..()
	if(!.) // Make sure we acctually can select clan in the first place
		return FALSE
	var/clan_type = preferences.read_preference(/datum/preference/choiced/subsplat/vampire_clan)
	var/datum/subsplat/vampire_clan/clan = get_vampire_clan(clan_type)
	if(!clan)
		return FALSE
	if(clan.clan_marks)
		return TRUE
	return FALSE

/datum/preference/external_choiced/clan_mark/get_choices(datum/preferences/preferences)
	if(!preferences)
		return list("none")
	var/clan_type = preferences.read_preference(/datum/preference/choiced/subsplat/vampire_clan)
	var/datum/subsplat/vampire_clan/clan = get_vampire_clan(clan_type)
	if(!clan || !clan.clan_marks)
		return list("none")

	return GLOB.beast_mark_names_by_clan[clan.type]

/datum/preference/external_choiced/clan_mark/create_informed_default_value(datum/preferences/preferences)
	var/clan_type = preferences.read_preference(/datum/preference/choiced/subsplat/vampire_clan)
	var/datum/subsplat/vampire_clan/clan = get_vampire_clan(clan_type)
	if(clan?.default_accessory)
		return GLOB.beast_marks_to_names_reverse[clan.default_accessory]
	return pick(get_choices(preferences))

/datum/preference/external_choiced/clan_mark/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(!value || (value == "none"))
		return
	var/datum/subsplat/vampire_clan/clan = target.get_clan()
	if(!length(clan?.clan_marks))
		return

	clan.clear_old_overlays(target)

	var/datum/bodypart_overlay/simple/clan_mark/mark_type = GLOB.beast_marks_to_names[value]
	if(!ispath(mark_type, /datum/bodypart_overlay/simple/clan_mark))
		return

	var/obj/item/bodypart/limb = target.get_bodypart(mark_type::using_limb)
	limb.add_bodypart_overlay(new mark_type())

//gargoyle legs and tail
/datum/preference/toggle/gargoyle_legs_and_tail
	savefile_key = "gargoyle_legs_and_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	priority = PREFERENCE_PRIORITY_REQUIRES_SUBSPLAT
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_inherent_trait = TRAIT_VTM_CLANS

/datum/preference/toggle/gargoyle_legs_and_tail/has_relevant_feature(datum/preferences/preferences)
	. = ..()
	if(!.)
		return FALSE
	var/clan_type = preferences.read_preference(/datum/preference/choiced/subsplat/vampire_clan)
	var/datum/subsplat/vampire_clan/clan = get_vampire_clan(clan_type)
	if(istype(clan, /datum/subsplat/vampire_clan/gargoyle))
		return TRUE
	return FALSE

/datum/preference/toggle/gargoyle_legs_and_tail/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(!value)
		return

	var/datum/bodypart_overlay/simple/clan_mark/tail_type = /datum/subsplat/vampire_clan/gargoyle::gargy_tail_type
	var/obj/item/bodypart/leggies = target.get_bodypart(tail_type::using_limb)
	leggies.remove_bodypart_overlay(tail_type)

	var/datum/subsplat/vampire_clan/gargoyle/clan = target.get_clan()
	if(!istype(clan))
		return

	leggies.add_bodypart_overlay(new tail_type())
