/* // DARKPACK TODO - Gas should be handled as a reagent
/datum/reagent/gasoline
	name = "Gasoline"
	color = "#b85614"

/obj/item/reagent_containers/cup/gas_can
	name = "gas can"
	desc = "Stores gasoline or pure fire death."
	icon_state = "gasoline"
	icon = 'modular_darkpack/modules/deprecated/icons/items.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/deprecated/icons/onfloor.dmi')
	lefthand_file = 'modular_darkpack/modules/deprecated/icons/righthand.dmi'
	righthand_file = 'modular_darkpack/modules/deprecated/icons/lefthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	list_reagents = list(/datum/reagent/gasoline = 200)
*/

/obj/item/gas_can
	name = "gas can"
	desc = "Stores gasoline or pure fire death."
	icon_state = "gasoline"
	icon = 'modular_darkpack/modules/deprecated/icons/items.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/deprecated/icons/onfloor.dmi')
	lefthand_file = 'modular_darkpack/modules/deprecated/icons/righthand.dmi'
	righthand_file = 'modular_darkpack/modules/deprecated/icons/lefthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	var/stored_gasoline = 0

/obj/item/gas_can/examine(mob/user)
	. = ..()
	. += "<b>Gas</b>: [stored_gasoline]/1000"

/obj/item/gas_can/full
	custom_price = 250 // ECONOMY
	stored_gasoline = 1000

/obj/item/gas_can/rand

/obj/item/gas_can/rand/Initialize(mapload)
	. = ..()
	stored_gasoline = rand(0, 500)

/obj/item/gas_can/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(istype(interacting_with, /obj/darkpack_car) || istype(interacting_with, /obj/structure/fuelstation) || istype(interacting_with, /mob/living/carbon/human))
		return NONE
	var/turf/our_turf = get_turf(interacting_with)
	if(!isgroundlessturf(our_turf))
		if(locate(/obj/effect/decal/cleanable/gasoline) in our_turf)
			return ITEM_INTERACT_BLOCKING
		if(stored_gasoline < 50)
			return ITEM_INTERACT_BLOCKING
		stored_gasoline = max(0, stored_gasoline-50)
		new /obj/effect/decal/cleanable/gasoline(our_turf)
		playsound(get_turf(src), 'modular_darkpack/modules/cars/sounds/gas_splat.ogg', 50, TRUE)
		user.log_message("poured gasoline on [interacting_with].", LOG_GAME)
		return ITEM_INTERACT_SUCCESS

/obj/item/gas_can/afterattack(atom/target, mob/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = target
		if(stored_gasoline < 50)
			return
		stored_gasoline = max(0, stored_gasoline-50)
		H.fire_stacks = min(10, H.fire_stacks+10)
		playsound(get_turf(H), 'modular_darkpack/modules/cars/sounds/gas_splat.ogg', 50, TRUE)
		user.visible_message(span_warning("[user] covers [target] in something flammable!"))
		log_combat(user, target, "poured gasoline on")

/obj/effect/decal/cleanable/gasoline
	name = "gasoline"
	desc = "I HOPE YOU DIE IN A FIRE!!!"
	icon = 'modular_darkpack/modules/cars/icons/water.dmi'
	icon_state = "water"
	base_icon_state = "water"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_SPILL
	canSmoothWith = SMOOTH_GROUP_SPILL + SMOOTH_GROUP_WALLS
	resistance_flags = UNACIDABLE | ACID_PROOF
	//mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	beauty = -50
	alpha = 64
	color = "#c6845b"

/obj/effect/decal/cleanable/gasoline/update_icon(updates=ALL)
	. = ..()
	if((updates & UPDATE_SMOOTHING) && (smoothing_flags & USES_SMOOTHING))
		QUEUE_SMOOTH(src)
		QUEUE_SMOOTH_NEIGHBORS(src)

/*
/obj/effect/decal/cleanable/gasoline/Crossed(atom/movable/AM, oldloc)
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.on_fire)
			var/obj/effect/abstract/turf_fire/F = locate() in get_turf(src)
			if(!F)
				new /obj/effect/abstract/turf_fire(get_turf(src))
	. = ..()
*/

/obj/effect/decal/cleanable/gasoline/Initialize(mapload)
	. = ..()
	var/turf/open/my_turf = get_turf(src)
	if(istype(my_turf))
		my_turf.flammability += 5
	if(smoothing_flags & USES_SMOOTHING)
		QUEUE_SMOOTH(src)
		QUEUE_SMOOTH_NEIGHBORS(src)

/obj/effect/decal/cleanable/gasoline/Destroy()
	var/turf/open/my_turf = get_turf(src)
	if(istype(my_turf))
		my_turf.flammability -= 5 // Technicly no validtiy for if its the same turf we started on. Making something less flamible is a nothing burger tho
	QUEUE_SMOOTH_NEIGHBORS(src)
	return ..()

/obj/effect/decal/cleanable/gasoline/fire_act(exposed_temperature, exposed_volume)
	var/turf/open/gas_turf = get_turf(src)
	if(isopenturf(gas_turf))
		gas_turf.ignite_turf(30 + gas_turf.flammability)
	addtimer(CALLBACK(src, PROC_REF(ignite_others)), 0.5 SECONDS)
	. = ..()

/obj/effect/decal/cleanable/gasoline/proc/ignite_others()
	for(var/obj/effect/decal/cleanable/gasoline/oil in range(1, get_turf(src)))
		if(prob(25))
			continue
		oil.fire_act()

/obj/effect/decal/cleanable/gasoline/attackby(obj/item/tool, mob/living/user)
	var/attacked_by_hot_thing = tool.get_temperature()
	if(attacked_by_hot_thing)
		visible_message(span_warning("[user] tries to ignite [src] with [tool]!"), span_warning("You try to ignite [src] with [tool]."))
		log_combat(user, src, (attacked_by_hot_thing < 480) ? "tried to ignite" : "ignited", tool)
		fire_act(attacked_by_hot_thing)
		return
	return ..()

/obj/structure/fuelstation
	name = "fuel station"
	desc = "Fuel your car here. 50 dollars per 1000 units."
	icon = 'modular_darkpack/modules/deprecated/icons/props.dmi'
	icon_state = "fuelstation"
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	var/stored_money = 0

/obj/structure/fuelstation/click_alt(mob/user)
	if(stored_money > 0)
		say("Money refunded.")
		var/money_to_spawn = min(stored_money, /obj/item/stack/dollar::max_amount)
		new /obj/item/stack/dollar(loc, money_to_spawn)
		stored_money -= money_to_spawn
		return CLICK_ACTION_SUCCESS

/obj/structure/fuelstation/examine(mob/user)
	. = ..()
	. += "<b>Balance</b>: [stored_money] [MONEY_NAME]"

/obj/structure/fuelstation/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(iscash(tool))
		stored_money += tool.get_item_credit_value()
		to_chat(user, span_notice("You insert [tool.get_item_credit_value()] [MONEY_NAME] into [src]."))
		qdel(tool)
		say("Payment received.")
		return ITEM_INTERACT_SUCCESS
	if(istype(tool, /obj/item/gas_can))
		var/obj/item/gas_can/G = tool
		if(G.stored_gasoline < 1000 && stored_money)
			var/gas_to_dispense = min(stored_money*20, 1000-G.stored_gasoline)
			var/money_to_spend = round(gas_to_dispense/20)
			G.stored_gasoline = min(1000, G.stored_gasoline+gas_to_dispense)
			stored_money = max(0, stored_money-money_to_spend)
			playsound(loc, 'modular_darkpack/master_files/sounds/effects/gas_fill.ogg', 50, TRUE)
			to_chat(user, span_notice("You fill [tool]."))
			say("Gas filled.")
			return ITEM_INTERACT_SUCCESS
		return ITEM_INTERACT_BLOCKING
	return NONE
