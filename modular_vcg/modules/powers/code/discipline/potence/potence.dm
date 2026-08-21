//Adding longer time since pot is active only now.

/datum/discipline_power/potence

	duration_length = 3 TURNS

// parent gives passive strength dice, active gives passive strength dice, we don't need double jeopardy
/datum/discipline_power/potence/post_gain()
	return

/datum/discipline_power/potence/post_loss()
	return
