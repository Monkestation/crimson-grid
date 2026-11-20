/// Ensure every quirk has a unique icon
/datum/unit_test/quirk_icons

/datum/unit_test/quirk_icons/Run()
	var/list/used_icons = list()

	for (var/datum/quirk/quirk_type as anything in valid_subtypesof(/datum/quirk))
		var/icon = initial(quirk_type.icon)

		if (isnull(icon))
			TEST_FAIL("[quirk_type] has no icon!")
			continue
		/* DARKPACK EDIT REMOVAL - MERITS_FLAWS
		if (icon in used_icons)
			TEST_FAIL("[icon] used in both [quirk_type] and [used_icons[icon]]!")
			continue
		*/

		used_icons[icon] = quirk_type

// Make sure all quirks start with a description in medical records
/datum/unit_test/quirk_initial_medical_records

/datum/unit_test/quirk_initial_medical_records/Run()
	/* DARKPACK EDIT REMOVAL - MERITS_FLAWS - we don't need this and darkpack quirk splat/clan exclusion makes it impossible to add to a random test character with no splats
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human/consistent)

	for(var/datum/quirk/quirk_type as anything in valid_subtypesof(/datum/quirk))
		if(quirk_type::medical_record_text)
			continue
		if(quirk_type::quirk_flags & QUIRK_NO_RECORD)
			continue

		//Add quirk to a patient - so we can pass quirks that add a medical record after being assigned someone
		patient.add_quirk(quirk_type)

		var/datum/quirk/quirk = patient.get_quirk(quirk_type)
		if(quirk.medical_record_text)
			continue

		TEST_FAIL("[quirk_type] has no medical record description!")

		patient.remove_quirk(quirk_type)
	*/

/// Ensures the blood deficiency quirk updates its mail goodies correctly
/datum/unit_test/blood_deficiency_mail
	var/list/species_to_test = list(
		/datum/species/human = /obj/item/reagent_containers/blood/o_minus,
		/datum/species/lizard = /obj/item/reagent_containers/blood/lizard,
		/datum/species/ethereal = /obj/item/reagent_containers/blood/ethereal,
		/datum/species/skeleton = null, // Anyone with noblood should not get a blood bag
		/datum/species/jelly = /obj/item/reagent_containers/blood/toxin,
	)

/datum/unit_test/blood_deficiency_mail/Run()
	/* DARKPACK EDIT REMOVAL - MERITS_FLAWS - we are not using /tg/ quirks
	var/mob/living/carbon/human/dummy = allocate(/mob/living/carbon/human/consistent)
	dummy.add_quirk(/datum/quirk/blooddeficiency)
	var/datum/quirk/blooddeficiency/quirk = dummy.get_quirk(/datum/quirk/blooddeficiency)

	TEST_ASSERT((species_to_test[dummy.dna.species.type] in quirk.mail_goodies), "Blood deficiency quirk did not get the right blood bag in its mail goodies for [dummy.dna.species.type]! \
		It should be getting species_to_test[dummy.dna.species.type]." \
	)

	for(var/species_type in species_to_test)
		var/last_species = dummy.dna.species.type
		if(species_type == /datum/species/human) // we already tested this above, and setting species again will cause it to randomize
			continue
		dummy.set_species(species_type)
		// Test that the new species has the correct blood bag
		if(!isnull(species_to_test[species_type]))
			TEST_ASSERT((species_to_test[species_type] in quirk.mail_goodies), \
				"Blood deficiency quirk did not update correctly! ([species_type] did not get its blood bag added)")
			TEST_ASSERT_EQUAL(length(quirk.mail_goodies), 1, \
				"Blood deficiency quirk got multiple blood bags for [species_type]!")
		else
			TEST_ASSERT_EQUAL(length(quirk.mail_goodies), 0, \
				"Blood deficiency quirk did not have an empty mail goody list for a noblood species!")
		// Test that we don't have the old species' blood bag
		if(!isnull(species_to_test[last_species]))
			TEST_ASSERT(!(species_to_test[last_species] in quirk.mail_goodies), \
				"Blood deficiency quirk did not update correctly for [species_type]! ([last_species] did not get its blood bag removed)")
	*/

/// Ensures that all quirks correctly initialized when added
/datum/unit_test/quirk_validity

/datum/unit_test/quirk_validity/Run()
	// Required for language quirks to function properly
	// Assigning this manually as config is empty
	GLOB.uncommon_roundstart_languages = list(/datum/language/uncommon)

	for (var/datum/quirk/quirk_type as anything in valid_subtypesof(/datum/quirk))
		// DARKPACK EDIT ADD START - MERITS_FLAWS
		if(!quirk_type::darkpack_allowed)
			continue
		var/list/forbidden_splats_test
		var/list/allowed_splats_test
		var/list/excluded_clans_test
		var/list/included_clans_test
		if(ispath(quirk_type, /datum/quirk/darkpack))
			var/datum/quirk/darkpack/darkpack_quirk = quirk_type
			forbidden_splats_test = darkpack_quirk.forbidden_splats
			allowed_splats_test = darkpack_quirk.allowed_splats
			excluded_clans_test = darkpack_quirk.excluded_clans
			included_clans_test = darkpack_quirk.included_clans
		// DARKPACK EDIT ADD END
		var/mob/dead/new_player/abstract_player = allocate(/mob/dead/new_player)
		var/datum/client_interface/roundstart_mock_client = new()
		abstract_player.mock_client = roundstart_mock_client
		roundstart_mock_client.prefs = new(roundstart_mock_client)
		var/mob/living/carbon/human/new_character = allocate(/mob/living/carbon/human/consistent)
		new_character.mind_initialize()
		abstract_player.new_character = new_character

		// DARKPACK EDIT ADD START - MERITS_FLAWS
		// if allowed splats, add the allowed splat, then test, failure if its not added
		if(allowed_splats_test)
			for(var/datum/splat/allowed_splat in allowed_splats_test)
				new_character.add_splat(allowed_splat)
				if (!new_character.add_quirk(quirk_type, roundstart_mock_client))
					TEST_FAIL("Failed to initialize quirk [quirk_type] on a roundstart character with allowed splat [allowed_splat]!")
				new_character.clear_splats() //clear after for the next test

		// if forbidden splats, add the disallowed splat, then test, failure if its added
		if(forbidden_splats_test)
			for(var/datum/splat/forbidden_splat in forbidden_splats_test)
				new_character.add_splat(forbidden_splat)
				if (new_character.add_quirk(quirk_type, roundstart_mock_client))
					TEST_FAIL("Successfully initialized quirk [quirk_type] on a roundstart character that had a forbidden splat [forbidden_splat]!")
				new_character.clear_splats()

		// if all are null, then its an allowed quirk for all, failure if cannot add
		if(!forbidden_splats_test && !allowed_splats_test && !excluded_clans_test && !included_clans_test)
			if (!new_character.add_quirk(quirk_type, roundstart_mock_client))
				TEST_FAIL("Failed to initialize quirk [quirk_type] on a roundstart character!")
		// DARKPACK EDIT ADD END - MERITS_FLAWS

		var/mob/living/carbon/human/latejoin_character = allocate(/mob/living/carbon/human/consistent)
		var/datum/client_interface/latejoin_mock_client = new()
		latejoin_mock_client.prefs = new(latejoin_mock_client)
		latejoin_character.mock_client = latejoin_mock_client
		latejoin_character.mind_initialize()

		// DARKPACK EDIT ADD - MERITS_FLAWS
		// if allowed splats, add the allowed splat, then test, failure if its not added
		if(allowed_splats_test)
			for(var/datum/splat/allowed_splat in allowed_splats_test)
				latejoin_character.add_splat(allowed_splat)
				if (!latejoin_character.add_quirk(quirk_type, latejoin_mock_client))
					TEST_FAIL("Failed to initialize quirk [quirk_type] on a latejoin character with allowed splat [allowed_splat]!")
				latejoin_character.clear_splats()

		// if forbidden splats, add the allowed splat, then test, failure if its added
		if(forbidden_splats_test)
			for(var/datum/splat/forbidden_splat in forbidden_splats_test)
				latejoin_character.add_splat(forbidden_splat)
				if (latejoin_character.add_quirk(quirk_type, latejoin_mock_client))
					TEST_FAIL("Successfully initialized quirk [quirk_type] on a latejoin character that had a forbidden splat [forbidden_splat]!")
				latejoin_character.clear_splats()

		// if all are null, then its an allowed quirk for all, failure if cannot add
		if(!forbidden_splats_test && !allowed_splats_test && !excluded_clans_test && !included_clans_test)
			if (!latejoin_character.add_quirk(quirk_type, latejoin_mock_client))
				TEST_FAIL("Failed to initialize quirk [quirk_type] on a latejoin character!")
		// DARKPACK EDIT ADD END - MERITS_FLAWS

	// Clean up after ourselves
	GLOB.uncommon_roundstart_languages.Cut()
