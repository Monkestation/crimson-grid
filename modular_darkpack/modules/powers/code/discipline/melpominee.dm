/datum/discipline/melpominee
	name = "Melpominee"
	desc = "Named for the Greek Muse of Tragedy, Melpominee is a unique discipline of the Daughters of Cacophony. It explores the power of the voice, shaking the very soul of those nearby and allowing the vampire to perform sonic feats otherwise impossible."
	icon_state = "melpominee"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/melpominee

/datum/discipline_power/melpominee
	name = "Melpominee power name"
	desc = "Melpominee power description"

	activate_sound = 'modular_darkpack/modules/powers/sounds/melpominee/melpominee.ogg'

	vitae_cost = 1 // All Melpominee powers below 5 dots cost blood except for Missing Voice
	var/obj/effect/abstract/particle_holder/particle_generator

/datum/discipline_power/melpominee/proc/setup_particles()
	if(!particle_generator)
		particle_generator = new(owner, /particles/melpominee, PARTICLE_ATTACH_MOB)

/particles/melpominee
	icon = 'modular_darkpack/modules/phones/icons/phone.dmi'
	icon_state = list("note" = 1)
	width = 32
	height = 48
	count = 5
	spawning = 0.5
	lifespan = 5 SECONDS
	fade = 1.5 SECONDS
	gravity = list(0, 0.1)
	position = generator(GEN_SPHERE, 0, 16, NORMAL_RAND)
	spin = generator(GEN_NUM, -1, 1, NORMAL_RAND)

/**
 * • The Missing Voice - p453
 *
 * The character can “throw” her voice anywhere within her line of sight. This enables the Daughter to carry on surreptitious conversations,
 * sing duets with herself, or cause any number of distractions. This power can also be combined with other Melpominee powers to
 * disguise their source (and some Daughters use it to conceal the fact that Melpominee powers do not function through recorded media).
 *
 * The Daughter clicks on an object, mob, or turf and sends a message from that location.
 *
 */
/obj/effect/the_missing_voice
	name = "disembodied voice"
	desc = "What are you, a ghost lip-reader?"

/datum/discipline_power/melpominee/the_missing_voice
	name = "The Missing Voice"
	desc = "Throw your voice to any place you can see."

	level = 1
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_SPEAK
	target_type = TARGET_MOB | TARGET_OBJ | TARGET_TURF
	range = 7
	vitae_cost = 0

/datum/discipline_power/melpominee/the_missing_voice/activate(atom/movable/target)
	. = ..()
	var/new_say = tgui_input_text(owner, "What will you say?")
	if(!new_say)
		return

	//prevent forceful emoting and whatnot
	new_say = trim(copytext_char(sanitize(new_say), 1, MAX_MESSAGE_LEN))
	if(!owner.try_speak(new_say))
		return

	if(findtext(new_say, "*"))
		to_chat(owner, span_danger("You can't emote with [name]!"))
		return

	var/obj/dummy = new /obj/effect/the_missing_voice(get_turf(target)) // snowflake code but it's more robust than engineering some evil to_chat mechanism
	if(!(dummy in view(world.view, owner)))
		to_chat(owner, span_warning("You need line of sight to the location your voice is coming from."))
		return

	dummy.name = owner.get_generic_name(TRUE, TRUE) + "'s voice"
	dummy.say(message = new_say, forced = "melpominee 1")
	QDEL_IN(dummy, 2 TURNS)

/**
 * •• Phantom Speaker  - p453
 *
 * The Daughter can project her voice to any individual she has personally met. Distance is no object,
 * but it must be night wherever the target presently is. The vampire can sing, talk, or otherwise project her voice in
 * any way she sees fit (including other uses of Melpominee), but she cannot hear what she is saying,
 * and therefore suffers a +1 difficulty to any rolls accompanying her utterance. For instance, the vampire could
 * project her voice to an enemy in an attempt to intimidate him, but would suffer a +1 to the difficulty of the Charisma + Intimidation roll.
 *
 * The Daughter selects a mob from their guestbook and sends a message to them, provided she succedes a Wits + Performance roll. The next N messages
 * do not require a roll and do not expend blood
 *
 */
/datum/storyteller_roll/phantom_speaker
	bumper_text = "Phantom Speaker"
	difficulty = 7
	successes_needed = 1
	applicable_stats = list(STAT_WITS, STAT_PERFORMANCE)
	numerical = TRUE
	roll_output_type = ROLL_PRIVATE
	spammy_roll = TRUE

/datum/discipline_power/melpominee/phantom_speaker
	name = "Phantom Speaker"
	desc = "Project your voice to anyone you've met, speaking to them from afar."

	level = 2
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_SPEAK

	cooldown_length = 5 SECONDS
	// the guys we last talked to
	var/list/free_speakers

/datum/discipline_power/melpominee/phantom_speaker/activate()
	. = ..()
	if(!owner.mind.guestbook.known_names) // Who do we know
		to_chat(owner, span_warning("You don't seem to know anyone you can speak to right now...")) // You have no friends.
		return
	// Guys we add to the input below
	var/list/targets

	for(var/mob/living/character in GLOB.player_list)
		if(character == owner) // Skip ourselves
			continue
		if(owner.mind.guestbook.known_names[character.real_name] && character.client) // Everyone we know who has a client
			targets += character

	var/list/mob/living/listener_list
	var/mob/living/listener

	if(!HAS_TRAIT_FROM(owner, TRAIT_VIRTUOSA, type))
		listener = tgui_input_list(owner, "Who will you project your voice to?", "Phantom Speaker", targets)
		if(!listener)
			return
		listener_list[WEAKREF(listener)] = 0
	else // We can talk to mulitple people (Melpominee 5)
		listener_list = tgui_input_checkboxes(owner, "Who will you project your voice to?", "Phantom Speaker", targets)

	if(!length(listener_list)) // We didn't pick anyone
		return

	var/input_message = tgui_input_text(owner, "What message will you project to them?", title = "Phantom Speaker")
	if (!input_message)
		return

	//sanitisation!
	input_message = trim(copytext_char(sanitize(input_message), 1, MAX_MESSAGE_LEN))
	if(!owner.try_speak(input_message))
		return

	if(findtext(input_message, "*"))
		to_chat(owner, span_danger("You can't emote with [name]!"))
		return

	var/language = owner.get_selected_language()
	var/message = owner.compose_message(owner, language, input_message)
	// Composed message of all the people in listener_list
	var/those_who_hear = "[jointext(listener_list, ", ", 1, length(listener_list))], and [listener_list[length(listener_list)]]."

	// The roll itself; wits+perception against diff 7
	var/mob/living/caster = owner

	var/datum/storyteller_roll/phantom_speaker/roll_datum = new()
	var/roll_result = roll_datum.st_roll(caster)

	if(roll_result < ROLL_SUCCESS)
		to_chat(owner, span_notice("Your voice fails to reach the ears of [those_who_hear]"))
		return

	for(var/mob/living/guy in listener_list)
		if(guy in free_speakers)
			if(free_speakers[guy] > 0)
				free_speakers[guy] = free_speakers[guy]-1
			else
				free_speakers -= guy
		else
			free_speakers += guy
			free_speakers[guy] = roll_result

	if(!(listener_list ~= free_speakers)) // if we're talking to anybody new
		var/bp_to_use = (length(listener_list)-length(free_speakers))-6 // (The amount of people we're talking to - people we can talk to for free) - 6
		var/bp_used = max(1, bp_to_use) // How much BP we're actually using
		owner.adjust_blood_pool(bp_used)

	for(var/mob/living/final_listeners in listener_list)
		to_chat(final_listeners, span_boldannounce("<i>You hear a voice in your head...</i>"))
		final_listeners.Hear(owner, language, span_purple(message), message_mods = list(MODE_SING))

	to_chat(owner, span_notice("Your voice reaches the ears of [those_who_hear]"))

/**
 * ••• Madrigal - p453-454
 *
 * Music has the power to sway the listener, engendering specific emotions through artful lyrics, pounding crescendo,
 * or haunting melody. The Daughters of Cacophony can tap into music’s power, forcing listeners to feel whatever they wish. The emotion becomes so
 * powerful that the listener must act, though what a listener does isn’t something the Siren can directly control.
 *
 * The Daughter chooses an emotion and anyone who fails a Wits + Awareness check against her roll will begin to feel that emotion
 *
 */
/datum/discipline_power/melpominee/madrigal
	name = "Madrigal"
	desc = "Sing a siren song, swaying the emotions of all around you."

	level = 3
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_SPEAK

	cooldown_length = 1 SCENES
	duration_length = 1 SCENES
	var/list/audience = list()

/datum/discipline_power/melpominee/madrigal/activate()
	. = ..()
	var/our_power = SSroll.storyteller_roll(owner.st_get_stat(STAT_WITS) + owner.st_get_stat(STAT_PERFORMANCE), 7, owner, numerical = TRUE)
	var/emotion = tgui_input_list(owner, "What emotion do you wish to incite?", "Madrigal", GLOB.emotion_to_quality)

	for(var/mob/living/carbon/member in ohearers(7, owner))
		audience += member
		var/their_power = SSroll.storyteller_roll(member.st_get_stat(STAT_WITS) + member.st_get_stat(STAT_AWARENESS), 7, member, numerical = TRUE)
		if(our_power > their_power)
			set_emotion(member, emotion)

/datum/discipline_power/melpominee/madrigal/proc/set_emotion(mob/living/target, emotion)
	target.set_emotion(emotion)
	ADD_TRAIT(target, TRAIT_FORCED_EMOTION, type)

	to_chat(target, span_purple("You are overwhelmed with [GLOB.emotion_to_quality[emotion]]."))
	var/datum/status_effect/forced_emotion/emoji = target.apply_status_effect(/datum/status_effect/forced_emotion)
	emoji.linked_alert.desc = "Something in you is making you dwell on a sense of [GLOB.emotion_to_quality[emotion]]."

/datum/discipline_power/melpominee/madrigal/deactivate()
	. = ..()
	for(var/mob/living/carbon/member in audience)
		if(HAS_TRAIT_FROM(member, TRAIT_FORCED_EMOTION, type))
			to_chat(member, span_nicegreen("You are no longer overwhelmed with [GLOB.emotion_to_quality[member.current_emotion]]."))
			REMOVE_TRAIT(member, TRAIT_FORCED_EMOTION, type)
		else if(HAS_TRAIT(member, TRAIT_FORCED_EMOTION))
			to_chat(member, span_nicegreen("You feel your [GLOB.emotion_to_quality[member.current_emotion]] weakening."))
			REMOVE_TRAIT(member, TRAIT_FORCED_EMOTION, type)

	audience = list()

/**
 * •••• Siren's Beckoning  - p454
 *
 * The Daughters of Cacophony don’t spread madness as surely (or as visibly) as the Malkavians, but their songs are definitely
 * detrimental to one’s sanity. With this power, the Daughter can drive any listener to madness. Most of the time, the victim is
 * too fascinated to realize that he should leave the area and block out the music from his mind.
 *
 * The Daughter sings a haunting sound that causes the victim to remain and listen, provided they fail a willpower roll.
 *
 */
/datum/storyteller_roll/sirens_beckoning // Difficulty is the victim's willpower
	bumper_text = "Siren's Beckoning"
	applicable_stats = list(STAT_WITS, STAT_PERFORMANCE)
	numerical = TRUE
	roll_output_type = ROLL_PRIVATE_AND_TARGET
	spammy_roll = TRUE

/datum/storyteller_roll/sirens_beckoning/victim // Difficulty is the siren's Appearance + Performance
	applicable_stats = list(STAT_TEMPORARY_WILLPOWER)
	roll_output_type = ROLL_PRIVATE

/datum/discipline_power/melpominee/sirens_beckoning
	name = "Siren's Beckoning"
	desc = "Sing an unearthly song to stun those around you."

	level = 4
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_SPEAK

	effect_sound = 'modular_darkpack/modules/powers/sounds/melpominee/melpominee.ogg'
	range = 7
	duration_length = 4 TURNS
	cooldown_length = 1 MINUTES
	duration_override = TRUE
	target_type = TARGET_LIVING
	var/list/listener_list = list()
	var/list/listeners_failed = list()
	var/channeling = FALSE
	var/list/cumulative_list = list()
	var/list/cumulative_our_power = list()
	var/turns_left = 4

/datum/discipline_power/melpominee/sirens_beckoning/can_activate(atom/target)
	if(HAS_TRAIT(owner, TRAIT_VIRTUOSA))
		target_type = NONE
	else
		target_type = TARGET_LIVING

	. = ..()

/datum/discipline_power/melpominee/sirens_beckoning/activate(mob/living/target) // TODO: sliding difficulty for willpower
	. = ..()
	setup_particles()
	to_chat(owner, span_purple("You begin to sing a haunting melody."))

	owner.Stun(1 TURNS)
	channeling = TRUE

	if(!HAS_TRAIT(owner, TRAIT_VIRTUOSA))
		if(!target)
			return
	else
		if(!length(ohearers(owner, 7)))
			return

	run_effect(target)

/datum/discipline_power/melpominee/sirens_beckoning/proc/run_effect(mob/living/carbon/target)
	if(turns_left > 0)
		turns_left--
	else
		deactivate(target, TRUE)
		return FALSE
	playsound(owner, 'modular_darkpack/modules/powers/sounds/melpominee/melpominee.ogg', 50)

	if(!HAS_TRAIT(owner, TRAIT_VIRTUOSA))
		listener_list = list(target)
	else
		listener_list = ohearers(owner, 7)

	for(var/mob/living/carbon/listener in listener_list)
		var/our_power = SSroll.storyteller_roll_datum(owner, target, /datum/storyteller_roll/sirens_beckoning, 0, listener.st_get_stat(STAT_TEMPORARY_WILLPOWER))
		cumulative_our_power[listener] += our_power
		var/their_power = SSroll.storyteller_roll_datum(listener, owner, /datum/storyteller_roll/sirens_beckoning/victim, 0, owner.st_get_stat(STAT_APPEARANCE) + owner.st_get_stat(STAT_PERFORMANCE))
		cumulative_list[listener] += their_power
		if(our_power > their_power && should_run_effect(listener))
			effect(listener)
		else
			listener_list -= listener
			listener.remove_overlay(MUTATIONS_LAYER)
			cumulative_our_power[listener] = null
			cumulative_list[listener] = null

	if(do_after(owner, 1 TURNS, timed_action_flags = IGNORE_HELD_ITEM | IGNORE_INCAPACITATED | IGNORE_SLOWDOWNS) && channeling && length(listener_list))
		run_effect(target)
	else
		deactivate(target, TRUE)

/datum/discipline_power/melpominee/sirens_beckoning/proc/should_run_effect(mob/living/listener)
	if(!owner.can_speak())
		return FALSE
	return TRUE

/datum/discipline_power/melpominee/sirens_beckoning/proc/effect(mob/living/carbon/listener)
	listener.Stun(1 TURNS)
	listener.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/song_overlay = mutable_appearance('modular_darkpack/modules/deprecated/icons/icons.dmi', "song", -MUTATIONS_LAYER)
	listener.overlays_standing[MUTATIONS_LAYER] = song_overlay
	listener.apply_overlay(MUTATIONS_LAYER)
	if(cumulative_our_power[listener] >= 20)
		listener.add_quirk(/datum/quirk/darkpack/derangement)

	if(cumulative_list[listener] <= cumulative_our_power[listener]-6)
		if(listener.add_quirk(/datum/quirk/darkpack/derangement))
			addtimer(CALLBACK(src, PROC_REF(remove_derangement), listener), 1 SCENES)

/datum/discipline_power/melpominee/sirens_beckoning/proc/remove_derangement(mob/living/carbon/listener)
	listener.remove_quirk(/datum/quirk/darkpack/derangement)

/datum/discipline_power/melpominee/sirens_beckoning/deactivate(mob/living/carbon/target)
	. = ..()
	for(var/mob/living/carbon/listener in listener_list)
		listener.remove_overlay(MUTATIONS_LAYER)

	owner.visible_message(span_purple("[owner]'s haunting melody ceases."), span_purple("You stop singing."))
	channeling = FALSE
	QDEL_NULL(particle_generator)
	turns_left = 4

	// These can still be a source of hardels if they happen mid ability.
	// But it would need a bigger refactor so we only have to handle 1 weakref/1 list per guy to avoid nightmare code.
	listener_list = list()
	listeners_failed = list()
	cumulative_list = list()
	cumulative_our_power = list()

/**
 * ••••• Shattering Crescendo - p454
 *
 * Most of the low-level Melpominee powers can only be used on one target at a time.
 * When the Daughter reaches this level of mastery in her Discipline, she can "entertain” a
 * wider audience. Each member of the audience hears the same message.
 *
 * The Siren toggles the ability, augmenting the function of •• Phantom Speaker and •••• Siren's Beckoning
 *
 */
/datum/discipline_power/melpominee/virtuosa
	name = "Virtuosa"
	desc = "Augment your abilities, allowing some powers to be used on multiple people."

	level = 5
	toggled = TRUE
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_SPEAK

	vitae_cost = 0

/datum/discipline_power/melpominee/virtuosa/activate()
	. = ..()
	ADD_TRAIT(owner, TRAIT_VIRTUOSA, type)

/datum/discipline_power/melpominee/virtuosa/deactivate(atom/target, direct)
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_VIRTUOSA, type)

/**
 * ••••• • Shattering Crescendo - p454
 *
 * The Daughter can sing powerfully enough to rend flesh, split skin, and crack bone. While some Kindred unfortunate enough to witness
 * this power make reference to the fact that even mortal singers can shatter glass at the right frequency, others note that volume and
 * intensity don’t seem to matter when a Daughter employs Shattering Crescendo. The Siren can sing a soothing lullaby and still kill a target.
 *
 * The Siren selects a target and deals a high amount of damage in brute and to the target's ears.
 *
 */
/datum/discipline_power/melpominee/death_of_the_drum
	name = "Shattering Crescendo"
	desc = "Scream at an unnatural pitch, shattering the bodies of your enemies."

	level = 6
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_SPEAK
	target_type = TARGET_MOB

	effect_sound = null // Sound handled by activate

	range = 7
	duration_length = 1 TURNS
	cooldown_length = 3 TURNS

/datum/discipline_power/melpominee/death_of_the_drum/activate()
	. = ..()
	playsound(owner, 'modular_darkpack/modules/powers/sounds/melpominee/melpominee.ogg', 50)
	for(var/mob/living/carbon/human/listener in oviewers(DEFAULT_SIGHT_DISTANCE, owner))
		listener.Stun(1 TURNS)
		switch(listener.get_ear_protection(TRUE))
			if(0)
				listener.apply_damage(50, AGGRAVATED, BODY_ZONE_HEAD)
				listener.sound_damage(50, 3 TURNS)
			if(1)
				listener.apply_damage(25, AGGRAVATED, BODY_ZONE_HEAD)
				listener.sound_damage(25, 10 TURNS)
			if(2)
				listener.apply_damage(15, AGGRAVATED, BODY_ZONE_HEAD)


		listener.remove_overlay(MUTATIONS_LAYER)
		var/mutable_appearance/song_overlay = mutable_appearance('modular_darkpack/modules/deprecated/icons/icons.dmi', "song", -MUTATIONS_LAYER)
		listener.overlays_standing[MUTATIONS_LAYER] = song_overlay
		listener.apply_overlay(MUTATIONS_LAYER)

		addtimer(CALLBACK(src, PROC_REF(deactivate), listener), 1 TURNS)

/datum/discipline_power/melpominee/death_of_the_drum/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)
