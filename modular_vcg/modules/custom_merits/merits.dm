/datum/quirk/darkpack/forked_tongue
	name = "Forked Tongue"
	desc = "You have a forked tongue that makes pronouncing the letter s sound like hissing."
	icon = FA_ICON_S
	value = -1
	allowed_splats = list(SPLAT_KINDRED)
	included_clans = list(VAMPIRE_CLAN_SETITE, VAMPIRE_CLAN_WARRIOR_SETITE, VAMPIRE_CLAN_TLACIQUE)
	/// The original tongue from before the forked one was applied
	var/obj/item/organ/old_organ

/datum/quirk/darkpack/forked_tongue/add_unique(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	old_organ = human_holder.get_organ_slot(ORGAN_SLOT_TONGUE)
	var/obj/item/organ/tongue/lizard/forked = new
	forked.Insert(human_holder, special = TRUE)
	if(old_organ)
		old_organ.moveToNullspace()
		STOP_PROCESSING(SSobj, old_organ)

/datum/quirk/darkpack/forked_tongue/remove()
	if(old_organ)
		old_organ.Insert(quirk_holder, special = TRUE)
	old_organ = null

/datum/quirk/darkpack/permafangs/fake
	name = "Cosmetic Fangs"
	desc = "You've had your teeth filed or are wearing prosthetics for one reason or another, giving the appearance of fangs in your mouth. Many view your fangs as something exotic or eccentric but a few superstitious may find this more than exotic..."
	value = -1
	gain_text = span_notice("Your feel your teeth becoming sharp")
	lose_text = span_notice("You feel your teeth becoming normal again.")
	allowed_splats = list(SPLAT_NONE, SPLAT_GHOUL)
	failure_message = "You feel your teeth becoming normal again."

/datum/quirk/darkpack/wyrmtainted
	name = "Wyrm Tainted"
	desc = "For some reason you have the stink of the Wyrm about you."
	value = -4
	mob_trait = TRAIT_WYRMTAINTED
	gain_text = span_notice("You feel tainted.")
	lose_text = span_notice("You don't feel tainted anymore.")
	allowed_splats = list(SPLAT_NONE, SPLAT_GHOUL, SPLAT_KINFOLK)
	icon = FA_ICON_WORM
	failure_message = "You don't feel tainted anymore."

/datum/quirk/item_quirk/addict
	var/list/forbidden_splats = list(SPLAT_KINDRED)

/datum/quirk/item_quirk/addict/add_to_holder(mob/living/new_holder, quirk_transfer = FALSE, client/client_source, unique = TRUE, announce = TRUE)
	for(var/datum/splat/splat as anything in new_holder.splats)
		if(splat.id in forbidden_splats)
			return FALSE
	return ..()

/datum/quirk/item_quirk/addict/is_splat_appropriate(datum/splat/mob_splat)
	if(!..())
		return FALSE
	var/datum/splat/splat_path = GLOB.splat_prototypes[mob_splat]
	// If splat is null, just assume we have no splat.
	var/splat_id = splat_path?.id ? splat_path.id : SPLAT_NONE
	if(forbidden_splats && (splat_id in forbidden_splats))
		return FALSE
	return TRUE

/datum/quirk/item_quirk/addict/smoker
	darkpack_allowed = TRUE
	value = -1

/datum/quirk/item_quirk/addict/alcoholic
	darkpack_allowed = TRUE
	value = -1

/datum/quirk/item_quirk/addict/junkie
	darkpack_allowed = TRUE
	value = -2
