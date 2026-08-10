// DARKPACK TODO - This should include clans.

/**
 * # Subsplat
 *
 * Represents the "splats" described in splatbooks, e.g. clans, tribes, factions and kiths.
 * These are the "real" splats but we call them subsplats as we used that type path for what WW calls supernaturals
 * A more official term sometimes used, especially for games in the Chronicles of Darkness, is "character axis".
 *
 * These at present are only stored on splats as a var for a given subtype and requires mostly implementing its own handling for everything.
 */
/datum/subsplat
	abstract_type = /datum/subsplat

	/// Name of the splat
	var/name
	/// Description of what the splat is and what it does
	var/desc
	/// If set, the roleplay level that is displayed in prefrences as a guide to players.
	var/roleplay_level
	/// ID for trait sources and whatnot
	var/id

	/// Typepath of keys for this subsplats's exclusive hideout
	var/obj/item/vamp/keys/subsplat_keys
	/// If we check the list of ids of city doors before granting the subsplat key
	var/check_doors_for_keys = TRUE

/datum/subsplat/proc/on_gain(mob/living/carbon/human/gaining_mob, datum/splat/gaining_splat, joining_round)
	SHOULD_CALL_PARENT(TRUE)

	// Applies on_join_round effects when a client logs into this mob
	if(joining_round)
		RegisterSignal(gaining_mob, COMSIG_MOB_LOGIN, PROC_REF(on_join_round))

/**
 * Undoes the effects of on_gain more or less
 * remove the effects of gaining the subsplat.
 *
 * Arguments:
 * * losing_mob - Human losing the subsplat.
 */
/datum/subsplat/proc/on_lose(mob/living/carbon/human/losing_mob)
	SHOULD_CALL_PARENT(TRUE)
	UnregisterSignal(losing_mob, COMSIG_MOB_LOGIN)
	return


/**
 * Applies subsplat-specific effects when the
 * mob that has the subsplat logs into their mob
 * at roundstart. Anything that's not innate
 * to the subsplat and more part of its social
 * structure or whatnot should go in here.
 * Will teleport Masquerade-breaching Clans to
 * safe areas and give them their subsplat keys by
 * default.
 *
 * Arguments:
 * * joining - Human with this subsplat joining the round.
 */
/datum/subsplat/proc/on_join_round(mob/living/carbon/human/joining)
	SIGNAL_HANDLER

	SHOULD_CALL_PARENT(TRUE)

	if(subsplat_keys && check_doors_for_keys && key_has_matching_door(subsplat_keys))
		joining.put_in_r_hand(new subsplat_keys(joining))

	UnregisterSignal(joining, COMSIG_MOB_LOGIN)

/// Displays description and roleplay level of the subsplat.
/datum/subsplat/proc/show_lore(mob/user)
	if(desc)
		to_chat(user, span_notice("[uppertext(name)]<br>[desc]"))
	if(roleplay_level)
		to_chat(user, span_notice("<br>ROLEPLAY LEVEL: [roleplay_level] <br>Roleplay levels, or, the difficulty to play and portray a character from that auspice, are as follows: Beginner Friendly, Intermediate, Advanced."))
