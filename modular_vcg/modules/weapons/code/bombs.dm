/obj/item/grenade/pipebomb
	name = "pipe bomb"
	desc = "The great equalizer between us and them"
	w_class = WEIGHT_CLASS_NORMAL
	icon = 'modular_vcg/modules/weapons/icons/bombs.dmi'
	icon_state = "pipebomb_fuse"
	lefthand_file = 'modular_vcg/modules/weapons/icons/bombs_lefthand.dmi'
	righthand_file = 'modular_vcg/modules/weapons/icons/bombs_righthand.dmi'
	worn_icon = 'modular_vcg/modules/weapons/icons/worn_bomb.dmi'
	ONFLOOR_ICON_HELPER('modular_vcg/modules/weapons/icons/bomb_onfloor.dmi')
	shrapnel_type = /obj/projectile/bullet/shrapnel
	shrapnel_radius = 1
	throw_speed = 3
	throw_range = 6
	det_time = 30

/obj/item/grenade/pipebomb/attack_self(mob/user) // you need to light it
	return

/obj/item/grenade/pipebomb/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(active)
		return NONE
	var/ignition_msg = tool.ignition_effect(src, user)
	if(!ignition_msg)
		return NONE
	visible_message(ignition_msg)
	arm_grenade(user)
	return ITEM_INTERACT_SUCCESS

/obj/item/grenade/pipebomb/fire_act(exposed_temperature, exposed_volume)
	detonate()//combo bomb shenangins and accidental detonations

/obj/item/grenade/pipebomb/arm_grenade(mob/user, delayoverride, msg = TRUE, volume = 80)
	log_grenade(user)
	if(user)
		add_fingerprint(user)
		if(msg)
			to_chat(user, span_warning("You prime [src]! [capitalize(DisplayTimeText(det_time))]!"))
	playsound(src, 'sound/effects/fuse.ogg', volume, TRUE)
	active = TRUE
	icon_state = initial(icon_state) + "_live"
	addtimer(CALLBACK(src, PROC_REF(detonate)), isnull(delayoverride)? det_time : delayoverride)

/obj/item/grenade/pipebomb/detonate(mob/living/lanced_by)
	. = ..()
	if(!.)
		return

	update_mob()
	explosion(src, devastation_range = 0, heavy_impact_range = 0, light_impact_range = 3)
	qdel(src)




/obj/item/grenade/c4/pipebomb_ied
	name = "improvised explosive"
	desc = "Your honor this bomb was not improvised I spent a whole weekend crafting it. A Pipebomb with a phone jury rigged into the side to operate as a trigger"
	icon = 'modular_vcg/modules/weapons/icons/bombs.dmi'
	icon_state = "ied_pipebomb"
	inhand_icon_state = "ied_pipebomb"
	worn_icon = 'modular_vcg/modules/weapons/icons/worn_bomb.dmi'
	lefthand_file = 'modular_vcg/modules/weapons/icons/bombs_lefthand.dmi'
	righthand_file = 'modular_vcg/modules/weapons/icons/bombs_righthand.dmi'
	ONFLOOR_ICON_HELPER('modular_vcg/modules/weapons/icons/bomb_onfloor.dmi')
	boom_sizes = list(0, 1, 3)
	w_class = WEIGHT_CLASS_NORMAL
	shrapnel_type = /obj/projectile/bullet/shrapnel
	shrapnel_radius = 1
/obj/item/grenade/c4/pipebomb_ied/Initialize(mapload)
	plastic_overlay = mutable_appearance(icon, "[icon]2", HIGH_OBJ_LAYER)
	. = ..()
/obj/item/grenade/c4/pipebomb_ied/fire_act(exposed_temperature, exposed_volume)
	detonate()//The pipebomb storage has gone up in smoke and blown up the entire factory
