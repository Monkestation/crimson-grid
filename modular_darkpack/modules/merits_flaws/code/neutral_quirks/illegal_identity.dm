// Homebrew?
/datum/quirk/darkpack/illegal_identity
	name = "Fake Documents"
	desc = "Your documents and paperwork are forged! Any IDs you're carrying are bullshit, and have whatever details you want."
	ttrpg_sources = list(/datum/source_book/homebrew = WE_MADE_IT_UP)
	value = 0
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_HIDE_FROM_SCAN
	icon = FA_ICON_FILE_CIRCLE_XMARK
	mob_trait = TRAIT_ILLEGAL_IDENTITY
	gain_text = span_warning("You feel legally unprepared.")
	lose_text = span_notice("You feel bureaucratically legitimate.")
	medical_record_text = "Patient is missing valid identification."
	//excluded_clans = list(VAMPIRE_CLAN_RAVNOS) // They are forced to take this
	failure_message = "Oh, there's my actual ID, looks like I misplaced it..."

/datum/quirk_constant_data/illegal_identity
	associated_typepath = /datum/quirk/darkpack/illegal_identity
	customization_options = list(
		/datum/preference/text/illegal_identity,
		/datum/preference/choiced/fake_gender,
		/datum/preference/toggle/fake_organ_donor,
		/datum/preference/numeric/fake_age
	)

/datum/quirk/darkpack/illegal_identity/add()
	. = ..()
	var/mob/living/carbon/human/criminal = astype(quirk_holder)
	if(!criminal)
		return
	for(var/item in criminal.gather_belongings()) // Relink passports and cards after quirk is applied
		if(istype(item, /obj/item/passport))
			var/obj/item/passport/passport = item
			passport.link_human(criminal)
			continue
		if(istype(item, /obj/item/card))
			var/obj/item/card/card = item
			card.link_to_human(criminal)
			continue

