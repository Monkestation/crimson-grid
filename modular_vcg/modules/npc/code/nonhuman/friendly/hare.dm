/mob/living/basic/hare/vamp
	name = "hare"
	desc = "The chunkiest hopper around."
	icon = 'modular_vcg/modules/npc/icons/32x32small.dmi'
	icon_state = "hare"
	icon_living = "hare"
	icon_dead = "hare_dead"
	health = 15
	maxHealth = 15
	mob_biotypes = MOB_ORGANIC | MOB_BEAST
	mob_size = MOB_SIZE_SMALL
	density = FALSE
	gold_core_spawnable = FRIENDLY_SPAWN
	speak_emote = list("sniffles", "twitches")
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	attack_sound = 'sound/items/weapons/punch1.ogg'
	attack_vis_effect = ATTACK_EFFECT_KICK
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	attack_verb_continuous = "kicks"
	attack_verb_simple = "kick"
	bloodquality = BLOOD_QUALITY_LOW
	bloodpool = 1
	maxbloodpool = 1
	butcher_results = list(/obj/item/food/meat/slab/grassfed = 2)
	unsuitable_cold_damage = 0.7 // Cold damage is 0.7 here to account for low health on the large hare.
	unsuitable_heat_damage = 0.7 // Heat damage is 0.7 here to account for low health on the large hare.
	ai_controller = /datum/ai_controller/basic_controller/rabbit

/datum/emote/hare
	abstract_type = /datum/emote/hare
	mob_type_allowed_typecache = /mob/living/basic/hare
	mob_type_blacklist_typecache = list()

/datum/emote/hare/leap
	key = "leap"
	key_third_person = "leaps"
	message = "leaps around happily!"
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/mob/living/basic/hare/vamp/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/ai_retaliate)
	AddElement(/datum/element/pet_bonus, "leap")
	AddElement(/datum/element/can_be_held)

/datum/ai_controller/basic_controller/hare
	behavior_tree_json = "code/modules/mob/living/basic/farm_animals/rabbit.bt.json"
	blackboard = list(
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic,
		BB_BASIC_MOB_SPEAK_LINES = list(
			BB_EMOTE_SAY = list("Mrrp.", "CHIRP!", "Mrrp?"),
			BB_EMOTE_HEAR = list("leaps."),
			BB_EMOTE_SEE = list("leaps around.", "bounces up and down."),
			BB_SPEAK_CHANCE = 10,
		),
	)
	ai_traits = PASSIVE_AI_FLAGS
	ai_movement = /datum/ai_movement/basic_avoidance
