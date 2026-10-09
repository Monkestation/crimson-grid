/datum/action/cooldown/power/gift/city_running
	name = "City Running"
	desc = {"The player spends a point of Rage. For the rest of the scene, the character may climb at her full movement speed,
	and the difficulty of all Athletics rolls to navigate is reduced by two."}
	button_icon_state = "city_running"
	rank = 1
	rage_cost = 1

/datum/action/cooldown/power/gift/city_running/Activate(atom/target)
	. = ..()
	var/mob/living/living_owner = astype(owner)
	living_owner?.apply_status_effect(/datum/status_effect/city_running)


/datum/status_effect/city_running
	id = "city_running"
	duration = 1 SCENES
	status_type = STATUS_EFFECT_REPLACE
	alert_type = /atom/movable/screen/alert/status_effect/gift/city_running

/atom/movable/screen/alert/status_effect/gift/city_running
	name = /datum/action/cooldown/power/gift/city_running::name
	desc = /datum/action/cooldown/power/gift/city_running::desc
	overlay_state = /datum/action/cooldown/power/gift/city_running::button_icon_state


/*
 * Once humans tamed fire to keep them warm and to drive off the wild beasts,
 * they were humanity’s ancient pact with the spirits of fire.
 * The spirits of flame agree to hold back their hunger when the werewolf touches them. An ancestor spirit or a fire-spirit grants this Gift.

 * This Gift allows a werewolf to heal fire damage as if it were bashing.
 * This requires the expenditure of a Gnosis point; the effects last for a scene.
*/
/datum/action/cooldown/power/gift/master_of_fire
	name = "Master of Fire"
	desc = "The spirits of flame agree to hold back their hunger, letting you regenerate fire damage for a scene."
	button_icon_state = "master_of_fire" // TODO: get an icon for this
	rank = 1
	gnosis_cost = 1

/datum/action/cooldown/power/gift/master_of_fire/Activate(atom/target)
	var/datum/splat/werewolf/shifter/shifter_splat = get_shifter_splat(owner)
	if(!shifter_splat)
		return FALSE // huh?

	. = ..()

	shifter_splat.adjust_gnosis(-1)
	shifter_splat.owner.apply_status_effect(/datum/status_effect/master_of_fire)

/datum/status_effect/master_of_fire
	id = "master_of_fire"
	duration = 1 SCENES

	status_type = STATUS_EFFECT_REPLACE

	alert_type = /atom/movable/screen/alert/status_effect/gift/master_of_fire

/datum/status_effect/master_of_fire/on_apply()
	to_chat(owner, span_notice("The spirits of flame agree to hold back their hunger, for a while."))
	return TRUE

/datum/status_effect/master_of_fire/on_remove()
	to_chat(owner, span_warning("The spirits of flame grow hungry yet again."))

/atom/movable/screen/alert/status_effect/gift/master_of_fire
	name = /datum/action/cooldown/power/gift/master_of_fire::name
	desc = "Lets you heal fire damage as if it were bashing."
	overlay_state = /datum/action/cooldown/power/gift/master_of_fire::button_icon_state


/datum/action/cooldown/power/gift/apecrafts_blessings
	name = "Apecraft's Blessings"
	desc = "Grants a bonus to the next roll made to employ any tool."
	button_icon_state = "apecrafts_blessing"
	rank = 1

/datum/action/cooldown/power/gift/apecrafts_blessings/IsAvailable(feedback)
	. = ..()
	var/mob/living/living_owner = astype(owner)
	if(!living_owner)
		return FALSE

	if(living_owner.has_status_effect(/datum/storyteller_roll/gift/apecrafts_blessings))
		return FALSE

/datum/action/cooldown/power/gift/apecrafts_blessings/Activate(atom/target)
	var/mob/living/living_owner = astype(owner)
	if(!living_owner)
		return FALSE

	. = ..()
	if(!do_after(owner, 1 TURNS))
		return

	var/datum/storyteller_roll/gift/apecrafts_blessings/roll_datum = new()
	var/roll_result = roll_datum.st_roll(owner)
	if(roll_result >= 1)
		living_owner.apply_status_effect(/datum/status_effect/apecrafts_blessings, roll_result)


/datum/storyteller_roll/gift/apecrafts_blessings
	bumper_text = /datum/action/cooldown/power/gift/apecrafts_blessings::name
	applicable_stats = list(STAT_WITS, STAT_CRAFTS)
	numerical = TRUE


/datum/status_effect/apecrafts_blessings
	id = "apecrafts_blessings"
	duration = STATUS_EFFECT_PERMANENT

	status_type = STATUS_EFFECT_UNIQUE

	alert_type = /atom/movable/screen/alert/status_effect/gift/apecrafts_blessings
	/// Passed in by the gift's activate
	var/value

/datum/status_effect/apecrafts_blessings/on_creation(mob/living/owner, value)
	src.value = value
	return ..()

/datum/status_effect/apecrafts_blessings/on_apply()
	to_chat(owner, span_notice("Your hands glow with power."))
	RegisterSignal(owner, COMSIG_LIVING_PRE_DICE_ROLLED, PROC_REF(on_dice_rolled))
	return TRUE

/datum/status_effect/apecrafts_blessings/proc/on_dice_rolled(mob/living/roller, datum/storyteller_roll/roll_datum, atom/target, atom/using_item, bonus, difficulty)
	SIGNAL_HANDLER

	if(using_item && !HAS_TRAIT(using_item, TRAIT_NATURAL))
		*difficulty -= value
		qdel(src)

/datum/status_effect/apecrafts_blessings/on_remove()
	to_chat(owner, span_warning("The power in your hands wanes.."))
	UnregisterSignal(owner, COMSIG_LIVING_PRE_DICE_ROLLED)


/atom/movable/screen/alert/status_effect/gift/apecrafts_blessings
	name = /datum/action/cooldown/power/gift/apecrafts_blessings::name
	desc = /datum/action/cooldown/power/gift/apecrafts_blessings::desc
	overlay_state = /datum/action/cooldown/power/gift/apecrafts_blessings::button_icon_state
