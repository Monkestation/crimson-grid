/datum/data/vending_product/New(name, path, price, amount = -1)
	src.name = name
	src.product_path = path
	src.price = price
	src.amount = amount

	var/obj/item/item = product_path
	if(!item)
		CRASH("Retail product equipment path of [product_path] is not a valid path!")

	if(!name)
		src.name = item::name

	if(!price)
		src.price = item.custom_price || item.custom_premium_price
