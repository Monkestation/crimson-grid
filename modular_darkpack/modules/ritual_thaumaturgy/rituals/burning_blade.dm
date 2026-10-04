/obj/ritual_rune/thaumaturgy/burning_blade
	name = "burning blade"
	desc = "enchant a scythe to be consumed with flame and deal aggravated damage for a few swings. Look closer to recall what you can enchant."
	icon_state = "rune9"
	word = "Blade of fire."
	level = 2
	cost = 3
	/// List of weapons that can be enchanted
	var/static/list/valid_weapons = list(
		/obj/item/scythe/vamp,
		/obj/item/katana/vamp,
		/obj/item/knife/vamp,
		/obj/item/melee/sabre/rapier,
		/obj/item/claymore/longsword,
		/obj/item/melee/sabre/vamp
	)

/obj/ritual_rune/thaumaturgy/burning_blade/complete()
	. = ..()
	var/obj/item/weapon
	for(var/obj/item/item in get_turf(src))
		if(is_type_in_list(item, valid_weapons))
			weapon = item
			break
	if(!weapon)
		to_chat(last_activator, span_warning("You need one of the compatible weapons to enchant!"))
		return
	if(!ritual_roll_datum)
		return
	var/charges = ritual_roll_datum.last_sucess_amount
	weapon.AddComponent(/datum/component/burning_blade, charges)
	to_chat(last_activator, span_notice("[weapon] ignites with an unholy flame for [charges] swings!"))
	qdel(src)

/obj/ritual_rune/thaumaturgy/burning_blade/examine_more(mob/user)
	. = ..()
	. += span_cult("<i>You recall some of the weapons that can be enchanted...</i>")
	var/list/desc = list()
	for(var/obj/item/weapon as anything in valid_weapons)
		desc += "\a [initial(weapon.name)]"
	. += "\t[span_cult("[desc.Join("\n\t")]")]"

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
