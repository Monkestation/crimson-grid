/* • Desperate Strength - W20 p.174
 *
 * The werewolf calls on desperate reserves for a sudden surge of strength. A badger-spirit teaches this Gift.
 *
 * Select a number 1-5 on a radial menu and add that much strength to the next strength roll. Take 10 brute damage per level of strength.
 *
 * TODO: audio. Include a badger sound.
*/
/datum/action/cooldown/power/gift/desperate_strength
	name = "Desperate Strength"
	desc = "Call on desperate reserves for a sudden surge of strength."
	button_icon_state = "desperate_strength"
	rank = 1

/datum/action/cooldown/power/gift/desperate_strength/IsAvailable(feedback)
	. = ..()
	if(owner.has_status_effect(/datum/status_effect/desperate_strength))
		if(feedback)
			to_chat(owner, span_warning("[name] cannot be used again right now."))
		return FALSE

/datum/action/cooldown/power/gift/desperate_strength/Activate(atom/target)
	. = ..()
	var/mob/living/caster = astype(owner)
	if(!caster)
		return

	var/static/list/radial_menu_options = list(
			"One" = icon('modular_darkpack/modules/werewolf_the_apocalypse/icons/gifts/tribes/bone_gnawers.dmi', "radial_one"),
			"Two" = icon('modular_darkpack/modules/werewolf_the_apocalypse/icons/gifts/tribes/bone_gnawers.dmi', "radial_two"),
			"Three" = icon('modular_darkpack/modules/werewolf_the_apocalypse/icons/gifts/tribes/bone_gnawers.dmi', "radial_three"),
			"Four" = icon('modular_darkpack/modules/werewolf_the_apocalypse/icons/gifts/tribes/bone_gnawers.dmi', "radial_four"),
			"Five" = icon('modular_darkpack/modules/werewolf_the_apocalypse/icons/gifts/tribes/bone_gnawers.dmi', "radial_five"),
		)

	var/pick = show_radial_menu(owner, owner, radial_menu_options)
	if(!pick)
		return

	var/value = word_to_int(pick)

	if(!isnull(value))
		caster.apply_status_effect(/datum/status_effect/desperate_strength, value)

/datum/status_effect/desperate_strength
	id = "desperate_strength"
	duration = STATUS_EFFECT_PERMANENT

	status_type = STATUS_EFFECT_UNIQUE

	alert_type = /atom/movable/screen/alert/status_effect/desperate_strength
	/// Passed in by the gift's activate
	var/value

/datum/status_effect/desperate_strength/on_creation(mob/living/owner, value)
	src.value = value
	return ..()

/datum/status_effect/desperate_strength/on_apply()
	owner.st_add_stat_mod(STAT_STRENGTH, value, type)
	to_chat(owner, span_userdanger("You feel stronger... at a cost."))
	RegisterSignal(owner, COMSIG_LIVING_DICE_ROLLED, PROC_REF(on_dice_rolled))
	playsound(owner, 'modular_darkpack/modules/werewolf_the_apocalypse/sounds/gifts/desperate_strength_activate.ogg', 75, FALSE)
	return TRUE

/datum/status_effect/desperate_strength/proc/on_dice_rolled(mob/living/roller, datum/storyteller_roll/roll_datum, atom/target, atom/using_item, output)
	SIGNAL_HANDLER

	if(STAT_STRENGTH in roll_datum.using_stats(roller))
		qdel(src)

/datum/status_effect/desperate_strength/on_remove()
	owner.adjust_brute_loss(value TTRPG_DAMAGE)
	owner.st_remove_stat_mod(STAT_STRENGTH, type)
	playsound(owner, 'sound/effects/magic/disintegrate.ogg', 50, FALSE)
	to_chat(owner, span_warning("Your strength subsides, the pain of your wounds creeping back in..."))
	UnregisterSignal(owner, COMSIG_LIVING_DICE_ROLLED)

/atom/movable/screen/alert/status_effect/desperate_strength
	name = "Desperate Strength"
	desc = "Your next roll will be made with bonus strength, at the penalty of bashing damage!"
	icon = 'modular_darkpack/modules/deprecated/icons/hud/screen_alert.dmi'
	icon_state = "riddle" // TODO: get an icon for this


/proc/word_to_int(word)
	var/static/alist/words_to_number = list(
		"one" = 1,
		"two" = 2,
		"three" = 3,
		"four" = 4,
		"five" = 5,
		"six" = 6,
		"seven" = 7,
		"eight" = 8,
		"nine" = 9,
		"ten" = 10,
	)

	word = LOWER_TEXT(word)
	return words_to_number[word]
