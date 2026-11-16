/datum/component/heartbeat_sensing
	/// Time between heartbeat sensings. IMPORTANT!! The effective time in local and the effective time in live are very different. The second is noticeably slower.
	var/cooldown_time = 1 SECONDS
	/// Time for the image to start fading out.
	var/image_expiry_time = 0.7 SECONDS
	/// Time for the image to fade in.
	var/fade_in_time = 0.2 SECONDS
	/// Time for the image to fade out and delete itself.
	var/fade_out_time = 0.3 SECONDS
	/// Ref of the client color we give to the parent.
	var/client_colour
	/// A matrix that turns everything except #ffffff into pure blackness, used for our images (the outlines are #ffffff).
	var/static/list/black_white_matrix = list(85, 85, 85, 0, 85, 85, 85, 0, 85, 85, 85, 0, 0, 0, 0, 1, -254, -254, -254, 0)
	/// Associative list of receivers to lists of atoms they are rendering (those atoms are associated to data of the image and time they were rendered at).
	var/list/receivers = list()
	/// Cooldown for the heartbeat sensing.
	COOLDOWN_DECLARE(cooldown_last)

/datum/component/heartbeat_sensing/Initialize(cooldown_time, image_expiry_time, fade_in_time, fade_out_time, color_path)
	. = ..()
	var/mob/living/parent_mob = parent
	if(!istype(parent_mob))
		return COMPONENT_INCOMPATIBLE
	if(!isnull(cooldown_time))
		src.cooldown_time = cooldown_time
	if(!isnull(image_expiry_time))
		src.image_expiry_time = image_expiry_time
	if(!isnull(fade_in_time))
		src.fade_in_time = fade_in_time
	if(!isnull(fade_out_time))
		src.fade_out_time = fade_out_time
	if(ispath(color_path))
		client_colour = parent_mob.add_client_colour(color_path, "heartbeat_sensing_colour")
	START_PROCESSING(SSfastprocess, src)

/datum/component/heartbeat_sensing/Destroy(force)
	STOP_PROCESSING(SSfastprocess, src)
	QDEL_NULL(client_colour)
	for(var/mob/living/echolocate_receiver as anything in receivers)
		if(!echolocate_receiver.client)
			continue
		for(var/atom/rendered_atom as anything in receivers[echolocate_receiver])
			echolocate_receiver.client.images -= receivers[echolocate_receiver][rendered_atom]["image"]
		receivers -= list(echolocate_receiver)
	return ..()

/datum/component/heartbeat_sensing/process(seconds_per_tick)
	var/mob/living/parent_mob = parent
	if(parent_mob.stat == DEAD)
		return
	sense_heartbeat()

/datum/component/heartbeat_sensing/proc/sense_heartbeat()
	if(!COOLDOWN_FINISHED(src, cooldown_last))
		return
	COOLDOWN_START(src, cooldown_last, cooldown_time)
	var/mob/living/parent_mob = parent
	if(isnull(receivers[parent_mob]))
		receivers[parent_mob] = list()
	for(var/mob/living/carbon/living_carbon in orange(parent_mob.client?.view, get_turf(parent_mob)))
		if(!living_carbon.heart_is_beating())
			continue
		show_heartbeat_image(living_carbon)

/datum/component/heartbeat_sensing/proc/show_heartbeat_image(mob/living_mob)
	var/current_time = "[world.time]"
	show_image(generate_appearance(living_mob), living_mob, current_time)
	addtimer(CALLBACK(src, PROC_REF(fade_images), current_time), image_expiry_time)

/datum/component/heartbeat_sensing/proc/show_image(image/input_appearance, atom/input, current_time)
	var/image/final_image = image(input_appearance)
	final_image.layer += EFFECTS_LAYER
	final_image.plane = FULLSCREEN_PLANE
	final_image.loc = input
	final_image.dir = input.dir
	final_image.alpha = 0
	var/list/fade_ins = list(final_image)
	for(var/mob/living/echolocate_receiver as anything in receivers)
		if(echolocate_receiver == input)
			continue
		if(receivers[echolocate_receiver][input])
			var/previous_image = receivers[echolocate_receiver][input]["image"]
			fade_ins |= previous_image
			receivers[echolocate_receiver][input] = list("image" = previous_image, "time" = current_time)
		else
			if(echolocate_receiver.client)
				echolocate_receiver.client.images += final_image
			receivers[echolocate_receiver][input] = list("image" = final_image, "time" = current_time)
	for(var/image_echo in fade_ins)
		animate(image_echo, alpha = 255, time = fade_in_time)

/datum/component/heartbeat_sensing/proc/generate_appearance(atom/input)
	var/mutable_appearance/copied_appearance = new /mutable_appearance()
	copied_appearance.appearance = input
	copied_appearance.color = black_white_matrix
	copied_appearance.filters += outline_filter(size = 1, color = COLOR_WHITE)
	return copied_appearance

/datum/component/heartbeat_sensing/proc/fade_images(from_when)
	var/fade_outs = list()
	for(var/mob/living/echolocate_receiver as anything in receivers)
		for(var/atom/rendered_atom as anything in receivers[echolocate_receiver])
			if(receivers[echolocate_receiver][rendered_atom]["time"] <= from_when)
				fade_outs |= receivers[echolocate_receiver][rendered_atom]["image"]
	for(var/image_echo in fade_outs)
		animate(image_echo, alpha = 0, time = fade_out_time)
	addtimer(CALLBACK(src, PROC_REF(delete_images), from_when), fade_out_time)

/datum/component/heartbeat_sensing/proc/delete_images(from_when)
	for(var/mob/living/echolocate_receiver as anything in receivers)
		for(var/atom/rendered_atom as anything in receivers[echolocate_receiver])
			if(receivers[echolocate_receiver][rendered_atom]["time"] <= from_when && echolocate_receiver.client)
				echolocate_receiver.client.images -= receivers[echolocate_receiver][rendered_atom]["image"]
				receivers[echolocate_receiver] -= rendered_atom
		if(!length(receivers[echolocate_receiver]))
			receivers -= echolocate_receiver
