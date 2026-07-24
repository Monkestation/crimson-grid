/proc/ui_hand_position(i)
	var/x_off = IS_LEFT_INDEX(i) ? 1 : 2
	var/y_off = round((i - 1) / 2)
	return "WEST+[x_off],SOUTH+[y_off + 6]:16"

/proc/ui_equip_position(mob/M)
	var/y_off = round((M.held_items.len-1) / 2) //values based on old equip ui position (CENTER: +/-16,SOUTH+1:5)
	return "WEST:16,SOUTH+[y_off+7]:16"

/proc/ui_swaphand_position(mob/M, which = LEFT_HANDS)
	var/x_off = (which == LEFT_HANDS) ? 1 : 2
	var/y_off = round((M.held_items.len - 1) / 2)
	return "WEST+[x_off],SOUTH+[y_off + 7]:16"

/proc/ui_perk_position(perk_count)
	var/y_off = perk_count < 1 ? 0 : perk_count/2
	return "WEST+0.5:12,NORTH-2-[y_off]:20"
