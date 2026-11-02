/obj/item/occult_artifact/holy/thorn_dagger
	name = "Odd Vine"
	desc = "An Odd Vine"
	true_name = "Dagger of Thorns"
	true_desc = "A Dagger made of thorns that inflicts aggravated wounds and destroys one blood with each hit."

	icon = 'modular_vcg/modules/leopold_artifacts/icons/relics.dmi'
	icon_state = "thorn_dagger"
	inhand_icon_state = "thorn_dagger"
	lefthand_file = 'modular_vcg/modules/leopold_artifacts/icons/relic_inhand_left.dmi'
	righthand_file = 'modular_vcg/modules/leopold_artifacts/icons/relic_inhand_right.dmi'
	worn_icon = 'modular_vcg/modules/leopold_artifacts/icons/relics_worn.dmi'
	worn_icon_state = "thorn_dagger"
	ONFLOOR_ICON_HELPER('modular_vcg/modules/leopold_artifacts/icons/relic_floor.dmi')

	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BELT
	sharpness = SHARP_EDGED
	hitsound = 'sound/items/weapons/slash.ogg'
	attack_verb_continuous = list("slashes", "cuts")
	attack_verb_simple = list("slash", "cut")
	force = 1.5 LETHAL_TTRPG_DAMAGE
	damtype = BRUTE//Changed to brute blood stealer 9000 still works tho for shankin
	research_value = 0
	attack_speed = 0.4 SECONDS //Increases attack speed to increase use cases from crusader sword also speed shanking

/obj/item/occult_artifact/holy/thorn_dagger/afterattack(atom/target, mob/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(!identified ||!isliving(target))
		return

	var/mob/living/victim = target
	if(victim.stat == DEAD || victim.bloodpool <= 1)
		return

	victim.adjust_blood_pool(-1)
	to_chat(victim, span_userdanger("You bleed from every orifice! You lose a blood point."))
