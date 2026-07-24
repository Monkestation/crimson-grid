/datum/surgery_operation/limb/sex_change
	name = "sex change surgery" //  someone come back and woke-ify this
	desc = "Change the patient's sex."
	implements = list(
		TOOL_HEMOSTAT = 1.15,
		TOOL_SCREWDRIVER = 2.85,
		/obj/item/pen = 6.67,
	)
	preop_sound = 'sound/items/handling/surgery/scalpel1.ogg'
	success_sound = 'sound/items/handling/surgery/scalpel2.ogg'
	operation_flags = OPERATION_LOCKED | OPERATION_NOTABLE | OPERATION_MORBID
	required_bodytype = ~BODYTYPE_ROBOTIC
	time = 20 SECONDS
	all_surgery_states_required = SURGERY_SKIN_OPEN|SURGERY_ORGANS_CUT|SURGERY_VESSELS_CLAMPED|SURGERY_BONE_SAWED

/datum/surgery_operation/limb/sex_change/get_default_radial_image()
	return image(/obj/item/scalpel)

/datum/surgery_operation/limb/sex_change/state_check(obj/item/bodypart/chest/limb)
	return limb.body_zone == BODY_ZONE_CHEST

/datum/surgery_operation/limb/sex_change/on_preop(atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args)
	var/mob/living/patient = get_patient(operating_on)
	display_results(
		surgeon,
		patient,
		span_notice("You begin to reshape [patient]..."),
		span_notice("[surgeon] begins to manipulate [patient]'s flesh in truly horrific ways!"),
		span_notice("[surgeon] begins to manipulate [patient]'s flesh in truly horrific ways!"),
	)
	display_pain(patient, "You feel like your flesh is moving!")

/datum/surgery_operation/limb/sex_change/on_success(atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args)
	var/mob/living/carbon/human/patient = get_patient(operating_on)

	var/chosen_sex = tgui_input_list(surgeon, "Choose a gender.", "Confirmation", list("Male", "Female", "Plural", "Neuter"))
	if(!chosen_sex)
		return FALSE
	if(!IN_GIVEN_RANGE(surgeon, patient, 1))
		return FALSE
	switch(chosen_sex)
		if("Male")
			patient.gender = MALE
		if("Female")
			patient.gender = FEMALE
		if("Plural")
			patient.gender = PLURAL
		if("Neuter")
			patient.gender = NEUTER
	to_chat(surgeon, span_notice("You finish altering the gender of [patient]."))
	SEND_SIGNAL(surgeon, COMSIG_MASQUERADE_VIOLATION)
	playsound(patient, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)

	var/chosen_physique = tgui_input_list(surgeon, "Alter physique as well?", "Confirmation", list("Masculine", "Feminine"))
	if(!chosen_physique)
		return FALSE
	if(!IN_GIVEN_RANGE(surgeon, patient, 1))
		return FALSE
	patient.physique = (chosen_physique == "Masculine") ? MALE : FEMALE
	patient.dna.update_ui_block(/datum/dna_block/identity/gender)
	patient.update_body(is_creating = TRUE) // or else physique won't change properly
	patient.update_appearance(UPDATE_OVERLAYS)
	patient.update_clothing(ITEM_SLOT_ICLOTHING) // update gender shaped clothing
	SEND_SIGNAL(surgeon, COMSIG_MASQUERADE_VIOLATION)
	playsound(patient, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)
	to_chat(surgeon, span_notice("You finish altering the physique of [patient]."))

	display_results(
		surgeon,
		patient,
		span_notice("You finish changing [patient]'s sex!"),
		span_notice("[surgeon] changes [patient] into something new."),
		span_notice("[surgeon] finishes the operation on [patient]."))
	display_pain(patient, "The pain fades, you feel refreshed!")

/datum/surgery_operation/limb/sex_change/on_failure(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	var/mob/living/carbon/human/patient = get_patient(limb.owner)
	display_results(
		surgeon,
		patient,
		span_warning("Your screw up, leaving [patient]  bruised!"),
		span_warning("[surgeon] screws up, bruising [patient]!"),
		span_notice("[surgeon] finishes the operation on [patient]."),
	)
	display_pain(patient, "Your chest feels torn!")
	limb.receive_damage(rand(4, 8), wound_bonus = 10, sharpness = SHARP_EDGED, damage_source = tool)
