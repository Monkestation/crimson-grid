/obj/ritual_rune/abyss
	name = "abyss rune"
	desc = "Learn the secrets of the Abyss, neonate..."
	color = rgb(0, 0, 0)
	word = "IDI NAH"
	required_discipline = /datum/discipline/obtenebration
	activation_color = rgb(50, 50, 50)

/obj/ritual_rune/abyss/complete()
	. = ..()
	playsound(loc, 'sound/effects/magic/voidblink.ogg', 50, FALSE)

/obj/ritual_rune/abyss/ritual_failure()
	. = ..()
	playsound(loc, 'sound/effects/magic/voidblink.ogg', 50, FALSE)

/obj/ritual_rune/abyss/ritual_botch()
	. = ..()
	playsound(loc, 'sound/effects/magic/voidblink.ogg', 50, FALSE)
