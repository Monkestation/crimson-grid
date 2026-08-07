GLOBAL_LIST_INIT(zulo_forms, list(
	"Beast" = "weretzi",
	"Brust" = "4armstzi",
))

/datum/action/cooldown/spell/shapeshift/zulo
	name = "Zulo Form"
	desc = "Take on the shape a beast."
	cooldown_time = 1 TURNS
	revert_on_death = TRUE
	die_with_shapeshifted_form = FALSE
	spell_requirements = NONE
	convert_damage = FALSE
	possible_shapes = list(/mob/living/basic/zulo)
	click_to_activate = FALSE

/datum/action/cooldown/spell/shapeshift/zulo/do_unshapeshift(mob/living/caster)
	. = ..()
	Remove(caster)

/mob/living/basic/zulo
	name = "unknown creature"
	desc = "What the hell is that thing!?"
	icon = 'modular_darkpack/modules/powers/icons/zulo_forms.dmi'
	icon_state = "fiend" // Default icon_state, changed by character preference
	pixel_w = -16
	mob_biotypes = MOB_ORGANIC
	mob_size = MOB_SIZE_HUGE
	basic_mob_flags = PRECISE_ATTACK_ZONES | FLAMMABLE_MOB
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/items/weapons/slash.ogg'
	combat_mode = TRUE

	maxHealth = 600
	health = 600
	speed = 0.5
	melee_damage_lower = 30
	melee_damage_upper = 30
	obj_damage = 30
	armour_penetration = 5
	wound_bonus = 0
	sharpness = SHARP_POINTY
	attacked_sound = SFX_DESECRATION

	bloodpool = 2
	maxbloodpool = 2

/mob/living/basic/zulo/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_UNMASQUERADE, INNATE_TRAIT)

/mob/living/basic/zulo/mind_initialize()
	. = ..()
	var/preffered_form = client?.prefs.read_preference(/datum/preference/choiced/zulo_form)
	var/new_icon_state = GLOB.zulo_forms[preffered_form]
	icon_state = new_icon_state ? new_icon_state : "fiend"
