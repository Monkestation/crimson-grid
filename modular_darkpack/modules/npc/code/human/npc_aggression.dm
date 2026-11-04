/mob/living/carbon/human/npc/proc/Aggro(mob/living/victim, attacked = FALSE)
	if (stat == DEAD)
		return
	if (attacked && danger_source != victim)
		GLOB.move_manager.stop_looping(src)
	if (victim == src)
		return
	if (isnpc(victim))
		return

	// If the victim doesn't appear dead, enter combat mode and set
	// them as the NPC's danger source.
	if (!HAS_TRAIT(victim, TRAIT_DEATHCOMA))
		set_combat_mode(TRUE)
		if (move_intent == MOVE_INTENT_WALK)
			toggle_move_intent()

		danger_source = victim
		if(attacked)
			last_attacker = victim
			if(health != last_health)
				last_health = health
				last_damager = victim
		remember_combatant(victim) // CORVAX EDIT ADD

	if (!can_npc_move())
		return
	if ((last_antagonised + 5 SECONDS) >= world.time)
		return
	last_antagonised = world.time

	if (prob(50))
		if (!my_weapon && prob(50))
			emote("scream")
		else
			realistic_say(pick(socialrole.help_phrases))

/mob/living/carbon/human/npc/proc/end_combat()
	danger_source = null
	if (has_weapon)
		if (get_active_held_item() == my_weapon)
			npc_stow_weapon()
		else
			has_weapon = FALSE
	walktarget = ChoosePath()

	set_combat_mode(FALSE)
	if (move_intent == MOVE_INTENT_RUN)
		toggle_move_intent()

/mob/living/carbon/human/npc/proc/handle_gun(obj/item/gun/ballistic/weapon, mob/living/user, atom/target, params, zone_override)
	SIGNAL_HANDLER

	if(weapon.loc != src)
		UnregisterSignal(weapon, COMSIG_GUN_FIRED)
		UnregisterSignal(weapon, COMSIG_GUN_EMPTY)
		return

	if(!istype(weapon, /obj/item/gun/ballistic))
		return

	if(istype(weapon.magazine, /obj/item/ammo_box/magazine/internal))
		var/obj/item/ammo_box/magazine/internal_mag = weapon.magazine
		if(extra_loaded_rounds)
			internal_mag.give_round(new internal_mag.ammo_type())
			extra_loaded_rounds--
		addtimer(CALLBACK(src, PROC_REF(rack_held_gun), weapon), weapon.rack_delay)
		return

	if(!weapon.magazine.ammo_count() && extra_mags)
		extra_mags--
		weapon.eject_magazine_npc(src, new weapon.spawn_magazine_type(src))
		weapon.rack(src)
		if(!weapon.chambered)
			weapon.chamber_round()

/mob/living/carbon/human/npc/proc/rack_held_gun(obj/item/gun/ballistic/weapon)
	if(weapon.bolt_locked)
		weapon.drop_bolt()
	weapon.rack(src)

/mob/living/carbon/human/npc/proc/handle_empty_gun()
	SIGNAL_HANDLER

	UnregisterSignal(my_weapon, COMSIG_GUN_FIRED)
	UnregisterSignal(my_weapon, COMSIG_GUN_EMPTY)
	npc_stow_weapon()

	if (!my_backup_weapon || spawned_backup_weapon)
		return
	npc_draw_backup_weapon()
	my_weapon = my_backup_weapon
	spawned_backup_weapon = TRUE

/mob/living/carbon/human/npc/proc/npc_stow_weapon()
	if (!my_weapon)
		return

	REMOVE_TRAIT(my_weapon, TRAIT_NODROP, NPC_ITEM_TRAIT)
	temporarilyRemoveItemFromInventory(my_weapon, TRUE)
	equip_to_appropriate_slot(my_weapon)
	ADD_TRAIT(my_weapon, TRAIT_NODROP, NPC_ITEM_TRAIT)
	spawned_weapon = FALSE

/mob/living/carbon/human/npc/proc/npc_draw_weapon()
	if (!my_weapon)
		return

	REMOVE_TRAIT(my_weapon, TRAIT_NODROP, NPC_ITEM_TRAIT)
	temporarilyRemoveItemFromInventory(my_weapon, TRUE)
	put_in_active_hand(my_weapon)
	ADD_TRAIT(my_weapon, TRAIT_NODROP, NPC_ITEM_TRAIT)
	spawned_weapon = TRUE

/mob/living/carbon/human/npc/proc/npc_draw_backup_weapon()
	if (!my_backup_weapon)
		return

	REMOVE_TRAIT(my_backup_weapon, TRAIT_NODROP, NPC_ITEM_TRAIT)
	temporarilyRemoveItemFromInventory(my_backup_weapon, TRUE)
	put_in_active_hand(my_backup_weapon)
	ADD_TRAIT(my_backup_weapon, TRAIT_NODROP, NPC_ITEM_TRAIT)
	spawned_weapon = TRUE

/obj/item/gun/ballistic/proc/eject_magazine_npc(mob/user, obj/item/ammo_box/magazine/tac_load = null)
	if(bolt_type == BOLT_TYPE_OPEN)
		chambered = null
	if (magazine.ammo_count())
		playsound(src, load_sound, load_sound_volume, load_sound_vary)
	else
		playsound(src, load_empty_sound, load_sound_volume, load_sound_vary)
	magazine.forceMove(drop_location())
	var/obj/item/ammo_box/magazine/old_mag = magazine

	if (tac_load)
		tac_load.forceMove(src)
		if (bolt_type == BOLT_TYPE_OPEN && !bolt_locked)
			chamber_round(TRUE)
		magazine = tac_load
	else
		magazine = null

	old_mag.forceMove(get_turf(user))
	old_mag.update_icon()
	update_icon()
