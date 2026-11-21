/obj/machinery/pc_cash_depositor
	name = "network cash depositor"
	desc = "A reinforced slot with a counting head. Cash fed into it is shredded and credited to the local network's treasury."
	icon = 'icons/obj/machines/cell_charger.dmi'
	icon_state = "scellbig"
	density = TRUE
	anchored = TRUE
	network_id = PC_NETWORK_PUBLIC

/obj/machinery/pc_cash_depositor/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!iscash(tool))
		return ..()
	var/datum/component/networked/C = GetComponent(/datum/component/networked)
	var/datum/pc_network/current_network = GLOB.pc_networks[C.network_id]
	var/datum/pc_treasury/treasury = current_network?.treasury
	if(!treasury)
		to_chat(user, span_warning("[src] is not connected to a network ledger."))
		return ITEM_INTERACT_BLOCKING
	var/value = tool.get_item_credit_value()
	if(value < 1)
		return ITEM_INTERACT_BLOCKING
	treasury.deposit(value)
	to_chat(user, span_notice("[src] shreds [value] [MONEY_NAME] and credits it to [current_network.name]."))
	balloon_alert(user, "[value] deposited")
	qdel(tool)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/pc_cash_depositor/examine(mob/user)
	. = ..()
	var/datum/component/networked/C = GetComponent(/datum/component/networked)
	var/datum/pc_network/current_network = GLOB.pc_networks[C.network_id]
	if(current_network)
		. += span_notice("Connected to [current_network.name].")
