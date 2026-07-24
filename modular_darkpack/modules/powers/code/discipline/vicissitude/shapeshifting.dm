#define CHANGE_HAIR "Change Hair"
#define CHANGE_BEARD "Change Beard"
#define CHANGE_SEX  "Change Sex"
#define CHANGE_NAME "Change Name"
#define CHANGE_EYES "Change Eyes"
#define CHANGE_RACE "Change Race"
#define CHANGE_HEIGHT "Change Height"
#define CHOICE_OPTIONS list(CHANGE_HAIR, CHANGE_BEARD, CHANGE_SEX, CHANGE_EYES, CHANGE_NAME, CHANGE_RACE, CHANGE_HEIGHT)

/datum/action/cooldown/mob_cooldown/shapeshift
	owner_has_control = FALSE
	/// What choices we get to pick.
	var/list/choices = CHOICE_OPTIONS
	/// The range of this action.
	var/range = 1

/datum/action/cooldown/mob_cooldown/shapeshift/New(Target, original)
	. = ..()
	update_choices()

/datum/action/cooldown/mob_cooldown/shapeshift/proc/update_choices()
	for(var/i in choices)
		choices[i] = icon('modular_darkpack/modules/powers/icons/shapeshifting_radial.dmi', i)

/datum/action/cooldown/mob_cooldown/shapeshift/Activate(atom/target)
	. = ..()
	display_radial_menu(target)
	return TRUE

/datum/action/cooldown/mob_cooldown/shapeshift/proc/display_radial_menu(mob/target)
	var/chosen_option = show_radial_menu(owner, target, choices, target, radius = 36, tooltips = TRUE)
	if(!chosen_option)
		return TRUE

	if(((target.pulledby == owner) && (owner.grab_state >= GRAB_AGGRESSIVE)) || (target == owner))
		switch(chosen_option)
			if(CHANGE_HAIR)
				change_hair(target)
			if(CHANGE_BEARD)
				change_beard(target)
			if(CHANGE_SEX)
				change_sex(target)
			if(CHANGE_NAME)
				change_name(target)
			if(CHANGE_EYES)
				change_eyes(target)
			if(CHANGE_RACE)
				change_race(target)
			if(CHANGE_HEIGHT)
				change_height(target)
	else
		to_chat(owner, span_danger("You need to have a firm grip on [target]!"))
		return TRUE

	if(!IN_GIVEN_RANGE(owner, target, range))
		return FALSE
	return display_radial_menu(target)

/datum/action/cooldown/mob_cooldown/shapeshift/proc/change_sex(mob/living/carbon/human/target)
	var/chosen_sex = tgui_input_list(owner, "Choose a gender.", "Confirmation", list("Male", "Female", "Plural", "Neuter"))
	if(!chosen_sex)
		return FALSE
	if(!IN_GIVEN_RANGE(owner, target, range))
		return FALSE
	if(!do_after(owner, delay = 1 TURNS, target = target))
		return FALSE
	switch(chosen_sex)
		if("Male")
			target.gender = MALE
		if("Female")
			target.gender = FEMALE
		if("Plural")
			target.gender = PLURAL
		if("Neuter")
			target.gender = NEUTER
	SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)
	playsound(target, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)
	to_chat(owner, span_notice("You finish altering the gender of [target]."))

	var/chosen_physique = tgui_input_list(owner, "Alter physique as well?", "Confirmation", list("Masculine", "Feminine"))
	if(!chosen_physique)
		return FALSE
	if(!IN_GIVEN_RANGE(owner, target, range))
		return FALSE
	if(!do_after(owner, delay = 1 TURNS, target = target))
		return FALSE
	target.physique = (chosen_physique == "Masculine") ? MALE : FEMALE
	target.dna.update_ui_block(/datum/dna_block/identity/gender)
	target.update_body(is_creating = TRUE) // or else physique won't change properly
	target.update_appearance(UPDATE_OVERLAYS) //(hulk male/female)
	target.update_clothing(ITEM_SLOT_ICLOTHING) // update gender shaped clothing
	SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)
	playsound(target, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)
	to_chat(owner, span_notice("You finish altering the physique of [target]."))
	return TRUE

/datum/action/cooldown/mob_cooldown/shapeshift/proc/change_eyes(mob/living/carbon/human/target)
	var/new_eye_color = input(owner, "Choose a eye color", "Eye Color", target.eye_color_left) as color|null
	if(!new_eye_color)
		return TRUE
	if(!IN_GIVEN_RANGE(owner, target, range))
		return FALSE
	if(!do_after(owner, delay = 1 TURNS, target = target))
		return FALSE
	target.set_eye_color(sanitize_hexcolor(new_eye_color))
	target.dna.update_ui_block(/datum/dna_block/identity/eye_colors)
	target.update_body()
	SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)
	playsound(target, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)
	to_chat(owner, span_notice("You finish altering the eye color of [target]."))
	return TRUE

/datum/action/cooldown/mob_cooldown/shapeshift/proc/change_beard(mob/living/carbon/human/target)
	var/new_style = tgui_input_list(owner, "Select a facial hairstyle", "Grooming", SSaccessories.facial_hairstyles_list)
	if(!new_style)
		return FALSE
	if(!IN_GIVEN_RANGE(owner, target, range))
		return FALSE
	if(!do_after(owner, delay = 1 TURNS, target = target))
		return FALSE
	target.set_facial_hairstyle(new_style, update = TRUE)
	SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)
	playsound(target, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)
	to_chat(owner, span_notice("You finish altering the facial style of [target]."))

	var/new_face_color = input(owner, "Choose a facial hair color", "Hair Color", target.facial_hair_color) as color|null
	if(!new_face_color)
		return FALSE
	if(!IN_GIVEN_RANGE(owner, target, range))
		return FALSE
	if(!do_after(owner, delay = 1 TURNS, target = target))
		return FALSE
	target.set_facial_haircolor(sanitize_hexcolor(new_face_color))
	target.dna.update_ui_block(/datum/dna_block/identity/facial_color)
	SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)
	playsound(target, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)
	to_chat(owner, span_notice("You finish altering the facial hair color of [target]."))
	return TRUE

/datum/action/cooldown/mob_cooldown/shapeshift/proc/change_hair(mob/living/carbon/human/target)
	var/new_style = tgui_input_list(owner, "Select a hairstyle", "Grooming", SSaccessories.hairstyles_list)
	if(!new_style)
		return FALSE
	if(!IN_GIVEN_RANGE(owner, target, range))
		return FALSE
	if(!do_after(owner, delay = 1 TURNS, target = target))
		return FALSE
	target.set_hairstyle(new_style, update = TRUE)
	SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)
	playsound(target, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)
	to_chat(owner, span_notice("You finish altering the hair style of [target]."))

	var/new_hair_color = input(owner, "Choose a hair color", "Hair Color", target.hair_color) as color|null
	if(!new_hair_color)
		return FALSE
	if(!IN_GIVEN_RANGE(owner, target, range))
		return FALSE
	if(!do_after(owner, delay = 1 TURNS, target = target))
		return FALSE
	target.set_haircolor(sanitize_hexcolor(new_hair_color))
	target.dna.update_ui_block(/datum/dna_block/identity/hair_color)
	SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)
	playsound(target, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)
	to_chat(owner, span_notice("You finish altering the hair color of [target]."))
	return TRUE

/datum/action/cooldown/mob_cooldown/shapeshift/proc/change_name(mob/living/carbon/human/target)
	var/newname = sanitize_name(tgui_input_text(owner, "Who are we again?", "Name change", target.real_name, MAX_NAME_LEN))
	if(!newname || newname == target.real_name)
		return FALSE
	if(!IN_GIVEN_RANGE(owner, target, range))
		return FALSE
	if(!do_after(owner, delay = 1 TURNS, target = target))
		return FALSE
	target.real_name = newname
	if(target.dna)
		target.dna.real_name = newname
	if(target.mind)
		target.mind.name = newname
	SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)
	playsound(target, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)
	to_chat(owner, span_notice("You finish altering the name of [target]."))
	return TRUE

/datum/action/cooldown/mob_cooldown/shapeshift/proc/change_race(mob/living/carbon/human/target)
	var/list/skin_tones = list()
	for(var/skin_tone in GLOB.skin_tone_names)
		var/skin_tone_name = GLOB.skin_tone_names[skin_tone]
		skin_tones[skin_tone_name] = skin_tone

	var/new_s_tone = tgui_input_list(owner, "Choose a skin tone", "Race change", skin_tones)
	new_s_tone = skin_tones[new_s_tone]
	if(!new_s_tone)
		return FALSE
	if(!IN_GIVEN_RANGE(owner, target, range))
		return FALSE
	if(!do_after(owner, delay = 1 TURNS, target = target))
		return FALSE
	target.skin_tone = new_s_tone
	target.dna.update_ui_block(/datum/dna_block/identity/skin_tone)
	target.update_body(is_creating = TRUE)
	target.update_appearance(UPDATE_OVERLAYS)
	SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)
	playsound(target, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)
	to_chat(owner, span_notice("You finish altering the race of [target]."))
	return TRUE

/datum/action/cooldown/mob_cooldown/shapeshift/proc/change_height(mob/living/carbon/human/target)
	var/list/heights = list(
		"Taller" = HUMAN_HEIGHT_TALLER,
		"Tall" = HUMAN_HEIGHT_TALL,
		"Average" = HUMAN_HEIGHT_MEDIUM,
		"Short" = HUMAN_HEIGHT_SHORT,
		"Shorter" = HUMAN_HEIGHT_SHORTEST,
		)

	var/new_height = tgui_input_list(owner, "Choose a height", "Height change", heights)
	new_height = heights[new_height]
	if(!new_height)
		return FALSE
	if(!IN_GIVEN_RANGE(owner, target, range))
		return FALSE
	if(!do_after(owner, delay = 1 TURNS, target = target))
		return FALSE
	target.set_mob_height(new_height)
	SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)
	playsound(target, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)
	to_chat(owner, span_notice("You finish altering the height of [target]."))
	return TRUE

#undef CHANGE_HAIR
#undef CHANGE_BEARD
#undef CHANGE_SEX
#undef CHANGE_EYES
#undef CHANGE_NAME
#undef CHANGE_RACE
#undef CHANGE_HEIGHT
#undef CHOICE_OPTIONS
