// For items that exist in stores already, my current plan is a bulk order of 5-10 items with a 20% discount.
// This means the supply has to peddle off spare goods.
/datum/supply_pack/local
	group = "Local stock"

/datum/supply_pack/local/vegetable_supplies //behold, ordering legal things.
	name = "Community Produce Seed Pack" //aimed at helping the poorest members of community.
	desc = "Contains a selection of seeds intended for use with the community or personal gardens. Bulk at a cheaper price. No trays."
	cost = 150
	contains = list(
		/obj/item/seeds/cabbage = 2,
		/obj/item/seeds/carrot = 2,
		/obj/item/seeds/corn = 2,
		/obj/item/seeds/onion = 2,
		/obj/item/seeds/carrot/parsnip = 2,
		/obj/item/seeds/peas = 2,
		/obj/item/seeds/potato = 2,
		/obj/item/seeds/pumpkin = 2,
		/obj/item/seeds/soya = 2,
		/obj/item/seeds/tomato = 2,
		/obj/item/seeds/apple = 2,
		/obj/item/seeds/wheat/rice = 2,
		/obj/item/seeds/wheat/oat = 2,
		/obj/item/seeds/aloe = 2,
	)
	crate_name = "veggie crate"

/datum/supply_pack/local/flower_supplies
	name = "Community Flower Seed Pack" //verified as local, non-invasive from https://calscape.org/ & https://plants.usda.gov/
	desc = "Contains a selection of flower seeds. No trays."
	cost = 150
	contains = list(
		/obj/item/seeds/poppy = 3,
		/obj/item/seeds/sunflower = 3,
		/obj/item/seeds/poppy/geranium = 3,
		/obj/item/seeds/poppy/lily = 3,
		// /obj/item/seeds/forgetmenot = 3,
	)
	crate_name = "flower crate"

/*
/datum/supply_pack/local/hydro_tray
	name = "Hydroponics Tray"
	desc = "Everything you need to start your own hydroponics setup."
	cost = 1000
	contains = list(/obj/machinery/hydroponics/constructable)
	crate_name = "hydro crate"
*/

/datum/supply_pack/local/weed_tray
	name = "Plastic Planter Tray"
	desc = "Contains a tray for growing plants."
	cost = 300
	contains = list(/obj/machinery/hydroponics/simple/plastic/unanchored)
	crate_name = "weed crate"

/datum/supply_pack/local/hydro_supplies
	name = "Hydroponics Tool Kit"
	desc = "All the tools you need to cultivate plants at home."
	cost = 400
	contains = list(
		/obj/item/secateurs,
		/obj/item/cultivator/rake,
		/obj/item/cultivator,
		/obj/item/reagent_containers/spray/weedspray,
		/obj/item/reagent_containers/spray/pestspray,
		/obj/item/shovel/spade,
		/obj/item/storage/bag/plants,
		/obj/item/reagent_containers/cup/bucket/wooden,
	)
	crate_name = "hydro crate"

/datum/supply_pack/local/hydro_adv_supplies
	name = "Advanced Fertilizer"
	desc = "Customized fertilizer mixed for the superior homegrown botanist."
	cost = 500
	contains = list(
		/obj/item/reagent_containers/cup/bottle/nutrient/rh = 5,
		)
	crate_name = "hydro crate"


/datum/supply_pack/local/weed_supplies
	name = "Weed Supplies"
	desc = "Contains a bailer and some seeds. No trays."
	cost = 100
	contains = list(
		/obj/item/reagent_containers/cup/watering_can/metal,
		/obj/item/seeds/cannabis = 5,
	)
	crate_name = "hydro crate"

/* Does nothing atm
/datum/supply_pack/local/methlab
	name = "Lab Equipment"
	desc = "Contains lab equipment."
	cost = 4000
	contains = list(/obj/structure/methlab/movable)
*/

/datum/supply_pack/local/fixing
	name = "Fixing kit (wirecutters, lights)"
	desc = "Contains wirecutters, lights and other things to restore light in the area."
	cost = 100
	contains = list(/obj/item/wirecutters, /obj/item/storage/box/lights/mixed)

/*
/datum/supply_pack/local/window_kit
	name = "Window Repair Kit"
	desc = "Contains a window repair kit, good for 10 window replacements."
	cost = 250
	contains = list(/obj/item/window_repair_kit)
*/

/datum/supply_pack/local/door_kit
	name = "Door Repair Kit"
	desc = "Contains a door repair kit that can be used to replace a broken door."
	cost = 1000
	contains = list(/obj/item/door_repair_kit)

/datum/supply_pack/local/medicalsupplies
	name = "Medical Supplies"
	desc = "Contains some first aid supplies."
	cost = 500
	contains = list(
		/obj/item/stack/medical/wrap/gauze = 4,
		/obj/item/stack/medical/bruise_pack = 4,
		/obj/item/stack/medical/suture = 4,
		/obj/item/stack/medical/ointment = 4
	)

/datum/supply_pack/local/cuffs
	name = "Boxs of Handcuffs"
	desc = "Contains boxs of handcuffs."
	cost = 400
	contains = list(/obj/item/storage/box/handcuffs = 4)
	crate_name = "handcuff crate"

/datum/supply_pack/local/potassiodide
	name = "Potassium Iodide"
	desc = "Contains bottles of potassium iodide."
	cost = /obj/item/storage/pill_bottle/potassiodide::custom_price * 4
	contains = list(/obj/item/storage/pill_bottle/potassiodide = 5)

/datum/supply_pack/local/ephedrine
	name = "Ephedrine"
	desc = "Contains bottles of ephedrine."
	cost = /obj/item/storage/pill_bottle/ephedrine::custom_price * 4
	contains = list(/obj/item/storage/pill_bottle/ephedrine = 5)

/datum/supply_pack/local/gas_can
	name = "Gas Cans"
	desc = "Contains gas cans."
	cost = /obj/item/gas_can/full::custom_price * 4
	contains = list(/obj/item/gas_can/full = 5)

/datum/supply_pack/local/thermal_drill
	name = "Thermal Drill"
	desc = "Contains a thermal drill."
	cost = 4000
	contains = list(/obj/structure/drill)
	crate_name = "drill crate"
