// Used for things that detect masquerade violations.
// Usually NPCs or cameras.
/datum/component/violation_observer
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/datum/proximity_monitor/advanced/violation_check_aoe/area_of_effect
	/// Time between us checking for violations
	COOLDOWN_DECLARE(scan_cooldown)
	var/list/breached_players

/datum/component/violation_observer/Initialize(add_area_of_effect) //Only add the AOE checker for NPCs and camera objects.
	if(add_area_of_effect)
		area_of_effect = new(parent, 7, TRUE, src)
	breached_players = new()

/datum/component/violation_observer/RegisterWithParent()
	RegisterSignal(parent, COMSIG_SEEN_MASQUERADE_VIOLATION, PROC_REF(on_observed_violation))
	RegisterSignal(parent, COMSIG_MASQUERADE_REINFORCE, PROC_REF(on_masquerade_violation_reinforced))
	RegisterSignals(parent, list(COMSIG_LIVING_DEATH, COMSIG_ALL_MASQUERADE_REINFORCE), PROC_REF(on_death))

/datum/component/violation_observer/UnregisterFromParent(force, silent)
	QDEL_NULL(area_of_effect)
	breached_players = null
	UnregisterSignal(parent, list(COMSIG_SEEN_MASQUERADE_VIOLATION, COMSIG_MASQUERADE_REINFORCE, COMSIG_LIVING_DEATH, COMSIG_ALL_MASQUERADE_REINFORCE))

/datum/component/violation_observer/proc/toggle_area_of_effect(origin = parent)
	if(area_of_effect)
		QDEL_NULL(area_of_effect)
	else
		area_of_effect = new(origin, 7, TRUE, src)

/datum/component/violation_observer/proc/on_observed_violation(atom/source, mob/living/player_breacher)
	SIGNAL_HANDLER

	if(!source || !player_breacher || ismundane(player_breacher)) //Humans cant break the masquerade. Because reasons.
		return

	if(isliving(source))
		var/mob/living/mob_parent = source
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
	breached_players += player_breacher
	SSmasquerade.masquerade_breach(source, player_breacher, (isliving(source) ? MASQUERADE_REASON_NPC : MASQUERADE_REASON_OBJECT))
	RegisterSignal(player_breacher, COMSIG_LIVING_DEATH, PROC_REF(on_breacher_death))

	return TRUE

/datum/component/violation_observer/proc/on_masquerade_violation_reinforced(atom/source, mob/living/player_breacher)
	SIGNAL_HANDLER

	if(player_breacher in breached_players)
		SEND_SIGNAL(source, COMSIG_MASQUERADE_HUD_DELETE, player_breacher)
		SSmasquerade.masquerade_reinforce(source, player_breacher)
		source.observe_masquerade_reinforce(player_breacher)
		breached_players -= player_breacher
		UnregisterSignal(player_breacher, COMSIG_LIVING_DEATH)

		return TRUE

/datum/component/violation_observer/proc/on_death(atom/source)
	SIGNAL_HANDLER

	for(var/mob/player_breacher in breached_players)
		if(!QDELETED(player_breacher))
			SEND_SIGNAL(source, COMSIG_MASQUERADE_HUD_DELETE, player_breacher)
			SSmasquerade.masquerade_reinforce(source, player_breacher)
			source.observe_masquerade_reinforce(player_breacher)
			breached_players -= player_breacher

/datum/component/violation_observer/proc/on_breacher_death(mob/living/dead_breacher, gibbed)
	SIGNAL_HANDLER

	if(dead_breacher in breached_players)
		var/atom/parent_atom = parent
		SEND_SIGNAL(parent, COMSIG_MASQUERADE_HUD_DELETE, dead_breacher)
		SSmasquerade.masquerade_reinforce(parent, dead_breacher)
		parent_atom.observe_masquerade_reinforce(dead_breacher)
		breached_players -= dead_breacher
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
