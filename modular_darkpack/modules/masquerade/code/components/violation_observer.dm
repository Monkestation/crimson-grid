/atom/movable
	var/violation_observer = FALSE
	COOLDOWN_DECLARE(masquerade_violation_cooldown)

/atom/movable/proc/toggle_masquerade_sensitivity(new_listening_state)
	// don't proceed if we're toggling to TRUE on something already listening
	if(!isnull(new_listening_state) && new_listening_state == violation_observer)
		return

	// if we don't pass an arg just flip the switch
	if(isnull(new_listening_state))
		violation_observer = !violation_observer
	else
		violation_observer = new_listening_state

	if(violation_observer)
		RegisterSignal(src, COMSIG_SEEN_MASQUERADE_VIOLATION, PROC_REF(on_observed_violation))
		RegisterSignal(src, COMSIG_MASQUERADE_REINFORCE, PROC_REF(on_masquerade_violation_reinforced))
		RegisterSignals(src, list(COMSIG_LIVING_DEATH, COMSIG_ALL_MASQUERADE_REINFORCE), PROC_REF(on_masquerade_witness_death))
	else
		UnregisterSignal(src, list(COMSIG_SEEN_MASQUERADE_VIOLATION, COMSIG_MASQUERADE_REINFORCE, COMSIG_LIVING_DEATH, COMSIG_ALL_MASQUERADE_REINFORCE))

/atom/movable/proc/on_masquerade_violation()
	if(!COOLDOWN_FINISHED(src, masquerade_violation_cooldown))
		return
	var/area/vtm/breacher_area = get_area(src)
	if(!istype(breacher_area, /area/vtm))
		return
	if(breacher_area.zone_type != ZONE_MASQUERADE)
		return
	for(var/atom/movable/moving_atom in view(7, loc))
		if(!moving_atom.violation_observer)
			continue
		SEND_SIGNAL(moving_atom, COMSIG_SEEN_MASQUERADE_VIOLATION, src)
	COOLDOWN_START(src, masquerade_violation_cooldown, 1 TURNS)

/atom/movable/proc/on_observed_violation(atom/source, atom/movable/player_breacher)
	SIGNAL_HANDLER

	if(!source || !player_breacher || ismundane(player_breacher)) //Humans cant break the masquerade. Because reasons.
		return

	if(isliving(source))
		var/mob/living/mob_parent = source
		if(mob_parent.stat == DEAD)
			return
		if(!INCAPACITATED_IGNORING(mob_parent, INCAPABLE_RESTRAINTS))
			mob_parent.face_atom(player_breacher)
	source.observe_masquerade_violation(player_breacher)

	var/mutable_appearance/alert = mutable_appearance('icons/obj/storage/closet.dmi', "cardboard_special")
	SET_PLANE_EXPLICIT(alert, ABOVE_LIGHTING_PLANE, source)
	var/atom/movable/flick_visual/exclamation = source.flick_overlay_view(alert, 1 SECONDS)
	exclamation.alpha = 0
	exclamation.pixel_x = -source.pixel_x
	animate(exclamation, pixel_z = 32, alpha = 255, time = 0.5 SECONDS, easing = ELASTIC_EASING)

	source.AddComponent(/datum/component/masquerade_hud, player_breacher)
	SSmasquerade.masquerade_breach(source, player_breacher, (isliving(source) ? MASQUERADE_REASON_NPC : MASQUERADE_REASON_OBJECT))
	RegisterSignal(player_breacher, COMSIG_LIVING_DEATH, PROC_REF(on_breacher_death), override = TRUE) // override is for breaching multiple times on the same violation observer - on_breacher_death handles all violations, not just the breach created here, so we only need one register

	return TRUE

/atom/movable/proc/on_masquerade_violation_reinforced(atom/source, atom/movable/player_breacher)
	SIGNAL_HANDLER

	for(var/breach in SSmasquerade.masquerade_breachers)
		if(breach[1] != player_breacher)
			continue
		if(breach[2] != src)
			continue
		SEND_SIGNAL(src, COMSIG_MASQUERADE_HUD_DELETE, player_breacher)
		SSmasquerade.masquerade_reinforce(src, player_breacher)
		src.observe_masquerade_reinforce(player_breacher)
		UnregisterSignal(player_breacher, COMSIG_LIVING_DEATH)

		return TRUE

/atom/movable/proc/on_masquerade_witness_death()
	SIGNAL_HANDLER

	for(var/breach in SSmasquerade.masquerade_breachers)
		var/mob/living/player_breacher = breach[1]
		var/atom/breach_witness = breach[2]
		if(breach_witness != src)
			continue
		SEND_SIGNAL(src, COMSIG_MASQUERADE_HUD_DELETE, player_breacher)
		SSmasquerade.masquerade_reinforce(src, player_breacher)
		observe_masquerade_reinforce(player_breacher)
		UnregisterSignal(player_breacher, COMSIG_LIVING_DEATH)

/atom/movable/proc/on_breacher_death(mob/living/dead_breacher, gibbed)
	SIGNAL_HANDLER

	for(var/breach in SSmasquerade.masquerade_breachers)
		if(breach[1] != dead_breacher)
			continue
		SEND_SIGNAL(src, COMSIG_MASQUERADE_HUD_DELETE, dead_breacher)
		SSmasquerade.masquerade_reinforce(src, dead_breacher)
		observe_masquerade_reinforce(dead_breacher)
		UnregisterSignal(dead_breacher, COMSIG_LIVING_DEATH)

/atom/proc/observe_masquerade_violation(player_breacher)
	do_alert_animation()
	if(get_werewolf_splat(player_breacher))
		to_chat(player_breacher, span_userdanger(span_bold("VEIL VIOLATION")))
		playsound(player_breacher, 'modular_darkpack/modules/masquerade/sound/veil_violation.ogg', 50, FALSE, -5)
		return
	playsound(player_breacher, 'modular_darkpack/modules/masquerade/sound/masquerade_violation.ogg', 50, FALSE, -5)
	to_chat(player_breacher, span_userdanger(span_bold("MASQUERADE VIOLATION")))

/atom/proc/observe_masquerade_reinforce(player_breacher)
	if(get_werewolf_splat(player_breacher))
		to_chat(player_breacher, span_big(span_boldnicegreen("VEIL REINFORCED")))
		playsound(player_breacher, 'modular_darkpack/modules/masquerade/sound/humanity_gain.ogg', 50, FALSE, -5)
		return
	to_chat(player_breacher, span_big(span_boldnicegreen("MASQUERADE REINFORCED")))
	playsound(player_breacher, 'modular_darkpack/modules/masquerade/sound/masquerade_reinforce.ogg', 50, FALSE, -5)
