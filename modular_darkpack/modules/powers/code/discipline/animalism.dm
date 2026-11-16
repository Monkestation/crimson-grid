/datum/discipline/animalism
	name = "Animalism"
	desc = {"Summons spectral animals over your targets. Violates Masquerade.
● Summon Rat: Passive
●● Summon Cat: Passive
●●● Summon Wolf: Passive
●●●● Summon Bat: Passive
●●●●● Skitter: Passive"}
	icon_state = "animalism"
	power_type = /datum/discipline_power/animalism

/datum/discipline_power/animalism
	name = "Animalism power name"
	desc = "Animalism power description"
	effect_sound = 'modular_darkpack/modules/werewolf_the_apocalypse/sounds/gifts/wolves.ogg'

//SUMMON RAT
/datum/discipline_power/animalism/summon_rat
	name = "Summon Rat"
	desc = "Summon a spectral rat to do your bidding."
	level = 1
	violates_masquerade = TRUE
	cooldown_length = 8 SECONDS
	check_flags = DISC_CHECK_IMMOBILE | DISC_CHECK_CAPABLE | DISC_CHECK_LYING

/datum/discipline_power/animalism/summon_rat/activate()
	. = ..()
	owner.add_beastmaster_minion(/mob/living/basic/mouse/vampire/summoned)

//SUMMON CAT
/datum/discipline_power/animalism/summon_cat
	name = "Summon Cat"
	desc = "Summon a spectral cat to do your bidding."
	level = 2
	violates_masquerade = TRUE
	cooldown_length = 8 SECONDS
	check_flags = DISC_CHECK_IMMOBILE | DISC_CHECK_CAPABLE | DISC_CHECK_LYING

/datum/discipline_power/animalism/summon_cat/activate()
	. = ..()
	owner.add_beastmaster_minion(/mob/living/basic/pet/cat/darkpack/summoned)

//SUMMON WOLF
/datum/discipline_power/animalism/summon_wolf
	name = "Summon Wolf"
	desc = "Summon a spectral wolf to do your bidding."
	level = 3
	violates_masquerade = TRUE
	cooldown_length = 8 SECONDS
	check_flags = DISC_CHECK_IMMOBILE | DISC_CHECK_CAPABLE | DISC_CHECK_LYING

/datum/discipline_power/animalism/summon_wolf/activate()
	. = ..()
	owner.add_beastmaster_minion(/mob/living/basic/pet/dog/wolf/summoned)

//SUMMON BAT
/datum/discipline_power/animalism/summon_bat
	name = "Summon Bat"
	desc = "Summon a spectral bat to do your bidding."
	level = 4
	violates_masquerade = TRUE
	cooldown_length = 8 SECONDS
	check_flags = DISC_CHECK_IMMOBILE | DISC_CHECK_CAPABLE | DISC_CHECK_LYING

/datum/discipline_power/animalism/summon_bat/activate()
	. = ..()
	owner.add_beastmaster_minion(/mob/living/basic/bat/summoned)

/datum/action/cooldown/spell/shapeshift/animalism
	name = "Animalism Form"
	desc = "Take on the shape of a rat."
	button_icon_state = "shapeshift"
	cooldown_time = 5 SECONDS
	spell_requirements = NONE
	revert_on_death = TRUE
	die_with_shapeshifted_form = FALSE
	convert_damage = TRUE
	convert_damage_type = BRUTE
	shapeshift_type = /mob/living/basic/mouse/rat
	possible_shapes = list(/mob/living/basic/mouse/rat)

//RAT SHAPESHIFT
/datum/discipline_power/animalism/rat_shapeshift
	name = "Skitter"
	desc = "Become one of the rats that crawl beneath the city."
	check_flags = DISC_CHECK_IMMOBILE | DISC_CHECK_CAPABLE | DISC_CHECK_LYING
	level = 5
	violates_masquerade = TRUE
	cooldown_length = 8 SECONDS
	duration_length = 20 SECONDS
	var/datum/action/cooldown/spell/shapeshift/animalism/shapeshift_spell
	check_flags = DISC_CHECK_IMMOBILE | DISC_CHECK_CAPABLE | DISC_CHECK_LYING

/datum/discipline_power/animalism/rat_shapeshift/activate()
	. = ..()
	if(!ishuman(owner))
		return

	if(!shapeshift_spell)
		shapeshift_spell = new /datum/action/cooldown/spell/shapeshift/animalism()
		shapeshift_spell.spell_requirements = NONE
		shapeshift_spell.Grant(owner)
		RegisterSignal(shapeshift_spell, COMSIG_ACTION_TRIGGER, PROC_REF(on_shapeshift_toggle))

	shapeshift_spell.cast(owner)

/datum/discipline_power/animalism/rat_shapeshift/proc/on_shapeshift_toggle(datum/source)
	SIGNAL_HANDLER
	if(!is_type_in_list(owner, shapeshift_spell.possible_shapes))
		addtimer(CALLBACK(src, PROC_REF(deactivate)), 0.1 SECONDS)

/datum/discipline_power/animalism/rat_shapeshift/deactivate()
	. = ..()
	if(!owner || owner.stat == DEAD)
		return

	if(shapeshift_spell && is_type_in_list(owner, shapeshift_spell.possible_shapes))
		shapeshift_spell.cast(owner)
		owner.Stun(1.5 SECONDS)

/mob/living/basic/mouse/vampire/summoned
	name = "rat"
	desc = "A rat bound to its master's will."
	ai_controller = /datum/ai_controller/basic_controller/beastmaster_summon
	melee_damage_lower = 3
	melee_damage_upper = 8
	obj_damage = 10
	bloodpool = 2

/mob/living/basic/mouse/vampire/summoned/Initialize(mapload)
	AddElement(/datum/element/ai_retaliate)
	. = ..()

/mob/living/basic/pet/cat/darkpack/summoned
	name = "cat"
	desc = "A cat bound to its master's will."
	ai_controller = /datum/ai_controller/basic_controller/beastmaster_summon
	melee_damage_lower = 5
	melee_damage_upper = 12
	obj_damage = 15
	bloodpool = 2

/mob/living/basic/pet/dog/wolf/summoned
	name = "wolf"
	desc = "A wolf bound to its master's will."
	ai_controller = /datum/ai_controller/basic_controller/beastmaster_summon
	basic_mob_flags = DEL_ON_DEATH
	mob_biotypes = MOB_ORGANIC
	speed = 0.35
	maxHealth = 80
	health = 80
	melee_damage_lower = 10
	melee_damage_upper = 20
	obj_damage = 20
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'modular_darkpack/modules/deprecated/sounds/dog.ogg'
	random_wolf_color = FALSE
	bloodpool = 2

/mob/living/basic/bat/summoned
	name = "bat"
	desc = "A bat bound to its master's will."
	ai_controller = /datum/ai_controller/basic_controller/beastmaster_summon
	melee_damage_lower = 4
	melee_damage_upper = 10
	obj_damage = 10
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	bloodpool = 2
