/obj/item/card/drivers_license
	name = "driver's license"
	desc = "An identification card allowing its holder to own and operate motor vehicles. Doubles as a valid form of identification."
	icon = 'modular_darkpack/modules/government/icons/docs.dmi'
	icon_state = "drivers"
	worn_icon_state = ""
	slot_flags = NONE
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/government/icons/docsonfloor.dmi')
	shows_name = TRUE
	item_type = "license"
	/// Issuing state
	var/issuing_state = "California"
	/// Owner
	var/owner = ""
	var/dob
	var/issued_year
	var/expiry_year
	var/owner_gender
	var/organ_donor
	/// If the ID is a counterfit.
	var/fake = FALSE
	/// If the NAME does not belong to the person.
	var/fake_identity = FALSE
	var/mob/living/carbon/human/our_human
	var/datum/universal_icon/our_photograph
	var/datum/storyteller_roll/investigation/examine_roll
	var/additional_text = ""

/obj/item/card/drivers_license/Initialize(mapload)
	. = ..()
	var/mob/living/carbon/human/user = null
	if(ishuman(loc)) // In pockets
		user = loc
	else if(ishuman(loc?.loc)) // In backpack
		user = loc.loc
	if(user)
		link_human(user)

/obj/item/card/drivers_license/proc/link_human(mob/living/carbon/human/user)
	if(HAS_TRAIT(user, TRAIT_ILLEGAL_IDENTITY))
		fake = TRUE
		fake_identity = TRUE

	if(fake_identity)
		owner = user.dna.fake_name_identity
		dob = CURRENT_STATION_YEAR - user.dna.fake_age
		issued_year = (dob + 18) + (round(((user.dna.fake_age - 18) / 8)) * 8) // This should be renewals roughly every 8 years after issuance at 18.
		expiry_year = (dob + 18) + ((round(((user.dna.fake_age - 18) / 8)) + 1) * 8) // this math is probably wrong but FUCK IT
		owner_gender = user.dna.fake_gender
		organ_donor = user.dna.fake_organ_donor
	else
		owner = user.real_name
		dob = CURRENT_STATION_YEAR - user.age
		issued_year = (dob + 18) + (round(((user.age - 18) / 8)) * 8) // This should be renewals roughly every 8 years after issuance at 18.
		expiry_year = (dob + 18) + ((round(((user.age - 18) / 8)) + 1) * 8) // this math is probably wrong but FUCK IT
		organ_donor = user.dna.organ_donor
		if(user.gender == MALE)
			owner_gender = "M"
		else if(user.gender == FEMALE)
			owner_gender = "F"
		else
			owner_gender = "X" // The X marker I think might not've existed yet as standard practice for ID documents in the US at this point in time, but as players can make non-binary characters, this doesn't hurt anyone to have and we should support it.
	examine_roll = new()
	examine_roll.roll_output_type = ROLL_PRIVATE_UNLESS_FAILURE
	examine_roll.reroll_cooldown = 1 SCENES
	our_human = user
	if(user.dna.country_of_origin == "United States")
		issuing_state = user.dna.state_of_origin

/obj/item/card/drivers_license/proc/get_owner_id_photo(force = FALSE)
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

/obj/item/card/drivers_license/examine(mob/user)
	. = ..()
	examine_roll.difficulty = min(our_human.st_get_stat(STAT_STREETWISE) * 2, 10)
	examine_roll.successes_needed = round(our_human.st_get_stat(STAT_STREETWISE))
	if(owner)
		var/id_examine = span_slightly_larger(separator_hr("You examine [src]...</em>"))
		id_examine += "<div class='img_by_text_container'>"
		id_examine += "[icon2html(get_owner_id_photo(), user, extra_classes = "hugeicon")]"
		id_examine += "<div class='img_text'>"
		var/organ_donor_text = organ_donor ? "YES" : "NO"
		id_examine += span_notice(jointext(list(
			"&bull; Name: [owner]",
			"&bull; Birth Year: [dob]",
			"&bull; Issuing State: [issuing_state]",
			"&bull; Issued Year: [issued_year]",
			"&bull; Expiry Year: [expiry_year]",
			"&bull; Gender: [owner_gender]",
			"&bull; Organ Donor: [organ_donor_text]",
			additional_text,
		), "<br>"))
		id_examine += "</div>" // container
		id_examine += "</div>" // text

		. += boxed_message(id_examine)
		. += span_slightly_larger(separator_hr("You finish reading [src]...</em>"))
		if(our_human == user)
			return

		if(fake)
			examine_roll.difficulty = our_human.st_get_stat(STAT_STREETWISE)
			examine_roll.successes_needed = round(our_human.st_get_stat(STAT_STREETWISE) / 2)
			var/roll_result = examine_roll.st_roll(user, src)
			if(roll_result == ROLL_SUCCESS)
				. += span_boldwarning("It looks like a crude counterfeit; this document is forged!")
				return
		if(our_human && !QDELETED(our_human))
			var/check_name = LAZYACCESS(user.mind.guestbook.known_names, our_human.real_name)
			if(check_name && owner != check_name)
				. += span_boldwarning("You recognize the license photo as [check_name], but this says [p_their(our_human)] name is [owner]!")
				return
			user.mind.guestbook.add_guest(user, our_human, our_human.real_name, owner, TRUE) // add them to your guestbook under the name on the ID
