/datum/discipline/quietus
	name = "Quietus"
	desc = "The signature discipline of the Banu Haqim, Quietus allows the user to create poison and assassinate their targets quietly, maipulating their blood. Violates Masquerade."
	icon_state = "quietus"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/quietus
	signature_clan = VAMPIRE_CLAN_BANU_HAQIM

/datum/discipline_power/quietus
	name = "Quietus power name"
	desc = "Quietus power description"

	activate_sound = 'modular_darkpack/modules/powers/sounds/quietus.ogg' // REPLACE THIS PRICE IS RIGHT ASS SOUND!!!

//SILENCE OF DEATH
/datum/discipline_power/quietus/silence_of_death
	name = "Silence of Death"
	desc = "Create an area of pure silence around you, deafening the screams of your targets. This mystical silence radiates from your body, muting all noise within a 7 tile radius."

	level = 1
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_LYING
	vitae_cost = 1
	cancelable = TRUE

	duration_length = 1 SCENES
	cooldown_length = 2 SCENES
	var/datum/proximity_monitor/advanced/silence_of_death/silence_field

/datum/discipline_power/quietus/silence_of_death/activate()
	. = ..()
	silence_field = new(owner, 7, FALSE)

/datum/discipline_power/quietus/silence_of_death/deactivate(atom/target, direct = FALSE)
	. = ..()
	QDEL_NULL(silence_field)


/datum/storyteller_roll/scorpions_touch
	applicable_stats = list(STAT_PERMANENT_WILLPOWER)
	numerical = TRUE

//SCORPIONS TOUCH
/datum/discipline_power/quietus/scorpions_touch
	name = "Scorpion's Touch"
	desc = "Create a powerful venom to destroy your target's Stamina."

	level = 2
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_LYING | DISC_CHECK_FREE_HAND
	vitae_cost = 0
	violates_masquerade = TRUE
	cooldown_length = 1 MINUTES
	var/blood_converted
	var/debuff_duration

/datum/discipline_power/quietus/scorpions_touch/pre_activation_checks(atom/target)
	. = ..()
	var/success_count = SSroll.storyteller_roll_datum(owner, roll_datum = /datum/storyteller_roll/scorpions_touch)

	if(success_count <= 0)
		to_chat(owner, span_warning("Your blood fails to transform into poison!"))
		return FALSE

	switch(success_count)
		if(1)
			debuff_duration = 5 TURNS
		if(2)
			debuff_duration = 10 TURNS
		if(3)
			debuff_duration = 20 TURNS
		if(4)
			debuff_duration = 5 MINUTES
		if(5 to INFINITY)
			debuff_duration = 2 SCENES

	//the book says they can use however many dots in stamina they have to convert bloodpoints into poison just FYI
	//so if this were to be lore accurate max_conversion would be owner.st_get_stat(STAT_STAMINA), but it also says 0 stamina = instant torpor so...
	var/max_conversion = 2 // 2 bps max for the stat mod reduction since instantly torporing people is bad
	var/list/bp_options = list()
	for(var/i in 1 to min(max_conversion, owner.bloodpool))
		bp_options += i

	blood_converted = tgui_input_list(owner, "How many blood points will you use to create this toxin?", "Scorpion's Touch", bp_options)
	if(!blood_converted)
		return FALSE

	owner.adjust_blood_pool(-blood_converted)

	return TRUE

/datum/discipline_power/quietus/scorpions_touch/activate()
	. = ..()
	var/obj/item/held_weapon = owner.get_active_held_item()
	if(held_weapon && isitem(held_weapon))
		if(held_weapon.GetComponent(/datum/component/scorpions_touch_poison))
			to_chat(owner, span_warning("[held_weapon] is already poisoned!"))
			return

		held_weapon.AddComponent(/datum/component/scorpions_touch_poison, blood_converted, debuff_duration)
		to_chat(owner, span_notice("You coat [held_weapon] with your venomous blood!"))
	else
		owner.drop_all_held_items()
		//Banu Haqim can 'spit' this venom too - perhaps throw the touch attack item...?
		var/obj/item/melee/touch_attack/quietus/touch = new(owner.loc, blood_converted, debuff_duration)
		owner.put_in_active_hand(touch)

//DAGON'S CALL
/datum/discipline_power/quietus/dagons_call
	name = "Dagon's Call"
	desc = "Curse anyone you've touched in the last hour to drown in their own blood."

	level = 3
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_LYING
	vitae_cost = 0
	//willpower_cost = 1
	cooldown_length = 5 SECONDS

	var/list/marked_targets = list()

/datum/discipline_power/quietus/dagons_call/post_gain()
	. = ..()
	RegisterSignal(owner, COMSIG_HUMAN_PUNCHED, PROC_REF(on_punch))
	RegisterSignal(owner, COMSIG_HUMAN_GOT_PUNCHED, PROC_REF(on_punch))
	RegisterSignal(owner, COMSIG_CARBON_HELP_ACT, PROC_REF(on_touch))
	RegisterSignal(owner, COMSIG_CARBON_HELPED, PROC_REF(on_touch))

/datum/discipline_power/quietus/dagons_call/Destroy()
	UnregisterSignal(owner, list(COMSIG_HUMAN_PUNCHED, COMSIG_CARBON_HELP_ACT, COMSIG_CARBON_HELPED))
	marked_targets.Cut()
	return ..()

/datum/discipline_power/quietus/dagons_call/proc/on_punch(datum/source, mob/living/carbon/human/victim)
	SIGNAL_HANDLER
	mark_target(victim)

/datum/discipline_power/quietus/dagons_call/proc/on_touch(datum/source, mob/living/carbon/human/target)
	SIGNAL_HANDLER
	mark_target(target)

/datum/discipline_power/quietus/dagons_call/proc/mark_target(mob/living/carbon/human/target)
	if(!target || !ishuman(target) || target == owner)
		return

	var/datum/weakref/target_ref = WEAKREF(target)
	marked_targets[target_ref] = world.time

	to_chat(owner, span_notice("You mark [target] with your touch."))

/datum/discipline_power/quietus/dagons_call/proc/get_valid_targets()
	var/list/valid = list()
	var/current_time = world.time

	for(var/datum/weakref/target_ref as anything in marked_targets)
		var/mark_time = marked_targets[target_ref]

		if(current_time - mark_time > 20 MINUTES)
			marked_targets -= target_ref
			continue

		var/mob/living/carbon/human/target = target_ref.resolve()
		if(!target || QDELETED(target))
			marked_targets -= target_ref
			continue

		valid[target] = mark_time

	return valid

/datum/discipline_power/quietus/dagons_call/pre_activation_checks(atom/target)
	. = ..()

	var/list/valid_targets = get_valid_targets()

	if(!length(valid_targets))
		to_chat(owner, span_warning("You haven't marked anyone with your touch yet!"))
		return FALSE

	return TRUE

/datum/discipline_power/quietus/dagons_call/activate()
	. = ..()

	var/list/valid_targets = get_valid_targets()
	var/list/target_names = list()

	for(var/mob/living/carbon/human/target as anything in valid_targets)
		target_names[target.name] = target

	var/chosen_name = tgui_input_list(owner, "Choose your target:", "Dagon's Call", target_names)
	if(!chosen_name)
		return

	var/mob/living/carbon/human/victim = target_names[chosen_name]
	strike_victim(victim)

/datum/discipline_power/quietus/dagons_call/proc/strike_victim(mob/living/carbon/human/victim)
	var/victim_willpower = victim.st_get_stat(STAT_PERMANENT_WILLPOWER)

	var/attacker_successes = SSroll.storyteller_roll_datum(owner, victim, difficulty = victim_willpower, applic_stats = list(STAT_STAMINA), numerical = TRUE)
	var/victim_successes = SSroll.storyteller_roll_datum(victim, owner, difficulty = victim_willpower, applic_stats = list(STAT_STAMINA), numerical = TRUE)

	var/net_successes = attacker_successes - victim_successes

	if(net_successes <= 0)
		to_chat(owner, span_warning("[victim] resists Dargon's Call."))
		return

	victim.adjust_fire_loss(10 * net_successes)

	to_chat(owner, span_boldwarning("You invoke Dagon's Call on [victim], choking them with their own blood!"))
	to_chat(victim, span_userdanger("Your blood vessels burst as you drown in your own blood!"))

	if(victim.stat != DEAD)
		var/continue_call = tgui_alert(owner, "Continue Dagon's Call for 1 additional Willpower?", "Dagon's Call", list("Yes", "No"))
		if(continue_call == "Yes" && owner.st_add_stat_mod(STAT_TEMPORARY_WILLPOWER, -1, "Dagon's Call")) //requires stat preferences pr
			strike_victim(victim)

//BAAL'S CARESS
/datum/discipline_power/quietus/baals_caress
	name = "Baal's Caress"
	desc = "Transmute your vitae into a toxin that destroys all flesh it touches."

	level = 4
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_LYING | DISC_CHECK_FREE_HAND
	vitae_cost = 0
	target_type = TARGET_OBJ
	range = 1

	violates_masquerade = TRUE

	cooldown_length = 15 SECONDS

/datum/discipline_power/quietus/baals_caress/can_activate(atom/target)
	. = ..()
	if(!isitem(target))
		to_chat(owner, span_warning("[src] can only be used on weapons!"))
		return FALSE

	var/obj/item/weapon = target

	if(!weapon.sharpness)
		to_chat(owner, span_warning("[src] can only be used on bladed weapons!"))
		return FALSE

	if(weapon.GetComponent(/datum/component/baals_caress))
		to_chat(owner, span_warning("This weapon is already poisoned!"))
		return FALSE

/datum/discipline_power/quietus/baals_caress/activate(obj/item/melee/vamp/target)
	. = ..()

	if(!ishuman(owner))
		return

	var/mob/living/carbon/human/user = owner
	var/max_layers = user.bloodpool

	if(max_layers <= 0)
		to_chat(owner, span_warning("You don't have any blood to coat the weapon with!"))
		return

	var/layers = tgui_input_number(owner, "How many blood points do you want to use?", "Baal's Caress", 1, max_layers, 1)
	if(!layers)
		return
	user.adjust_blood_pool(-layers)
	target.AddComponent(/datum/component/baals_caress, owner, layers)
	to_chat(owner, span_notice("You imbue [target] with [layers] layer\s of your toxic vitae!"))

//TASTE OF DEATH
/obj/projectile/quietus
	name = "acid spit"
	icon_state = "toxin"
	pass_flags = PASSTABLE
	damage = 60
	damage_type = BURN
	hitsound = 'sound/items/weapons/effects/searwall.ogg'
	hitsound_wall = 'sound/items/weapons/effects/searwall.ogg'
	ricochets_max = 0
	ricochet_chance = 0

/obj/item/gun/magic/quietus
	name = "acid spit"
	desc = "Spit poison on your targets."
	icon = 'modular_darkpack/modules/deprecated/icons/items.dmi'
	icon_state = "har4ok"
	item_flags = NEEDS_PERMIT | ABSTRACT | DROPDEL | NOBLUDGEON
	flags_1 = NONE
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = NONE
	ammo_type = /obj/item/ammo_casing/magic/quietus
	fire_sound = 'sound/effects/splat.ogg'
	force = 0
	max_charges = 1
	fire_delay = 1
	throwforce = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0
	item_flags = DROPDEL

/obj/item/ammo_casing/magic/quietus
	name = "acid spit"
	desc = "A spit."
	projectile_type = /obj/projectile/quietus
	caliber = CALIBER_TENTACLE
	firing_effect_type = null
	item_flags = DROPDEL

/obj/item/gun/magic/quietus/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	. = ..()
	if(charges == 0)
		qdel(src)
/*
	playsound(target.loc, 'modular_darkpack/modules/deprecated/sounds/quietus.ogg', 50, TRUE)
	target.Stun(5*level_casting)
	if(level_casting >= 3)
		if(target.bloodpool > 1)
			var/transfered = max(1, target.bloodpool-3)
			owner.adjust_blood_points(transfered)
			target.adjust_blood_points(-transfered)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.remove_overlay(POWERS_LAYER)
		var/mutable_appearance/quietus_overlay = mutable_appearance('modular_darkpack/modules/deprecated/icons/icons.dmi', "quietus", -POWERS_LAYER)
		H.overlays_standing[POWERS_LAYER] = quietus_overlay
		H.apply_overlay(POWERS_LAYER)
		spawn(5*level_casting)
			H.remove_overlay(POWERS_LAYER)
*/


/datum/storyteller_roll/taste_of_death
	applicable_stats = list(STAT_STAMINA, STAT_ATHLETICS)

/datum/discipline_power/quietus/taste_of_death
	name = "Taste of Death"
	desc = "Spit a glob of caustic blood at your enemies."

	level = 5
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_LYING | DISC_CHECK_FREE_HAND

	violates_masquerade = TRUE

	cooldown_length = 8 SECONDS

/datum/discipline_power/quietus/taste_of_death/can_activate()
	range = 3 + owner.st_get_stat(STAT_STRENGTH)
	return ..()

/datum/discipline_power/quietus/taste_of_death/pre_activation_checks(atom/target)
	. = ..()
	var/roll = SSroll.storyteller_roll_datum(owner, target, /datum/storyteller_roll/taste_of_death)
	if(roll == ROLL_SUCCESS)
		return TRUE
	else
		return FALSE

/datum/discipline_power/quietus/taste_of_death/activate()
	. = ..()
	owner.drop_all_held_items()
	//should be changed to a ranged attack targeting turfs
	owner.put_in_active_hand(new /obj/item/gun/magic/quietus(owner))
