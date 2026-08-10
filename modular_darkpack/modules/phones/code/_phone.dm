/obj/item/smartphone
	name = "smartphone"
	desc = "A portable device to call anyone you want."
	icon = 'modular_darkpack/modules/phones/icons/phone.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/phones/icons/phone_onfloor.dmi')
	icon_state = "phone"
	inhand_icon_state = "phone"
	lefthand_file = 'modular_darkpack/modules/phones/icons/lefthand.dmi'
	righthand_file = 'modular_darkpack/modules/phones/icons/righthand.dmi'
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FIRE_PROOF | ACID_PROOF
	// Who owns this phone on initialization?
	var/datum/weakref/owner_weakref
	// There's a radio in my phone that calls me stud muffin.
	var/obj/item/radio/phone_radio
	// Cooldown for the phone call sound.
	COOLDOWN_DECLARE(ringer_cooldown)
	// Contacts the phone has saved.
	var/list/contacts = list()
	// Contacts the phone has blocked.
	var/list/blocked_contacts = list()
	// The phone history of the phone.
	var/list/phone_history_list = list()
	// Currently viewed newscaster channel. Used for IRC Announcements
	var/obj/machinery/newscaster/irc_channel
	// Do we have a SIM card?
	var/obj/item/sim_card/sim_card
	// There's a wiki in our phone. Literally.
	var/obj/item/book/manual/wiki/wiki_book
	// Phone flags, for things like if its open or if it has no sim card.
	var/phone_flags = NONE
	// The phone's current state.
	VAR_PRIVATE/current_state = PHONE_AVAILABLE
	// The number the phone has dialed.
	var/dialed_number
	// The frequency in use for a phone call.
	var/secure_frequency
	// Current sound to play when the phone is ringing.
	var/call_sound = 'modular_darkpack/modules/phones/sounds/call.ogg'
	// If the phone should play a sound when ringing.
	var/ringer = TRUE
	// If the phone shows balloon alerts when ringing.
	var/vibration = TRUE
	// Passive particle effect generation for when on call
	var/obj/effect/abstract/particle_holder/particle_generator
	// If the phone's microphone is muted.
	var/muted = FALSE
	// ID of the timer that the phone uses for ringing. Deleted once the user denies a phone call or misses it.
	var/phone_ringing_timer = null
	// The phone number of the phone calling us. If any.
	var/incoming_phone_number = null

	/// A list of associative lists with three indeces: NETWORK_ID, OUR_ROLE and USE_JOB_TITLE. So that contact_networks is populated on init.
	var/list/contact_networks_pre_init = null
	/// A list of contact networks to be added in. Order matters, as if members overlap they will only get the first contact.
	var/list/contact_networks = null
	var/important_contact_of = null
	custom_price = 100
	//texting stuff
	var/list/conversations = list()
	var/current_viewed_conversation = null
	var/phone_background = ""
	var/custom_background = null // ori's request to add a custom background URL
	var/endpost_username = null //username for the endpost app

/obj/item/smartphone/Initialize(mapload)
	. = ..()
	GLOB.phones_list += src
	if(!sim_card)
		sim_card = new()
		sim_card.phone_weakref = WEAKREF(src)
	phone_radio = new(src)
	phone_radio.keyslot = new
	phone_radio.radio_noise = FALSE
	phone_radio.canhear_range = 1
	irc_channel = new()
	wiki_book = new()
	become_hearing_sensitive(ROUNDSTART_TRAIT)
	RegisterSignal(src, COMSIG_MOVABLE_HEAR, PROC_REF(handle_hearing))
	AddComponent(/datum/component/violation_observer, FALSE)
	phone_background = "BG_[rand(1,18)]" // pick a random phone background when spawned

/obj/item/smartphone/proc/update_initialized_contacts()
	var/mob/living/carbon/owner = owner_weakref.resolve()
	if(LAZYLEN(contact_networks_pre_init))
		LAZYINITLIST(contact_networks)
		for(var/list/contact_network_info as anything in contact_networks_pre_init)
			var/list/network_contacts = GLOB.contact_networks[contact_network_info[NETWORK_ID]]

			var/our_role = contact_network_info[OUR_ROLE]
			if(contact_network_info[USE_JOB_TITLE] && !isnull(owner) && owner?.job)
				var/datum/job/job = SSjob.get_job(owner.job)
				our_role = job.title

			var/datum/contact_network/contact_network = new(network_contacts, our_role)
			contact_networks += contact_network

			var/datum/contact/our_contact = new(owner.real_name, sim_card.phone_number, our_role, WEAKREF(src))
			network_contacts |= our_contact

	for(var/obj/item/smartphone/P as anything in GLOB.phones_list)
		P.update_contacts()

	if(important_contact_of && owner && sim_card.phone_number)
		GLOB.important_contacts[important_contact_of] = new /datum/phonecontact(owner.real_name, sim_card.phone_number)

/obj/item/smartphone/Destroy(force)
	SEND_SIGNAL(src, COMSIG_ALL_MASQUERADE_REINFORCE)
	GLOB.phones_list -= src
	for(var/datum/contact_network/contact_network as anything in contact_networks)
		for(var/datum/contact/our_contact in contact_network.contacts)
			if(our_contact.number == sim_card.phone_number)
				contact_network.contacts -= our_contact

	if(particle_generator)
		QDEL_NULL(particle_generator)

	lose_hearing_sensitivity(ROUNDSTART_TRAIT)
	UnregisterSignal(src, COMSIG_MOVABLE_HEAR)
	if(sim_card)
		sim_card.phone_weakref = null
		QDEL_NULL(sim_card)
	if(phone_radio)
		QDEL_NULL(phone_radio.keyslot)
		QDEL_NULL(phone_radio)
	if(irc_channel)
		QDEL_NULL(irc_channel)
	if(wiki_book)
		QDEL_NULL(wiki_book)
	return ..()

/obj/item/smartphone/examine(mob/user)
	. = ..()
	. += span_notice("[EXAMINE_HINT("Interact")] to look at the screen.")
	. += span_notice("[EXAMINE_HINT("Alt-Click")] or [EXAMINE_HINT("Right-Click")] to toggle the screen.")
	if(sim_card)
		. += span_notice("[EXAMINE_HINT("Ctrl-Click")] to remove [sim_card].")
	else
		. += span_notice("You can [EXAMINE_HINT("Insert")] a SIM card.")

/obj/item/smartphone/attack_self(mob/user, modifiers)
	. = ..()
	if(!(phone_flags & PHONE_OPEN))
		toggle_screen(user)
	ui_interact(user)

/obj/item/smartphone/click_alt(mob/user)
	if(!(user.is_holding(src)))
		return CLICK_ACTION_BLOCKING
	toggle_screen(user)
	return CLICK_ACTION_SUCCESS

/obj/item/smartphone/item_ctrl_click(mob/user)
	if(!(user.is_holding(src)))
		return CLICK_ACTION_BLOCKING
	if(!sim_card)
		balloon_alert(user, "no sim card!")
		return CLICK_ACTION_BLOCKING
	if(do_after(user, 2 SECONDS, src))
		balloon_alert(user, "you remove \the [sim_card]!")
		log_phone("[key_name(usr)] removed a SIM card with the number [sim_card.phone_number].")
		switch(current_state)
			if(PHONE_CALLING)
				hang_up_phone_call(dialed_number)
			if(PHONE_RINGING)
				decline_phone_call()
			if(PHONE_IN_CALL)
				end_phone_call()
		user.put_in_hands(sim_card)
		sim_card.phone_weakref = null
		sim_card = null
		phone_flags |= PHONE_NO_SIM
		return CLICK_ACTION_SUCCESS
	return CLICK_ACTION_BLOCKING

/obj/item/smartphone/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/sim_card))
		if(sim_card)
			balloon_alert(user, "[sim_card] already installed!")
			return ITEM_INTERACT_BLOCKING
		balloon_alert(user, "you insert \the [tool]!")
		sim_card = tool
		user.transferItemToLoc(tool, src)
		sim_card.phone_weakref = WEAKREF(src)
		phone_flags &= ~PHONE_NO_SIM
		log_phone("[key_name(usr)] inserted a SIM card with the number [sim_card.phone_number].")
		return TRUE
	return ..()

/obj/item/smartphone/ui_status(mob/user, datum/ui_state/state)
	if(!(phone_flags & PHONE_OPEN))
		return UI_CLOSE
	return ..()

/obj/item/smartphone/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	var/datum/asset/background_files = get_asset_datum(/datum/asset/simple/phone_assets)
	if(user.client)
		background_files.send(user.client)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Telephone")
		ui.open()

/obj/item/smartphone/ui_data(mob/living/user)
	var/list/data = list()
	data["my_number"] = sim_card ? sim_card.phone_number : "No SIM card inserted."
	data["no_sim_card"] = (phone_flags & PHONE_NO_SIM) ? TRUE : FALSE
	data["phone_in_call"] = (current_state == PHONE_IN_CALL) ? TRUE : FALSE
	data["phone_ringing"] = (current_state == PHONE_RINGING) ? TRUE : FALSE
	data["phone_calling"] = (current_state == PHONE_CALLING) ? TRUE : FALSE
	data["ringer"] = ringer
	data["vibration"] = vibration
	data["speaker_mode"] = (phone_radio.canhear_range == 3) ? TRUE : FALSE
	data["muted"] = muted

	var/list/published_numbers = list()
	for(var/contact, number in SSphones.published_phone_numbers)
		UNTYPED_LIST_ADD(published_numbers, list(
			"name" = contact,
			"number" = number,
		))
	data["published_numbers"] = published_numbers
	data["sim_published"] = sim_card.published
	data["sim_published_name"] = sim_card.published_name

	var/list/our_contacts = list()
	for(var/datum/phonecontact/contact in contacts)
		UNTYPED_LIST_ADD(our_contacts, list(
			"name" = contact.name,
			"number" = contact.number,
		))
	data["our_contacts"] = our_contacts

	var/list/our_blocked_contacts = list()
	for(var/datum/phonecontact/contact in blocked_contacts)
		UNTYPED_LIST_ADD(our_blocked_contacts, list(
			"name" = contact.name,
			"number" = contact.number,
		))
	data["our_blocked_contacts"] = our_blocked_contacts

	var/list/phone_history = list()
	for(var/datum/phone_history/PH in phone_history_list)
		UNTYPED_LIST_ADD(phone_history, list(
			"type" = PH.call_type,
			"type_tooltip" = PH.call_type_tooltip,
			"name" = PH.name,
			"number" = PH.number,
			"time" = PH.time
		))
	data["phone_history"] = phone_history

	var/calling_user = incoming_phone_number ? incoming_phone_number : dialed_number
	if(calling_user)
		data["calling_user"] = get_number_contact_name(calling_user)
	else
		data["calling_user"] = ""

	data["time"] = server_timestamp("hh:mm", ic_time = TRUE)
	data["date"] = server_timestamp("Day, Month DD, YYYY", ic_time = TRUE)
	data["background_url"] = phone_background

	var/list/conversations_list = list()
	for(var/datum/phone_conversation/convo in conversations)
		var/contact_name = convo.contact_number

		for(var/datum/phonecontact/contact in contacts)
			if(contact.number == convo.contact_number)
				contact_name = contact.name
				break

		if(contact_name == convo.contact_number && (convo.contact_number in SSphones.published_phone_numbers))
			contact_name = SSphones.published_phone_numbers[convo.contact_number]

		var/last_msg = ""
		var/last_timestamp = 0
		if(length(convo.messages) > 0)
			var/datum/phone_message/last_message = convo.messages[length(convo.messages)]
			last_msg = last_message.message_text // replaces the phone number under the name
			last_timestamp = last_message.timestamp

		UNTYPED_LIST_ADD(conversations_list, list(
			"contact_name" = contact_name,
			"number" = convo.contact_number,
			"last_message_text" = last_msg,
			"last_timestamp" = last_timestamp,
		))

	data["conversations"] = conversations_list

	if(current_viewed_conversation)
		data["current_conversation_messages"] = format_conversation(current_viewed_conversation)
	else
		data["current_conversation_messages"] = list()

	data["posts"] = SSphones.endpost_posts
	data["endpost_username"] = endpost_username
	data["show_endpost_registration"] = !endpost_username || user.st_get_stat(STAT_TECHNOLOGY) >= 3 //only let big brains change their usernames
	data["is_admin"] = is_admin(user)

	return data

/obj/item/smartphone/ui_act(action, params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("call")
			start_phone_call(usr, params["number"])
			log_phone("[key_name(usr)] called [params["number"]].")
			return TRUE

		if("hang")
			if(current_state == PHONE_IN_CALL)
				end_phone_call()
			else
				hang_up_phone_call(dialed_number)
			return TRUE

		if("accept")
			accept_phone_call(usr)
			log_phone("[key_name(usr)] answered a phone call.")
			return TRUE

		if("decline")
			decline_phone_call()
			log_phone("[key_name(usr)] declined a phone call.")
			return TRUE

		if("publish_number")
			to_chat(usr, span_notice("This text will represent you in the phonebook. example: Jane Doe | Anarchy Rose Manager"))
			var/name = tgui_input_text(usr, "Phonebook Name", "Publish Number")
			if(!name)
				to_chat(usr, span_danger("You must input text to publish your number."))
				return
			if(!sim_card)
				to_chat(usr, span_danger("You must insert a SIM card to publish your number."))
				return
			name = trim(copytext_char(sanitize(name), 1, MAX_MESSAGE_LEN))
			for(var/contact in SSphones.published_phone_numbers)
				if(SSphones.published_phone_numbers[contact] == sim_card.phone_number)
					to_chat(usr, span_danger("Error: This number is already published."))
					return TRUE
			SSphones.published_phone_numbers[name] = sim_card.phone_number
			to_chat(usr, span_notice("Your number is now published."))
			sim_card.published = TRUE
			sim_card.published_name = name
			log_phone("[key_name(usr)] published their number ([name])/[sim_card.phone_number] to the phonebook.")
			return TRUE

		if("unpublish_number")
			for(var/contact in SSphones.published_phone_numbers)
				if(SSphones.published_phone_numbers[contact] == sim_card.phone_number)
					log_phone("[key_name(usr)] unpublished their number ([contact])/[sim_card.phone_number] from the phonebook.")
					SSphones.published_phone_numbers.Remove(contact)
					sim_card.published = FALSE
					sim_card.published_name = null
					to_chat(usr, span_notice("Your number is now unpublished."))
					return TRUE

		if("custom_background")
			to_chat(usr, span_danger("Do NOT use images that can be considered offensive or obscene, or that contain references to something that happened after the year [CURRENT_STATION_YEAR]. Recommended image dimensions: 400x600 "))
			custom_background = tgui_input_text(usr, "Input background image URL", "Custom Background")
			if(!custom_background)
				to_chat(usr, span_danger("You must input a URL to set a custom background."))
				return
			phone_background = custom_background
			log_phone("[key_name(usr)] set a custom background image on [src]: [custom_background]")
			return TRUE

		if("add_contact")
			var/number = tgui_input_text(usr, "Input number", "Add Contact")
			if(length(number) > 15)
				to_chat(usr, span_danger("Entered number is too long"))
				return FALSE
			var/stripped_number = replacetext(number, " ", "") // remove spaces
			var/new_contact_name = tgui_input_text(usr, "Input name", "Add Contact")
			if(!new_contact_name || !number)
				to_chat(usr, span_danger("You must provide both a name and a number."))
				return FALSE

			var/datum/phonecontact/new_contact = new()
			new_contact.number = "[stripped_number]"
			new_contact.name = "[new_contact_name]"
			contacts += new_contact
			log_phone("[key_name(usr)] added a new contact: [new_contact_name] ([stripped_number])")
			return TRUE

		if("remove_contact")
			var/number = tgui_input_text(usr, "Input number", "Remove Contact")
			if(length(number) > 15)
				to_chat(usr, span_danger("Entered number is too long"))
				return FALSE
			for(var/datum/phonecontact/contact in contacts)
				if(contact.number == number)
					contacts -= contact
					log_phone("[key_name(usr)] removed a contact with number: [number]")
					return TRUE
			return FALSE

		if("block")
			var/block_number = tgui_input_text(usr, "Input number to block", "Block Contact")
			if(!block_number)
				to_chat(usr, span_warning("You must provide a number."))
				return FALSE
			if(length(block_number) > 15)
				to_chat(usr, span_warning("Invalid number."))
				return FALSE

			var/datum/phonecontact/blocked_contact = new()
			block_number = replacetext(block_number, " ", "")
			blocked_contact.number = "[block_number]"
			blocked_contact.name = "Blocked [length(blocked_contacts)+1]"
			blocked_contacts += blocked_contact
			return TRUE

		if("unblock")
			var/result = tgui_input_text(usr, "Input number to unblock", "Unblock Contact")
			if(!result)
				to_chat(usr, span_warning("You must provide a number."))
				return FALSE
			for(var/datum/phonecontact/unblocked_contact in blocked_contacts)
				if(unblocked_contact.name == result)
					blocked_contacts -= unblocked_contact
					return TRUE
			return FALSE

		if("delete_call_history")
			if(!length(phone_history_list))
				to_chat(usr, span_danger("You have no call history to delete."))
				return FALSE

			to_chat(usr, "Your total amount of history saved is: [length(phone_history_list)]")
			var/number_of_deletions = tgui_input_number(usr, "Input the amount that you want to delete", "Deletion Amount", max_value = length(phone_history_list))
			if(!number_of_deletions)
				return FALSE

			//Delete the call history depending on the amount inputed by the User
			if(number_of_deletions > length(phone_history_list))
				//Verify if the requested amount in bigger than the history list.
				to_chat(usr, "You cannot delete more items than the history contains.")
				return FALSE
			else
				for(var/i in 1 to number_of_deletions)
					//It will always delete the first item of the list, so the last logs are deleted first
					var/item_to_remove = phone_history_list[1]
					phone_history_list -= item_to_remove
			to_chat(usr, "[number_of_deletions] call history entries were deleted. Remaining: [length(phone_history_list)]")
			return TRUE

		if("terminal_sound")
			if(ringer)
				playsound(loc, 'sound/machines/terminal/terminal_select.ogg', 15, TRUE)
			return TRUE

		if("silent")
			ringer = !ringer
			balloon_alert(usr, "ringer [ringer ? "on" : "off"]!")
			return TRUE

		if("vibration")
			vibration = !vibration
			balloon_alert(usr, "vibration [vibration ? "on" : "off"]!")
			return TRUE

		if("speaker")
			if(phone_radio.canhear_range == 1)
				phone_radio.canhear_range = 3
				balloon_alert(usr, "speaker on!")
			else
				phone_radio.canhear_range = 1
				balloon_alert(usr, "speaker off!")
			return TRUE

		if("set_background")
			phone_background = params["background_url"]
			return TRUE

		if("mute")
			muted = !muted
			phone_radio.set_listening(!muted)
			balloon_alert(usr, "[muted ? "muted" : "unmuted"]!")

		if("wiki")
			wiki_book.display_content(usr)

		if("view_conversation")
			current_viewed_conversation = params["contact_number"]
			var/datum/phone_conversation/conversation = get_conversation(current_viewed_conversation)
			if(!conversation)
				conversation = new(current_viewed_conversation)
			return TRUE

		if("submit_post")
			submit_post(params["body"])
			return TRUE

		if("endpost_registration")
			endpost_registration()
			return TRUE

		if("remove_endpost")
			var/post_index = text2num(params["post_index"])
			if(!post_index)
				to_chat(usr, "Invalid post index.")
				return FALSE
			var/list/selected_post = SSphones.endpost_posts[post_index]
			SSphones.endpost_posts.Cut(post_index, post_index + 1)
			to_chat(usr, "Post '[selected_post["body"]]' by [selected_post["author"]] removed.")
			log_phone("[key_name(usr)] removed an endpost: [selected_post["body"]] by [selected_post["author"]]", list("author" = selected_post["author"], "body" = selected_post["body"]))
			return TRUE

		if("keyboard_click")
			if(ringer)
				playsound(loc, 'modular_darkpack/modules/phones/sounds/keyboard_click.ogg', 75, TRUE)
			return TRUE

		if("send_message")
			var/contact_number = params["contact_number"]
			var/message_text = params["message_text"]
			if(!contact_number || !message_text)
				return FALSE
			send_text_message(contact_number, message_text)
			if(ringer)
				playsound(loc, 'modular_darkpack/modules/phones/sounds/text_send.ogg', 50, TRUE)
			return TRUE

	return FALSE

/obj/item/smartphone/proc/get_conversation(contact_number)
	for(var/datum/phone_conversation/convo in conversations)
		if(convo.contact_number == contact_number)
			return convo

/obj/item/smartphone/proc/send_text_message(contact_number, message_text)
	if(!contact_number || !message_text)
		return FALSE

	var/contact_name = get_number_contact_name(contact_number)
	var/datum/phone_conversation/conversation = get_conversation(contact_number)

	if(!conversation)
		conversation = new(contact_name, contact_number)
		conversations += conversation

	conversation.add_message(message_text, TRUE)

	var/obj/item/smartphone/receiving_phone = SSphones.get_phone_from_number(contact_number)
	if(receiving_phone)
		var/recv_contact_name = receiving_phone.get_number_contact_name(sim_card.phone_number)
		var/datum/phone_conversation/recv_conversation = receiving_phone.get_conversation(sim_card.phone_number)
		if(!recv_conversation)
			recv_conversation = new(recv_contact_name, sim_card.phone_number)
			receiving_phone.conversations += recv_conversation
		recv_conversation.add_message(message_text, FALSE)
		addtimer(CALLBACK(receiving_phone, PROC_REF(after_text_received), contact_name, message_text), rand(1 SECONDS, 2 SECONDS)) //simulate random delay before sending an audible/visible alert
		log_phone("[key_name(usr)] sent a text to [contact_number]: [message_text]", list("sender" = contact_name, "receiver" = recv_contact_name, "message" = message_text))
	return TRUE

//stuff to do after a text is received
/obj/item/smartphone/proc/after_text_received(contact_name, message_text)
	// This should support having your notifiactions set to hidden to not show detials without opening the app.
	receive_notification("Message+", contact_name, message_text)

/obj/item/smartphone/proc/format_conversation(contact_number)
	var/datum/phone_conversation/conversation = get_conversation(contact_number)

	if(!conversation)
		conversation = new("Unknown", contact_number)

	var/list/formatted_messages = list()
	for(var/datum/phone_message/msg in conversation.messages)
		UNTYPED_LIST_ADD(formatted_messages, list(
			"contact_name" = msg.contact_name,
			"number" = msg.number,
			"message_text" = msg.message_text,
			"time" = msg.time,
			"is_outgoing" = msg.is_outgoing,
		))

	return formatted_messages

/obj/item/smartphone/proc/toggle_screen(mob/user)
	if(phone_flags & PHONE_OPEN)
		phone_flags &= ~PHONE_OPEN
	else
		phone_flags |= PHONE_OPEN
	icon_state = (phone_flags & PHONE_OPEN) ? "phone_on" : "phone"
	inhand_icon_state = (phone_flags & PHONE_OPEN) ? "phone_on" : "phone"
	update_icon()

/obj/item/smartphone/proc/submit_post(body)
	if(!body)
		return FALSE

	if(!endpost_username)
		return FALSE

	var/new_post = list(
		"body" = trim(body),
		"date" = server_timestamp("Day, Month DD, YYYY", ic_time = TRUE),
		"time" = server_timestamp("hh:mm", ic_time = TRUE),
		"author" = endpost_username
	)

	UNTYPED_LIST_ADD(SSphones.endpost_posts, new_post)
	log_phone("[key_name(usr)] submitted a new endpost: [trim(body)] as [endpost_username]")

	return TRUE

/obj/item/smartphone/proc/endpost_registration()
	var/new_username = tgui_input_text(usr, "Choose your username:", "EndPost Registration", "", 14) //max size of 14 chars or it starts bumping elements around
	log_phone("[key_name(usr)] [endpost_username ? "updated" : "registered"] their username as [new_username]")
	endpost_username = new_username
	return TRUE

/proc/log_phone(text, list/data)
	logger.Log(LOG_CATEGORY_PDA_CHAT, text, data)
