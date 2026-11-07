/datum/action/cooldown/power/gift/falling_touch
	name = "Сбивающее касание"
	desc = "Этот Дар позволяет гару одним лишь касанием сбить врага с ног."
	button_icon_state = "falling_touch"
	click_to_activate = TRUE
	cooldown_time = 10 SECONDS //CRIMSON GRID ADDITION - cooldown
	rank = 1

/datum/action/cooldown/power/gift/falling_touch/set_click_ability(mob/on_who)
	. = ..()
	SEND_SOUND(owner, 'modular_darkpack/modules/werewolf_the_apocalypse/sounds/gifts/falling_touch.ogg')

/datum/action/cooldown/power/gift/falling_touch/Activate(atom/target)
	if(!isliving(target))
		return
	if(!(target in range(1, owner)))
		return

	. = ..()

	var/mob/living/victim = target
	var/mob/living/caster = owner
	var/datum/splat/werewolf/casting_splat = get_werewolf_splat(owner)
	var/holding = caster.get_active_held_item()
	if(caster.combat_mode)
		victim.Knockdown(3 SECONDS) //CRIMSON GRID EDIT - original victim.Knockdown(1 TURNS)
		victim.Immobilize(3 SECONDS) //CRIMSON GRID EDIT - original victim.Immobilize(1 TURNS)
		playsound(caster, 'modular_darkpack/modules/werewolf_the_apocalypse/sounds/gifts/falling_touch_activate.ogg', 75, FALSE) // red-tailed hawk sound mixed with disintegrate.ogg
		SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)
		if(holding)
			victim.attackby(holding, caster)
		else
			victim.attack_hand(caster)

		if(casting_splat.rage)
			casting_splat.adjust_rage(-1)
		else
			caster.st_set_stat(STAT_TEMPORARY_WILLPOWER, max((caster.st_get_stat(STAT_TEMPORARY_WILLPOWER) - 1),0))
			to_chat(caster, span_userdanger("Вы потратили <b>ВОЛЮ</b>, чтобы применить Дар \"[name]\"!"))
	else
		victim.Knockdown(4 SECONDS) //CRIMSON GRID EDIT - original victim.Knockdown(1 TURNS)
		to_chat(caster, span_notice("Одно лёгкое касание, и [victim.declent_ru(NOMINATIVE)] уже на земле!"))
		to_chat(victim, span_userdanger("Вас сбивает с ног!"))

	StartCooldown()
	return TRUE


/datum/action/cooldown/power/gift/inspiration
	name = "Вдохновение"
	desc = "Гару, владеющий этим Даром, вселяет в собратьев новую решимость и праведный гнев."
	button_icon_state = "inspiration"
	gnosis_cost = 1
	rank = 1

/datum/action/cooldown/power/gift/inspiration/Activate(atom/target)
	. = ..()
	playsound(owner, 'modular_darkpack/modules/werewolf_the_apocalypse/sounds/gifts/inspiration.ogg', 75, FALSE)
	owner.emote("scream")
	for(var/mob/living/nearby_guy in oviewers(7, owner))
		nearby_guy.apply_status_effect(/datum/status_effect/inspiration)

/datum/status_effect/inspiration
	id = "inspiration"
	duration = 1 SCENES
	status_type = STATUS_EFFECT_REPLACE
	alert_type = /atom/movable/screen/alert/status_effect/gift/inspiration

/datum/status_effect/inspiration/on_apply()
	. = ..()
	if(isliving(owner))
		var/mob/living/living_owner = owner
		living_owner.st_change_stat(STAT_TEMPORARY_WILLPOWER, 1)

/datum/status_effect/inspiration/on_remove()
	if(isliving(owner))
		var/mob/living/living_owner = owner
		// Ugh. We really dont have a way to represent or register the spending of a temporary temp willpoint....
		living_owner.st_change_stat(STAT_TEMPORARY_WILLPOWER, -1)
	return ..()

/atom/movable/screen/alert/status_effect/gift/inspiration
	name = /datum/action/cooldown/power/gift/inspiration::name
	desc = "До конца сцены у вас на один пункт воли больше!"
	overlay_state = /datum/action/cooldown/power/gift/inspiration::button_icon_state


/datum/action/cooldown/power/gift/razor_claws
	name = "Когти-бритвы"
	desc = "Арун проводит когтями по камню, стали или другой твёрдой поверхности и затачивает их до остроты бритвы."
	button_icon_state = "razor_claws"
	rank = 1
	rage_cost = 1

/datum/action/cooldown/power/gift/razor_claws/Activate(atom/target)
	to_chat(owner, span_notice("Ваши когти становятся всё острее..."))
	playsound(owner, 'modular_darkpack/modules/werewolf_the_apocalypse/sounds/gifts/razor_claws.ogg', 75, FALSE)
	if(!do_after(owner, 1 SECONDS)) // CRIMSON EDIT - Original : 	if(!do_after(owner, 1 TURNS))
		return
	. = ..()
	var/mob/living/living_owner = astype(owner)
	living_owner?.apply_status_effect(/datum/status_effect/razor_claws)

/datum/status_effect/razor_claws
	id = "razor_claws"
	duration = 1 SCENES
	status_type = STATUS_EFFECT_REPLACE
	alert_type = /atom/movable/screen/alert/status_effect/gift/razor_claws

/datum/status_effect/razor_claws/on_apply()
	. = ..()
	playsound(owner, 'modular_darkpack/modules/werewolf_the_apocalypse/sounds/gifts/razor_claws.ogg', 75, FALSE)
	ADD_TRAIT(owner, TRAIT_RAZOR_CLAWS, GIFT_TRAIT)

/datum/status_effect/razor_claws/on_remove()
	REMOVE_TRAIT(owner, TRAIT_RAZOR_CLAWS, GIFT_TRAIT)
	to_chat(owner, span_warning("Ваши когти затупились..."))
	return ..()

/atom/movable/screen/alert/status_effect/gift/razor_claws
	name = /datum/action/cooldown/power/gift/razor_claws::name
	desc = "Ваши когти наносят больше повреждений."
	overlay_state = /datum/action/cooldown/power/gift/razor_claws::button_icon_state
