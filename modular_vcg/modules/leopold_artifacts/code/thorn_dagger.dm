/obj/item/occult_artifact/holy/thorn_dagger
	name = "Odd Vine"
	desc = "An Odd Vine"
	true_name = "Dagger of Thorns"
	true_desc = "A Dagger made of thorns that inflicts aggravated wounds and destroys one blood with each hit."

	icon = 'modular_vcg/modules/leopold_artifacts/icons/relics.dmi'
	icon_state = "thorn_dagger"
	inhand_icon_state = "knife"
	lefthand_file = 'modular_darkpack/modules/deprecated/icons/lefthand.dmi'
	righthand_file = 'modular_darkpack/modules/deprecated/icons/righthand.dmi'
	worn_icon = 'modular_darkpack/modules/weapons/icons/worn_melee.dmi'
	worn_icon_state = "knife"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	ONFLOOR_ICONSTATE_HELPER("knife")

	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BELT
	sharpness = SHARP_EDGED
	hitsound = 'sound/items/weapons/slash.ogg'
	attack_verb_continuous = list("slashes", "cuts")
	attack_verb_simple = list("slash", "cut")
	force = 1.5 LETHAL_TTRPG_DAMAGE
	damtype = AGGRAVATED
	research_value = 0
	attack_speed = 0.4 SECONDS //Increases attack speed to increase use cases from crusader sword also speed shanking

/obj/item/occult_artifact/holy/thorn_dagger/afterattack(atom/target, mob/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(!isliving(target))
		return

	var/mob/living/victim = target
	if(victim.stat == DEAD || victim.bloodpool <= 1)
		return

	victim.adjust_blood_pool(-1)
	to_chat(victim, span_userdanger("You bleed from every orifice! You lose a blood point."))
