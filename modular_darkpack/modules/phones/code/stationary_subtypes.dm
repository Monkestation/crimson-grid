/obj/item/smartphone/payphone
	name = "payphone"
	desc = "Ring ring. Ring ring. Ring ring."
	ONFLOOR_ICON_HELPER(null)
	icon = 'modular_darkpack/modules/phones/icons/phone.dmi'
	base_icon_state = "payphone"
	icon_state = "payphone"
	anchored = TRUE
	opened = TRUE
	always_open = TRUE
	default_sim_card_type = /obj/item/sim_card/landline

/obj/item/smartphone/payphone/attack_hand(mob/user, list/modifiers)
	. = ..()
	ui_interact(user)

/obj/item/smartphone/clean
	name = "cleaner phone"
	desc = "The usual phone of a cleaning company used to communicate with employees"
	ONFLOOR_ICON_HELPER(null)
	icon = 'modular_darkpack/modules/phones/icons/phone.dmi'
	base_icon_state = "phone_black"
	icon_state = "phone_black"
	anchored = TRUE
	opened = TRUE
	always_open = TRUE
	default_sim_card_type = /obj/item/sim_card/cleaner

/obj/item/smartphone/clean/attack_hand(mob/user, list/modifiers)
	. = ..()
	ui_interact(user)

/obj/item/smartphone/emergency
	name = "911 dispatch phone"
	desc = "A phone used for emergency calls."
	ONFLOOR_ICON_HELPER(null)
	icon = 'modular_darkpack/modules/phones/icons/phone.dmi'
	base_icon_state = "phone_red"
	icon_state = "phone_red"
	anchored = TRUE
	opened = TRUE
	always_open = TRUE
	default_sim_card_type = /obj/item/sim_card/emergency

/obj/item/smartphone/emergency/attack_hand(mob/user, list/modifiers)
	. = ..()
	ui_interact(user)
