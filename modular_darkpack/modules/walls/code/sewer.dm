/turf/open/floor/plating/canal
	name = "plating"
	icon = 'modular_darkpack/modules/walls/icons/floors.dmi'
	icon_state = "canal1"
	footstep = FOOTSTEP_FLOOR

/turf/open/floor/plating/canal/Enter(atom/movable/mover, atom/oldloc)
	. = ..()
	var/mob/living/living_mover = mover
	if(istype(living_mover) && living_mover.client)
		if(prob(0.5))
			var/cap = CONFIG_GET(number/ratcap)
			if(LAZYLEN(SSmobs.cheeserats) >= cap)
				return
			new /mob/living/basic/mouse/vampire(oldloc)

/turf/open/floor/plating/canal/Initialize(mapload)
	. = ..()
	icon_state = "canal[rand(1, 3)]"

/turf/open/floor/plating/canalplating
	name = "plating"
	icon = 'modular_darkpack/modules/walls/icons/floors.dmi'
	icon_state = "canal_plating1"
	footstep = FOOTSTEP_PARKET
	barefootstep = FOOTSTEP_PARKET

/turf/open/floor/plating/canalplating/Enter(atom/movable/mover, atom/oldloc)
	. = ..()
	var/mob/living/living_mover = mover
	if(istype(living_mover) && living_mover.client)
		if(prob(0.5))
			var/cap = CONFIG_GET(number/ratcap)
			if(LAZYLEN(SSmobs.cheeserats) >= cap)
				return
			new /mob/living/basic/mouse/vampire(oldloc)

/turf/open/floor/plating/canalplating/Initialize(mapload)
	. = ..()
	icon_state = "canal_plating[rand(1, 4)]"

/turf/open/water/vamp_sewer
	name = "sewage"
	icon = 'modular_darkpack/modules/walls/icons/floors.dmi'
	icon_state = "shit"
	fishing_datum = /datum/fish_source/sewer

/turf/open/water/vamp_sewer/Initialize(mapload)
	. = ..()
	if(prob(25))
		new /obj/effect/realistic_fog(src)

/turf/open/water/vamp_sewer/border
	icon_state = "shit_border"
