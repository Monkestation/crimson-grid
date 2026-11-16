/mob/living/carbon/Initialize(mapload)
	. = ..()
	if(!examine_panel_tgui)
		examine_panel_tgui = new()
		examine_panel_tgui.holder = src

/mob/living/carbon/Destroy()
	examine_panel_tgui.holder = null
	QDEL_NULL(examine_panel_tgui)
	client?.images -= suckbar
	QDEL_NULL(suckbar)
	GLOB.masquerade_breakers_list -= src
	return ..()

/mob/living/carbon/resist_restraints()
	var/obj/item/I
	if(handcuffed)
		I = handcuffed
		changeNext_move(I.resist_cooldown)
		last_special = world.time + I.resist_cooldown
	else if(legcuffed)
		I = legcuffed
		changeNext_move(CLICK_CD_RANGE)
		last_special = world.time + CLICK_CD_RANGE
	else
		return

	var/resist_type = "Remove"
	if(!isnull(I.cuff_break_strength_needed))
		resist_type = tgui_alert(src, "Remove your restraints, or try to break them?", "[I]", list("Remove", "Break"))

	switch(resist_type)
		if("Remove")
			var/roll_difficulty = 0
			switch(I.breakouttime)
				if(5 SECONDS to 15 SECONDS)
					roll_difficulty = 6
				if(15 SECONDS to 30 SECONDS)
					roll_difficulty = 7
				if(30 SECONDS to 1 MINUTES)
					roll_difficulty = 8
				if(1 MINUTES to INFINITY)
					roll_difficulty = 9
			if(!roll_difficulty)
				cuff_resist(I)

			var/datum/storyteller_roll/slip_restraints/roll = new()
			roll.difficulty = roll_difficulty
			switch(roll.st_roll(src, I))
				if(ROLL_SUCCESS)
					cuff_resist(I, null, INSTANT_CUFFBREAK)
				else
					playsound(src, 'sound/effects/jingle.ogg', 25, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
					visible_message(span_warning("[src] is trying to wiggle out of [I]!"))
		if("Break")
			var/missing_strength =  I.cuff_break_strength_needed - st_get_stat(STAT_STRENGTH)
			if(missing_strength > 0)
				// we gotta substitute the rest with willpower
				var/datum/storyteller_roll/restraint_break/roll = new()
				roll.successes_needed = missing_strength

				switch(roll.st_roll(src, I))
					if(ROLL_SUCCESS)
						playsound(src, 'sound/effects/rock/rocktap3.ogg', 40, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
						cuff_resist(I, null, INSTANT_CUFFBREAK) // OUT WITH THE CUFFS
					/* Not reachable rn
					if(ROLL_COOLDOWN)
						pass()
					*/
					else
						playsound(src, 'sound/effects/jingle.ogg', 40, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
						visible_message(span_warning("[src] aggressively wrenches against [I]!"))
				qdel(roll)
			else
				playsound(src, 'sound/effects/rock/rocktap3.ogg', 40, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
				cuff_resist(I, null, INSTANT_CUFFBREAK)

		else
			return
