//Function for giving a player upgraded wound tending based on their current medical skill
/datum/st_stat/ability/medicine/proc/check_medicine_wound_tending(mob/living/source, atom/movable/operating_on, list/possible_operations)
	SIGNAL_HANDLER

	var/medicine = source.st_get_stat(STAT_MEDICINE)
	if(medicine >= 4)
		possible_operations += /datum/surgery_operation/basic/tend_wounds/combo/upgraded
	else if(medicine >= 3)
		possible_operations += /datum/surgery_operation/basic/tend_wounds/combo
