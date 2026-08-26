// Represents the system not that they are a werewolf/fera
/datum/splat/werewolf
	abstract_type = /datum/splat/werewolf

	power_type = /datum/action/cooldown/power/gift

	// Perm is for rolls
	// Non-perm/ or temp is for expenditure
	var/uses_rage = FALSE
	var/permanent_rage = 10
	var/rage = 0
	// without a merit kinfolk cannot use gnosis
	var/uses_gnosis = FALSE
	var/permanent_gnosis = 10
	var/gnosis = 0

	var/list/renown = list()
	var/renown_rank = RANK_CUB

	var/datum/subsplat/werewolf/breed_form/breed_form
	var/datum/subsplat/werewolf/auspice/auspice
	var/datum/subsplat/werewolf/tribe/tribe

/datum/splat/werewolf/proc/adjust_rage(amount, sound = TRUE)
	if(!uses_rage)
		return FALSE

	if(amount > 0)
		if(rage < permanent_rage)
			rage = min(permanent_rage, rage+amount)
			if(sound)
				SEND_SOUND(owner, sound('modular_darkpack/modules/werewolf_the_apocalypse/sounds/rage_increase.ogg', volume = 50))
			to_chat(owner, span_userdanger("<b>RAGE INCREASES</b>"))
		else
			return FALSE
	if(amount < 0)
		if(rage > 0)
			rage = max(0, rage+amount)
			if(sound)
				SEND_SOUND(owner, sound('modular_darkpack/modules/werewolf_the_apocalypse/sounds/rage_decrease.ogg', volume = 50))
			to_chat(owner, span_userdanger("<b>RAGE DECREASES</b>"))
		else
			return FALSE

	owner.update_werewolf_hud()
	return TRUE

/datum/splat/werewolf/proc/adjust_gnosis(amount, sound = TRUE)
	if(!uses_gnosis)
		return FALSE

	if(amount > 0)
		if(gnosis < permanent_gnosis)
			gnosis = clamp(gnosis + amount, 0, permanent_gnosis)
			if(sound)
				SEND_SOUND(owner, sound('modular_darkpack/modules/deprecated/sounds/humanity_gain.ogg', volume = 50))
			to_chat(owner, span_boldnotice("<b>GNOSIS INCREASES</b>"))
		else
			return FALSE
	if(amount < 0)
		if(gnosis > 0)
			gnosis = clamp(gnosis + amount, 0, permanent_gnosis)
			if(sound)
				SEND_SOUND(owner, sound('modular_darkpack/modules/werewolf_the_apocalypse/sounds/rage_decrease.ogg', volume = 50))
			to_chat(owner, span_boldnotice("<b>GNOSIS DECREASES</b>"))
		else
			return FALSE

	owner.update_werewolf_hud()
	return TRUE


/datum/splat/werewolf/kinfolk
	name = "Kinfolk"
	id = SPLAT_KINFOLK

	splat_priority = SPLAT_PRIO_KINFOLK
	half_splat = TRUE

	splat_traits = list(
		TRAIT_FERA_RENOWN,
	)

	// incompatible_splats = list(/datum/splat/werewolf/shifter) // TODO: Becoming a shifter should get rid of your kinfolk splat

/datum/splat/werewolf/shifter
	abstract_type = /datum/splat/werewolf/shifter
	splat_traits = list(
		TRAIT_POSSIBLE_WYRM,
		TRAIT_FERA_FORMS,
		TRAIT_FERA_FUR,
		TRAIT_FERA_RENOWN,
		TRAIT_FRENETIC_AURA,
		TRAIT_SILVER_WEAKNESS,
	)
	// id = SPLAT_FERA
	incompatible_splats = list(
		/datum/splat/werewolf
	) // We dont support being multiple fera or gaining kinfolk as a fera
	uses_rage = TRUE
	uses_gnosis = TRUE

	splat_priority = SPLAT_PRIO_SHIFTER

	var/list/transformation_list = list()
	/// Stats added and removed upon gaining the species of the splat. Assoc list indexed by the species ids for each form
	var/list/transformation_stats
	var/transform_sound = 'modular_darkpack/modules/werewolf_the_apocalypse/sounds/transform.ogg'
	COOLDOWN_DECLARE(transform_cd)
	/**
	 * [SPECIES_ID -> dmi path] assoc list
	 *
	 * Only required for forms that you can into (corax lack dire and bestial)
	 * and acctually have custom sprite behavoir (homid are exempt, bestial are fluff added to homid)
	 */
	var/list/mob_icons = list(
		SPECIES_FERA_BESTIAL = 'modular_darkpack/modules/werewolf_the_apocalypse/icons/garou_forms/glabro.dmi',
		SPECIES_FERA_WAR = 'modular_darkpack/modules/werewolf_the_apocalypse/icons/garou_forms/crinos.dmi',
		SPECIES_FERA_DIRE = 'modular_darkpack/modules/werewolf_the_apocalypse/icons/garou_forms/hispo.dmi',
		SPECIES_FERA_FERAL = 'modular_darkpack/modules/werewolf_the_apocalypse/icons/garou_forms/lupus.dmi'
	)
	var/transform_hud_icon = 'modular_darkpack/modules/werewolf_the_apocalypse/icons/hud_transforms.dmi'
	/// Type path of the animal we look like in our feral form
	var/mob/living/basic/mimmicing_animal
	COOLDOWN_DECLARE(passive_healing_cd)
	COOLDOWN_DECLARE(passive_regrowth_cd)
	COOLDOWN_DECLARE(gnosis_regain_cd)

	/// Emote uses for activations of gifts and other things
	var/warcry_emote = "howl"

/datum/splat/werewolf/shifter/on_gain()
	. = ..()
	owner.set_species(/datum/species/human/shifter/homid)
	add_power(/datum/action/cooldown/power/gift/howling)
	COOLDOWN_START(src, passive_regrowth_cd, 8 MINUTES)

	RegisterSignal(owner, COMSIG_LIVING_DEATH, PROC_REF(revert_to_breed_form))

/datum/splat/werewolf/shifter/on_lose_or_destroy()
	. = ..()
	if(!QDELETED(owner))
		owner.set_species(/datum/species/human)

	remove_power(/datum/action/cooldown/power/gift/howling)
	UnregisterSignal(owner, COMSIG_LIVING_DEATH)

/datum/splat/werewolf/shifter/splat_life(seconds_per_tick)
	regain_gnosis_process(seconds_per_tick)
	// Crinos heal in all forms. Lupus and homid born dont heal FAST FAST in their breed form.
	// their fast healing is represented in day/days in breed-form so we just dont.
	var/can_passively_heal = !(is_breed_form() && (get_breed_form_species() != /datum/species/human/shifter/war))
	if(COOLDOWN_FINISHED(src, passive_healing_cd))
		if(can_passively_heal)
			// 2 to represent lethal. Fera passive regen closes burn, but not aggravated damage.
			owner.heal_storyteller_health(2, heal_aggravated = FALSE, heal_scars = TRUE, heal_blood = TRUE, heal_burn = TRUE)
			// Keep organ healing ticking so internal damage recovers even between major regrowth pulses.
			owner.adjust_organ_loss(ORGAN_SLOT_BRAIN, -0.5 * seconds_per_tick, required_organ_flag = ORGAN_ORGANIC)
			owner.adjust_organ_loss(ORGAN_SLOT_HEART, -0.5 * seconds_per_tick, required_organ_flag = ORGAN_ORGANIC)
			owner.adjust_organ_loss(ORGAN_SLOT_LUNGS, -0.5 * seconds_per_tick, required_organ_flag = ORGAN_ORGANIC)
			owner.adjust_organ_loss(ORGAN_SLOT_STOMACH, -0.5 * seconds_per_tick, required_organ_flag = ORGAN_ORGANIC)
			owner.adjust_organ_loss(ORGAN_SLOT_LIVER, -0.5 * seconds_per_tick, required_organ_flag = ORGAN_ORGANIC)
			owner.adjust_organ_loss(ORGAN_SLOT_EYES, -0.5 * seconds_per_tick, required_organ_flag = ORGAN_ORGANIC)
			owner.adjust_organ_loss(ORGAN_SLOT_EARS, -0.5 * seconds_per_tick, required_organ_flag = ORGAN_ORGANIC)
		COOLDOWN_START(src, passive_healing_cd, 1 TURNS)

	if(COOLDOWN_FINISHED(src, passive_regrowth_cd))
		owner.regenerate_organs()
		if(length(owner.get_missing_limbs()))
			owner.regenerate_limbs()
		COOLDOWN_START(src, passive_regrowth_cd, 8 MINUTES)

	var/datum/species/human/shifter/shifter_species = owner.dna.species
	if(istype(shifter_species))
		if(shifter_species.is_veil_breaching_form(owner) && !causes_delirium())
			SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)
		if(causes_delirium())
			for(var/mob/living/carbon/human/guy in oviewers(owner, DEFAULT_SIGHT_DISTANCE))
				if(!guy.affected_by_delirium())
					continue
				guy.apply_status_effect(STATUS_EFFECT_DELIRIUM, owner)

/datum/splat/werewolf/shifter/proc/causes_delirium()
	var/datum/species/human/shifter/shifter_species = owner.dna.species
	if(!istype(shifter_species))
		return FALSE
	if(HAS_TRAIT(owner, TRAIT_PIERCED_VEIL))
		return FALSE
	return shifter_species.form_causes_delirium

// Being used to represent meditating in your caern
/datum/splat/werewolf/shifter/proc/regain_gnosis_process(seconds_per_tick)
	if(!COOLDOWN_FINISHED(src, gnosis_regain_cd))
		return
	for(var/obj/structure/werewolf_totem/totem in GLOB.totems)
		if(totem.broken)
			continue
		if(!totem.is_friend_of_totem(owner))
			continue
		if(get_area(totem) != get_area(owner))
			continue
		adjust_gnosis(1, TRUE)
		COOLDOWN_START(src, gnosis_regain_cd, 1 SCENES)

/datum/splat/werewolf/shifter/garou
	name = "Garou"
	id = SPLAT_GAROU
	transformation_list = list(
		/datum/species/human/shifter/homid,
		/datum/species/human/shifter/bestial,
		/datum/species/human/shifter/war,
		/datum/species/human/shifter/dire,
		/datum/species/human/shifter/feral
	)
	transformation_stats = list(
		SPECIES_FERA_BESTIAL = list(
			STAT_STRENGTH = 2,
			STAT_STAMINA = 2,
			STAT_MANIPULATION = -2,
			STAT_APPEARANCE = -1
		),
		SPECIES_FERA_WAR = list(
			STAT_STRENGTH = 4,
			STAT_STAMINA = 3,
			STAT_DEXTERITY = 1,
			STAT_MANIPULATION = -3,
			// STAT_APPEARANCE = 0 // NOT YET SUPPORTED
		),
		SPECIES_FERA_DIRE = list(
			STAT_STRENGTH = 3,
			STAT_STAMINA = 3,
			STAT_DEXTERITY = 2,
			STAT_MANIPULATION = -3,
		),
		SPECIES_FERA_FERAL = list(
			STAT_STRENGTH = 1,
			STAT_STAMINA = 2,
			STAT_DEXTERITY = 2,
			STAT_MANIPULATION = -3,
		)
	)
	mimmicing_animal = /mob/living/basic/pet/dog/wolf

/datum/splat/werewolf/shifter/corax
	name = "Corax"
	id = SPLAT_CORAX
	splat_traits = list(
		TRAIT_POSSIBLE_WYRM,
		TRAIT_FERA_FORMS,
		TRAIT_FERA_FUR,
		TRAIT_FERA_RENOWN,
		TRAIT_FERA_FLIGHT,
		TRAIT_FRENETIC_AURA,
		TRAIT_GOLD_WEAKNESS,
		TRAIT_TRUE_NIGHT_VISION, // CRIMSON GRID ADDITION - allow corax to see in the dark, so they can snoop on people better
	)
	transformation_list = list(
		/datum/species/human/shifter/homid,
		/datum/species/human/shifter/war,
		/datum/species/human/shifter/feral
	)
	transformation_stats = list(
		SPECIES_FERA_WAR = list(
			STAT_STRENGTH = 1,
			STAT_STAMINA = 1,
			STAT_DEXTERITY = 1,
			STAT_MANIPULATION = -2,
			STAT_PERCEPTION = 3,
			// STAT_APPEARANCE = 0 // NOT YET SUPPORTED
		),
		SPECIES_FERA_FERAL = list(
			STAT_STRENGTH = -1,
			STAT_DEXTERITY = 1,
			STAT_MANIPULATION = -3,
			STAT_PERCEPTION = 4,
		)
	)
	transform_sound = 'modular_darkpack/modules/werewolf_the_apocalypse/sounds/corax_transform.ogg'
	mob_icons = list(
		SPECIES_FERA_WAR = 'modular_darkpack/modules/werewolf_the_apocalypse/icons/corax_forms/crinos.dmi',
		SPECIES_FERA_FERAL = 'modular_darkpack/modules/werewolf_the_apocalypse/icons/corax_forms/corvid.dmi'
	)
	transform_hud_icon = 'modular_darkpack/modules/werewolf_the_apocalypse/icons/hud_transforms_corax.dmi'
	mimmicing_animal = /mob/living/basic/corvid/raven

	warcry_emote = "caw"

/datum/splat/werewolf/shifter/corax/on_gain()
	. = ..()
	add_power(/datum/action/cooldown/power/gift/eye_drink)
	owner.update_sight() // CRIMSON GRID ADDITION - allow corax to see in the dark, so they can snoop on people better

/datum/splat/werewolf/shifter/corax/on_lose_or_destroy()
	. = ..()
	remove_power(/datum/action/cooldown/power/gift/eye_drink)
	// CRIMSON GRID ADDITION START - allow corax to see in the dark, so they can snoop on people better
	if(!QDELETED(owner))
		owner.update_sight()
	// CRIMSON GRID ADDITION END

/mob/living/carbon/human/splat/kinfolk
	auto_splats = list(/datum/splat/werewolf/kinfolk)

/mob/living/carbon/human/splat/garou
	auto_splats = list(/datum/splat/werewolf/shifter/garou)

/mob/living/carbon/human/splat/corax
	auto_splats = list(/datum/splat/werewolf/shifter/corax)
