/obj/item/clothing/mask/kitsune
	adjusted_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK

/obj/item/clothing/mask/kitsune/attack_hand_secondary(mob/user, list/modifiers)
	if(user.get_item_by_slot(ITEM_SLOT_HEAD) == src)
		pull_down_from_head(user)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(user.get_item_by_slot(ITEM_SLOT_MASK) != src)
		return ..()
	attack_self(user)
	user.update_worn_mask()
	astype(user, /mob/living/carbon)?.refresh_obscured()
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/clothing/mask/kitsune/proc/pull_down_from_head(mob/user)
	if(user.get_item_by_slot(ITEM_SLOT_MASK))
		to_chat(user, span_warning("You can't pull [src] down over your face while you're already wearing a mask!"))
		return
	if(!user.temporarilyRemoveItemFromInventory(src))
		return
	attack_self(user)
	if(!user.equip_to_slot_if_possible(src, ITEM_SLOT_MASK, bypass_equip_delay_self = TRUE))
		user.put_in_hands(src)
