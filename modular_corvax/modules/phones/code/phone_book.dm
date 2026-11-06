/client
	/// Only one phone-book input may be pending for this player.
	var/phone_book_open = FALSE

/obj/item/sim_card
	/// Generated directory label shared by all readers of this SIM card.
	var/directory_name

/obj/item/phone_book/proc/show_directory(mob/user)
	var/client/reader_client = user.client
	if(!reader_client || reader_client.phone_book_open)
		return
	var/list/entries = list()
	var/list/used_labels = list()
	var/list/seen_entries = list()
	for(var/obj/item/sim_card/card as anything in SSphones.assigned_phone_numbers)
		var/obj/item/smartphone/phone = card.phone_weakref?.resolve()
		var/mob/living/carbon/owner = phone?.owner_weakref?.resolve()
		var/label
		if(istype(card, /obj/item/sim_card/emergency))
			label = "Экстренные службы"
		else if(istype(card, /obj/item/sim_card/cleaner))
			label = "Клининговая служба"
		else if(owner || card.published_name)
			var/list/name_parts = splittext(trim(owner ? owner.real_name : card.published_name), " ")
			name_parts -= ""
			if(length(name_parts))
				label = name_parts[1]
				if(length(name_parts) > 1)
					label += " [copytext_char(name_parts[length(name_parts)], 1, 2)]."
			else
				label = "неизвестен"
		else if(istype(phone, /obj/item/smartphone/payphone))
			var/area/phone_area = get_area(phone)
			label = phone_area ? "Таксофон ([phone_area.name])" : "Таксофон"
		else if(phone)
			if(!card.directory_name)
				var/last_name = pick(GLOB.last_names)
				card.directory_name = "[pick(GLOB.first_names)] [copytext_char(last_name, 1, 2)]."
			label = card.directory_name
		else
			label = "SIM-карта без телефона"
		var/chat_entry = "[label] - [SSphones.assigned_phone_numbers[card]]"
		if(seen_entries[chat_entry])
			continue
		seen_entries[chat_entry] = TRUE
		var/entry_label = avoid_assoc_duplicate_keys(label, used_labels)
		while(entries[entry_label])
			entry_label = avoid_assoc_duplicate_keys(label, used_labels)
		entries[entry_label] = chat_entry
	if(!length(entries))
		balloon_alert(user, "в книге нет номеров")
		return
	reader_client.phone_book_open = TRUE
	var/selection = tgui_input_list(user, "Найдите имя", "Телефонная книга", sort_list(entries))
	if(reader_client)
		reader_client.phone_book_open = FALSE
	if(selection)
		to_chat(user, html_encode(entries[selection]))
