#define COAT_BLACK 1 // wolf1
#define COAT_GRAY 2 // wolf2
#define COAT_RED 3 // wolf3
#define COAT_WHITE 4 // wolf4
#define COAT_GINGER 5 // wolf5
#define COAT_BROWN 6 // wolf6

#define TYPE_MUNDANE "wolf"
#define TYPE_KINFOLK "kinfolk"

#define WOLF_COAT_HELPER(wolf_type)	\
	##wolf_type/black {	\
		random_wolf_color = FALSE; \
		coat_color = COAT_BLACK; \
	}	\
	##wolf_type/gray {	\
		random_wolf_color = FALSE; \
		coat_color = COAT_GRAY; \
	}	\
	##wolf_type/red {	\
		random_wolf_color = FALSE; \
		coat_color = COAT_RED; \
	}	\
	##wolf_type/white {	\
		random_wolf_color = FALSE; \
		coat_color = COAT_WHITE; \
	}	\
	##wolf_type/ginger {	\
		random_wolf_color = FALSE; \
		coat_color = COAT_GINGER; \
	}	\
	##wolf_type/brown {	\
		random_wolf_color = FALSE; \
		coat_color = COAT_BROWN; \
	}

/mob/living/basic/pet/dog/wolf
	name = "wolf"
	icon_state = "wolf1"
	desc = "That's a big, scary wolf. Might be best to steer clear."
	base_icon_state = "wolf"
	icon = 'modular_darkpack/modules/werewolf_the_apocalypse/icons/garou_forms/wolf.dmi'
	var/random_wolf_color = TRUE
	var/coat_color = COAT_BLACK
	var/wolf_type = TYPE_MUNDANE
	basic_mob_flags = NONE
	mobility_flags = MOBILITY_FLAGS_REST_CAPABLE_DEFAULT
	mob_size = MOB_SIZE_HUMAN // big guy

	butcher_results = list(
		/obj/item/food/meat/slab = 2,
		/obj/item/stack/sheet/bone = 2
	)

	var/sprite_eye_color = "#FFFFFF"

	maxHealth = 120
	health = 120
	obj_damage = 15
	melee_damage_lower = 7.5
	melee_damage_upper = 7.5
	attack_vis_effect = ATTACK_EFFECT_BITE
	melee_attack_cooldown = 1.2 SECONDS

	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	death_message = "snarls its last and perishes."

	attack_sound = 'sound/items/weapons/bite.ogg'
	move_force = MOVE_FORCE_WEAK
	move_resist = MOVE_FORCE_WEAK
	pull_force = MOVE_FORCE_WEAK

	ai_controller = /datum/ai_controller/basic_controller/wolf

	var/can_tame = TRUE

/mob/living/basic/pet/dog/wolf/Initialize(mapload)
	. = ..()
	add_verb(src, /mob/living/proc/toggle_resting)
	if(random_wolf_color)
		coat_color = rand(1, 6)

	icon_state = "[base_icon_state][coat_color]"
	icon_living = "[base_icon_state][coat_color]"
	icon_dead = "[base_icon_state][coat_color]_dead"

//	AddElement(/datum/element/ai_retaliate)
	update_appearance(UPDATE_ICON)

/mob/living/basic/pet/dog/wolf/examine(mob/user)
	. = ..()
	var/datum/splat/werewolf/wolp_splat = get_werewolf_splat(user)
	if(istype(wolp_splat?.auspice, /datum/subsplat/werewolf/auspice/garou/philodox))
		if(wolf_type == TYPE_KINFOLK)
			. += span_purple("On closer inspection, they appear to be kin.")
		if(HAS_TRAIT(src, TRAIT_WYRMTAINTED))
			. += span_warning("They are strongly wyrm-tainted.")


/mob/living/basic/pet/dog/wolf/add_obey_commands()
	var/static/list/pet_commands = list(
		/datum/pet_command/idle,
		/datum/pet_command/free,
		/datum/pet_command/move,
		/datum/pet_command/good_boy/dog,
		/datum/pet_command/good_boy/wolf,
		/datum/pet_command/follow/dog,
		/datum/pet_command/attack/dog,
		/datum/pet_command/fetch,
		/datum/pet_command/play_dead,
		/datum/pet_command/protect_owner
	)

	AddComponent(/datum/component/obeys_commands, pet_commands)

/mob/living/basic/pet/dog/wolf/update_icon_state()
	. = ..()
	if(stat != DEAD)
		if(resting)
			icon_state = "[icon_living]_rest"
		else
			icon_state = "[icon_living]"

/mob/living/basic/pet/dog/wolf/update_overlays()
	. = ..()
	var/laid_down = wolfresting()

	var/mutable_appearance/eyes_overlay = mutable_appearance(icon, "eyes[laid_down ? "_rest" : ""]")
	SET_PLANE(eyes_overlay, ABOVE_LIGHTING_PLANE, src)
	eyes_overlay.color = sprite_eye_color
	. += eyes_overlay

	switch(get_fire_loss()+get_brute_loss()+get_agg_loss())
		if(40 to 70)
			var/mutable_appearance/damage_overlay = mutable_appearance(icon, "damage1[laid_down ? "_rest" : ""]")
			. += damage_overlay
		if(71 to 100)
			var/mutable_appearance/damage_overlay = mutable_appearance(icon, "damage2[laid_down ? "_rest" : ""]")
			. += damage_overlay
		if(101 to INFINITY)
			var/mutable_appearance/damage_overlay = mutable_appearance(icon, "damage3[laid_down ? "_rest" : ""]")
			. += damage_overlay

/mob/living/basic/pet/dog/wolf/proc/wolfresting()
	return IS_UNCONSCIOUS_OR_CRIT(src) || IsSleeping() || IsParalyzed() || body_position == LYING_DOWN

// WOLF TYPES
/mob/living/basic/pet/dog/wolf/kinfolk
	// real_name = "kinfolk"
	wolf_type = TYPE_KINFOLK

/mob/living/basic/pet/dog/wolf/kinfolk/spiral
	name = "rotten wolf"
	// real_name = "tainted kinfolk"
	icon_state = "wolfspiral1"
	base_icon_state = "wolfspiral"

/mob/living/basic/pet/dog/wolf/kinfolk/spiral/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_WYRMTAINTED, INNATE_TRAIT)

// STATIC COLORS
WOLF_COAT_HELPER(/mob/living/basic/pet/dog/wolf)
WOLF_COAT_HELPER(/mob/living/basic/pet/dog/wolf/kinfolk)
WOLF_COAT_HELPER(/mob/living/basic/pet/dog/wolf/kinfolk/spiral)

#undef WOLF_COAT_HELPER

#undef COAT_BLACK
#undef COAT_GRAY
#undef COAT_RED
#undef COAT_WHITE
#undef COAT_GINGER
#undef COAT_BROWN

#undef TYPE_MUNDANE
#undef TYPE_KINFOLK
