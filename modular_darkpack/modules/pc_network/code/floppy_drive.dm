/datum/storyteller_roll/install_program
	bumper_text = "install program"
	applicable_stats = list(STAT_COMPUTER)
	// reroll_cooldown = 1 TURNS
	difficulty = 1

/obj/item/pc_floppy
	name = "floppy disk"
	desc = "A 3.5\" floppy disk. The label is smudged."
	icon = 'icons/obj/devices/floppy_disks.dmi'
	icon_state = "datadisk3"
	w_class = WEIGHT_CLASS_TINY
	/// Program this disk installs
	var/datum/pc_program/program_type
	/// If TRUE the disk is destroyed after a successful install
	var/consumed_on_install = FALSE
	var/install_difficulty = 1

/obj/item/pc_floppy/examine(mob/user)
	. = ..()
	if(program_type)
		. += span_notice("The label reads: [initial(program_type.name)].")

/obj/item/pc_floppy/network
	program_type = /datum/pc_program/network_log

/obj/item/pc_floppy/automation
	program_type = /datum/pc_program/automation

/obj/item/pc_floppy/browser
	program_type = /datum/pc_program/browser

/obj/item/pc_floppy/intrusion
	program_type = /datum/pc_program/hacking

/obj/item/pc_floppy/permissions
	program_type = /datum/pc_program/permissions

/obj/item/pc_floppy/security
	program_type = /datum/pc_program/security_camera

/obj/item/pc_floppy/broadcast_editor
	program_type = /datum/pc_program/nightcrawler_editor

/obj/item/pc_floppy/checkout
	program_type = /datum/pc_program/checkout

/obj/item/pc_floppy/portrait_printer
	program_type = /datum/pc_program/portrait_printer
