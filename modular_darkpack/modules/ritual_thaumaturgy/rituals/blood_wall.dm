/obj/ritual_rune/thaumaturgy/blood_wall
	name = "blood wall"
	desc = "Creates the Blood Wall to protect tremere or his domain."
	icon_state = "rune3"
	word = "SOT'PY-O"
	level = 2

/obj/ritual_rune/thaumaturgy/blood_wall/complete()
	. = ..()
	new /obj/structure/bloodwall(loc)
	qdel(src)

/obj/structure/bloodwall
	name = "blood wall"
	desc = "Wall from BLOOD."
	icon = 'modular_darkpack/modules/deprecated/icons/icons.dmi'
	icon_state = "bloodwall"
	plane = GAME_PLANE
	layer = ABOVE_MOB_LAYER
	anchored = TRUE
	density = TRUE
	max_integrity = 100
