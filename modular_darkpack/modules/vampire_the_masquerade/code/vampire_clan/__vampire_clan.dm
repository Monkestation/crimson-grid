/datum/subsplat/vampire_clan
	abstract_type = /datum/subsplat/vampire_clan
	/// The icon for this clan. Used in preferences.
	var/icon
	/// Description of the Clan's supernatural curse
	var/curse

	/// List of Disciplines that are innate to this Clan
	var/list/clan_disciplines = list()
	/// List of Disciplines that are rejected by this Clan
	var/list/restricted_disciplines = list()
	/// List of traits that are applied to members of this Clan
	var/list/clan_traits = list()

	/// The Clan's unique body sprite
	var/alt_sprite
	/// If the Clan's unique body sprites need to account for skintone
	var/alt_sprite_greyscale
	/// If members of this Clan can't have hair
	var/no_hair
	/// If members of this Clan can't have facial hair
	var/no_facial

	/// Default clothing for male members of this Clan
	var/male_clothes
	/// Default clothing for female members of this Clan
	var/female_clothes

	/// List of unnatural features that members of this Clan can choose
	var/list/clan_marks
	/// Clan accessory that's selected by default
	var/default_accessory

	/// If members of this Clan are on a Path of Enlightenment by default
	var/enlightenment

	/// If this Clan needs a whitelist to select and play
	var/whitelisted = FALSE

	/// daimoinon 1 text
	var/sense_the_sin_text = "has been abandoned by the cold ocean of the night with nobody to keep them afloat."

/**
 * Applies Clan-specific effects to the mob
 * gaining this Clan. Will alter the mob's
 * sprite according to the alternate sprite
 * and appearance variables, and apply the
 * Clan's traits to the mob. If the Clan is
 * being given as the mob joins the round,
 * it'll cause on_join_round to trigger when the
 * client logs into the mob.
 *
 * Arguments:
 * * gaining_mob - Human being given the splat
 * * joining_round - If this splat is being applied as the mob joins the round
 */
/datum/subsplat/vampire_clan/on_gain(mob/living/carbon/human/gaining_mob, datum/splat/gaining_splat, joining_round)
	. = ..()

	// Apply alternative sprites
	if (alt_sprite)
		gaining_mob.set_body_sprite(alt_sprite, alt_sprite_greyscale)

	// Remove hair if the Clan demands it
	if (no_hair)
		gaining_mob.set_hairstyle("Bald", update = FALSE)

	// Remove facial hair if the Clan demands it
	if (no_facial)
		gaining_mob.set_facial_hairstyle("Shaved", update = FALSE)

	// Add unique Clan features as traits
	for (var/trait in clan_traits)
		ADD_TRAIT(gaining_mob, trait, CLAN_TRAIT)

	// Mostly for summons to not kill you.
	gaining_mob.add_faction(id)

/datum/subsplat/vampire_clan/on_lose(mob/living/carbon/human/losing_mob)
	. = ..()

	// Remove unique Clan feature traits
	for (var/trait in clan_traits)
		REMOVE_TRAIT(losing_mob, trait, CLAN_TRAIT)

	// Sets the losing_mob back to their default body sprite
	if (alt_sprite)
		losing_mob.set_body_sprite(ignore_clan = TRUE)

	clear_old_overlays(losing_mob)

	losing_mob.remove_faction(id)

/datum/subsplat/vampire_clan/apply_after_setup(mob/living/carbon/human/source)
	. = ..()

	// if they spawn with the masquerade violating face trait, give them the things to cover up so they aren't stuck in the sewer.
	if (HAS_TRAIT(source, TRAIT_MASQUERADE_VIOLATING_FACE) || HAS_TRAIT(source, TRAIT_MASQUERADE_VIOLATING_EYES))
		if (length(GLOB.masquerade_latejoin))
			var/turf/join_spot = pick(GLOB.masquerade_latejoin)
			if(join_spot)
				source.forceMove(join_spot)

	if(HAS_TRAIT(source, TRAIT_MASQUERADE_VIOLATING_FACE) && !(source.obscured_slots & HIDEFACE))
		var/obj/item/clothing/mask/vampire/venetian_mask/fancy/new_mask = new(source.loc)
		source.equip_to_appropriate_slot(new_mask, FALSE)
	if(HAS_TRAIT(source, TRAIT_MASQUERADE_VIOLATING_EYES) && !source.is_eyes_covered())
		var/obj/item/clothing/glasses/vampire/sun/new_glasses = new(source.loc)
		source.equip_to_appropriate_slot(new_glasses, FALSE)

	// We dont have masquerade breaching body. YET.
	/*
		var/obj/item/clothing/suit/hooded/robes/darkred/new_robe = new(source.loc)
		source.equip_to_appropriate_slot(new_robe, FALSE)
	*/


/// effect from daimonion psychomania
/datum/subsplat/vampire_clan/proc/psychomania_effect(mob/living/target, mob/living/owner)
	to_chat(target, span_cult("THE BEAST SCREAMS IN MY MIND TO RUN"))
	new /obj/effect/client_image_holder/baali_demon(get_turf(target), list(target))


/**
 * Gives the human a vampiric Clan, applying
 * on_gain effects and post_gain effects if the
 * parameter is true. Can also remove Clans
 * with or without a replacement, and apply
 * on_lose effects. Will have no effect the human
 * is being given the Clan it already has.
 *
 * Arguments:
 * * setting_clan - Typepath or Clan singleton to give to the human
 * * joining_round - If this Clan is being given at roundstart and should call on_join_round
 */
/mob/living/carbon/human/proc/set_clan(setting_clan, joining_round)
	var/datum/subsplat/vampire_clan/previous_clan = get_clan()

	// Convert IDs and typepaths to singletons, or just directly assign if already singleton
	var/datum/subsplat/vampire_clan/new_clan = get_vampire_clan(setting_clan)

	// Handle losing Clan
	previous_clan?.on_lose(src)

	var/datum/splat/vampire/kindred/kindred = get_kindred_splat(src)
	if (!kindred)
		return

	kindred.clan = new_clan

	// Clan's been cleared, don't apply effects
	if (!new_clan)
		return

	// Gaining Clan effects
	kindred.clan.on_gain(src, kindred, joining_round)

/mob/living/proc/get_clan()
	RETURN_TYPE(/datum/subsplat/vampire_clan)

	return get_kindred_splat(src)?.clan

/mob/living/proc/is_clan(clan_type)
	return istype(get_clan(), clan_type)

/datum/subsplat/vampire_clan/proc/clear_old_overlays(mob/living/carbon/human/losing_mob)
	var/needs_update = FALSE
	for(var/obj/item/bodypart/part as anything in losing_mob.get_bodyparts())
		for(var/clan_mark in clan_marks)
			part.remove_bodypart_overlay(clan_mark, update = FALSE)
			needs_update = TRUE

	if(needs_update && !(losing_mob.living_flags & STOP_OVERLAY_UPDATE_BODY_PARTS))
		losing_mob.update_body_parts()

/datum/subsplat/vampire_clan/show_lore(mob/user)
	. = ..()
	if(curse)
		to_chat(user, span_danger("<br>CURSE: [curse]"))

