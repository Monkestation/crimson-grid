#define PC_PRINTER_COOLDOWN (4 SECONDS)
#define PC_PRINTER_MAX_PAPER 30

/obj/machinery/pc_printer
	name = "network printer"
	desc = "A printer that accepts jobs from any computer on its network. Load it with paper."
	icon = 'icons/obj/machines/fax.dmi'
	icon_state = "fax"
	density = TRUE
	anchored = FALSE
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.2
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 0.5
	/// Network this printer joins on init
	network_id = PC_NETWORK_PUBLIC
	var/paper = 0
	var/max_paper = PC_PRINTER_MAX_PAPER
	/// Set through network automation, refuses all jobs while TRUE
	var/locked = FALSE
	COOLDOWN_DECLARE(print_cooldown)

/obj/machinery/pc_printer/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/drag_carry, force_two_handed = TRUE, carry_slowdown = 1.5, throw_damage = 20, do_after_time = 2 SECONDS)

/obj/machinery/pc_printer/update_overlays()
	. = ..()
	if(paper > 0)
		. += mutable_appearance(icon, "contain_paper")

/obj/machinery/pc_printer/get_pc_actions()
	return list(
		"lock" = list(
			AUTOMATION_NAME = "Lock printer",
			AUTOMATION_DESC = "Makes the printer refuse all print jobs.",
			AUTOMATION_CALLBACK = CALLBACK(src, PROC_REF(automation_set_lock), TRUE),
			AUTOMATION_MIN_ROLE = PC_NETWORK_ADMIN,
			AUTOMATION_ALLOW_AUTOMATE = TRUE,
		),
		"unlock" = list(
			AUTOMATION_NAME = "Unlock printer",
			AUTOMATION_DESC = "Lets the printer accept print jobs again.",
			AUTOMATION_CALLBACK = CALLBACK(src, PROC_REF(automation_set_lock), FALSE),
			AUTOMATION_MIN_ROLE = PC_NETWORK_ADMIN,
			AUTOMATION_ALLOW_AUTOMATE = TRUE,
		),
		"test_page" = list(
			AUTOMATION_NAME = "Print test page",
			AUTOMATION_DESC = "Prints a single page. Uses one sheet of paper.",
			AUTOMATION_CALLBACK = CALLBACK(src, PROC_REF(automation_print_test_page)),
			AUTOMATION_MIN_ROLE = PC_NETWORK_USER,
			AUTOMATION_ALLOW_AUTOMATE = TRUE,
		),
	)

/obj/machinery/pc_printer/get_pc_triggers()
	return list(
		"printed" = list(
			AUTOMATION_NAME = "Finished a print job",
			AUTOMATION_DESC = "Fires after the printer prints something.",
			AUTOMATION_SIGNAL = COMSIG_PC_PRINTER_PRINTED,
			AUTOMATION_MIN_ROLE = PC_NETWORK_USER,
			AUTOMATION_PAYLOAD = list("job"),
		),
		"out_of_paper" = list(
			AUTOMATION_NAME = "Ran out of paper",
			AUTOMATION_DESC = "Fires when the last sheet is used.",
			AUTOMATION_SIGNAL = COMSIG_PC_PRINTER_OUT_OF_PAPER,
			AUTOMATION_MIN_ROLE = PC_NETWORK_USER,
			AUTOMATION_PAYLOAD = list("paper"),
		),
		"paper_loaded" = list(
			AUTOMATION_NAME = "Paper was loaded",
			AUTOMATION_DESC = "Fires when someone adds paper to the tray.",
			AUTOMATION_SIGNAL = COMSIG_PC_PRINTER_PAPER_LOADED,
			AUTOMATION_MIN_ROLE = PC_NETWORK_USER,
			AUTOMATION_PAYLOAD = list("paper"),
		),
	)


/obj/machinery/pc_printer/get_pc_variables()
	return list(
		"paper" = list(
			AUTOMATION_NAME = "Paper count",
			AUTOMATION_DESC = "Sheets currently in the tray.",
			AUTOMATION_CALLBACK = CALLBACK(src, PROC_REF(get_paper)),
			AUTOMATION_MIN_ROLE = PC_NETWORK_USER,
		),
		"max_paper" = list(
			AUTOMATION_NAME = "Tray capacity",
			AUTOMATION_DESC = "Maximum sheets the tray holds.",
			AUTOMATION_CALLBACK = CALLBACK(src, PROC_REF(get_max_paper)),
			AUTOMATION_MIN_ROLE = PC_NETWORK_USER,
		),
		"locked" = list(
			AUTOMATION_NAME = "Locked",
			AUTOMATION_DESC = "1 if the network has locked the printer.",
			AUTOMATION_CALLBACK = CALLBACK(src, PROC_REF(get_locked)),
			AUTOMATION_MIN_ROLE = PC_NETWORK_USER,
		),
	)

/obj/machinery/pc_printer/proc/get_paper()
	return paper
/obj/machinery/pc_printer/proc/get_max_paper()
	return max_paper
/obj/machinery/pc_printer/proc/get_locked()
	return locked ? 1 : 0

/obj/machinery/pc_printer/proc/animate_printing()
	icon_state = "fax_receive"
	var/mutable_appearance/overlay = mutable_appearance(icon, "receive_paper")
	overlays += overlay
	addtimer(CALLBACK(src, PROC_REF(print_animation_complete), overlay), 2 SECONDS)

/obj/machinery/pc_printer/proc/print_animation_complete(mutable_appearance/remove_overlay)
	icon_state = "fax"
	overlays -= remove_overlay

/obj/machinery/pc_printer/proc/automation_set_lock(new_state, datum/bank_account/account, mob/user)
	locked = new_state
	if(user)
		balloon_alert(user, locked ? "printer locked" : "printer unlocked")

/obj/machinery/pc_printer/proc/automation_print_test_page(datum/bank_account/account, mob/user)
	if(print_block_reason(1))
		return
	var/obj/item/paper/page = new(get_turf(src))
	page.name = "test page"
	page.add_raw_text("Network printer test page.\nNetwork: [get_network_id()]")
	page.update_appearance()
	finish_job(1, "test page")

/obj/machinery/pc_printer/examine(mob/user)
	. = ..()
	. += span_notice("It holds [paper]/[max_paper] sheets of paper.")
	. += span_notice("It is [get_network_id() == PC_NETWORK_OFFLINE ? "disconnected from any network" : "connected to a network"].")
	if(locked)
		. += span_warning("It is locked by the network.")

/obj/machinery/pc_printer/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/paper))
		return NONE
	if(paper >= max_paper)
		balloon_alert(user, "paper tray full!")
		return ITEM_INTERACT_BLOCKING
	if(!user.transferItemToLoc(tool, src))
		return ITEM_INTERACT_BLOCKING
	qdel(tool)
	paper++
	update_appearance()
	balloon_alert(user, "paper loaded")
	SEND_SIGNAL(src, COMSIG_PC_PRINTER_PAPER_LOADED, paper)
	return ITEM_INTERACT_SUCCESS

/// Why a job can't run right now, or null if it can.
/obj/machinery/pc_printer/proc/print_block_reason(sheets_needed)
	if(!is_operational)
		return "The printer is unpowered."
	if(get_network_id() == PC_NETWORK_OFFLINE)
		return "The printer is disconnected from the network."
	if(locked)
		return "The printer has been locked by the network."
	if(!COOLDOWN_FINISHED(src, print_cooldown))
		return "The printer is still warming up."
	if(paper < sheets_needed)
		return "The printer is out of paper."
	return null

/obj/machinery/pc_printer/proc/finish_job(sheets_used, job_name)
	paper = max(0, paper - sheets_used)
	COOLDOWN_START(src, print_cooldown, PC_PRINTER_COOLDOWN)
	use_energy(active_power_usage)
	playsound(src, 'sound/machines/printer.ogg', 100, TRUE)
	animate_printing()
	update_appearance()
	SEND_SIGNAL(src, COMSIG_PC_PRINTER_PRINTED, job_name)
	if(!paper)
		SEND_SIGNAL(src, COMSIG_PC_PRINTER_OUT_OF_PAPER, paper)

/// Prints a saved painting as a canvas. Returns null on success, or an error string.
/obj/machinery/pc_printer/proc/print_painting(datum/painting/painting, sheets_needed)
	var/reason = print_block_reason(sheets_needed)
	if(reason)
		return reason
	var/obj/item/canvas/new_canvas = painting.spawn_canvas(get_turf(src))
	if(!new_canvas)
		return "An unknown error has occurred."
	finish_job(sheets_needed, painting.title)
	return null

/// Returns an error string for the UI, or null when the print started.
/// on_done is invoked with our drop location as its last argument when the print finishes.
/obj/machinery/pc_printer/proc/begin_print(sheets, datum/callback/on_done)
	if(!is_operational)
		return "[src] is offline."
	if(!COOLDOWN_FINISHED(src, print_cooldown))
		return "[src] is busy."
	if(paper < sheets)
		return "[src] needs [sheets] sheet\s of paper ([paper] loaded)."
	paper -= sheets
	COOLDOWN_START(src, print_cooldown, PC_PRINT_COOLDOWN)
	playsound(src, 'sound/machines/printer.ogg', 50)
	animate_printing()
	update_appearance()
	addtimer(CALLBACK(src, PROC_REF(finish_print), on_done), PC_PRINT_TIME)
	return null

/obj/machinery/pc_printer/proc/finish_print(datum/callback/on_done)
	if(QDELETED(src))
		return
	on_done.Invoke(drop_location())

// Title, author and content passed here must already be html-encoded, because the
// book datum is filled as trusted.
/proc/pc_make_printed_book(title, author, content, printed_by, atom/where)
	var/obj/item/book/printed_book = new(where)
	printed_book.name = "Book: [title]"
	printed_book.book_data = new()
	var/datum/book_info/fill = printed_book.book_data
	fill.set_title(title, trusted = TRUE)
	fill.set_author(author, trusted = TRUE)
	fill.set_content(content, trusted = TRUE)
	printed_book.gen_random_icon_state()
	log_paper("[printed_by] printed \"[title]\" from a PC library program.")

/proc/pc_make_bible(atom/where)
	var/obj/item/book/bible/holy_book = new(where)
	if(!GLOB.bible_icon_state || !GLOB.bible_inhand_icon_state)
		return
	holy_book.icon_state = GLOB.bible_icon_state
	holy_book.inhand_icon_state = GLOB.bible_inhand_icon_state
	holy_book.name = GLOB.bible_name
	holy_book.deity_name = GLOB.deity

/proc/pc_make_poster(poster_type, atom/where)
	new /obj/item/poster(where, new poster_type)

/// Run by the printer when the job finishes, can callbacks just do new? IDK so this is a global
/proc/create_newspaper(atom/where)
	new /obj/item/newspaper(where)

#undef PC_PRINTER_COOLDOWN
#undef PC_PRINTER_MAX_PAPER
