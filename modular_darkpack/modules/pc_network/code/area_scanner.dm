/obj/machinery/pc_area_scanner
	name = "network area scanner"
	desc = "Inventories the room it stands in and reports the dollars and commodities inside to the local network's ledger."
	icon = 'icons/obj/machines/cell_charger.dmi'
	icon_state = "scellbig"
	density = FALSE
	anchored = TRUE
	network_id = PC_NETWORK_PUBLIC
	var/area/scanned_area
	var/scanned_dollars = 0
	var/list/scanned_commodities = list()
	var/last_scan_time = 0
	COOLDOWN_DECLARE(scan_cooldown)

/obj/machinery/pc_area_scanner/Destroy()
	scanned_area = null
	return ..()

/obj/machinery/pc_area_scanner/proc/scan()
	var/area/A = get_area(src)
	scanned_area = A
	scanned_dollars = 0
	scanned_commodities = list()
	last_scan_time = world.time
	if(!A)
		return
	var/list/queue = A.contents.Copy()
	for(var/atom/AM in queue)
		if(AM == src || ismob(AM))
			continue
		if(istype(AM, /obj/item/stack/dollar))
			var/obj/item/stack/dollar/D = AM
			scanned_dollars += D.get_item_credit_value()
			continue
		if(istype(AM, /obj/item))
			var/obj/item/I = AM
			var/datum/commodity/C = SScommodities.commodity_for_item(I)
			if(C)
				var/units = 1
				if(istype(I, /obj/item/stack))
					var/obj/item/stack/S = I
					units = S.amount
				scanned_commodities[C.ticker] += units
		if(length(AM.contents))
			queue += AM.contents

/obj/machinery/pc_area_scanner/attack_hand(mob/living/user, list/modifiers)
	if(!COOLDOWN_FINISHED(src, scan_cooldown))
		balloon_alert(user, "recalibrating")
		return TRUE
	COOLDOWN_START(src, scan_cooldown, 10 SECONDS)
	scan()
	balloon_alert(user, "area scanned")
	return TRUE

/obj/machinery/pc_area_scanner/examine(mob/user)
	. = ..()
	var/datum/component/networked/C = GetComponent(/datum/component/networked)
	var/datum/pc_network/current_network = GLOB.pc_networks[C.network_id]
	if(current_network)
		. += span_notice("Connected to [current_network.name].")

/obj/machinery/pc_card_reader/loan
	name = "network loan terminal"
	desc = "Scans a credit or ID card and publishes it to the local network's ledger for a short time so an operator can lend to or collect from the account."

/obj/machinery/pc_card_reader/loan/attackby(obj/item/I, mob/user, params)
	var/datum/component/networked/comp = GetComponent(/datum/component/networked)
	var/datum/pc_network/current_network = GLOB.pc_networks[comp.network_id]
	if(istype(I, /obj/item/card/credit) || istype(I, /obj/item/card/id))
		var/datum/bank_account/acc = null
		if(istype(I, /obj/item/card/credit))
			var/obj/item/card/credit/C = I
			acc = C.registered_account
		else
			var/obj/item/card/id/ID = I
			acc = ID.registered_account
		if(!acc)
			to_chat(user, span_warning("This card has no linked account."))
			return
		if(!current_network?.treasury)
			to_chat(user, span_warning("This network has no treasury."))
			return
		current_network.treasury.publish_card(acc, scan_duration)
		to_chat(user, span_notice("Card published to [current_network.name] ledger for [DisplayTimeText(scan_duration)]. An operator can now lend to or collect from it."))
		balloon_alert(user, "card published")
		return
	return ..()
