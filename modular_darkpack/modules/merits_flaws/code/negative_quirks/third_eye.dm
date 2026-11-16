/datum/quirk/darkpack/permanent_third_eye
	name = "Permanent Third Eye"
	desc = "While most third eyes can be closed and appear on the forehead as if it were a scar of some sort, your third eye is almost always wide-open on your forehead. For Salubri, this is a dangerous proposition, exposing you to Kindred who believe the Tremere's stories of your clan being rife with infernal diablerists. For Tremere, this flaw manifests as a miraculous inheritance of the Diablerie of Saulot, almost certainly dooming your standing in Clan Tremere to be mistrusted at best, and immediately killed at worse. Your permanent third eye can be covered with a hat. This flaw is only available to Tremere and Salubri."
	value = -2
	mob_trait = TRAIT_THIRD_EYE
	gain_text = span_notice("Saulot curses you for your forefather's crime. Your third eye opens to never close again.")
	lose_text = span_notice("Your third eye shuts once again.")
	allowed_splats = list(SPLAT_KINDRED)
	included_clans = list(VAMPIRE_CLAN_TREMERE)
	icon = FA_ICON_EYE
	failure_message = "Your blood resists the urge to open the third eye."
	quirk_flags = QUIRK_CHANGES_APPEARANCE
	quirk_flags = QUIRK_HIDE_FROM_SCAN //CRIMSON GRID EDIT ADD | PR: MAKE MEDICAL RECORDS NOT MASQ BREACHY | CHANGE: ADDED THIS TO PREVENT IT FROM BEING SEEN IN COMS

/datum/quirk/darkpack/permanent_third_eye/add_to_holder(mob/living/new_holder, quirk_transfer, client/client_source, unique, announce)
	. = ..()
	if(iscarbon(new_holder))
		var/mob/living/carbon/carbon_holder = new_holder
		var/obj/item/organ/eyes/salubri/three_eyes = new()
		three_eyes.Insert(carbon_holder, TRUE, DELETE_IF_REPLACED)

/datum/quirk/darkpack/permanent_third_eye/remove_from_current_holder(quirk_transfer)
	. = ..()
	// replace eyes
	var/eye_type = /obj/item/organ/eyes
	var/obj/item/organ/eyes/new_eyes = new eye_type()
	new_eyes.Insert(quirk_holder, TRUE, DELETE_IF_REPLACED)


