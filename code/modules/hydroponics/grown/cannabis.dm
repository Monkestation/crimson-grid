// Cannabis
/obj/item/seeds/cannabis
	name = "cannabis seed pack"
	desc = "Taxable."
	icon = 'modular_darkpack/modules/drugs/icons/items.dmi' // DARKPACK EDIT CHANGE - DRUGS
	icon_state = "seed-cannabis"
	plant_icon_offset = 7 // DARKPACK EDIT CHANGE - DRUGS
	species = "cannabis"
	plantname = "Cannabis Plant"
	product = /obj/item/food/grown/cannabis
	maturation = 8
	potency = 20
	growthstages = 3 // DARKPACK EDIT CHANGE - DRUGS
	instability = 40
	growing_icon = 'modular_darkpack/modules/drugs/icons/growing.dmi' // DARKPACK EDIT CHANGE - DRUGS
	icon_grow = "cannabis-grow" // Uses one growth icons set for all the subtypes
	icon_dead = "cannabis-dead" // Same for the dead icon
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	/* // DARKPACK EDIT REMOVAL START - DRUGS
	mutatelist = list(
		/obj/item/seeds/cannabis/anti,
		/obj/item/seeds/cannabis/death,
		/obj/item/seeds/cannabis/rainbow,
		/obj/item/seeds/cannabis/ultimate,
		/obj/item/seeds/cannabis/white,
	)
	*/
	reagents_add = list(/datum/reagent/drug/cannabis = 0.15)


/obj/item/seeds/cannabis/rainbow
	name = "rainbow weed seed pack"
	desc = "These seeds grow into rainbow weed. Groovy... and also highly addictive."
	// icon_state = "seed-megacannabis" // DARKPACK EDIT REMOVAL - DRUGS
	// icon_grow = "megacannabis-grow" // DARKPACK EDIT REMOVAL - DRUGS
	// species = "megacannabis" // DARKPACK EDIT REMOVAL - DRUGS
	plantname = "Rainbow Weed"
	product = /obj/item/food/grown/cannabis/rainbow
	mutatelist = null
	// reagents_add = list(/datum/reagent/colorful_reagent = 0.05, /datum/reagent/medicine/psicodine = 0.03, /datum/reagent/drug/happiness = 0.1, /datum/reagent/toxin/mindbreaker = 0.1, /datum/reagent/toxin/lipolicide = 0.15, /datum/reagent/drug/space_drugs = 0.15) // DARKPACK EDIT REMOVAL - DRUGS
	rarity = 40

/obj/item/seeds/cannabis/death
	name = "deathweed seed pack"
	desc = "These seeds grow into deathweed. Not groovy."
	// icon_state = "seed-blackcannabis" // DARKPACK EDIT REMOVAL - DRUGS
	// icon_grow = "blackcannabis-grow" // DARKPACK EDIT REMOVAL - DRUGS
	// species = "blackcannabis" // DARKPACK EDIT REMOVAL - DRUGS
	plantname = "Deathweed"
	product = /obj/item/food/grown/cannabis/death
	mutatelist = null
	// reagents_add = list(/datum/reagent/toxin/cyanide = 0.35, /datum/reagent/drug/cannabis = 0.15) // DARKPACK EDIT REMOVAL - DRUGS
	rarity = 40

/obj/item/seeds/cannabis/white
	name = "lifeweed seed pack"
	desc = "I will give unto him that is munchies of the fountain of the cravings of life, freely."
	// icon_state = "seed-whitecannabis" // DARKPACK EDIT REMOVAL - DRUGS
	// icon_grow = "whitecannabis-grow" // DARKPACK EDIT REMOVAL - DRUGS
	// species = "whitecannabis" // DARKPACK EDIT REMOVAL - DRUGS
	plantname = "Lifeweed"
	instability = 30
	product = /obj/item/food/grown/cannabis/white
	mutatelist = null
	// reagents_add = list(/datum/reagent/medicine/omnizine = 0.35, /datum/reagent/drug/cannabis = 0.15) // DARKPACK EDIT REMOVAL - DRUGS
	rarity = 40


/obj/item/seeds/cannabis/ultimate
	name = "omega weed seed pack"
	desc = "These seeds grow into omega weed."
	// icon_state = "seed-ocannabis" // DARKPACK EDIT REMOVAL - DRUGS
	// plant_icon_offset = 1 // DARKPACK EDIT REMOVAL - DRUGS
	// icon_grow = "ocannabis-grow" // DARKPACK EDIT REMOVAL - DRUGS
	// species = "ocannabis" // DARKPACK EDIT REMOVAL - DRUGS
	plantname = "Omega Weed"
	product = /obj/item/food/grown/cannabis/ultimate
	genes = list(/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/glow/green, /datum/plant_gene/trait/modified_volume/omega_weed)
	mutatelist = null
	/* // DARKPACK EDIT REMOVAL - DRUGS
	reagents_add = list(/datum/reagent/drug/cannabis = 0.3,
		/datum/reagent/toxin/mindbreaker = 0.3,
		/datum/reagent/mercury = 0.15,
		/datum/reagent/lithium = 0.15,
		/datum/reagent/medicine/atropine = 0.15,
		/datum/reagent/drug/methamphetamine = 0.15,
		/datum/reagent/drug/bath_salts = 0.15,
		/datum/reagent/drug/krokodil = 0.15,
		/datum/reagent/toxin/lipolicide = 0.15,
		/datum/reagent/drug/nicotine = 0.1,
	)*/
	rarity = 69
	graft_gene = /datum/plant_gene/trait/glow/green

/obj/item/seeds/cannabis/anti
	name = "anti weed seed pack"
	desc = "These seeds grow into anti weed."
	// icon_state = "seed-ocannabis" // DARKPACK EDIT REMOVAL - DRUGS
	// plant_icon_offset = 0 // DARKPACK EDIT REMOVAL - DRUGS
	// icon_grow = "ocannabis-grow" // DARKPACK EDIT REMOVAL - DRUGS
	// species = "ocannabis" // DARKPACK EDIT REMOVAL - DRUGS
	plantname = "Anti Weed"
	product = /obj/item/food/grown/cannabis/anti
	genes = list(/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/glow/shadow)
	mutatelist = null
	// reagents_add = list(/datum/reagent/medicine/naloxone = 0.3, /datum/reagent/medicine/antihol = 0.2, /datum/reagent/medicine/synaphydramine = 0.1) // DARKPACK EDIT REMOVAL - DRUGS
	rarity = 40
	instability = 0

/obj/item/seeds/cannabis/anti/Initialize(mapload, nogenes)
	. = ..()
	add_atom_colour(COLOR_MATRIX_INVERT, FIXED_COLOUR_PRIORITY)
	transform = transform.Turn(180)

/obj/item/seeds/cannabis/anti/get_tray_overlay(age, status)
	var/mutable_appearance/plant = ..()
	plant.color = COLOR_MATRIX_INVERT
	return plant

// ---------------------------------------------------------------

/obj/item/food/grown/cannabis
	seed = /obj/item/seeds/cannabis
	icon = 'modular_darkpack/modules/drugs/icons/items.dmi' // DARKPACK EDIT CHANGE - DRUGS
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/drugs/icons/onfloor.dmi')// DARKPACK EDIT ADD - DRUGS
	name = "cannabis leaf"
	desc = "They say that next year they're going to try to legalise it." // DARKPACK EDIT CHANGE
	icon_state = "cannabis"
	bite_consumption_mod = 4
	foodtypes = VEGETABLES //i dont really know what else weed could be to be honest
	tastes = list("cannabis" = 1)
	wine_power = 20

// DARKPACK EDIT ADD START
/obj/item/food/grown/cannabis/Initialize(mapload, obj/item/seeds/new_seed)
	. = ..()
	AddComponent(/datum/component/selling, 100, "weed", TRUE, -1, 7)
	//In 2015 Cannabis was only legally distributed in California by medical dispensary. https://web.archive.org/web/20161109220853/http://www.times-standard.com/article/NJ/20161107/NEWS/161109826
	ADD_TRAIT(src, TRAIT_CONTRABAND, INNATE_TRAIT)
// DARKPACK EDIT ADD END

/obj/item/food/grown/cannabis/rainbow
	seed = /obj/item/seeds/cannabis/rainbow
	name = "rainbow cannabis leaf"
	desc = "Is it supposed to be glowing like that...?"
	// icon_state = "megacannabis" // DARKPACK EDIT REMOVAL - DRUGS
	wine_power = 60

/obj/item/food/grown/cannabis/death
	seed = /obj/item/seeds/cannabis/death
	name = "death cannabis leaf"
	desc = "Looks a bit dark. Oh well."
	// icon_state = "blackcannabis" // DARKPACK EDIT REMOVAL - DRUGS
	wine_power = 40

/obj/item/food/grown/cannabis/white
	seed = /obj/item/seeds/cannabis/white
	name = "white cannabis leaf"
	desc = "It feels smooth and nice to the touch."
	// icon_state = "whitecannabis" // DARKPACK EDIT REMOVAL - DRUGS
	wine_power = 10

/obj/item/food/grown/cannabis/ultimate
	seed = /obj/item/seeds/cannabis/ultimate
	name = "omega cannabis leaf"
	desc = "You feel dizzy looking at it. What the fuck?"
	// icon_state = "ocannabis" // DARKPACK EDIT REMOVAL - DRUGS
	bite_consumption_mod = 2 // Ingesting like 40 units of drugs in 1 bite at 100 potency
	wine_power = 90

/obj/item/food/grown/cannabis/anti
	seed = /obj/item/seeds/cannabis/anti
	name = "anti cannabis leaf"
	desc = "You feel normal looking at it. What the fuck?"
	// icon_state = "ocannabis" // DARKPACK EDIT REMOVAL - DRUGS

/obj/item/food/grown/cannabis/anti/Initialize(mapload, obj/item/seeds/new_seed)
	. = ..()
	add_atom_colour(COLOR_MATRIX_INVERT, FIXED_COLOUR_PRIORITY)
	transform = transform.Turn(180)
	if(prob(0.05))
		name = "evil cannabis leaf"
