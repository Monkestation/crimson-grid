/datum/surgery_operation/limb/modify_skin
	name = "skin pigmentation surgery"
	desc = "Change the patient's skin color."
	implements = list(
		TOOL_HEMOSTAT = 1.15,
		TOOL_SCREWDRIVER = 2.85,
		/obj/item/pen = 6.67,
	)
	preop_sound = 'sound/items/handling/surgery/scalpel1.ogg'
	success_sound = 'sound/items/handling/surgery/scalpel2.ogg'
	operation_flags = OPERATION_LOCKED | OPERATION_NOTABLE | OPERATION_MORBID
	time = 20 SECONDS
	all_surgery_states_required = SURGERY_SKIN_OPEN|SURGERY_VESSELS_CLAMPED

/datum/surgery_operation/limb/modify_skin/get_default_radial_image()
	return image(/obj/item/scalpel)

/datum/surgery_operation/limb/modify_skin/state_check(obj/item/bodypart/chest/limb)
	return limb.body_zone == BODY_ZONE_CHEST

/datum/surgery_operation/limb/modify_skin/on_preop(atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args)
	var/mob/living/patient = get_patient(operating_on)
	display_results(
		surgeon,
		patient,
		span_notice("You begin to alter [patient]'s skin color..."),
		span_notice("[surgeon] begins to alter [patient]'s skin color."),
		span_notice("[surgeon] begins to make an incision in [patient]'s body."),
	)
	display_pain(patient, "You feel a slicing pain across your body!")

/datum/surgery_operation/limb/modify_skin/on_success(atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args)
	var/mob/living/carbon/human/patient = get_patient(operating_on)

	var/list/skin_tones = list()
	for(var/skin_tone in GLOB.skin_tone_names)
		var/skin_tone_name = GLOB.skin_tone_names[skin_tone]
		skin_tones[skin_tone_name] = skin_tone

	var/new_s_tone = tgui_input_list(surgeon, "Choose a skin tone", "Race change", skin_tones)
	new_s_tone = skin_tones[new_s_tone]
	if(!new_s_tone)
		return FALSE
	if(!IN_GIVEN_RANGE(surgeon, patient, 1))
		return FALSE
	patient.skin_tone = new_s_tone
	patient.dna.update_ui_block(/datum/dna_block/identity/skin_tone)
	patient.update_body(is_creating = TRUE)
	patient.update_appearance(UPDATE_OVERLAYS)
	SEND_SIGNAL(surgeon, COMSIG_MASQUERADE_VIOLATION)
	playsound(patient, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)

	display_results(
		surgeon,
		patient,
		span_notice("You alter [patient]'s skin color completely."),
		span_notice("[surgeon] alters [patient]'s skin color."),
		span_notice("[surgeon] finishes the operation on [patient]'s skin."),
	)
	display_pain(patient, "The pain fades, the world seems different!")

/datum/surgery_operation/limb/modify_skin/on_failure(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	var/mob/living/carbon/human/patient = get_patient(limb.owner)
	display_results(
		surgeon,
		patient,
		span_warning("Your screw up, leaving [patient]'s skin bruised!"),
		span_warning("[surgeon] screws up, bruising [patient]'s skin!"),
		span_notice("[surgeon] finishes the operation on [patient]'s skin."),
	)
	display_pain(patient, "Your body feels torn!")
	limb.receive_damage(rand(4, 8), wound_bonus = 10, sharpness = SHARP_EDGED, damage_source = tool)
