/// Characters shown per page in the reader
#define PC_BOOK_PAGE_CHARS 1800

/datum/pc_program/book_reader
	name = "Book Reader"
	icon_state = "book-open"
	tgui_id = "PcBookReader"

	/// Key of the book currently open, null = showing the shelf
	var/open_key = null
	var/page = 0

/datum/pc_program/book_reader/proc/get_open_book()
	var/datum/pc_book_cache/cache = get_book_cache()
	if(!cache || !open_key)
		return null
	return cache.books[open_key]

/datum/pc_program/book_reader/proc/page_total(datum/pc_saved_book/book)
	return max(1, CEILING(length_char(book.content) / PC_BOOK_PAGE_CHARS, 1))

/datum/pc_program/book_reader/ui_data(mob/user)
	var/list/data = list()
	var/datum/pc_book_cache/cache = get_book_cache()

	data["books"] = list()
	if(cache)
		for(var/key in cache.books)
			var/datum/pc_saved_book/shelf_book = cache.books[key]
			data["books"] += list(list(
				"id" = shelf_book.id,
				"title" = shelf_book.title,
				"author" = shelf_book.author,
				"category" = shelf_book.category,
				"length" = length_char(shelf_book.content),
			))
	data["saved_max"] = 20

	var/datum/pc_saved_book/book = get_open_book()
	if(!book)
		open_key = null
		data["open"] = null
		return data

	var/total = page_total(book)
	page = clamp(page, 0, total - 1)
	var/start = (page * PC_BOOK_PAGE_CHARS) + 1
	data["open"] = list(
		"id" = book.id,
		"title" = book.title,
		"author" = book.author,
		"text" = copytext_char(book.content, start, start + PC_BOOK_PAGE_CHARS),
		"page" = page + 1,
		"page_count" = total,
	)
	return data

/datum/pc_program/book_reader/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	var/datum/pc_book_cache/cache = get_book_cache()
	if(!cache)
		return FALSE

	switch(action)
		if("open")
			var/key = params["id"]
			if(!istext(key) || !cache.books[key])
				return FALSE
			open_key = key
			page = 0
			return TRUE

		if("close")
			open_key = null
			page = 0
			return TRUE

		if("page")
			var/datum/pc_saved_book/book = get_open_book()
			var/wanted = text2num(params["page"])
			if(!book || !isnum(wanted))
				return FALSE
			page = clamp(wanted - 1, 0, page_total(book) - 1)
			return TRUE

		if("remove")
			var/key = params["id"]
			if(!istext(key) || !cache.books[key])
				return FALSE
			cache.books -= key
			if(open_key == key)
				open_key = null
				page = 0
			return TRUE

	return FALSE

#undef PC_BOOK_PAGE_CHARS
