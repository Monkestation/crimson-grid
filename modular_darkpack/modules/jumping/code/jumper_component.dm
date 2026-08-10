#define JUMP_DELAY 40
#define JUMP_WINDUP 12
#define JUMP_SLOWDOWN_MULT 1.6 // 1.5 means a jumping character and a walking character will keep pace. Increase to slow jumpers further.
#define BASE_JUMP_DISTANCE 1
#define MAX_JUMP_DISTANCE 6

/datum/component/jumper
	COOLDOWN_DECLARE(jump_cooldown)
	var/prepared_to_jump = FALSE

/datum/component/jumper/Initialize()
	. = ..()
	if(!isliving(parent))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_MOB_CLICKON, PROC_REF(try_jump))
	RegisterSignal(parent, COMSIG_LIVING_JUMP_PREP_TOGGLE, PROC_REF(toggle_jumping))

//Toggles whether a left click will perform a jump.
//We have this functionality so players without a 3rd mouse button can still jump around.
/datum/component/jumper/proc/toggle_jumping(datum/source)
	SIGNAL_HANDLER
	prepared_to_jump = !prepared_to_jump

	if(prepared_to_jump)
		to_chat(source, span_notice("You prepare to jump."))
	else
		to_chat(source, span_notice("You are not prepared to jump anymore."))


//Ensures that a jump can actually be performed
/datum/component/jumper/proc/try_jump(mob/living/jumper, atom/target, list/modifiers)
	SIGNAL_HANDLER
	//only process if the clicker used left click if prepared, or middle click
	if(!(prepared_to_jump && LAZYACCESS(modifiers, LEFT_CLICK)) && !LAZYACCESS(modifiers, MIDDLE_CLICK))
		return

	//only process if shift, ctrl, and alt are NOT being held
	if(LAZYACCESS(modifiers, CTRL_CLICK) || LAZYACCESS(modifiers, SHIFT_CLICK) || LAZYACCESS(modifiers, ALT_CLICK))
		return

	if(jumper.stat >= UNCONSCIOUS)
		return

	if(jumper.pulledby && jumper.pulledby.grab_state != GRAB_PASSIVE)
		return

	if(HAS_TRAIT(jumper, TRAIT_IMMOBILIZED))
		return

	if(HAS_TRAIT(jumper, TRAIT_INCAPACITATED))
		return

	if(HAS_TRAIT(jumper, TRAIT_RESTRAINED))
		return

	if(HAS_TRAIT(jumper, TRAIT_FLOORED))
		return

	if(jumper.body_position == LYING_DOWN)
		return

	if(jumper.buckled)
		return

	if(!(jumper.mobility_flags & MOBILITY_MOVE))
		return

	if(!target || !isturf(jumper.loc))
		return

	if(istype(target, /atom/movable/screen))
		return

	if(get_turf(jumper) == get_turf(target)) // We can't jump on ourselves
		return

	if(!COOLDOWN_FINISHED(src, jump_cooldown))
		to_chat(jumper, span_notice("You can't jump so soon!"))
		return

	INVOKE_ASYNC(src, PROC_REF(jump), jumper, target)
	return COMSIG_MOB_CANCEL_CLICKON

/datum/config_entry/flag/jump_windup // Config datum

/datum/config_entry/flag/jump_slowdown // Config datum

/mob/living/proc/post_jump_slowdown(duration)
	if(duration < 1)
		duration = 1

	add_movespeed_modifier(/datum/movespeed_modifier/post_jump)
	addtimer(CALLBACK(src, PROC_REF(remove_movespeed_modifier), /datum/movespeed_modifier/post_jump), duration)

/datum/movespeed_modifier/post_jump
	multiplicative_slowdown = 2
	flags = IGNORE_NOSLOW

//Actually executes the jump
/datum/component/jumper/proc/jump(mob/living/jumper, atom/target)
	var/strength = jumper.st_get_stat(STAT_STRENGTH)
	var/dexterity = jumper.st_get_stat(STAT_DEXTERITY)
	var/athletics = jumper.st_get_stat(STAT_ATHLETICS)

	if(CONFIG_GET(flag/jump_windup))
		if(!do_after(jumper, JUMP_WINDUP - athletics, interaction_key = DOAFTER_SOURCE_JUMP))
			return

	var/adjusted_jump_range = clamp((BASE_JUMP_DISTANCE + 0.75 + max(0,(strength -1)) * 0.5 + athletics), 1, 6)

	var/distance = get_dist(jumper.loc, target)
	var/turf/adjusted_target = target
	if(distance > adjusted_jump_range)
		var/dx = target.x - jumper.loc.x
		var/dy = target.y - jumper.loc.y
		var/scale = adjusted_jump_range / distance
		adjusted_target = locate(jumper.loc.x + round(dx * scale), jumper.loc.y + round(dy * scale), jumper.loc.z)

	playsound(jumper.loc, 'modular_darkpack/modules/jumping/sounds/jump_neutral.ogg', 50, TRUE)

	if(jumper.combat_mode && get_dist(jumper.loc, target) <= 3 && strength >= 8)
		addtimer(CALLBACK(src, PROC_REF(jump_boom), jumper),(distance * 0.5))
		jumper.visible_message(span_danger("[jumper] takes a mighty leap that shatters \the [adjusted_target] where they land!"))
		jumper.adjust_stamina_loss(20)
	else
		jumper.adjust_stamina_loss(10)
		jumper.visible_message(span_danger("[jumper] jumps towards [adjusted_target]."))

	var/turf/start_T = get_turf(jumper.loc) //Get the start and target tile for the descriptors
	var/turf/end_T = get_turf(adjusted_target)
	if(start_T && end_T)
		log_combat(jumper, adjusted_target, "jumped", addition="from tile in [AREACOORD(start_T)] towards tile at [AREACOORD(end_T)]")

	jumper.newtonian_move(get_dir(adjusted_target, jumper))
	jumper.safe_throw_at(adjusted_target, jumper.throw_range, jumper.throw_speed, jumper, null, null, null, jumper.move_force, spin = FALSE)

	if(CONFIG_GET(flag/jump_slowdown))
		jumper.post_jump_slowdown(get_dist(start_T, end_T)*JUMP_SLOWDOWN_MULT)

	COOLDOWN_START(src, jump_cooldown, max(JUMP_DELAY - (0.4 * dexterity) - (1 * athletics), 1))

	if(CONFIG_GET(flag/jump_slowdown))
		jumper.add_movespeed_modifier(/datum/movespeed_modifier/post_jump)
		spawn(get_dist(start_T, end_T)*JUMP_SLOWDOWN_MULT)
			jumper.remove_movespeed_modifier(/datum/movespeed_modifier/post_jump)

//Produces a boom effect for ludicrously high strength/physique scores
/datum/component/jumper/proc/jump_boom(mob/living/jumper)
	playsound(get_turf(jumper), 'modular_darkpack/modules/jumping/sounds/jump_slam.ogg', 40, FALSE)
	new /obj/effect/temp_visual/dir_setting/crack_effect(get_turf(jumper))
	for(var/mob/living/shaken_person in range(5, jumper))
		if(shaken_person == jumper)
			continue
		shaken_person.Stun(20)
		var/distance = get_dist(shaken_person, jumper)
		shake_camera(shaken_person, max(6-distance), max(4-distance, 1))
	jumper.Stun(10)
	shake_camera(jumper, 4, 3)

	SEND_SIGNAL(jumper, COMSIG_MASQUERADE_VIOLATION)


#undef JUMP_DELAY
#undef JUMP_SLOWDOWN_MULT
#undef JUMP_WINDUP
#undef BASE_JUMP_DISTANCE
#undef MAX_JUMP_DISTANCE
