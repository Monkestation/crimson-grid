/datum/discipline/temporis
	name = "Temporis"
	desc = "Temporis is a Discipline unique to the True Brujah. Supposedly a refinement of Celerity, Temporis grants the Cainite the ability to manipulate the flow of time itself."
	icon_state = "temporis"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/temporis
	signature_clan = VAMPIRE_CLAN_TRUE_BRUJAH

/datum/discipline_power/temporis
	name = "Temporis power name"
	desc = "Temporis power description"

	activate_sound = 'modular_darkpack/modules/powers/sounds/temporis/temporis.ogg'

/datum/discipline_power/temporis/activate()
	. = ..()
	ADD_TRAIT(owner, TRAIT_TIMEWARPER, DISCIPLINE_TRAIT(type))

/datum/discipline_power/temporis/proc/celerity_explode(datum/source, datum/discipline_power/power, atom/target)
	SIGNAL_HANDLER

	if (!istype(power, /datum/discipline_power/celerity))
		return

	to_chat(owner, span_userdanger("You try to use Celerity, but your active Temporis causes your body to wrench itself apart!"))
	INVOKE_ASYNC(owner, TYPE_PROC_REF(/mob, emote), "scream")
	addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob/living/carbon/human, gib)), 3 SECONDS)

	return POWER_CANCEL_ACTIVATION

//HOURGLASS OF THE MIND
/datum/discipline_power/temporis/hourglass_of_the_mind
	name = "Hourglass of the Mind"
	desc = "Gain a perfect sense of time. Know exactly when you are."

	level = 1
	check_flags = DISC_CHECK_CONSCIOUS
	vitae_cost = 0

/datum/discipline_power/temporis/hourglass_of_the_mind/post_gain()
	ADD_TRAIT(owner, TRAIT_TIME_SENSE, DISCIPLINE_TRAIT(type))

/datum/discipline_power/temporis/hourglass_of_the_mind/activate()
	. = ..()
	to_chat(owner, "<b>[station_time_timestamp("hh:mm:ss")]</b>")

	// Check range for targets with that have warped time this round and display them, if any exist
	var/list/targets = list()
	for(var/mob/living/carbon/human/target in view(range, owner))
		if(target == owner)
			continue
		if(HAS_TRAIT(target, TRAIT_TIMEWARPER))
			targets += target
	if(targets.len)
		var/target_list = ""
		for(var/i = 1 to targets.len)
			var/mob/living/carbon/human/target = targets[i]
			target_list += target.name
			if(i < targets.len - 1)
				target_list += ", "
			else if(i == targets.len - 1)
				target_list += " and "
		to_chat(owner, span_notice("[english_list(targets)] [targets.len == 1 ? "has" : "have"] temporal distortions around [targets.len == 1 ? "themself" : "themselves"]."))
	else
		to_chat(owner, span_notice("There are no temporal distortions nearby."))

//RECURRING CONTEMPLATION
/datum/discipline_power/temporis/recurring_contemplation
	name = "Recurring Contemplation"
	desc = "Trap your target into repeating the same set of actions."

	level = 2
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE
	target_type = TARGET_LIVING
	range = 7
	vitae_cost = 0 //You *can* spend a BP to boost this, but it'd extend time to hours or a day.

	hostile = TRUE

	cooldown_length = 15 SECONDS

/datum/discipline_power/temporis/recurring_contemplation/activate(mob/living/target)
	. = ..()
	target.AddComponent(/datum/component/dejavu, rewinds = 4, interval = 2 SECONDS)

//LEADEN MOMENT
/datum/discipline_power/temporis/leaden_moment
	name = "Leaden Moment"
	desc = "Slow time around your opponent, reducing their speed."

	level = 3
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE
	target_type = TARGET_LIVING
	range = 7

	hostile = TRUE

	multi_activate = TRUE
	duration_length = 15 SECONDS
	cooldown_length = 15 SECONDS

/datum/discipline_power/temporis/leaden_moment/activate(mob/living/target)
	. = ..()
	to_chat(target, span_userdanger("<b>Slow down.</b>"))
	target.add_movespeed_modifier(/datum/movespeed_modifier/temporis)

/datum/discipline_power/temporis/leaden_moment/deactivate(mob/living/target)
	. = ..()
	target.remove_movespeed_modifier(/datum/movespeed_modifier/temporis)

/datum/movespeed_modifier/temporis
	multiplicative_slowdown = 7.5

//PATIENCE OF THE NORNS
/datum/discipline_power/temporis/patience_of_the_norns
	name = "Patience of the Norns"
	desc = "Be in multiple places at once, creating several false images."

	level = 4
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE

	violates_masquerade = TRUE

	cancelable = TRUE
	duration_length = 10 SECONDS
	cooldown_length = 15 SECONDS

/datum/discipline_power/temporis/patience_of_the_norns/activate()
	. = ..()
	var/matrix/initial_matrix = matrix(owner.transform)
	var/matrix/secondary_matrix = matrix(owner.transform)
	var/matrix/tertiary_matrix = matrix(owner.transform)
	initial_matrix.Translate(1,0)
	secondary_matrix.Translate(0,1)
	tertiary_matrix.Translate(1)
	animate(owner, transform = initial_matrix, time = 1 SECONDS, loop = 0)
	animate(owner, transform = secondary_matrix, time = 1 SECONDS, loop = 0, ANIMATION_PARALLEL)
	animate(owner, transform = tertiary_matrix, time = 1 SECONDS, loop = 0, ANIMATION_PARALLEL)
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(temporis_visual))
	RegisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION, PROC_REF(celerity_explode))

/datum/discipline_power/temporis/patience_of_the_norns/deactivate()
	. = ..()
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION)

/datum/discipline_power/temporis/patience_of_the_norns/proc/temporis_visual(datum/discipline_power/temporis/source, atom/newloc, dir)
	SIGNAL_HANDLER

	new /obj/effect/temporis/patience_of_the_norns(owner.loc, owner)

	SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)

//CLOTHOS GIFT
/datum/discipline_power/temporis/clothos_gift
	name = "Clotho's Gift"
	desc = "Accelerate yourself through time and magnify your speed."

	level = 5
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE
	vitae_cost = 3

	violates_masquerade = TRUE

	cancelable = TRUE
	duration_length = 10 SECONDS
	cooldown_length = 15 SECONDS

/datum/discipline_power/temporis/clothos_gift/activate()
	. = ..()
	owner.add_movespeed_modifier(/datum/movespeed_modifier/temporis5)
	owner.next_move_modifier *= 0.25
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(temporis_visual))
	RegisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION, PROC_REF(celerity_explode))

/datum/discipline_power/temporis/clothos_gift/deactivate()
	. = ..()
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/temporis5)
	owner.next_move_modifier /= 0.25
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION)

/datum/discipline_power/temporis/clothos_gift/proc/temporis_visual(datum/discipline_power/temporis/source, atom/newloc, dir)
	SIGNAL_HANDLER

	new /obj/effect/temporis/clothos_gift(owner.loc, owner)

	SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)

/datum/movespeed_modifier/temporis5
	multiplicative_slowdown = -2.5
