/datum/component/door_ownership
	/// Type of ownership (apartment, car, etc.)
	var/ownership_type = LOCK_OWNERSHIP_APARTMENT
	var/prompt_open = FALSE // CORVAX EDIT ADD

/datum/component/door_ownership/Initialize()

	if(istype(parent, /obj/darkpack_car))
		ownership_type = LOCK_OWNERSHIP_CAR
		var/obj/darkpack_car/car = parent
		car.flags_1 |= HAS_CONTEXTUAL_SCREENTIPS_1
	else if(istype(parent, /obj/structure/vampdoor))
		ownership_type = LOCK_OWNERSHIP_APARTMENT
		var/obj/structure/vampdoor/door = parent
		door.flags_1 |= HAS_CONTEXTUAL_SCREENTIPS_1
	else
		return COMPONENT_INCOMPATIBLE


/datum/component/door_ownership/RegisterWithParent()
	RegisterSignal(parent, COMSIG_CLICK_ALT, PROC_REF(try_award_key))
	RegisterSignal(parent, COMSIG_ATOM_REQUESTING_CONTEXT_FROM_ITEM, PROC_REF(add_context))

/datum/component/door_ownership/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_CLICK_ALT)
	UnregisterSignal(parent, COMSIG_ATOM_REQUESTING_CONTEXT_FROM_ITEM)

/datum/component/door_ownership/proc/try_award_key(atom/source, mob/user)
	SIGNAL_HANDLER

	if(!ishuman(user))
		return

	var/mob/living/carbon/human/human = user
	// can only have one apartment key, one car key
	if(ownership_type in human.received_ownership_keys)
		return

	var/lock_id
	if(istype(parent, /obj/darkpack_car))
		var/obj/darkpack_car/car = parent
		lock_id = car.access
	else if(istype(parent, /obj/structure/vampdoor))
		var/obj/structure/vampdoor/door = parent
		lock_id = door.lock_id

	if(!lock_id)
		return

	// async proc because signal handler
	INVOKE_ASYNC(src, PROC_REF(award_key_async), human, lock_id)
	return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/component/door_ownership/proc/award_key_async(mob/living/carbon/human/human, lock_id)
	// CORVAX EDIT ADD START - a second open prompt kept the deleted component alive and gave out extra keys
	if(prompt_open)
		return
	prompt_open = TRUE
	award_key_prompts(human, lock_id)
	if(!QDELETED(src))
		prompt_open = FALSE

/datum/component/door_ownership/proc/award_key_prompts(mob/living/carbon/human/human, lock_id)
	// CORVAX EDIT ADD END
	var/ownership_question
	var/alert_title

	switch(ownership_type)
		if(LOCK_OWNERSHIP_CAR)
			if(CONFIG_GET(flag/punishing_zero_dots) && human.st_get_stat(STAT_DRIVE) < 1)
				to_chat(human, span_danger("Может, сначала научиться водить, а уже потом заводить машину?"))
				return
			ownership_question = "Это моя машина?"
			alert_title = "Машина"
		if(LOCK_OWNERSHIP_APARTMENT)
			ownership_question = "Это моя квартира?"
			alert_title = "Квартира"

	var/alert = tgui_alert(human, ownership_question, alert_title, list("Да", "Нет"), 30 SECONDS) // CORVAX EDIT CHANGE - ORIGINAL: no timeout
	if(alert != "Да" || QDELETED(src)) // CORVAX EDIT CHANGE - ORIGINAL: if(alert != "Да")
		return

	var/spare_key = tgui_alert(human, "Есть ли у меня запасной ключ?", alert_title, list("Да", "Нет"), 30 SECONDS) // CORVAX EDIT CHANGE - ORIGINAL: no timeout
	if(QDELETED(src) || QDELETED(human)) // CORVAX EDIT ADD
		return // CORVAX EDIT ADD

	var/key_amount = 1
	if(spare_key == "Да")
		key_amount = 2

	for(var/i in 1 to key_amount)
		var/obj/item/vamp/keys/key = new /obj/item/vamp/keys(get_turf(human))
		key.accesslocks = list("[lock_id]")
		human.put_in_hands(key)

	human.received_ownership_keys += ownership_type
	qdel(src)

/datum/component/door_ownership/proc/add_context(datum/source, list/context, obj/item/held_item, mob/user)
	SIGNAL_HANDLER

	var/mob/living/carbon/human/human_user = astype(user)
	if(human_user)
		if(ownership_type in human_user.received_ownership_keys)
			return NONE
		context[SCREENTIP_CONTEXT_ALT_LMB] = "Забрать ключи"
		return CONTEXTUAL_SCREENTIP_SET
	return NONE
