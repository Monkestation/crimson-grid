/datum/splat/vampire/kindred
	name = "Kindred"
	desc = "Undead predators that have been feeding on humanity since stone was first turned into tools. \
			They use the powers of their stolen blood to control human societies."
	id = SPLAT_KINDRED

	splat_traits = list(
		TRAIT_LIMBATTACHMENT,
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
		TRAIT_NOCRITDAMAGE,
		TRAIT_LIVERLESS_METABOLISM,
		TRAIT_RADIMMUNE,
		TRAIT_CAN_ENTER_TORPOR,
		TRAIT_VTM_MORALITY,
		TRAIT_VTM_CLANS,
		TRAIT_UNAGING,
		TRAIT_DRINKS_BLOOD,
		TRAIT_PALE_AURA,
	)
	splat_actions = list(
		/datum/action/cooldown/mob_cooldown/give_vitae,
		/datum/action/cooldown/blood_power,
	)
	splat_biotypes = MOB_UNDEAD

	incompatible_splats = list(
		/datum/splat/vampire/ghoul
	)

	splat_priority = SPLAT_PRIO_KINDRED

	/// How many generations away from the first vampire they are. Determines how much blood can be stored and used
	var/generation
	/// How quickly they can spend vitae. Depends on Generation and affects abilities like bloodheal
	var/vitae_spending_rate
	/// Which vampiric bloodline or Clan they fall into. Determines natural Disciplines. Singleton reference, never modify
	var/datum/subsplat/vampire_clan/clan
	/// The Kindred who created this Kindred, null unless Embraced in-round
	var/mob/living/sire

	/// Timer tracking how long before the Kindred can wake up from torpor
	COOLDOWN_DECLARE(torpor_timer)

/datum/splat/vampire/kindred/New(generation, clan, mob/living/sire)
	src.generation = generation
	src.clan = clan
	src.sire = sire

/datum/splat/vampire/kindred/on_gain()
	if (!isdummy(owner))
		GLOB.kindred_list |= owner

	// Initialize previously set Clan and Generation
	set_generation(generation)
	owner.set_clan(clan)

	// DARKPACK TODO - reimplement this action maybe
	// add_verb(new_kindred, TYPE_VERB_REF(/mob/living/carbon/human, teach_discipline))

	owner.give_st_power(/datum/discipline/bloodheal, vitae_spending_rate)

	//vampires die instantly upon having their heart removed
	RegisterSignal(owner, COMSIG_CARBON_LOSE_ORGAN, PROC_REF(handle_lose_organ))

	//vampires don't die while in crit, they just slip into torpor after 2 minutes of being critted
	RegisterSignal(owner, SIGNAL_ADDTRAIT(TRAIT_CRITICAL_CONDITION), PROC_REF(handle_enter_critical_condition))

	//vampires resist vampire bites better than mortals
	RegisterSignal(owner, COMSIG_MOB_VAMPIRE_SUCKED, PROC_REF(on_vampire_bitten))

	// Apply bashing damage resistance
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMAGE_MODIFIERS, PROC_REF(damage_resistance))

	// Prevent blood loss and regeneration effects
	RegisterSignal(owner, COMSIG_HUMAN_ON_HANDLE_BLOOD, PROC_REF(kindred_blood))

	// Morality loss
	RegisterSignal(owner, COMSIG_PATH_HIT, PROC_REF(adjust_morality))

	RegisterSignal(owner, COMSIG_LIVING_DEATH, PROC_REF(on_kindred_death))

	// Make all food except raw meat repulsive
	var/obj/item/organ/tongue/tongue = owner.get_organ_by_type(/obj/item/organ/tongue)
	tongue?.liked_foodtypes = NONE
	tongue?.disliked_foodtypes = NONE
	tongue?.toxic_foodtypes = ~(GORE | MEAT | RAW)

	// Set blood type
	owner.set_blood_type(BLOOD_TYPE_KINDRED)

	// Apply temperature damage modifiers
	owner.physiology.heat_mod *= 2
	owner.physiology.cold_mod *= 0.25

/datum/splat/vampire/kindred/on_lose()
	owner.set_clan(null)

	UnregisterSignal(owner, list(
		COMSIG_CARBON_LOSE_ORGAN,
		SIGNAL_ADDTRAIT(TRAIT_CRITICAL_CONDITION),
		COMSIG_MOB_VAMPIRE_SUCKED,
		COMSIG_MOB_APPLY_DAMAGE_MODIFIERS,
		COMSIG_HUMAN_ON_HANDLE_BLOOD,
		COMSIG_LIVING_DEATH
	))

	// Reset tongue
	var/obj/item/organ/tongue/tongue = owner.get_organ_by_type(/obj/item/organ/tongue)
	tongue?.liked_foodtypes = initial(tongue.liked_foodtypes)
	tongue?.disliked_foodtypes = initial(tongue.disliked_foodtypes)
	tongue?.toxic_foodtypes = initial(tongue.toxic_foodtypes)

	// Reset blood type
	owner.set_blood_type()

	// Reset temperature damage modifiers
	owner.physiology.heat_mod *= 0.5
	owner.physiology.cold_mod *= 4

	// Reset bloodpool size from Generation
	owner.maxbloodpool = initial(owner.maxbloodpool)

/datum/splat/vampire/kindred/on_lose_or_destroy()
	if (isdummy(owner))
		return

	GLOB.kindred_list -= owner

/datum/splat/vampire/kindred/proc/damage_resistance(datum/source, list/damage_mods, damage_amount, damagetype, def_zone, sharpness, attack_direction, obj/item/attacking_item)
	SIGNAL_HANDLER

	// Kindred take half "bashing" damage, which is normally blunt damage but includes pointy things like bullets because they're undead
	if ((damagetype == BRUTE) && (sharpness != SHARP_EDGED))
		damage_mods += 0.5

/**
 * Signal handler for COMSIG_CARBON_LOSE_ORGAN to near-instantly kill Kindred whose hearts have been removed.
 *
 * Arguments:
 * * source - The Kindred whose organ has been removed.
 * * organ - The organ which has been removed.
 */
/datum/splat/vampire/kindred/proc/handle_lose_organ(mob/living/carbon/human/source, obj/item/organ/organ)
	SIGNAL_HANDLER

	if (!istype(organ, /obj/item/organ/heart))
		return
	// You don't want the character preview going sideways, and they lose organs a lot
	if (isdummy(source))
		return

	addtimer(CALLBACK(src, PROC_REF(lose_heart), source, organ), 0.5 SECONDS)

/datum/splat/vampire/kindred/proc/lose_heart(mob/living/carbon/human/source, obj/item/organ/heart/heart)
	if (source.get_organ_by_type(/obj/item/organ/heart))
		return

	source.death()

/datum/splat/vampire/kindred/proc/handle_enter_critical_condition(mob/living/carbon/human/source)
	SIGNAL_HANDLER

	to_chat(source, span_warning("You can feel yourself slipping into Torpor. You can use succumb to immediately sleep..."))
	addtimer(CALLBACK(src, PROC_REF(slip_into_torpor), source), 2 MINUTES)

/datum/splat/vampire/kindred/proc/slip_into_torpor(mob/living/carbon/human/kindred)
	if (!kindred || (kindred.stat == DEAD))
		return
	if (kindred.stat < SOFT_CRIT)
		return

	kindred.torpor(DAMAGE_TRAIT)

/**
 * On being bit by a vampire
 *
 * This handles vampire bite sleep immunity and any future special interactions.
 */
/datum/splat/vampire/kindred/proc/on_vampire_bitten(datum/source, mob/living/carbon/being_bitten)
	SIGNAL_HANDLER

	return COMPONENT_RESIST_VAMPIRE_KISS

/datum/splat/vampire/kindred/proc/kindred_blood(mob/living/carbon/human/kindred, seconds_per_tick, times_fired)
	SIGNAL_HANDLER

	if(kindred.stat == DEAD)
		return HANDLE_BLOOD_HANDLED

	return HANDLE_BLOOD_NO_NUTRITION_DRAIN|HANDLE_BLOOD_NO_OXYLOSS

/datum/splat/vampire/kindred/proc/on_kindred_death(mob/living/carbon/human/kindred, gibbed)
	if(gibbed)
		return

	kindred.can_be_embraced = FALSE
	var/obj/item/organ/brain/brain = kindred.get_organ_slot(ORGAN_SLOT_BRAIN) //NO REVIVAL EVER
	if(brain)
		brain.organ_flags |= ORGAN_FAILING

	/*
	if(HAS_TRAIT(src, TRAIT_IN_FRENZY))
		exit_frenzymod()
	*/
	SEND_SOUND(kindred, sound('modular_darkpack/modules/vampire_the_masquerade/sounds/final_death.ogg', volume = 50))

	switch(kindred.chronological_age)
		if(-INFINITY to 10) //normal corpse
			return
		if(10 to 50)
			kindred.rot_body(1) //skin takes on a weird colouration
			kindred.visible_message(span_notice("[kindred]'s skin loses some of its colour."))
		if(50 to 100)
			kindred.rot_body(2) //looks slightly decayed
			kindred.visible_message(span_notice("[kindred]'s skin rapidly decays."))
		if(100 to 150)
			kindred.rot_body(3) //looks very decayed
			kindred.visible_message(span_warning("[kindred]'s body rapidly decomposes!"))
		if(150 to 200)
			kindred.rot_body(4) //mummified skeletonised corpse
			kindred.visible_message(span_warning("[kindred]'s body rapidly skeletonises!"))
		if(200 to INFINITY) //turn to ash
			playsound(kindred, 'modular_darkpack/modules/vampire_the_masquerade/sounds/burning_death.ogg', 80, TRUE)
			kindred.dust(just_ash = TRUE, drop_items = TRUE, force = TRUE)

/datum/splat/vampire/kindred/vv_edit_var(var_name, var_value)
	switch (var_name)
		if (NAMEOF(src, generation))
			if (var_value < LOWEST_GENERATION_LIMIT || var_value > HIGHEST_GENERATION_LIMIT)
				return FALSE

			set_generation(var_value)

	return ..()
