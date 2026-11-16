/* • Faerie Light - W20 p.178-179
 *
 *  The Fianna conjures a small, bobbing sphere of light. It’s no brighter than a torch,
 * but that’s usually enough to light the werewolf’s way — or lead foes into an ambush.
 * A marsh-spirit teaches this Gift.
 *
 * Roll Wits + Occult (PLACEHOLDER FOR Wits + Enigmas). On success, summon a light on the turf clicked on. If clicked on a mob,
 * the light orbits the mob. When clicked on by the summoner, it orbits or de-orbits them. When clicked on by another, the light is dispelled.
 * Lasts for 1 scene.
 *
*/

/obj/effect/faerie_light // TODO: add an animate or something to make this gently bob up and down
	name = "orb of light"
	desc = "Happy to light your way."
	icon = 'icons/obj/lighting.dmi' // TODO: or maybe a new icon that has that baked in?
	icon_state = "orb"
	light_system = OVERLAY_LIGHT
	light_range = 4
	light_power = 1.3
	light_color = "#79f1ff"
	light_flags = LIGHT_ATTACHED
	layer = ABOVE_ALL_MOB_LAYER
	plane = ABOVE_GAME_PLANE
	var/mob/living/summoner

/obj/effect/faerie_light/Initialize(mapload)
	. = ..()
	register_context()

/obj/effect/faerie_light/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	. = ..()
	if(user == summoner)
		context[SCREENTIP_CONTEXT_LMB] =  "[orbit_target ? "Dismiss" : "Beckon"]"
	else
		context[SCREENTIP_CONTEXT_LMB] =  "Dispel"

	context[SCREENTIP_CONTEXT_RMB] =  "Dispel"

	return CONTEXTUAL_SCREENTIP_SET

/obj/effect/faerie_light/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(user != summoner)
		to_chat(user, span_purple("You [ishuman(user) ? "wave your hand at" : "paw at"] [src], causing it to float away and disappear."))
		animate(src, 1 SECONDS, alpha = 0)
		QDEL_IN(src, 1.1 SECONDS)
		return TRUE
	else if(orbit_target)
		to_chat(user, span_purple("You [ishuman(user) ? "wave your hand at" : "paw at"] [src], causing it to float away and remain still."))
		orbit_target.orbiters.end_orbit(src)
		animate(src, flags = ANIMATION_END_NOW)
		return TRUE
	else
		to_chat(user, span_purple("You [ishuman(user) ? "wave your hand at" : "paw at"] [src], causing it to float over to you happily."))
		orbit(user, 20)
		return TRUE

/obj/effect/faerie_light/attack_hand_secondary(mob/living/user, list/modifiers)
	. = ..()
	to_chat(user, span_purple("You [ishuman(user) ? "wave your hand at" : "paw at"] [src], causing it to float away and disappear.")) // Don't have paws? Too bad.
	animate(src, 1 SECONDS, alpha = 0)
	QDEL_IN(src, 1.1 SECONDS)
	return TRUE

/obj/effect/faerie_light/proc/timeout(time)
	QDEL_IN(src, time)

/obj/effect/faerie_light/Destroy()
	. = ..()
	if(orbit_target)
		orbit_target.orbiters.end_orbit(src)

/datum/action/cooldown/power/gift/faerie_light
	name = "Faerie Light"
	desc = "Create a bobbing mote of light to light your way or attract targets for an ambush."
	button_icon_state = "faerie_light"
	click_to_activate = TRUE

	rank = 1
	cooldown_time = 1 TURNS

	var/datum/storyteller_roll/roll_datum

/datum/action/cooldown/power/gift/faerie_light/Activate(atom/target)
	. = ..()
	if(!roll_datum)
		roll_datum = new()
	roll_datum.applicable_stats = list(STAT_WITS, STAT_OCCULT)
	roll_datum.difficulty = 6
	roll_datum.roll_output_type = ROLL_FLAG_ROLLER
	var/roll_result = roll_datum.st_roll(owner)

	if(roll_result <= ROLL_FAILURE)
		return FALSE

	var/obj/effect/faerie_light/cool_guy = new /obj/effect/faerie_light(get_turf(target))
	cool_guy.summoner = owner
	cool_guy.alpha = 0
	animate(cool_guy, 1 SECONDS, alpha = 255, easing = BOUNCE_EASING)

	if(isliving(target))
		cool_guy.orbit(target, 20)

	cool_guy.timeout(1 SCENES)

	playsound(owner, 'modular_darkpack/modules/werewolf_the_apocalypse/sounds/gifts/faerie_light_activate.ogg', 75, FALSE)

	StartCooldown()
	return TRUE
