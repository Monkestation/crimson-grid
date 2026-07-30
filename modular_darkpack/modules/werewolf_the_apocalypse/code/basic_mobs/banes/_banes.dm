/mob/living/basic/bane
	name = "creature"
	abstract_type = /mob/living/basic/bane
	icon = 'modular_darkpack/modules/werewolf_the_apocalypse/icons/basic/banes.dmi'

	mob_biotypes = MOB_SPIRIT
	basic_mob_flags = DEL_ON_DEATH

	speed = 0.35
	maxHealth = 80
	health = 80
	melee_damage_lower = 10
	melee_damage_upper = 20
	obj_damage = 20

	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/items/weapons/bite.ogg'
	speak_emote = list("gnashes")

	faction = list("bane")

	pressure_resistance = 200
	bloodpool = 0
	maxbloodpool = 0
	bloodquality = BLOOD_QUALITY_LOW

	ai_controller = /datum/ai_controller/basic_controller/simple/simple_hostile_obstacles
	// General spitball of the "power" of the bane so we can use that for difficulty calculations
	var/power_rank = 1

/mob/living/basic/bane/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/ai_retaliate)
	ADD_TRAIT(src, TRAIT_WYRMTAINTED, INNATE_TRAIT)
