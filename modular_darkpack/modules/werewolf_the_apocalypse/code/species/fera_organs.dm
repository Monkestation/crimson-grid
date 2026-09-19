// Organs and limbs are applied where it makes sense to limited behavoir.
// e.g only the proper dogs on all 4s get the brain as that is to restrict there use of tools and force biting.

/obj/item/bodypart/head/fera
	// limb_id = SPECIES_FERA
	head_flags = NONE
	unarmed_attack_sound = 'modular_darkpack/modules/werewolf_the_apocalypse/sounds/werewolf_bite.ogg'

/obj/item/bodypart/head/fera/aggravated
	attack_type = AGGRAVATED

/obj/item/bodypart/chest/fera
	// limb_id = SPECIES_FERA

/obj/item/bodypart/chest/fera/bestial

/obj/item/bodypart/chest/fera/bestial/update_mob_heights(mob/living/carbon/human/holder)
	if(HAS_TRAIT(holder, TRAIT_DWARF))
		return HUMAN_HEIGHT_MEDIUM

	if(HAS_TRAIT(holder, TRAIT_TOO_TALL))
		return HUMAN_HEIGHT_TALLEST

	return HUMAN_HEIGHT_TALL

/obj/item/bodypart/arm/left/fera
	// limb_id = SPECIES_FERA
	unarmed_sharpness = SHARP_EDGED
	unarmed_attack_verbs = list("claw")
	unarmed_attack_verbs_continuous = list("claws")
	appendage_noun = "paw"
	unarmed_attack_effect = ATTACK_EFFECT_CLAW
	unarmed_attack_sound = 'modular_darkpack/modules/werewolf_the_apocalypse/sounds/werewolf_bite.ogg'
	unarmed_miss_sound = 'sound/items/weapons/slashmiss.ogg'

/obj/item/bodypart/arm/left/fera/aggravated
	attack_type = AGGRAVATED

/obj/item/bodypart/arm/right/fera
	// limb_id = SPECIES_FERA
	unarmed_sharpness = SHARP_EDGED
	unarmed_attack_verbs = list("claw")
	unarmed_attack_verbs_continuous = list("claws")
	appendage_noun = "paw"
	unarmed_attack_effect = ATTACK_EFFECT_CLAW
	unarmed_attack_sound = 'modular_darkpack/modules/werewolf_the_apocalypse/sounds/werewolf_bite.ogg'
	unarmed_miss_sound = 'sound/items/weapons/slashmiss.ogg'

/obj/item/bodypart/arm/right/fera/aggravated
	attack_type = AGGRAVATED

/obj/item/bodypart/leg/left/fera
	unarmed_sharpness = SHARP_EDGED
	// limb_id = SPECIES_FERA
	footprint_sprite = FOOTPRINT_SPRITE_CLAWS

/obj/item/bodypart/leg/left/fera/heavy
	special_footstep_sounds = list(list('modular_darkpack/modules/werewolf_the_apocalypse/sounds/hefty_step.ogg'), 60, 15)

/obj/item/bodypart/leg/right/fera
	unarmed_sharpness = SHARP_EDGED
	// limb_id = SPECIES_FERA
	footprint_sprite = FOOTPRINT_SPRITE_CLAWS

/obj/item/bodypart/leg/right/fera/heavy
	special_footstep_sounds = list(list('modular_darkpack/modules/werewolf_the_apocalypse/sounds/hefty_step.ogg'), 60, 15)

// Specificly to restrict use of tools... because that was moved to the brain..
/obj/item/organ/brain/fera
	name = "exotic brain"
	organ_traits = list(TRAIT_LITERATE, TRAIT_CAN_STRIP)

/obj/item/organ/brain/fera/get_attacking_limb(mob/living/carbon/human/target)
	if(!HAS_TRAIT(owner, TRAIT_ADVANCEDTOOLUSER) || HAS_TRAIT(owner, TRAIT_FERAL_BITER))
		return owner.get_bodypart(BODY_ZONE_HEAD)
	return ..()

/obj/item/organ/tongue/fera
	name = "exotic tongue"
	languages_native = list(/datum/language/garou_tongue, /datum/language/primal_tongue)

// Garou tongues can speak all default + garou tongue
/obj/item/organ/tongue/fera/get_possible_languages()
	return ..() + list(/datum/language/garou_tongue, /datum/language/primal_tongue)

//CRIMSON GRID EDIT START - Gives fera war forms powerful passive regen that is constent, does not heal aggravated damage

/datum/species/human/shifter/war/on_species_gain(mob/living/carbon/human/species_fera_war, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	var/datum/component/regenerator/regenerator = species_fera_war.GetComponent(/datum/component/regenerator)
	if(!regenerator)
		species_fera_war.AddComponent(/datum/component/regenerator, regeneration_delay = 1 SECONDS, heals_wounds = TRUE, brute_per_second = 15, tox_per_second = 5, oxy_per_second = 5, ignore_damage_types = list(AGGRAVATED,BURN), outline_colour = COLOR_RED)
		regenerator = species_fera_war.GetComponent(/datum/component/regenerator)
	regenerator?.start_regenerating()


/datum/species/human/shifter/war/on_species_loss(mob/living/carbon/human/human, datum/species/new_species, pref_load)
	. = ..()
	qdel(human.GetComponent(/datum/component/regenerator))

/datum/species/human/shifter/dire/on_species_gain(mob/living/carbon/human/species_fera_dire, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	RegisterSignal(species_fera_dire, COMSIG_MOB_APPLY_DAMAGE_MODIFIERS, PROC_REF(damage_resistance))
	var/datum/component/regenerator/regenerator = species_fera_dire.GetComponent(/datum/component/regenerator)
	if(!regenerator)
		species_fera_dire.AddComponent(/datum/component/regenerator, regeneration_delay = 1 SECONDS, heals_wounds = TRUE, brute_per_second = 12.5, tox_per_second = 5, oxy_per_second = 5, ignore_damage_types = list(AGGRAVATED,BURN), outline_colour =  COLOR_RED_LIGHT)
		regenerator = species_fera_dire.GetComponent(/datum/component/regenerator)
	regenerator?.start_regenerating()


/datum/species/human/shifter/dire/on_species_loss(mob/living/carbon/human/human, datum/species/new_species, pref_load)
	. = ..()
	UnregisterSignal(human, COMSIG_MOB_APPLY_DAMAGE_MODIFIERS)
	qdel(human.GetComponent(/datum/component/regenerator))

/datum/species/human/shifter/bestial/on_species_gain(mob/living/carbon/human/species_fera_bestial, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	var/datum/component/regenerator/regenerator = species_fera_bestial.GetComponent(/datum/component/regenerator)
	if(!regenerator)
		species_fera_bestial.AddComponent(/datum/component/regenerator, regeneration_delay = 2 SECONDS, heals_wounds = FALSE, brute_per_second = 12.5, tox_per_second = 5, oxy_per_second = 5, ignore_damage_types = list(AGGRAVATED,BURN), outline_colour = COLOR_ALMOST_BLACK)
		regenerator = species_fera_bestial.GetComponent(/datum/component/regenerator)
	regenerator?.start_regenerating()


/datum/species/human/shifter/bestial/on_species_loss(mob/living/carbon/human/human, datum/species/new_species, pref_load)
	. = ..()
	qdel(human.GetComponent(/datum/component/regenerator))

//CRIMSION GRID ADDITION END

//CRIMSON GRID ADDITION START - gives fera passive defensives per their species forms

/datum/species/human/shifter/dire/proc/damage_resistance(datum/source, list/damage_mods, damage_amount, damagetype, def_zone, sharpness, attack_direction, obj/item/attacking_item)
	SIGNAL_HANDLER
	if(damagetype == BRUTE)
		damage_mods += 0.5
	if(damagetype == AGGRAVATED)
		damage_mods += 0.8
	if(damagetype == TOXIC)
		damage_mods += 0.7
	if(damagetype == BURN)
		damage_mods += 0.9
/datum/splat/werewolf/shifter/garou/on_gain()
	. = ..()
	RegisterSignal(owner,COMSIG_MOB_APPLY_DAMAGE_MODIFIERS,PROC_REF(garou_damage_resistance))

/datum/splat/werewolf/shifter/garou/proc/garou_damage_resistance(datum/source, list/damage_mods, damage_amount, damagetype, def_zone, sharpness, attack_direction, obj/item/attacking_item)
	SIGNAL_HANDLER
	if(!istype(owner.dna?.species, /datum/species/human/shifter/war))
		return
	if(damagetype == BRUTE)
		damage_mods += 0.4
	if(damagetype == AGGRAVATED)
		damage_mods += 0.7
	if(damagetype == TOXIC)
		damage_mods += 0.65
	if(damagetype == BURN)
		damage_mods += 0.6
/datum/splat/werewolf/shifter/garou/on_lose_or_destroy()
	. = ..()
	UnregisterSignal(owner,COMSIG_MOB_APPLY_DAMAGE_MODIFIERS)

/datum/splat/werewolf/shifter/corax/on_gain()
	. = ..()
	RegisterSignal(owner,COMSIG_MOB_APPLY_DAMAGE_MODIFIERS,PROC_REF(corax_damage_resistance))
/datum/splat/werewolf/shifter/corax/proc/corax_damage_resistance(datum/source, list/damage_mods, damage_amount, damagetype, def_zone, sharpness, attack_direction, obj/item/attacking_item)
	SIGNAL_HANDLER
	if(!istype(owner.dna?.species, /datum/species/human/shifter/war))
		return
	if(damagetype == BRUTE)
		damage_mods += 0.8
	if(damagetype == BURN)
		damage_mods += 0.8
	if(damagetype == AGGRAVATED)
		damage_mods += 0.8
/datum/splat/werewolf/shifter/corax/on_lose_or_destroy()
	. = ..()
	UnregisterSignal(owner,COMSIG_MOB_APPLY_DAMAGE_MODIFIERS)
/datum/splat/werewolf/shifter/bestial/on_gain()
	. = ..()
	RegisterSignal(owner,COMSIG_MOB_APPLY_DAMAGE_MODIFIERS,PROC_REF(bestial_damage_resistance))
/datum/splat/werewolf/shifter/bestial/proc/bestial_damage_resistance(datum/source, list/damage_mods, damage_amount, damagetype, def_zone, sharpness, attack_direction, obj/item/attacking_item)
	SIGNAL_HANDLER
	if(damagetype == BRUTE)
		damage_mods += 0.8
	if(damagetype == AGGRAVATED)
		damage_mods += 0.9
	if(damagetype == TOXIC)
		damage_mods += 0.9
	if(damagetype == BURN)
		damage_mods += 0.9
/datum/splat/werewolf/shifter/bestial/on_lose_or_destroy()
	. = ..()
	UnregisterSignal(owner,COMSIG_MOB_APPLY_DAMAGE_MODIFIERS)
//CRIMSON GRID ADDITION END
