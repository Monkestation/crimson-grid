/obj/ritual_rune/abyss/blackout //not canon wod material, seemed a cool idea.
	name = "blackout"
	desc = "Destroys every wall light in range of the rune."
	icon_state = "rune7"
	word = "FYU'SES BLO'OUN"
	level = 2
	cost = 1

//actual function of the rune
/obj/ritual_rune/abyss/blackout/complete()
	. = ..()
	for(var/obj/machinery/light/light_to_kill in range(7, src)) //for every light in a range of 7 (called i)
		if(light_to_kill != LIGHT_BROKEN) //if it aint broke
			light_to_kill.break_light_tube(0) //break it
	qdel(src) //delete the rune
