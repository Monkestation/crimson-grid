/* • Breath of the Wyld - W20 p.173
 *
 * Furies embrace the energy of creation, and they can share that passion with others.
 * With this Gift, the Black Fury instills a feeling of vitality, life, and lucidity in another living being.
 * It is taught by a servant of Pegasus.
 *
 * Roll Gnosis (difficulty 5 against Garou, Kinfolk; 6 otherwise).
 * Success grants the recipient an additional die to all mental rolls for the rest of the scene.
 * Also adds 1 to the difficulty of rage rolls made in this time.
 *
 * TODO: Rage check difficulty and audio. Use a horse sound.
*/

/datum/action/cooldown/power/gift/breath_of_the_wyld
	name = "Breath of the Wyld"
	desc = "The Fury instills a target with a rush of lucidity."
	button_icon_state = "breath_of_the_wyld"
	click_to_activate = TRUE
	rank = 1
	var/datum/storyteller_roll/roll_datum

/datum/action/cooldown/power/gift/breath_of_the_wyld/Activate(atom/target)
	if(!isliving(target))
		return
	if(!(target in range(1, owner)))
		return

	. = ..()

	var/mob/living/victim = target
	var/mob/living/caster = owner
	var/datum/splat/werewolf/casting_splat = get_werewolf_splat(caster)
	var/roll_difficulty = get_werewolf_splat(target) ? 5 : 6
	if(!roll_datum)
		roll_datum = new()
	roll_datum.difficulty = roll_difficulty
	roll_datum.roll_output_type = ROLL_FLAG_ROLLER|ROLL_FLAG_TARGET
	var/roll_result = roll_datum.st_roll(caster, target, casting_splat.gnosis)

	if(roll_result != ROLL_SUCCESS)
		return

	victim.apply_status_effect(/datum/status_effect/breath_of_the_wyld)

	StartCooldown()
	return TRUE

/datum/status_effect/breath_of_the_wyld
	id = "breath_of_the_wyld"
	duration = 1 SCENES

	status_type = STATUS_EFFECT_REPLACE

	alert_type = /atom/movable/screen/alert/status_effect/breath_of_the_wyld

/datum/status_effect/breath_of_the_wyld/on_apply()
	owner.st_add_stat_mod(STAT_PERCEPTION, 1, type)
	owner.st_add_stat_mod(STAT_INTELLIGENCE, 1, type)
	owner.st_add_stat_mod(STAT_WITS, 1, type)
	ADD_TRAIT(owner, TRAIT_DIFFICULT_RAGE, type)
	to_chat(owner, span_notice("You feel a sense of heightened lucidity."))
	return TRUE

/datum/status_effect/breath_of_the_wyld/on_remove()
	owner.st_remove_stat_mod(STAT_PERCEPTION, type)
	owner.st_remove_stat_mod(STAT_INTELLIGENCE, type)
	owner.st_remove_stat_mod(STAT_WITS, type)
	REMOVE_TRAIT(owner, TRAIT_DIFFICULT_RAGE, type)
	to_chat(owner, span_warning("Your mind settles, returning to it's normal state of lucidity."))

/atom/movable/screen/alert/status_effect/breath_of_the_wyld
	name = "Breath of the Wyld"
	desc = "Gain an additional die to all mental checks, but suffer a penalty to rage check difficulty."
	icon = 'modular_darkpack/modules/deprecated/icons/hud/screen_alert.dmi'
	icon_state = "riddle" // TODO: get an icon for this
