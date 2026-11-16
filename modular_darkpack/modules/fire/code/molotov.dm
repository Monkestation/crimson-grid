/obj/item/molotov
	name = "molotov cocktail"
	desc = "A throwing weapon used to ignite things, typically filled with an accelerant. Recommended highly by rioters and revolutionaries. Light and toss."
	icon_state = "molotov"
	icon = 'modular_darkpack/modules/weapons/icons/weapons.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	w_class = WEIGHT_CLASS_SMALL
	var/active = FALSE
	var/explode_timer

/obj/item/molotov/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_CONTRABAND, INNATE_TRAIT)

/obj/item/molotov/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	explode()

/obj/item/molotov/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(I.get_temperature() && !active)
		activate()

/obj/item/molotov/proc/activate(mob/user)
	active = TRUE
	log_bomber(user, "has primed a", src, "for detonation")
	icon_state = "molotov_flamed"

	explode_timer = addtimer(CALLBACK(src, PROC_REF(explode)), rand(15 SECONDS, 45 SECONDS), TIMER_STOPPABLE | TIMER_DELETE_ME)

/obj/item/molotov/proc/explode()
	deltimer(explode_timer)

	var/turf/explode_location = get_turf(src)

	for(var/turf/open/floor in circle_view_turfs(explode_location, 2))
		new /obj/effect/decal/cleanable/gasoline(floor)

	if(active)
		explode_location.ignite_turf(30)

	playsound(explode_location, 'modular_darkpack/modules/fire/sounds/explode.ogg', 100, TRUE)
	qdel(src)
