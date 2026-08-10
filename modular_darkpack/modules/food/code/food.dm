/obj/item/food/vampire
	icon = 'modular_darkpack/modules/food/icons/items.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/food/icons/food_onfloor.dmi')
	w_class = WEIGHT_CLASS_SMALL
	//eatsound = 'code/modules/wod13/sounds/eat.ogg'
	custom_price = 3
	food_flags = FOOD_BITE_SPRITE

//----------FAST FOOD--------///
/obj/item/food/burger/plain
	icon = 'modular_darkpack/modules/food/icons/items.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/food/icons/food_onfloor.dmi')
	custom_price = 3
	food_flags = FOOD_BITE_SPRITE

/obj/item/food/donut/plain // DARKPACK TODO: unique onfloors for variants
	icon = 'modular_darkpack/modules/food/icons/items.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/food/icons/food_onfloor.dmi')
	custom_price = 1
	food_flags = FOOD_BITE_SPRITE

/obj/item/food/donut/choco // DARKPACK TODO: unique onfloors for variants
	icon = 'modular_darkpack/modules/food/icons/items.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/food/icons/food_onfloor.dmi')
	custom_price = 1
	food_flags = FOOD_BITE_SPRITE

/obj/item/food/pizzaslice/square
	name = "square pizza slice"
	icon_state = "pizza"
	icon = 'modular_darkpack/modules/food/icons/items.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/food/icons/food_onfloor.dmi')
	custom_price = 2
	food_flags = FOOD_BITE_SPRITE

/obj/item/food/taco
	icon = 'modular_darkpack/modules/food/icons/items.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/food/icons/food_onfloor.dmi')
	custom_price = 2
	food_flags = FOOD_BITE_SPRITE

/obj/item/food/taco/plain
	icon_state = "taco"

/obj/item/food/taco/fish
	icon_state = "taco"

/obj/item/trash/vampirenugget
	name = "chicken wing bone"
	icon_state = "nugget0"
	icon = 'modular_darkpack/modules/food/icons/items.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/food/icons/food_onfloor.dmi')

/obj/item/food/vampire/nugget
	name = "chicken wing"
	desc = "Big Wing for a big man."
	icon_state = "nugget1"
	trash_type = /obj/item/trash/vampirenugget
	bite_consumption = 1
	tastes = list("chicken" = 1)
	foodtypes = MEAT
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/protein = 3)
	eat_time = 15

/obj/item/food/hotdog
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/food/icons/food_onfloor.dmi')

/obj/item/food/butterdog
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/food/icons/food_onfloor.dmi')

//--------PACKAGED SNACKS-----------//

/obj/item/trash/vampirebar
	name = "chocolate bar wrapper"
	icon_state = "bar0"
	icon = 'modular_darkpack/modules/food/icons/items.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/food/icons/food_onfloor.dmi')

/obj/item/food/vampire/icecream
	name = "ice cream"
	desc = "Taste the childhood."
	icon_state = "icecream2"
	food_reagents = list(/datum/reagent/consumable/cream = 2, /datum/reagent/consumable/vanilla = 1, /datum/reagent/consumable/sugar = 4)
	tastes = list("vanilla" = 2, "ice cream" = 2)
	foodtypes = FRUIT | DAIRY | SUGAR

/obj/item/food/vampire/icecream/chocolate
	icon_state = "icecream1"
	tastes = list("chocolate" = 2, "ice cream" = 2)
	food_reagents = list(/datum/reagent/consumable/hot_coco = 4, /datum/reagent/consumable/salt = 1,  /datum/reagent/consumable/cream = 2, /datum/reagent/consumable/vanilla = 1, /datum/reagent/consumable/sugar = 4)

/obj/item/food/vampire/icecream/berry
	icon_state = "icecream3"
	tastes = list("berry" = 2, "ice cream" = 2)
	food_reagents = list(/datum/reagent/consumable/berryjuice = 4, /datum/reagent/consumable/salt = 1,  /datum/reagent/consumable/cream = 2, /datum/reagent/consumable/vanilla = 1, /datum/reagent/consumable/sugar = 4)

/* Sprites dont match new tg ones, but they look so good.. do something with this fact.
/obj/item/reagent_containers/condiment/flour
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/food/icons/food_onfloor.dmi')

/obj/item/reagent_containers/condiment/sugar
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/food/icons/food_onfloor.dmi')

/obj/item/reagent_containers/condiment/rice
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/food/icons/food_onfloor.dmi')
*/

/obj/item/food/meat/slab
	ONFLOOR_ICONSTATE_HELPER("meat")
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/food/icons/food_onfloor.dmi')
