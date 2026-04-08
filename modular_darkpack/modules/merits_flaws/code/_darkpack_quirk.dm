/datum/quirk/darkpack
	abstract_type = /datum/quirk/darkpack
	darkpack_allowed = TRUE
	/// List of splats (vampire clans/types) this quirk is allowed for. Null = all allowed
	var/list/allowed_splats
	/// List of splats this quirk is explicitly forbidden for
	var/list/forbidden_splats
	/// Excluded clans from this quirk (exclusive to vampire). E.g "Cappadocians cannot take this flaw"
	var/list/excluded_clans
	/// Included clans for this quirk (exclusive to vampire). E.g "Only Cappadocians can take this flaw"
	var/list/included_clans
	/// Minimum Generation
	var/minimum_generation
	/// Unique failure message on joining the round (in case someone joins with an incompatible quirk on their savefile for some reason)
	var/failure_message = "One of the quirks you've selected hasn't applied - your character is ineligible to use it!"

/datum/quirk/darkpack/add_to_holder(mob/living/new_holder, quirk_transfer = FALSE, client/client_source, unique = TRUE, announce = TRUE)
	if(forbidden_splats)
		for(var/datum/splat/splat as anything in new_holder.splats)
			if(splat.id in forbidden_splats)
				return FALSE

	if(allowed_splats)
		var/has_allowed_splat = FALSE
		for(var/datum/splat/splat as anything in new_holder.splats)
			if(splat.id in allowed_splats)
				has_allowed_splat = TRUE
				break
		if(!new_holder.splats && (SPLAT_NONE in allowed_splats))
			has_allowed_splat = TRUE
		if(!has_allowed_splat)
			return FALSE

	if(excluded_clans && get_kindred_splat(new_holder))
		var/datum/splat/vampire/kindred/kindred_splat = get_kindred_splat(new_holder)
		if(kindred_splat.clan && (kindred_splat.clan.id in excluded_clans))
			to_chat(new_holder, span_warning("[failure_message]"))
			return FALSE

	if(minimum_generation)
		var/datum/splat/vampire/kindred/kindred_splat = get_kindred_splat(new_holder)
		if(kindred_splat.generation < minimum_generation)
			to_chat(new_holder, span_warning("[failure_message]"))
			return FALSE
	return ..()

/datum/quirk/darkpack/is_splat_appropriate(datum/splat/mob_splat)
	if(!..())
		return FALSE

	if(!forbidden_splats && !allowed_splats && !excluded_clans)
		return TRUE

	var/datum/splat/splat_path = GLOB.splat_prototypes[mob_splat]
	// If splat is null, just assume we have no splat.
	var/splat_id = splat_path?.id ? splat_path.id : SPLAT_NONE

	if(forbidden_splats && (splat_id in forbidden_splats))
		return FALSE

	if(allowed_splats && !(splat_id in allowed_splats))
		return FALSE

	return TRUE

/datum/quirk/darkpack/proc/is_clan_appropriate(datum/subsplat/vampire_clan/clan)
	if(!excluded_clans && !included_clans)
		return TRUE

	if(!clan)
		return TRUE

	if(excluded_clans && (clan.id in excluded_clans))
		return FALSE

	if(included_clans && !(clan.id in included_clans))
		return FALSE

	return TRUE

