// W20 p. 259
/datum/status_effect/stacking/silver_bullets
	id = "silver_bullet_stacks"
	tick_interval = 1 TURNS
	delay_before_decay = 1 SCENES
	stacks = 1
	stack_threshold = 5
	max_stacks = 5
	// This renders ONTOP of the mob. Not as a status effect. Which is prob what we need to do.
	// overlay_file = 'modular_darkpack/modules/werewolf_the_apocalypse/icons/silver_dam_status.dmi'
	// overlay_state = "silver"

/datum/status_effect/stacking/silver_bullets/threshold_cross_effect()
	var/datum/splat/werewolf/shifter/splat = get_shifter_splat(owner)
	if(splat)
		splat.adjust_gnosis(-1, TRUE)


/obj/projectile/bullet/proc/fera_silver_damage(mob/living/carbon/human/target, dice = 0, blocked = 0) // CG add blocked arg for armour handling for silver
	if(!istype(target))
		return
	if(!HAS_TRAIT(target, TRAIT_SILVER_WEAKNESS))
		return
	var/datum/splat/werewolf/shifter/shot_pup_splat = get_shifter_splat(target)
	if(shot_pup_splat)
		var/mob/living/carbon/human/shot_pup = target
		shot_pup.apply_status_effect(STATUS_EFFECT_SILVER_BULLET_STACKS)

		if(!shot_pup_splat.is_breed_form() || iscrinos(shot_pup))
			// IDK. This is might TTRPG inaccurate RN because i think it should acctaully convert ALL the damage to agg not just add some agg to it.
			if(blocked < 100) // CG added check here to make sure parried silver damage is fully blocked as normal instead of capping at 90 block
				blocked = min(ARMOR_MAX_BLOCK, blocked)
			shot_pup.apply_damage(dice TTRPG_DAMAGE, AGGRAVATED, def_zone = def_zone, blocked = blocked) // CG add def_zone and blocked args to make silver dmg not hit random locations or ignore armour

/obj/item/proc/fera_silver_damage(mob/living/carbon/human/target, dice = 0, gnosis_damage = 0, list/attack_modifiers = null) // CG add attack_modifiers for silver damage hitzone and armour interactions
	if(!istype(target))
		return
	if(!HAS_TRAIT(target, TRAIT_SILVER_WEAKNESS))
		return
	var/datum/splat/werewolf/shifter/shot_pup_splat = get_shifter_splat(target)
	if(shot_pup_splat)
		var/mob/living/carbon/human/shot_pup = target
		shot_pup_splat.adjust_gnosis(-gnosis_damage, TRUE)
		var/def_zone = LAZYACCESS(attack_modifiers, "silver_hit_zone") // CG add handling for properly applying silver damage to actual hit zone rather than hitting random bodypart
		if(isnull(def_zone)) // CG do not apply silver damage if no valid hitzone for some reason
			return
		var/silver_armor_block = LAZYACCESS(attack_modifiers, "silver_armor_block") // CG add handling for reducing silver damage by armor block amount

		// W20 p. 290 - Werewolves dont take silver damage in breed form because they arent spirits
		if(!shot_pup_splat.is_breed_form() || iscrinos(shot_pup))
			shot_pup.apply_damage(dice TTRPG_DAMAGE, AGGRAVATED, def_zone = def_zone, blocked = silver_armor_block) // CG add def_zone and blocked for handling silver damage hit zone and armour interactions
