/obj/ritual_rune/thaumaturgy/burning_blade
	name = "burning blade"
	desc = "enchant a scythe to be consumed with flame and deal aggravated damage for a few swings."
	icon_state = "rune9"
	word = "Blade of fire."
	level = 2
	cost = 3

/obj/ritual_rune/thaumaturgy/burning_blade/complete()
	. = ..()
	var/static/list/valid_weapons = list(
		/obj/item/scythe/vamp,
		/obj/item/katana/vamp
	)

	var/obj/item/weapon
	for(var/obj/item/item in get_turf(src))
		if(is_type_in_list(item, valid_weapons))
			weapon = item
			break
	if(!weapon)
		to_chat(last_activator, span_warning("You need a scythe or katana to enchant!"))
		return
	if(!ritual_roll_datum)
		return
	var/charges = ritual_roll_datum.last_sucess_amount
	weapon.AddComponent(/datum/component/burning_blade, charges)
	to_chat(last_activator, span_notice("[weapon] ignites with an unholy flame for [charges] swings!"))
	qdel(src)

// Turns a scythe/katana into their "weapon_burning" icon state, allowing tremeres to deal aggravated damage for a few swings.
/datum/component/burning_blade
	var/original_damtype
	var/original_icon_state
	var/original_inhand_icon_state
	var/charges

/datum/component/burning_blade/Initialize(charges)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	var/obj/item/weapon = parent
	src.charges = charges
	original_damtype = weapon.damtype
	original_icon_state = weapon.icon_state
	original_inhand_icon_state = weapon.inhand_icon_state
	weapon.damtype = AGGRAVATED
	weapon.icon_state = weapon.icon_state + "_burning"
	weapon.inhand_icon_state = weapon.inhand_icon_state + "_burning"

	return ..()

/datum/component/burning_blade/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ITEM_ATTACK, PROC_REF(on_hit_living))

/datum/component/burning_blade/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_ITEM_ATTACK))

	var/obj/item/weapon = parent
	weapon.damtype = original_damtype
	weapon.icon_state = original_icon_state
	weapon.inhand_icon_state = original_inhand_icon_state

/datum/component/burning_blade/proc/on_hit_living()
	SIGNAL_HANDLER
	charges--
	if(charges <= 0)
		qdel(src)
