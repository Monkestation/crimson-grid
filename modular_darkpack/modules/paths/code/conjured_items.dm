// conjured items subclassed as lighters to emit light
/obj/item/lighter/conjured
	lit = TRUE
	light_system = OVERLAY_LIGHT
	light_on = TRUE
	damtype = BURN
	item_flags = DROPDEL
	icon = 'modular_darkpack/modules/paths/icons/paths.dmi'
	lefthand_file = 'modular_darkpack/modules/paths/icons/paths_inhand_lefthand.dmi'
	righthand_file = 'modular_darkpack/modules/paths/icons/paths_inhand_righthand.dmi'
	icon_state = "flame-on"
	inhand_icon_state = "flame"

// Override parent behavior so that they can't be turned off
/obj/item/lighter/conjured/attack_self(mob/user)
	to_chat(user, span_notice("The supernatural flame cannot be extinguished by normal means."))
	return

/obj/item/lighter/conjured/set_lit(new_lit)
	if(!new_lit)
		return
	return ..()

/obj/item/lighter/conjured/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, TRAIT_GENERIC)
	set_light_on(TRUE)

/obj/item/lighter/conjured/flame
	light_range = 3
	light_power = 1
	light_color = COLOR_ORANGE

/obj/item/lighter/conjured/flame/afterattack(atom/target, mob/living/user, proximity_flag, click_parameters)
	if(proximity_flag && isliving(target))
		var/mob/living/L = target
		if(prob(25))
			L.adjust_fire_stacks(1)
			L.ignite_mob()
		playsound(src, 'modular_darkpack/modules/paths/sounds/fireball.ogg', 25, TRUE)

	return ..()

// Lure of Flames items
/obj/item/lighter/conjured/flame/candle
	name = "conjured candle"
	desc = "From your finger sprouts out the small flame of a candle."
	icon_state = "candle"
	inhand_icon_state = "candle"
	force = 10

/obj/item/lighter/conjured/flame/palm_of_flame
	name = "hand of flame"
	desc = "Your hand burns with supernatural fire."
	icon_state = "flame"
	inhand_icon_state = "flame"
	force = 15
	fancy = FALSE

// Levinbolt items
/obj/item/lighter/conjured/levinbolt_arm
	name = "illuminate"
	desc = "Your arm surges with electricity!"
	icon_state = "illuminate"
	inhand_icon_state = "illuminate"
	force = 10
	light_range = 2
	light_power = 1
	light_color = COLOR_WHITE
