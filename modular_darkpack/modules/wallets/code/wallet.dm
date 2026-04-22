/obj/item/storage/wallet/darkpack
	name = "wallet"
	desc = "A simple leather wallet for storing cash, cards, and small items."
	icon = 'modular_darkpack/modules/wallets/icons/docsicons.dmi'
	icon_state = "wallet"
	worn_icon_state = "nothing"
	w_class = WEIGHT_CLASS_SMALL
	storage_type = /datum/storage/wallet/darkpack
	slot_flags = ITEM_SLOT_ID
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/wallets/icons/docsonfloor.dmi')

/obj/item/storage/wallet/darkpack/update_icon_state()
	. = ..()
	if(length(contents) >= 6)
		icon_state = "wallet_full"
	else
		icon_state = "wallet"

//we dont need these methods from the parent type so just return
/obj/item/storage/wallet/darkpack/refreshID()
	return

/obj/item/storage/wallet/darkpack/update_overlays()
	return ..()

/obj/item/storage/wallet/darkpack/update_label()
	return

/obj/item/storage/wallet/darkpack/GetID()
	return

/obj/item/storage/wallet/darkpack/GetAccess()
	return list()

/obj/item/storage/wallet/darkpack/remove_id()
	return

/obj/item/storage/wallet/darkpack/insert_id(obj/item/inserting_item)
	return FALSE

/datum/storage/wallet/darkpack
	max_slots = 10
	max_specific_storage = WEIGHT_CLASS_SMALL
	max_total_storage = WEIGHT_CLASS_SMALL * 10

/datum/storage/wallet/darkpack/New(atom/parent, max_slots, max_specific_storage, max_total_storage, rustle_sound, remove_rustle_sound)
	. = ..()
	var/list/additional_types = list(
		/obj/item/stack/dollar,
		/obj/item/passport,
		/obj/item/vamp/keys
	)
	set_holdable(can_hold_list = can_hold + additional_types)
