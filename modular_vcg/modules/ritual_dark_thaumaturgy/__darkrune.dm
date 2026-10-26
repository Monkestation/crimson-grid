/obj/ritual_rune/dark
	name = "dark rune"
	desc = "Learn and use the secrets of The Infernal."
	color = COLOR_VERY_DARK_LIME_GREEN
	word = "IDI NAH"
	required_discipline = /datum/discipline/daimonion
	activation_color = COLOR_DARK_LIME

/obj/ritual_rune/dark/complete()
	. = ..()
	playsound(loc, 'modular_darkpack/modules/powers/sounds/thaum.ogg', 50, FALSE)

/obj/ritual_rune/dark/ritual_failure()
	. = ..()
	playsound(loc, 'modular_darkpack/modules/powers/sounds/thaum.ogg', 50, FALSE)

/obj/ritual_rune/dark/ritual_botch()
	. = ..()
	playsound(loc, 'modular_darkpack/modules/powers/sounds/thaum.ogg', 50, FALSE)
