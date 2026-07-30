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



/// Subtype quirk that has some bonus logic to spawn items for the player.
/datum/quirk/darkpack/item_quirk
	/// Lazylist of strings describing where all the quirk items have been spawned.
	var/list/where_items_spawned
	/// If true, the backpack automatically opens on post_add(). Usually set to TRUE when an item is equipped inside the player's backpack.
	var/open_backpack = FALSE
	abstract_type = /datum/quirk/darkpack/item_quirk

/**
 * Handles inserting an item in any of the valid slots provided, then allows for post_add notification.
 *
 * If no valid slot is available for an item, the item is left at the mob's feet.
 * Arguments:
 * * quirk_item - The item to give to the quirk holder. If the item is a path, the item will be spawned in first on the player's turf.
 * * valid_slots - List of LOCATION_X that is fed into [/mob/living/carbon/proc/equip_in_one_of_slots].
 * * flavour_text - Optional flavour text to append to the where_items_spawned string after the item's location.
 * * default_location - If the item isn't possible to equip in a valid slot, this is a description of where the item was spawned.
 * * notify_player - If TRUE, adds strings to where_items_spawned list to be output to the player in [/datum/quirk/darkpack/item_quirk/post_add()]
 */
/datum/quirk/darkpack/item_quirk/proc/give_item_to_holder(obj/item/quirk_item, list/valid_slots, flavour_text = null, default_location = "at your feet", notify_player = FALSE)
	if(ispath(quirk_item))
		quirk_item = new quirk_item(get_turf(quirk_holder))

	var/mob/living/carbon/human/human_holder = quirk_holder

	var/where = human_holder.equip_in_one_of_slots(quirk_item, valid_slots, qdel_on_fail = FALSE, indirect_action = TRUE) || default_location

	if(where == LOCATION_BACKPACK)
		open_backpack = TRUE

	if(notify_player)
		LAZYADD(where_items_spawned, span_boldnotice("You have \a [quirk_item] [where]. [flavour_text]"))

/datum/quirk/darkpack/item_quirk/post_add()
	if(open_backpack)
		var/mob/living/carbon/human/human_holder = quirk_holder
		// post_add() can be called via delayed callback. Check they still have a backpack equipped before trying to open it.
		if(human_holder.back)
			human_holder.back.atom_storage.show_contents(human_holder)

	for(var/chat_string in where_items_spawned)
		to_chat(quirk_holder, chat_string)

	where_items_spawned = null
