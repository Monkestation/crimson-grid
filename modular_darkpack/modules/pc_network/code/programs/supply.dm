/datum/pc_program/supply
	name = "Supply Request"
	icon_state = "shopping-cart"
	tgui_id = "PcSupply"

/datum/pc_program/supply/ui_data(mob/user)
	var/list/data = list()
	data["packs"] = list()
	for(var/pack_id in SSshuttle.supply_packs)
		var/datum/supply_pack/P = SSshuttle.supply_packs[pack_id]
		if(P.order_flags & (ORDER_INVISIBLE | ORDER_EMAG_ONLY))
			continue
		data["packs"] += list(list(
			"id" = pack_id,
			"name" = P.name,
			"cost" = P.get_cost(),
			"desc" = P.desc
		))
	data["cart"] = list() // local cart for this PC
	return data

/datum/pc_program/supply/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	switch(action)
		if("order")
			var/pack = SSshuttle.supply_packs[text2path(params["id"])]
			if(!pack)
				return FALSE
			var/datum/supply_order/order = new(pack, computer.login_name, "PC Operator", null, "Long-range PC order")
			SSshuttle.request_list += order
			return TRUE
	return FALSE
