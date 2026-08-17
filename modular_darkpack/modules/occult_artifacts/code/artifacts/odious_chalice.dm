/obj/item/occult_artifact/vampire/odious_chalice
	true_name = "Odious Chalice"
	true_desc = "Stores blood from every attack."
	icon_state = "o_chalice"
	var/stored_blood = 0
	var/blood_cap = 10
	research_value = 30
	COOLDOWN_DECLARE(chalice_alert_cooldown)
	COOLDOWN_DECLARE(feed_cooldown)

/obj/item/occult_artifact/vampire/odious_chalice/examine(mob/user)
	. = ..()
	if(identified)
		. += "[src] contains [stored_blood] blood points..."

/obj/item/occult_artifact/vampire/odious_chalice/grant_powers()
	. = ..()
	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_item_attack))
	RegisterSignal(owner, COMSIG_LIVING_UNARMED_ATTACK, PROC_REF(on_attack_hand))

/obj/item/occult_artifact/vampire/odious_chalice/ungrant_powers()
	. = ..()
	UnregisterSignal(owner, list(COMSIG_MOB_ITEM_ATTACK, COMSIG_LIVING_UNARMED_ATTACK))


/obj/item/occult_artifact/vampire/odious_chalice/proc/on_item_attack(mob/living/source, atom/attacked, list/modifiers)
	SIGNAL_HANDLER

	var/obj/item/weapon = source.get_active_held_item()
	if(!weapon.force)
		return
	if(weapon.damtype == STAMINA)
		return

	on_feed(source, attacked)

/obj/item/occult_artifact/vampire/odious_chalice/proc/on_attack_hand(mob/living/source, atom/target, proximity, modifiers)
	SIGNAL_HANDLER

	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		return
	if(!source.combat_mode)
		return

	on_feed(source, target)

/obj/item/occult_artifact/vampire/odious_chalice/proc/on_feed(mob/living/user, mob/living/target)
	if(!identified)
		return

	if(!istype(user) || !istype(target))
		return
	if(user == target)
		return
	if(user != owner)
		return // How? whatever.

	if(!target.bloodpool && !target.blood_volume)
		return

	if(!COOLDOWN_FINISHED(src, feed_cooldown))
		return
	COOLDOWN_START(src, feed_cooldown, 1 TURNS)

	if(stored_blood >= blood_cap)
		return

	Shake(duration = 0.5 SECONDS)

	stored_blood = min(stored_blood + 1, blood_cap)
	if(COOLDOWN_FINISHED(src, chalice_alert_cooldown))
		//rather spammy. 1 scene cooldown
		balloon_alert(user, "the chalice drinks...")
		COOLDOWN_START(src, chalice_alert_cooldown, 1 SCENES)

/obj/item/occult_artifact/vampire/odious_chalice/attack(mob/living/target_mob, mob/living/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(!get_splat_with_vitae(target_mob))
		return
	if(stored_blood <= 0)
		return
	if(!identified)
		return
	if(target_mob.bloodpool >= target_mob.maxbloodpool)
		return

	var/amount_to_spend = clamp(target_mob.maxbloodpool - target_mob.bloodpool, 0, stored_blood)

	target_mob.adjust_blood_pool(amount_to_spend)
	stored_blood -= amount_to_spend
	playsound(get_turf(target_mob), 'sound/items/drink.ogg', 50, TRUE)
	return
