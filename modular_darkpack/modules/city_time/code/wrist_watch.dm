/obj/item/watch
	name = "wrist watch"
	desc = "A portable device to check time."
	icon = 'modular_darkpack/modules/city_time/icons/clock.dmi'
	worn_icon = 'modular_darkpack/modules/clothes/icons/worn.dmi'
	icon_state = "watch"
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	armor_type = /datum/armor/card_id
	resistance_flags = FIRE_PROOF | ACID_PROOF
	slot_flags = ITEM_SLOT_GLOVES
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/deprecated/icons/onfloor.dmi')
	custom_price = 20 // ECONOMY

/obj/item/watch/examine(mob/user)
	. = ..()
	. += "[src]: <b>[server_timestamp("hh:mm:ss", ic_time = TRUE, twelve_hour_clock = user.client?.prefs.read_preference(/datum/preference/toggle/twelve_hour))], [server_timestamp("MMM DD", ic_time = TRUE)]</b>"
	. += "That should make it <b>[server_timestamp("Day", ic_time = TRUE)]</b>"

// CRIMSON EDIT ADD START - Sell Valuables
/obj/item/watch/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 20, "watch", FALSE)
// CRIMSON EDIT ADD END - Sell Valuables
