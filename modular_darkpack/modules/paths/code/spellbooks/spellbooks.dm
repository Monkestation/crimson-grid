/obj/item/path_spellbook
	abstract_type = /obj/item/path_spellbook
	name = "path spellbook"
	desc = "A default path spellbook. if you're seeing this ingame, please report to coders"
	icon = 'modular_darkpack/modules/paths/icons/paths.dmi'
	icon_state = "spellbook_unfinished"
	drop_sound = 'sound/items/handling/book_drop.ogg'
	pickup_sound = 'sound/items/handling/book_pickup.ogg'
	var/activate_sound = 'modular_darkpack/modules/paths/sounds/open_book.ogg'
	var/deactivate_sound = 'modular_darkpack/modules/paths/sounds/close_book.ogg'

	var/path_type = null
	var/path_level = 1
	var/do_after_time = 30 SECONDS

	var/identified = FALSE
	var/true_name = ""
	var/true_desc = ""

	var/datum/storyteller_roll/identify_occult/identify_roll

/obj/item/path_spellbook/Initialize(mapload)
	. = ..()
	if(!identified)
		true_name = name
		true_desc = desc
		name = "dusty forgotten tome"
		desc = "This book is covered in dust and the pages appear worn. Its probably not important."
	AddComponent(/datum/component/selling, 100, "artifact", FALSE, 0, 10, TRUE)

/obj/item/path_spellbook/examine(mob/user)
	. = ..()
	if(!identified)
		. += span_notice("You could try to clean off the dust to see what lies beneath.")

/obj/item/path_spellbook/attack_self(mob/living/carbon/human/user)
	if(!istype(user))
		return FALSE

	if(!identified)
		if(do_after(user, 1 TURNS))
			if(!identify_roll)
				identify_roll = new()
				identify_roll.difficulty = path_level + 3
			var/roll = identify_roll.st_roll(user, src)
			switch(roll)
				if(ROLL_SUCCESS)
					to_chat(user, span_cult("You wipe the dust off the previously irrelevant tome. Did someone misplace it from the Library?"))
					src.identified = TRUE
					name = true_name
					desc = true_desc
					return
				else
					to_chat(user, span_warning("You fail to figure out the real nature of the book and get distracted by more important matters. Maybe its a cookbook?"))
					return
		return

	var/datum/splat/vampire/kindred/kindred = get_kindred_splat(user)
	var/datum/discipline/existing_path_discipline = kindred?.get_discipline(path_type)

	if(!path_type)
		to_chat(user, span_warning("This spellbook appears to be incomplete!"))
		return

	if(get_kindred_splat(user))
		if(!user.get_discipline(/datum/discipline/thaumaturgy))
			to_chat(user, span_warning("You must have knowledge of Thaumaturgy to use this book!"))
			return
		if(existing_path_discipline)
			//Then we check if the level can be learned
			if(path_level == existing_path_discipline.level)
				// User already knows this level
				to_chat(user, span_warning("You already know this book!"))
				return
			else if(path_level == existing_path_discipline.level + 1)
				// The book's level is one higher than the user's current level
				user.playsound_local(user, activate_sound, 50, FALSE)
			else if (path_level > existing_path_discipline.level + 1)
				// The book's level is too high for the user to learn
				to_chat(user, span_warning("You must learn the previous book(s) first!"))
				return
			else if (path_level < existing_path_discipline.level)
				// The book's level is lower than the user's current level
				to_chat(user, span_warning("You already know a higher level of this path!"))
				return
		// If we reach here, the user does not know this path at all
		if(path_level > 1 && !existing_path_discipline)
			to_chat(user, span_warning("You must know the first level of this path before you can learn higher levels!"))
			return
		else if(path_level == 1 && !existing_path_discipline)
			user.playsound_local(user, activate_sound, 50, FALSE)
	else
		to_chat(user, span_warning("This book is filled with gibberish and nonsense."))
		return

	var/original_icon_state = icon_state
	icon_state = "[original_icon_state]-opened"
	update_appearance()

	to_chat(user, span_notice("You begin studying the ancient texts..."))

	if(do_after(user, do_after_time, target = src))
		// Now checking the level again to assign the correct path level
		if(!existing_path_discipline)
			user.give_st_power(path_type, path_level)
			to_chat(user, span_notice("The knowledge of [name] flows into your mind!"))
		else
			// If the user already knows the path, update the level
			to_chat(user, span_notice("You have increased your knowledge of [name]!"))

			user.remove_st_power(path_type)
			user.give_st_power(path_type, path_level)

		user.playsound_local(user, deactivate_sound, 50, FALSE)
		qdel(src)
	else
		icon_state = original_icon_state
		update_appearance()
		to_chat(user, span_warning("Your concentration was broken!"))


/obj/item/occult_book
	abstract_type = /obj/item/occult_book
	name = "occult book"
	desc = "A default occult book. if you're seeing this ingame, please report to coders"
	icon = 'modular_darkpack/modules/paths/icons/paths.dmi'
	icon_state = "spellbook_unfinished"
	var/do_after_time = 30 SECONDS
	var/activate_sound = 'modular_darkpack/modules/paths/sounds/open_book.ogg'
	var/deactivate_sound = 'modular_darkpack/modules/paths/sounds/close_book.ogg'
	drop_sound = 'sound/items/handling/book_drop.ogg'
	pickup_sound = 'sound/items/handling/book_pickup.ogg'

	// research vars overriden by subtypes
	var/research_value = 10
	var/study_cooldown = 30 MINUTES
	var/study_research_value = 50
	var/required_discipline = /datum/discipline/thaumaturgy
	var/no_trait_message = "The text is incomprehensible to you without the proper knowledge."
	var/cooldown_message = "You have recently studied this tome extensively. You need %TIME% more minutes before you can gain further insight from it."
	var/study_start_message = "You begin studying the occult text..."
	var/study_interrupted_message = "Your concentration was broken. You failed to absorb any meaningful knowledge from the text."
	var/research_gain_message = "You gain %POINTS% research points from studying this tome!"

	// Flavor texts, must be overriden by subtypes
	var/list/study_flavor_texts = list(
		"You study the arcane text, gaining insight into occult mysteries.",
		"Ancient knowledge flows from the pages into your mind.",
		"The text reveals secrets of supernatural power and ritual."
	)

/obj/item/occult_book/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 100, "artifact", FALSE, 0, 10, TRUE)

/obj/item/occult_book/attack_self(mob/living/carbon/human/user)
	if(!can_study(user))
		return ..()

	if(!check_cooldown(user))
		return

	begin_study(user)
	return ..()

/obj/item/occult_book/proc/can_study(mob/living/carbon/human/user)
	if(required_discipline && !user.get_discipline(required_discipline))
		to_chat(user, span_warning(no_trait_message))
		return FALSE
	return TRUE

/obj/item/occult_book/proc/check_cooldown(mob/living/carbon/human/user)
	if(!COOLDOWN_FINISHED(src, study_cooldown))
		to_chat(user, span_warning(cooldown_message))
		return FALSE
	return TRUE

/obj/item/occult_book/proc/begin_study(mob/living/carbon/human/user)
	var/original_icon_state = icon_state
	icon_state = "[original_icon_state]-opened"
	update_appearance()

	to_chat(user, span_notice(study_start_message))
	user.playsound_local(user, activate_sound, 50, FALSE)

	if(do_after(user, do_after_time, target = src))
		complete_study(user)
	else
		to_chat(user, span_warning(study_interrupted_message))

	icon_state = original_icon_state
	update_appearance()

/obj/item/occult_book/proc/complete_study(mob/living/carbon/human/user)
	user.research_points += study_research_value
	var/flavor_text = pick(study_flavor_texts)
	to_chat(user, span_cult(flavor_text))

	var/formatted_message = replacetext(research_gain_message, "%POINTS%", "[study_research_value]")
	to_chat(user, span_green(formatted_message))

	COOLDOWN_START(src, study_cooldown, study_cooldown)
	user.playsound_local(user, deactivate_sound, 50, FALSE)
