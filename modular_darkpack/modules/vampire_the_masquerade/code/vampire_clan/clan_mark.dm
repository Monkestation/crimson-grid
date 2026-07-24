/proc/beast_marks_to_names(reverse)
	var/alist/mark_list = alist()
	for(var/datum/bodypart_overlay/simple/clan_mark/mark as anything in valid_subtypesof(/datum/bodypart_overlay/simple/clan_mark))
		var/using_string = replacetext(replacetext(replacetext("[mark]", "/datum/bodypart_overlay/simple/clan_mark/", ""), "_", " "), "/", " ")

		if(reverse)
			mark_list[mark] = using_string
		else
			mark_list[using_string] = mark

	return mark_list

/proc/beast_mark_names_by_clan()
	var/alist/marklist = alist()
	for(var/clan_type in GLOB.vampire_clans)
		var/datum/subsplat/vampire_clan/clan = GLOB.vampire_clans[clan_type]
		if(!clan.clan_marks)
			continue
		var/list/new_list = list()
		for(var/mark in clan.clan_marks)
			new_list += GLOB.beast_marks_to_names_reverse[mark]
		new_list += "none"

		marklist[clan.type] = new_list

	return marklist


/datum/bodypart_overlay/simple/clan_mark
	abstract_type = /datum/bodypart_overlay/simple/clan_mark
	icon = 'modular_darkpack/modules/vampire_the_masquerade/icons/features.dmi'
	var/using_limb = BODY_ZONE_CHEST

/datum/bodypart_overlay/simple/clan_mark/beast_legs
	icon_state = "beast_legs"
	layers = list(EXTERNAL_ADJACENT = BODY_ADJ_LAYER)

/datum/bodypart_overlay/simple/clan_mark/beast_tail
	icon_state = "beast_tail"
	layers = list(EXTERNAL_ADJACENT = BODY_ADJ_LAYER)

/datum/bodypart_overlay/simple/clan_mark/beast_tail_and_legs
	icon_state = "beast_tail_and_legs"
	layers = list(EXTERNAL_ADJACENT = BODY_ADJ_LAYER)


/datum/bodypart_overlay/simple/clan_mark/nosferatu_ears
	icon_state = "nosferatu_ears"
	layers = list(EXTERNAL_FRONT = BODY_FRONT_LAYER)


/datum/bodypart_overlay/simple/clan_mark/fae_ears
	icon_state = "fae_ears"
	layers = list(EXTERNAL_FRONT = BODY_FRONT_LAYER)


/datum/bodypart_overlay/simple/clan_mark/spines
	icon_state = "spines"
	layers = list(EXTERNAL_ADJACENT = BODY_ADJ_LAYER)

/datum/bodypart_overlay/simple/clan_mark/spines_slim
	icon_state = "spines_slim"
	layers = list(EXTERNAL_ADJACENT = BODY_ADJ_LAYER)

/datum/bodypart_overlay/simple/clan_mark/animal_skull
	icon_state = "animal_skull"
	layers = list(EXTERNAL_ADJACENT = BODY_ADJ_LAYER)
	using_limb = BODY_ZONE_HEAD

/datum/bodypart_overlay/simple/clan_mark/gargoyle
	abstract_type = /datum/bodypart_overlay/simple/clan_mark/gargoyle
	layers = list(EXTERNAL_FRONT = BODY_FRONT_LAYER)
	using_limb = BODY_ZONE_HEAD

/datum/bodypart_overlay/simple/clan_mark/gargoyle/full
	icon_state = "gargoyle_full"

/datum/bodypart_overlay/simple/clan_mark/gargoyle/left
	icon_state = "gargoyle_left"

/datum/bodypart_overlay/simple/clan_mark/gargoyle/right
	icon_state = "gargoyle_right"

/datum/bodypart_overlay/simple/clan_mark/gargoyle/broken
	icon_state = "gargoyle_broken"

/datum/bodypart_overlay/simple/clan_mark/gargoyle/round
	icon_state = "gargoyle_round"

/datum/bodypart_overlay/simple/clan_mark/gargoyle/oni
	icon_state = "gargoyle_oni"

/datum/bodypart_overlay/simple/clan_mark/gargoyle/devil
	icon_state = "gargoyle_devil"

// Seperate pref but some concept.
/datum/bodypart_overlay/simple/clan_mark/gargoyle/tail
	icon_state = "gargoyle_legs_n_tails"
	layers = list(EXTERNAL_ADJACENT = BODY_ADJ_LAYER)
	using_limb = BODY_ZONE_CHEST
