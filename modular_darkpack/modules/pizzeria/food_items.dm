/obj/item/food/raw_fries
	name = "raw french fries"
	desc = "Cut potato strips. Needs a deep fryer to become the real thing."
	icon = 'modular_darkpack/modules/pizzeria/icons/food.dmi'
	icon_state = "raw_fries"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2)
	tastes = list("raw potato" = 1)
	foodtypes = VEGETABLES | RAW
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/raw_fries/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/fryable, /obj/item/food/fries, 10 SECONDS)
