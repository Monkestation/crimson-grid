/datum/quirk/darkpack/time_sense
	name = "Time Sense"
	desc = {"You have an innate sense of time and are able to estimate the passage of time accurately without using a watch or other mechanical device,
		even after long periods of unconsciousness. This allows you to know (among other things) what phase the moon is in."}
	ttrpg_sources = list(
		/datum/source_book/wta20 = 475,
		/datum/source_book/vtm20 = 484,
		/datum/source_book/htr3/pg = 111,
		)
	value = 1
	mob_trait = TRAIT_TIME_SENSE
	icon = FA_ICON_STOPWATCH

	excluded_clans = list(VAMPIRE_CLAN_TRUE_BRUJAH)

/mob/proc/get_time_status()
	. = list()
	. += "Local City Time: [SSticker.round_start_timeofday ? "[server_timestamp("hh:mm", ic_time = TRUE, twelve_hour_clock = client?.prefs.read_preference(/datum/preference/toggle/twelve_hour))] [server_timestamp("MMM YYYY", ic_time = TRUE)]" : "The round hasn't started yet!"]"

/mob/living/get_time_status()
	. = list()
	if(HAS_TRAIT(src, TRAIT_TIME_SENSE))
		. += "Local City Time: [server_timestamp("hh:mm", ic_time = TRUE, twelve_hour_clock = client?.prefs.read_preference(/datum/preference/toggle/twelve_hour))] [server_timestamp("MMM YYYY", ic_time = TRUE)]"
		. += "Phase of moon: [GLOB.moon_state]"
	else
		. += "Local City Time: [CURRENT_STATION_YEAR]? Get a watch."

