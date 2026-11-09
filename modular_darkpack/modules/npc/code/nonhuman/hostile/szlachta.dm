/mob/living/basic/szlachta
	name = "szlachta biter"
	desc = "Свирепая клыкастая тварь, похожая на паука."
	icon = 'modular_darkpack/modules/npc/icons/szlachta.dmi'
	icon_state = "biter"
	icon_living = "biter"
	icon_dead = "biter_dead"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	butcher_results = list(/obj/item/stack/sheet/meat = 1)
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	speed = -0.4
	maxHealth = 75
	health = 75
	obj_damage = 50
	melee_damage_lower = 20
	melee_damage_upper = 20
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/items/weapons/bite.ogg'
	speak_emote = list("gnashes")
	faction = list(FACTION_SABBAT, VAMPIRE_CLAN_TZIMISCE)
	pressure_resistance = 200
	bloodquality = BLOOD_QUALITY_LOW
	bloodpool = 2
	maxbloodpool = 2
	ai_controller = /datum/ai_controller/basic_controller/szlachta/darkpack	// CORVAX EDIT
	custom_materials = list(/datum/material/meat = SHEET_MATERIAL_AMOUNT * 2)
	default_blood_volume = BLOOD_VOLUME_NORMAL

/mob/living/basic/szlachta/fister
	name = "szlachta"
	desc = "Сущая мерзость: ходит на руках и смотрит пустыми, печальными, ярко-белыми глазами."
	icon_state = "fister"
	icon_living = "fister"
	icon_dead = "fister_dead"
	maxHealth = 125
	health = 125
	butcher_results = list(/obj/item/stack/sheet/meat = 2)
	melee_damage_lower = 30
	melee_damage_upper = 30
	attack_verb_continuous = "punches"
	attack_verb_simple = "punch"
	speed = 1.5
	attack_sound = 'sound/items/weapons/punch1.ogg'
	combat_mode = TRUE
	status_flags = CANPUSH
	bloodpool = 5
	maxbloodpool = 5
	custom_materials = list(/datum/material/meat = SHEET_MATERIAL_AMOUNT * 5)

/mob/living/basic/szlachta/tanker
	name = "vozhd"
	desc = "Жуткий танк из плоти и костей с отростками-клинками и немыслимой толщей живой брони. Бывалые вампиры знают таких тварей как осадных гулей Цимисхов."
	icon_state = "tanker"
	icon_living = "tanker"
	icon_dead = "tanker_dead"
	maxHealth = 350
	health = 350
	butcher_results = list(/obj/item/stack/sheet/meat = 4)
	melee_damage_lower = 25
	melee_damage_upper = 25
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	speed = 2
	attack_sound = 'sound/items/weapons/slash.ogg'
	combat_mode = TRUE
	bloodpool = 7
	maxbloodpool = 7
	custom_materials = list(/datum/material/meat = SHEET_MATERIAL_AMOUNT * 10)


/mob/living/basic/szlachta/otherthing
	name = "sludgelike vozhd"
	desc = "Раздутая клыкастая тварь, похожая на ком слизи. Она напоминает прочих осадных гулей, но эта кусает, рвёт плоть и жадно пьёт кровь..."
	icon_state = "otherthing"
	icon_living = "otherthing"
	icon_dead = "otherthing_dead"
	maxHealth = 350
	health = 350
	butcher_results = list(/obj/item/stack/sheet/meat = 4)
	melee_damage_lower = 25
	melee_damage_upper = 25
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	speed = 2
	attack_sound = 'sound/items/weapons/slash.ogg'
	combat_mode = TRUE
	bloodpool = 10
	maxbloodpool = 10
	custom_materials = list(/datum/material/meat = SHEET_MATERIAL_AMOUNT * 10)


//DARKPACK TODO - Szlachta - make this guy drain blood

/mob/living/basic/szlachta/hostile
	faction = list(FACTION_HOSTILE)

/mob/living/basic/szlachta/fister/hostile
	faction = list(FACTION_HOSTILE)

/mob/living/basic/szlachta/tanker/hostile
	faction = list(FACTION_HOSTILE)

/mob/living/basic/szlachta/otherthing/hostile
	faction = list(FACTION_HOSTILE)

// CORVAX EDIT START
/mob/living/basic/szlachta/Initialize(mapload)
	. = ..()
	cut_overlays()
	update_body()
	AddElement(/datum/element/ai_retaliate)

/datum/targeting_strategy/basic/szlachta

/datum/targeting_strategy/basic/szlachta/is_valid_target(mob/living/living_mob, atom/the_target, vision_range, datum/ai_controller/controller = null)
	if(istype(the_target, /datum/targeting_strategy/basic/szlachta))
		return FALSE

	return ..()

/datum/ai_controller/basic_controller/szlachta/darkpack
	blackboard = list(
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic/szlachta,
		BB_TARGET_MINIMUM_STAT = HARD_CRIT,
		BB_VISION_RANGE = 9,
	)
	ai_movement = /datum/ai_movement/basic_avoidance

	behavior_tree_json = "code/datums/ai/basic_mobs/simple_hostile.bt.json"
// CORVAX EDIT END
