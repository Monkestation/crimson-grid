/datum/possession_controller
	var/datum/weakref/vampire_original
	var/datum/weakref/mortal_body
	var/datum/weakref/mortal_observer
	var/possession_active = FALSE

/datum/possession_controller/New(mob/living/carbon/human/vampire, mob/living/carbon/human/mortal)
	vampire_original = WEAKREF(vampire)
	mortal_body = WEAKREF(mortal)
	start_possession()

/datum/possession_controller/proc/start_possession()
	var/mob/living/carbon/human/vamp = vampire_original?.resolve()
	var/mob/living/carbon/human/mortal = mortal_body?.resolve()

	var/mob/living/possession_observer/observer = new(mortal, src)
	mortal_observer = WEAKREF(observer)
	observer.ckey = mortal.ckey
	observer.name = mortal.real_name
	observer.real_name = mortal.real_name
	if(mortal.mind)
		observer.mind = mortal.mind

	mortal.ckey = vamp.ckey
	mortal.mind = vamp.mind

	var/datum/action/end_possession/end_action = new(src)
	end_action.Grant(mortal)

	vamp.toggle_resting()
	vamp.visible_message(span_warning("[vamp]'s eyes roll back and they collapse into a catatonic state!"))
	possession_active = TRUE
	RegisterSignal(mortal, COMSIG_LIVING_DEATH, PROC_REF(handle_death_during_possession))

/datum/possession_controller/proc/end_possession()
	var/mob/living/carbon/human/vamp = vampire_original?.resolve()
	var/mob/living/carbon/human/mortal = mortal_body?.resolve()

	if(mortal.stat == DEAD)
		handle_death_during_possession()
		return

	to_chat(vamp, span_warning("You withdraw from [mortal.real_name]'s mind and return to your own body."))

	vamp.ckey = mortal.ckey
	if(mortal.mind)
		vamp.mind = mortal.mind

	var/mob/living/possession_observer/observer = mortal_observer?.resolve()
	if(observer?.ckey)
		mortal.ckey = observer.ckey
		if(observer.mind)
			mortal.mind = observer.mind
		to_chat(mortal, span_notice("Your consciousness returns to your own body as the foreign presence withdraws."))
	log_combat(vamp, mortal, "Has ended their Possession ")
	mortal.possessed = FALSE
	cleanup()
	UnregisterSignal(mortal, COMSIG_LIVING_DEATH)

/datum/possession_controller/proc/handle_death_during_possession()
	SIGNAL_HANDLER
	var/mob/living/carbon/human/vamp = vampire_original?.resolve()
	var/mob/living/carbon/human/mortal = mortal_body?.resolve()
	var/mob/living/possession_observer/observer = mortal_observer?.resolve()

	to_chat(vamp, span_boldwarning("The death of your host body violently ejects you from their mind!"))
	vamp.ckey = mortal.ckey
	if(mortal.mind)
		vamp.mind = mortal.mind

	vamp.adjust_brute_loss(50)
	vamp.visible_message(span_danger("[vamp] suddenly convulses violently and falls into what appears to be a coma!"))
	to_chat(vamp, span_boldwarning("The psychic shock of your host's death sends you into torpor!"))
	vamp.torpor(DAMAGE_TRAIT)

	if(observer)
		to_chat(observer, span_boldwarning("Your body has died while you were displaced from it. You fade into oblivion..."))
		observer.ghostize()

	cleanup()

/datum/possession_controller/proc/cleanup()
	var/mob/living/carbon/human/vamp = vampire_original?.resolve()
	var/mob/living/carbon/human/mortal = mortal_body?.resolve()
	var/mob/living/possession_observer/observer = mortal_observer?.resolve()
	possession_active = FALSE
	if(vamp)
		for(var/datum/action/end_possession/action in vamp.actions)
			action.controller = null
			action.Remove(action.owner)
			qdel(action)
	if(mortal)
		UnregisterSignal(mortal, COMSIG_LIVING_DEATH)
		for(var/datum/action/end_possession/action in mortal.actions)
			action.controller = null
			action.Remove(action.owner)
			qdel(action)
	if(observer)
		observer.controller = null
		qdel(observer)
	qdel(src)

/mob/living/possession_observer
	name = "displaced consciousness"
	real_name = "displaced consciousness"
	var/datum/weakref/possessed_body
	var/datum/weakref/controller

/mob/living/possession_observer/Initialize(mapload, datum/possession_controller/possessor)
	if(iscarbon(loc))
		possessed_body = WEAKREF(loc)
		controller = WEAKREF(possessor)
	return ..()

/mob/living/possession_observer/Login()
	. = ..()
	if(!. || !client)
		return FALSE
	to_chat(src, span_warning("Your consciousness has been displaced from your body by a supernatural force. You can only observe as another mind controls your physical form."))
	to_chat(src, span_notice("You are helpless to act, but can still observe and think. Pray that the intruder releases control soon..."))

/mob/living/possession_observer/say(message,bubble_type,list/spans = list(),sanitize = TRUE,datum/language/language,ignore_spam = FALSE,forced,filterproof = FALSE,message_range = 7,datum/saymode/saymode,list/message_mods = list())
	to_chat(src, span_warning("You have no voice while displaced from your body!"))
	return FALSE

/mob/living/possession_observer/emote(act, m_type = null, message = null, intentional = FALSE)
	to_chat(src, span_warning("You cannot express yourself while displaced from your body!"))
	return FALSE

/datum/action/end_possession
	name = "End Possession"
	desc = "Release control of the possessed body and return to your own."
	button_icon_state = "possession_end"
	check_flags = NONE
	var/datum/weakref/controller

/datum/action/end_possession/New(datum/possession_controller/possessor)
	controller = WEAKREF(possessor)
	..()

/datum/action/end_possession/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return

	var/datum/possession_controller/possessor = controller?.resolve()
	if(!possessor)
		Remove(owner)
		qdel(src)
		return FALSE
	possessor.end_possession()
