#define PC_LOAN_MAX_MINUTES 180
#define PC_INVENTORY_RESCAN_COOLDOWN (2 SECONDS)

/datum/borrowbook
	var/source_ref

/datum/pc_program/checkout
	name = "Library Checkout"
	icon_state = "clipboard"
	tgui_id = "PcCheckout"

	/// ref(book_info) -> /datum/book_info
	var/list/inventory = list()
	/// Inventory refs the librarian removed, so a rescan doesn't bring them back
	var/list/ignored_refs = list()
	/// ref(loan) -> /datum/borrowbook
	var/list/checkouts = list()
	var/inventory_page = 0
	var/checkout_page = 0
	var/inventory_loaded = FALSE
	/// Book picked for the next checkout (UI pick or barcode scan)
	var/datum/book_info/checking_out_book
	var/checking_out_ref
	var/status_message = ""
	COOLDOWN_DECLARE(rescan_cooldown)

/datum/pc_program/checkout/proc/can_manage(mob/user)
	if(!computer)
		return FALSE
	if(!length(computer.req_access))
		return TRUE
	return computer.allowed(user)

/datum/pc_program/checkout/proc/load_nearby_books()
	inventory_loaded = TRUE
	if(!computer)
		return
	for(var/datum/book_info/book as anything in SSlibrary.get_area_books(get_area(computer)))
		var/book_ref = ref(book)
		if(book_ref in ignored_refs)
			continue
		inventory[book_ref] = book
	refresh_paging()

/datum/pc_program/checkout/proc/page_count(total, per_page)
	return FLOOR(max(total - 1, 0) / per_page, 1)

/datum/pc_program/checkout/proc/refresh_paging()
	inventory_page = clamp(inventory_page, 0, page_count(length(inventory), INVENTORY_PER_PAGE))
	checkout_page = clamp(checkout_page, 0, page_count(length(checkouts), CHECKOUTS_PER_PAGE))

/// UI sends pages 1-indexed. Returns a 0-indexed page, refresh_paging() clamps it.
/datum/pc_program/checkout/proc/read_page(raw, current)
	var/wanted = text2num(raw)
	if(!isnum(wanted))
		return current
	return wanted - 1

/datum/pc_program/checkout/proc/clear_selection()
	checking_out_book = null
	checking_out_ref = null

/datum/pc_program/checkout/proc/push_update()
	if(computer)
		SStgui.update_uis(computer)

/datum/pc_program/checkout/proc/ensure_inventory_loaded()
	if(!inventory_loaded)
		load_nearby_books()

/// Entry point for the barcode scanner as well as the UI "select" action.
/// `book` should be an inventory entry, so the on-loan check can tell it apart.
/datum/pc_program/checkout/proc/set_checkout_book(datum/book_info/book)
	if(!istype(book))
		return FALSE
	checking_out_book = book
	checking_out_ref = ref(book)
	status_message = ""
	push_update()
	return TRUE

/// ref of the loan matching this book (by content, as physical books are separate datums), or null.
/datum/pc_program/checkout/proc/find_loan_ref(datum/book_info/book)
	for(var/loan_ref in checkouts)
		var/datum/borrowbook/loan = checkouts[loan_ref]
		if(book.compare(loan.book_data))
			return loan_ref
	return null

/// The inventory entry matching this book, or null.
/datum/pc_program/checkout/proc/find_inventory_entry(datum/book_info/book)
	ensure_inventory_loaded()
	for(var/book_ref in inventory)
		var/datum/book_info/entry = inventory[book_ref]
		if(book.compare(entry))
			return entry
	return null

/// Barcode check-in. FALSE if the book isn't checked out here.
/datum/pc_program/checkout/proc/check_in_book(datum/book_info/book)
	var/loan_ref = find_loan_ref(book)
	if(!loan_ref)
		return FALSE
	checkouts -= loan_ref
	status_message = "Book checked in."
	refresh_paging()
	push_update()
	return TRUE

/// Barcode inventory add. FALSE if an identical book is already in the inventory.
/datum/pc_program/checkout/proc/add_to_inventory(datum/book_info/book)
	if(find_inventory_entry(book))
		return FALSE
	var/datum/book_info/our_copy = book.return_copy()
	inventory[ref(our_copy)] = our_copy
	refresh_paging()
	push_update()
	return TRUE

/datum/pc_program/checkout/proc/is_on_loan(book_ref)
	for(var/loan_ref in checkouts)
		var/datum/borrowbook/loan = checkouts[loan_ref]
		if(loan.source_ref == book_ref)
			return TRUE
	return FALSE

/datum/pc_program/checkout/ui_data(mob/user)
	var/list/data = list()
	data["can_manage"] = can_manage(user)
	if(!data["can_manage"])
		return data
	if(!inventory_loaded)
		load_nearby_books()
	refresh_paging()
	data["status"] = status_message

	data["inventory"] = list()
	var/inventory_len = length(inventory)
	for(var/i in ((INVENTORY_PER_PAGE * inventory_page) + 1) to min(INVENTORY_PER_PAGE * (inventory_page + 1), inventory_len))
		var/book_ref = inventory[i] // assoc list: numeric index gives the key
		var/datum/book_info/info = inventory[book_ref]
		data["inventory"] += list(list(
			"ref" = book_ref,
			"title" = info.get_title(),
			"author" = info.get_author(),
			"on_loan" = is_on_loan(book_ref),
		))
	data["has_inventory"] = !!inventory_len
	data["inventory_page"] = inventory_page + 1
	data["inventory_page_count"] = page_count(inventory_len, INVENTORY_PER_PAGE) + 1
	data["selected_ref"] = checking_out_ref
	data["selected_title"] = checking_out_book?.get_title()

	data["checkouts"] = list()
	var/checkout_len = length(checkouts)
	for(var/i in ((CHECKOUTS_PER_PAGE * checkout_page) + 1) to min(CHECKOUTS_PER_PAGE * (checkout_page + 1), checkout_len))
		var/loan_ref = checkouts[i]
		var/datum/borrowbook/loan = checkouts[loan_ref]
		var/timedue = max(round((loan.duedate - world.time) / (1 MINUTES), 0.1), 0)
		data["checkouts"] += list(list(
			"ref" = loan_ref,
			"borrower" = loan.loanedto || "N/A",
			"overdue" = (timedue <= 0),
			"due_in_minutes" = timedue,
			"title" = loan.book_data.get_title(),
			"author" = loan.book_data.get_author(),
		))
	data["has_checkout"] = !!checkout_len
	data["checkout_page"] = checkout_page + 1
	data["checkout_page_count"] = page_count(checkout_len, CHECKOUTS_PER_PAGE) + 1
	data["max_minutes"] = PC_LOAN_MAX_MINUTES
	return data

/datum/pc_program/checkout/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	if(!can_manage(ui.user))
		return FALSE

	switch(action)
		if("rescan")
			if(!COOLDOWN_FINISHED(src, rescan_cooldown))
				return FALSE
			COOLDOWN_START(src, rescan_cooldown, PC_INVENTORY_RESCAN_COOLDOWN)
			load_nearby_books()
			return TRUE

		if("inventory_remove")
			var/book_ref = params["ref"]
			if(!istext(book_ref) || !inventory[book_ref])
				return FALSE
			inventory -= book_ref
			ignored_refs |= book_ref
			if(checking_out_ref == book_ref)
				clear_selection()
			refresh_paging()
			return TRUE

		if("inventory_page")
			inventory_page = read_page(params["page"], inventory_page)
			refresh_paging()
			return TRUE

		if("checkout_page")
			checkout_page = read_page(params["page"], checkout_page)
			refresh_paging()
			return TRUE

		if("select")
			var/book_ref = params["ref"]
			if(!istext(book_ref))
				return FALSE
			return set_checkout_book(inventory[book_ref])

		if("clear_selection")
			clear_selection()
			return TRUE

		if("checkout")
			if(!checking_out_book)
				return FALSE
			if(is_on_loan(checking_out_ref))
				status_message = "That book is already on loan."
				return TRUE
			var/raw_name = params["loaned_to"]
			var/loan_to = istext(raw_name) ? copytext_char(sanitize(raw_name), 1, MAX_NAME_LEN + 1) : ""
			var/minutes = clamp(round(text2num(params["minutes"]) || 1), 1, PC_LOAN_MAX_MINUTES)
			var/datum/borrowbook/loan = new
			loan.book_data = checking_out_book.return_copy()
			loan.source_ref = checking_out_ref
			loan.loanedto = loan_to
			loan.checkout = world.time
			loan.duedate = world.time + (minutes MINUTES)
			checkouts[ref(loan)] = loan
			status_message = "Checked out \"[loan.book_data.get_title()]\" for [minutes] minute\s."
			clear_selection()
			refresh_paging()
			return TRUE

		if("checkin")
			var/loan_ref = params["ref"]
			if(!istext(loan_ref) || !checkouts[loan_ref])
				return FALSE
			checkouts -= loan_ref
			status_message = "Book checked in."
			refresh_paging()
			return TRUE

	return FALSE

#undef PC_LOAN_MAX_MINUTES
#undef PC_INVENTORY_RESCAN_COOLDOWN
