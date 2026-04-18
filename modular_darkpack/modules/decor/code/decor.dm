/obj/structure/vampfence
	name = "\improper fence"
	desc = "Protects places from walking in."
	icon = 'modular_darkpack/modules/decor/icons/fence.dmi'
	icon_state = "fence"
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	density = TRUE

/obj/structure/vampfence/corner
	icon_state = "fence_corner"

/obj/structure/vampfence/rich
	icon = 'modular_darkpack/modules/deprecated/icons/32x48.dmi'

/obj/structure/vampfence/corner/rich
	icon = 'modular_darkpack/modules/deprecated/icons/32x48.dmi'

/obj/structure/vampfence/Initialize(mapload)
	.=..()
	AddElement(/datum/element/climbable)

/obj/structure/vampfence/rich/Initialize(mapload)
	.=..()
	RemoveElement(/datum/element/climbable)

/obj/structure/gargoyle
	name = "\improper gargoyle"
	desc = "Some kind of gothic architecture."
	icon = 'modular_darkpack/modules/deprecated/icons/32x48.dmi'
	icon_state = "gargoyle"
	pixel_z = 8
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE

/obj/structure/lamppost
	name = "lamppost"
	desc = "Gives some light to the streets."
	icon = 'modular_darkpack/modules/decor/icons/lamppost.dmi'
	base_icon_state = "base"
	layer = SPACEVINE_LAYER // Cant even with flav bro - Fallcon
	pixel_w = -32
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	var/number_of_lamps
	var/list/my_lights = list()

/obj/structure/lamppost/Initialize(mapload)
	. = ..()
	if(check_holidays(FESTIVE_SEASON))
		var/area/my_area = get_area(src)
		if(istype(my_area) && my_area.outdoors)
			icon_state = "[initial(icon_state)]-snow"
	switch(number_of_lamps)
		if(1)
			new_light(get_step(loc, dir))
		if(2)
			new_light(get_step(loc, dir))
			new_light(get_step(loc, turn(dir, 180)))
		if(3)
			new_light(get_step(loc, dir))
			new_light(get_step(loc, turn(dir, -90)))
			new_light(get_step(loc, turn(dir, 90)))
		if(4)
			new_light(get_step(loc, NORTH))
			new_light(get_step(loc, SOUTH))
			new_light(get_step(loc, EAST))
			new_light(get_step(loc, WEST))
		else
			new_light(loc)

/obj/structure/lamppost/proc/new_light(location)
	my_lights += new /obj/effect/decal/lamplight(location)

/obj/structure/lamppost/Destroy(force)
	QDEL_LIST(my_lights)
	. = ..()


/obj/effect/decal/lamplight
	alpha = 0

// DARKPACK TODO - Fix lol.
/obj/effect/decal/lamplight/NeverShouldHaveComeHere(turf/here_turf)
	return FALSE

/obj/effect/decal/lamplight/Initialize(mapload)
	. = ..()
	set_light(4, 3, "#ffde9b")

/obj/structure/lamppost/one
	icon_state = "one"
	number_of_lamps = 1

/obj/structure/lamppost/two
	icon_state = "two"
	number_of_lamps = 2

/obj/structure/lamppost/three
	icon_state = "three"
	number_of_lamps = 3

/obj/structure/lamppost/four
	icon_state = "four"
	number_of_lamps = 4

/obj/structure/lamppost/sidewalk
	icon_state = "civ"
	number_of_lamps = 5

/obj/structure/lamppost/sidewalk/chinese
	icon_state = "chinese"

/obj/structure/trafficlight
	name = "traffic light"
	desc = "Shows when road is free or not."
	icon = 'modular_darkpack/modules/decor/icons/lamppost.dmi'
	icon_state = "traffic"
	layer = SPACEVINE_LAYER
	pixel_w = -32
	anchored = TRUE

/obj/structure/trafficlight/Initialize(mapload)
	. = ..()
	if(check_holidays(FESTIVE_SEASON))
		var/area/my_area = get_area(src)
		if(istype(my_area) && my_area.outdoors)
			icon_state = "[initial(icon_state)]-snow"

/obj/structure/closet/crate/dumpster
	name = "dumpster"
	desc = "Holds garbage inside."
	icon = 'modular_darkpack/master_files/icons/obj/storage/crates32x32.dmi'
	icon_state = "garbage"
	base_icon_state = "garbage"
	drag_slowdown = 3
	var/internal_trash_chance = 75
	var/external_trash_chance = 10

/obj/structure/closet/crate/dumpster/Initialize(mapload)
	if(prob(25))
		icon_state = "garbageopen"
	. = ..()
	//Letting you clear the snow by opening and closing it is acctually pretty flavor
	if(check_holidays(FESTIVE_SEASON))
		var/area/my_area = get_area(src)
		if(istype(my_area) && my_area.outdoors)
			icon_state = "[base_icon_state]-snow"

/obj/structure/closet/crate/dumpster/PopulateContents()
	if(prob(internal_trash_chance))
		if(prob(95))
			new /obj/effect/spawner/random/trash/garbage(src)
		else //Pretty rare while the loot table is un-audited
			new /obj/effect/spawner/random/maintenance(src)
	if(prob(external_trash_chance))
		new /obj/effect/spawner/random/trash/grime(loc)

/obj/structure/closet/crate/dumpster/empty
	internal_trash_chance = 0
	external_trash_chance = 0

/obj/structure/trashbag
	name = "trash bags"
	desc = "Enough trashbags to block your way."
	icon = 'modular_darkpack/modules/decor/icons/trash.dmi'
	icon_state = "garbage1"
	density = TRUE
	anchored = TRUE

/obj/structure/trashbag/Initialize(mapload)
	. = ..()
	icon_state = "garbage[rand(7, 9)]"

/obj/structure/trashbag/Destroy()
	new /obj/effect/spawner/random/trash/garbage(loc)
	return ..()

/obj/structure/hotelbanner
	name = "banner"
	desc = "It says H O T E L."
	icon = 'modular_darkpack/modules/decor/icons/city_sign.dmi'
	icon_state = "banner"
	anchored = TRUE
	density = TRUE

/obj/structure/hotelbanner/Initialize(mapload)
	. = ..()
	if(check_holidays(FESTIVE_SEASON))
		var/area/my_area = get_area(src)
		if(istype(my_area) && my_area.outdoors)
			icon_state = "[initial(icon_state)]-snow"

/obj/structure/arc
	name = "chinatown arc"
	desc = "Cool chinese architecture."
	icon = 'modular_darkpack/modules/decor/icons/chinatown.dmi'
	icon_state = "ark1"
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE

/obj/structure/arc/Initialize(mapload)
	. = ..()
	if(check_holidays(FESTIVE_SEASON))
		var/area/my_area = get_area(src)
		if(istype(my_area) && my_area.outdoors)
			icon_state = "[initial(icon_state)]-snow"

/obj/structure/arc/add
	icon_state = "ark2"

/obj/structure/trad
	name = "traditional lamp"
	desc = "Cool chinese lamp."
	icon = 'modular_darkpack/modules/decor/icons/chinatown.dmi'
	icon_state = "trad"
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE

/obj/structure/vampipe
	name = "pipes"
	icon = 'modular_darkpack/modules/decor/icons/pipes.dmi'
	icon_state = "piping1"
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE

/obj/structure/vamproofwall
	name = "wall"
	icon = 'modular_darkpack/modules/decor/icons/roofwall.dmi'
	icon_state = "the_wall"
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE

/obj/structure/hydrant
	name = "hydrant"
	desc = "Used for firefighting."
	icon = 'modular_darkpack/modules/decor/icons/hydrant.dmi'
	icon_state = "hydrant"
	anchored = TRUE

/obj/structure/hydrant/Initialize(mapload)
	. = ..()
	if(check_holidays(FESTIVE_SEASON))
		var/area/my_area = get_area(src)
		if(istype(my_area) && my_area.outdoors)
			icon_state = "[initial(icon_state)]-snow"

/obj/structure/hydrant/mouse_drop_receive(atom/dropped, mob/user, params)
	if(HAS_TRAIT(user, TRAIT_DWARF)) //Only lean on the fire hydrant if we are smol
		//Adds the component only once. We do it here & not in Initialize(mapload) because there are tons of windows & we don't want to add to their init times
		LoadComponent(/datum/component/leanable, dropped)

/obj/structure/roadblock
	name = "\improper road block"
	desc = "Protects places from walking in."
	icon = 'modular_darkpack/modules/decor/icons/barriers.dmi'
	icon_state = "roadblock"
	anchored = TRUE
	density = TRUE

/obj/structure/roadblock/alt
	icon_state = "barrier"

// DARKPACK TODO - Does not pass the sniff test of being a decal. Make a structure
/obj/effect/decal/painting
	name = "painting"
	icon = 'modular_darkpack/modules/decor/icons/paintings.dmi'
	icon_state = "painting1"
	plane = GAME_PLANE
	layer = SIGN_LAYER

/obj/effect/decal/painting/second
	icon_state = "painting2"

/obj/effect/decal/painting/third
	icon_state = "painting3"

/obj/structure/painting/trad
	name = "chinese traditional ink painting"
	icon_state = "trad-art1"
	icon = 'modular_darkpack/modules/decor/icons/chinatown.dmi'
	desc = "Seems to be ink on a pleasant yellow canvas."
	layer = SIGN_LAYER

/obj/structure/painting/trad/second
	icon_state = "trad-art2"

/obj/structure/painting/trad/three
	icon_state = "trad-art3"

/obj/structure/fluff/shrine
	name = "altar shrine"
	desc = "An old rustic buddhist shrine, with a red cermaic roof."
	icon = 'modular_darkpack/modules/decor/icons/chinatown.dmi'
	icon_state = "budshrine"
	anchored = TRUE
	density = TRUE

/obj/structure/jesuscross
	name = "Jesus Christ on a cross"
	desc = "Jesus said, “Father, forgive them, for they do not know what they are doing.” And they divided up his clothes by casting lots (Luke 23:34)."
	icon = 'modular_darkpack/modules/deprecated/icons/64x64.dmi'
	icon_state = "cross"
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	density = TRUE
	pixel_w = -16
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF

/obj/structure/barrels
	name = "barrel"
	desc = "Storage some liquids."
	icon = 'modular_darkpack/modules/decor/icons/barrels.dmi'
	icon_state = "barrel1"
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	density = TRUE

/obj/structure/barrels/rand
	icon_state = "barrel2"

/obj/structure/barrels/rand/Initialize(mapload)
	. = ..()
	icon_state = "barrel[rand(1, 12)]"

/obj/structure/bricks
	name = "bricks"
	desc = "Building material."
	icon = 'modular_darkpack/modules/decor/icons/alleyway.dmi'
	icon_state = "bricks"
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	density = TRUE

/obj/effect/decal/pallet
	name = "pallet"
	icon = 'modular_darkpack/modules/decor/icons/alleyway.dmi'
	icon_state = "under1"

/obj/effect/decal/pallet/NeverShouldHaveComeHere(turf/here_turf)
	return FALSE

/obj/effect/decal/pallet/Initialize(mapload)
	. = ..()
	icon_state = "under[rand(1, 2)]"

/obj/cargotrain
	name = "cargocrate"
	desc = "It delivers a lot of things."
	icon = 'modular_darkpack/modules/decor/icons/containers.dmi'
	icon_state = "1"
	anchored = TRUE
	density = FALSE
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB | PASSGLASS | PASSCLOSEDTURF
	movement_type = PHASING
	var/mob/living/starter

/obj/cargotrain/Initialize(mapload)
	. = ..()
	icon_state = "[rand(2, 5)]"
	AddComponent(/datum/component/seethrough, SEE_THROUGH_CARGO_CRATE)

/obj/cargotrain/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	for(var/mob/living/L in get_step(src, movement_dir))
		if(isnpc(L))
			if(starter)
				if(ishuman(starter))
					var/mob/living/carbon/human/H = starter
					SEND_SIGNAL(H, COMSIG_PATH_HIT, -1, 0, FALSE)
		L.gib()
	. = ..()

/obj/cargocrate
	name = "cargocrate"
	desc = "It delivers a lot of things."
	icon = 'modular_darkpack/modules/decor/icons/containers.dmi'
	icon_state = "1"
	anchored = TRUE


/obj/cargocrate/Initialize(mapload)
	. = ..()
	icon_state = "[rand(1, 5)]"
	if(icon_state != "1")
		opacity = TRUE
		AddComponent(/datum/component/seethrough, SEE_THROUGH_CARGO_CRATE)
	set_density(TRUE)
	var/atom/movable/M1 = new(get_step(loc, EAST))
	var/atom/movable/M2 = new(get_step(M1.loc, EAST))
	var/atom/movable/M3 = new(get_step(M2.loc, EAST))
	M1.set_density(TRUE)
	if(icon_state != "1")
		M1.opacity = TRUE
	M1.anchored = TRUE
	M2.set_density(TRUE)
	if(icon_state != "1")
		M2.opacity = TRUE
	M2.anchored = TRUE
	M3.set_density(TRUE)
	if(icon_state != "1")
		M3.opacity = TRUE
	M3.anchored = TRUE

/proc/get_farthest_open_chain_turf(turf/start, dir = EAST, distance = 20)
	var/turf/current = start
	var/turf/last_open = null
	for(var/i = 1 to distance)
		current = get_step(current, dir)
		if(isopenturf(current))
			last_open = current
		else
			break
	return last_open || start

/obj/structure/marketplace
	name = "stock market"
	desc = "Recent stocks visualization."
	icon = 'modular_darkpack/modules/decor/icons/stonks.dmi'
	icon_state = "marketplace"
	anchored = TRUE
	density = TRUE
	pixel_w = -24
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF

/obj/structure/reagent_dispensers/cleaningfluid
	name = "cleaning fluid tank"
	desc = "A container filled with cleaning fluid."
	reagent_id = /datum/reagent/space_cleaner
	icon_state = "water"

/obj/underplate
	name = "underplate"
	icon = 'modular_darkpack/modules/decor/icons/restaurant.dmi'
	icon_state = "underplate"
	layer = TABLE_LAYER
	anchored = TRUE

/obj/underplate/stuff
	icon_state = "stuff"

/obj/structure/pole
	name = "stripper pole"
	desc = "A pole fastened to the ceiling and floor, used to show of ones goods to company."
	icon = 'modular_darkpack/modules/deprecated/icons/64x64.dmi'
	icon_state = "pole"
	density = TRUE
	anchored = TRUE
	var/icon_state_inuse
	layer = 4 //make it the same layer as players.
	density = FALSE //easy to step up on
	/// Is the pole in use currently?
	var/pole_in_use

/obj/structure/pole/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(pole_in_use)
		to_chat(user, "It's already in use - wait a bit.")
		return
	if(user.dancing)
		return
	else
		pole_in_use = TRUE
		user.setDir(SOUTH)
		user.Stun(100)
		user.forceMove(src.loc)
		user.visible_message("<B>[user] dances on [src]!</B>")
		animatepole(user)
		user.layer = layer //set them to the poles layer
		pole_in_use = FALSE
		user.pixel_y = 0
		icon_state = initial(icon_state)

/obj/structure/pole/proc/animatepole(mob/living/user)
	return

/obj/structure/pole/animatepole(mob/living/user)

	if (user.loc != src.loc)
		return
	animate(user,pixel_x = -6, pixel_y = 0, time = 10)
	sleep(20)
	user.dir = 4
	animate(user,pixel_x = -6,pixel_y = 24, time = 10)
	sleep(12)
	src.layer = 4.01 //move the pole infront for now. better to move the pole, because the character moved behind people sitting above otherwise
	animate(user,pixel_x = 6,pixel_y = 12, time = 5)
	user.dir = 8
	sleep(6)
	animate(user,pixel_x = -6,pixel_y = 4, time = 5)
	user.dir = 4
	src.layer = 4 // move it back.
	sleep(6)
	user.dir = 1
	animate(user,pixel_x = 0, pixel_y = 0, time = 3)
	sleep(6)
	user.do_jitter_animation()
	sleep(6)
	user.dir = 2

/obj/structure/fire_barrel
	name = "barrel"
	desc = "Some kind of light and warm source..."
	icon = 'modular_darkpack/modules/decor/icons/fires.dmi'
	icon_state = "fire_barrel_on_fire"
	anchored = TRUE
	density = TRUE
	light_range = 3
	light_power = 2
	light_color = "#ffa800"

/obj/structure/fountain
	name = "fountain"
	desc = "Gothic water structure."
	icon = 'modular_darkpack/modules/decor/icons/fountain.dmi'
	icon_state = "fountain"
	anchored = TRUE
	density = TRUE
	pixel_w = -16
	pixel_z = -16

/obj/effect/decal/graffiti
	name = "graffiti"
	icon = 'modular_darkpack/modules/deprecated/icons/32x48.dmi'
	icon_state = "graffiti1"
	pixel_z = 32
	anchored = TRUE
	var/large = FALSE

/obj/effect/decal/graffiti/NeverShouldHaveComeHere(turf/here_turf)
	return isclosedturf(here_turf)

/obj/effect/decal/graffiti/large
	pixel_w = -16
	icon = 'modular_darkpack/modules/deprecated/icons/64x64.dmi'
	large = TRUE

/obj/effect/decal/graffiti/Initialize(mapload)
	. = ..()
	if(!large)
		icon_state = "graffiti[rand(1, 15)]"
	else
		icon_state = "graffiti[rand(1, 3)]"

/obj/effect/decal/graffiti/NeverShouldHaveComeHere(turf/here_turf)
	return isclosedturf(here_turf)

/obj/effect/decal/kopatich
	name = "hide carpet"
	pixel_w = -16
	pixel_z = -16
	icon = 'modular_darkpack/modules/decor/icons/rugs64x64.dmi'
	icon_state = "kopatich"

/obj/effect/decal/baalirune
	name = "satanic rune"
	pixel_w = -16
	pixel_z = -16
	icon = 'modular_darkpack/modules/deprecated/icons/64x64.dmi'
	icon_state = "baali"
	var/rune_in_use = FALSE

/obj/effect/decal/baalirune/attack_hand(mob/living/user)
	. = ..()
	if(rune_in_use)
		return

	var/list/myriad_targets = list()
	for(var/mob/living/target in loc)
		if(!IS_DEAD_OR_INCAP(target))
			myriad_targets += target

	if(length(myriad_targets) < 20)
		visible_message(span_warning("The markings pulse with a small flash of red light, then fall dark."))
		var/oldcolor = color
		color = rgb(255, 0, 0)
		animate(src, color = oldcolor, time = 5)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_atom_colour)), 0.5 SECONDS)
		return

	rune_in_use = TRUE
	visible_message(span_warning("[src] pulses blood red!"))
	color = RUNE_COLOR_DARKRED
	playsound(get_turf(src), 'sound/effects/magic/demon_dies.ogg', 100, TRUE)
	new /mob/living/basic/baali_guard(get_turf(src))
	animate(src, color = initial(color), time = 0.5 SECONDS)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_atom_colour)), 0.5 SECONDS)
	for(var/mob/living/dead_victim as anything in myriad_targets)
		dead_victim.gib(DROP_ALL_REMAINS)
	rune_in_use = FALSE

/obj/structure/vampstatue
	name = "statue"
	desc = "A cloaked figure forgotten to the ages."
	icon = 'modular_darkpack/modules/deprecated/icons/32x64.dmi'
	icon_state = "statue"
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF

/obj/structure/vampstatue/angel
	name = "angel statue"
	desc = "An angel stands before you. You're glad it's only stone."
	icon = 'modular_darkpack/modules/deprecated/icons/64x64.dmi'
	icon_state = "angelstatue"

/obj/structure/vampstatue/cloaked
	name = "cloaked figure"
	desc = "He appears to be sitting."
	icon = 'modular_darkpack/modules/deprecated/icons/32x48.dmi'
	icon_state = "cloakedstatue"

/obj/structure/bath
	name = "bath"
	desc = "Not big enough for hiding in."
	icon = 'modular_darkpack/modules/decor/icons/bathroom.dmi'
	icon_state = "tub"
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF

/obj/weapon_showcase
	name = "weapon showcase"
	desc = "Look, a gun."
	icon = 'modular_darkpack/modules/decor/icons/showcase.dmi'
	icon_state = "showcase"
	density = TRUE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF

/obj/weapon_showcase/Initialize(mapload)
	. = ..()
	icon_state = "showcase[rand(1, 7)]"

/obj/effect/decal/carpet
	name = "carpet"
	pixel_w = -16
	pixel_z = -16
	icon = 'modular_darkpack/modules/decor/icons/rugs64x64.dmi'
	icon_state = "kover"

/obj/structure/bury_pit
	name = "bury pit"
	desc = "You can bury someone here."
	icon = 'modular_darkpack/modules/decor/icons/bury_pit.dmi'
	icon_state = "pit0"
	layer = ABOVE_OPEN_TURF_LAYER
	plane = FLOOR_PLANE
	anchored = TRUE
	density = FALSE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/pit_busy = FALSE

/obj/structure/bury_pit/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(tool.tool_behaviour == TOOL_SHOVEL)
		if(pit_busy)
			return ITEM_INTERACT_BLOCKING

		pit_busy = TRUE
		user.visible_message(span_warning("[user] starts to dig [src]"), span_warning("You start to dig [src]."))
		if(!do_after(user, 10 SECONDS, src))
			pit_busy = FALSE

		pit_busy = FALSE
		if(icon_state == "pit0")
			for(var/mob/living/L in get_turf(src))
				L.forceMove(src)
				icon_state = "pit1"
				user.visible_message(span_warning("[user] digs a hole in [src]."), span_warning("You dig a hole in [src]."))
		else
			for(var/mob/living/L in src)
				L.forceMove(get_turf(src))
			icon_state = "pit0"
			user.visible_message(span_warning("[user] digs a hole in [src]."), span_warning("You dig a hole in [src]."))

/obj/structure/bury_pit/container_resist_act(mob/living/user)
	if(pit_busy)
		return

	pit_busy = TRUE
	if(!do_after(user, 30 SECONDS, src))
		pit_busy = FALSE

	for(var/mob/living/L in src)
		L.forceMove(get_turf(src))
	icon_state = "pit0"
	pit_busy = FALSE


/obj/structure/fluff/tv
	name = "\improper TV"
	desc = "A slightly battered looking TV. Various infomercials play on a loop, accompanied by a jaunty tune."
	icon = 'modular_darkpack/modules/decor/icons/television.dmi'
	icon_state = "tv_news"

/obj/structure/fluff/tv/order
	name = "order screen"
	desc = "A slightly battered looking TV. It shows a menu to order from."
	icon = 'modular_darkpack/modules/decor/icons/restaurant.dmi'
	icon_state = "order1"

/obj/structure/fluff/tv/order/one
	icon_state = "order1"

/obj/structure/fluff/tv/order/two
	icon_state = "order2"

/obj/structure/fluff/tv/order/three
	icon_state = "order3"

/obj/structure/fluff/tv/order/four
	icon_state = "order4"

/obj/structure/fluff/tv/order/random

/obj/structure/fluff/tv/order/random/Initialize(mapload)
	. = ..()
	icon_state = "order[rand(1,4)]"

/obj/structure/projector
	name = "projector"
	icon = 'icons/obj/machines/stationary_camera.dmi'
	icon_state = "camera"
