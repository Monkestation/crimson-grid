/datum/hud/living/initialize_screen_objects()
	. = ..()
	add_screen_object(/atom/movable/screen/pull, HUD_MOB_PULL, HUD_GROUP_STATIC, ui_style, ui_living_pull)
	add_screen_object(/atom/movable/screen/combattoggle/flashy, HUD_MOB_INTENTS, HUD_GROUP_INFO, ui_style, ui_basic_combat_toggle)
	add_screen_object(/atom/movable/screen/healthdoll/living, HUD_MOB_HEALTHDOLL, HUD_GROUP_INFO)
	add_screen_object(/atom/movable/screen/stamina, HUD_MOB_STAMINA, HUD_GROUP_INFO)
	add_screen_object(/atom/movable/screen/floor_changer, HUD_MOB_FLOOR_CHANGER, HUD_GROUP_STATIC, ui_style, ui_floor_change)
	add_screen_object(/atom/movable/screen/language_menu, HUD_MOB_LANGUAGE_MENU, HUD_GROUP_STATIC, ui_style, ui_basic_language_menu)
	add_screen_object(/atom/movable/screen/memories, HUD_MOB_MEMORIES, HUD_GROUP_STATIC, ui_style, ui_basic_memories_menu)

	// DARKPACK EDIT ADD START
	add_screen_object(/atom/movable/screen/bloodpool, HUD_MOB_BLOODPOOL, HUD_GROUP_INFO)
	add_screen_object(/atom/movable/screen/zone_hud, HUD_MOB_ZONE, HUD_GROUP_INFO)
	var/mob/living/carbon/human/human_mob = astype(mymob)
	if(human_mob?.splats)
		for(var/datum/splat/splat in human_mob.splats)
			splat.add_relevent_huds(src)
	// DARKPACK EDIT ADD END
