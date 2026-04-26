/obj/ritual_rune/abyss/selfgib
	name = "self destruction"
	desc = "Meet the Final Death."
	icon_state = "rune2"
	word = "YNT FRM MCHGN FYNV DN THS B'FO" //'youre not from michigan if youve never done this before'
	cost = 1

/obj/ritual_rune/abyss/selfgib/complete()
	. = ..()
	last_activator.death()
