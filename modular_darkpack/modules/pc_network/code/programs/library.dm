#define PC_LIBRARY_REQUEST_COOLDOWN (1 SECONDS)
#define PC_LIBRARY_MAX_SAVED 20
#define PC_LIBRARY_MAX_FIELD 64

/datum/pc_saved_book
	var/id
	var/title
	var/author
	var/category
	/// Plain text, already stripped of markup
	var/content

/datum/pc_book_cache
	var/list/books = list()

/datum/pc_book_cache/proc/is_full()
	return length(books) >= PC_LIBRARY_MAX_SAVED

/// Shared by every program, so both apps see the same saved books.
/datum/pc_program/proc/get_book_cache()
	if(!computer)
		return null
	if(!computer.book_cache)
		computer.book_cache = new /datum/pc_book_cache
	return computer.book_cache

/datum/pc_program/library
	name = "Library Archive"
	icon_state = "book"
	tgui_id = "PcLibrary"

	var/book_id = null
	var/title = ""
	var/author = ""
	var/category = ""
	/// Results of the last query
	var/list/results = list()
	var/page_count = 0
	var/search_page = 0
	var/can_connect = TRUE
	var/sending_request = FALSE
	/// Hash of the last search, so we never run the exact same query twice
	var/last_search_hash = ""
	/// Have we run the first search yet? (done lazily on first UI update)
	var/searched_once = FALSE
	/// Last message from the printer, shown in the UI
	var/status_message = ""
	COOLDOWN_DECLARE(request_cooldown)

// Host must be passed up, otherwise `computer` is never set.
/datum/pc_program/library/New(obj/machinery/computer/pc/host)
	. = ..()
	category = DEFAULT_SEARCH_CATAGORY

/datum/pc_program/library/proc/push_update()
	if(computer)
		SStgui.update_uis(computer)

/datum/pc_program/library/proc/can_request()
	if(sending_request)
		return FALSE
	return COOLDOWN_FINISHED(src, request_cooldown)

/datum/pc_program/library/proc/try_request()
	if(!can_request())
		return FALSE
	COOLDOWN_START(src, request_cooldown, PC_LIBRARY_REQUEST_COOLDOWN)
	return TRUE

/datum/pc_program/library/proc/clean_field(raw)
	if(!istext(raw))
		return ""
	return trim(copytext_char(raw, 1, PC_LIBRARY_MAX_FIELD + 1))

/datum/pc_program/library/proc/hash_search_info()
	return "[GLOB.library_table_modified]-[book_id]-[title]-[author]-[category]-[search_page]"

/datum/pc_program/library/proc/printer_status()
	var/datum/pc_network/net = computer?.current_network
	if(!net)
		return "No network"
	var/obj/machinery/pc_printer/printer = net.find_printer(1)
	if(!printer)
		return "No printer"
	if(printer.paper < 1)
		return "Out of paper"
	return "Ready"

/datum/pc_program/library/ui_data(mob/user)
	var/list/data = list()
	if(!searched_once)
		searched_once = TRUE
		INVOKE_ASYNC(src, PROC_REF(run_search))
	var/datum/pc_book_cache/cache = get_book_cache()
	data["can_connect"] = can_connect
	data["busy"] = !can_request()
	data["search_categories"] = SSlibrary.search_categories
	data["category"] = category
	data["author"] = author
	data["title"] = title
	data["book_id"] = book_id
	data["page_count"] = page_count + 1 // Displayed 1-indexed
	data["our_page"] = search_page + 1
	data["pages"] = results
	data["saved_ids"] = cache ? assoc_to_keys(cache.books) : list()
	data["saved_count"] = cache ? length(cache.books) : 0
	data["saved_max"] = PC_LIBRARY_MAX_SAVED

	data["status"] = status_message
	data["printer_status"] = printer_status()
	data["posters"] = list()
	for(var/poster_name in SSlibrary.printable_posters)
		data["posters"] += poster_name
	data["bible_name"] = GLOB.bible_name || DEFAULT_BIBLE_REPLACE(GLOB.religion || DEFAULT_RELIGION)
	return data

/datum/pc_program/library/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("search")
			if(!try_request())
				return FALSE
			title = clean_field(params["title"])
			author = clean_field(params["author"])
			var/newcategory = params["category"]
			if(!(newcategory in SSlibrary.search_categories))
				newcategory = DEFAULT_SEARCH_CATAGORY
			category = newcategory
			var/newid = text2num(params["id"])
			book_id = isnum(newid) ? newid : null
			search_page = 0
			INVOKE_ASYNC(src, PROC_REF(run_search))
			return TRUE

		if("switch_page")
			if(!try_request())
				return FALSE
			var/wanted = text2num(params["page"])
			if(!isnum(wanted))
				return FALSE
			search_page = clamp(wanted - 1, 0, page_count)
			INVOKE_ASYNC(src, PROC_REF(run_search))
			return TRUE

		if("clear")
			if(!try_request())
				return FALSE
			title = ""
			author = ""
			book_id = null
			category = DEFAULT_SEARCH_CATAGORY
			search_page = 0
			INVOKE_ASYNC(src, PROC_REF(run_search))
			return TRUE

		if("download")
			var/id = text2num(params["id"])
			if(!isnum(id) || !try_request())
				return FALSE
			INVOKE_ASYNC(src, PROC_REF(download_book), id, key_name(ui.user))
			return TRUE

		if("print")
			var/datum/pc_book_cache/cache = get_book_cache()
			var/key = "[text2num(params["id"])]"
			var/datum/pc_saved_book/book = cache?.books[key]
			if(!book)
				return FALSE
			status_message = print_saved_book(book, key_name(ui.user))
			return TRUE

		if("print_bible")
			status_message = print_on_network(1, CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(pc_make_bible)))
			return TRUE

		if("print_poster")
			var/poster_name = params["poster_name"]
			var/poster_type = istext(poster_name) ? SSlibrary.printable_posters[poster_name] : null
			if(!poster_type)
				return FALSE
			status_message = print_on_network(1, CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(pc_make_poster), poster_type))
			return TRUE

	return FALSE

/// Finds a printer on our network and starts a print. Returns a message for the UI.
/// on_done is invoked with the printer's drop location as its last argument.
/datum/pc_program/library/proc/print_on_network(sheets, datum/callback/on_done)
	var/datum/pc_network/net = computer?.current_network
	if(!net)
		return "Not connected to a network."
	var/obj/machinery/pc_printer/printer = net.find_printer(sheets)
	if(!printer)
		return "No printer found on [net.name]."
	var/problem = printer.begin_print(sheets, on_done)
	return problem || "Printing..."

/// Prints a book from the device's saved list. Snapshots the text now, so removing
/// the book or closing the program mid-print doesn't matter.
/datum/pc_program/library/proc/print_saved_book(datum/pc_saved_book/book, printed_by)
	var/sheets = clamp(CEILING(length_char(book.content) / PC_PRINT_CHARS_PER_SHEET, 1), 1, PC_PRINT_MAX_SHEETS)
	var/safe_content = replacetext(html_encode(book.content), "\n", "<br>")
	return print_on_network(sheets, CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(pc_make_printed_book), html_encode(book.title), html_encode(book.author), safe_content, printed_by))

/datum/pc_program/library/proc/run_search()
	if(sending_request)
		return
	if(last_search_hash == hash_search_info())
		return // Same search twice is a waste of the db
	if(!SSdbcore.Connect())
		can_connect = FALSE
		page_count = 0
		results = list()
		push_update()
		return
	can_connect = TRUE
	sending_request = TRUE
	update_page_count()
	update_page_contents()
	sending_request = FALSE
	// Hashed last, so it reflects the page after clamping.
	last_search_hash = hash_search_info()
	push_update()

/datum/pc_program/library/proc/update_page_count()
	var/bookcount = 0
	var/datum/db_query/query_count = SSdbcore.NewQuery({"
		SELECT COUNT(id) FROM [format_table_name("library")]
		WHERE isnull(deleted)
			AND author LIKE CONCAT('%',:author,'%')
			AND title LIKE CONCAT('%',:title,'%')
			AND (:category = 'Any' OR category = :category)
			[book_id ? "AND id LIKE CONCAT('%', :book_id, '%')" : ""]
	"}, list("author" = author, "title" = title, "book_id" = book_id, "category" = category))
	if(!query_count.warn_execute())
		qdel(query_count)
		return
	if(query_count.NextRow())
		bookcount = text2num(query_count.item[1])
	qdel(query_count)
	page_count = round(max(bookcount - 1, 0) / BOOKS_PER_PAGE)
	search_page = clamp(search_page, 0, page_count)

/datum/pc_program/library/proc/update_page_contents()
	var/datum/db_query/query_list = SSdbcore.NewQuery({"
		SELECT author, title, category, id
		FROM [format_table_name("library")]
		WHERE isnull(deleted)
			AND author LIKE CONCAT('%',:author,'%')
			AND title LIKE CONCAT('%',:title,'%')
			AND (:category = 'Any' OR category = :category)
			[book_id ? "AND id LIKE CONCAT('%', :book_id, '%')" : ""]
		ORDER BY id DESC
		LIMIT :skip, :take
	"}, list("author" = author, "title" = title, "book_id" = book_id, "category" = category, "skip" = BOOKS_PER_PAGE * search_page, "take" = BOOKS_PER_PAGE))
	var/succeeded = query_list.Execute()
	results = list()
	if(!succeeded)
		qdel(query_list)
		return
	while(query_list.NextRow())
		results += list(list(
			"author" = html_decode(query_list.item[1]),
			"title" = html_decode(query_list.item[2]),
			"category" = query_list.item[3],
			"id" = query_list.item[4],
		))
	qdel(query_list)

/// saves book to pc
/datum/pc_program/library/proc/download_book(id, downloaded_by)
	var/datum/pc_book_cache/cache = get_book_cache()
	if(!cache || sending_request)
		return
	var/key = "[id]"
	if(cache.books[key] || cache.is_full())
		return
	if(!SSdbcore.Connect())
		can_connect = FALSE
		push_update()
		return
	sending_request = TRUE
	var/datum/db_query/query_book = SSdbcore.NewQuery(
		"SELECT author, title, category, content FROM [format_table_name("library")] WHERE id = :id AND isnull(deleted)",
		list("id" = id),
	)
	var/succeeded = query_book.Execute()
	sending_request = FALSE
	if(succeeded && query_book.NextRow() && !QDELETED(computer) && !cache.is_full())
		var/datum/pc_saved_book/book = new
		book.id = key
		book.author = html_decode(query_book.item[1])
		book.title = html_decode(query_book.item[2])
		book.category = query_book.item[3]
		book.content = query_book.item[4]
		cache.books[key] = book
		log_game("[downloaded_by] saved library book #[id] ([book.title]) to a PC.")
	qdel(query_book)
	push_update()

#undef PC_LIBRARY_REQUEST_COOLDOWN
#undef PC_LIBRARY_MAX_SAVED
#undef PC_LIBRARY_MAX_FIELD

#define BARCODE_SCANNER_CHECKIN "check_in"
#define BARCODE_SCANNER_CHECKOUT "check_out"
#define BARCODE_SCANNER_INVENTORY "inventory"

/obj/item/barcodescanner
	network_id = PC_NETWORK_PUBLIC

/obj/item/barcodescanner/get_pc_triggers()
	return list(
		"book_scanned" = list(AUTOMATION_NAME = "Book scanned", AUTOMATION_DESC = "Fires when a book is scanned. Carries the title and scan mode.", AUTOMATION_SIGNAL = COMSIG_BARCODE_SCAN, AUTOMATION_PAYLOAD = list("title", "mode"), AUTOMATION_MIN_ROLE = PC_NETWORK_USER),
	)

/// The checkout program on the closest library computer on our network, or null.
/obj/item/barcodescanner/proc/get_checkout_program()
	var/datum/pc_network/net = GLOB.pc_networks[get_network_id()]
	if(!net)
		return null
	return net.find_closest_program(/datum/pc_program/checkout, src)

/obj/item/barcodescanner/interact_with_book(obj/item/book/target_book, mob/living/user)
	var/datum/pc_program/checkout/program = get_checkout_program()
	if(!program)
		user.balloon_alert(user, "no library computer in range!")
		return ITEM_INTERACT_BLOCKING
	if(!program.can_manage(user))
		user.balloon_alert(user, "access denied!")
		return ITEM_INTERACT_BLOCKING
	var/datum/book_info/scanned = target_book.book_data
	if(!scanned)
		user.balloon_alert(user, "unreadable barcode!")
		return ITEM_INTERACT_BLOCKING

	switch(scan_mode)
		if(BARCODE_SCANNER_CHECKIN)
			if(!program.check_in_book(scanned))
				user.balloon_alert(user, "isn't checked out!")
				return ITEM_INTERACT_BLOCKING
			return scan_success(user, scanned, "checked in")

		if(BARCODE_SCANNER_CHECKOUT)
			if(program.find_loan_ref(scanned))
				user.balloon_alert(user, "already checked out!")
				return ITEM_INTERACT_BLOCKING
			var/datum/book_info/entry = program.find_inventory_entry(scanned)
			if(!entry)
				user.balloon_alert(user, "not in inventory!")
				return ITEM_INTERACT_BLOCKING
			program.set_checkout_book(entry)
			return scan_success(user, scanned, "set for check out")

		if(BARCODE_SCANNER_INVENTORY)
			if(!program.add_to_inventory(scanned))
				user.balloon_alert(user, "already in inventory!")
				return ITEM_INTERACT_BLOCKING
			return scan_success(user, scanned, "added to inventory")

	return NONE

/obj/item/barcodescanner/proc/scan_success(mob/living/user, datum/book_info/scanned, message)
	balloon_alert(user, message)
	playsound(src, 'sound/items/barcodebeep.ogg', 20, FALSE)
	SEND_SIGNAL(src, COMSIG_BARCODE_SCAN, scanned.get_title(), scan_mode)
	return ITEM_INTERACT_SUCCESS

#undef BARCODE_SCANNER_CHECKIN
#undef BARCODE_SCANNER_CHECKOUT
#undef BARCODE_SCANNER_INVENTORY
