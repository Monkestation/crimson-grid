/mob/living/basic/pet/dog/darkpack
	name = "dog"
	icon_state = "dog1"
	desc = "That's an ouppy."
	base_icon_state = "dog"
	icon = 'modular_darkpack/master_files/icons/mobs/simple/pets.dmi'
	var/random_dog_color = TRUE
	var/color_id = 1
	mobility_flags = MOBILITY_FLAGS_REST_CAPABLE_DEFAULT

/mob/living/basic/pet/dog/darkpack/Initialize(mapload)
	. = ..()
	add_verb(src, /mob/living/proc/toggle_resting)
	if(random_dog_color)
		color_id = rand(1, 6)
	icon_state = "[base_icon_state][color_id]"
	icon_living = "[base_icon_state][color_id]"
	icon_dead = "[base_icon_state][color_id]_dead"

/mob/living/basic/pet/dog/darkpack/update_icon_state()
	. = ..()
	if(stat != DEAD)
		if(resting)
			icon_state = "[icon_living]_rest"
		else
			icon_state = "[icon_living]"

/mob/living/basic/pet/dog/darkpack/ginger
	color_id = 1
	random_dog_color = FALSE

/mob/living/basic/pet/dog/darkpack/white
	color_id = 2
	random_dog_color = FALSE

/mob/living/basic/pet/dog/darkpack/black
	color_id = 3
	random_dog_color = FALSE

/mob/living/basic/pet/dog/darkpack/gray
	color_id = 4
	random_dog_color = FALSE

/mob/living/basic/pet/dog/darkpack/red
	color_id = 5
	random_dog_color = FALSE

/mob/living/basic/pet/dog/darkpack/gray
	color_id = 6
	random_dog_color = FALSE
