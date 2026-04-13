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
		TRAIT_WTA_GAROU_BREED,
		TRAIT_WTA_GAROU_AUSPICE,
		TRAIT_WTA_GAROU_TRIBE,
		TRAIT_FERA_FUR,
		TRAIT_FRENETIC_AURA,
		TRAIT_FERA_RENOWN,
	)
	// id = SPLAT_FERA
	incompatible_splats = list(
		/datum/splat/werewolf
	) // We dont support being multiple fera or gaining kinfolk as a fera
	uses_rage = TRUE
	uses_gnosis = TRUE

	splat_priority = SPLAT_PRIO_SHIFTER

	var/list/transformation_list = list()
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
	COOLDOWN_DECLARE(passive_healing_cd)
	COOLDOWN_DECLARE(gnosis_regain_cd)

/datum/splat/werewolf/shifter/on_gain()
	. = ..()
	owner.set_species(/datum/species/human/shifter/homid)
	add_power(/datum/action/cooldown/power/gift/howling)

	RegisterSignal(owner, COMSIG_LIVING_DEATH, PROC_REF(revert_to_breed_form))

/datum/splat/werewolf/shifter/on_lose_or_destroy()
	. = ..()
	if(!QDELETED(owner))
		owner.set_species(/datum/species/human)

	UnregisterSignal(owner, COMSIG_LIVING_DEATH)

/datum/splat/werewolf/shifter/splat_life(seconds_per_tick)
	regain_gnosis_process(seconds_per_tick)
	if(COOLDOWN_FINISHED(src, passive_healing_cd))
		// Crinos heal in all forms. Lupus and homid born dont heal FAST FAST in their breed form
		// their fast healing is represented in day/days in breed-form so we just dont.
		if(is_breed_form() && (get_breed_form_species() != /datum/species/human/shifter/war))
			return
		// 2 to represent leathal***
		owner.heal_storyteller_health(2, heal_scars = TRUE, heal_blood = TRUE)
		COOLDOWN_START(src, passive_healing_cd, 1 TURNS)
	var/datum/species/human/shifter/shifter_species = owner.dna.species
	if(istype(shifter_species))
		if(shifter_species.is_veil_breaching_form(owner) && (!shifter_species.causes_delerium || HAS_TRAIT(owner, TRAIT_PIERCED_VEIL)))
			SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)

// Being used to represent meditating in your caern
/datum/splat/werewolf/shifter/proc/regain_gnosis_process(seconds_per_tick)
	if(!COOLDOWN_FINISHED(src, gnosis_regain_cd))
		return
	for(var/obj/structure/werewolf_totem/totem in GLOB.totems)
		if(totem.broken)
			continue
		if(!(tribe.name in totem.tribes))
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

/* // DARKPACK TODO - CORAX
/datum/splat/werewolf/shifter/corax
	name = "Corax"
	id = SPLAT_CORAX
	transformation_list = list(
		/datum/species/human/shifter/homid,
		/datum/species/human/shifter/war,
		/datum/species/human/shifter/feral
	)
	mob_icons = list(
		SPECIES_FERA_WAR = 'modular_darkpack/modules/werewolf_the_apocalypse/icons/corax_forms/crinos.dmi',
		SPECIES_FERA_FERAL = 'modular_darkpack/modules/werewolf_the_apocalypse/icons/corax_forms/corvid.dmi'
	)
	transform_sound = 'modular_darkpack/modules/werewolf_the_apocalypse/sounds/corax_transform.ogg'
*/


/mob/living/carbon/human/splat/kinfolk
	auto_splats = list(/datum/splat/werewolf/kinfolk)

/mob/living/carbon/human/splat/garou
	auto_splats = list(/datum/splat/werewolf/shifter/garou)
