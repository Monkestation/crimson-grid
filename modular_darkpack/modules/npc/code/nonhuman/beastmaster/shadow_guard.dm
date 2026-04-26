/mob/living/basic/shadow_guard
	name = "heart of silence"
	desc = "A shadow given life, fathomless creature..."
	icon = 'modular_darkpack/modules/npc/icons/shadow_guard.dmi'
	icon_state = "shadow2"
	icon_living = "shadow2"

	basic_mob_flags = DEL_ON_DEATH

	speed = 0
	maxHealth = 100
	health = 100

	obj_damage = 50
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_verb_continuous = "gouges"
	attack_verb_simple = "gouge"
	attack_sound = 'sound/mobs/non-humanoids/venus_trap/venus_trap_hit.ogg'

	faction = list(VAMPIRE_CLAN_LASOMBRA)
	bloodpool = 1
	maxbloodpool = 1

	ai_controller = /datum/ai_controller/basic_controller/beastmaster_summon

/mob/living/basic/shadow_guard/Initialize(mapload)
	. = ..()
	if(prob(50) && icon_state == "shadow2")
		icon_state = "shadow"
		icon_living = "shadow"
	AddElement(/datum/element/ai_retaliate)

/mob/living/basic/shadow_guard/hungry_shade
	name = "hungry shade"
	desc = "A shade from the furthest reaches of the underworld made manifest."
	maxHealth = 150
	health = 150
	melee_damage_upper = 25
	melee_damage_lower = 25
	icon_state = "shade"
	icon_living = "shade"
	alpha = 160
	attack_sound = 'sound/mobs/humanoids/shadow/shadow_wail.ogg'
