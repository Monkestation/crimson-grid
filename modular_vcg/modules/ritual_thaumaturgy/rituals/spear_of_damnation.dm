/obj/ritual_rune/thaumaturgy/spear_of_damnation
	name = "wield the spear of damnation"
	desc = "Этот ритуал обращается к самой легенде о Каине, посвящая оружие удовлетворению природы вампира.\
			Половина летального урона, нанесённого этим оружием, превращается в пункты крови, наполняя запас владельца."
	icon_state = "rune9"
	// Whisper this because...we are saying it outloud as we engrave it I guess
	word = "#И сказал: 'что ты сделал? голос крови брата твоего вопиет ко Мне от земли.'"
	level = 3
	cost = 3

/obj/ritual_rune/thaumaturgy/spear_of_damnation/complete()
	. = ..()

	var/obj/item/weapon

	for(var/obj/item/item in get_turf(src))
		if(!(item.get_sharpness() & SHARP_EDGED) && !(item.get_sharpness() & SHARP_POINTY))
			to_chat(last_activator, span_warning("Предмет должен быть острым!"))
			break
		else
			weapon = item

	if(!weapon)
		to_chat(last_activator, span_warning("Вам нужен предмет для зачарования!"))
		return

	if(!ritual_roll_datum)
		return

	// Amount of blood we can steal equals to success count + thaum discipline level
	var/blood_to_steal = last_sucess_amount + last_activator.get_discipline_dots(/datum/discipline/thaumaturgy)
	// Amount of BP harvested is proportional to half lethal damage done
	var/theft_per_hit = round(weapon.force / (2 LETHAL_TTRPG_DAMAGE), 0.1)

	weapon.AddComponent(/datum/component/blood_theft, blood_to_steal, theft_per_hit)
	to_chat(last_activator, span_notice("[capitalize(weapon.declent_ru(NOMINATIVE))] впитает в общей сложности [blood_to_steal] пунктов крови, собирая [theft_per_hit] за удар!"))
	last_activator.visible_message(span_notice("[capitalize(last_activator.declent_ru(NOMINATIVE))] что-то пишет на [weapon.declent_ru(PREPOSITIONAL)]!"))
	qdel(src)

/**
 * Blood theft component
 *
 * Can be applied to any item, on hit takes target's blood points
 * and gives them to the user
 *
 */
/datum/component/blood_theft
	/// How many bloodpoints we have left to steal
	var/blood_to_steal
	/// Amount of BP stolen per hit
	var/theft_per_hit

/datum/component/blood_theft/Initialize(blood_to_steal, theft_per_hit)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	src.blood_to_steal = blood_to_steal
	src.theft_per_hit = theft_per_hit

	return ..()

/datum/component/blood_theft/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ITEM_ATTACK, PROC_REF(on_successful_attack))
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/datum/component/blood_theft/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_ITEM_ATTACK))

/datum/component/blood_theft/proc/on_examine(datum/source, mob/viewer, list/examine_list)
	SIGNAL_HANDLER

	examine_list += span_cult("Вы видите какие-то странные слова, выгравированные на [parent.declent_ru(PREPOSITIONAL)]...")

/// Signal handler for landing a hit on the target
/datum/component/blood_theft/proc/on_successful_attack(datum/source, mob/living/target, mob/user, list/modifiers)
	SIGNAL_HANDLER

	if(!isliving(target) || !isliving(user))
		return

	steal_blood(user, target)

/// Take BP from targets, appropriately adjust blood pools of both
/datum/component/blood_theft/proc/steal_blood(mob/living/thief, mob/living/target)
	// Make sure we can't steal more than we have left to
	var/bp_theft_amount = clamp(theft_per_hit, 0, blood_to_steal)

	if(get_kindred_splat(target) || get_ghoul_splat(target))
		var/blood_taken = clamp(bp_theft_amount, 0, target.bloodpool)
		target.adjust_blood_pool(-blood_taken)

		var/blood_gained = blood_taken * max(1, target.bloodquality-1)
		thief.adjust_blood_pool(blood_gained)

		blood_to_steal -= blood_taken
	else
		if(!target.bloodpool || !target.blood_volume)
			return

		var/blood_coefficient = (5 / target.bloodpool)

		var/blood_taken = clamp(bp_theft_amount, 0, target.bloodpool)
		target.blood_volume = max(0, (target.blood_volume - (blood_taken * (70 * blood_coefficient))))
		blood_to_steal -= blood_taken

		var/blood_gained = blood_taken * max(1, target.bloodquality - 1)
		target.adjust_blood_pool(-blood_gained)
		thief.adjust_blood_pool(blood_gained)

	// Remove our component once we run out of blood to steal
	if(blood_to_steal <= 0)
		qdel(src)
