/obj/structure/retail/pharmacy
	product_types = list(
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/ointment,
		/obj/item/stack/medical/wrap/gauze,
		/obj/item/stack/medical/suture,
		/obj/item/stack/medical/mesh,
	)
	products_list = list(
		new /datum/data/vending_product("Баночка йодида калия", /obj/item/storage/pill_bottle/potassiodide),
		new /datum/data/vending_product("Латексные перчатки", /obj/item/clothing/gloves/vampire/latex, 150),
		new /datum/data/vending_product("Баночка таблеток железа", /obj/item/storage/pill_bottle/iron, 150),
		new /datum/data/vending_product("Баллончик для ингалятора", /obj/item/reagent_containers/inhaler_canister/albuterol/asthma, 150),
		new /datum/data/vending_product("Баночка эфедрина", /obj/item/storage/pill_bottle/ephedrine),
		new /datum/data/vending_product("Коробка шприцев", /obj/item/storage/box/syringes, 300),
		new /datum/data/vending_product("Ингалятор", /obj/item/inhaler/albuterol/asthma, 400),
		new /datum/data/vending_product("Трость", /obj/item/cane),
		new /datum/data/vending_product("Белая трость", /obj/item/cane/white),
		new /datum/data/vending_product("Костыль", /obj/item/cane/crutch),
		new /datum/data/vending_product("Деревянный костыль", /obj/item/cane/crutch/wood),
		new /datum/data/vending_product("Пустой пакет для крови", /obj/item/reagent_containers/blood/empty),
		new /datum/data/vending_product("Неврологический молоточек", /obj/item/reflexhammer, 30),
// CRIMSON EDIT ADD START - Medkit to Pharmacy
		new /datum/data/vending_product("Пустая аптечка", /obj/item/storage/medkit/darkpack, 200),
		new /datum/data/vending_product("Аптечка", /obj/item/storage/medkit/darkpack/standard, 500),
		new /datum/data/vending_product("Индивидуальная аптечка", /obj/item/storage/medkit/darkpack/ifak, 500),
		new /datum/data/vending_product("Врачебная аптечка", /obj/item/storage/medkit/darkpack/doctor, 900),
		new /datum/data/vending_product("Расширенная аптечка", /obj/item/storage/medkit/darkpack/advanced, 1200),
		new /datum/data/vending_product("Аптечка от ожогов", /obj/item/storage/medkit/darkpack/burn, 600),
		new /datum/data/vending_product("Аптечка от отравлений", /obj/item/storage/medkit/darkpack/tox, 700),
		new /datum/data/vending_product("Аптечка от травм", /obj/item/storage/medkit/darkpack/brute, 700),
		new /datum/data/vending_product("Аптечка от удушья", /obj/item/storage/medkit/darkpack/oxy, 700),
// CRIMSON EDIT ADD END - Medkit to Pharmacy
// CRIMSON EDIT ADD START - Shop Inventories Additions
		new /datum/data/vending_product("Баночка псикодина", /obj/item/storage/pill_bottle/psicodine, 150),
		new /datum/data/vending_product("Баночка мультивера", /obj/item/storage/pill_bottle/multiver, 150),
		new /datum/data/vending_product("Автоинъектор адреналина", /obj/item/reagent_containers/hypospray/medipen, 100),
		new /datum/data/vending_product("Стоматологические щипцы", /obj/item/wirecutters/pliers, 300),
// CRIMSON EDIT ADD END - Shop Inventories Additions
// CRIMSON EDIT ADD START - Magadon Drugs
		new /datum/data/vending_product("magafinil pill bottle", /obj/item/storage/pill_bottle/magafinil, 500),
		new /datum/data/vending_product("magaloft pill bottle", /obj/item/storage/pill_bottle/magaloft, 600),
// CRIMSON EDIT ADD END - Magadon Drugs
	)
