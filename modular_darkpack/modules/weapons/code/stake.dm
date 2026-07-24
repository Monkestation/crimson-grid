/obj/item/vampire_stake
	name = "stake"
	desc = "Paralyzes blank-bodies if aimed straight to the heart."
	icon = 'modular_darkpack/modules/weapons/icons/weapons.dmi'
	worn_icon = 'modular_darkpack/modules/weapons/icons/worn_melee.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	icon_state = "stake"

	// VTM pg. 280
	force = 1 TTRPG_DAMAGE

	sharpness = SHARP_POINTY
	attack_verb_continuous = list("pierces", "cuts")
	attack_verb_simple = list("pierce", "cut")
	hitsound = 'sound/items/weapons/bladeslice.ogg'
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 2)
	custom_price = 100

/obj/item/vampire_stake/attack(mob/living/target, mob/living/user)
	. = ..()
	if(.)
		return TRUE
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		return TRUE

	if(HAS_TRAIT(target, TRAIT_STAKE_IMMUNE) || HAS_TRAIT(target, TRAIT_STAKE_RESISTANT))
		visible_message(span_warning("[user]'s stake splinters as it touches [target]'s heart!"), span_warning("Your stake splinters as it touches [target]'s heart!"))
		REMOVE_TRAIT(target, TRAIT_STAKE_RESISTANT, MAGIC_TRAIT)
		qdel(src)
		return TRUE

	visible_message(span_danger("[user] aims [src] straight to the [target]'s heart!"), span_danger("You aim [src] straight to the [target]'s heart!"))
	if(!do_after(user, 1 TURNS, target))
		return TRUE
	user.do_attack_animation(target)
	visible_message(span_danger("[user] pierces [target]'s torso!"), span_danger("You pierce [target]'s torso!"))

	user.do_attack_animation(target, used_item = src)
	var/datum/embedding/stake/embed = get_embed()
	if(!istype(embed))
		embed = set_embed(/datum/embedding/stake)
	force_embed(target, target.get_bodypart(BODY_ZONE_CHEST))
	return TRUE

/datum/embedding/stake
	embed_chance = 1
	fall_chance = 0
	pain_chance = 0
	jostle_chance = 0
	pain_mult = 0
	jostle_pain_mult = 0
	rip_time = 1 TURNS
	ignore_throwspeed_threshold = TRUE
	immune_traits = list(TRAIT_STAKE_RESISTANT, TRAIT_STAKE_IMMUNE)

/datum/embedding/stake/set_owner(mob/living/carbon/victim, obj/item/bodypart/target_limb)
	. = ..()
	ADD_TRAIT(owner, TRAIT_STAKED, STAKE_TRAIT)

/datum/embedding/stake/stop_embedding()
	REMOVE_TRAIT(owner, TRAIT_STAKED, STAKE_TRAIT)
	return ..()

/datum/embedding/stake/can_embed(atom/movable/source, mob/living/carbon/victim, hit_zone, datum/thrownthing/throwingdatum)
	. = ..()
	if (!.)
		return
	var/obj/item/bodypart/affecting = victim.get_bodypart(hit_zone) || victim.bodyparts[1]
	if (!IS_ORGANIC_LIMB(affecting))
		return FALSE
	return TRUE
