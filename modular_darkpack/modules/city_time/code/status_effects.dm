/datum/status_effect/day_time_notif
	id = "day_time_notif"
	alert_type = /atom/movable/screen/alert/status_effect/day_time_notif

/atom/movable/screen/alert/status_effect/day_time_notif
	name = "The sun is out"
	desc = "God, you must be tired..."
	icon = 'modular_darkpack/modules/deprecated/icons/hud/screen_alert.dmi'
	icon_state = "asleep"

/atom/movable/screen/alert/status_effect/day_time_notif/examine(mob/user)
	. = ..()
	. += span_notice("You are currently [user.visible_to_sky() ? "visible" : "not visible"] to the sun.")
	if(get_kindred_splat(user))
//CRIMSON GRID EDIT ADD PR: Humanity 10 Vamps can walk under the Sun CHANGE: Made it clearer if you can walk under the sun or not.
		var/mob/living/kindred = user
		if(!kindred.is_enlightenment() && (kindred.st_get_stat(STAT_MORALITY)>=10))
			. += span_green("Your dedication perserves you. For this few minutes the Sun shall not sear you")
		else
			. += span_warning("The sun will sear your flesh and bring final death.")
//CRIMSON GRID EDIT END
/datum/status_effect/sunlight_burning
	id = "sunlight_burning"
	alert_type = /atom/movable/screen/alert/status_effect/sunlight_burning

/datum/status_effect/sunlight_burning/on_apply()
	if(!SScity_time.daytime_started)
		return FALSE
	if(!owner.visible_to_sky())
		return FALSE

	var/datum/splat/vampire/kindred/kindred_owner = get_kindred_splat(owner)
	if(!kindred_owner)
		return FALSE
	// Humanity 10 vamps are immume to the light. atleast for the amount of time our day lasts.
	if(CONFIG_GET(flag/humanity_sunlight_resistance) && !owner.is_enlightenment() && (owner.st_get_stat(STAT_MORALITY) >= 10))
		return FALSE

	to_chat(owner, span_danger("THE SUN SEARS YOUR FLESH"))
	return TRUE

/datum/status_effect/sunlight_burning/tick(seconds_per_tick)
	. = ..()
	if(SScity_time.daytime_started)
		if(owner.visible_to_sky() && get_kindred_splat(owner))
			owner.apply_damage(1 TTRPG_DAMAGE, BURN)
			if(HAS_TRAIT(owner, TRAIT_LIGHT_WEAKNESS))
				owner.apply_damage(2 TTRPG_DAMAGE, BURN)
			return TRUE
	qdel(src)


/// A recersive search up our locs till something returns or we hit turf and return outdoors from its loc.
/atom/proc/visible_to_sky()
	// Anything that is not a turf should have its loc be an atom. Shits already fucked otherwise. Still have ?. saftey anyway.
	var/atom/my_loc = astype(loc)
	return my_loc?.contents_visible_to_sky()

/turf/visible_to_sky()
	var/area/my_area = astype(loc)
	return my_area?.outdoors

// This is a bold assumption, that every object you can be inside would obscure you.
// But imo its better to NOT grief a player when they assume something will protect them.
// Rather then having some weird things protect you from the sun.
/atom/proc/contents_visible_to_sky()
	return FALSE

/turf/contents_visible_to_sky()
	return visible_to_sky()


/atom/movable/screen/alert/status_effect/sunlight_burning
	name = "YOU ARE BURNING FROM THE SUN"
	desc = "Get inside!"
	icon = 'modular_darkpack/modules/deprecated/icons/hud/screen_alert.dmi'
	icon_state = "fire"

/datum/config_entry/flag/humanity_sunlight_resistance
