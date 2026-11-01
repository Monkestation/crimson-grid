/obj/machinery/pc_card_reader
	name = "network card reader"
	desc = "Scans a credit or ID card and publishes it to the local network's ETF program for a short time so an operator can enroll the account."
	icon = 'icons/obj/machines/cell_charger.dmi'
	icon_state = "scellbig"
	density = TRUE
	anchored = TRUE
	var/datum/pc_network/current_network
	var/scan_duration = 30 SECONDS

/obj/machinery/pc_card_reader/Initialize(mapload)
	. = ..()
	current_network = GLOB.public_network // adapt if your networks join differently
	current_network?.join(src)

/obj/machinery/pc_card_reader/Destroy()
	current_network?.leave(src)
	return ..()

/obj/machinery/pc_card_reader/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/card/credit) || istype(I, /obj/item/card/id))
		var/datum/bank_account/acc = null
		if(istype(I, /obj/item/card/credit))
			var/obj/item/card/credit/C = I
			acc = C.registered_account
		else if(istype(I, /obj/item/card/id))
			var/obj/item/card/id/ID = I
			acc = ID.registered_account
		if(!acc)
			to_chat(user, span_warning("This card has no linked account."))
			return
		if(!current_network?.etf)
			to_chat(user, span_warning("This network has no ETF."))
			return
		current_network.etf.publish_card(acc, scan_duration, src)
		to_chat(user, span_notice("Card published to [current_network.name] ETF for [DisplayTimeText(scan_duration)]. An operator can now enroll it."))
		balloon_alert(user, "card published")
		return
	return ..()

/obj/machinery/pc_card_reader/examine(mob/user)
	. = ..()
	if(current_network)
		. += span_notice("Connected to [current_network.name].")
