/mob/living/basic/pet/cat/darkpack
	icon_state = "cat3"
	base_icon_state = "cat"
	icon = 'modular_darkpack/master_files/icons/mobs/simple/pets.dmi'
	var/random_cat_color = TRUE

/mob/living/basic/pet/cat/darkpack/Initialize(mapload)
	. = ..()
	if(random_cat_color)
		var/id = rand(3, 9)
		icon_state = "[base_icon_state][id]"
		icon_living = "[base_icon_state][id]"
		icon_dead = "[base_icon_state][id]_dead"


/mob/living/basic/pet/cat/darkpack/tzi
	name = "Gene"
	bloodpool = 5
	maxbloodpool = 5
	icon_state = "cat_tzi"
	icon_living = "cat_tzi"
	icon_dead = "cat_tzi_dead"
	unique_pet = TRUE
	random_cat_color = FALSE

/mob/living/basic/pet/cat/darkpack/cain
	name = "Cain"
	health = 228
	bloodpool = 10
	maxbloodpool = 10
	unique_pet = TRUE

/mob/living/basic/pet/cat/darkpack/autun
	name = "Autun"
	unique_pet = TRUE

/mob/living/basic/pet/cat/darkpack/don
	name = "Don"
	unique_pet = TRUE

// Dont ask okay.
/mob/living/basic/pet/cat/darkpack/sproingus
	name = "Sproingus"
	unique_pet = TRUE

/mob/living/basic/pet/cat/darkpack/zleeby
	name = "Zleeby"
	unique_pet = TRUE
