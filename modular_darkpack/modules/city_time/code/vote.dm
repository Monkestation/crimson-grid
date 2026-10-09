// #define CHOICE_15 "15 Minutes"
// #define CHOICE_30 "30 Mintues"
// #define CHOICE_60 "1 Hour"
// #define CHOICE_NO "No Extension"

// /datum/vote/extend_night // Crimson Grid Edit - STOP CALLING EXTENSION VOTES GRAHHHHH!!
// 	name = "Extend Night"
// 	default_choices = list(
// 		CHOICE_15,
// 		CHOICE_30,
// 		CHOICE_60,
// 		CHOICE_NO
// 	)
// 	default_message = "Vote to extend the night by a given amount."

// /datum/vote/extend_night/can_be_initiated(forced)
// 	. = ..()
// 	if(. != VOTE_AVAILABLE)
// 		return .

// 	if(forced)
// 		return VOTE_AVAILABLE

// 	if(SScity_time.daytime_started)
// 		return "The night has already ended."

// 	return VOTE_AVAILABLE

// /datum/vote/extend_night/finalize_vote(winning_option)
// 	switch(winning_option)
// 		if(CHOICE_NO)
// 			return
// 		if(CHOICE_15)
// 			SScity_time.extend_round(15 MINUTES)
// 		if(CHOICE_30)
// 			SScity_time.extend_round(30 MINUTES)
// 		if(CHOICE_60)
// 			SScity_time.extend_round(1 HOURS)

// #undef CHOICE_15
// #undef CHOICE_30
// #undef CHOICE_60
// #undef CHOICE_NO
