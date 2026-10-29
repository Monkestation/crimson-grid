/obj/effect/mapping_helpers/limited_vending_stock
	name = "Limited Vending Stock Injector"
	icon_state = "trait"

/obj/effect/mapping_helpers/limited_vending_stock/LateInitialize()
	var/turf/target_turf = get_turf(src)
	for(var/obj/machinery/vending/vendor_on_turf in target_turf.get_all_contents())
		for(var/datum/data/vending_product/product_record as anything in vendor_on_turf.product_records + vendor_on_turf.coin_records + vendor_on_turf.hidden_records)
			product_record.amount = rand(CEILING(product_record.amount * 0.5, 1), product_record.amount)
			product_record.credits_contained += rand(1, 5)
	qdel(src)
