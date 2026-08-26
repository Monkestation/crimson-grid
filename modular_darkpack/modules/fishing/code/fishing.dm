/obj/item/fish/darkpack
	abstract_type = /obj/item/fish/darkpack
	desc = "marine life"
	icon = 'modular_darkpack/modules/fishing/icons/fish.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/fishing/icons/fish_onfloor.dmi')
	w_class = WEIGHT_CLASS_SMALL
	//eatsound = 'modular_darkpack/modules/food/sounds/eat.ogg'

/obj/item/fish/darkpack/shark
	name = "leopard shark"
	icon_state = "shark"
	icon = 'modular_darkpack/modules/fishing/icons/fish48x32.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/fishing/icons/fish_onfloor.dmi')
	base_pixel_w = -16
	pixel_w = -16
	fish_id = "darkpack_shark"
	required_fluid_type = AQUARIUM_FLUID_SALTWATER

	average_size = 60
	average_weight = 1400
	stable_population = 4

	dedicated_in_aquarium_icon_state = "fish_greyscale"
	aquarium_vc_color = "#33302e"
	sprite_width = 5
	sprite_height = 3

/obj/item/fish/darkpack/shark/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 50, "fish", FALSE)
//CRIMSON GRID EDIT ADDED HALVED SELLING PRICE
/obj/item/fish/darkpack/tuna
	name = "bluefin tuna"
	icon_state = "fish"
	fish_id = "darkpack_tuna"
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	num_fillets = 2

	stable_population = 9
	average_size = 50
	average_weight = 600

	dedicated_in_aquarium_icon_state = "fish_greyscale"
	aquarium_vc_color = "#33302e"
	sprite_width = 5
	sprite_height = 3

/obj/item/fish/darkpack/tuna/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 4, "fish", FALSE)
//CRIMSON GRID EDIT ADDED MADE THE PRICE SMALLER BY ONE DIGIT
/obj/item/fish/darkpack/catfish
	name = "channel catfish"
	icon_state = "catfish"
	fish_id = "darkpack_catfish"
	required_fluid_type = AQUARIUM_FLUID_SALTWATER

	stable_population = 9
	average_size = 55
	average_weight = 800

	dedicated_in_aquarium_icon_state = "fish_greyscale"
	aquarium_vc_color = "#33302e"
	sprite_width = 5
	sprite_height = 3

/obj/item/fish/darkpack/catfish/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 2, "fish", FALSE)
//CRIMSON GRID EDIT ADDED MADE THE PRICE SMALLER BY ONE DIGIT
/obj/item/fish/darkpack/crab
	name = "dungeness crab"
	icon_state = "crab"
	fillet_type = /obj/item/food/meat/slab/rawcrab
	fish_id = "darkpack_crab"
	required_fluid_type = AQUARIUM_FLUID_SALTWATER

	stable_population = 8
	average_size = 50
	average_weight = 600

	dedicated_in_aquarium_icon_state = "crab_small"
	sprite_height = 6
	sprite_width = 10

/obj/item/fish/darkpack/crab/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 7, "fish", FALSE)
//CRIMSON GRID EDIT ADDED MADE THE PRICE SMALLER BY ONE DIGIT
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
