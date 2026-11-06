/datum/discipline/valeren
	name = "Валерен"
	desc = {"Воинский путь Валерена: салюбри-антитрибу читают слабости врагов и бьют точно по ним.
● Биение жизни: Восприятие + Эмпатия (сложность 7)
●● Обезболивающее касание: Воля (сложность 8, если цель противится)
●●● Обжигающее касание: пассивно
●●●● Броня гнева Каинова: Выносливость + Фехтование (сложность 7)
●●●●● Месть Самиэля: пассивно"}
	icon_state = "valeren"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/valeren

// Assets for the UI
/datum/asset/simple/valeren_assets
	legacy = TRUE
	assets = list(
		"da_vinci_vitruve_luc_viatour.webp" = 'modular_darkpack/modules/powers/icons/images/da_vinci_vitruve_luc_viatour.webp',
	)

/datum/discipline_power/valeren
	name = "Valeren power name"
	desc = "Valeren power description"

/datum/storyteller_roll/sense_vitality
	bumper_text = "биение жизни"
	applicable_stats = list(STAT_PERCEPTION, STAT_EMPATHY)
	difficulty = 7
	numerical = TRUE
	roll_output_type = ROLL_FLAG_ROLLER

/datum/discipline_power/valeren/sense_vitality
	name = "Биение жизни"
	desc = "Позволяет оценить жизненные силы цели."
	level = 1
	check_flags = DISC_CHECK_CAPABLE
	target_type = TARGET_HUMAN | TARGET_SELF
	range = 1
	cooldown_length = 3 TURNS
	duration_length = 1 TURNS
	activate_sound = null
	vitae_cost = 0
	var/successes = 0
	var/msg_creature = "" // what kinda phreak they is
	var/msg_damage = ""
	var/msg_blood = ""
	var/msg_disease = ""
	var/msg_mental = ""

	var/datum/storyteller_roll/sense_vitality/vitality_roll

/datum/discipline_power/valeren/sense_vitality/pre_activation_checks(mob/living/target)
	. = ..()
	if(!vitality_roll)
		vitality_roll = new()
	successes = vitality_roll.st_roll(owner, target)
	if(successes >= 1)
		return TRUE
	else
		return FALSE

/datum/discipline_power/valeren/sense_vitality/proc/blood_read(mob/living/carbon/human/target)
	var/blood_volume = target.get_blood_volume(apply_modifiers = TRUE)
	switch(blood_volume)
		if(BLOOD_VOLUME_EXCESS to INFINITY)
			return "Вены переполнены так, что вот-вот лопнут."
		if(BLOOD_VOLUME_MAXIMUM to BLOOD_VOLUME_EXCESS)
			return "Крови в теле намного больше нормы."
		if(BLOOD_VOLUME_SAFE to BLOOD_VOLUME_MAXIMUM)
			return "Объём крови в норме."
		if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
			return "Крови меньше нормы."
		if(BLOOD_VOLUME_RISKY to BLOOD_VOLUME_OKAY)
			return "Крови опасно мало."
		if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_RISKY)
			return "Крови критически мало."
		if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
			return "Крови в теле почти не осталось. Без немедленной помощи смерть не заставит себя ждать."
		else
			return "Тело полностью обескровлено."

/datum/discipline_power/valeren/sense_vitality/proc/damage_severity(damage)
	if(damage < 30)
		return "лёгкой степени"
	if(damage < 50)
		return "средней степени"
	return "тяжёлой степени"

/datum/discipline_power/valeren/sense_vitality/ui_state(mob/user)
	return GLOB.always_state

/datum/discipline_power/valeren/sense_vitality/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	var/datum/asset/valeren_files = get_asset_datum(/datum/asset/simple/valeren_assets)
	if(user.client)
		valeren_files.send(user.client)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new /datum/tgui(user, src, "Valeren")
		ui.open()

/datum/discipline_power/valeren/sense_vitality/ui_data(mob/living/user)
	var/list/data = list()
	data["creature"] = msg_creature
	data["damage"] = msg_damage
	data["blood"] = msg_blood
	data["disease"] = msg_disease
	data["mental"] = msg_mental
	return data

/datum/discipline_power/valeren/sense_vitality/activate(mob/living/target)
	. = ..()
	msg_creature = ""
	msg_damage = ""
	msg_blood = ""
	msg_disease = ""
	msg_mental = ""

	// on one success, identify their splat
	var/creature_type = "из смертных"
	if(get_kindred_splat(target))
		creature_type = "из Сородичей"
	else if(get_ghoul_splat(target))
		creature_type = "из гулей"
	else if(isavatar(target) || isobserver(target)) // because salubri spend all their time in the clinic anyway. they'll use this on ghosts
		creature_type = "из призраков"
	msg_creature = "[target] - [creature_type]."

	// on two successes, identify their damage
	if(successes >= 2)
		var/brute = target.get_brute_loss()
		var/burn = target.get_fire_loss()
		var/tox = target.get_tox_loss()
		var/oxy = target.get_oxy_loss()
		var/agg = target.get_agg_loss()
		var/list/damage_parts = list()
		if(brute > 0)
			damage_parts += "ушибы [damage_severity(brute)]"
		if(burn > 0)
			damage_parts += "ожоги [damage_severity(burn)]"
		if(tox > 0)
			damage_parts += "отравление [damage_severity(tox)]"
		if(oxy > 0)
			damage_parts += "кислородное голодание [damage_severity(oxy)]"
		if(agg > 0)
			damage_parts += "сверхъестественные раны [damage_severity(agg)]"
		msg_damage = length(damage_parts) ? "Обнаружены: [english_list(damage_parts)]." : "Повреждений не видно."

	// on three successes, detect their bloodpool, if any exists
	if(successes >= 3)
		msg_blood = "[blood_read(target)] [round(target.bloodpool / target.maxbloodpool * 100)]% запаса крови в остатке."

	// on four, display any diseases they might have
	if(successes >= 4)
		var/list/datum/disease/diseases = target.get_static_viruses()
		if(LAZYLEN(diseases))
			var/list/disease_names = list()
			for(var/datum/disease/D in diseases)
				disease_names += D.name
			msg_disease = "В крови обнаружено: [english_list(disease_names)]."
		else
			msg_disease = "Болезней в крови не обнаружено."
		var/list/mental_conditions = list()
		if(target.has_quirk(/datum/quirk/insanity))
			mental_conditions += "безумие"
		if(target.has_quirk(/datum/quirk/darkpack/derangement))
			mental_conditions += "неизлечимое психическое расстройство"
		if(length(mental_conditions))
			msg_mental = "Разум затуманен. Причина: [english_list(mental_conditions)]."

	ui_interact(owner)
	to_chat(owner, span_notice("[msg_creature] \n[msg_damage] \n[msg_blood] \n[msg_disease] \n[msg_mental]"))

/datum/discipline_power/valeren/sense_vitality/deactivate()
	. = ..()

/datum/storyteller_roll/anesthetic_touch
	bumper_text = "обезболивающее касание"
	applicable_stats = list(STAT_TEMPORARY_WILLPOWER)
	numerical = TRUE
	roll_output_type = ROLL_FLAG_ROLLER|ROLL_FLAG_TARGET

/datum/storyteller_roll/anesthetic_touch/unwilling
	bumper_text = "обезболивающее касание (против воли)"
	difficulty = 8

/datum/discipline_power/valeren/anesthetic_touch
	name = "Обезболивающее касание"
	desc = "Уймите боль пациента или погрузите смертного в безмятежный сон."
	level = 2
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND
	target_type = TARGET_LIVING
	range = 1
	cooldown_length = 3 TURNS
	var/sleep_duration_length = 10 TURNS
	var/soothe_duration_length = 1 SCENES
	var/successes = 0
	var/datum/storyteller_roll/anesthetic_touch/touch_roll
	var/datum/storyteller_roll/anesthetic_touch/unwilling/touch_roll_unwilling
	frenzy_usable = FALSE

/datum/discipline_power/valeren/anesthetic_touch/pre_activation_checks(mob/living/target)
	. = ..()
	var/datum/storyteller_roll/anesthetic_touch/roll_to_use
	if(target.combat_mode)
		if(!touch_roll_unwilling)
			touch_roll_unwilling = new()
		roll_to_use = touch_roll_unwilling
	else
		if(!touch_roll)
			touch_roll = new()
		roll_to_use = touch_roll
	successes = roll_to_use.st_roll(owner, target)
	if(successes >= 1)
		return TRUE
	else
		return FALSE

/datum/discipline_power/valeren/anesthetic_touch/activate(mob/living/target)
	. = ..()
	var/list/choices = list(
		"Унять боль" = icon('icons/mob/actions/actions_spells.dmi', "statue"),
		"Усыпить" = icon('icons/mob/actions/actions_spells.dmi', "blind"),
	)
	var/chosen_option = show_radial_menu(owner, target, choices, radius = 38, require_near = TRUE)
	switch(chosen_option)
		if("Унять боль")
			target.add_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown) // CORVAX EDIT CHANGE - ORIGINAL: owner.add_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown)
			ADD_TRAIT(target, TRAIT_ANALGESIA, type)
			addtimer(CALLBACK(src, PROC_REF(end_soothe_pain), target), (successes TURNS) + soothe_duration_length)
		if("Усыпить")
			if(get_kindred_splat(target))
				to_chat(owner, span_warning("Сородича этой способностью не усыпить!"))
				return TRUE
			target.SetSleeping(sleep_duration_length + (successes TURNS)) // 50 seconds + successes in turns
			target.adjust_blood_pool(1) // restores a BP to the target, but if this gets abused, maybe make this depend on successes
	return TRUE

/datum/discipline_power/valeren/anesthetic_touch/proc/end_soothe_pain(mob/living/target)
	target.remove_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown) // CORVAX EDIT CHANGE - ORIGINAL: owner.remove_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown)
	REMOVE_TRAIT(target, TRAIT_ANALGESIA, type)

/datum/discipline_power/valeren/burning_touch
	name = "Обжигающее касание"
	desc = "Пропустите сквозь ладони сверхъестественный огонь: всякий, кого вы схватите, на 30 секунд познает жгучую боль. Ожогов она не оставляет, зато оглушает чувства, не даёт сосредоточиться и крайне мешает применять Дисциплины."
	level = 3
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND
	target_type = TARGET_LIVING
	range = 1
	vitae_cost = 1
	hostile = TRUE
	violates_masquerade = FALSE

/datum/discipline_power/valeren/burning_touch/activate(mob/living/target)
	. = ..()
	target.apply_status_effect(/datum/status_effect/burning_touch)
	if(owner.grab_state <= GRAB_AGGRESSIVE)
		target.grabbedby(owner)
		target.grippedby(owner, instant = TRUE)
		owner.do_attack_animation(target, ATTACK_EFFECT_MECHFIRE)

/datum/storyteller_roll/burning_touch_resist
	bumper_text = "стерпеть жгучую боль"
	applicable_stats = list(STAT_TEMPORARY_WILLPOWER)
	roll_output_type = ROLL_FLAG_ROLLER|ROLL_FLAG_TARGET

/datum/storyteller_roll/burning_touch_focus
	bumper_text = "сосредоточиться сквозь жгучую боль"
	applicable_stats = list(STAT_TEMPORARY_WILLPOWER)
	spammy_roll = TRUE
	roll_output_type = ROLL_FLAG_ROLLER|ROLL_FLAG_TARGET

/datum/status_effect/burning_touch
	id = "burning_touch"
	status_type = STATUS_EFFECT_REFRESH
	duration = 6 TURNS // 30 second debuff duration, so it will still affect them for a few seconds even if they escape their captors grip, as per v20
	alert_type = /atom/movable/screen/alert/status_effect/burning_touch
	tick_interval = 2 TURNS // how frequently the pain messages will tick
	var/datum/storyteller_roll/burning_touch_resist/resist_roll
	var/datum/storyteller_roll/burning_touch_focus/focus_roll
	var/list/pain_messages = list(
		"Жжёт!",
		"Больно!",
		"Господи, пусть это прекратится!",
		"ОГОНЬ! ОГОНЬ!",
		"Хватит, пожалуйста, ХВАТИТ!",
		"Кожа горит!",
		"Не могу думать! Как же больно!",
		"Отпусти, ОТПУСТИ!",
		"Оно в самых костях!",
		"От боли не вздохнуть!",
		"Почему это не кончается?!",
	)

/datum/status_effect/burning_touch/on_apply()
	. = ..()
	if(!.)
		return
	resist_roll = new()
	focus_roll = new()
	owner.st_add_stat_mod(STAT_DEXTERITY, -2, "burning_touch") // you're in searing pain, so you're a little less dextrous
	owner.st_add_stat_mod(STAT_TEMPORARY_WILLPOWER, -2, "burning_touch")
	var/resist_scream = resist_roll.st_roll(owner, owner)
	if(!resist_scream)
		owner.emote("scream")
	RegisterSignal(owner, COMSIG_POWER_TRY_ACTIVATE, PROC_REF(on_discipline_activate))

/datum/status_effect/burning_touch/on_remove()
	. = ..()
	owner.st_remove_stat_mod(STAT_DEXTERITY, "burning_touch")
	owner.st_remove_stat_mod(STAT_TEMPORARY_WILLPOWER, "burning_touch")
	UnregisterSignal(owner, COMSIG_POWER_TRY_ACTIVATE)
	resist_roll = null
	focus_roll = null

// crispy victims must roll willpower at difficulty 6 to focus through the burning pain
/datum/status_effect/burning_touch/proc/on_discipline_activate(mob/living/source, datum/discipline_power/power, atom/target)
	SIGNAL_HANDLER
	var/success = focus_roll.st_roll(source, source)
	if(!success)
		to_chat(source, span_userdanger("Жгучая боль не даёт сосредоточиться. Сейчас вам не до Дисциплин!"))
		return POWER_PREVENT_ACTIVATE

/datum/status_effect/burning_touch/tick(seconds_between_ticks)
	to_chat(owner, span_userdanger(pick(pain_messages)))
	playsound(get_turf(owner), SFX_SIZZLE, 80, TRUE)

/atom/movable/screen/alert/status_effect/burning_touch
	name = "Обжигающее касание"
	desc = "Ваше тело горит сверхъестественным огнём! Чтобы применить Дисциплину, придётся сосредоточиться сквозь боль: проверка Воли со сложностью 6."
	icon_state = "fire"

/datum/storyteller_roll/armor_of_caines_fury
	bumper_text = "броня гнева Каинова"
	applicable_stats = list(STAT_STAMINA, STAT_MELEE)
	difficulty = 7
	numerical = TRUE
	roll_output_type = ROLL_FLAG_ROLLER|ROLL_FLAG_TARGET

/datum/discipline_power/valeren/armor_of_caines_fury
	name = "Броня гнева Каинова"
	desc = "Салюбри-антитрибу окружает сияющий багровый ореол. Эта призрачная броня защищает вампира от большинства телесных ран, а заодно и от Ротшрека."
	level = 4
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE
	cooldown_length = 1 SCENES
	toggled = TRUE
	duration_length = 2 TURNS
	vitae_cost = 1
	var/successes = 0
	violates_masquerade = TRUE
	var/datum/storyteller_roll/armor_of_caines_fury/armor_roll

/datum/discipline_power/valeren/armor_of_caines_fury/pre_activation_checks(mob/living/target)
	. = ..()
	if(!armor_roll)
		armor_roll = new()
	successes = armor_roll.st_roll(owner, target)
	if(successes >= 1)
		return TRUE
	else
		return FALSE

/datum/discipline_power/valeren/armor_of_caines_fury/activate(mob/living/target)
	. = ..()
	// TODO: once frenzy is in, add a status effect to reduce frenzy difficulty as per the book's 'resist Rötschreck'
	owner.apply_status_effect(/datum/status_effect/armor_of_caines_fury, clamp(successes, 1, 5))
	return TRUE

/datum/discipline_power/valeren/armor_of_caines_fury/deactivate()
	. = ..()
	owner.remove_status_effect(/datum/status_effect/armor_of_caines_fury)

#define CAINES_FURY_PROTECTION 15 // borrowed from fortitude

// Halo behavoir is copy pasted from /datum/status_effect/cult_halo
/datum/status_effect/armor_of_caines_fury
	id = "armor_of_caines_fury"
	status_type = STATUS_EFFECT_REPLACE
	alert_type = null
	tick_interval = STATUS_EFFECT_NO_TICK
	var/successes = 1
	/// The actual halo applied to the mob
	VAR_PRIVATE/mutable_appearance/halo_overlay

/datum/status_effect/armor_of_caines_fury/on_creation(mob/living/new_owner, successes_count = 1)
	successes = successes_count
	. = ..()

/datum/status_effect/armor_of_caines_fury/on_apply()
	. = ..()
	if (!.)
		return

	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMAGE_MODIFIERS, PROC_REF(reduce_damage))
	RegisterSignal(owner, COMSIG_ATOM_UPDATE_OVERLAYS, PROC_REF(add_halo))
	refresh_halo()

/datum/status_effect/armor_of_caines_fury/on_remove()
	. = ..()

	UnregisterSignal(owner, list(COMSIG_MOB_APPLY_DAMAGE_MODIFIERS, COMSIG_ATOM_UPDATE_OVERLAYS))
	owner.update_appearance(UPDATE_OVERLAYS)

	REMOVE_TRAIT(owner, TRAIT_MASQUERADE_VIOLATING_FACE, TRAIT_STATUS_EFFECT(id))
	halo_overlay = null

/datum/status_effect/armor_of_caines_fury/proc/reduce_damage(datum/source, list/damage_mods, damage_amount, damagetype, def_zone, sharpness, attack_direction, obj/item/attacking_item)
	SIGNAL_HANDLER
	if (damagetype != BRUTE)
		return

	var/protection = clamp(successes * CAINES_FURY_PROTECTION, 0, 90) // we don't yet have a comparison for what 1 point of armor means in v20 vs ingame, so this is just a percent reduction for now
	damage_mods += (100 - protection) / 100

/datum/status_effect/armor_of_caines_fury/proc/refresh_halo()
	ADD_TRAIT(owner, TRAIT_MASQUERADE_VIOLATING_FACE, TRAIT_STATUS_EFFECT(id))
	owner.update_appearance(UPDATE_OVERLAYS)
	new /obj/effect/temp_visual/cult/sparks(get_turf(owner), owner.dir)

/datum/status_effect/armor_of_caines_fury/proc/add_halo(datum/source, list/overlay_list)
	SIGNAL_HANDLER

	halo_overlay ||= mutable_appearance('icons/mob/effects/halo.dmi', "halo[rand(1, 6)]", -HALO_LAYER)
	halo_overlay.pixel_z = 0
	halo_overlay.pixel_w = 0
	if (ishuman(owner))
		var/mob/living/carbon/human/human_parent = owner
		human_parent.apply_height(halo_overlay, UPPER_BODY)

		var/obj/item/bodypart/head/human_head = human_parent.get_bodypart(BODY_ZONE_HEAD)
		human_head?.worn_head_offset?.apply_offset(halo_overlay)

	overlay_list += halo_overlay

#undef CAINES_FURY_PROTECTION

// this is basically just potence 5 with stat bonuses, used potence as a baseline because of the 'makes for significant damage' wording in v20 above
/datum/discipline_power/valeren/vengeance_of_samiel
	name = "Месть Самиэля"
	desc = "Третий глаз салюбри-антитрибу распахивается и наливается яростной ледяной синевой - и удар обрушивается на врага с нечеловеческой точностью и силой. Одни Фурии взывают к именам древних воинов Салюбри, другие просто закрывают обычные глаза и позволяют Самиэлю направлять их руку."
	level = 5
	check_flags = DISC_CHECK_CAPABLE
	toggled = TRUE
	duration_length = 1 TURNS
	frenzy_usable = FALSE

/datum/discipline_power/valeren/vengeance_of_samiel/activate()
	. = ..()
	owner.apply_status_effect(/datum/status_effect/vengeance_of_samiel)

/datum/discipline_power/valeren/vengeance_of_samiel/deactivate()
	. = ..()
	owner.remove_status_effect(/datum/status_effect/vengeance_of_samiel)

/datum/status_effect/vengeance_of_samiel
	id = "vengeance_of_samiel"
	status_type = STATUS_EFFECT_REPLACE
	alert_type = null

	var/bonus = 5
	var/datum/component/tackler/tackler
	var/list/datum/weakref/affected_bodyparts

/datum/status_effect/vengeance_of_samiel/on_apply()
	. = ..()
	if (!.)
		return
	owner.st_add_stat_mod(STAT_DEXTERITY, bonus, "vengeance_of_samiel")
	owner.st_add_stat_mod(STAT_MELEE, bonus, "vengeance_of_samiel")
	owner.st_add_stat_mod(STAT_BRAWL, bonus, "vengeance_of_samiel")
	if (iscarbon(owner))
		var/mob/living/carbon/carbon_owner = owner
		for (var/obj/item/bodypart/limb as anything in carbon_owner.bodyparts)
			if (!istype(limb, /obj/item/bodypart/arm) && !istype(limb, /obj/item/bodypart/leg))
				continue
			LAZYADD(affected_bodyparts, WEAKREF(limb))
			limb.unarmed_attack_sound = pick(list('sound/items/weapons/cqchit2.ogg', 'sound/items/weapons/cqchit1.ogg')) // i know kung fu
	else if (isbasicmob(owner))
		var/mob/living/basic/basic_owner = owner
		basic_owner.attack_sound = pick(list('sound/items/weapons/cqchit2.ogg', 'sound/items/weapons/cqchit1.ogg'))
	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(apply_melee_modifier))
	tackler = owner.AddComponent(/datum/component/tackler, stamina_cost=0, base_knockdown = 1 SECONDS, range = 2 + bonus, speed = 1, skill_mod = 0, min_distance = 0)

/datum/status_effect/vengeance_of_samiel/on_remove()
	. = ..()
	owner.st_remove_stat_mod(STAT_DEXTERITY, "vengeance_of_samiel")
	owner.st_remove_stat_mod(STAT_MELEE, "vengeance_of_samiel")
	owner.st_remove_stat_mod(STAT_BRAWL, "vengeance_of_samiel")

	for(var/datum/weakref/limb_weakref in affected_bodyparts)
		var/obj/item/bodypart/limb = limb_weakref.resolve()
		if(!limb)
			continue
		limb.unarmed_attack_sound = limb::unarmed_attack_sound

	if (isbasicmob(owner))
		var/mob/living/basic/basic_owner = owner
		basic_owner.attack_sound = basic_owner::attack_sound

	LAZYCLEARLIST(affected_bodyparts)
	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK)
	qdel(tackler)

/datum/status_effect/vengeance_of_samiel/proc/apply_melee_modifier(mob/source, mob/M, mob/user, list/modifiers, list/attack_modifiers)
	SIGNAL_HANDLER
	MODIFY_ATTACK_FORCE_MULTIPLIER(attack_modifiers, 1 + (0.4 * bonus))
