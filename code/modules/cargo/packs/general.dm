/datum/supply_pack/misc
	group = "Стандартные поставки"

/datum/supply_pack/misc/artsupply
	name = "Набор художника"
	desc = "Устройте несколько маленьких счастливых случаев с помощью трех аэрозольных баллончиков и множества цветных карандашей!"
	cost = CARGO_CRATE_VALUE * 1.8
	contains = list(// /obj/item/rcl, // CORVAX EDIT
					/obj/item/storage/toolbox/artistic,
					/obj/item/storage/toolbox/crafter,
					/obj/item/toy/crayon/spraycan = 3,
					/obj/item/storage/crayons,
					/obj/item/toy/crayon/white,
					/obj/item/toy/crayon/rainbow,
				)
	crate_name = "набор художника"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/misc/tattoo_kit
	name = "Набор тату-мастера"
	desc = "Набор для татуировки с дополнительными начальными чернилами."
	cost = CARGO_CRATE_VALUE * 1.8
	contains = list(
		/obj/item/tattoo_kit,
		/obj/item/toner = 2)
	crate_name = "набор тату-мастера"
	crate_type = /obj/structure/closet/crate/wooden
	// discountable = SUPPLY_PACK_STD_DISCOUNTABLE // CORVAX EDIT

/* CORVAX EDIT REMOVAL
/datum/supply_pack/misc/bicycle
	name = "Bicycle"
	desc = "Nanotrasen reminds all employees to never toy with powers outside their control."
	cost = 1000000 //Special case, we don't want to make this in terms of crates because having bikes be a million credits is the whole meme.
	contains = list(/obj/vehicle/ridden/bicycle)
	crate_name = "bicycle crate"
	crate_type = /obj/structure/closet/crate/large
	discountable = SUPPLY_PACK_RARE_DISCOUNTABLE

/datum/supply_pack/misc/bigband
	name = "Big Band Instrument Collection"
	desc = "Get your sad station movin' and groovin' with this fine collection! \
		Contains nine different instruments!"
	cost = CARGO_CRATE_VALUE * 10
	crate_name = "Big band musical instruments collection"
	contains = list(/obj/item/instrument/violin,
					/obj/item/instrument/guitar,
					/obj/item/instrument/glockenspiel,
					/obj/item/instrument/accordion,
					/obj/item/instrument/saxophone,
					/obj/item/instrument/trombone,
					/obj/item/instrument/recorder,
					/obj/item/instrument/harmonica,
					/obj/structure/musician/piano/unanchored,
				)
	crate_type = /obj/structure/closet/crate/wooden
*/

/datum/supply_pack/misc/book_crate
	name = "Набор книг"
	desc = "Эти семь книг, точно не затерявшихся где-то на складе, несомненно, будут полезны для чтения."
	cost = CARGO_CRATE_VALUE * 3
	access_view = ACCESS_LIBRARY
	contains = list(/obj/item/book/codex_gigas,
					/obj/item/book/manual/random = 3,
					/obj/item/book/random = 3,
				)
	crate_type = /obj/structure/closet/crate/wooden

/* // DARKPACK EDIT REMOVAL
/datum/supply_pack/misc/commandkeys
	name = "Command Encryption Key Crate"
	desc = "A pack of encryption keys that give access to the command radio network. \
		Nanotrasen reminds unauthorized employees not to eavesdrop in on secure communications channels, \
		or at least to keep heckling of the command staff to a minimum."
	access_view = ACCESS_COMMAND
	access = ACCESS_COMMAND
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/encryptionkey/headset_com = 3)
	crate_type = /obj/structure/closet/crate/secure/centcom
	crate_name = "command encryption key crate"

/datum/supply_pack/misc/exploration_drone
	name = "Exploration Drone"
	desc = "A replacement long-range exploration drone."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/exodrone)
	crate_name = "exodrone crate"

/datum/supply_pack/misc/exploration_fuel
	name = "Drone Fuel Pellet"
	desc = "A fresh tank of exploration drone fuel."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/fuel_pellet)
	crate_name = "exodrone fuel crate"
*/

/datum/supply_pack/misc/paper
	name = "Бюрократический набор"
	desc = "Большие стопки бумаг на вашем столе - большая проблема, поэтому сделайте их \
		размером с горошину с помощью этих канцелярских принадлежностей! Содержит шесть \
		ручек, немного фотопленки, принадлежности для ручной наклеивания этикеток, ящик для \
		бумаги, копировальную бумагу, три папки, лазерную указку, два блокнота и две марки."
	cost = CARGO_CRATE_VALUE * 3.2
	contains = list(/obj/structure/filingcabinet/chestdrawer/wheeled,
					/obj/item/camera_film,
					/obj/item/hand_labeler,
					/obj/item/hand_labeler_refill = 2,
					/obj/item/paper_bin,
					/obj/item/paper_bin/carbon,
					/obj/item/pen/fourcolor = 2,
					/obj/item/pen,
					/obj/item/pen/fountain,
					/obj/item/pen/blue,
					/obj/item/pen/red,
					/obj/item/folder/blue,
					/obj/item/folder/red,
					/obj/item/folder/yellow,
					/obj/item/clipboard = 2,
					/obj/item/storage/box/stamps,
					/obj/item/laser_pointer/purple,
				)
	crate_name = "бюрократический набор"

/datum/supply_pack/misc/fountainpens
	name = "Ящик для каллиграфии"
	desc = "Стильно подписывайте смертные приговоры с помощью этих семи перьевых ручек."
	cost = CARGO_CRATE_VALUE * 1.45
	contains = list(/obj/item/storage/box/fountainpens)
	crate_type = /obj/structure/closet/crate/wooden
	crate_name = "ящик для каллиграфии"

/* CORVAX EDIT REMOVAL
/datum/supply_pack/misc/wrapping_paper
	name = "Festive Wrapping Paper Crate"
	desc = "Want to mail your loved ones gift-wrapped chocolates, stuffed animals, the Clown's severed head? \
		You can do all that, with this crate full of wrapping paper."
	cost = CARGO_CRATE_VALUE * 1.8
	contains = list(/obj/item/stack/wrapping_paper)
	crate_type = /obj/structure/closet/crate/wooden
	crate_name = "festive wrapping paper crate"


/datum/supply_pack/misc/funeral
	name = "Funeral Supplies Crate"
	desc = "At the end of the day, someone's gonna want someone dead. Give them a proper send-off with these \
		funeral supplies! Contains a coffin with burial garments and flowers."
	cost = CARGO_CRATE_VALUE * 1.6
	access_view = ACCESS_CHAPEL_OFFICE
	contains = list(/obj/item/clothing/under/misc/burial,
					/obj/item/food/grown/flower/harebell,
					/obj/item/food/grown/flower/poppy/geranium,
				)
	crate_name = "coffin"
	crate_type = /obj/structure/closet/crate/coffin
*/

/* // DARKPACK EDIT REMOVAL
/datum/supply_pack/misc/empty
	name = "Empty Supplypod"
	desc = "Presenting the New Nanotrasen-Brand Bluespace Supplypod! Transport cargo with grace and ease! \
		Call today and we'll shoot over a demo unit for just 300 credits!"
	cost = CARGO_CRATE_VALUE * 0.6 //Empty pod, so no crate refund
	contains = list()
	order_flags = ORDER_POD_ONLY
	crate_type = null
	special_pod = /obj/structure/closet/supplypod/bluespacepod

/datum/supply_pack/misc/empty/generate(atom/A, datum/bank_account/paying_account, crate_override)
	return
*/

/* CORVAX EDIT REMOVAL
/datum/supply_pack/misc/religious_supplies
	name = "Religious Supplies Crate"
	desc = "Keep your local chaplain happy and well-supplied, lest they call down judgement upon your \
		cargo bay. Contains two bottles of holy water, bibles, chaplain robes, and burial garments."
	cost = CARGO_CRATE_VALUE * 6 // it costs so much because the Space Church needs funding to build a cathedral
	access_view = ACCESS_CHAPEL_OFFICE
	contains = list(/obj/item/reagent_containers/cup/glass/bottle/holywater = 2,
					/obj/item/book/bible/booze = 2,
					/obj/item/clothing/suit/hooded/chaplain_hoodie = 2,
					/obj/item/clothing/under/misc/burial = 2,
				)
	crate_name = "religious supplies crate"
*/

/datum/supply_pack/misc/candles_bulk
	name = "Набор свечей"
	desc = "Небольшой набор из трёх стандартных пачек красных восковых свечей."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/storage/fancy/candle_box = 3)
	crate_name = "candle box crate"

/datum/supply_pack/misc/toner
	name = "Ящик с тонерами"
	desc = "Потратили слишком много чернил на печать фотографий задниц? \
		Не волнуйтесь, с этими шестью заправками тонера вы будете печатать \
		задницы, пока не наступит утро!"
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/toner = 6)
	crate_name = "ящик с тонерами"

/datum/supply_pack/misc/toner_large
	name = "Ящик с тонерами (Большой)"
	desc = "Устали от замены картриджей с тонером? В этих шести картриджах \
		для заправки в особо тяжелых условиях содержится примерно в пять раз \
		больше тонера, чем в базовой модели!"
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/obj/item/toner/large = 6)
	crate_name = "большой ящик с тонерами"

/* CORVAX EDIT REMOVAL
/datum/supply_pack/misc/training_toolbox
	name = "Training Toolbox Crate"
	desc = "Hone your combat abiltities with two AURUMILL-Brand Training Toolboxes! \
		Guarenteed to count hits made against living beings!"
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/training_toolbox = 2)
	crate_name = "training toolbox crate"
*/

///Special supply crate that generates random syndicate gear up to a determined TC value
/datum/supply_pack/misc/syndicate
	name = "Assorted Syndicate Gear"
	desc = "Contains a random assortment of syndicate gear."
	order_flags = ORDER_SPECIAL //Cannot be ordered via cargo
	contains = list()
	crate_name = "syndicate gear crate"
	crate_type = /obj/structure/closet/crate
	test_ignored = TRUE
	///Total TC worth of contained uplink items
	var/crate_value = 30
	///What uplink the contents are pulled from
	var/contents_uplink_type = UPLINK_TRAITORS

///Generate assorted uplink items, taking into account the same surplus modifiers used for surplus crates
/datum/supply_pack/misc/syndicate/fill(obj/container)
	var/list/uplink_items = list()
	for(var/datum/uplink_item/item as anything in SStraitor.uplink_items)
		if(item.purchasable_from & contents_uplink_type && item.item)
			uplink_items += item

	while(crate_value)
		var/datum/uplink_item/uplink_item = pick(uplink_items)
		if(!uplink_item.surplus || prob(100 - uplink_item.surplus))
			continue
		if(length(uplink_item.restricted_roles) || length(uplink_item.restricted_species))
			continue
		if(crate_value < uplink_item.cost)
			continue
		crate_value -= uplink_item.cost
		new uplink_item.item(container)

///Syndicate supply crate that can have its contents value changed by admins, uses a seperate datum to avoid having admins touch the original one.
/datum/supply_pack/misc/syndicate/custom_value

/datum/supply_pack/misc/syndicate/custom_value/proc/setup_contents(value, uplink)
	crate_value = value
	contents_uplink_type = uplink

/datum/supply_pack/misc/papercutter
	name = "Ящик с резчиком бумаги"
	desc = "Содержит 3 канцелярских ножа для резки бумаги, оснащенных острыми лезвиями, которые позволяют разрезать любую бумагу на две тонкие полоски. \
		В комплекте есть одно сменное лезвие."
	cost = CARGO_CRATE_VALUE * 3.5
	contains = list(
		/obj/item/papercutter = 3,
		/obj/item/hatchet/cutterblade = 1,
	)
	crate_name = "ящик с резчиком бумаги"

/datum/supply_pack/misc/water_cooler
	name = "Кулер с водой"
	desc = "Кулер для жидкости, наполненный самой свежей водой из всех периферийных устройств. Идеально подходит для того, чтобы тратить время в офисе!"
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/structure/reagent_dispensers/water_cooler/jugless = 1, /obj/item/reagent_containers/cooler_jug/water = 1)
	crate_name = "water cooler crate"

/datum/supply_pack/misc/punch_cooler
	name = "Кулер с фруктовым пуншом"
	desc = "Кулер для жидкости, наполненный экзотическим фруктовым пуншем, который может залечить травмы! Обязательно оставайтесь рядом с кулером во время питья, для вашего же здоровья и безопасности. Серьезно, не пейте этот напиток вдали от кулера."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/obj/structure/reagent_dispensers/water_cooler/jugless = 1, /obj/item/reagent_containers/cooler_jug/punch = 1)
	crate_name = "punch cooler crate"
