/mob/living/basic/pig/vampire
	name = "wild boar"
	desc = "A feral hog that has became invasive."
	icon = 'modular_vcg/modules/npc/icons/32x32small.dmi'
	icon_state = "boar"
	icon_living = "boar"
	icon_dead = "boar_dead"
	maxHealth = 175
	health = 175
	melee_damage_lower = 30
	melee_damage_upper = 25
	mob_size = MOB_SIZE_HUMAN
	exposed_wound_bonus = 15
	sharpness = SHARP_EDGED
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak_emote = list("loudly grunts","squeels", "grunts lowly")
	butcher_results = list(/obj/item/food/meat/slab/grassfed = 3)
	attack_sound = 'sound/items/weapons/slice.ogg'
	ai_controller = /datum/ai_controller/basic_controller/goat
	var/gleam_delay = 5 SECONDS

	COOLDOWN_DECLARE(gleam_cooldown)

/mob/living/basic/pig/vampire/Initialize(mapload)
	. = ..()

	bloodquality = BLOOD_QUALITY_LOW
	bloodpool = 4 // Vampire: the Masquerade V20 editon page 388
	maxbloodpool = 4

/mob/living/basic/pig/vampire/proc/on_attacked(datum/source, atom/attacker, attack_flags)
	if (!COOLDOWN_FINISHED(src, gleam_cooldown))
		return
	visible_message(
		span_danger("[src] gets an hateful-looking gleam in [p_their()] eye."),
	)
	COOLDOWN_START(src, gleam_cooldown, gleam_delay)

/datum/emote/boar
	abstract_type = /datum/emote/boar
	mob_type_allowed_typecache = /mob/living/basic/pig/vampire
	mob_type_blacklist_typecache = list()

/datum/emote/boar/oink
	key = "oink"
	key_third_person = "oinks"
	message = "oinks!"
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE
	vary = TRUE
	sound = SFX_PIG_OINK
