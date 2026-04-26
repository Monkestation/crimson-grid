/obj/ritual_rune/thaumaturgy/teleport
	name = "teleportation"
	desc = "Move your body among the city streets. Requires a bloodpack."
	icon_state = "rune6"
	word = "CLAV'TRANSITUM"
	level = 5
	sacrifices = list(/obj/item/reagent_containers/blood)

/obj/ritual_rune/thaumaturgy/teleport/complete()
	. = ..()
	if(!activated)
		activated = TRUE
		color = rgb(255,255,255)
		icon_state = "teleport"

/obj/ritual_rune/thaumaturgy/teleport/attack_hand(mob/user)
	. = ..()
	if(activated)
		if(last_activator != user)
			to_chat(user, span_warning("You are not the one who activated this rune!"))
			return
		var/direction = tgui_input_list(user, "Choose direction:", "Teleportation Rune", list("North", "East", "South", "West"))
		if(direction)
			var/x_dir = user.x
			var/y_dir = user.y
			var/step = 1
			var/min_distance = 10
			var/max_distance = 20
			var/valid_destination = FALSE
			var/turf/destination = null

			if(get_dist(src, user) > 1)
				to_chat(user, span_warning("You moved away from the rune!"))
				return

			// Move at least min_distance tiles in the chosen direction
			while(step <= min_distance)
				switch(direction)
					if("North")
						y_dir += 1
					if("East")
						x_dir += 1
					if("South")
						y_dir -= 1
					if("West")
						x_dir -= 1
				step += 1

			// Continue moving until a valid destination is found or max_distance is reached
			while(step <= max_distance && !valid_destination)
				switch(direction)
					if("North")
						y_dir += 1
					if("East")
						x_dir += 1
					if("South")
						y_dir -= 1
					if("West")
						x_dir -= 1

				if(x_dir < 15 || x_dir > 240 || y_dir < 15 || y_dir > 240)
					to_chat(user, span_warning("You can't teleport outside the city!"))
					return

				destination = locate(x_dir, y_dir, user.z)
				if(destination && !istype(destination, /turf/open/space/basic) && !istype(destination, /turf/closed/wall/vampwall))
					valid_destination = TRUE
				else
					step += 1

			if(valid_destination)
				playsound(loc, 'modular_darkpack/modules/powers/sounds/thaum.ogg', 50, FALSE)
				user.forceMove(destination)
				qdel(src)
			else
				to_chat(user, span_warning("The spell fails as no destination is found!"))


