/datum/supply_pack/service
	group = "Обслуживание"

/datum/supply_pack/service/cargo_supples
	name = "Ящик складских принадлежностей"
	desc = "Распродали всё, что не было прикручено? Вернитесь к работе с этим ящиком: штампы, сканер экспорта, маркировщик пункта назначения, ручной этикетировщик и упаковочная плёнка."
	cost = CARGO_CRATE_VALUE * 1.75
	contains = list(/obj/item/stamp/granted,
					/obj/item/stamp/denied,
					/obj/item/universal_scanner,
					// /obj/item/dest_tagger, // CORVAX EDIT
					/obj/item/hand_labeler,
					/obj/item/stack/package_wrap,
				)
	crate_name = "ящик складских принадлежностей"

/datum/supply_pack/service/noslipfloor
	name = "Противоксольные напольные плитки"
	desc = "Забудьте о скольжении с тридцатью промышленными противоскользящими плитками!"
	cost = CARGO_CRATE_VALUE * 4
	access_view = ACCESS_JANITOR
	contains = list(/obj/item/stack/tile/noslip/thirty)
	crate_name = "ящик противоскользящих плиток"
	order_flags = ORDER_INVISIBLE // CORVAX EDIT ADD

/datum/supply_pack/service/janitor
	name = "Ящик уборочного инвентаря"
	desc = "Дайте отпор грязи и жиру! Содержит три ведра, знаки осторожности, швабру, метлу, чистящий спрей, тряпку и мешок для мусора."
	cost = CARGO_CRATE_VALUE * 2
	access_view = ACCESS_JANITOR
	contains = list(/obj/item/reagent_containers/cup/bucket = 3,
					/obj/item/mop,
					/obj/item/pushbroom,
					/obj/item/clothing/suit/caution = 3,
					/obj/item/storage/bag/trash,
					/obj/item/reagent_containers/spray/cleaner,
					/obj/item/rag,
					// /obj/item/grenade/chem_grenade/cleaner = 3, // CORVAX EDIT REMOVAL
				)
	crate_name = "ящик уборочного инвентаря"

/datum/supply_pack/service/janitor/janicart
	name = "Уборочная тележка"
	desc = "Основа любого успешного уборщика. Уборочная тележка."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/structure/mop_bucket/janitorialcart,
					// /obj/item/clothing/shoes/galoshes, // CORVAX EDIT
				)
	crate_name = "ящик с уборочной тележкой"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/service/janitor/janitank
	name = "Ранцевый бак уборщика"
	desc = "Призовите божественное правосудие над грязью с этим высокоёмким ранцевым баком. Содержит 500 единиц чистящего средства для города."
	cost = CARGO_CRATE_VALUE * 2
	access = ACCESS_JANITOR
	contains = list(/obj/item/watertank/janitor)
	crate_name = "ящик с ранцевым баком уборщика"
	crate_type = /obj/structure/closet/crate/secure
	order_flags = ORDER_INVISIBLE // CORVAX EDIT ADD

/* // DARKPACK EDIT REMOVAL
/datum/supply_pack/service/mule
	name = "MULEbot Crate"
	desc = "Pink-haired Quartermaster not doing her job? Replace her with this tireless worker, today! \
		Contains one MULEbot."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/mob/living/basic/bot/mulebot)
	crate_name = "\improper MULEbot Crate"
	crate_type = /obj/structure/closet/crate/large
*/

/datum/supply_pack/service/party
	name = "Набор для вечеринки"
	desc = "Отметьте и жизнь, и смерть с этим набором! Содержит семь цветных светящихся палочек, шесть бутылок пива, шесть банок газировки, два эля, бутылку текилы, бутылку Goldschläger и шейкер."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/storage/box/drinkingglasses,
					/obj/item/reagent_containers/cup/glass/shaker,
					/obj/item/reagent_containers/cup/glass/bottle/patron,
					/obj/item/reagent_containers/cup/glass/bottle/goldschlager,
					/obj/item/reagent_containers/cup/glass/bottle/ale = 2,
					/obj/item/storage/cans/sixbeer,
					/obj/item/storage/cans/sixsoda,
					/obj/item/flashlight/glowstick,
					/obj/item/flashlight/glowstick/red,
					/obj/item/flashlight/glowstick/blue,
					/obj/item/flashlight/glowstick/cyan,
					/obj/item/flashlight/glowstick/orange,
					/obj/item/flashlight/glowstick/yellow,
					/obj/item/flashlight/glowstick/pink,
				)
	crate_name = "ящик с набором для вечеринки"

/datum/supply_pack/service/carpet
	name = "Премиальный ковёр"
	desc = "Металлические плитки на полу действуют на нервы? Эти стопки мягкого ковра объединят любую комнату. Содержит по 100 плиток обычного и чёрного ковра."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/stack/tile/carpet/fifty = 2,
					/obj/item/stack/tile/carpet/black/fifty = 2)
	crate_name = "ящик с премиальным ковром"
	discountable = SUPPLY_PACK_UNCOMMON_DISCOUNTABLE

/datum/supply_pack/service/carpet_exotic
	name = "Экзотический ковёр"
	desc = "Экзотические ковры со склада распродажи, для всех ваших декораторских нужд. Содержит по 100 плиток восьми разных расцветок."
	cost = CARGO_CRATE_VALUE * 8
	contains = list(/obj/item/stack/tile/carpet/blue/fifty = 2,
					/obj/item/stack/tile/carpet/cyan/fifty = 2,
					/obj/item/stack/tile/carpet/green/fifty = 2,
					/obj/item/stack/tile/carpet/orange/fifty = 2,
					/obj/item/stack/tile/carpet/purple/fifty = 2,
					/obj/item/stack/tile/carpet/red/fifty = 2,
					/obj/item/stack/tile/carpet/royalblue/fifty = 2,
					/obj/item/stack/tile/carpet/royalblack/fifty = 2,
				)
	crate_name = "ящик с экзотическим ковром"
	discountable = SUPPLY_PACK_UNCOMMON_DISCOUNTABLE

/datum/supply_pack/service/carpet_neon
	name = "Простой неоновый ковёр"
	desc = "Простые резиновые коврики с фосфоресцирующей кромкой. Содержит по 120 плиток тринадцати цветов. Ограниченная серия."
	cost = CARGO_CRATE_VALUE * 15
	contains = list(/obj/item/stack/tile/carpet/neon/simple/white/sixty = 2,
					/obj/item/stack/tile/carpet/neon/simple/black/sixty = 2,
					/obj/item/stack/tile/carpet/neon/simple/red/sixty = 2,
					/obj/item/stack/tile/carpet/neon/simple/orange/sixty = 2,
					/obj/item/stack/tile/carpet/neon/simple/yellow/sixty =2,
					/obj/item/stack/tile/carpet/neon/simple/lime/sixty = 2,
					/obj/item/stack/tile/carpet/neon/simple/green/sixty = 2,
					/obj/item/stack/tile/carpet/neon/simple/teal/sixty = 2,
					/obj/item/stack/tile/carpet/neon/simple/cyan/sixty = 2,
					/obj/item/stack/tile/carpet/neon/simple/blue/sixty = 2,
					/obj/item/stack/tile/carpet/neon/simple/purple/sixty = 2,
					/obj/item/stack/tile/carpet/neon/simple/violet/sixty = 2,
					/obj/item/stack/tile/carpet/neon/simple/pink/sixty = 2,
				)
	crate_name = "ящик с неоновым ковром"
	discountable = SUPPLY_PACK_UNCOMMON_DISCOUNTABLE

/datum/supply_pack/service/lightbulbs
	name = "Сменные лампы"
	desc = "Да будет свет! Содержит сорок две люминесцентные трубки и двадцать одну лампу накаливания."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/storage/box/lights/mixed = 3)
	crate_name = "ящик со сменными лампами"

/* // DARKPACK EDIT REMOVAL
/datum/supply_pack/service/minerkit
	name = "Shaft Miner Starter Kit"
	desc = "All the miners died too fast? Assistant wants to get a taste of life off-station? \
		Either way, this kit is the best way to turn a regular crewman into an ore-producing, \
		monster-slaying machine. Contains meson goggles, a pickaxe, advanced mining scanner, \
		cargo headset, ore bag, gasmask, an explorer suit and a miner ID upgrade."
	cost = CARGO_CRATE_VALUE * 4
	access = ACCESS_QM
	access_view = ACCESS_MINING_STATION
	contains = list(/obj/item/storage/backpack/duffelbag/mining_conscript)
	crate_name = "shaft miner starter kit"
	crate_type = /obj/structure/closet/crate/secure/cargo/mining

/datum/supply_pack/service/survivalknives
	name = "Survival Knives Crate"
	desc = "Contains three sharpened survival knives. Each knife guaranteed to fit snugly \
		inside any Nanotrasen-standard boot."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/knife/combat/survival = 3)
	crate_name = "survival knife crate"
	crate_type = /obj/structure/closet/crate/cargo/mining
*/

/datum/supply_pack/service/wedding
	name = "Свадебный набор"
	desc = "Всё для свадьбы! Осталось найти ведущего. Содержит свадебное платье, смокинг, камербанд, фату, три букета и бутылку шампанского."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/clothing/under/dress/wedding_dress,
					/obj/item/clothing/under/suit/tuxedo,
					/obj/item/storage/belt/fannypack/cummerbund,
					/obj/item/clothing/head/costume/weddingveil,
					/obj/item/bouquet,
					/obj/item/bouquet/sunflower,
					/obj/item/bouquet/poppy,
					/obj/item/reagent_containers/cup/glass/bottle/champagne,
				)
	crate_name = "свадебный ящик"

/* // DARKPACK EDIT REMOVAL
/// Box of 7 grey IDs.
/datum/supply_pack/service/greyidbox
	name = "Grey ID Card Multipack Crate"
	desc = "A convenient crate containing a box of seven cheap ID cards in a handy wallet-sized form factor. \
		Cards come in every colour you can imagine, as long as it's grey."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/storage/box/ids)
	crate_name = "basic id card crate"

/// Single silver ID.
/datum/supply_pack/service/silverid
	name = "Silver ID Card Crate"
	desc = "Did we forget to hire any Heads of Staff? Recruit your own with this high value ID card \
		capable of holding advanced levels of access in a handy wallet-sized form factor."
	cost = CARGO_CRATE_VALUE * 7
	contains = list(/obj/item/card/id/advanced/silver)
	crate_name = "silver id card crate"
*/

/datum/supply_pack/service/emptycrate
	name = "Пустой ящик"
	desc = "Пустой ящик для всех ваших нужд хранения."
	cost = CARGO_CRATE_VALUE * 1.4
	contains = list()
	crate_name = "ящик"

/datum/supply_pack/service/randomized/donkpockets
	name = "Donk Pocket Variety Crate"
	desc = "Featuring a line up of Donk Co.'s most popular pastry! Contains \
		a random assortment of Donk Pocket boxes."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/storage/box/donkpockets/donkpocketspicy,
					/obj/item/storage/box/donkpockets/donkpocketteriyaki,
					/obj/item/storage/box/donkpockets/donkpocketpizza,
					/obj/item/storage/box/donkpockets/donkpocketberry,
					/obj/item/storage/box/donkpockets/donkpockethonk,
				)
	crate_name = "donk pocket crate"
	crate_type = /obj/structure/closet/crate/freezer/food
	order_flags = ORDER_INVISIBLE // CORVAX EDIT ADD

/datum/supply_pack/service/randomized/donkpockets/fill(obj/container)
	for(var/i in 1 to 3)
		var/item = pick(contains)
		new item(container)

/datum/supply_pack/service/randomized/ready_donk
	name = "Ready-Donk Variety Crate"
	desc = "Featuring a line up of Donk Co.'s fan-favourite microwave meal! Contains \
		a random assortment of Ready Donk products."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/food/ready_donk,
					/obj/item/food/ready_donk/mac_n_cheese,
					/obj/item/food/ready_donk/donkhiladas,
					/obj/item/food/ready_donk/nachos_grandes,
					/obj/item/food/ready_donk/donkrange_chicken,
					/obj/item/food/ready_donk/salisbury_steak,
					/obj/item/food/ready_donk/country_chicken,
				)
	crate_name = "\improper Ready-Donk crate"
	crate_type = /obj/structure/closet/crate/freezer/donk
	discountable = SUPPLY_PACK_UNCOMMON_DISCOUNTABLE
	order_flags = ORDER_INVISIBLE // CORVAX EDIT ADD

/datum/supply_pack/service/randomized/ready_donk/fill(obj/container)
	for(var/i in 1 to 3)
		var/item = pick(contains)
		new item(container)

/datum/supply_pack/service/coffeekit
	name = "Набор для кофе"
	desc = "Полный набор для обустройства уютной кофейни. Кофемашина по какой-то причине не входит."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(
		/obj/item/storage/box/coffeepack/robusta,
		/obj/item/storage/box/coffeepack,
		/obj/item/reagent_containers/cup/coffeepot,
		/obj/item/storage/fancy/coffee_condi_display,
		/obj/item/reagent_containers/cup/glass/bottle/juice/cream,
		/obj/item/reagent_containers/condiment/milk,
		/obj/item/reagent_containers/condiment/soymilk,
		/obj/item/reagent_containers/condiment/sugar,
		/obj/item/reagent_containers/cup/bottle/syrup_bottle/caramel,
	)
	crate_name = "ящик с набором для кофе"
	crate_type = /obj/structure/closet/crate/robust
	discountable = SUPPLY_PACK_UNCOMMON_DISCOUNTABLE

/datum/supply_pack/service/coffeemaker
	name = "Кофемашина Impressa"
	desc = "Кофемашина модели Impressa."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/machinery/coffeemaker/impressa)
	crate_name = "ящик с кофемашиной"
	crate_type = /obj/structure/closet/crate/large
	discountable = SUPPLY_PACK_UNCOMMON_DISCOUNTABLE

/* // DARKPACK EDIT REMOVAL
/// Spare bar sign wallmount
/datum/supply_pack/service/bar_sign
	name = "Bar Sign Replacement Kit"
	desc = "A replacement bar sign, perfect for drawing in customers to your bar, tavern, inn, nightclub, or even coffeehouse!"
	cost = CARGO_CRATE_VALUE * 14
	contains = list(/obj/item/wallframe/barsign/all_access)
	crate_name = "bar sign crate"
	discountable = SUPPLY_PACK_RARE_DISCOUNTABLE
*/

/datum/supply_pack/service/bowmaking
	name = "Набор для изготовления луков и стрел"
	desc = "Несколько устаревший экземпляр «Вырежи мне это: флетчинг для современного горожанина» и немного материалов. Для тех, кто хочет заняться изготовлением луков или придать своему LARP'у остроты. Также содержит инструкции по изготовлению скрипок."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(
		/obj/item/book/granter/crafting_recipe/fletching = 1,
		/obj/item/stack/sheet/mineral/wood = 10,
		/obj/item/stack/sheet/cloth = 10,
	)
	crate_name = "ящик с набором для изготовления луков"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/service/mousetraps
	name = "Мышеловки Pest-B-Gon"
	desc = "Три коробки удобных пружинных мышеловок для ловли грызунов. Держите подальше от детей!"
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/storage/box/mousetraps = 3)
	crate_name = "ящик с мышеловками"

/datum/supply_pack/service/boombox
	name = "Бумбокс с кассетой"
	desc = "Бумбокс высшего класса от местного производителя. Может проигрывать кассеты для вас и ваших коллег. В комплекте демонстрационная кассета."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(
		/obj/item/boombox = 1,
		/obj/item/music_tape = 1,
	)
	crate_name = "ящик с бумбоксом"
