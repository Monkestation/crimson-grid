// OPTIONS
#define BODYCRAFT_HAIR "Hair"
#define BODYCRAFT_BEARD "Beard"
#define BODYCRAFT_HAIR_COLOR "Hair Color"
#define BODYCRAFT_BEARD_COLOR "Beard Color"
#define BODYCRAFT_SEX  "Sex"
#define BODYCRAFT_NAME "Name"
#define BODYCRAFT_EYES "Eyes"
#define BODYCRAFT_SKIN "Skin"
#define BODYCRAFT_HEIGHT "Height"
// CATEGORIES
#define BODYCRAFT_BACK "Back"
#define BODYCRAFT_HAIR_LIST "Hair Options"
// LISTS
#define BODYCRAFT_OPTIONS list(BODYCRAFT_HAIR_LIST, BODYCRAFT_SEX, BODYCRAFT_EYES, BODYCRAFT_NAME, BODYCRAFT_SKIN, BODYCRAFT_HEIGHT)
#define BODYCRAFT_OPTIONS_HAIR list(BODYCRAFT_BACK, BODYCRAFT_BEARD, BODYCRAFT_BEARD_COLOR, BODYCRAFT_HAIR_COLOR, BODYCRAFT_HAIR, )

/datum/action/cooldown/mob_cooldown/bodycraft
	owner_has_control = FALSE
	// What choices we get to pick.
	var/list/choices_initial = BODYCRAFT_OPTIONS
	var/list/choices_hair = BODYCRAFT_OPTIONS_HAIR
	/// The range of this action.
	var/range = 1
	// User's bloodpool
	var/bloodpool
	// Fail/Succeed
	var/rollstate
	// Vitae Cost
	var/vitae_cost = 0
	// SET VITAE COSTS HERE
	var/static/list/bodycrafting_costs = list()

/datum/action/cooldown/mob_cooldown/bodycraft/proc/spend_resources(mob/living/owner)
	bloodpool = owner.bloodpool
	if(bloodpool < vitae_cost || bloodpool == 0)
		rollstate = "fail"
		to_chat(owner, span_warning("You do not have enough blood to alter the body in such a way!"))
	else
		(rollstate = "success")
		owner.adjust_blood_pool(-vitae_cost)

/datum/action/cooldown/mob_cooldown/bodycraft/New(Target, original)
	. = ..()
	update_choices()

/datum/action/cooldown/mob_cooldown/bodycraft/proc/update_choices()
	for(var/i in choices_initial)
		choices_initial["Hair Options"] = icon('modular_darkpack/modules/powers/icons/bodycrafting_radial.dmi', "hair")
		choices_initial["Sex"] = icon('modular_darkpack/modules/powers/icons/bodycrafting_radial.dmi', "sex",)
		choices_initial["Eyes"] = icon('modular_darkpack/modules/powers/icons/bodycrafting_radial.dmi', "eyes")
		choices_initial["Name"] = icon('modular_darkpack/modules/powers/icons/bodycrafting_radial.dmi', "name")
		choices_initial["Skin"] = icon('modular_darkpack/modules/powers/icons/bodycrafting_radial.dmi', "skin")
		choices_initial["Height"] = icon('modular_darkpack/modules/powers/icons/bodycrafting_radial.dmi', "height")
	for(var/i in choices_hair)
		choices_hair["Back"] = icon('modular_darkpack/modules/powers/icons/bodycrafting_radial.dmi', "back")
		choices_hair["Hair"] = icon('modular_darkpack/modules/powers/icons/bodycrafting_radial.dmi', "hair")
		choices_hair["Beard"] = icon('modular_darkpack/modules/powers/icons/bodycrafting_radial.dmi', "beard")
		choices_hair["Hair Color"] = icon('modular_darkpack/modules/powers/icons/bodycrafting_radial.dmi', "hair_color")
		choices_hair["Beard Color"] = icon('modular_darkpack/modules/powers/icons/bodycrafting_radial.dmi', "beard_color")

/datum/action/cooldown/mob_cooldown/bodycraft/Activate(atom/target)
	. = ..()
	display_radial_menu(target)
	return TRUE

/datum/action/cooldown/mob_cooldown/bodycraft/proc/display_radial_menu(mob/target)
	var/bodycraft_menu = show_radial_menu(owner, target, choices_initial, target, radius = 36, require_near = TRUE)
	if(bodycraft_menu == BODYCRAFT_HAIR_LIST)
		bodycraft_menu = show_radial_menu(owner, target, choices_hair, target, radius = 36, require_near = TRUE)
	if(!bodycraft_menu)
		return TRUE

	if(((target.pulledby == owner) && (owner.grab_state >= GRAB_AGGRESSIVE)) || (target == owner))
		vitae_cost = bodycrafting_costs[bodycraft_menu]
		if(!(bodycraft_menu in bodycrafting_costs))
			vitae_cost = 0
		if(target != owner)
			vitae_cost += 1
		spend_resources(owner)
		if (rollstate == "fail")
			return FALSE
		switch(bodycraft_menu)
			if(BODYCRAFT_BACK)
				back(target)
			if(BODYCRAFT_BEARD)
				change_beard(target)
			if(BODYCRAFT_HAIR)
				change_hair(target)
			if(BODYCRAFT_BEARD_COLOR)
				change_beard_color(target)
			if(BODYCRAFT_HAIR_COLOR)
				change_hair_color(target)
			if(BODYCRAFT_SEX)
				change_sex(target)
			if(BODYCRAFT_NAME)
				change_name(target)
			if(BODYCRAFT_EYES)
				change_eyes(target)
			if(BODYCRAFT_SKIN)
				change_skin(target)
			if(BODYCRAFT_HEIGHT)
				change_height(target)

	else
		to_chat(owner, span_danger("You need to have a firm grip on [target]!"))
		return TRUE

	if(!IN_GIVEN_RANGE(owner, target, range))
		return FALSE
	return display_radial_menu(target)

/datum/action/cooldown/mob_cooldown/bodycraft/proc/back(mob/living/carbon/human/target)
	return TRUE

/datum/action/cooldown/mob_cooldown/bodycraft/proc/change_sex(mob/living/carbon/human/target)
	var/chosen_sex = tgui_input_list(owner, "Choose a gender.", "Confirmation", list("Male", "Female", "Plural", "Neuter"), autofocus = FALSE)
	if(!chosen_sex)
		return FALSE
	if(!IN_GIVEN_RANGE(owner, target, range))
		return FALSE
	if(!HAS_TRAIT(owner, TRAIT_PROMETHEAN_CLAY))
		if(!do_after(owner, delay = 1 TURNS, target = target))
			return FALSE
	if(target != owner && !do_after(owner, delay = 1 TURNS, target = target))
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

	var/chosen_physique = tgui_input_list(owner, "Alter physique as well?", "Confirmation", list("Masculine", "Feminine"), autofocus = FALSE)
	if(!chosen_physique)
		return FALSE
	if(!IN_GIVEN_RANGE(owner, target, range))
		return FALSE
	if(!HAS_TRAIT(owner, TRAIT_PROMETHEAN_CLAY))
		if(!do_after(owner, delay = 1 TURNS, target = target))
			return FALSE
	if(target != owner && !do_after(owner, delay = 1 TURNS, target = target))
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

/datum/action/cooldown/mob_cooldown/bodycraft/proc/change_eyes(mob/living/carbon/human/target)
	var/new_eye_color = tgui_color_picker(owner, "Choose a eye color", "Eye Color", target.eye_color_left, default = null, autofocus = FALSE)
	if(!new_eye_color)
		return TRUE
	if(!IN_GIVEN_RANGE(owner, target, range))
		return FALSE
	if(!HAS_TRAIT(owner, TRAIT_PROMETHEAN_CLAY))
		if(!do_after(owner, delay = 1 TURNS, target = target))
			return FALSE
	if(target != owner && !do_after(owner, delay = 1 TURNS, target = target))
		return FALSE
	target.set_eye_color(sanitize_hexcolor(new_eye_color))
	target.dna.update_ui_block(/datum/dna_block/identity/eye_colors)
	target.update_body()
	SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)
	playsound(target, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)
	to_chat(owner, span_notice("You finish altering the eye color of [target]."))
	return TRUE

/datum/action/cooldown/mob_cooldown/bodycraft/proc/change_beard(mob/living/carbon/human/target)
	var/new_style = tgui_input_list(owner, "Select a facial hairstyle", "Grooming", SSaccessories.facial_hairstyles_list, autofocus = FALSE)
	if(!new_style)
		return FALSE
	if(!IN_GIVEN_RANGE(owner, target, range))
		return FALSE
	if(!HAS_TRAIT(owner, TRAIT_PROMETHEAN_CLAY))
		if(!do_after(owner, delay = 1 TURNS, target = target))
			return FALSE
	if(target != owner && !do_after(owner, delay = 1 TURNS, target = target))
		return FALSE
	target.set_facial_hairstyle(new_style, update = TRUE)
	SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)
	playsound(target, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)
	to_chat(owner, span_notice("You finish altering the facial style of [target]."))
	return TRUE

/datum/action/cooldown/mob_cooldown/bodycraft/proc/change_beard_color(mob/living/carbon/human/target)
	var/new_face_color = tgui_color_picker(owner, "Choose a facial hair color", "Hair Color", target.facial_hair_color, default = null, autofocus = FALSE)
	if(!new_face_color)
		return FALSE
	if(!IN_GIVEN_RANGE(owner, target, range))
		return FALSE
	if(!HAS_TRAIT(owner, TRAIT_PROMETHEAN_CLAY))
		if(!do_after(owner, delay = 1 TURNS, target = target))
			return FALSE
	if(target != owner && !do_after(owner, delay = 1 TURNS, target = target))
		return FALSE
	target.set_facial_haircolor(sanitize_hexcolor(new_face_color))
	target.dna.update_ui_block(/datum/dna_block/identity/facial_color)
	SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)
	playsound(target, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)
	to_chat(owner, span_notice("You finish altering the facial hair color of [target]."))
	return TRUE

/datum/action/cooldown/mob_cooldown/bodycraft/proc/change_hair(mob/living/carbon/human/target)
	var/new_style = tgui_input_list(owner, "Select a hairstyle", "Grooming", SSaccessories.hairstyles_list, autofocus = FALSE)
	if(!new_style)
		return FALSE
	if(!IN_GIVEN_RANGE(owner, target, range))
		return FALSE
	if(!HAS_TRAIT(owner, TRAIT_PROMETHEAN_CLAY))
		if(!do_after(owner, delay = 1 TURNS, target = target))
			return FALSE
	if(target != owner && !do_after(owner, delay = 1 TURNS, target = target))
		return FALSE
	target.set_hairstyle(new_style, update = TRUE)
	SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)
	playsound(target, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)
	to_chat(owner, span_notice("You finish altering the hair style of [target]."))
	return TRUE

/datum/action/cooldown/mob_cooldown/bodycraft/proc/change_hair_color(mob/living/carbon/human/target)
	var/new_hair_color = tgui_color_picker(owner, "Choose a hair color", "Hair Color", target.hair_color, default = null, autofocus = FALSE)
	if(!new_hair_color)
		return FALSE
	if(!IN_GIVEN_RANGE(owner, target, range))
		return FALSE
	if(!HAS_TRAIT(owner, TRAIT_PROMETHEAN_CLAY))
		if(!do_after(owner, delay = 1 TURNS, target = target))
			return FALSE
	if(target != owner && !do_after(owner, delay = 1 TURNS, target = target))
		return FALSE
	target.set_haircolor(sanitize_hexcolor(new_hair_color))
	target.dna.update_ui_block(/datum/dna_block/identity/hair_color)
	SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)
	playsound(target, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)
	to_chat(owner, span_notice("You finish altering the hair color of [target]."))
	return TRUE

/datum/action/cooldown/mob_cooldown/bodycraft/proc/change_name(mob/living/carbon/human/target)
	var/newname = sanitize_name(tgui_input_text(owner, "Who are we again?", "Name change", target.real_name, MAX_NAME_LEN, autofocus = FALSE))
	if(!newname || newname == target.real_name)
		return FALSE
	if(!IN_GIVEN_RANGE(owner, target, range))
		return FALSE
	if(!HAS_TRAIT(owner, TRAIT_PROMETHEAN_CLAY))
		if(!do_after(owner, delay = 1 TURNS, target = target))
			return FALSE
	if(target != owner && !do_after(owner, delay = 1 TURNS, target = target))
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

/datum/action/cooldown/mob_cooldown/bodycraft/proc/change_skin(mob/living/carbon/human/target)
	var/list/skin_tones = list()
	for(var/skin_tone in GLOB.skin_tone_names)
		var/skin_tone_name = GLOB.skin_tone_names[skin_tone]
		skin_tones[skin_tone_name] = skin_tone

	var/new_s_tone = tgui_input_list(owner, "Choose a skin tone", "Skin change", skin_tones, autofocus = FALSE)
	new_s_tone = skin_tones[new_s_tone]
	if(!new_s_tone)
		return FALSE
	if(!IN_GIVEN_RANGE(owner, target, range))
		return FALSE
	if(!HAS_TRAIT(owner, TRAIT_PROMETHEAN_CLAY))
		if(!do_after(owner, delay = 1 TURNS, target = target))
			return FALSE
	if(target != owner && !do_after(owner, delay = 1 TURNS, target = target))
		return FALSE
	target.skin_tone = new_s_tone
	target.dna.update_ui_block(/datum/dna_block/identity/skin_tone)
	target.update_body(is_creating = TRUE)
	target.update_appearance(UPDATE_OVERLAYS)
	SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)
	playsound(target, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)
	to_chat(owner, span_notice("You finish altering the skin of [target]."))
	return TRUE

/datum/action/cooldown/mob_cooldown/bodycraft/proc/change_height(mob/living/carbon/human/target)
	var/list/heights = list(
		"Taller" = HUMAN_HEIGHT_TALLER,
		"Tall" = HUMAN_HEIGHT_TALL,
		"Average" = HUMAN_HEIGHT_MEDIUM,
		"Short" = HUMAN_HEIGHT_SHORT,
		"Shorter" = HUMAN_HEIGHT_SHORTEST,
		)

	var/new_height = tgui_input_list(owner, "Choose a height", "Height change", heights, autofocus = FALSE)
	new_height = heights[new_height]
	if(!new_height)
		return FALSE
	if(!IN_GIVEN_RANGE(owner, target, range))
		return FALSE
	if(!HAS_TRAIT(owner, TRAIT_PROMETHEAN_CLAY))
		if(!do_after(owner, delay = 1 TURNS, target = target))
			return FALSE
	if(target != owner && !do_after(owner, delay = 1 TURNS, target = target))
		return FALSE
	target.set_mob_height(new_height)
	SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)
	playsound(target, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)
	to_chat(owner, span_notice("You finish altering the height of [target]."))
	return TRUE

// OPTIONS
#undef BODYCRAFT_HAIR
#undef BODYCRAFT_BEARD
#undef BODYCRAFT_HAIR_COLOR
#undef BODYCRAFT_BEARD_COLOR
#undef BODYCRAFT_SEX
#undef BODYCRAFT_EYES
#undef BODYCRAFT_NAME
#undef BODYCRAFT_SKIN
#undef BODYCRAFT_HEIGHT
// LISTS
#undef BODYCRAFT_BACK
#undef BODYCRAFT_HAIR_LIST
// OPTION LISTS
#undef BODYCRAFT_OPTIONS_HAIR
#undef BODYCRAFT_OPTIONS
