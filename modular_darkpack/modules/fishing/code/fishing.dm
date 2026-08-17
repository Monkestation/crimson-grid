/obj/item/fish/darkpack
	abstract_type = /obj/item/fish/darkpack
	desc = "marine life"
	icon = 'modular_darkpack/modules/fishing/icons/fish.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/fishing/icons/fish_onfloor.dmi')
	w_class = WEIGHT_CLASS_SMALL
	//eatsound = 'modular_darkpack/modules/food/sounds/eat.ogg'

/obj/item/fish/darkpack/shark
	name = "leopard shark"
	desc = "Often found in groups foraging for clams, crabs, shrimp, and worms in intertidal mudflats found along the west coast, these sharks are rarely found bigger than 2 meters."
	icon_state = "shark"
	icon = 'modular_darkpack/modules/fishing/icons/fish48x32.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/fishing/icons/fish_onfloor.dmi')
	base_pixel_w = -16
	pixel_w = -16
	fish_id = "darkpack_shark"
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	fish_traits = list(/datum/fish_trait/predator, /datum/fish_trait/territorial)
	fish_movement_type = /datum/fish_movement/accelerando
	fishing_difficulty_modifier = 15

	average_size = 135
	average_weight = 10000
	stable_population = 6

	dedicated_in_aquarium_icon_state = "fish_greyscale"
	aquarium_vc_color = "#33302e"
	beauty = FISH_BEAUTY_GREAT
	sprite_width = 5
	sprite_height = 3

/obj/item/fish/darkpack/shark/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 150, "fish", FALSE)

/obj/item/fish/darkpack/tuna
	name = "bluefin tuna"
	desc = "The mighty tuna fuels a robust fishing economy."
	icon = 'modular_darkpack/modules/fishing/icons/fish48x32.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/fishing/icons/fish_onfloor.dmi')
	icon_state = "bluefin_tuna"
	fish_id = "darkpack_tuna"
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	fish_traits = list(/datum/fish_trait/predator)
	fish_movement_type = /datum/fish_movement/choppy
	fishing_difficulty_modifier = 45

	stable_population = 3
	average_size = 150
	average_weight = 60000

	dedicated_in_aquarium_icon_state = "fish_greyscale"
	aquarium_vc_color = "#22244e"
	sprite_width = 8
	sprite_height = 6

/obj/item/fish/darkpack/tuna/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 250, "fish", FALSE)

/obj/item/fish/darkpack/catfish
	name = "channel catfish"
	desc = "The channel cat loves to eat snails, crabs, bugs, algae, nuts, even small birds or mammals it can get its mouth on."
	icon_state = "catfish"
	fish_id = "darkpack_catfish"
	required_fluid_type = AQUARIUM_FLUID_FRESHWATER
	fish_traits = list(/datum/fish_trait/predator)
	fishing_difficulty_modifier = 10

	stable_population = 3
	average_size = 35
	average_weight = 1350

	dedicated_in_aquarium_icon_state = "catfish_small"
	beauty = FISH_BEAUTY_GOOD
	sprite_width = 4
	sprite_height = 2

/obj/item/fish/darkpack/catfish/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 75, "fish", FALSE)

/obj/item/fish/darkpack/crab
	name = "dungeness crab"
	desc = "An economically important crab prized for its tasty innards."
	icon_state = "crab"
	fillet_type = /obj/item/food/meat/slab/rawcrab
	fish_id = "darkpack_crab"
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	fish_traits = list(/datum/fish_trait/amphibious)
	fish_movement_type = /datum/fish_movement/slow

	stable_population = 8
	average_size = 16
	average_weight = 900

	dedicated_in_aquarium_icon_state = "crab_small"
	sprite_height = 4
	sprite_width = 4

/obj/item/fish/darkpack/crab/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 65, "fish", FALSE)

/obj/item/fish/darkpack/stickleback
	name = "three-spined stickleback"
	desc = "A hardy, tiny, prolific little fish. Often used itself for bait."
	icon_state = "stickleback"
	fish_id = "darkpack_stickleback"
	required_fluid_type = AQUARIUM_FLUID_ANADROMOUS
	w_class = WEIGHT_CLASS_TINY
	fish_movement_type = /datum/fish_movement/slow

	stable_population = 8
	average_size = 5
	average_weight = 2

	dedicated_in_aquarium_icon_state = "fish_greyscale"
	aquarium_vc_color = "#9c8527"
	beauty = FISH_BEAUTY_NULL
	sprite_height = 1
	sprite_width = 2

/obj/item/fish/darkpack/stickleback/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 5, "fish", FALSE)

/obj/item/fish/darkpack/anchovy
	name = "anchovy"
	desc = "A filter-feeder that travels in schools, which are often netted to be sold in great quantities."
	icon_state = "anchovy"
	fish_id = "darkpack_anchovy"
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	w_class = WEIGHT_CLASS_TINY
	fish_movement_type = /datum/fish_movement/slow

	stable_population = 12
	average_size = 7
	average_weight = 9

	dedicated_in_aquarium_icon_state = "fish_greyscale"
	aquarium_vc_color = "#818493"
	beauty = FISH_BEAUTY_NULL
	sprite_height = 1
	sprite_width = 2

/obj/item/fish/darkpack/anchovy/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 10, "fish", FALSE)

/obj/item/fish/darkpack/crappie
	name = "crappie"
	desc = "Ironically well-regarded for its flavor."
	icon_state = "crappie"
	fish_id = "darkpack_crappie"
	required_fluid_type = AQUARIUM_FLUID_FRESHWATER
	w_class = WEIGHT_CLASS_TINY
	fish_traits = list(/datum/fish_trait/predator)

	stable_population = 16
	average_size = 23
	average_weight = 700

	dedicated_in_aquarium_icon_state = "fish_greyscale"
	aquarium_vc_color = "#819390"
	beauty = FISH_BEAUTY_BAD
	sprite_height = 1
	sprite_width = 2

/obj/item/fish/darkpack/crappie/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 65, "fish", FALSE)


/obj/item/fish/darkpack/trout
	name = "rainbow trout"
	desc = "An anadromous fish, meaning it lives normally in the ocean but returns to freshwater to spawn."
	icon_state = "trout"
	fish_id = "darkpack_trout"
	required_fluid_type = AQUARIUM_FLUID_ANADROMOUS
	fish_traits = list(/datum/fish_trait/predator)

	stable_population = 8
	average_size = 30
	average_weight = 1500

	dedicated_in_aquarium_icon_state = "fish_greyscale"
	aquarium_vc_color = "#c7c5d2"
	beauty = FISH_BEAUTY_GOOD
	sprite_height = 5
	sprite_width = 3

/obj/item/fish/darkpack/trout/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 50, "fish", FALSE)

/obj/item/fish/darkpack/eagle_ray
	name = "bat ray"
	desc = "Bottom feeders that use their wings to brush sand to expose their prey. Uses its venomous spine for defense. Prized in saltwater aquariums."
	icon_state = "eagle_ray"
	fish_id = "darkpack_eagle_ray"
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	fish_traits = list(/datum/fish_trait/predator, /datum/fish_trait/stinger, /datum/fish_trait/toxic_barbs)
	fish_movement_type = /datum/fish_movement/zippy

	stable_population = 2
	average_size = 200
	average_weight = 11000

	dedicated_in_aquarium_icon_state = "stingray_small"
	beauty = FISH_BEAUTY_EXCELLENT
	sprite_height = 7
	sprite_width = 9

/obj/item/fish/darkpack/eagle_ray/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 200, "fish", FALSE)

/obj/item/fish/darkpack/salmon
	name = "cherry salmon"
	desc = "A favorite that's especially abundant in the Pacific Northwest but has become quite rare as of late."
	icon_state = "fish"
	fish_id = "darkpack_salmon"
	required_fluid_type = AQUARIUM_FLUID_ANADROMOUS
	fishing_difficulty_modifier = 15

	stable_population = 6
	average_size = 50
	average_weight = 2250

	dedicated_in_aquarium_icon_state = "fish_greyscale"
	beauty = FISH_BEAUTY_GOOD
	sprite_width = 5
	sprite_height = 3

/obj/item/fish/darkpack/salmon/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 70, "fish", FALSE)

/obj/item/food/darkpack/leech
	name = "leech"
	desc = "A vile creature that feasts on the blood of other animals."
	icon_state = "leech"
	icon = 'modular_darkpack/modules/fishing/icons/fish.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/fishing/icons/fish_onfloor.dmi')
	w_class = WEIGHT_CLASS_TINY

	bite_consumption = 1
	tastes = list("slime" = 1, "blood" = 1)
	foodtypes = GROSS | MEAT | RAW
	eat_time = 5
	food_reagents = list(/datum/reagent/consumable/nutriment/leech = 1)

/obj/item/food/darkpack/leech/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 1, "fish", FALSE)

/datum/reagent/consumable/nutriment/leech
	name = "leech guts"
	nutriment_factor = 1 * REAGENTS_METABOLISM
	taste_description = "copper"

/datum/reagent/consumable/nutriment/leech/expose_mob(mob/living/exposed_mob, methods=INGEST, reac_volume, show_message, touch_protection)
	if(get_kindred_splat(exposed_mob))
		var/survival_skill = exposed_mob.st_get_stat(STAT_SURVIVAL)
		var/animal_skill = exposed_mob.st_get_stat(STAT_ANIMAL_KEN)
		if(prob(max(25,((survival_skill+animal_skill)*10))))
			exposed_mob.adjust_blood_pool(reac_volume/2)
	return ..()

/datum/reagent/consumable/nutriment/leech/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	if(get_splat_with_vitae(affected_mob))
		var/survival_skill = affected_mob.st_get_stat(STAT_SURVIVAL)
		var/animal_skill = affected_mob.st_get_stat(STAT_ANIMAL_KEN)
		if(SPT_PROB(max(25,((survival_skill+animal_skill)*10)), seconds_per_tick))
			affected_mob.adjust_blood_pool(0.25)
	return ..()

/obj/item/food/darkpack/horn_snail
	name = "horn snail"
	desc = "Looks like something's in there!"
	icon = 'modular_darkpack/modules/fishing/icons/fish.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/fishing/icons/fish_onfloor.dmi')
	icon_state = "horn_snail"
	trash_type = /obj/item/toy/darkpack/seashell/horn_snail
	w_class = WEIGHT_CLASS_TINY

	bite_consumption = 1
	tastes = list("snail" = 1)
	foodtypes = MEAT | RAW
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/protein = 1)

/obj/item/food/darkpack/horn_snail/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 5, "fish", FALSE)

/obj/item/toy/darkpack/seashell/
	name = "seashell"
	desc = "If you put it to your ear, you can hear the ocean! No, wait, that's just the blood in your ears."
	floor_placeable = TRUE

/obj/item/toy/darkpack/seashell/horn_snail
	icon = 'modular_darkpack/modules/fishing/icons/fish.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/fishing/icons/fish_onfloor.dmi')
	icon_state = "horn_snail"

/*
/obj/item/fishing_rod
	name = "fishing rod"
	icon_state = "fishing"
	icon = 'modular_darkpack/modules/deprecated/icons/items.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/deprecated/icons/onfloor.dmi')
	w_class = WEIGHT_CLASS_BULKY
	lefthand_file = 'modular_darkpack/modules/deprecated/icons/lefthand.dmi'
	righthand_file = 'modular_darkpack/modules/deprecated/icons/righthand.dmi'
	var/catching = FALSE

/obj/item/fishing_rod/attack_self(mob/user)
	. = ..()
	if(isturf(user.loc))
		forceMove(user.loc)
		onflooricon = 'modular_darkpack/modules/deprecated/icons/64x64.dmi'
		icon = 'modular_darkpack/modules/deprecated/icons/64x64.dmi'
		dir = user.dir
		anchored = TRUE

/obj/item/fishing_rod/mouse_drop_receive(atom/over_object)
	. = ..()
	if(isturf(loc))
		if(istype(over_object, /mob/living))
			if(get_dist(src, over_object) < 2)
				if(anchored)
					anchored = FALSE
					onflooricon = initial(onflooricon)
					icon = onflooricon

/obj/item/fishing_rod/attack_hand(mob/living/user)
	if(anchored)
		if(!istype(get_step(src, dir), /turf/open/water))
			return
		if(user.isfishing)
			return
		if(!catching)
			catching = TRUE
			user.isfishing = TRUE
			playsound(loc, 'modular_darkpack/modules/deprecated/sounds/catching.ogg', 50, FALSE)
			if(do_after(user, 15 SECONDS, src))
				catching = FALSE
				user.isfishing = FALSE
				var/diceroll = rand(1, 20)
				var/obj/item/fish/darkpack/new_fish
				if(diceroll <= 5)
					new_fish = /obj/item/fish/darkpack/tuna
				else if(diceroll <= 10)
					new_fish = /obj/item/fish/darkpack/catfish
				else if(diceroll <= 15)
					new_fish = /obj/item/fish/darkpack/crab
				else
					new_fish = /obj/item/fish/darkpack/shark
				new new_fish(user.loc)
				playsound(loc, 'modular_darkpack/modules/deprecated/sounds/catched.ogg', 50, FALSE)
			else
				catching = FALSE
				user.isfishing = FALSE
		return
	. = ..()
*/
