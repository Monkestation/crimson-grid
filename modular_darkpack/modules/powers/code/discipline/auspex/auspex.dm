#define SENSE_VISION "Vision"
#define SENSE_HEARING "Hearing"
#define SENSE_SMELL "Smell"
#define SENSE_TASTE "Taste"
#define SENSE_TOUCH "Touch"
#define TELEPATHY_MIND_READING "Mind Reading"
#define TELEPATHY_IMPLANT_THOUGHT "Implant Thoughts"

/datum/discipline/auspex
	name = "Auspex"
	desc = "Allows to see entities, auras and their health through walls."
	icon_state = "auspex"
	power_type = /datum/discipline_power/auspex

/datum/discipline_power/auspex
	name = "Auspex power name"
	desc = "Auspex power description"

	activate_sound = 'modular_darkpack/modules/powers/sounds/auspex/auspex.ogg'
	deactivate_sound = 'modular_darkpack/modules/powers/sounds/auspex/auspex_deactivate.ogg'

//HEIGHTENED SENSES
/datum/discipline_power/auspex/heightened_senses
	name = "Heightened Senses"
	desc = "Enhances your senses far past human limitations."

	level = 1
	check_flags = DISC_CHECK_CONSCIOUS
	vitae_cost = 0
	cooldown_length = 1 TURNS

	toggled = TRUE

/datum/discipline_power/auspex/heightened_senses/activate()
	. = ..()

	var/list/chosen_sense = tgui_input_checkboxes(owner, "Choose a sense to heighten", "Heightened Senses", list(
		SENSE_VISION,
		SENSE_HEARING,
		SENSE_SMELL,
		SENSE_TASTE,
		SENSE_TOUCH
	))
	if(isnull(chosen_sense))
		deactivate()
		return
	var/list/output_senses = list()
	for(var/list/sense as anything in chosen_sense)
		output_senses += sense[1]

	if(SENSE_VISION in output_senses)
		owner.client?.view_size?.setTo(2) // This increases the view size of the player by 2 tiles in each direction. I dont know why it's called Set if it Adds.
		ADD_TRAIT(owner, TRAIT_REFLECTIVE_EYES, DISCIPLINE_TRAIT(type))
		var/obj/item/organ/eyes/kindred_eyes = owner.get_organ_slot(ORGAN_SLOT_EYES)
		if(kindred_eyes)
			kindred_eyes.flash_protect = max(kindred_eyes.flash_protect += -2, FLASH_PROTECTION_HYPER_SENSITIVE)
	if(SENSE_HEARING in output_senses)
		ADD_TRAIT(owner, TRAIT_GOOD_HEARING, DISCIPLINE_TRAIT(type))
		var/obj/item/organ/ears/kindred_ears = owner.get_organ_slot(ORGAN_SLOT_EARS)
		kindred_ears.damage_multiplier = kindred_ears.damage_multiplier + 1
	if(SENSE_SMELL in output_senses)
		owner.dna?.add_mutation(/datum/mutation/olfaction, DISCIPLINE_TRAIT(type))
	if(SENSE_TASTE in output_senses)
		ADD_TRAIT(owner, TRAIT_REAGENT_SCANNER, DISCIPLINE_TRAIT(type))
	if(SENSE_TOUCH in output_senses)
		RegisterSignals(owner, list(COMSIG_CARBON_HELP_ACT, COMSIG_ON_CARBON_SLIP, COMSIG_LIVING_DISARM_HIT, COMSIG_LIVING_TRYING_TO_PULL), PROC_REF(on_touch))
		owner.AddComponent(/datum/component/heartbeat_sensing, color_path = /datum/client_colour/psyker)

	owner.st_add_stat_mod(STAT_PERCEPTION, discipline.level, "heightened_senses")

/datum/discipline_power/auspex/heightened_senses/deactivate()
	. = ..()
	// Smell
	var/datum/mutation/mutation = owner.dna?.get_mutation(/datum/mutation/olfaction)
	if(mutation)
		owner.dna?.remove_mutation(mutation, mutation.sources)
	// Hearing
	REMOVE_TRAIT(owner, TRAIT_GOOD_HEARING, DISCIPLINE_TRAIT(type))
	var/obj/item/organ/ears/kindred_ears = owner.get_organ_slot(ORGAN_SLOT_EARS)
	kindred_ears.damage_multiplier = initial(kindred_ears.damage_multiplier)
	// Vision
	owner.client?.view_size?.resetToDefault()
	REMOVE_TRAIT(owner, TRAIT_REFLECTIVE_EYES, DISCIPLINE_TRAIT(type))
	var/obj/item/organ/eyes/kindred_eyes = owner.get_organ_slot(ORGAN_SLOT_EYES)
	if(kindred_eyes)
		kindred_eyes.flash_protect = max(kindred_eyes.flash_protect += 2, FLASH_PROTECTION_NONE)
	// Taste
	REMOVE_TRAIT(owner, TRAIT_REAGENT_SCANNER, DISCIPLINE_TRAIT(type))
	// Touch
	UnregisterSignal(owner, list(COMSIG_CARBON_HELP_ACT, COMSIG_ON_CARBON_SLIP, COMSIG_LIVING_DISARM_HIT, COMSIG_LIVING_TRYING_TO_PULL))
	qdel(owner.GetComponent(/datum/component/heartbeat_sensing))

	owner.st_remove_stat_mod(STAT_PERCEPTION, "heightened_senses")

/datum/discipline_power/auspex/heightened_senses/proc/on_touch(datum/source)
	SIGNAL_HANDLER

	INVOKE_ASYNC(owner, TYPE_PROC_REF(/mob, emote), "shiver", forced = TRUE)
	owner.Stun(0.5 SECONDS)


/datum/storyteller_roll/aura_perception
	bumper_text = "aura reading"
	difficulty = 8
	applicable_stats = list(STAT_PERCEPTION, STAT_EMPATHY)
	roll_output_type = ROLL_PRIVATE

//AURA PERCEPTION
/datum/discipline_power/auspex/aura_perception
	name = "Aura Perception"
	desc = "Allows you to perceive the auras of those near you."

	level = 2
	check_flags = DISC_CHECK_CONSCIOUS
	duration_length = 1 SCENES
	cooldown_length = 1 SCENES
	vitae_cost = 0

	toggled = TRUE
	var/datum/storyteller_roll/aura_perception/aura_roll

/datum/discipline_power/auspex/aura_perception/pre_activation_checks(mob/living/target)
	. = ..()
	if(!aura_roll)
		aura_roll = new()
	switch(aura_roll.st_roll(owner, target))
		if(ROLL_SUCCESS)
			return TRUE
		else
			to_chat(owner, span_danger("You fail to read into anything at all..."))
			return FALSE

/datum/discipline_power/auspex/aura_perception/activate()
	. = ..()
	var/datum/atom_hud/data/auspex_aura/target_hud = GLOB.huds[DATA_HUD_AUSPEX_AURAS]
	target_hud.show_to(owner)

	var/list/heard = orange(DEFAULT_MESSAGE_RANGE, owner)
	for(var/mob/living/hearer in heard)
		if(!HAS_TRAIT(src, TRAIT_FORCED_EMOTION))
			hearer.apply_status_effect(/datum/status_effect/question_emotion)

/datum/discipline_power/auspex/aura_perception/deactivate()
	. = ..()
	var/datum/atom_hud/data/auspex_aura/target_hud = GLOB.huds[DATA_HUD_AUSPEX_AURAS]
	target_hud.hide_from(owner)

//THE SPIRIT'S TOUCH
/datum/discipline_power/auspex/the_spirits_touch
	name = "The Spirit's Touch"
	desc = "Allows you to feel the physical wellbeing of those near you."

	level = 3
	check_flags = DISC_CHECK_CONSCIOUS
	vitae_cost = 0
	cooldown_length = 1 TURNS

	toggled = TRUE

/datum/discipline_power/auspex/the_spirits_touch/activate()
	. = ..()

	var/datum/atom_hud/health_hud = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	health_hud.show_to(owner)
	owner.update_sight()

	RegisterSignal(owner, COMSIG_MOB_EXAMINING, PROC_REF(scan))

/datum/discipline_power/auspex/the_spirits_touch/deactivate()
	. = ..()

	var/datum/atom_hud/health_hud = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	health_hud.hide_from(owner)
	owner.update_sight()

	UnregisterSignal(owner, COMSIG_MOB_EXAMINING)

/datum/discipline_power/auspex/the_spirits_touch/proc/scan(mob/user, atom/scanned_atom, list/examine_strings)
	// Can scan items we hold and store
	if(!(scanned_atom in user.get_all_contents()))
		// Can remotely scan objects and mobs.
		if((get_dist(scanned_atom, user) > 8) || (!(scanned_atom in view(8, user))))
			return TRUE

	// GATHER INFORMATION

	var/datum/detective_scanner_log/log_entry = new

	// Start gathering

	log_entry.scan_target = scanned_atom.name

	var/list/atom_fibers = GET_ATOM_FIBRES(scanned_atom)
	if(length(atom_fibers))
		log_entry.add_data_entry(DETSCAN_CATEGORY_FIBER, atom_fibers.Copy())

	var/list/blood = GET_ATOM_BLOOD_DNA(scanned_atom)
	if(length(blood))
		log_entry.add_data_entry(DETSCAN_CATEGORY_BLOOD, blood.Copy())

	if(ishuman(scanned_atom))
		var/mob/living/carbon/human/scanned_human = scanned_atom
		if(!scanned_human.gloves)
			log_entry.add_data_entry(
				DETSCAN_CATEGORY_FINGERS,
				rustg_hash_string(RUSTG_HASH_MD5, scanned_human.dna?.unique_identity)
			)

	else if(!ismob(scanned_atom))

		var/list/atom_fingerprints = GET_ATOM_FINGERPRINTS(scanned_atom)
		if(length(atom_fingerprints))
			log_entry.add_data_entry(DETSCAN_CATEGORY_FINGERS, atom_fingerprints.Copy())

		// Only get reagents from non-mobs.
		for(var/datum/reagent/present_reagent as anything in scanned_atom.reagents?.reagent_list)
			log_entry.add_data_entry(DETSCAN_CATEGORY_REAGENTS, list(present_reagent.name = present_reagent.volume))

			// Get blood data from the blood reagent.
			if(!istype(present_reagent, /datum/reagent/blood))
				continue

			var/blood_DNA = present_reagent.data["blood_DNA"]
			var/blood_type = present_reagent.data["blood_type"]
			if(!blood_DNA || !blood_type)
				continue

			log_entry.add_data_entry(DETSCAN_CATEGORY_BLOOD, list(blood_DNA = blood_type))

	if(istype(scanned_atom, /obj/item/card/id))
		var/obj/item/card/id/user_id = scanned_atom
		for(var/region in DETSCAN_ACCESS_ORDER())
			var/access_in_region = SSid_access.accesses_by_region[region] & user_id.GetAccess()
			if(!length(access_in_region))
				continue
			var/list/access_names = list()
			for(var/access_num in access_in_region)
				access_names += SSid_access.get_access_desc(access_num)

			log_entry.add_data_entry(DETSCAN_CATEGORY_ACCESS, list("[region]" = english_list(access_names)))

	// sends it off to be modified by the items
	SEND_SIGNAL(scanned_atom, COMSIG_DETECTIVE_SCANNED, user, log_entry)

	// Perform sorting now, because probably this will be never modified
	log_entry.sort_data_entries()
	var/list/generated_report_text = log_entry.generate_report_text()
	var/output_report = generated_report_text.Join()

	examine_strings += boxed_message(output_report)
	return TRUE

//TELEPATHY
/datum/discipline_power/auspex/telepathy
	name = "Telepathy"
	desc = "Project your thoughts into the mind of another."

	level = 4
	check_flags = DISC_CHECK_CONSCIOUS
	target_type = TARGET_LIVING
	vitae_cost = 0
	cooldown_length = 1 TURNS
	range = 7
	var/telepathy_types = list(TELEPATHY_MIND_READING, TELEPATHY_IMPLANT_THOUGHT)
	var/telepathy_type_selected
	var/successes
	var/disguised_voice
	var/datum/storyteller_roll/telepathy_success/telepathy_roll
	var/datum/storyteller_roll/disguise_voice_roll/disguise_roll

/datum/storyteller_roll/telepathy_success
	bumper_text = "mind reading"
	applicable_stats = list(STAT_INTELLIGENCE, STAT_SUBTERFUGE)
	numerical = TRUE
	roll_output_type = ROLL_PRIVATE

/datum/storyteller_roll/disguise_voice_roll
	bumper_text = "disguise voice"
	applicable_stats = list(STAT_MANIPULATION, STAT_SUBTERFUGE)
	numerical = FALSE
	roll_output_type = ROLL_PRIVATE

/datum/discipline_power/auspex/telepathy/pre_activation_checks(mob/living/target)
	. = ..()
	if(!telepathy_roll)
		telepathy_roll = new()
	telepathy_roll.difficulty = target.st_get_stat(STAT_TEMPORARY_WILLPOWER)
	successes = telepathy_roll.st_roll(owner, target)
	if(successes > 0)
		// need linebreaks... but \n and <br> arent working...
		var/telepathy_type = tgui_input_list(owner, "What kind of Telepathy would you like to perform? Reading the minds of supernaturals requires expending one temporary willpower point.", "Telepathy Type Selection", telepathy_types, TELEPATHY_IMPLANT_THOUGHT)
		switch(telepathy_type)
			if(TELEPATHY_MIND_READING)
				//var/supernatural_splat = issupernatural(target)??? the current issupernatural just checks for a single splat, which doesnt qualify for the -1 willpower, think its just other 'undead' p137 V20
				if(get_kindred_splat(target) || get_shifter_splat(target))
					owner.st_set_stat(STAT_TEMPORARY_WILLPOWER, owner.st_get_stat(STAT_TEMPORARY_WILLPOWER) - 1)
			if(TELEPATHY_IMPLANT_THOUGHT)
				var/disguise_voice_prompt = tgui_input_list(owner, "Attempt to disguise the origin of the implanted thought? Requires a Manipulation + Subterfuge roll at the difficulty of the target's Perception + Awareness", "Disguise Voice", list("Yes", "No"), "No")
				switch(disguise_voice_prompt)
					if("Yes")
						if(!disguise_roll)
							disguise_roll = new()
						disguise_roll.difficulty = target.st_get_stat(STAT_PERCEPTION) + target.st_get_stat(STAT_AWARENESS)
						switch(disguise_roll.st_roll(owner, target))
							if(ROLL_SUCCESS)
								disguised_voice = tgui_input_text(owner, "What will be the 'voice' of this implanted thought?", "Implanted Voice Selection")
							if(ROLL_FAILURE, ROLL_BOTCH)
								to_chat(span_danger("You fail to disguise your voice - the subject hears your voice in their head!"))
								disguised_voice = owner.name
					if("No")
						disguised_voice = owner.name
		telepathy_type_selected = telepathy_type
		return TRUE
	return FALSE


/datum/discipline_power/auspex/telepathy/activate(mob/living/target)
	. = ..()
	var/input_message
	var/specific_search
	switch(telepathy_type_selected)
		if(TELEPATHY_IMPLANT_THOUGHT)
			input_message = tgui_input_text(owner, "What message will you project to them?", "Telepathic Message")
			if(!input_message)
				return

			if(!sanitize_input_message(input_message))
				return

			log_directed_talk(owner, target, input_message, LOG_SAY, "Telepathy")
			to_chat(owner, span_notice("You project your thoughts into [target]'s mind: \"[input_message]\""))
			to_chat(target, span_boldannounce("You hear the voice of [disguised_voice] in your thoughts: \"[input_message]\""))

		if(TELEPATHY_MIND_READING)
			var/flavor_text_telepathy = "Someone nearby reads your mind without your knowing..." + get_flavor_text(successes)
			var/mind_reading_search = tgui_input_list(owner, "Are you searching their mind for specific information? Deeper secrets and long-past memories require more successes.", "Mind Reading Specifics", list("Yes", "No"), "No")
			if(mind_reading_search == "Yes")
				specific_search = tgui_input_text(owner, "What are you trying to mind read from your victim?", "Mind Reading Search Input", max_length = MAX_MESSAGE_LEN)
				if(!specific_search)
					specific_search = "something specific"

			var/prompt_message = flavor_text_telepathy
			if(specific_search)
				prompt_message += "The telepath specifically scans your mind for : [specific_search]"
			else
				prompt_message += "The telepath searches your recent thoughts and emotions..."

			input_message = tgui_input_text(target, prompt_message, "Mind Being Read")
			if(!input_message)
				input_message = "Fragmented, unclear thoughts and impressions."

			if(!sanitize_input_message(input_message))
				return

			log_directed_talk(target, owner, input_message, LOG_SAY, "Telepathy (Mind Reading)")
			to_chat(owner, span_notice("You read [target]'s thoughts with [successes] successes: [input_message]"))

/datum/discipline_power/auspex/telepathy/proc/get_flavor_text(successes)
	var/message = "As your mind is read with [successes] successes, "
	switch(successes)
		if(1)
			message += "the most surface-level thoughts or unspoken comments are easily read, but if your character was expecting their mind to be read, they can make an effort to obfuscate their true thoughts..."
		if(2)
			message += "the person reading your mind begins to probe deeper into your subconcious, revealing deeper, or clearer, thoughts..."
		if(3)
			message += "your mind begins to be probed at a deep level, revealing verbatim thoughts, details, secrets and recent memories..."
		if(4)
			message += "your mind is being deeply invaded. Hidden thoughts, suppressed emotions, and secrets you've tried to bury begin to surface. The attacker can access memories and feelings you may have forgotten without you ever knowing..."
		if(5 to INFINITY)
			message += "your deepest secrets and most buried memories are laid bare. The telepath can access traumatic experiences, long-forgotten events, and the darkest corners of your psyche. Nothing is hidden..."
	return message

/datum/discipline_power/auspex/telepathy/proc/sanitize_input_message(input_message)
	//sanitisation!
	input_message = CAN_BYPASS_FILTER(owner) ? strip_html_full(input_message, MAX_MESSAGE_LEN) : input_message
	var/list/filter_result = CAN_BYPASS_FILTER(owner) ? null : is_ooc_filtered(input_message)
	if(filter_result)
		REPORT_CHAT_FILTER_TO_USER(owner, filter_result)
		log_filter("OOC", input_message, filter_result)
		return FALSE
	return TRUE

//PSYCHIC PROJECTION
/datum/discipline_power/auspex/psychic_projection
	name = "Psychic Projection"
	desc = "Leave your body behind and fly across the land."

	willpower_cost = 1
	level = 5
	check_flags = DISC_CHECK_CONSCIOUS
	vitae_cost = 0
	cooldown_length = 1 TURNS

/datum/discipline_power/auspex/psychic_projection/activate()
	. = ..()
	var/roll = SSroll.storyteller_roll(owner.st_get_stat(STAT_PERCEPTION) + owner.st_get_stat(STAT_AWARENESS), 7, owner)
	if(roll == ROLL_SUCCESS)
		owner.enter_avatar()
	else
		to_chat(owner, span_warning("Your mind fails to leave your body."))

#undef TELEPATHY_MIND_READING
#undef TELEPATHY_IMPLANT_THOUGHT
#undef SENSE_VISION
#undef SENSE_HEARING
#undef SENSE_SMELL
#undef SENSE_TASTE
#undef SENSE_TOUCH
