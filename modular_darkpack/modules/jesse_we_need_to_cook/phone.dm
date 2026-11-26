/obj/item/smartphone/proc/receive_npc_text(sender_name, sender_number, message_text)
	var/datum/phone_conversation/conversation = get_conversation(sender_number)
	if(!conversation)
		conversation = new(sender_name, sender_number)
		conversations += conversation
	conversation.add_message(message_text, FALSE)
	addtimer(CALLBACK(src, PROC_REF(after_text_received), sender_name, message_text), rand(1 SECONDS, 2 SECONDS))
