/obj/ritual_rune/thaumaturgy/ward_item
	name = "ward versus ghouls"
	desc = "Mark a material object with a glyph drawn out of blood\
			Causing any ghoul who touches the object to feel intense pain."
	icon_state = "rune9"
	word = ""
	level = 2
	cost = 3
	var/list/targeted_splats = list(SPLAT_GHOUL)

/obj/ritual_rune/thaumaturgy/ward_item/lupine
	name = "ward versus lupine"
	desc = "Mark a material object with a glyph drawn out of silver\
			Causing any lupine who touches the object to feel intense pain."
	level = 3
	sacrifices = list(/obj/item/card/hunter/silver)
	targeted_splats = list(SPLAT_GAROU)

/obj/ritual_rune/thaumaturgy/ward_item/kindred
	name = "ward versus kindred"
	desc = "Mark a material object with a glyph drawn out of blood\
			Causing any kindred who touches the object to feel intense pain."
	level = 4
	targeted_splats = list(SPLAT_KINDRED)

/obj/ritual_rune/thaumaturgy/ward_item/complete()
	. = ..()

	var/obj/item/weapon

	for(var/obj/item/item in get_turf(src))
		weapon = item

	if(!weapon)
		to_chat(last_activator, span_warning("You need an item to ward!"))
		return

	if(!ritual_roll_datum)
		return

	var/charges = last_sucess_amount
	weapon.AddComponent(/datum/component/ward_item, targeted_splats, charges)
	to_chat(last_activator, span_notice("[weapon] will work as a ward for [charges] times"))
	last_activator.visible_message(span_notice("[last_activator] incantates something upon [weapon]!"))

	qdel(src)

/datum/component/ward_item
	var/list/targeted_splats
	var/charges
	var/datum/storyteller_roll/identify_occult/notice_roll

/datum/component/ward_item/Initialize(targeted_splats, charges)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	src.targeted_splats = targeted_splats
	src.charges = charges

	return ..()

/datum/component/ward_item/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ITEM_ATTACK, PROC_REF(on_successful_attack))
	RegisterSignal(parent, COMSIG_ITEM_PICKUP, PROC_REF(on_pickup))
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/datum/component/ward_item/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_ITEM_ATTACK, COMSIG_ITEM_PICKUP, COMSIG_ATOM_EXAMINE))

/datum/component/ward_item/proc/on_examine(datum/source, mob/viewer, list/examine_list)
	SIGNAL_HANDLER
	if(!isliving(viewer))
		return
	if(!notice_roll)
		notice_roll = new()
		notice_roll.roll_output_type_on_fail = NONE
	if(notice_roll.st_roll(viewer, parent) == ROLL_SUCCESS)
		examine_list += span_cult("There's a weird glyph on it.")

/datum/component/ward_item/proc/on_successful_attack(datum/source, mob/living/target, mob/user, list/modifiers)
	SIGNAL_HANDLER
	trigger_ward(target)

/datum/component/ward_item/proc/on_pickup(datum/source, mob/taker)
	SIGNAL_HANDLER
	trigger_ward(taker)

/datum/component/ward_item/proc/trigger_ward(mob/living/victim)
	if(!isliving(victim))
		return

	var/isTarget = FALSE
	for(var/datum/splat/splat as anything in victim.splats)
		if(splat.id in targeted_splats)
			isTarget = TRUE
	if(!isTarget)
		return

	victim.apply_damage(3 LETHAL_TTRPG_DAMAGE, BRUTE)
	victim.AdjustKnockdown(4 SECONDS, daze_amount = 3 SECONDS)
	to_chat(victim, span_warning("You feel immense pain as you make contact with [parent]!"))
	charges -= 1
	if (charges <= 0)
		qdel(src)
