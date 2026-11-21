/datum/pc_hack/adware
	name = "Adware"
	desc = "Floods the target's screen with garish pop-up ads."

/datum/pc_hack/adware/can_target(atom/target)
	if(!istype(target, /obj/machinery/computer/pc))
		return "[target.get_network_device_id()] has no screen to infect."
	return null

/datum/pc_hack/adware/execute(datum/pc_program/hacking/source, atom/target, mob/user)
	var/obj/machinery/computer/pc/target_pc = target
	if(!istype(target_pc))
		return "The target dropped off the network mid-hack."
	target_pc.infect_adware(HACK_ADWARE_DURATION)
	target_pc.visible_message(span_warning("[target_pc]'s screen erupts with garish pop-up ads!"))
	return "Adware deployed to [target_pc.get_network_device_id()]. It runs for [DisplayTimeText(HACK_ADWARE_DURATION)]."

/datum/pc_hack/imageboard_tap
	name = "Image Board Tap"
	desc = "Copies every image board post the target makes back to this program for a while."
	difficulty_mod = 1

/datum/pc_hack/imageboard_tap/can_target(atom/target)
	var/obj/machinery/computer/pc/target_pc = target
	if(!istype(target_pc))
		return "[target.get_network_device_id()] isn't a computer."
	if(!target_pc.get_program(/datum/pc_program/imageboard))
		return "[target.get_network_device_id()] doesn't have the Image Board installed."
	return null

/datum/pc_hack/imageboard_tap/execute(datum/pc_program/hacking/source, atom/target, mob/user)
	var/obj/machinery/computer/pc/target_pc = target
	var/datum/pc_program/imageboard/board = istype(target_pc) ? target_pc.get_program(/datum/pc_program/imageboard) : null
	if(!board)
		return "The target's Image Board vanished mid-hack."
	board.tap = WEAKREF(source)
	board.tap_until = world.time + HACK_TAP_DURATION
	return "Tap installed on [target.get_network_device_id()]. New posts will show up under Intercepts."

/datum/pc_hack/locate
	name = "Locate Device"
	desc = "Pings the target for its general location."
	difficulty_mod = 1

/datum/pc_hack/locate/execute(datum/pc_program/hacking/source, atom/target, mob/user)
	var/area/where = get_area(target)
	if(!where)
		return "Signal lost. [target.get_network_device_id()] returned no location."
	return "[target.get_network_device_id()] is somewhere in: [where.name]."
