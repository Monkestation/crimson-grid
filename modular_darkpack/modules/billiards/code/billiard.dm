#define SOLID_BALL "Solid Ball"
#define STRIPED_BALL "Striped Ball"
#define EIGHT_BALL "8-Ball"
#define ZERO_BALL "0-Ball"

#define TABLE_BOUNDS 11

/obj/item/pool_cue
	name = "pool cue"
	desc = "Used for playing a game of 8 ball."
	icon = 'modular_darkpack/modules/billiards/icons/billiard.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/billiards/icons/billiard_onfloor.dmi')
	icon_state = "cue"
	base_icon_state = "cue"
	worn_icon = 'modular_darkpack/modules/billiards/icons/back.dmi'
	lefthand_file = 'modular_darkpack/modules/billiards/icons/lefthand.dmi'
	righthand_file = 'modular_darkpack/modules/billiards/icons/righthand.dmi'
	force = 10
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	throwforce = 15
	throw_speed = 2
	attack_verb_continuous = list("smashes", "slams", "whacks", "thwacks")
	attack_verb_simple = list("smash", "slam", "whack", "thwack")

/obj/item/pool_cue/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/two_handed, \
		force_unwielded = /obj/item/pool_cue::force, \
		force_wielded = 15, \
	)

/obj/item/pool_cue/update_icon_state()
	inhand_icon_state = "[base_icon_state][HAS_TRAIT(src, TRAIT_WIELDED)]"
	return ..()

/obj/item/pool_ball
	name = "pool ball"
	desc = "Used for playing a game of 8 ball."
	icon = 'modular_darkpack/modules/billiards/icons/billiard.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/billiards/icons/billiard_onfloor.dmi')
	icon_state = "0ball"
	var/ball_number = 0

/obj/item/pool_ball/update_name(updates)
	. = ..()
	if(ball_number == 0)
		name = "cue ball"
	else
		name = "\improper [ball_number]-ball"

/obj/item/pool_ball/update_icon_state()
	. = ..()
	icon_state = "[ball_number]ball"

/obj/item/pool_ball/random/Initialize(mapload)
	. = ..()
	ball_number = rand(0,15)
	update_appearance()

/obj/structure/table/wood/billiard
	name = "billiard table"
	desc = "Come here, play some BALLS. I know you want it so much..."
	icon = 'modular_darkpack/modules/billiards/icons/32x48.dmi'
	icon_state = "billiard1"
	smoothing_flags = NONE
	smoothing_groups = null
	canSmoothWith = null
	pixel_y = -16

	can_flip = FALSE

	var/start_with_cues = TRUE
	var/start_min_cues = 1
	var/start_max_cues = 4

	var/start_with_balls = TRUE

/obj/structure/table/wood/billiard/Initialize(mapload)
	. = ..()

	var/turf/my_turf = get_turf(src)
	if(start_with_balls)
		for(var/ball_num in 0 to 15)
			var/obj/item/pool_ball/new_ball = new(my_turf)
			new_ball.ball_number = ball_num
			new_ball.update_appearance()
			new_ball.pixel_x += rand(-TABLE_BOUNDS,TABLE_BOUNDS)
			new_ball.pixel_y += rand(-TABLE_BOUNDS-6,TABLE_BOUNDS)

	if(start_with_cues)
		for(var/i in 1 to rand(start_min_cues, start_max_cues))
			var/obj/item/pool_cue/new_cue = new(my_turf)
			new_cue.pixel_x += rand(-TABLE_BOUNDS,TABLE_BOUNDS)
			new_cue.pixel_y += rand(-TABLE_BOUNDS,TABLE_BOUNDS)

/obj/structure/table/wood/billiard/atom_deconstruct(disassembled)
	. = ..()
	dump_contents()

/obj/structure/table/wood/billiard/dump_contents()
	var/turf/my_turf = get_turf(src)
	for(var/obj/item/ball in contents)
		ball.forceMove(my_turf)
		ball.pixel_x = rand(-TABLE_BOUNDS,TABLE_BOUNDS)
		ball.pixel_y = rand(-TABLE_BOUNDS,TABLE_BOUNDS)

/obj/structure/table/wood/billiard/examine(mob/user)
	. = ..()
	. += span_notice("There are [length(get_balls_on_table(SOLID_BALL))] solid and [length(get_balls_on_table(STRIPED_BALL))] striped balls left.")
	if(!length(get_balls_on_table(EIGHT_BALL)))
		. += span_warning("The 8-Ball has been sunk.")

/obj/structure/table/wood/billiard/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	. = ..()

	if(istype(held_item, /obj/item/pool_cue))
		context[SCREENTIP_CONTEXT_RMB] = "Strike ball"
		. = CONTEXTUAL_SCREENTIP_SET
	else if(!held_item)
		context[SCREENTIP_CONTEXT_RMB] = "Reset Table"
		. = CONTEXTUAL_SCREENTIP_SET

	return . || NONE

/obj/structure/table/wood/billiard/item_interaction_secondary(mob/living/user, obj/item/tool, list/modifiers)
	. = ..()
	if(istype(tool, /obj/item/pool_cue))
		var/static/list/cue_options = list(
			SOLID_BALL = image(icon = 'modular_darkpack/modules/billiards/icons/billiard.dmi', icon_state = "1ball"),
			STRIPED_BALL = image(icon = 'modular_darkpack/modules/billiards/icons/billiard.dmi', icon_state = "15ball"),
			EIGHT_BALL = image(icon = 'modular_darkpack/modules/billiards/icons/billiard.dmi', icon_state = "8ball"),
		)
		var/choice = show_radial_menu(user, src, cue_options, require_near = TRUE)
		if(!choice)
			return ITEM_INTERACT_BLOCKING
		if(!length(get_balls_on_table(choice)))
			to_chat(user, span_warning("You cant aim for a [LOWER_TEXT(choice)] because they are all sunk!"))
			return ITEM_INTERACT_BLOCKING
		user.visible_message(span_notice("[user] begins lining up a shot to hit a [LOWER_TEXT(choice)]."), span_notice("You begin lining up a shot to hit a [LOWER_TEXT(choice)]."))
		if(!do_after(user, 1 TURNS, src))
			return ITEM_INTERACT_BLOCKING
		user.visible_message(span_notice("[user] strikes a [LOWER_TEXT(choice)]!"), span_notice("You strike your target!"))
		playsound(src, 'modular_darkpack/modules/billiards/sounds/poolball_strike.ogg', 75)

		var/datum/storyteller_roll/pool_aiming/accuracy_roll = new()
		var/accuracy_result = accuracy_roll.st_roll(user, src, using_item = tool)
		var/datum/storyteller_roll/pool_hits/amount_to_hit_roll = new()
		var/amount_to_hit_result = amount_to_hit_roll.st_roll(user, src)
		var/list/balls_sunk = list()
		for(var/i in 1 to amount_to_hit_result)
			if(!length(get_balls_on_table()))
				break
			if(!sink_ball(user, choice, accuracy_result, amount_to_hit_result, balls_sunk = balls_sunk))
				break
		if(length(balls_sunk))
			user.visible_message(span_notice("[user] sinks [english_list(balls_sunk)]. [length(get_balls_on_table())] left."), span_notice("You sink [english_list(balls_sunk)]!"))
		return ITEM_INTERACT_SUCCESS

/datum/storyteller_roll/pool_aiming
	bumper_text = "billiard aiming"
	applicable_stats = list(STAT_DEXTERITY)
	// spammy_roll = TRUE
	difficulty = 4

/datum/storyteller_roll/pool_hits
	bumper_text = "billiard hit"
	applicable_stats = list(STAT_PERCEPTION, STAT_STREETWISE)
	numerical = TRUE
	// spammy_roll = TRUE
	difficulty = 4

/obj/structure/table/wood/billiard/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	to_chat(user, span_notice("You begin reseting the table to play another game of 8-Ball."))
	if(do_after(user, 1 TURNS, src))
		reset_table()
		user.visible_message(span_notice("[user] resets the table for another game of 8-Ball"), span_notice("You finish reseting the table. Ready for another game?"))
		update_appearance()
		return ITEM_INTERACT_SUCCESS
	return ITEM_INTERACT_BLOCKING

/obj/structure/table/wood/billiard/proc/sink_ball(mob/living/user, target_ball_type, accuracy_result, amount_to_hit_result, obj/item/pool_ball/sunk_ball, list/balls_sunk)
	if(!sunk_ball)
		sunk_ball = random_ball(target_ball_type, accuracy_result)

	if(!sunk_ball)
		return
	if(num_to_ball_type(sunk_ball.ball_number) == EIGHT_BALL)
		user.visible_message(span_warning("[user] [pick("Pitted", "Sank", "Sunk")] the 8-Ball.. Damn.."), span_warning("[pick("Fuck", "Shit", "Piss")].. You [pick("Pitted", "Sank", "Sunk")] the 8-Ball"))
	else
		balls_sunk += sunk_ball
	sunk_ball.forceMove(src)

	for(var/obj/item/pool_ball/ball in get_balls_on_table(list(SOLID_BALL, STRIPED_BALL, EIGHT_BALL, ZERO_BALL)))
		if(prob(50 + amount_to_hit_result * 10))
			animate(ball, time = rand(0.5 SECONDS, 3 SECONDS) , pixel_x = rand(-TABLE_BOUNDS, TABLE_BOUNDS), pixel_y = rand(-TABLE_BOUNDS-6, TABLE_BOUNDS), easing = CUBIC_EASING|EASE_OUT)
	return TRUE

/obj/structure/table/wood/billiard/proc/random_ball(desired_ball_type, accuracy_result = ROLL_SUCCESS)
	var/balls_to_get
	switch(accuracy_result)
		if(ROLL_SUCCESS)
			balls_to_get = desired_ball_type
		if(ROLL_FAILURE)
			balls_to_get = list(SOLID_BALL, STRIPED_BALL, EIGHT_BALL) - desired_ball_type
		if(ROLL_BOTCH)
			balls_to_get = EIGHT_BALL

	var/list/balls_sunk = get_balls_on_table(balls_to_get)
	if(length(balls_sunk))
		return pick(balls_sunk)

/* I really like the weighting but it leads to sinking too many balls u dont want if u roll to many hits.
	var/list/obj/item/pool_ball/sorted_balls = get_balls_on_table()
	var/list/obj/item/pool_ball/weighted_balls = list()
	for(var/obj/item/pool_ball/entry in sorted_balls)
		if(desired_ball_type == num_to_ball_type(entry.ball_number))
			weighted_balls[entry] = accuracy_result
		else
			weighted_balls[entry] = 1
	return pick_weight(weighted_balls)
*/

/obj/structure/table/wood/billiard/proc/reset_table()
	var/turf/my_turf = get_turf(src)
	for(var/obj/item/pool_ball/ball in contents)
		ball.forceMove(my_turf)
		ball.pixel_x = rand(-TABLE_BOUNDS,TABLE_BOUNDS)
		ball.pixel_y = rand(-TABLE_BOUNDS-6,TABLE_BOUNDS)

/obj/structure/table/wood/billiard/proc/get_balls_on_table(list/looking_for = list(SOLID_BALL, STRIPED_BALL, EIGHT_BALL), sorted = FALSE)
	RETURN_TYPE(/list/obj/item/pool_ball)

	var/turf/my_turf = get_turf(src)

	// Lets us pass a single item and turn it into a list
	if(looking_for && !islist(looking_for))
		looking_for = list(looking_for)

	var/list/all_balls = list()
	for(var/obj/item/pool_ball/ball in my_turf)
		if(!(num_to_ball_type(ball.ball_number) in looking_for))
			continue
		all_balls += ball

	if(sorted)
		all_balls = sort_list(all_balls, GLOBAL_PROC_REF(cmp_num_string_asc))
	return all_balls

/obj/structure/table/wood/billiard/proc/num_to_ball_type(number)
	switch(number)
		if(1 to 7)
			return SOLID_BALL
		if(9 to 15)
			return STRIPED_BALL
		if(8)
			return EIGHT_BALL
		if(0)
			return ZERO_BALL

#undef SOLID_BALL
#undef STRIPED_BALL
#undef EIGHT_BALL
#undef ZERO_BALL

#undef TABLE_BOUNDS
