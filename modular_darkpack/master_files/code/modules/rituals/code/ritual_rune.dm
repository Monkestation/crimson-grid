//parent rune type for thaumaturgy, necromancy, obtenebration
/obj/ritual_rune
	abstract_type = /obj/ritual_rune
	name = "ritual rune"
	desc = "A mystical rune."
	icon = 'modular_darkpack/modules/deprecated/icons/icons.dmi'
	icon_state = "rune1"
	anchored = TRUE

	var/word = "IDI NAH"
	var/activator_bonus = 0
	var/activated = FALSE
	var/mob/living/last_activator
	var/level = 1
	var/list/sacrifices = list()
	var/activation_color
	var/cost = 1 // this needs to be set in subtypes
	var/ritual_name
	var/difficulty = 6 // set in subtypes

	/// What discipline is required (if any) to use this rune.
	var/required_discipline

	var/datum/storyteller_roll/ritual_roll/ritual_roll_datum

/datum/storyteller_roll/ritual_roll
	bumper_text = "ritual"
	applicable_stats = list(STAT_INTELLIGENCE, STAT_OCCULT)

/obj/ritual_rune/Initialize(mapload)
	. = ..()
	ritual_name = name
	name = "[name] rune"

/obj/ritual_rune/click_alt(mob/user)
	qdel(src)
	return CLICK_ACTION_SUCCESS

/*
*What happens when the ritual rune executes successfully
*/
/obj/ritual_rune/proc/complete()
	return

/*
*What happens when the ritual rune executes with a failure
*/
/obj/ritual_rune/proc/ritual_failure()
	return

/*
*What happens when the ritual rune executes with a botch
*/
/obj/ritual_rune/proc/ritual_botch()
	return

/*
* What happens when the user clicks on the rune. Ideally shouldn't be overriden.
*/
/obj/ritual_rune/attack_hand(mob/user)
	if(activated)
		return

	var/mob/living/living_user = astype(user)
	if(!living_user || (required_discipline && !living_user.get_discipline(required_discipline)))
		return

	living_user.say(word)
	living_user.Immobilize(30)
	last_activator = user
	if(activation_color)
		animate(src, color = activation_color, time = 10)
	if(length(sacrifices))
		if(!check_and_consume_sacrifices(user))
			return

	if(!ritual_roll_datum)
		ritual_roll_datum = new()
		ritual_roll_datum.difficulty = difficulty

	var/roll_result = ritual_roll_datum.st_roll(last_activator, last_activator)
	switch(roll_result)
		if(ROLL_SUCCESS)
			complete()
			return TRUE
		if(ROLL_FAILURE)
			ritual_failure()
			return FALSE
		if(ROLL_BOTCH)
			ritual_botch()
			return FALSE

/obj/ritual_rune/proc/check_and_consume_sacrifices(mob/user)
	var/list/found_items = list()

	for(var/obj/item/I in get_turf(src))
		for(var/item_type in sacrifices)
			if(istype(I, item_type))
				if(istype(I, /obj/item/reagent_containers/blood))
					var/obj/item/reagent_containers/blood/bloodpack = I
					if(bloodpack.reagents && bloodpack.reagents.total_volume > 0)
						found_items += I
						break
				else
					found_items += I
					break

	if(found_items.len == sacrifices.len)
		for(var/obj/item/I in found_items)
			qdel(I)
		return TRUE
	else
		to_chat(user, span_warning("You lack the necessary sacrifices to complete the ritual. Found [found_items.len], required [sacrifices.len]."))
		return FALSE
