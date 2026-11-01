/datum/pc_program/commodities
	name = "Commodity Desk"
	icon_state = "gem"
	tgui_id = "PcCommodities"

/datum/pc_program/commodities/ui_data(mob/user)
	var/list/data = list()
	var/list/list_out = list()
	for(var/datum/commodity/C as anything in SScommodities.commodities)
		list_out += list(list(
			"ticker" = C.ticker,
			"name" = C.name,
			"desc" = C.desc,
			"kind" = C.is_bond ? "Bond" : "Commodity",
			"price" = C.price,
			"last_price" = C.last_price,
			"coupon" = C.coupon,
			"history" = C.history.Copy(),
		))
	data["commodities"] = list_out
	return data
