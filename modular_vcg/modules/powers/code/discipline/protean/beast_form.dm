// Protean 4 buffs
/mob/living/basic/pet/dog/wolf/protean
	maxHealth = 400
	health = 400
	melee_damage_lower = 40
	melee_damage_upper = 40
	melee_attack_cooldown = 8
	random_wolf_color = FALSE
	speed = -0.4

/mob/living/basic/pet/dog/wolf/protean/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swing_attack)


/mob/living/basic/pet/dog/darkpack/protean
	melee_attack_cooldown = 8
	speed = -0.6
	random_dog_color = FALSE

/mob/living/basic/pet/dog/darkpack/protean/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swing_attack)


/mob/living/basic/bear/vampire/protean
	maxHealth = 500
	health = 500
	melee_damage_lower = 60
	melee_damage_upper = 60
	melee_attack_cooldown = 10
	speed = -0.2
	slowed_by_drag = FALSE

/mob/living/basic/bear/vampire/protean/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swing_attack)

// FLIGHT FORMS
/mob/living/basic/corvid/protean
	mob_size = MOB_SIZE_SMALL
	speed = -0.6

/mob/living/basic/pet/cat/protean
	name = "cat"
	desc = "Kitty!!"
	maxHealth = 300
	health = 300
	speed = -0.8
	melee_damage_lower = 10
	melee_damage_upper = 10
	melee_attack_cooldown = 4
	mob_size = MOB_SIZE_SMALL
	icon_state = "cat3"
	icon_living = "cat3"
	icon_dead = "cat3_dead"
	base_icon_state = "cat3"
	icon = 'modular_darkpack/master_files/icons/mobs/simple/pets.dmi'
	attack_verb_continuous = "claws"
	attack_verb_simple = "claw"
	attack_sound = 'sound/items/weapons/slash.ogg'
	attack_vis_effect = ATTACK_EFFECT_CLAW
	can_breed = FALSE

/mob/living/basic/pet/cat/protean/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swing_attack)

/datum/action/cooldown/spell/shapeshift/gangrel/beast_form
	var/chosen_icon_state
	var/static/list/shape_colors = list(
		/mob/living/basic/pet/cat/protean = list(
			"brown" = "cat3",
			"white" = "cat4",
			"black" = "cat5",
			"gray" = "cat6",
			"blue" = "cat7",
			"tabby" = "cat8",
			"silver" = "cat9",
		),
		/mob/living/basic/pet/dog/wolf/protean = list(
			"black" = "wolf1",
			"gray" = "wolf2",
			"red" = "wolf3",
			"white" = "wolf4",
			"ginger" = "wolf5",
			"brown" = "wolf6",
		),
		/mob/living/basic/pet/dog/darkpack/protean = list(
			"ginger" = "dog1",
			"white" = "dog2",
			"black" = "dog3",
			"gray" = "dog4",
			"red" = "dog5",
			"olive" = "dog6",
		),
		/mob/living/basic/corvid/protean = list(
			"black" = "black",
			"brown" = "brown",
			"white" = "white",
			"green" = "green",
			"gray" = "gray",
			"red" = "red",
		),
	)

/datum/action/cooldown/spell/shapeshift/gangrel/beast_form/Grant(mob/grant_to)
	. = ..()
	if(!ishuman(grant_to))
		return
	var/mob/living/carbon/human/grant_to_human = grant_to
	if(grant_to_human.is_clan(/datum/subsplat/vampire_clan/gangrel) || grant_to_human.is_clan(/datum/subsplat/vampire_clan/setite/tlacique)) // Host requested
		possible_shapes |= /mob/living/basic/pet/cat/protean

/datum/action/cooldown/spell/shapeshift/gangrel/beast_form/before_cast(mob/living/cast_on)
	if(shapeshift_type)
		return ..()

	. = ..()
	if(. & SPELL_CANCEL_CAST)
		shapeshift_type = null
		return

	var/list/colors = shape_colors[shapeshift_type]
	if(!colors)
		return

	var/atom/shape_path = shapeshift_type
	var/list/color_images = list()
	for(var/color_name in colors)
		color_images[color_name] = image(icon = initial(shape_path.icon), icon_state = colors[color_name])

	var/picked_color = show_radial_menu(
		cast_on,
		cast_on,
		color_images,
		custom_check = CALLBACK(src, PROC_REF(check_menu), cast_on),
		radius = 38,
		tooltips = TRUE,
	)
	if(!picked_color || QDELETED(src) || QDELETED(owner) || !can_cast_spell(feedback = FALSE))
		shapeshift_type = null
		return . | SPELL_CANCEL_CAST

	chosen_icon_state = colors[picked_color]

/datum/action/cooldown/spell/shapeshift/gangrel/beast_form/create_shapeshift_mob(atom/loc)
	var/mob/living/basic/new_shape = ..()
	if(!chosen_icon_state)
		return new_shape

	new_shape.icon_living = chosen_icon_state
	if(istype(new_shape, /mob/living/basic/corvid))
		var/mob/living/basic/corvid/crow = new_shape
		crow.sprite_color = chosen_icon_state
		crow.icon_dead = chosen_icon_state
	else
		new_shape.icon_dead = "[chosen_icon_state]_dead"
	new_shape.update_appearance(UPDATE_ICON)
	return new_shape
