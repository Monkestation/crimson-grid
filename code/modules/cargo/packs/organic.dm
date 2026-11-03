/datum/supply_pack/organic
	group = "Гидропоника"
	crate_type = /obj/structure/closet/crate/freezer

/datum/supply_pack/organic/hydroponics
	access_view = ACCESS_HYDROPONICS
	crate_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/organic/hydroponics/beekeeping_suits
	name = "Набор пчеловода"
	desc = "Пчелиный бизнес процветает? Тогда запаситесь двумя комплектами пчеловодной защиты с подходящими головными уборами."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/clothing/head/utility/beekeeper_head = 2,
					/obj/item/clothing/suit/utility/beekeeper_suit = 2,
				)
	crate_name = "набор пчеловода"
	crate_type = /obj/structure/closet/crate/hydroponics

/* // DARKPACK EDIT REMOVAL - (Removing Monkey Cubes and Bees)
/datum/supply_pack/organic/hydroponics/beekeeping_fullkit
	name = "Beekeeping Starter Crate"
	desc = "BEES BEES BEES. Contains three honey frames, a beekeeper suit and helmet, \
		flyswatter, bee house, and, of course, a pure-bred Nanotrasen-Standardized Queen Bee!"
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/structure/beebox/unwrenched,
					/obj/item/honey_frame = 3,
					/obj/item/queen_bee/bought,
					/obj/item/clothing/head/utility/beekeeper_head,
					/obj/item/clothing/suit/utility/beekeeper_suit,
					/obj/item/melee/flyswatter,
				)
	crate_name = "beekeeping starter crate"
	crate_type = /obj/structure/closet/crate/hydroponics
*/

/datum/supply_pack/organic/randomized
	test_ignored = TRUE
	crate_name = "ящик еды"

/datum/supply_pack/organic/randomized/fill(obj/container)
	for(var/i in 1 to 15)
		var/item = pick(contains)
		new item(container)

/datum/supply_pack/organic/randomized/chef
	name = "Ящик отборного мяса"
	desc = "Лучшие отрубы в Сан-Франциско. Содержит случайный набор экзотического мяса для тех, кто не боится экспериментировать."
	cost = CARGO_CRATE_VALUE * 4
	order_flags = ORDER_INVISIBLE // CORVAX EDIT ADD
	contains = list(
		/obj/item/food/meat/slab/human/mutant/slime,
		/obj/item/food/meat/slab/killertomato,
		/obj/item/food/meat/slab/bear,
		/obj/item/food/meat/slab/xeno,
		/obj/item/food/meat/slab/spider,
		/obj/item/food/meat/rawbacon,
		/obj/item/food/meat/slab/penguin,
		/obj/item/food/spiderleg,
		/obj/item/food/fishmeat/carp,
		/obj/item/food/meat/slab/human,
		/obj/item/food/meat/slab/grassfed,
	)

/datum/supply_pack/organic/randomized/fruits
	name = "Ящик фруктов"
	desc = "Богато витаминами. Содержит лайм, апельсин, арбуз, яблоко, ягоды и лимон."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(
		/obj/item/food/grown/citrus/lime,
		/obj/item/food/grown/citrus/orange,
		/obj/item/food/grown/melonlike/watermelon,
		/obj/item/food/grown/apple,
		/obj/item/food/grown/berries,
		/obj/item/food/grown/citrus/lemon,
	)

/datum/supply_pack/organic/randomized/vegetables
	name = "Ящик овощей"
	desc = "Выращено в теплицах. Содержит перец чили, кукурузу, помидор, картофель, морковь, лисичку, лук, тыкву и огурец."
	cost = CARGO_CRATE_VALUE * 1.8
	contains = list(
		/obj/item/food/grown/chili,
		/obj/item/food/grown/corn,
		/obj/item/food/grown/tomato,
		/obj/item/food/grown/potato,
		/obj/item/food/grown/carrotlike/carrot,
		/obj/item/food/grown/mushroom/chanterelle,
		/obj/item/food/grown/onion,
		/obj/item/food/grown/pumpkin,
		/obj/item/food/grown/cucumber,
	)

/* // DARKPACK EDIT REMOVAL
/datum/supply_pack/organic/exoticseeds
	name = "Exotic Seeds Crate"
	desc = "Any entrepreneuring botanist's dream. Contains twelve different seeds, \
		including one replica-pod seed and two mystery seeds!"
	cost = CARGO_CRATE_VALUE * 3
	access_view = ACCESS_HYDROPONICS
	contains = list(
		/obj/item/seeds/amanita,
		/obj/item/seeds/bamboo,
		/obj/item/seeds/eggplant/eggy,
		/obj/item/seeds/liberty,
		/obj/item/seeds/nettle,
		/obj/item/seeds/plump,
		/obj/item/seeds/replicapod,
		/obj/item/seeds/reishi,
		/obj/item/seeds/rainbow_bunch,
		/obj/item/seeds/seedling,
		/obj/item/seeds/shrub,
		/obj/item/seeds/random = 2,
	)
	crate_name = "exotic seeds crate"
	crate_type = /obj/structure/closet/crate/hydroponics
*/

/datum/supply_pack/organic/food
	name = "Ящик продуктов"
	desc = "Всё для готовки: дюжина яиц, три банана, мука, рис, молоко, соевое молоко, соль, перец, энзимный размягчитель, сахар и бананы."
	cost = CARGO_CRATE_VALUE * 3 // DARKPACK EDIT CHANGE - Unit test failure? - Original: 	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/reagent_containers/condiment/flour,
					/obj/item/reagent_containers/condiment/rice,
					/obj/item/reagent_containers/condiment/milk,
					/obj/item/reagent_containers/condiment/soymilk,
					/obj/item/reagent_containers/condiment/saltshaker,
					/obj/item/reagent_containers/condiment/peppermill,
					/obj/item/storage/fancy/egg_box,
					/obj/item/reagent_containers/condiment/enzyme,
					/obj/item/reagent_containers/condiment/sugar,
					// /obj/item/food/meat/slab/monkey, // CORVAX EDIT REMOVAL
					/obj/item/food/grown/banana = 3,
				)
	crate_name = "ящик продуктов"

/datum/supply_pack/organic/cream_piee
	name = "Ящик кремовых пирогов"
	desc = "Набор высококачественных кремовых пирогов для розыгрышей, вечеринок и тех случаев, когда нужно произвести впечатление. Содержит спортивную сумку с пирогами."
	cost = CARGO_CRATE_VALUE * 12
	contains = list(/obj/item/storage/backpack/duffelbag/clown/cream_pie)
	crate_name = "ящик кремовых пирогов"
	order_flags = ORDER_INVISIBLE // CORVAX EDIT ADD
	access = ACCESS_THEATRE
	access_view = ACCESS_THEATRE
	crate_type = /obj/structure/closet/crate/secure
	discountable = SUPPLY_PACK_RARE_DISCOUNTABLE

/datum/supply_pack/organic/hydroponics/supplies
	name = "Ящик для гидропоники"
	desc = "Всё для хорошего сада: две бутылки аммиака, два спрея Plant-B-Gone, топорик, культиватор, кожаные перчатки и фартук садовника."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/reagent_containers/spray/plantbgone = 2,
					/obj/item/reagent_containers/cup/bottle/ammonia = 2,
					/obj/item/hatchet,
					/obj/item/cultivator,
					// /obj/item/plant_analyzer, // CORVAX EDIT ADD
					/obj/item/clothing/gloves/botanic_leather,
					/obj/item/clothing/suit/apron,
				)
	crate_name = "ящик для гидропоники"

/datum/supply_pack/organic/hydroponics/hydrotank
	name = "Ранцевый бак для гидропоники"
	desc = "Высокоёмкий ранцевый бак с 500 единицами живительной H2O. Для тех, кто решил, что шланга недостаточно."
	cost = CARGO_CRATE_VALUE * 2
	access = ACCESS_HYDROPONICS
	contains = list(/obj/item/watertank)
	crate_name = "ящик с ранцевым баком для гидропоники"
	crate_type = /obj/structure/closet/crate/secure/hydroponics
	order_flags = ORDER_INVISIBLE // CORVAX EDIT ADD

/datum/supply_pack/organic/pizza
	name = "Pizza Crate"
	desc = "Why visit the kitchen when you can have five random pizzas in a fraction of the time? \
			Best prices this side of the galaxy! All deliveries are guaranteed to be 99% anomaly-free."
	cost = CARGO_CRATE_VALUE * 10 // Best prices this side of the galaxy.
	contains = list()
	crate_name = "pizza crate"
	order_flags = ORDER_INVISIBLE // CORVAX EDIT ADD

	///Whether we've provided an infinite pizza box already this shift or not.
	var/anomalous_box_provided = FALSE
	/// one percent chance for a pizza box to be the ininfite pizza box
	var/infinite_pizza_chance = 1
	/// chance that any one of the pizzas in the crate will have romerol added to it
	var/romerol_chance = 0.2
	///Whether we've provided a bomb pizza box already this shift or not.
	var/boombox_provided = FALSE
	/// three percent chance for a pizza box to be the pizza bomb box
	var/bomb_pizza_chance = 3
	/// 1 in 3 pizza bombs spawned will be a dud
	var/bomb_dud_chance = 33

	/// list of pizza that can randomly go inside of a crate, weighted by how disruptive it would be
	var/list/pizza_types = list(
		/obj/item/food/pizza/margherita = 10,
		/obj/item/food/pizza/meat = 10,
		/obj/item/food/pizza/mushroom = 10,
		/obj/item/food/pizza/vegetable = 10,
		/obj/item/food/pizza/donkpocket = 10,
		/obj/item/food/pizza/dank = 7,
		/obj/item/food/pizza/sassysage = 10,
		/obj/item/food/pizza/pineapple = 10,
		/obj/item/food/pizza/arnold = 3,
		/obj/item/food/pizza/energy = 5
	)

/datum/supply_pack/organic/pizza/fill(obj/structure/closet/crate/new_crate)
	. = ..()
	var/list/rng_pizza_list = pizza_types.Copy()
	var/add_romerol = prob(romerol_chance)
	for(var/i in 1 to 5)
		if(add_anomalous(new_crate))
			continue
		if(add_boombox(new_crate))
			continue
		var/obj/item/pizzabox/pizzabox = add_normal_pizza(new_crate, rng_pizza_list)
		if(add_romerol && pizzabox.pizza)
			pizzabox.pizza.reagents.add_reagent(/datum/reagent/romerol, pizzabox.pizza.slices_left)
			add_romerol = FALSE
			log_game("A romerol pizza (as [pizzabox.pizza]) was created in a pizza crate delivery.")
			message_admins("A romerol pizza (as [pizzabox.pizza]) was created in a pizza crate delivery.")

/// adds the chance for an infinite pizza box
/datum/supply_pack/organic/pizza/proc/add_anomalous(obj/structure/closet/crate/new_crate)
	if(anomalous_box_provided)
		return FALSE
	if(!prob(infinite_pizza_chance))
		return FALSE
	new /obj/item/pizzabox/infinite(new_crate)
	anomalous_box_provided = TRUE
	log_game("An anomalous pizza box was provided in a pizza crate at during cargo delivery.")
	if(prob(50))
		addtimer(CALLBACK(src, PROC_REF(anomalous_pizza_report)), rand(30 SECONDS, 180 SECONDS))
		message_admins("An anomalous pizza box was provided in a pizza crate at during cargo delivery.")
	else
		message_admins("An anomalous pizza box was silently created with no command report in a pizza crate delivery.")
	return TRUE

/// adds a chance of a pizza bomb replacing a pizza
/datum/supply_pack/organic/pizza/proc/add_boombox(obj/structure/closet/crate/new_crate)
	if(boombox_provided)
		return FALSE
	if(!prob(bomb_pizza_chance))
		return FALSE
	var/boombox_type = (prob(bomb_dud_chance)) ? /obj/item/pizzabox/bomb : /obj/item/pizzabox/bomb/armed
	new boombox_type(new_crate)
	boombox_provided = TRUE
	log_game("A pizza box bomb was created by a pizza crate delivery.")
	message_admins("A pizza box bomb has arrived in a pizza crate delivery.")
	return TRUE

/// adds a randomized pizza from the pizza list
/datum/supply_pack/organic/pizza/proc/add_normal_pizza(obj/structure/closet/crate/new_crate, list/rng_pizza_list)
	var/randomize_pizza = pick_weight(rng_pizza_list)
	rng_pizza_list -= randomize_pizza
	var/obj/item/pizzabox/new_pizza_box = new(new_crate)
	new_pizza_box.pizza = new randomize_pizza(new_pizza_box)
	new_pizza_box.pizza.slice()
	new_pizza_box.boxtag = new_pizza_box.pizza.boxtag
	new_pizza_box.boxtag_set = TRUE
	new_pizza_box.update_appearance(UPDATE_ICON | UPDATE_DESC)
	return new_pizza_box

/// tells crew that an infinite pizza box exists, half of the time, based on a roll in the anamolous box proc
/datum/supply_pack/organic/pizza/proc/anomalous_pizza_report()
	print_command_report("[station_name()], our anomalous materials divison has reported a missing object that is highly likely to have been sent to your station during a routine cargo \
	delivery. Please search all crates and manifests provided with the delivery and return the object if is located. The object resembles a standard <b>\[DATA EXPUNGED\]</b> and is to be \
	considered <b>\[REDACTED\]</b> and returned at your leisure. Note that objects the anomaly produces are specifically attuned exactly to the individual opening the anomaly; regardless \
	of species, the individual will find the object edible and it will taste great according to their personal definitions, which vary significantly based on person and species.")

/datum/supply_pack/organic/potted_plants
	name = "Ящик горшечных растений"
	desc = "Оживите помещение этими растениями. Содержит случайный набор из пяти горшечных растений из городского питомника. Гарантия не действует при метании."
	cost = CARGO_CRATE_VALUE * 1.5
	contains = list(/obj/item/kirbyplants/random = 5)
	crate_name = "ящик горшечных растений"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/organic/seeds
	name = "Ящик семян"
	desc = "Большое начинается с малого. Содержит пятнадцать разных семян."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/seeds/chili,
					/obj/item/seeds/cotton,
					/obj/item/seeds/berry,
					/obj/item/seeds/corn,
					/obj/item/seeds/eggplant,
					/obj/item/seeds/tomato,
					/obj/item/seeds/soya,
					/obj/item/seeds/wheat,
					/obj/item/seeds/wheat/rice,
					/obj/item/seeds/carrot,
					/obj/item/seeds/sunflower,
					/obj/item/seeds/rose,
					/obj/item/seeds/chanter,
					/obj/item/seeds/potato,
					/obj/item/seeds/sugarcane,
					/obj/item/seeds/cucumber,
				)
	crate_name = "ящик семян"
	crate_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/organic/grill
	name = "Набор для гриля"
	desc = "Всё для первого выезда на природу: гриль, уголь, щипцы и банка энергетика. Соберите друзей и не забудьте про огнетушитель."
	cost = CARGO_CRATE_VALUE * 4
	crate_type = /obj/structure/closet/crate
	contains = list(
		/obj/item/stack/sheet/mineral/coal/five,
		/obj/item/kitchen/tongs,
		/obj/item/reagent_containers/cup/soda_cans/monkey_energy,
		/obj/machinery/grill/unwrenched,
	)
	crate_name = "ящик с набором для гриля"
	discountable = SUPPLY_PACK_UNCOMMON_DISCOUNTABLE

/datum/supply_pack/organic/grillfuel
	name = "Топливо для гриля"
	desc = "Пропан и всё для него. Содержит десять кусков угля и банку энергетика. (Примечание: пропана в комплекте нет.)"
	cost = CARGO_CRATE_VALUE * 4
	crate_type = /obj/structure/closet/crate
	contains = list(/obj/item/stack/sheet/mineral/coal/ten,
					/obj/item/reagent_containers/cup/soda_cans/monkey_energy,
				)
	crate_name = "ящик с топливом для гриля"
	discountable = SUPPLY_PACK_UNCOMMON_DISCOUNTABLE

/* // DARKPACK EDIT REMOVAL
/datum/supply_pack/organic/tiziran_supply
	name = "Tiziran Supply Box"
	desc = "A packaged box of supplies from the heart of the Lizard Empire. \
		Contains a selection of Tiziran ingredients and basic foods."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/storage/box/tiziran_goods,
					/obj/item/storage/box/tiziran_cans,
					/obj/item/storage/box/tiziran_meats,
				)
	crate_name = "\improper Tiziran Supply box"
	crate_type = /obj/structure/closet/crate/cardboard/tiziran
	test_ignored = TRUE

/datum/supply_pack/organic/mothic_supply
	name = "Mothic Supply Box"
	desc = "A packaged box of surplus supplies from the Mothic Fleet. \
		Contains a selection of Mothic ingredients and basic foods."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/storage/box/mothic_goods,
					/obj/item/storage/box/mothic_cans_sauces,
					/obj/item/storage/box/mothic_rations,
				)
	crate_name = "\improper Mothic Supply box"
	crate_type = /obj/structure/closet/crate/cardboard/mothic
*/

/datum/supply_pack/organic/syrup
	name = "Коробка кофейных сиропов"
	desc = "Набор разных сиропов, чтобы ваш кофе стал ещё более диабетическим."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(
		/obj/item/reagent_containers/cup/bottle/syrup_bottle/caramel,
		/obj/item/reagent_containers/cup/bottle/syrup_bottle/liqueur,
		// /obj/item/reagent_containers/cup/bottle/syrup_bottle/korta_nectar, // CORVAX EDIT REMOVAL
	)
	crate_name = "коробка кофейных сиропов"
	crate_type = /obj/structure/closet/crate/cardboard

/datum/supply_pack/organic/syrup_contraband
	order_flags = ORDER_INVISIBLE // CORVAX EDIT ADD
	name = "Коробка нелегальных сиропов"
	desc = "Коробка с нелегальными кофейными сиропами. Хранение и распространение преследуется по Уголовному кодексу штата Калифорния."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(
		/obj/item/reagent_containers/cup/bottle/syrup_bottle/laughsyrup = 2,
	)
	crate_name = "коробка нелегальных сиропов"
	crate_type = /obj/structure/closet/crate/cardboard

/datum/supply_pack/organic/cooking_oil
	name = "Бак кулинарного масла"
	desc = "Высококачественное кулинарное масло. Всё, что помещается во фритюрницу, становится закуской. Содержит бак кулинарного масла."
	cost = CARGO_CRATE_VALUE * 4.75
	contains = list(/obj/structure/reagent_dispensers/cooking_oil)
	crate_name = "ящик с кулинарным маслом"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/organic/beer_keg
	name = "Бочка пива"
	desc = "Идеальный способ начать смену... или закончить её. Содержит полную бочку дешёвого местного пива — чтобы расслабиться после тяжёлого дня, когда ты ещё жив."
	cost = CARGO_CRATE_VALUE * 6.25
	contains = list(/obj/structure/reagent_dispensers/keg/beer)
	crate_name = "ящик с бочкой пива"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/organic/nutraslop
	name = "Блюдо с дешёвой столовой смесью"
	desc = "Кулинарный шедевр, созданный из достижений местной пищевой промышленности. Один укус вернёт вас к вкусу вчерашнего тюремного пайка. Содержит блюдо с Nutraslop."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/structure/reagent_dispensers/servingdish/unanchored)
	crate_name = "ящик с блюдом Nutraslop"
	order_flags = ORDER_INVISIBLE // CORVAX EDIT ADD

/datum/supply_pack/organic/hydroponics/soil_normal
	name = "Ящик почвенной смеси"
	desc = "Ящик с мешками обычной коммерческой почвы."
	cost = CARGO_CRATE_VALUE * 2
	crate_name = "ящик почвенной смеси"
	contains = list(
		/obj/item/soil_sack = 5,
	)

/datum/supply_pack/organic/hydroponics/soil_vermaculite
	name = "Ящик вермикулита"
	desc = "Ящик с мешками вермикулита. Ваш любимый вспученный минерал!"
	cost = CARGO_CRATE_VALUE * 2
	crate_name = "ящик вермикулита"
	contains = list(
		/obj/item/soil_sack/vermaculite = 3,
	)

/datum/supply_pack/organic/hydroponics/soil_gel
	name = "Ящик гидрогелевых шариков"
	desc = "Ящик с мешками предварительно гидратированных суперабсорбирующих гелевых шариков. Всем нравятся хорошие шарики."
	cost = CARGO_CRATE_VALUE * 2
	crate_name = "ящик гидрогелевых шариков"
	contains = list(
		/obj/item/soil_sack/gel = 3,
	)


/datum/supply_pack/organic/hydroponics/soil_coir
	name = "Ящик кокосового волокна"
	desc = "Ящик с мешками кокосового волокна. Отлично подходит для выращивания грибов."
	cost = CARGO_CRATE_VALUE * 3
	crate_name = "ящик кокосового волокна"
	contains = list(
		/obj/item/soil_sack/coir = 3,
	)

/datum/supply_pack/organic/hydroponics/soil_worm
	name = "Ящик вермикомпоста"
	desc = "Ящик с мешками вермикомпоста. Черви не входят в комплект! Или.."
	cost = CARGO_CRATE_VALUE * 4
	crate_name = "ящик вермикомпоста"
	contains = list(
		/obj/item/soil_sack/worm = 3,
	)
