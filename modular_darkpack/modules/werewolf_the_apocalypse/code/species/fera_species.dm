//Required so werewolves can almost entirely override body rendering
/mob/living/carbon/human/update_body_parts(update_limb_data)
	if(dna?.species?.update_body_parts(src))
		return
	return ..()

/datum/species/proc/update_body_parts(mob/living/carbon/human/human)
	return

/mob/living/carbon/human/update_damage_overlays()
	if(dna?.species?.update_damage_overlays(src))
		return
	return ..()

/datum/species/proc/update_damage_overlays(mob/living/carbon/human/human)
	return


/datum/species/human/shifter
	abstract_type = /datum/species/human/shifter
	name = "Fera"
	plural_form = "Fera"
	id = SPECIES_FERA
	species_language_holder = /datum/language_holder/garou
	var/mob_pixel_w
	var/mob_pixel_z
	/// If declared will override the mob size.
	var/mob_size_override
	/// Dice roll difficulty required to shift into this form
	var/shift_difficulty = 6
	/// If update_body_parts is allowed to override the body render
	var/custom_body_render = FALSE
	/// If update_damage_parts is allowed to override the damage render
	var/custom_damage_render = FALSE
	/// Fallback dmi to refrence if we fail to get one from our splat
	var/fallback_icon
	var/has_flight_icon_states = FALSE
	/// Speed mod applied and removed upon gaining this species
	var/speed_mod
	/// Causes delirium, which if the user is affected by, does not cause breaches
	var/form_causes_delirium = FALSE
	/// IF this form can be witnessed, causes masqurade breaches
	var/veil_breaching_form = FALSE

/datum/species/human/shifter/on_species_gain(mob/living/carbon/human/human_who_gained_species, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	if(speed_mod)
		human_who_gained_species.add_movespeed_modifier(speed_mod)

	human_who_gained_species.add_offsets(type, w_add = mob_pixel_w, z_add = mob_pixel_z)

	if(mob_size_override)
		human_who_gained_species.mob_size = mob_size_override

	add_buffs(human_who_gained_species)

/datum/species/human/shifter/on_species_loss(mob/living/carbon/human/human, datum/species/new_species, pref_load)
	. = ..()
	if(speed_mod)
		human.remove_movespeed_modifier(speed_mod)

	if(mob_size_override)
		human.mob_size = human::mob_size

	human.remove_offsets(type)

	clear_buffs(human)

/datum/species/human/shifter/proc/get_buffs(mob/living/carbon/human/human)
	var/datum/splat/werewolf/shifter/shifter_splat = get_shifter_splat(human)
	if(shifter_splat?.transformation_stats && shifter_splat.transformation_stats[id])
		return shifter_splat.transformation_stats[id]

/datum/species/human/shifter/proc/add_buffs(mob/living/carbon/human/human)
	for(var/key, value in get_buffs(human))
		if(!should_add_buff(human, key, value))
			continue
		human.st_add_stat_mod(key, value, type)

/datum/species/human/shifter/proc/should_add_buff(mob/living/carbon/human/human, datum/st_stat/buff_type, amount)
	return TRUE

/datum/species/human/shifter/proc/clear_buffs(mob/living/carbon/human/human)
	for(var/key, value in get_buffs(human))
		human.st_remove_stat_mod(key, type)

/datum/species/human/shifter/proc/is_veil_breaching_form(mob/living/carbon/human/human)
	return veil_breaching_form

/// Fetch the mobs fur color from their features.
/datum/species/human/shifter/proc/get_fur_color(mob/living/carbon/human/human)
	return human.dna.features[FEATURE_FUR_COLOR] ? human.dna.features[FEATURE_FUR_COLOR] : "black"


/// Fetch the mob dmi from our splat
/datum/species/human/shifter/proc/get_mob_icon(mob/living/carbon/human/human)
	var/datum/splat/werewolf/shifter/shifter_splat = get_shifter_splat(human)
	var/icon_to_use
	if(shifter_splat)
		icon_to_use = shifter_splat.mob_icons[id]

	return icon_to_use ? icon_to_use : fallback_icon

/datum/species/human/shifter/update_body_parts(mob/living/carbon/human/human)
	if(!custom_body_render)
		return FALSE

	human.remove_overlay(BODYPARTS_LAYER)

	var/fur_color = get_fur_color(human)
	var/mob_icon = get_mob_icon(human)

	var/main_iconstate = ""
	if(HAS_TRAIT(human, TRAIT_WYRMTAINTED_SPRITE))
		main_iconstate += "spiral"
	main_iconstate += fur_color
	if(has_flight_icon_states && HAS_TRAIT(human, TRAIT_FERA_FLIGHT) && HAS_TRAIT(human, TRAIT_MOVE_FLYING) && HAS_TRAIT(human, TRAIT_NO_FLOATING_ANIM))
		main_iconstate += "_flying"
	else if(human.body_position == LYING_DOWN)
		main_iconstate += "_rest"

	human.overlays_standing[BODYPARTS_LAYER] = list(image(mob_icon, main_iconstate))

	human.apply_overlay(BODYPARTS_LAYER)

	return TRUE

/datum/species/human/shifter/update_damage_overlays(mob/living/carbon/human/human)
	if(!custom_damage_render)
		return FALSE

	human.remove_overlay(DAMAGE_LAYER)

	var/dam_amount
	switch(human.get_brute_loss() + human.get_fire_loss() + human.get_agg_loss())
		if(25 to 100)
			dam_amount = 1
		if(100 to 250)
			dam_amount = 2
		if(250 to INFINITY)
			dam_amount = 3
	if(dam_amount)
		human.overlays_standing[DAMAGE_LAYER] = mutable_appearance(get_mob_icon(human), "damage[dam_amount][human.body_position == LYING_DOWN ? "_rest" : ""]")

	human.apply_overlay(DAMAGE_LAYER)

	return TRUE

/datum/species/human/shifter/homid
	name = "homid form"
	id = SPECIES_FERA_HOMID


/datum/species/human/shifter/bestial
	name = "bestial form"
	id = SPECIES_FERA_BESTIAL
	shift_difficulty = 7
	fallback_icon = 'modular_darkpack/modules/werewolf_the_apocalypse/icons/garou_forms/glabro.dmi'
	veil_breaching_form = TRUE
	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right,
		BODY_ZONE_HEAD = /obj/item/bodypart/head,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/fera/bestial,
	)

/datum/species/human/shifter/bestial/should_add_buff(mob/living/carbon/human/human, datum/st_stat/buff_type, amount)
	. = ..()
	// Raw string check instead of a define or type path is pretty bleak
	if(HAS_TRAIT(human, TRAIT_FAIR_GLABRO) && (buff_type::subcategory == "Social") && (amount < 0))
		return FALSE

/datum/species/human/shifter/bestial/is_veil_breaching_form(mob/living/carbon/human/human)
	if(HAS_TRAIT(human, TRAIT_FAIR_GLABRO))
		return FALSE
	return ..()

/datum/species/human/shifter/bestial/on_species_gain(mob/living/carbon/human/human_who_gained_species, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	RegisterSignal(human_who_gained_species, COMSIG_ATOM_UPDATE_OVERLAYS, PROC_REF(add_fluff))
	human_who_gained_species.update_appearance(UPDATE_OVERLAYS)
	human_who_gained_species.update_transform(1.25)

/datum/species/human/shifter/bestial/on_species_loss(mob/living/carbon/human/human, datum/species/new_species, pref_load)
	. = ..()
	UnregisterSignal(human, COMSIG_ATOM_UPDATE_OVERLAYS)
	human.update_appearance(UPDATE_OVERLAYS)
	human.update_transform()

/datum/species/human/shifter/bestial/proc/add_fluff(datum/source, list/overlay_list)
	SIGNAL_HANDLER

	var/mob/living/carbon/human/guy = astype(source)
	if(!guy)
		return

	if(!HAS_TRAIT(guy, TRAIT_FAIR_GLABRO))
		var/fur_color = get_fur_color(guy)
		var/mob_icon = get_mob_icon(guy)
		var/image/fluff = image(mob_icon, fur_color, layer = -BODY_ADJ_LAYER)
		overlay_list += fluff


/datum/species/human/shifter/war
	name = "war form"
	id = SPECIES_FERA_WAR
	inherent_traits = list(
		TRAIT_NO_UNDERWEAR,
		TRAIT_NO_BLOOD_OVERLAY,
		TRAIT_NO_LYING_ANGLE,
		TRAIT_TRANSFORM_UPDATES_ICON,
		TRAIT_HARDENED_SOLES,
	)
	form_causes_delirium = TRUE
	veil_breaching_form = TRUE

	mutanttongue = /obj/item/organ/tongue/fera
	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/fera/aggravated,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/fera/aggravated,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/fera/aggravated,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/fera,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/fera,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/fera,
	)

	no_equip_flags = ITEM_SLOT_ON_BODY

	mob_pixel_w = -8
	mob_size_override = MOB_SIZE_LARGE
	custom_body_render = TRUE
	custom_damage_render = TRUE
	fallback_icon = 'modular_darkpack/modules/werewolf_the_apocalypse/icons/garou_forms/crinos.dmi'

/datum/species/human/shifter/war/visible_gender_override(mob/living/carbon/human/holder)
	return "beast"


/datum/species/human/shifter/dire
	name = "dire form"
	id = SPECIES_FERA_DIRE
	inherent_traits = list(
		TRAIT_NO_UNDERWEAR,
		TRAIT_NO_BLOOD_OVERLAY,
		TRAIT_NO_LYING_ANGLE,
		TRAIT_TRANSFORM_UPDATES_ICON,
		TRAIT_FERAL_BITER,
		TRAIT_SMALL_HANDS,
		TRAIT_NO_CUFF,
		TRAIT_HARDENED_SOLES,
	)
	veil_breaching_form = TRUE

	mutantbrain = /obj/item/organ/brain/fera
	mutanttongue = /obj/item/organ/tongue/fera
	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/fera/aggravated,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/fera/aggravated,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/fera/aggravated,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/fera,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/fera,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/fera,
	)

	no_equip_flags = ITEM_SLOT_ON_BODY

	mob_pixel_w = -16
	mob_pixel_z = -8
	shift_difficulty = 7
	custom_body_render = TRUE
	custom_damage_render = TRUE
	fallback_icon = 'modular_darkpack/modules/werewolf_the_apocalypse/icons/garou_forms/hispo.dmi'
	speed_mod = /datum/movespeed_modifier/shifter/dire

/datum/species/human/shifter/dire/visible_gender_override(mob/living/carbon/human/holder)
	return "beast"


/datum/species/human/shifter/feral
	name = "feral form"
	id = SPECIES_FERA_FERAL
	inherent_traits = list(
		TRAIT_NO_UNDERWEAR,
		TRAIT_NO_BLOOD_OVERLAY,
		TRAIT_NO_LYING_ANGLE,
		TRAIT_TRANSFORM_UPDATES_ICON,
		TRAIT_FERAL_BITER,
		TRAIT_SMALL_HANDS,
		TRAIT_NO_CUFF,
	)

	mutantbrain = /obj/item/organ/brain/fera
	mutanttongue = /obj/item/organ/tongue/fera
	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/fera,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/fera,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/fera/aggravated,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/fera,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/fera,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/fera,
	)

	no_equip_flags = ITEM_SLOT_ON_BODY

	custom_body_render = TRUE
	custom_damage_render = TRUE
	fallback_icon = 'modular_darkpack/modules/werewolf_the_apocalypse/icons/garou_forms/lupus.dmi'
	has_flight_icon_states = TRUE
	speed_mod = /datum/movespeed_modifier/shifter/feral

/datum/species/human/shifter/feral/visible_gender_override(mob/living/carbon/human/holder)
	var/datum/splat/werewolf/shifter/shifter_splat = get_shifter_splat(holder)
	if(shifter_splat?.mimmicing_animal)
		return shifter_splat.mimmicing_animal::name

	return "beast"

/datum/species/human/shifter/feral/on_species_gain(mob/living/carbon/human/human_who_gained_species, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	if(HAS_TRAIT(human_who_gained_species, TRAIT_FERA_FLIGHT))
		var/datum/action/innate/toggle_fera_flight/ability = new(human_who_gained_species)
		ability.Grant(human_who_gained_species)
		human_who_gained_species.AddElementTrait(TRAIT_WADDLING, INNATE_TRAIT, /datum/element/waddling)

/datum/species/human/shifter/feral/on_species_loss(mob/living/carbon/human/human, datum/species/new_species, pref_load)
	. = ..()
	for(var/datum/action/innate/toggle_fera_flight/action in human.actions)
		action.Remove(human)

	if(HAS_TRAIT(human, TRAIT_FERA_FLIGHT))
		REMOVE_TRAIT(human, TRAIT_WADDLING, INNATE_TRAIT)

/datum/movespeed_modifier/shifter
	abstract_type = /datum/movespeed_modifier/shifter
	movetypes = GROUND

/datum/movespeed_modifier/shifter/dire
	multiplicative_slowdown = -0.2

/datum/movespeed_modifier/shifter/feral
	multiplicative_slowdown = -0.35
