#define METHLAB_IDLE 0
#define METHLAB_COOKING 1
#define METHLAB_DONE 2
/// A ruined batch. Locked up until it goes off.
#define METHLAB_RUINED 3

#define METHLAB_STAGE_COUNT 5
/// How long between a batch being ruined and the lab going off, so people can get clear.
#define METHLAB_FUSE_TIME (3 SECONDS)

/obj/structure/methlab
	/// One of METHLAB_*
	var/state = METHLAB_IDLE
	/// What this lab is set to make
	var/datum/lab_recipe/recipe
	/// Slot typepath > how many are in
	var/list/loaded = list()
	/// Current minigame, 1-based
	var/stage = 1
	/// world.time the current minigame was started from the UI, 0 if it hasn't been
	var/stage_started = 0
	/// Score (0-100) of each finished minigame
	var/list/stage_scores = list()
	var/final_quality = 0
	/// Went in in the wrong order. Makes the minigames harder and the batch worse.
	var/instability = 0

/obj/structure/methlab/Initialize(mapload)
	. = ..()
	recipe = locate(/datum/lab_recipe/meth) in GLOB.lab_recipes
	if(!recipe)
		recipe = GLOB.lab_recipes[1]

/obj/structure/methlab/Destroy()
	SStgui.close_uis(src)
	recipe = null
	return ..()

/obj/structure/methlab/examine(mob/user)
	. = ..()
	. += span_notice("It's set to make [recipe.name].")
	switch(state)
		if(METHLAB_IDLE)
			var/list/missing = list()
			for(var/slot_type in recipe.slots)
				var/datum/lab_slot/slot = GLOB.lab_slots[slot_type]
				var/remaining = recipe.slots[slot_type] - (loaded[slot_type] || 0)
				if(remaining > 0)
					missing += "[remaining]x [slot.name]"
			. += span_notice("Still needs: [english_list(missing, "nothing")]. Use it with an empty hand to change the recipe.")
		if(METHLAB_RUINED)
			. += span_userdanger("It's rattling and hissing. It's about to go!")
		else
			. += span_notice("It's loaded and ready. Use it with an empty hand to open the controls.")

/obj/structure/methlab/proc/reset_lab()
	state = METHLAB_IDLE
	stage = 1
	stage_started = 0
	stage_scores = list()
	final_quality = 0
	loaded = list()
	instability = 0
	SStgui.update_uis(src)

/obj/structure/methlab/proc/nothing_loaded()
	for(var/slot_type in loaded)
		if(loaded[slot_type])
			return FALSE
	return TRUE

/obj/structure/methlab/proc/fully_loaded()
	for(var/slot_type in recipe.slots)
		if((loaded[slot_type] || 0) < recipe.slots[slot_type])
			return FALSE
	return TRUE

// ---------------------------------------------------------------------------------------------
// Loading ingredients (by hand)
// ---------------------------------------------------------------------------------------------

/obj/structure/methlab/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	var/datum/lab_slot/slot = recipe.find_slot(tool)
	if(!slot)
		return ..()
	if(state != METHLAB_IDLE)
		balloon_alert(user, "already loaded!")
		return ITEM_INTERACT_BLOCKING
	if(!add_ingredient(user, tool, slot))
		return ITEM_INTERACT_BLOCKING
	if(prob(20) || (instability && prob(40)))
		to_chat(user, span_warning("The reagents start to react strangely..."))
	if(fully_loaded())
		start_cook()
	SStgui.update_uis(src)
	return ITEM_INTERACT_SUCCESS

/// Consumes the ingredient if it fits the recipe. Order mistakes are allowed but add instability.
/obj/structure/methlab/proc/add_ingredient(mob/living/user, obj/item/tool, datum/lab_slot/slot)
	if((loaded[slot.type] || 0) >= recipe.slots[slot.type])
		balloon_alert(user, "no room for more")
		return FALSE
	if(!slot.can_accept(user, tool))
		return FALSE
	instability += slot.order_penalty(tool, loaded)
	loaded[slot.type] = (loaded[slot.type] || 0) + 1
	slot.consume(user, tool)
	return TRUE

/obj/structure/methlab/proc/start_cook()
	state = METHLAB_COOKING
	stage = 1
	stage_started = 0
	stage_scores = list()
	playsound(src, 'sound/machines/click.ogg', 40, TRUE)
	visible_message(span_notice("[src] is loaded and ready to go."))

// ---------------------------------------------------------------------------------------------
// The minigame UI. The minigames themselves run client side; the server only checks the order,
// enforces a minimum time per stage, and turns the scores into a purity.
// ---------------------------------------------------------------------------------------------

/obj/structure/methlab/attack_hand(mob/living/user, list/modifiers)
	if(user.combat_mode)
		return ..()
	ui_interact(user)
	return TRUE

/obj/structure/methlab/ui_interact(mob/user, datum/tgui/ui)
	if(state == METHLAB_RUINED)
		balloon_alert(user, "it's about to blow!")
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MethLab")
		ui.open()

/obj/structure/methlab/ui_static_data(mob/user)
	var/list/data = list()
	data["stage_names"] = list("Pour", "Heat", "Stir", "Filter", "Crush")
	var/list/recipe_list = list()
	for(var/datum/lab_recipe/each_recipe as anything in GLOB.lab_recipes)
		UNTYPED_LIST_ADD(recipe_list, list(
			"id" = "[each_recipe.type]",
			"name" = each_recipe.name,
			"desc" = each_recipe.desc,
		))
	data["recipes"] = recipe_list
	return data

/obj/structure/methlab/ui_data(mob/user)
	var/list/data = list()
	data["state"] = state
	data["recipe_id"] = "[recipe.type]"
	data["stage"] = stage
	data["stage_scores"] = stage_scores
	data["quality"] = final_quality
	data["instability"] = instability
	data["difficulty"] = instability + recipe.base_difficulty
	var/list/slot_list = list()
	for(var/slot_type in recipe.slots)
		var/datum/lab_slot/slot = GLOB.lab_slots[slot_type]
		UNTYPED_LIST_ADD(slot_list, list(
			"label" = slot.name,
			"have" = loaded[slot_type] || 0,
			"need" = recipe.slots[slot_type],
		))
	data["slots"] = slot_list
	return data

/obj/structure/methlab/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state_obj)
	. = ..()
	if(.)
		return
	var/mob/living/user = ui.user
	switch(action)
		if("select_recipe")
			// Can't swap recipes with ingredients already in
			if(state != METHLAB_IDLE || !nothing_loaded())
				return FALSE
			for(var/datum/lab_recipe/each_recipe as anything in GLOB.lab_recipes)
				if("[each_recipe.type]" == params["id"])
					recipe = each_recipe
					return TRUE
			return FALSE
		if("begin_stage")
			if(state != METHLAB_COOKING)
				return FALSE
			stage_started = world.time
			return TRUE
		if("stage_done")
			if(state != METHLAB_COOKING || !stage_started)
				return FALSE
			var/static/list/stage_min_time = list(2 SECONDS, 3 SECONDS, 4 SECONDS, 3 SECONDS, 5 SECONDS)
			var/score = text2num(params["score"])
			if(isnull(score))
				score = 0
			score = clamp(round(score), 0, 100)
			// Nobody finishes a stage that fast legitimately
			if(world.time - stage_started < stage_min_time[stage])
				score = 0
			stage_scores += score
			stage++
			stage_started = 0
			playsound(src, 'sound/machines/click.ogg', 30, TRUE)
			if(stage > METHLAB_STAGE_COUNT)
				finish_batch(user)
			return TRUE
		if("collect")
			if(state != METHLAB_DONE)
				return FALSE
			collect(user)
			return TRUE
	return FALSE

/obj/structure/methlab/proc/finish_batch(mob/living/user)
	var/total = 0
	for(var/score in stage_scores)
		total += score
	var/average = total / max(length(stage_scores), 1)
	final_quality = clamp(round(average) - instability * 5, 0, 100)
	if(final_quality < 10)
		ruin_batch(user)
		return
	state = METHLAB_DONE
	visible_message(span_notice("[src] pings. The batch is ready."))
	playsound(src, 'sound/machines/ping.ogg', 40, TRUE)

/// Starts the fuse. user is whoever finished the last stage, and is who witnesses blame.
/obj/structure/methlab/proc/ruin_batch(mob/living/user)
	state = METHLAB_RUINED
	SStgui.close_uis(src)
	visible_message(span_userdanger("[src] shudders and starts hissing violently! Get away from it!"))
	playsound(src, 'sound/effects/spray2.ogg', 50, TRUE)

	for(var/mob/living/carbon/human/npc/police/witness in oviewers(DEFAULT_SIGHT_DISTANCE, src))
		witness.announce_drug_line(witness.socialrole?.drug_witness_phrases)
		witness.last_antagonised = world.time
		if(user)
			witness.Aggro(user, TRUE)
		witness.fleeing_from = witness
		witness.cancel_talking()
		SEND_SIGNAL(SSdcs, COMSIG_GLOB_REPORT_CRIME, CRIME_DRUG_PRODUCTION, get_turf(src))

	addtimer(CALLBACK(src, PROC_REF(detonate)), METHLAB_FUSE_TIME)

/// The lab goes up: a cloud of fumes, a blast sized by the recipe, and the lab is destroyed.
/obj/structure/methlab/proc/detonate()
	var/turf/blast_turf = get_turf(src)
	if(blast_turf)
		var/datum/effect_system/fluid_spread/smoke/lab_fumes/fumes = new(blast_turf, recipe.fume_range)
		fumes.tox_damage = recipe.fume_damage
		fumes.start()
		if(recipe.blast_range)
			explosion(blast_turf, light_impact_range = recipe.blast_range, flame_range = recipe.blast_range)
	qdel(src)

/obj/structure/methlab/proc/collect(mob/living/user)
	var/amount = recipe.base_yield + round(final_quality / recipe.yield_divisor)
	var/turf/drop = get_turf(src)
	for(var/i in 1 to amount)
		new recipe.output_type(drop, final_quality)
	to_chat(user, span_notice("You collect [amount] [recipe.output_name]. [final_quality >= 90 ? "Beautiful work." : (final_quality >= 60 ? "Decent." : "Rough.")]"))
	reset_lab()

#undef METHLAB_IDLE
#undef METHLAB_COOKING
#undef METHLAB_DONE
#undef METHLAB_RUINED
#undef METHLAB_STAGE_COUNT
#undef METHLAB_FUSE_TIME
