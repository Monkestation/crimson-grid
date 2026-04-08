// W20 p. 475
/datum/quirk/darkpack/time_sense
	name = "Time Sense"
	desc = {"You have an innate sense of time and are able to estimate the passage of time accurately without using a watch or other mechanical device,
		even after long periods of unconsciousness. This allows you to know (among other things) what phase the moon is in."}
	value = 1
	mob_trait = TRAIT_TIME_SENSE
	icon = FA_ICON_STOPWATCH

	excluded_clans = list(VAMPIRE_CLAN_TRUE_BRUJAH)

/mob/proc/get_time_status()
	. = list()
	. += "Local City Time: [SSticker.round_start_timeofday ? "[station_time_timestamp("hh:mm MMM")] [CURRENT_STATION_YEAR]" : "The round hasn't started yet!"]"

/mob/living/get_time_status()
	. = list()
	if(HAS_TRAIT(src, TRAIT_TIME_SENSE))
		. += "Local City Time: [station_time_timestamp("hh:mm MMM")] [CURRENT_STATION_YEAR]"
		. += "Phase of moon: [GLOB.moon_state]"
	else
		. += "Local City Time: [CURRENT_STATION_YEAR]? Get a watch."

