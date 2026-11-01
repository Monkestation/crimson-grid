/obj/structure/retail/commodity
	name = "commodity dealer"
	desc = "A counter that sells precious materials at the day's market price."
	take_area_name = FALSE
	/// Multiplier on the market price. 1 = sells at spot, 1.1 = 10% over.
	var/markup = 1

/obj/structure/retail/commodity/Initialize(mapload)
	. = ..()
	SScommodities.tills += src

/obj/structure/retail/commodity/Destroy()
	SScommodities.tills -= src
	return ..()

/// Replaces the stock-list build: products come from the commodity list, not product_types.
/obj/structure/retail/commodity/build_inventory()
	build_commodity_products()

/// SScommodities may not have initialised when this machine does (mapload), so this can run
/// again later from refresh_prices().
/obj/structure/retail/commodity/proc/build_commodity_products()
	for(var/datum/commodity/C as anything in SScommodities.commodities)
		if(C.is_bond || !C.item_type)
			continue
		var/datum/data/vending_product/product = new /datum/data/vending_product(path = C.item_type)
		product.name = C.name
		product.amount = -1 // unlimited
		product.price = max(1, round(C.price * markup))
		products_list += product

/obj/structure/retail/commodity/proc/refresh_prices(push = TRUE)
	if(!length(products_list))
		build_commodity_products()
		if(push && length(products_list))
			update_static_data_for_all_viewers()
		return
	var/changed = FALSE
	for(var/datum/data/vending_product/product as anything in products_list)
		var/datum/commodity/C = SScommodities.commodity_by_item[product.product_path]
		if(!C)
			continue
		var/new_price = max(1, round(C.price * markup))
		if(product.price != new_price)
			product.price = new_price
			changed = TRUE
	if(changed && push)
		update_static_data_for_all_viewers()

/obj/structure/retail/commodity/ui_act(action, params)
	// A purchase must charge the price at the moment of the click, not the last pushed one.
	refresh_prices(FALSE)
	return ..()
