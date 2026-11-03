// Wooden Bolt
/obj/projectile/bullet/wooden_bolt
	name = "wooden bolt"
	damage = 20
	armour_penetration = 40
	exposed_wound_bonus = 20
	wound_bonus = 20
	sharpness = SHARP_POINTY
	embed_type = /datum/embedding/stake/wooden_bolt
	shrapnel_type = /obj/item/ammo_casing/caseless/bolt/wooden

/datum/embedding/stake/wooden_bolt
	embed_chance = 90
	fall_chance = 25
	var/pierce_resistance_chance = 35
	var/armor_pierce_penalty = 20
	immune_traits = list(TRAIT_STAKE_IMMUNE)

/datum/embedding/stake/wooden_bolt/can_embed(atom/movable/source, mob/living/carbon/victim, hit_zone, datum/thrownthing/throwingdatum)
	if(!..())
		return FALSE

	if(HAS_TRAIT(victim, TRAIT_STAKE_IMMUNE))
		return FALSE

	if(ishuman(victim) && hit_zone == BODY_ZONE_CHEST)
		var/mob/living/carbon/human/H = victim
		var/obj/item/clothing/armor_item = H.get_item_by_slot(ITEM_SLOT_OCLOTHING) || H.get_item_by_slot(ITEM_SLOT_ICLOTHING)

		if(istype(armor_item))
			var/armor_val = max(armor_item.armor["melee"], armor_item.armor["bullet"])

			if(armor_val > 30)
				var/penalty_steps = (armor_val - 30) / 10
				var/armor_pierce_chance = max(0, 100 - (penalty_steps * armor_pierce_penalty))

				if(!prob(armor_pierce_chance))
					H.visible_message(
						span_warning("Деревянный болт отскакивает от брони [H.declent_ru(GENITIVE)]!"),
						span_warning("Деревянный болт отскакивает от вашей брони!")
					)
					return FALSE
				else
					H.visible_message(
						span_warning("Деревянный болт с трудом пробивает броню [H.declent_ru(GENITIVE)]!"),
						span_warning("Деревянный болт с трудом пробивает вашу броню!")
					)

	if(HAS_TRAIT(victim, TRAIT_STAKE_RESISTANT))
		if(!prob(pierce_resistance_chance))
			victim.visible_message(
				span_warning("Деревянный болт разлетается в щепки, едва коснувшись сердца [victim.declent_ru(GENITIVE)]!"),
				span_warning("Деревянный болт разлетается в щепки, едва коснувшись вашего сердца!")
			)
			return FALSE
		REMOVE_TRAIT(victim, TRAIT_STAKE_RESISTANT, MAGIC_TRAIT)
		victim.visible_message(
			span_warning("Деревянный болт пробивает защиту [victim.declent_ru(GENITIVE)]!"),
			span_danger("Деревянный болт пробивает вашу защиту!")
		)
	return TRUE

/datum/embedding/stake/wooden_bolt/set_owner(mob/living/carbon/victim, obj/item/bodypart/target_limb)
	if(istype(target_limb) && target_limb.body_zone == BODY_ZONE_CHEST)
		return ..()

	owner = victim

	if(target_limb)
		victim.visible_message(
			span_warning("Деревянный болт впивается в [target_limb.declent_ru(ACCUSATIVE)], но не находит сердца."),
			span_warning("Деревянный болт впивается в вас, но не находит сердца.")
		)
