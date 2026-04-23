#define UI_LIVING_AUSPICE "EAST-2:16,CENTER:40"
#define UI_LIVING_RAGE_AND_GNOSIS "EAST-2:20,CENTER-1:40"
#define UI_LIVING_TRANSFORM_HOMID "EAST-2,CENTER+1:40"
#define UI_LIVING_TRANSFORM_WAR "EAST-1,CENTER+1:40"
#define UI_LIVING_TRANSFORM_FERAL "EAST,CENTER+1:40"

/datum/hud/proc/add_werewolf_elements()
	add_screen_object(/atom/movable/screen/auspice, HUD_MOB_AUSPICE, HUD_GROUP_INFO)
	add_screen_object(/atom/movable/screen/rage_and_gnosis, HUD_MOB_RAGE_AND_GNOSIS, HUD_GROUP_INFO)
	add_screen_object(/atom/movable/screen/fera_transform/homid, HUD_MOB_HOMID_TRANS, HUD_GROUP_INFO)
	add_screen_object(/atom/movable/screen/fera_transform/war, HUD_MOB_WAR_TRANS, HUD_GROUP_INFO)
	add_screen_object(/atom/movable/screen/fera_transform/feral, HUD_MOB_FERAL_TRANS, HUD_GROUP_INFO)


/datum/splat/werewolf/add_relevent_huds(datum/hud/hud_used)
	hud_used.add_werewolf_elements()

/atom/movable/screen/auspice
	name = "auspice"
	icon = 'modular_darkpack/modules/werewolf_the_apocalypse/icons/werewolf_ui.dmi'
	icon_state = "auspice_bar"
	screen_loc = UI_LIVING_AUSPICE
	mouse_over_pointer = MOUSE_HAND_POINTER
	var/looked_at_moon = FALSE
	COOLDOWN_DECLARE(force_rage_cd)

/atom/movable/screen/auspice/Initialize(mapload, datum/hud/hud_owner)
	. = ..()

	update_icon()
	register_context()

/atom/movable/screen/auspice/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()

	context[SCREENTIP_CONTEXT_LMB] = "Check Moon"
	if(COOLDOWN_FINISHED(src, force_rage_cd))
		context[SCREENTIP_CONTEXT_RMB] = "Gain Rage"

	return CONTEXTUAL_SCREENTIP_SET

/atom/movable/screen/auspice/Click(location, control, params)
	. = ..()
	var/mob/living/carbon/human/clicker = usr
	if(!istype(clicker))
		return
	var/datum/splat/werewolf/clicker_splat = get_werewolf_splat(clicker)
	if(!istype(clicker_splat))
		return

	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, RIGHT_CLICK) && clicker_splat.uses_rage)
		if(!COOLDOWN_FINISHED(src, force_rage_cd))
			return

		clicker_splat.adjust_rage(1)
		message_admins("[ADMIN_LOOKUPFLW(clicker)] manually gained rage.")
		clicker.log_message("manually gained rage.", LOG_GAME, color="red")
		COOLDOWN_START(src, force_rage_cd, 1 SCENES)
		return TRUE

	if(!clicker.visible_to_sky())
		to_chat(clicker, span_warning("You need to be outside to look at the moon!"))
		return

	to_chat(clicker, span_notice("The phase of the Moon is a [GLOB.moon_state]."))

	if(looked_at_moon)
		return
	looked_at_moon = TRUE

	update_icon()

	if(!clicker_splat.uses_rage)
		return

	var/rage_amount = 1
	// W20 p. 145
	switch(GLOB.moon_state)
		if(MOON_NEW)
			rage_amount = 1
		if(MOON_WANING_GIBBOUS, MOON_WANING_CRESCENT)
			rage_amount = 2
		if(MOON_WAXING_CRESENT, MOON_FIRST_QUARTER, MOON_WAXING_GIBBOUS, MOON_LAST_QUARTER)
			rage_amount = 3
		if(MOON_FULL)
			rage_amount = 4

	if(clicker_splat?.auspice && (GLOB.moon_state in clicker_splat.auspice.moons_born_under))
		rage_amount = MAX_RAGE

	clicker_splat.adjust_rage(rage_amount, TRUE)
	return TRUE

/atom/movable/screen/auspice/update_icon_state()
	if(looked_at_moon)
		icon_state = "[GLOB.moon_state]"
	return ..()


/mob/living/proc/update_werewolf_hud()
	if(!hud_used)
		return
	hud_used.screen_objects[HUD_MOB_RAGE_AND_GNOSIS]?.update_icon()

/atom/movable/screen/rage_and_gnosis
	name = "rage and gnosis"
	icon = 'modular_darkpack/modules/werewolf_the_apocalypse/icons/hud_meters.dmi'
	icon_state = "rage0"
	screen_loc = UI_LIVING_RAGE_AND_GNOSIS

/atom/movable/screen/rage_and_gnosis/Initialize(mapload, datum/hud/hud_owner)
	. = ..()

	update_icon()

/atom/movable/screen/rage_and_gnosis/update_icon_state()
	var/mob/living/owner = hud?.mymob
	if(!istype(owner))
		return

	var/datum/splat/werewolf/our_splat = get_werewolf_splat(owner)
	if(!istype(our_splat))
		return

	icon_state = "rage[our_splat.rage]"

	// Should really be in update_overlays but i wanted to keep it to one get_werewolf_splat fetch
	cut_overlays()
	add_overlay("gnosis[our_splat.gnosis]")

	return ..()

/atom/movable/screen/fera_transform
	abstract_type = /atom/movable/screen/fera_transform
	icon = 'modular_darkpack/modules/werewolf_the_apocalypse/icons/hud_transforms.dmi'
	mouse_over_pointer = MOUSE_HAND_POINTER
	var/datum/species/left_click_transform
	var/datum/species/right_click_transform

/atom/movable/screen/fera_transform/Initialize(mapload, datum/hud/hud_owner)
	. = ..()

	update_icon()
	register_context()

/atom/movable/screen/fera_transform/Click(location, control, params)
	. = ..()
	var/mob/living/carbon/human/clicker = usr
	if(!istype(clicker))
		return
	if(clicker.stat >= UNCONSCIOUS)
		return

	var/datum/splat/werewolf/shifter/shifting = get_shifter_splat(clicker)
	var/list/modifiers = params2list(params)
	// Right click for alt forms like glabro and hispo. Ctrl click to use rage to do it instantly (doesnt matter if its breed form tho)
	shifting.transform_fera(LAZYACCESS(modifiers, RIGHT_CLICK) ? right_click_transform : left_click_transform, LAZYACCESS(modifiers, CTRL_CLICK))


/atom/movable/screen/fera_transform/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()

	var/datum/splat/werewolf/shifter/shifting = get_shifter_splat(user)

	if(left_click_transform)
		context[SCREENTIP_CONTEXT_LMB] = "Shift to [left_click_transform::name]"
		if(left_click_transform != shifting.get_breed_form_species())
			context[SCREENTIP_CONTEXT_CTRL_LMB] = "Shift using rage"
	if(right_click_transform)
		context[SCREENTIP_CONTEXT_RMB] = "Shift to [right_click_transform::name]"
		if(right_click_transform != shifting.get_breed_form_species())
			context[SCREENTIP_CONTEXT_CTRL_RMB] = "Shift using rage"

	return CONTEXTUAL_SCREENTIP_SET

/atom/movable/screen/fera_transform/homid
	name = "homid form"
	icon_state = "homid"
	screen_loc = UI_LIVING_TRANSFORM_HOMID
	left_click_transform = /datum/species/human/shifter/homid
	right_click_transform = /datum/species/human/shifter/bestial

/atom/movable/screen/fera_transform/war
	name = "war form"
	icon_state = "war"
	screen_loc = UI_LIVING_TRANSFORM_WAR
	left_click_transform = /datum/species/human/shifter/war

/atom/movable/screen/fera_transform/feral
	name = "feral form"
	icon_state = "feral"
	screen_loc = UI_LIVING_TRANSFORM_FERAL
	left_click_transform = /datum/species/human/shifter/feral
	right_click_transform = /datum/species/human/shifter/dire

#undef UI_LIVING_TRANSFORM_HOMID
#undef UI_LIVING_TRANSFORM_WAR
#undef UI_LIVING_TRANSFORM_FERAL
#undef UI_LIVING_AUSPICE
#undef UI_LIVING_RAGE_AND_GNOSIS
