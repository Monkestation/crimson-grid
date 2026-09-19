/obj/effect/client_image_holder/baali_demon
	name = "infernal demon"
	image_icon = 'modular_darkpack/modules/deprecated/icons/32x48.dmi'
	image_state = "baali"
	var/mob/living/target //person who had daimoinon 4 used on them
	COOLDOWN_DECLARE(move_cooldown)

/obj/effect/client_image_holder/baali_demon/Initialize(mapload, list/mobs_which_see_us)
	. = ..()
	for(var/mob/living/possible_target as anything in mobs_which_see_us)
		target = possible_target
		break // daimoinon only has a demon chasing after one target at a time but parent init asks for a list.
	var/turf/closed/wall = locate(/turf/closed) in range(7, target)
	if(!wall)
		return INITIALIZE_HINT_QDEL
	forceMove(wall)
	target.playsound_local(wall, 'sound/effects/meteorimpact.ogg', 150, TRUE)
	RegisterSignal(src, COMSIG_BAALI_DEMON_REACHED_TARGET, PROC_REF(on_reached_target))
	START_PROCESSING(SSfastprocess, src)

/obj/effect/client_image_holder/baali_demon/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	target = null
	return ..()

/obj/effect/client_image_holder/baali_demon/process(seconds_per_tick)
	if(QDELETED(target) || target.stat == DEAD)
		qdel(src)
		return
	if(!COOLDOWN_FINISHED(src, move_cooldown))
		return
	setDir(get_dir(src, target))
	forceMove(get_step_towards(src, target))
	target.playsound_local(get_turf(src), 'sound/effects/meteorimpact.ogg', 150, TRUE)
	if(Adjacent(target))
		SEND_SIGNAL(src, COMSIG_BAALI_DEMON_REACHED_TARGET, target)
		qdel(src)
	COOLDOWN_START(src, move_cooldown, 0.4 SECONDS)

/obj/effect/client_image_holder/baali_demon/proc/on_reached_target(datum/source, mob/living/victim)
	SIGNAL_HANDLER
	on_contact(victim)
	step_away(victim, get_turf(src))

/obj/effect/client_image_holder/baali_demon/spectre
	name = "specter"
	image_icon = 'modular_darkpack/modules/deprecated/icons/mob.dmi'
	image_state = "shade"

/obj/effect/client_image_holder/baali_demon/wyrm
	name = "wyrmic avatar"
	image_icon = 'modular_darkpack/modules/deprecated/icons/48x64.dmi'
	image_state = "bigskeleton"

/obj/effect/client_image_holder/baali_demon/tremere
	name = "RECLAIMER"
	image_icon = 'modular_darkpack/modules/deprecated/icons/48x64.dmi'
	image_state = "4armstzi"

/obj/effect/client_image_holder/baali_demon/banu
	name = "LOREMASTER"
	image_icon = 'modular_darkpack/modules/antediluvian_sarcophagus/icons/the_antediluvian.dmi'
	image_state = "eva"

/obj/effect/client_image_holder/baali_demon/proc/on_contact(mob/living/victim)
	victim.visible_message(span_warning("[victim] falls on their knees"), span_warning("[src.name] grasps your head with its hands"))
	// CRIMSON GRID ADD: DARK THAUMATURGY
	victim.Immobilize(3 SECONDS)
	if(victim.body_position == STANDING_UP)
		victim.toggle_resting()
	// CRIMSON GRID ADD END: DARK THAUMATURGY
	victim.playsound_local(src, 'modular_darkpack/modules/powers/sounds/daimonion_laughs/demonlaugh1.ogg', 50, FALSE)
	to_chat(victim, span_cult("HELL IS REAL, IT HAS TOUCHED ME"))

/obj/effect/client_image_holder/baali_demon/spectre/on_contact(mob/living/victim)
	victim.visible_message(span_warning("[victim] collapses onto the ground"), span_warning("[src.name] touches you with an outstretched hand"))
	// CRIMSON GRID ADD: DARK THAUMATURGY
	victim.Immobilize(3 SECONDS)
	if(victim.body_position == STANDING_UP)
		victim.toggle_resting()
	// CRIMSON GRID ADD END: DARK THAUMATURGY
	to_chat(victim, span_cult("THE SPIRIT HAS TAKEN SOMETHING FROM ME"))

/obj/effect/client_image_holder/baali_demon/wyrm/on_contact(mob/living/victim)
	victim.visible_message(span_warning("[victim] whines in animalistic fear"), span_cult("THE WYRM HAS NOTICED ME"))
	// CRIMSON GRID ADD: DARK THAUMATURGY
	victim.Immobilize(3 SECONDS)
	if(victim.body_position == STANDING_UP)
		victim.toggle_resting()
	// CRIMSON GRID ADD END: DARK THAUMATURGY
	victim.playsound_local(src, 'modular_darkpack/modules/powers/sounds/daimonion_laughs/malklaugh.ogg', 50, FALSE)

/obj/effect/client_image_holder/baali_demon/banu/on_contact(mob/living/victim)
	victim.visible_message(span_warning("[victim] grasps their chest, feeling for a hole"), span_cult("THE [src.name] PLUCKS OUT YOUR HEART"))
	// CRIMSON GRID ADD: DARK THAUMATURGY
	victim.Immobilize(3 SECONDS)
	if(victim.body_position == STANDING_UP)
		victim.toggle_resting()
	// CRIMSON GRID ADD END: DARK THAUMATURGY

/obj/effect/client_image_holder/baali_demon/tremere/on_contact(mob/living/victim)
	victim.visible_message(span_warning("[victim] collapses onto the ground, convulsing"), span_cult("THE [src.name] TAKES YOUR VITAE"))
	victim.playsound_local(src, 'modular_darkpack/modules/powers/sounds/daimonion_laughs/malklaugh.ogg', 50, FALSE)
	// CRIMSON GRID ADD: DARK THAUMATURGY
	victim.Immobilize(3 SECONDS)
	if(victim.body_position == STANDING_UP)
		victim.toggle_resting()
	// CRIMSON GRID ADD END: DARK THAUMATURGY
