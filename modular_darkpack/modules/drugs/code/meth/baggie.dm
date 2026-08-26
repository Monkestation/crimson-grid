/obj/item/reagent_containers/cup/glass/baggie
	name = "small plastic bag"
	icon_state = "package_empty"
	icon = 'modular_darkpack/modules/drugs/icons/items.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/drugs/icons/onfloor.dmi')

/obj/item/reagent_containers/cup/glass/baggie/meth
	name = "blue package"
	icon_state = "package_meth"
	list_reagents = list(/datum/reagent/drug/methamphetamine = 30)


/obj/item/reagent_containers/cup/glass/baggie/meth/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 50, "meth", TRUE, -1, 4)
//CRIMSON GRID EDIT. HALVED THE SELLING PRICE

/obj/item/reagent_containers/cup/glass/baggie/meth/cocaine
	name = "white package"
	icon_state = "package_cocaine"
	list_reagents = list(/datum/reagent/drug/methamphetamine/cocaine = 30)


/obj/item/reagent_containers/cup/glass/baggie/meth/cocaine/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 50, "cocaine", TRUE, -1, 5)

//CRIMSON GRID EDIT. HALVED THE SELLING PRICE
