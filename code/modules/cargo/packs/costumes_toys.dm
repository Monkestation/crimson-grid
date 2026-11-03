/datum/supply_pack/costumes_toys
	group = "Развлечения"

/* CORVAX EDIT REMOVAL
/datum/supply_pack/costumes_toys/randomised
	name = "Collectable Hats Crate"
	desc = "Flaunt your status with three unique, highly-collectable hats!"
	cost = CARGO_CRATE_VALUE * 40
	var/num_contained = 3 //number of items picked to be contained in a randomised crate
	contains = list(/obj/item/clothing/head/collectable/chef,
					/obj/item/clothing/head/collectable/paper,
					/obj/item/clothing/head/collectable/tophat,
					/obj/item/clothing/head/collectable/captain,
					/obj/item/clothing/head/collectable/beret,
					/obj/item/clothing/head/collectable/welding,
					/obj/item/clothing/head/collectable/flatcap,
					/obj/item/clothing/head/collectable/pirate,
					/obj/item/clothing/head/collectable/kitty,
					/obj/item/clothing/head/collectable/rabbitears,
					/obj/item/clothing/head/collectable/wizard,
					/obj/item/clothing/head/collectable/hardhat,
					/obj/item/clothing/head/collectable/hos,
					/obj/item/clothing/head/collectable/hop,
					/obj/item/clothing/head/collectable/thunderdome,
					/obj/item/clothing/head/collectable/swat,
					/obj/item/clothing/head/collectable/slime,
					/obj/item/clothing/head/collectable/police,
					/obj/item/clothing/head/collectable/slime,
					/obj/item/clothing/head/collectable/xenom,
					/obj/item/clothing/head/collectable/petehat,
				)
	crate_name = "collectable hats crate"
	crate_type = /obj/structure/closet/crate/wooden
	discountable = SUPPLY_PACK_RARE_DISCOUNTABLE
	test_ignored = TRUE

/datum/supply_pack/costumes_toys/randomised/fill(obj/container)
	var/list/L = contains.Copy()
	for(var/i in 1 to num_contained)
		var/item = pick_n_take(L)
		new item(container)

/datum/supply_pack/costumes_toys/formalwear
	name = "Formalwear Crate"
	desc = "You're gonna like the way you look, I guaranteed it. Contains an asston of fancy clothing."
	cost = CARGO_CRATE_VALUE * 4 //Lots of very expensive items. You gotta pay up to look good!
	contains = list(/obj/item/clothing/under/dress/tango,
					/obj/item/clothing/under/misc/assistantformal = 2,
					/obj/item/clothing/under/rank/civilian/lawyer/bluesuit,
					/obj/item/clothing/suit/toggle/lawyer,
					/obj/item/clothing/under/rank/civilian/lawyer/purpsuit,
					/obj/item/clothing/suit/toggle/lawyer/purple,
					/obj/item/clothing/suit/toggle/lawyer/black,
					/obj/item/clothing/accessory/waistcoat,
					/obj/item/clothing/neck/tie/blue,
					/obj/item/clothing/neck/tie/red,
					/obj/item/clothing/neck/tie/black,
					/obj/item/clothing/head/hats/bowler,
					/obj/item/clothing/head/fedora,
					/obj/item/clothing/head/flatcap,
					/obj/item/clothing/head/beret,
					/obj/item/clothing/head/hats/tophat,
					/obj/item/clothing/shoes/laceup = 3,
					/obj/item/clothing/under/suit/charcoal,
					/obj/item/clothing/under/suit/navy,
					/obj/item/clothing/under/suit/burgundy,
					/obj/item/clothing/under/suit/checkered,
					/obj/item/clothing/under/suit/tan,
					/obj/item/lipstick/random,
				)
	crate_name = "formalwear crate"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/clownpin
	name = "Hilarious Firing Pin Crate"
	desc = "I uh... I'm not really sure what this does. Wanna buy it?"
	cost = CARGO_CRATE_VALUE * 10
	order_flags = ORDER_CONTRABAND
	contains = list(/obj/item/firing_pin/clown)
	crate_name = "toy crate" // It's /technically/ a toy. For the clown, at least.
	crate_type = /obj/structure/closet/crate/wooden
	discountable = SUPPLY_PACK_RARE_DISCOUNTABLE

/datum/supply_pack/costumes_toys/lasertag
	name = "Laser Tag Crate"
	desc = "Foam Force is for boys. Laser Tag is for men. Contains three sets of red suits, blue suits, \
		matching helmets, and matching laser tag guns."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/gun/energy/laser/redtag = 3,
					/obj/item/gun/energy/laser/bluetag = 3,
					/obj/item/clothing/suit/redtag = 3,
					/obj/item/clothing/suit/bluetag = 3,
					/obj/item/clothing/head/helmet/taghelm/blue = 3,
					/obj/item/clothing/head/helmet/taghelm/red = 3,
				)
	crate_name = "laser tag crate"
*/

/datum/supply_pack/costumes_toys/knucklebones
	name = "Ящик для игры в кости"
	desc = "Набор для настольной игры в кости. В комплекте восемнадцать шестигранных кубиков, мел и правила. Игра не имеет отношения к культам; соблюдайте местные законы."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/dice/d6 = 18,
					/obj/item/paper/guides/knucklebone,
					/obj/item/toy/crayon/white,
				)
	crate_name = "knucklebones game crate"
	crate_type = /obj/structure/closet/crate/wooden

/* CORVAX EDIT REMOVAL
/datum/supply_pack/costumes_toys/lasertag/pins
	name = "Laser Tag Firing Pins Crate"
	desc = "Three laser tag firing pins used in laser-tag units to ensure users are wearing their vests."
	cost = CARGO_CRATE_VALUE * 3.5
	order_flags = ORDER_CONTRABAND
	contains = list(/obj/item/storage/box/lasertagpins)
	crate_name = "laser tag crate"

/datum/supply_pack/costumes_toys/mech_suits
	name = "Mech Pilot's Suit Crate"
	desc = "Suits for piloting big robots. Contains four of those!"
	cost = CARGO_CRATE_VALUE * 3 //state-of-the-art technology doesn't come cheap
	contains = list(/obj/item/clothing/under/costume/mech_suit = 4)
	crate_name = "mech pilot's suit crate"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/costume_original
	name = "Original Costume Crate"
	desc = "Reenact Shakespearean plays with this assortment of outfits. Contains eight different costumes!"
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/clothing/head/costume/snowman,
					/obj/item/clothing/suit/costume/snowman,
					/obj/item/clothing/head/costume/chicken,
					/obj/item/clothing/suit/costume/chickensuit,
					/obj/item/clothing/mask/gas/monkeymask,
					/obj/item/clothing/suit/costume/monkeysuit,
					/obj/item/clothing/head/costume/cardborg,
					/obj/item/clothing/suit/costume/cardborg,
					/obj/item/clothing/head/costume/xenos,
					/obj/item/clothing/suit/costume/xenos,
					/obj/item/clothing/suit/hooded/ian_costume,
					/obj/item/clothing/suit/hooded/carp_costume,
					/obj/item/clothing/suit/hooded/bee_costume,
				)
	crate_name = "original costume crate"
	crate_type = /obj/structure/closet/crate/wooden
*/

/datum/supply_pack/costumes_toys/costume
	name = "Набор одежды артиста"
	desc = "Стандартный набор для начинающих артистов. Два набора по цене одного!"
	cost = CARGO_CRATE_VALUE * 3 // CORVAX EDIT
	// access = ACCESS_THEATRE // CORVAX EDIT
	contains = list(/obj/item/storage/backpack/clown,
					/obj/item/clothing/shoes/clown_shoes,
					/obj/item/clothing/mask/gas/clown_hat,
					/obj/item/clothing/under/rank/civilian/clown,
					/obj/item/bikehorn,
					/obj/item/clothing/under/rank/civilian/mime,
					/obj/item/clothing/shoes/sneakers/black,
					/obj/item/clothing/gloves/color/white,
					/obj/item/clothing/mask/gas/mime,
					/obj/item/clothing/head/beret/frenchberet,
					/obj/item/clothing/suit/toggle/suspenders,
					// /obj/item/reagent_containers/cup/glass/bottle/bottleofnothing, // CORVAX EDIT
					/obj/item/storage/backpack/mime,
				)
	crate_name = "набор артиста"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/costume/fill(obj/container)
	..()
	var/funny_gas_internals
	funny_gas_internals = pick(subtypesof(/obj/item/tank/internals/emergency_oxygen/engi/clown) - /obj/item/tank/internals/emergency_oxygen/engi/clown)
	new funny_gas_internals(container)

/* CORVAX EDIT REMOVAL
/datum/supply_pack/costumes_toys/randomised/toys
	name = "Ящик с игрушками"
	desc = "Пропустите скучные игры и сразу переходите к призам! Содержит пять случайных игрушек."
	cost = CARGO_CRATE_VALUE * 8 // or play the arcade machines ya lazy bum
	num_contained = 5
	contains = list()
	crate_name = "toy crate"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/randomised/toys/fill(obj/container)
	var/the_toy
	for(var/i in 1 to num_contained)
		if(prob(50))
			the_toy = pick_weight(GLOB.arcade_prize_pool)
		else
			the_toy = /obj/effect/spawner/random/entertainment/plushie_delux
		new the_toy(container)

/datum/supply_pack/costumes_toys/wizard
	name = "Wizard Costume Crate"
	desc = "Pretend to join the Wizard Federation with this full wizard outfit! Nanotrasen would like to remind \
		its employees that actually joining the Wizard Federation is subject to termination of job and life."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/staff,
					/obj/item/clothing/suit/wizrobe/fake,
					/obj/item/clothing/shoes/sandal,
					/obj/item/clothing/head/wizard/fake,
				)
	crate_name = "wizard costume crate"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/trekkie
	name = "Trekkie Costume Crate"
	desc = "Wear the scrapped concepts for twelve of Nanotrasen's jumpsuits, based off popular \
		late-20th century Earth media! While they couldn't be used for the official jumpsuits \
		due to copyright infringement, it's been assured that they can still legally be sold under \
		the label of being 'failed designs'."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(
		/obj/item/clothing/under/trek/command,
		/obj/item/clothing/under/trek/command/next,
		/obj/item/clothing/under/trek/command/voy,
		/obj/item/clothing/under/trek/command/ent,
		/obj/item/clothing/under/trek/engsec,
		/obj/item/clothing/under/trek/engsec/next,
		/obj/item/clothing/under/trek/engsec/voy,
		/obj/item/clothing/under/trek/engsec/ent,
		/obj/item/clothing/under/trek/medsci,
		/obj/item/clothing/under/trek/medsci/next,
		/obj/item/clothing/under/trek/medsci/voy,
		/obj/item/clothing/under/trek/medsci/ent,
	)
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/randomised/tcg
	name = "Big-Ass Booster Pack Pack"
	desc = "A bumper load of NT TCG Booster Packs of varying series. Collect them all!"
	cost = 1000
	contains = list()
	crate_name = "booster pack pack"
	discountable = SUPPLY_PACK_STD_DISCOUNTABLE

/datum/supply_pack/costumes_toys/randomised/tcg/fill(obj/container)
	var/cardpacktype
	for(var/i in 1 to 10)
		cardpacktype = pick(subtypesof(/obj/item/cardpack))
		new cardpacktype(container)

/datum/supply_pack/costumes_toys/stickers
	name = "Sticker Pack Crate"
	desc = "This crate contains a random assortment of stickers."
	cost = CARGO_CRATE_VALUE * 3
	contains = list()
	discountable = SUPPLY_PACK_STD_DISCOUNTABLE

/datum/supply_pack/costumes_toys/stickers/fill(obj/structure/closet/crate/crate)
	for(var/i in 1 to rand(1, 2))
		new /obj/item/storage/box/stickers(crate)

	if(prob(30)) // a pair of googly eyes because funny
		new /obj/item/storage/box/stickers/googly(crate)
*/

/datum/supply_pack/costumes_toys/pinata
	name = "Набор пиньяты"
	desc = "В этом ящике находится пиньята, полная конфет, повязка на глаза и бита, чтобы разбивать ее."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(
		/obj/item/pinata,
		/obj/item/melee/baseball_bat,
		/obj/item/clothing/glasses/blindfold,
	)
	crate_name = "набор пиньяты"
	crate_type = /obj/structure/closet/crate/wooden
	discountable = SUPPLY_PACK_STD_DISCOUNTABLE

/datum/supply_pack/costumes_toys/balloons
	name = "Набор воздушных шариков"
	desc = "Набор содержит 24 разноцветных воздушных шариков плотно упакованных в коробочку. Прямиком из Китая."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(
		/obj/item/storage/box/balloons,
		// /obj/item/skillchip/job/clown, // CORVAX EDIT
	)
	crate_name = "набор воздушных шариков"
	crate_type = /obj/structure/closet/crate/wooden
	discountable = SUPPLY_PACK_STD_DISCOUNTABLE

/datum/supply_pack/costumes_toys/christmas
	name = "Рождественский набор подарков"
	desc = "В этом ящике находятся предварительно упакованные подарки, адресованные всем гражданам штата, которые были выбраны случайным образом в рамках инициативы по повышению морального духа страны."
	cost = CARGO_CRATE_VALUE * 30
	contains = list()
	order_flags = ORDER_SPECIAL
	crate_type = /obj/structure/closet/crate/mail
	discountable = SUPPLY_PACK_NOT_DISCOUNTABLE

/datum/supply_pack/costumes_toys/christmas/fill(obj/structure/closet/crate/crate)
	var/list/mail_recipients = list()
	for(var/mob/living/carbon/human/human in GLOB.player_list)
		if(human.stat == DEAD || !human.mind)
			continue
		// Skip wizards, nuke ops, cyborgs; They're not written down as employees
		if(!(human.mind.assigned_role.job_flags & JOB_CREW_MEMBER))
			continue
		mail_recipients += human.mind

	for (var/i in 1 to rand(4, 6))
		var/obj/item/gift/anything/gift = new(crate)
		var/datum/mind/recipient = pick_n_take(mail_recipients)
		if(recipient)
			gift.assign_recipient(recipient)
		else
			qdel(gift)
			break

	var/obj/item/delivery/big/parcel = new(crate.loc)
	parcel.base_icon_state = crate.delivery_icon
	parcel.giftwrapped = TRUE
	parcel.update_icon()
	parcel.drag_slowdown = crate.drag_slowdown
	crate.forceMove(parcel)
	parcel.name = "рождественская посылка"
