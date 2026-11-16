/obj/effect/looping_sound_emitter
	name = "sound emitter"
	desc = "Emits sounds, presumably."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield2"
	invisibility = INVISIBILITY_OBSERVER
	anchored = TRUE
	density = FALSE
	opacity = FALSE
	alpha = 175
	var/datum/looping_sound/main_looping_sound
	var/sound_type

/obj/effect/looping_sound_emitter/Initialize(mapload)
	. = ..()
	if(sound_type)
		main_looping_sound = new sound_type(src, TRUE)

/obj/effect/looping_sound_emitter/Destroy(force)
	. = ..()
	QDEL_NULL(main_looping_sound)
