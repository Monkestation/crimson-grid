// Homebrew?
/datum/quirk/darkpack/illegal_identity
	name = "Illegal Identity"
	desc = "Illegal immigrant? Died legally? Born a wolf? The cops aren't happy."
	value = 0
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_HIDE_FROM_SCAN
	icon = FA_ICON_PERSON_CIRCLE_QUESTION
	mob_trait = TRAIT_ILLEGAL_IDENTITY
	gain_text = span_warning("You feel legally unprepared.")
	lose_text = span_notice("You feel bureaucratically legitimate.")
	medical_record_text = "Patient is not checked in with valid identification."
	//excluded_clans = list(VAMPIRE_CLAN_RAVNOS) // They are forced to take this
	failure_message = "Oh, there's my actual ID, looks like I misplaced it..."

/datum/quirk/darkpack/illegal_identity/add()
	. = ..()
	if(!ishuman(quirk_holder))
		return
	var/mob/living/carbon/human/criminal = quirk_holder
	var/obj/item/passport/passport = locate() in criminal // In pockets
	if(!passport && criminal.back)
		passport = locate() in criminal.back // In backpack
	if(passport && passport.owner == criminal.real_name)
		passport.link_human(criminal)
	//drivers license too
	var/obj/item/card/drivers_license/license = locate() in criminal // In pockets
	if(!license && criminal.back)
		license = locate() in criminal.back // In backpack
	if(license)
		license.link_human(criminal)
