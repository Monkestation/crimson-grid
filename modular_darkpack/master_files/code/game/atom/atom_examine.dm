/obj/item/get_examine_icon(mob/user)
	if(item_flags & ACTIVE_WORLD_ICON)
		return icon2html(initial(icon), user, initial(icon_state))
	else
		return icon2html(src, user)
