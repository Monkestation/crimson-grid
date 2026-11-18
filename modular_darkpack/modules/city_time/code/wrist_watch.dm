/obj/item/clothing/watch
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
	clothing_traits = list(TRAIT_TIME_SENSE)
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/deprecated/icons/onfloor.dmi')
	custom_price = 20 // ECONOMY

/obj/item/clothing/watch/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/readable_time)

/obj/item/clothing/watch/attack_hand(mob/user, list/modifiers)
	. = ..()
	user.examinate(src)
