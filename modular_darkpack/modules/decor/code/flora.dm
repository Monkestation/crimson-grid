/obj/structure/flora/tree/vamp
	name = "tree"
	desc = "Cute and tall flora."
	icon = 'modular_darkpack/modules/decor/icons/trees.dmi'
	icon_state = "tree1"
	SET_BASE_PIXEL(-32,0)
	var/burned = FALSE

/obj/structure/flora/tree/vamp/Initialize(mapload)
	. = ..()
	icon_state = "tree[rand(1, 11)]"
	var/area/my_area = get_area(src)
	if(istype(my_area) && my_area.outdoors)
		if(check_holidays(FESTIVE_SEASON))
			icon_state = "[initial(icon_state)][rand(1, 11)]-snow"

		AddElement(/datum/element/swaying, sway_angle = 4, sway_time = 4 SECONDS, pivot_offset = 48)


/obj/structure/flora/tree/vamp/get_seethrough_map()
	return SEE_THROUGH_MAP_DEFAULT

/obj/structure/flora/tree/vamp/proc/burnshit()
	if(!burned)
		burned = TRUE
		icon_state = "dead[rand(1, 3)]"
		animate(src, transform = null, time = 1 SECONDS, loop = 1)

/obj/structure/flora/tree/vamp/pine
	name = "pine"
	desc = "Cute and tall flora."
	icon = 'modular_darkpack/modules/decor/icons/pines.dmi'
	icon_state = "pine1"

/obj/structure/flora/tree/vamp/pine/Initialize(mapload)
	. = ..()
	icon_state = "pine[rand(1, 4)]"
	var/area/my_area = get_area(src)
	if(istype(my_area) && my_area.outdoors)
		if(check_holidays(FESTIVE_SEASON))
			icon_state = "pine[rand(1, 4)]-snow"
		if(prob(2))
			burnshit()

		if(!burned)
			AddElement(/datum/element/swaying, sway_angle = 4, sway_time = 6 SECONDS, pivot_offset = 128)

/obj/structure/flora/tree/vamp/pine/burnshit()
	if(!burned)
		burned = TRUE
		icon_state = "dead[rand(1, 5)]"
		animate(src, transform = null, time = 1 SECONDS, loop = 1)

/obj/structure/flora/tree/vamp/pine/get_seethrough_map()
	return SEE_THROUGH_MAP_THREE_X_THREE

/obj/structure/flora/tree/vamp/pine/burnshit()
	if(!burned)
		burned = TRUE
		icon_state = "dead[rand(1, 5)]"


/obj/structure/flora/grass/tall
	icon_state = "tallgrass_1"
	icon = 'modular_darkpack/modules/decor/icons/flora32x48.dmi'

/obj/structure/flora/grass/tall/style_2
	icon_state = "tallgrass_2"

/obj/structure/flora/grass/tall/style_3
	icon_state = "tallgrass_3"

/obj/structure/flora/grass/tall/style_4
	icon_state = "tallgrass_4"

/obj/structure/flora/grass/tall/style_random/Initialize(mapload)
	. = ..()
	icon_state = "tallgrass_[rand(1, 4)]"
	update_appearance()

/obj/structure/flora/grass/tall/dry
	icon_state = "drytallgrass_1"

/obj/structure/flora/grass/tall/dry/style_2
	icon_state = "drytallgrass_2"

/obj/structure/flora/grass/tall/dry/style_3
	icon_state = "drytallgrass_3"

/obj/structure/flora/grass/tall/dry/style_4
	icon_state = "drytallgrass_4"

/obj/structure/flora/grass/tall/dry/style_random/Initialize(mapload)
	. = ..()
	icon_state = "drytallgrass_[rand(1, 4)]"
	update_appearance()

/obj/structure/flora/grass/short
	icon_state = "grass_1"
	icon = 'modular_darkpack/modules/decor/icons/flora32x48.dmi'

/obj/structure/flora/grass/short/style_2
	icon_state = "grass_2"

/obj/structure/flora/grass/short/style_3
	icon_state = "grass_3"

/obj/structure/flora/grass/short/style_4
	icon_state = "grass_4"

/obj/structure/flora/grass/short/style_random/Initialize(mapload)
	. = ..()
	icon_state = "grass_[rand(1, 4)]"
	update_appearance()

/obj/structure/flora/bush/redflower
	icon_state = "redplant_1"
	icon = 'modular_darkpack/modules/decor/icons/flora32x48.dmi'

/obj/structure/flora/bush/redflower/style_2
	icon_state = "redplant_2"

/obj/structure/flora/bush/redflower/style_3
	icon_state = "redplant_3"

/obj/structure/flora/bush/redflower/style_4
	icon_state = "redplant_4"

/obj/structure/flora/bush/redflower/style_random/Initialize(mapload)
	. = ..()
	icon_state = "redplant_[rand(1, 4)]"
	update_appearance()


/obj/structure/flora/rock/darkpack
	icon_state = "rock1"
	icon = 'modular_darkpack/modules/decor/icons/flora.dmi'

/obj/structure/flora/rock/darkpack/Initialize(mapload)
	. = ..()
	icon_state = "rock[rand(1, 9)]"

/obj/structure/flora/rock/pile/darkpack
	icon_state = "smallrock1"
	icon = 'modular_darkpack/modules/decor/icons/flora.dmi'

/obj/structure/flora/rock/pile/darkpack/Initialize(mapload)
	. = ..()
	icon_state = "smallrock[rand(1, 6)]"

/obj/structure/flora/rock/darkpack_big
	icon_state = "rock1"
	icon = 'modular_darkpack/modules/decor/icons/flora64x64.dmi'
	pixel_w = -16

/obj/structure/flora/rock/darkpack_big/Initialize(mapload)
	. = ..()
	icon_state = "rock[rand(1, 4)]"

/obj/structure/flora/rock/stalagmite
	icon_state = "stalagmite1"
	icon = 'modular_darkpack/modules/decor/icons/flora64x64.dmi'
	pixel_w = -16
	var/datum/looping_sound/slow_drip/looping_drips
	var/drip_chance = 75

/obj/structure/flora/rock/stalagmite/Initialize(mapload)
	. = ..()
	icon_state = "stalagmite[rand(1, 5)]"
	if(prob(drip_chance))
		looping_drips = new(src, TRUE)

/obj/structure/flora/rock/stalagmite/Destroy(force)
	. = ..()
	QDEL_NULL(looping_drips)

/obj/effect/spawner/random/flora
	icon_state = "flower"
	abstract_type = /obj/effect/spawner/random/flora

/obj/effect/spawner/random/flora/all
	loot = list(
		/obj/effect/spawner/random/flora/grass = 5,
		/obj/effect/spawner/random/flora/bushes = 2,
		/obj/effect/spawner/random/flora/rocks = 1
	)

/obj/effect/spawner/random/flora/grass
	loot = list(
		/obj/structure/flora/bush/fullgrass/style_random = 3,
		/obj/structure/flora/bush/sparsegrass/style_random = 2,
		/obj/structure/flora/bush/lavendergrass/style_random = 2,
		/obj/structure/flora/bush/style_random = 1
	)

/obj/effect/spawner/random/flora/bushes
	loot = list(
		/obj/structure/flora/grass/tall/style_random = 4,
		/obj/structure/flora/grass/short/style_random = 3,
		/obj/structure/flora/bush/fullgrass/style_random = 2,
		/obj/structure/flora/grass/tall/dry/style_random = 1,
		/obj/structure/flora/bush/redflower/style_random = 1,
	)

/obj/effect/spawner/random/flora/rocks
	loot = list(/obj/structure/flora/rock/pile/darkpack = 5, /obj/structure/flora/rock/darkpack = 1)

/obj/effect/spawner/random/flora/flowers
	loot = list(
		/obj/structure/flora/bush/lavendergrass/style_random = 1,
		/obj/structure/flora/bush/flowers_yw/style_random = 1,
		/obj/structure/flora/bush/flowers_br/style_random = 1,
		/obj/structure/flora/bush/flowers_pp/style_random = 1,
		/obj/effect/spawner/random/flora/flowers/unique = 1,
	)

/obj/effect/spawner/random/flora/flowers/unique
	loot = list(
		/obj/structure/flora/darkpack_flower/marigold,
		/obj/structure/flora/darkpack_flower/flax,
		/obj/structure/flora/darkpack_flower/bluestar,
		/obj/structure/flora/darkpack_flower/primrose,
		/obj/structure/flora/darkpack_flower/turtleback,
		/obj/structure/flora/darkpack_flower/yerba,
		/obj/structure/flora/darkpack_flower/paintbrush
	)

/obj/structure/flora/darkpack_flower
	icon = 'modular_darkpack/modules/decor/icons/flowers.dmi'
	desc = "A common wildflower."
	abstract_type = /obj/structure/flora/darkpack_flower
	flora_flags = FLORA_HERBAL

/obj/structure/flora/darkpack_flower/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swaying, sway_angle = 4, sway_time = 2 SECONDS)

/obj/structure/flora/darkpack_flower/marigold
	name = "marigold"
	icon_state = "marigold"

/obj/structure/flora/darkpack_flower/flax
	name = "prairie flax"
	icon_state = "prairie_flax"

/obj/structure/flora/darkpack_flower/bluestar
	name = "wooly bluestar"
	icon_state = "wooly_bluestar"

/obj/structure/flora/darkpack_flower/primrose
	name = "evening primrose"
	icon_state = "evening_primrose"

/obj/structure/flora/darkpack_flower/turtleback
	name = "velvet turtleback"
	icon_state = "velvet_turtleback"

/obj/structure/flora/darkpack_flower/yerba
	name = "yerba mansa"
	icon_state = "yerba_mansa"

/obj/structure/flora/darkpack_flower/paintbrush
	name = "indian paintbrush"
	icon_state = "indian_paintbrush"
