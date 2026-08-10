/obj/item/smartphone/payphone
	name = "payphone"
	desc = "Ring ring. Ring ring. Ring ring."
	ONFLOOR_ICON_HELPER(null)
	icon = 'modular_darkpack/modules/phones/icons/phone.dmi'
	icon_state = "payphone"
	anchored = TRUE

/obj/item/smartphone/payphone/Initialize(mapload)
	sim_card = new /obj/item/sim_card/landline()
	sim_card.phone_weakref = WEAKREF(src)
	phone_flags |= PHONE_OPEN
	. = ..()

/obj/item/smartphone/payphone/attack_hand(mob/user, list/modifiers)
	. = ..()
	ui_interact(user)

/obj/item/smartphone/clean
	name = "cleaner phone"
	desc = "The usual phone of a cleaning company used to communicate with employees"
	ONFLOOR_ICON_HELPER(null)
	icon = 'modular_darkpack/modules/phones/icons/phone.dmi'
	icon_state = "phone_black"
	anchored = TRUE

/obj/item/smartphone/clean/Initialize(mapload)
	sim_card = new /obj/item/sim_card/cleaner()
	sim_card.phone_weakref = WEAKREF(src)
	phone_flags |= PHONE_OPEN
	. = ..()

/obj/item/smartphone/clean/attack_hand(mob/user, list/modifiers)
	. = ..()
	ui_interact(user)

/obj/item/smartphone/emergency
	name = "911 dispatch phone"
	desc = "A phone used for emergency calls."
	ONFLOOR_ICON_HELPER(null)
	icon = 'modular_darkpack/modules/phones/icons/phone.dmi'
	icon_state = "phone_red"
	anchored = TRUE

/obj/item/smartphone/emergency/Initialize(mapload)
	sim_card = new /obj/item/sim_card/emergency()
	sim_card.phone_weakref = WEAKREF(src)
	phone_flags |= PHONE_OPEN
	. = ..()

/obj/item/smartphone/emergency/attack_hand(mob/user, list/modifiers)
	. = ..()
	ui_interact(user)
