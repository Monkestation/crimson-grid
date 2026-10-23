/datum/pc_program/email
	name = "Mail Client"
	icon_state = "envelope"
	tgui_id = "PcEmail"

/datum/pc_program/email/ui_data(mob/user)
	var/list/data = list()
	var/address = computer.get_formatted_address()
	var/datum/pc_network/net = computer.current_network

	data["address"] = address
	data["network"] = net?.name
	data["is_schrecknet"] = (net?.id == PC_NETWORK_SCHRECKNET)
	data["inbox"] = list()

	if(net)
		var/list/mailbox = net.mailboxes[address]
		if(islist(mailbox))
			for(var/datum/pc_mail/M in mailbox)
				data["inbox"] += list(list(
					"from" = M.from_address,
					"subject" = M.subject,
					"body" = M.body,
					"time" = M.timestamp,
					"read" = M.read
				))
	return data

/datum/pc_program/email/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	var/datum/pc_network/net = computer.current_network
	if(!net)
		return FALSE

	var/address = computer.get_formatted_address()

	switch(action)
		if("send")
			var/datum/pc_mail/mail = new
			mail.from_address = address
			mail.to_address = lowertext(params["to"])
			mail.subject = params["subject"]
			mail.body = params["body"]
			mail.timestamp = time_to_twelve_hour()

			//only same network emails
			LAZYADD(net.mailboxes[mail.to_address], mail)
			return TRUE

		if("mark_read")
			var/index = text2num(params["index"])
			var/list/mailbox = net.mailboxes[address]
			if(islist(mailbox) && index >= 1 && index <= length(mailbox))
				var/datum/pc_mail/M = mailbox[index]
				if(M)
					M.read = TRUE
					return TRUE
	return FALSE
