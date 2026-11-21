/datum/pc_hack/bank_tap
	name = "Bank Tap"
	desc = "Intercepts every payment the target makes from Bank Manager. Some get skimmed, and the cut goes to the account logged in on this computer."
	difficulty_mod = 2

/datum/pc_hack/bank_tap/can_target(atom/target)
	var/obj/machinery/computer/pc/target_pc = target
	if(!istype(target_pc))
		return "[target.get_network_device_id()] isn't a computer."
	if(!target_pc.get_program(/datum/pc_program/bank))
		return "[target.get_network_device_id()] doesn't have Bank Manager installed."
	return null

/datum/pc_hack/bank_tap/execute(datum/pc_program/hacking/source, atom/target, mob/user)
	var/obj/machinery/computer/pc/target_pc = target
	var/datum/pc_program/bank/bank = istype(target_pc) ? target_pc.get_program(/datum/pc_program/bank) : null
	if(!bank)
		return "The target's Bank Manager vanished mid-hack."
	bank.tap = WEAKREF(source)
	bank.tap_until = world.time + HACK_BANK_TAP_DURATION
	return "Tap installed on [target.get_network_device_id()]. Payments will show up under Payments."

/datum/pc_hack/atm_tap
	name = "ATM Tap"
	desc = "Records every withdrawal and deposit at this ATM. Some withdrawals get skimmed, and the cut goes to the account logged in on this computer."
	difficulty_mod = 2

/datum/pc_hack/atm_tap/applies_to(atom/target)
	return istype(target, /obj/machinery/atm)

/datum/pc_hack/atm_tap/execute(datum/pc_program/hacking/source, atom/target, mob/user)
	var/obj/machinery/atm/atm = target
	if(!istype(atm))
		return "The ATM dropped off the network mid-hack."
	source.tap_atm(atm, HACK_BANK_TAP_DURATION)
	return "Tap installed on [atm.get_network_device_id()]. Withdrawals and deposits will show up under Payments."
