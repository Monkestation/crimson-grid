#define UI_LIVING_BLOODPOOL "EAST-2:29,CENTER-4:4"
/atom/movable/screen/bloodpool
	name = "bloodpool"
	//icon = 'modular_darkpack/modules/blood_drinking/icons/bloodpool.dmi'
	//32x32 version
	icon = 'modular_darkpack/modules/blood_drinking/icons/bloodpool.dmi'
	icon_state = "blood0"
	screen_loc = UI_LIVING_BLOODPOOL
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/bloodpool/Initialize(mapload, datum/hud/hud_owner)
	. = ..()

	update_icon()
	register_context()

/atom/movable/screen/bloodpool/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()

	context[SCREENTIP_CONTEXT_LMB] = "Check blood points"

	return CONTEXTUAL_SCREENTIP_SET

/atom/movable/screen/bloodpool/Click(location, control, params)
	if(isliving(usr))
		var/mob/living/bloodbag = usr
		bloodbag.update_blood_hud()
		if(bloodbag.bloodpool <= 0)
			to_chat(bloodbag, span_bolddanger("You've got [bloodbag.bloodpool]/[bloodbag.maxbloodpool] blood points."))
		else if(HAS_TRAIT(bloodbag, TRAIT_NEEDS_BLOOD))
			to_chat(bloodbag, span_warning("You've got [bloodbag.bloodpool]/[bloodbag.maxbloodpool] blood points and are gripped with hunger!"))
		else
			to_chat(bloodbag, span_notice("You've got [bloodbag.bloodpool]/[bloodbag.maxbloodpool] blood points."))

	return ..()

/atom/movable/screen/bloodpool/update_icon_state()
	var/mob/living/owner = hud?.mymob
	if(!istype(owner))
		icon_state = null
		return
	if(owner.maxbloodpool <= 0)
		icon_state = null
		return
	var/bp_amount = clamp(round((owner.bloodpool/owner.maxbloodpool)*10), 0, 10)
	icon_state = "blood[bp_amount]"
	return ..()

/mob/living/proc/update_blood_hud()
	if(!hud_used)
		return
	hud_used.screen_objects[HUD_MOB_BLOODPOOL]?.update_icon()

#undef UI_LIVING_BLOODPOOL
