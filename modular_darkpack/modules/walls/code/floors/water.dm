/turf/open/water/river
	name = "river"
	icon = 'modular_darkpack/modules/walls/icons/floors.dmi'
	icon_state = "ocean"
	baseturfs = /turf/open/water/river

/turf/open/water/beach/vamp
	name = "ocean"
	icon = 'modular_darkpack/modules/walls/icons/floors.dmi'
	icon_state = "ocean"
	baseturfs = /turf/open/water/beach/vamp

/turf/open/water/beach/vamp/deep
	name = "deep water"
	desc = "Don't forget your life jacket."
	immerse_overlay = "immerse_deep"
	baseturfs = /turf/open/water/beach/vamp/deep
	is_swimming_tile = TRUE
	color = "#979797"

//Make a pr to TG eventually adding acid from shiptest mabye.
/turf/open/water/acid
	name = "goop"
	icon = 'modular_darkpack/modules/walls/icons/floors.dmi'
	icon_state = "acid"
	light_color = "#1b7c4c"
	light_range = 1
	light_power = 0.5
	baseturfs = /turf/open/water/acid

/turf/open/water/acid/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	if(acid_burn(arrived))
		START_PROCESSING(SSobj, src)

/turf/open/water/acid/proc/acid_burn(mob/living/burnt_mob)
	if(istype(burnt_mob))
		if(!HAS_TRAIT(burnt_mob, TRAIT_IMMERSED))
			return TRUE // We still want to keep processing incase something changes
		if(burnt_mob.movement_type & FLYING)
			return TRUE
		burnt_mob.apply_damage(1 TTRPG_DAMAGE, AGGRAVATED)
		burnt_mob.apply_damage(2 TTRPG_DAMAGE, TOX)
		to_chat(burnt_mob, span_warning("Your flesh burns!"))
		return TRUE

/turf/open/water/acid/process(seconds_per_tick)
	if(!(locate(/mob/living) in contents))
		return PROCESS_KILL
	for(var/mob/living/burnt_guy in contents)
		acid_burn(burnt_guy)

//Code mostly taken from /obj/crystal_mass
/turf/open/water/bloodwave
	gender = PLURAL
	name = "blood"
	icon = 'modular_darkpack/modules/walls/icons/floors.dmi'
	icon_state = "blood"
	light_color = COLOR_MAROON
	light_range = 1
	light_power = 0.5
	baseturfs = /turf/open/water/bloodwave
	immerse_overlay = "immerse_deep"
	is_swimming_tile = TRUE
	///All dirs we can expand to
	var/list/available_dirs = list(NORTH,SOUTH,EAST,WEST,DOWN)
	///Cooldown on the expansion process
	COOLDOWN_DECLARE(wave_cooldown)

/turf/open/water/bloodwave/Initialize(mapload, dir_to_remove)
	. = ..()
	if(mapload)
		return
	START_PROCESSING(SSsupermatter_cascade, src)
	available_dirs -= dir_to_remove

/turf/open/water/bloodwave/proc/start_flood()
	SSsupermatter_cascade.can_fire = TRUE
	SSsupermatter_cascade.cascade_initiated = TRUE

/turf/open/water/bloodwave/process()

	if(!COOLDOWN_FINISHED(src, wave_cooldown))
		return

	if(!available_dirs || available_dirs.len <= 0)
		return PROCESS_KILL

	COOLDOWN_START(src, wave_cooldown, rand(0, 2 SECONDS))

	var/picked_dir = pick_n_take(available_dirs)
	var/turf/next_turf = get_step_multiz(src, picked_dir)

	if(!next_turf || locate(/turf/open/water/bloodwave) in next_turf)
		return

	for(var/atom/movable/checked_atom as anything in next_turf)
		if(isliving(checked_atom))
			var/mob/living/checked_mob = checked_atom
			checked_mob.death()
		//else if(isitem(checked_atom))
		//	qdel(checked_atom)

	new /turf/open/water/bloodwave(next_turf, get_dir(next_turf, src))
