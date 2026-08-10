/datum/action/cooldown/mob_cooldown/give_vitae
	name = "Give Vitae"
	desc = "Give your vitae to someone, make the Blood Bond."
	button_icon_state = "vitae"
	check_flags = AB_CHECK_HANDS_BLOCKED | AB_CHECK_CONSCIOUS | AB_CHECK_INCAPACITATED
	button_icon = 'modular_darkpack/modules/vampire_the_masquerade/icons/vitae.dmi'
	button_icon_state = "vitae"
	background_icon = 'modular_darkpack/master_files/icons/mob/actions/backgrounds.dmi'
	background_icon_state = "bg_discipline"
	ranged_mousepointer = 'modular_darkpack/modules/deprecated/icons/effects/mouse_pointers/discipline.dmi'
	cooldown_time = 10 SECONDS
	vampiric = TRUE

	// How long do we take giving blood?
	var/charge_duration = 10 SECONDS

/datum/action/cooldown/mob_cooldown/give_vitae/Activate(mob/living/carbon/human/target)
	if(!IN_GIVEN_RANGE(owner, target, 1))
		owner.balloon_alert(owner, "too far!")
		return FALSE
	if(!target.reagents)
		return FALSE
	if(target == owner)
		return FALSE

	var/choice = tgui_alert(owner, "", "Give Vitae", list("Feed Blood", "Teach Discipline", "Cancel"))
	if(QDELETED(owner) || QDELETED(target))
		return FALSE
	if(!choice || choice == "Cancel")
		return FALSE
	if(!IN_GIVEN_RANGE(owner, target, 1))
		owner.balloon_alert(owner, "too far!")
		return FALSE

	if(choice == "Teach Discipline")
		return teach_discipline(target)

	StartCooldown()
	unset_click_ability(owner, refund_cooldown = FALSE)
	owner.visible_message(
		span_danger("[owner] starts pouring blood into \the [target][ismob(target) ? "'s mouth" : null]!"),
		span_info("You start pouring blood into \the [target][ismob(target) ? "'s mouth" : null]."))
	if(!do_after(owner, delay = charge_duration, target = target, icon = 'modular_darkpack/modules/vampire_the_masquerade/icons/vitae.dmi', iconstate = "vitae"))
		return FALSE

	var/mob/living/carbon/vamp = owner
	if(vamp.bloodpool <= 1)
		to_chat(vamp, span_danger("You don't have enough vitae!"))
		return FALSE

	owner.visible_message(
		span_danger("[owner] finishes pouring blood into \the [target][ismob(target) ? "'s mouth" : null]!"),
		span_info("You finish pouring blood into \the [target][ismob(target) ? "'s mouth" : null]."))
	owner.log_message("poured their vitae into [key_name(target)].", LOG_GAME)
	message_admins("[ADMIN_LOOKUPFLW(vamp)] poured their vitae into [ADMIN_LOOKUPFLW(target)].")
	vamp.adjust_blood_pool(-1)
	target.reagents.add_reagent(/datum/reagent/blood/vitae, 100, list("donor" = WEAKREF(owner)))
	target.reagents.expose(target, INGEST, 1, FALSE)
	return TRUE

/datum/action/cooldown/mob_cooldown/give_vitae/proc/teach_discipline(mob/living/carbon/human/student)
	var/datum/splat/vampire/sire = get_splat_with_discipline(owner)
	if(!sire)
		return FALSE

	var/list/discipline_entries = list()
	var/list/disc_type = list()
	var/list/seen_types = list()
	for(var/datum/action/discipline/action as anything in sire.powers)
		var/datum/discipline/disc = action.discipline
		if(!disc?.selectable)
			continue
		if(ispath(disc.type, /datum/discipline/path))
			continue
		if(disc.type in seen_types)
			continue
		seen_types += disc.type // prevent duplicates
		discipline_entries += "[disc.name]"
		disc_type["[disc.name]"] = disc.type

	if(!length(discipline_entries))
		return FALSE

	if(!student || student.stat != CONSCIOUS)
		owner.balloon_alert(owner,"they must be conscious!")
		return FALSE

	var/chosen = tgui_input_list(owner, "Select a discipline to teach to [student]", "Teach Discipline", discipline_entries)
	if(!chosen || QDELETED(owner) || QDELETED(student))
		return FALSE

	if(!IN_GIVEN_RANGE(owner, student, 1)) // they moved away
		owner.balloon_alert(owner,"too far!")
		return FALSE

	StartCooldown()
	unset_click_ability(owner, refund_cooldown = FALSE)
	owner.visible_message(
		span_danger("[owner] starts pouring blood into [student]'s mouth!"),
		span_info("You start pouring blood into [student]'s mouth."))
	if(!do_after(owner, delay = 1 MINUTES, target = student, icon = 'modular_darkpack/modules/vampire_the_masquerade/icons/vitae.dmi', iconstate = "vitae"))
		return FALSE

	if(student.stat != CONSCIOUS)
		return FALSE

	var/mob/living/carbon/vamp = owner
	if(vamp.bloodpool <= 1)
		to_chat(vamp, span_danger("You don't have enough vitae!"))
		return FALSE

	vamp.adjust_blood_pool(-1)
	student.reagents.add_reagent(/datum/reagent/blood/vitae, 100, list("donor" = WEAKREF(owner)))
	student.reagents.expose(student, INGEST, 1, FALSE)

	var/discipline_type = disc_type[chosen]
	if(discipline_type)
		var/datum/splat/vampire/student_splat = student ? get_splat_with_discipline(student) : null
		if(student_splat && !student_splat.get_power(discipline_type))
			var/list/validation = validate_mob_sheet(student, discipline_type)
			if(validation && !validation["valid"])
				owner.balloon_alert(owner, "unable to teach them anything!")
				var/violations = ""
				for(var/violation in validation["violations"])
					violations += violation
				to_chat(owner, span_warning("[student] is unable to learn [chosen]."))
				message_admins("[ADMIN_LOOKUPFLW(owner)] tried to teach [chosen] to [ADMIN_LOOKUPFLW(student)], but doing so would've made [key_name(student)]'s sheet invalid due to the following: [violations]")
				return FALSE
			student.give_st_power(discipline_type, 1)
			if(student.client?.prefs)
				student.client.prefs.discipline_levels["[discipline_type]"] = 1
				student.client.prefs.save_character()

	owner.log_message("taught [chosen] to [key_name(student)].", LOG_STATS)
	message_admins("[ADMIN_LOOKUPFLW(owner)] taught [chosen] to [ADMIN_LOOKUPFLW(student)].")
	return TRUE
