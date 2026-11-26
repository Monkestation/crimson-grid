/datum/component/fryable
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	///Result atom type of frying this object
	var/atom/fry_result
	///Amount of time required to fry the food, in deciseconds
	var/required_fry_time = 20 SECONDS
	///Time spent frying so far, in deciseconds
	var/current_fry_time = 0
	/// REF() to the mind which placed us in a fryer
	var/who_fried_us
	/// Reagents that should be added to the result
	var/list/added_reagents

/datum/component/fryable/Initialize(fry_result, required_fry_time, list/added_reagents)
	. = ..()
	if(!isitem(parent)) //Only items support frying at the moment
		return COMPONENT_INCOMPATIBLE

	src.fry_result = fry_result
	if(required_fry_time)
		src.required_fry_time = required_fry_time
	src.added_reagents = added_reagents

/datum/component/fryable/InheritComponent(datum/component/fryable/new_comp, original, fry_result, required_fry_time, list/added_reagents)
	if(!original)
		return
	if(fry_result)
		src.fry_result = fry_result
	if(required_fry_time)
		src.required_fry_time = required_fry_time
	if(added_reagents)
		src.added_reagents = added_reagents

/datum/component/fryable/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ITEM_ENTERED_FRYER, PROC_REF(on_frying_start))
	RegisterSignal(parent, COMSIG_ITEM_FRYER_PROCESS, PROC_REF(on_fry))
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/datum/component/fryable/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_ITEM_ENTERED_FRYER, COMSIG_ITEM_FRYER_PROCESS, COMSIG_ATOM_EXAMINE))

/// Signal proc for [COMSIG_ITEM_ENTERED_FRYER] when frying starts (parent is put in a fryer)
/datum/component/fryable/proc/on_frying_start(datum/source, mob/user)
	SIGNAL_HANDLER

	if(user?.mind)
		who_fried_us = REF(user.mind)

///god I'm so fried right now
/datum/component/fryable/proc/on_fry(datum/source, obj/machinery/deepfryer/fryer, seconds_per_tick = 1)
	SIGNAL_HANDLER

	current_fry_time += fryer.fry_speed * seconds_per_tick SECONDS
	if(current_fry_time >= required_fry_time)
		finish_frying(fryer)

	// We fucking got this fryer
	return COMPONENT_HANDLED_FRYING

///finshed
/datum/component/fryable/proc/finish_frying(obj/machinery/deepfryer/fryer)
	var/obj/item/original_object = parent
	var/atom/fried_result = new fry_result(fryer.drop_location())

	//so full of oil
	if(fried_result.reagents && original_object.reagents)
		fried_result.reagents.clear_reagents()
		original_object.reagents.trans_to(fried_result, original_object.reagents.total_volume)
	if(added_reagents && fried_result.reagents)
		fried_result.reagents.add_reagent_list(added_reagents)

	if(who_fried_us)
		ADD_TRAIT(fried_result, TRAIT_HANDMADE, who_fried_us)

	if(original_object.custom_materials)
		fried_result.set_custom_materials(original_object.custom_materials, 1)

	fried_result.pixel_x = original_object.pixel_x
	fried_result.pixel_y = original_object.pixel_y

	playsound(fryer, 'sound/machines/ding.ogg', 50, TRUE)
	fryer.audible_message(span_notice("[fryer] dings!"))

	var/list/anosmia_havers = list()
	for(var/mob/smeller in get_hearers_in_view(DEFAULT_MESSAGE_RANGE, fryer))
		if(HAS_TRAIT(smeller, TRAIT_ANOSMIA))
			anosmia_havers += smeller
	fryer.visible_message(
		span_notice("You smell something great coming from [fryer]."),
		blind_message = span_notice("You smell something great..."),
		ignored_mobs = anosmia_havers,
	)

	BLACKBOX_LOG_FOOD_MADE(fried_result.type)
	SEND_SIGNAL(parent, COMSIG_ITEM_FRIED, fried_result)
	SEND_SIGNAL(fried_result, COMSIG_ITEM_FRIED_RESULT, parent)
	qdel(parent)

///Gives info about the item's frying status so you can see if it's almost done
/datum/component/fryable/proc/on_examine(atom/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	if(!current_fry_time) //Not fried yet
		if(initial(fry_result.gender) == PLURAL)
			examine_list += span_notice("[parent] can be [span_bold("deep fried")] into some [initial(fry_result.name)].")
		else
			examine_list += span_notice("[parent] can be [span_bold("deep fried")] into \a [initial(fry_result.name)].")
		return

	if(current_fry_time <= required_fry_time * 0.75)
		examine_list += span_notice("[parent] probably needs to be fried a bit longer!")
	else
		examine_list += span_notice("[parent] seems to be almost finished frying!")
