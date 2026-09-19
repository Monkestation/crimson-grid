/obj/item/identification
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_ID

	// Owner information
	var/owner = ""
	var/dob
	var/issued_year
	var/expiry_year
	var/owner_gender

	/// If the ID is a counterfeit
	var/fake = FALSE

	var/mob/living/carbon/human/our_human
	var/datum/universal_icon/our_photograph
	var/datum/storyteller_roll/investigation/examine_roll

/obj/item/identification/attack_self(mob/user, modifiers)
	. = ..()
	user.examinate(src)

/obj/item/identification/proc/link_human(mob/living/carbon/human/user)
	if(HAS_TRAIT(user, TRAIT_ILLEGAL_IDENTITY))
		fake = TRUE

	if(fake)
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
			owner_gender = "X" // The X marker I think might not've existed yet as standard practice for ID documents in the US at this point in time, but as players can make non-binary characters, this doesn't hurt anyone to have and we should support it.

	QDEL_NULL(examine_roll)
	examine_roll = new()
	examine_roll.roll_output_type = ROLL_PRIVATE_UNLESS_FAILURE
	examine_roll.reroll_cooldown = 1 SCENES
	examine_roll.difficulty = min(user.st_get_stat(STAT_STREETWISE) * 2, 10)
	examine_roll.successes_needed = round(user.st_get_stat(STAT_STREETWISE))

	our_human = user

/obj/item/identification/proc/get_owner_id_photo(force = FALSE)
	if((!our_photograph && our_human) || (our_human && force))
		var/mob/living/carbon/human/dummy = new
		dummy.equipOutfit(/datum/outfit/job/vampire/citizen, visuals_only = TRUE)
		our_human.client?.prefs.safe_transfer_prefs_to(dummy)
		dummy.set_clan(null)
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
