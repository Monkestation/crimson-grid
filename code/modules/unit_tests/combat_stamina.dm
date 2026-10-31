/// Tests 100 stamina damage = stamcrit
/datum/unit_test/stamcrit
	priority = TEST_LONGER

/datum/unit_test/stamcrit/Run()
	var/mob/living/carbon/human/consistent/tider = allocate(__IMPLIED_TYPE__)
	tider.stamina_regen_time = 0.2 SECONDS
	// CRIMSON GRID ADD: DARK THAUMATURGY 2
	var/stamloss_to_reach_crit_threshold = tider.max_stamina - tider.crit_threshold
	// CRIMSON GRID ADD END: DARK THAUMATURGY 2
	tider.adjust_stamina_loss(stamloss_to_reach_crit_threshold - 1)
	TEST_ASSERT(!tider.has_status_effect(/datum/status_effect/incapacitating/stamcrit), "Stamcrit should not be applied at [stamloss_to_reach_crit_threshold - 1] stamina damage")
	tider.adjust_stamina_loss(1)
	TEST_ASSERT(tider.has_status_effect(/datum/status_effect/incapacitating/stamcrit), "Stamcrit should be applied at [stamloss_to_reach_crit_threshold] stamina damage")
	sleep(tider.stamina_regen_time * 2)
	TEST_ASSERT(!tider.has_status_effect(/datum/status_effect/incapacitating/stamcrit), "Stamcrit should be removed after regen time")

/// Tests stamina regen after the set time
/datum/unit_test/stam_regen
	priority = TEST_LONGER

/datum/unit_test/stam_regen/Run()
	var/mob/living/carbon/human/consistent/tider = allocate(__IMPLIED_TYPE__)
	tider.stamina_regen_time = 0.2 SECONDS
	tider.adjust_stamina_loss(50)
	sleep(tider.stamina_regen_time * 2)
	TEST_ASSERT_EQUAL(tider.get_stamina_loss(), 0, "Stamina should be fully regenerated after regen time")
