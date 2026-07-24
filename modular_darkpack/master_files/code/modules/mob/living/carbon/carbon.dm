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
	suckbar_loc = null
	GLOB.masquerade_breakers_list -= src
	return ..()

/mob/living/carbon/resist_restraints()
	var/obj/item/I = null
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
			cuff_resist(I)
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
					if(ROLL_COOLDOWN)
						pass()
					else
						playsound(src, 'sound/effects/jingle.ogg', 40, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
						visible_message(span_warning("[src] aggressively wrenches against [I]!"))
				qdel(roll)
			else
				playsound(src, 'sound/effects/rock/rocktap3.ogg', 40, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
				cuff_resist(I, null, INSTANT_CUFFBREAK)

		else
			return
