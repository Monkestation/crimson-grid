SUBSYSTEM_DEF(bloodhunt)
	name = "Blood Hunt"
	wait = 5 MINUTES
	priority = FIRE_PRIORITY_DEFAULT

	var/list/hunted

/datum/controller/subsystem/bloodhunt/Initialize(start_timeofday)
	hunted = list()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/bloodhunt/fire()
	update_alert()

/datum/controller/subsystem/bloodhunt/proc/update_alert()
	set waitfor = FALSE
	for(var/mob/kindred in GLOB.kindred_list)
		if(length(hunted))
			kindred.throw_alert("bloodhunt", /atom/movable/screen/alert/bloodhunt)
		else
			kindred.clear_alert("bloodhunt")

/atom/movable/screen/alert/bloodhunt
	name = "Blood Hunt"
	icon_state = "cult_sense"
	var/angle = 0
	var/atom/blood_target
	var/selected_target = 1

/atom/movable/screen/alert/bloodhunt/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	START_PROCESSING(SSprocessing, src)

/atom/movable/screen/alert/bloodhunt/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	angle = null
	blood_target = null
	selected_target = null
	return ..()

/atom/movable/screen/alert/bloodhunt/Click()
	if(!..())
		return
	if(!length(SSbloodhunt.hunted))
		return
	selected_target += 1
	if(selected_target > length(SSbloodhunt.hunted))
		selected_target = 1
	blood_target = SSbloodhunt.hunted?[selected_target]
	to_chat(owner, span_info("You are now tracking [blood_target] at [get_area_name(blood_target)]."))

/atom/movable/screen/alert/bloodhunt/process(seconds_per_tick)
	if(!owner.mind)
		return

	if(!blood_target) // No target, attempt to find the first person being hunted
		blood_target = SSbloodhunt.hunted?[1]

	if(!blood_target) //If there is noone being hunted, delete ourselves
		qdel(src)
		return

	var/turf/P = get_turf(blood_target)
	var/turf/Q = get_turf(owner)
	if(!P || !Q)
		icon_state = "cult_sense"
		desc = "You can no longer sense your target's presence."
		return
	desc = "You are currently tracking [blood_target] in [get_area_name(blood_target)]."

	var/target_angle = get_angle(Q, P)
	var/target_dist = get_dist(P, Q)
	cut_overlays()
	switch(target_dist)
		if(0 to 1)
			icon_state = "runed_sense2"
		if(2 to 8)
			icon_state = "arrow8"
		if(9 to 15)
			icon_state = "arrow7"
		if(16 to 22)
			icon_state = "arrow6"
		if(23 to 29)
			icon_state = "arrow5"
		if(30 to 36)
			icon_state = "arrow4"
		if(37 to 43)
			icon_state = "arrow3"
		if(44 to 50)
			icon_state = "arrow2"
		if(51 to 57)
			icon_state = "arrow1"
		if(58 to 64)
			icon_state = "arrow0"
		if(65 to 400)
			icon_state = "arrow"
	var/difference = target_angle - angle
	angle = target_angle
	if(!difference)
		return
	var/matrix/final = matrix(transform)
	final.Turn(difference)
	animate(src, transform = final, time = 5, loop = 0)
