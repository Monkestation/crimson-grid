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
	var/dob
	var/issued_year
	var/expiry_year
	var/owner_gender
	var/mob/living/carbon/human/our_human
	/// Country of origin for the passport holder
	var/country_of_origin = "United States"
	/// If the ID is a counterfit.
	var/fake = FALSE
	/// If the NAME does not belong to the person.
	var/fake_identity = FALSE
	var/datum/storyteller_roll/investigation/examine_roll
	var/datum/universal_icon/our_photograph
	var/additional_text = ""

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
		owner = user.dna.fake_name_identity
		dob = CURRENT_STATION_YEAR - user.dna.fake_age
		issued_year = (dob + 18) + (round(((user.dna.fake_age - 18) / 8)) * 8) // This should be renewals roughly every 8 years after issuance at 18.
		expiry_year = (dob + 18) + ((round(((user.dna.fake_age - 18) / 8)) + 1) * 8) // this math is probably wrong but FUCK IT
		owner_gender = user.dna.fake_gender
	else
		owner = user.real_name
		dob = CURRENT_STATION_YEAR - user.age
		issued_year = (dob + 18) + (round(((user.age - 18) / 8)) * 8) // This should be renewals roughly every 8 years after issuance at 18.
		expiry_year = (dob + 18) + ((round(((user.age - 18) / 8)) + 1) * 8) // this math is probably wrong but FUCK IT
		if(user.gender == MALE)
			owner_gender = "M"
		else if(user.gender == FEMALE)
			owner_gender = "F"
		else
			owner_gender = "X" // The X marker I think might not've existed yet as standard practice for ID documents at this point in time, but as players can make non-binary characters, this doesn't hurt anyone to have and we should support it.
	QDEL_NULL(examine_roll)
	examine_roll = new()
	examine_roll.roll_output_type = ROLL_PRIVATE_UNLESS_FAILURE
	examine_roll.reroll_cooldown = 1 SCENES
	our_human = user
	country_of_origin = user.dna.country_of_origin
	if(country_of_origin == "United States")
		country_of_origin = "[user.dna.state_of_origin], United States"

/obj/item/passport/proc/get_owner_id_photo(force = FALSE)
	if((!our_photograph && our_human) || (our_human && force))
		var/mob/living/carbon/human/dummy = new
		dummy.equipOutfit(/datum/outfit/job/vampire/citizen, visuals_only = TRUE)
		our_human.client?.prefs.safe_transfer_prefs_to(dummy)
		dummy.dna.remove_all_mutations()
		dummy.dna.update_dna_identity()
		dummy.underlays += icon('icons/obj/machines/photobooth.dmi', "height_chart")
		var/datum/universal_icon/photograph = get_flat_uni_icon(dummy)
		photograph.scale(128, 128)
		photograph.crop(1,1,128,128)
		our_photograph = photograph
		qdel(dummy)
		return our_photograph.to_icon()
	else if(our_photograph)
		return our_photograph.to_icon()

/obj/item/passport/examine(mob/user)
	. = ..()
	if(owner)
		var/id_examine = span_slightly_larger(separator_hr("You examine [src]...</em>"))
		id_examine += "<div class='img_by_text_container'>"
		id_examine += "[icon2html(get_owner_id_photo(), user, extra_classes = "hugeicon")]"
		id_examine += "<div class='img_text'>"
		id_examine += span_notice(jointext(list(
			"&bull; Name: [owner]",
			"&bull; Birth Year: [dob]",
			"&bull; Issuing Country: [country_of_origin]",
			"&bull; Issued Year: [issued_year]",
			"&bull; Expiry Year: [expiry_year]",
			"&bull; Gender: [owner_gender]",
			additional_text,
		), "<br>"))
		id_examine += "</div>" // container
		id_examine += "</div>" // text

		. += boxed_message(id_examine)
		. += span_slightly_larger(separator_hr("You finish reading [src]...</em>"))
		if(our_human == user)
			return

		if(fake)
			examine_roll.difficulty = min(our_human.st_get_stat(STAT_STREETWISE) * 2, 10)
			examine_roll.successes_needed = round(our_human.st_get_stat(STAT_STREETWISE))
			var/roll_result = examine_roll.st_roll(user, src)
			if(roll_result == ROLL_SUCCESS)
				. += span_boldwarning("It looks like a crude counterfeit; this document is forged!")
				return
		if(our_human && !QDELETED(our_human))
			var/check_name = LAZYACCESS(user.mind.guestbook.known_names, our_human.real_name)
			if(check_name && owner != check_name)
				. += span_boldwarning("You recognize the passport photo as [check_name], but this says [p_their(our_human)] name is [owner]!")
				return
			user.mind.guestbook.add_guest(user, our_human, our_human.real_name, owner, TRUE) // add them to your guestbook under the name on the ID


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
