/obj/ritual_rune/abyss/comforting_darkness
	name = "comforting darkness"
	desc = "Use the power of the abyss to mend the wounds of yourself and others."
	icon_state = "rune8"
	word = "KEYUR'AGA"
	level = 2
	cost = 0
	var/static/list/roll_cache = list()

/obj/ritual_rune/abyss/comforting_darkness/complete()
	. = ..()
	var/list/heal_targets = list()
	var/turf/rune_location = get_turf(src)
	var/mob/living/carbon/human/invoker = last_activator
	var/dice = (invoker.st_get_stat(STAT_STAMINA) + invoker.st_get_stat(STAT_OCCULT))
	var/ckey = invoker.ckey

	// Can't use the ritual again until the debt is paid
	if(invoker.has_status_effect(/datum/status_effect/blood_debt))
		to_chat(invoker, span_notice("The Abyss demands payment before you can draw on its power again!"))
		return

	for(var/mob/living/carbon/human/target in rune_location)
		if(get_kindred_splat(target))
			heal_targets |= target

	heal_targets |= invoker

	var/roll
	var/spent_points
	var/list/bpoptions = list()

	// Prevents the player from rerolling for free; initial roll is stored until the ritual is invoked
	if(ckey in roll_cache)
		roll = roll_cache[ckey]
	else
		roll = SSroll.storyteller_roll(dice, 8, invoker, numerical = TRUE)
		roll_cache[ckey] = roll

	if(roll >= 1)
		for(var/i in 1 to roll)
			if(i <= invoker.bloodpool)
				bpoptions += i
		spent_points = tgui_input_list(invoker, "How many blood points would you like to spend? (60 healing per)", "Blood Points", bpoptions, null)
		if(!spent_points)
			return
		invoker.adjust_blood_pool(-spent_points)
		invoker.apply_status_effect(/datum/status_effect/blood_debt, 2 * spent_points) // Apply debuff with debt amount
		for(var/mob/living/carbon/human/target in heal_targets)
			target.heal_ordered_damage(60 * spent_points, list(BRUTE, TOX, OXY, STAMINA)) // Heals 2 levels of lethal/bashing per point spent
			target.heal_ordered_damage(30 * spent_points, list(BURN, AGGRAVATED)) // Heals aggravated at half effectiveness, TTRPG-inaccurate implementation but necessary

	else if(roll == 0)
		invoker.adjust_blood_pool(-1)
		qdel(src)

	else if(roll <= -1)
		to_chat(invoker, span_warning("You lose focus, failing to control the darkness as it burns you!"))
		invoker.adjust_blood_pool(-1)
		invoker.apply_damage(30, AGGRAVATED)
		qdel(src)

	playsound(rune_location, 'sound/effects/magic/voidblink.ogg', 50, FALSE)
	invoker.say("SANA'OSCURA") // Spanish for something along the lines of 'healing dark', spoken upon actual invocation of the rune.

	roll_cache -= ckey
	qdel(src)
