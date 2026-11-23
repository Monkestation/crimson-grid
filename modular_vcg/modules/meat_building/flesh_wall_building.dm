/obj/item/stack/sheet/meat/examine(mob/user)
	. = ..()
	. += span_notice("You can build a flesh wall by right clicking on an empty floor.")

/obj/item/stack/sheet/meat/afterattack_secondary(atom/target, mob/user, proximity_flag, click_parameters)
	if(istype(target, /turf/open))
		var/turf/open/build_on = target
		if(!user.Adjacent(build_on))
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
		if(isgroundlessturf(build_on))
			user.balloon_alert(user, "can't place it here!")
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
		if(build_on.is_blocked_turf())
			user.balloon_alert(user, "something is blocking the tile!")
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
		if(get_amount() < 2)
			user.balloon_alert(user, "not enough material!")
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
		if(!do_after(user, 4 SECONDS, build_on))
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
		if(build_on.is_blocked_turf())
			user.balloon_alert(user, "something is blocking the tile!")
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
		if(!use(2))
			user.balloon_alert(user, "not enough material!")
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
		new/obj/structure/fleshwall(build_on)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	return SECONDARY_ATTACK_CONTINUE_CHAIN
