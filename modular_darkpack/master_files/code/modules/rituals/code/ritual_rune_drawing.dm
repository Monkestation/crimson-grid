/datum/action/ritual_drawing
	name = "Ritual Drawing"
	desc = "Draw mystical runes."
	button_icon = 'modular_darkpack/master_files/icons/hud/actions.dmi'
	check_flags = AB_CHECK_HANDS_BLOCKED | AB_CHECK_IMMOBILE | AB_CHECK_LYING | AB_CHECK_CONSCIOUS
	vampiric = TRUE

	var/drawing = FALSE
	var/level = 1

	//ritual_rune/abyss, ritual_rune/thaumaturgy, etc
	var/rune_type
	//such as /obj/item/ritual_tome/abyss, /obj/item/ritual_tome/arcane, etc
	var/tome_type
	//stat to use for rune drawing speed
	var/speed_stat = STAT_OCCULT

/datum/action/ritual_drawing/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return

	if(!rune_type || !tome_type)
		stack_trace("[type] has no rune_type or tome_type set!")
		return

	var/mob/living/carbon/human/H = owner
	if(drawing)
		return

	var/has_tome = istype(H.get_active_held_item(), tome_type)
	var/list/available_runes = get_available_runes()

	if(!length(available_runes))
		to_chat(H, span_warning("You don't know any runes!"))
		return

	var/chosen_rune = select_rune(H, available_runes, has_tome)
	if(!chosen_rune)
		return

	var/list/rune_data = available_runes[chosen_rune]
	var/rune_cost = rune_data["cost"]

	if(H.bloodpool < rune_cost)
		to_chat(H, span_warning("You need more <b>BLOOD</b> to do that!"))
		return

	draw_rune(H, rune_data)

/datum/action/ritual_drawing/proc/get_available_runes()
	var/list/runes = list()
	for(var/rune_path in subtypesof(rune_type))
		var/obj/ritual_rune/R = new rune_path(owner)
		if(R.level <= level)
			runes[R.ritual_name] = list("path" = rune_path, "cost" = R.cost)
		qdel(R)
	return runes

/datum/action/ritual_drawing/proc/select_rune(mob/living/carbon/human/user, list/available_runes, has_tome)
	if(has_tome)
		return tgui_input_list(user, "Choose rune to draw:", name, available_runes)
	else
		var/random = tgui_input_list(user, "Choose rune to draw (Without a tome, you can only draw random runes...):", name, list("???"))
		if(random)
			return pick(available_runes)
		return null

/datum/action/ritual_drawing/proc/draw_rune(mob/living/carbon/human/user, list/rune_data)
	var/rune_path = rune_data["path"]
	var/rune_cost = rune_data["cost"]

	drawing = TRUE
	var/draw_time = 3 SECONDS * max(1, 5 - user.st_get_stat(speed_stat))

	if(do_after(user, draw_time, user))
		new rune_path(user.loc)
		user.adjust_blood_pool(-rune_cost)
		SEND_SIGNAL(user, COMSIG_MASQUERADE_VIOLATION)

	drawing = FALSE
