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
