/obj/structure/retail
	network_id = PC_NETWORK_OFFLINE
	var/closed = FALSE // set through network automation
	var/sales = 0
	var/revenue = 0

/obj/structure/retail/get_pc_triggers()
	return list(
		"purchase" = list(AUTOMATION_NAME = "Item purchased", AUTOMATION_DESC = "Carries the item name and price.", AUTOMATION_SIGNAL = COMSIG_RETAIL_PURCHASE, AUTOMATION_PAYLOAD = list("item", "price"), AUTOMATION_MIN_ROLE = PC_NETWORK_USER),
		"sold_out" = list(AUTOMATION_NAME = "Item sold out", AUTOMATION_DESC = "Fires when the last unit of an item is bought.", AUTOMATION_SIGNAL = COMSIG_RETAIL_SOLD_OUT, AUTOMATION_PAYLOAD = list("item"), AUTOMATION_MIN_ROLE = PC_NETWORK_USER),
	)

/obj/structure/retail/get_pc_actions()
	return list(
		"close" = list(AUTOMATION_NAME = "Close shop", AUTOMATION_DESC = "Stops all sales.", AUTOMATION_CALLBACK = CALLBACK(src, PROC_REF(pc_set_closed), TRUE), AUTOMATION_MIN_ROLE = PC_NETWORK_ADMIN, AUTOMATION_ALLOW_AUTOMATE = TRUE),
		"open" = list(AUTOMATION_NAME = "Open shop", AUTOMATION_DESC = "Resumes sales.", AUTOMATION_CALLBACK = CALLBACK(src, PROC_REF(pc_set_closed), FALSE), AUTOMATION_MIN_ROLE = PC_NETWORK_ADMIN, AUTOMATION_ALLOW_AUTOMATE = TRUE),
	)

/obj/structure/retail/get_pc_variables()
	return list(
		"stock" = list(AUTOMATION_NAME = "Units in stock", AUTOMATION_DESC = "Total counted stock. Unlimited items aren't counted.", AUTOMATION_CALLBACK = CALLBACK(src, PROC_REF(pc_stock)), AUTOMATION_MIN_ROLE = PC_NETWORK_USER),
		"sold_out" = list(AUTOMATION_NAME = "Items sold out", AUTOMATION_DESC = "How many product lines are at zero.", AUTOMATION_CALLBACK = CALLBACK(src, PROC_REF(pc_sold_out)), AUTOMATION_MIN_ROLE = PC_NETWORK_USER),
		"sales" = list(AUTOMATION_NAME = "Sales made", AUTOMATION_DESC = "Purchases since round start.", AUTOMATION_CALLBACK = CALLBACK(src, PROC_REF(pc_sales)), AUTOMATION_MIN_ROLE = PC_NETWORK_USER),
		"revenue" = list(AUTOMATION_NAME = "Revenue", AUTOMATION_DESC = "Money taken since round start.", AUTOMATION_CALLBACK = CALLBACK(src, PROC_REF(pc_revenue)), AUTOMATION_MIN_ROLE = PC_NETWORK_ADMIN),
		"teller" = list(AUTOMATION_NAME = "Teller present", AUTOMATION_DESC = "1 if a conscious teller is nearby.", AUTOMATION_CALLBACK = CALLBACK(src, PROC_REF(pc_teller)), AUTOMATION_MIN_ROLE = PC_NETWORK_USER),
	)

/obj/structure/retail/proc/pc_stock()
	var/total = 0
	for(var/datum/data/vending_product/product in products_list)
		if(product.amount > 0)
			total += product.amount
	return total
/obj/structure/retail/proc/pc_sold_out()
	var/total = 0
	for(var/datum/data/vending_product/product in products_list)
		if(product.amount == 0)
			total++
	return total

/obj/structure/retail/proc/pc_sales()
	return sales

/obj/structure/retail/proc/pc_revenue()
	return revenue

/obj/structure/retail/proc/pc_teller()
	return (my_owner && get_dist(src, my_owner) <= 4 && my_owner.stat < HARD_CRIT) ? 1 : 0

/obj/structure/retail/proc/pc_set_closed(new_state, datum/bank_account/account, mob/user)
	closed = new_state
	return TRUE
