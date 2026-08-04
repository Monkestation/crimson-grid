/* CRIMSON GRID EDIT - Everyone has identification now by default.
/datum/loadout_item/pocket_items/passport
	name = "Identification"
	item_path = /obj/item/passport

/datum/loadout_item/pocket_items/passport/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(visuals_only)
		return ..()
	var/country = equipper?.client?.prefs?.read_preference(/datum/preference/choiced/country_of_origin)
	//USA Country of Origin gets drivers license, not passport
	if(country == "United States")
		LAZYADD(outfit.backpack_contents, /obj/item/card/drivers_license)
	else
		return ..()
*/

/obj/item/passport
	name = "passport"
	desc = "A book with someone's license, photo, and identifying information. Don't lose it!"
	icon = 'modular_darkpack/modules/government/icons/docs.dmi'
	worn_icon = 'modular_darkpack/modules/clothes/icons/worn.dmi'
	icon_state = "passport1"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_ID
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/government/icons/docsonfloor.dmi')

	var/closed = TRUE
	/// String of who the owner of the passport.
	var/owner = ""
	/// Country of origin for the passport holder
	var/country_of_origin = "United States"
	/// If the ID is a counterfit.
	var/fake = FALSE
	/// If the NAME does not belong to the person.
	var/fake_identity = FALSE
	var/datum/storyteller_roll/investigation/examine_roll

/* CRIMSON GRID EDIT
/obj/item/passport/Initialize(mapload)
	. = ..()
	var/mob/living/carbon/human/user = null
	if(ishuman(loc)) // In pockets
		user = loc
	else if(ishuman(loc?.loc)) // In backpack
		user = loc
	if(user)
		// Init and equiping via loadout are both too soon to be able to catch the illegal identity quirk
		link_human(user)
*/

/obj/item/passport/proc/link_human(mob/living/carbon/human/user)
	if(HAS_TRAIT(user, TRAIT_ILLEGAL_IDENTITY))
		fake = TRUE
		fake_identity = TRUE

	if(fake_identity)
		owner = user.generate_random_mob_name(TRUE)
	else
		owner = user.real_name

	if(user.client?.prefs)
		var/pref_country = user.client.prefs.read_preference(/datum/preference/choiced/country_of_origin)
		if(pref_country)
			country_of_origin = pref_country
			if(pref_country == "United States")
				var/pref_state = user.client.prefs.read_preference(/datum/preference/choiced/state_of_origin)
				if(pref_state)
					country_of_origin = "[pref_state], United States"

/obj/item/passport/examine(mob/user)
	. = ..()
	if(!examine_roll)
		examine_roll = new()
		examine_roll.reroll_cooldown = 1 SCENES
	var/roll_result = examine_roll.st_roll(user, src)
	if(!closed && owner)
		. += span_notice("It reads as belonging to [owner] from [country_of_origin].")
		if(fake && (roll_result == ROLL_SUCCESS))
			. += span_notice("It looks like a crude counterfeit.")

/obj/item/passport/attack_self(mob/user)
	. = ..()
	if(closed)
		closed = FALSE
		icon_state = "passport0"
		to_chat(user, span_notice("You open [src]."))
	else
		closed = TRUE
		icon_state = "passport1"
		to_chat(user, span_notice("You close [src]."))
