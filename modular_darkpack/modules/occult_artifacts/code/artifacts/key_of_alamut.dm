/obj/item/occult_artifact/vampire/key_of_alamut
	true_name = "Key of Alamut"
	true_desc = "Decreases incoming damage."
	icon_state = "k_alamut"
	research_value = 30
	var/damage_modifier = 1.2

/obj/item/occult_artifact/vampire/key_of_alamut/grant_powers()
	. = ..()
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMAGE_MODIFIERS, PROC_REF(on_owner_damage))

/obj/item/occult_artifact/vampire/key_of_alamut/ungrant_powers()
	. = ..()
	UnregisterSignal(owner, COMSIG_MOB_APPLY_DAMAGE_MODIFIERS)

/obj/item/occult_artifact/vampire/key_of_alamut/proc/on_owner_damage(mob/living/carbon/human/source, list/damage_mods, damage_amount, damagetype, def_zone, sharpness, attack_direction, obj/item/attacking_item)
	SIGNAL_HANDLER
	if(!istype(source))
		return
	damage_mods += damage_modifier
