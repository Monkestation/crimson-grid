/datum/discipline/serpentis
	name = "Serpentis"
	desc = "Act like a cobra, get the powers to stun targets with your gaze and your tongue, praise the mummy traditions and spread them to your childe. Violates Masquerade."
	icon_state = "serpentis"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/serpentis
	signature_clan = VAMPIRE_CLAN_SETITE

/datum/discipline_power/serpentis
	name = "Serpentis power name"
	desc = "Serpentis power description"

	activate_sound = 'modular_darkpack/modules/powers/sounds/serpentis.ogg'

//THE EYES OF THE SERPENT
/datum/discipline_power/serpentis/the_eyes_of_the_serpent
	name = "The Eyes of the Serpent"
	desc = "Gain the hypnotic eyes of the serpent, and immobilise all who look into them."

	level = 1
	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SEE
	target_type = TARGET_LIVING
	range = 3
	vitae_cost = 0

	aggravating = FALSE
	hostile = FALSE
	violates_masquerade = TRUE

	multi_activate = TRUE
	duration_length = 5 SECONDS
	cooldown_length = 5 SECONDS

/datum/discipline_power/serpentis/the_eyes_of_the_serpent/proc/immobilize_target(mob/living/target, duration = 5 SECONDS)
	ADD_TRAIT(target, TRAIT_IMMOBILIZED, DISCIPLINE_TRAIT(type))
	RegisterSignals(target, list(COMSIG_ATOM_ATTACKBY, COMSIG_MOB_ITEM_ATTACK, COMSIG_PROJECTILE_PREHIT), PROC_REF(on_target_attacked))
	if(do_after(owner, duration, target))
		release_target(target)
		return TRUE
	else
		release_target(target)
		return FALSE

/datum/discipline_power/serpentis/the_eyes_of_the_serpent/proc/on_target_attacked(datum/source)
	SIGNAL_HANDLER
	var/mob/living/target = source
	release_target(target)
	to_chat(owner, span_warning("Your concentration is broken as [target] is attacked!"))
	to_chat(target, span_warning("The mental hold on you breaks as you're attacked!"))

/datum/discipline_power/serpentis/the_eyes_of_the_serpent/proc/release_target(mob/living/target)
	UnregisterSignal(target, list(COMSIG_ATOM_ATTACKBY, COMSIG_MOB_ITEM_ATTACK, COMSIG_PROJECTILE_PREHIT))
	to_chat(target, span_danger("You feel your concentration become your own once more, able to look away from the commanding gaze."))
	REMOVE_TRAIT(target, TRAIT_IMMOBILIZED, DISCIPLINE_TRAIT(type))

/datum/discipline_power/serpentis/the_eyes_of_the_serpent/can_activate_untargeted(alert)
	. = ..()
	if (owner?.is_eyes_covered())
		if (alert)
			to_chat(owner, span_warning("You cannot use [name] with your eyes covered!"))
		. = FALSE
	return .

/datum/discipline_power/serpentis/the_eyes_of_the_serpent/activate(mob/living/target)
	. = ..()
	target.face_atom(owner)
	target.visible_message(span_hypnophrase("<b>[owner] hypnotizes [target] with [owner.p_their()] eyes!</b>"), span_warning("<b>[owner] hypnotizes you! Their words seem to become more convincing and hypnotic...</b>"))
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.remove_overlay(MUTATIONS_LAYER)
		var/mutable_appearance/serpentis_overlay = mutable_appearance('modular_darkpack/modules/powers/icons/serpentis.dmi', "serpentis", -MUTATIONS_LAYER)
		H.overlays_standing[MUTATIONS_LAYER] = serpentis_overlay
		H.apply_overlay(MUTATIONS_LAYER)
	immobilize_target(target)

/datum/discipline_power/serpentis/the_eyes_of_the_serpent/deactivate(mob/living/target)
	. = ..()
	release_target(target)
	if (ishuman(target))
		var/mob/living/carbon/human/human_target = target
		human_target.remove_overlay(MUTATIONS_LAYER)

//THE TONGUE OF THE ASP
/datum/discipline_power/serpentis/the_tongue_of_the_asp
	name = "The Tongue of the Asp"
	desc = "Lengthen your tongue and strike your enemies with it, draining their blood."
	level = 2
	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_LYING
	target_type = TARGET_LIVING
	range = 6
	effect_sound = 'modular_darkpack/modules/powers/sounds/tongue.ogg'
	aggravating = TRUE
	hostile = TRUE
	violates_masquerade = TRUE
	cooldown_length = 5 SECONDS
	vitae_cost = 0
	var/successes

/datum/discipline_power/serpentis/the_tongue_of_the_asp/can_activate_untargeted(alert)
	. = ..()
	if (owner?.is_mouth_covered())
		if (alert)
			to_chat(owner, span_warning("You cannot use [name] with your mouth covered!"))
		. = FALSE
	return .

/datum/discipline_power/serpentis/the_tongue_of_the_asp/pre_activation_checks(mob/living/target)
	. = ..()
	successes = SSroll.storyteller_roll(owner.st_get_stat(STAT_STRENGTH), 6, owner, numerical = TRUE)
	if(successes > 0)
		return TRUE
	else
		return FALSE

/datum/discipline_power/serpentis/the_tongue_of_the_asp/activate(mob/living/target)
	. = ..()
	target.adjust_blood_pool(-2)
	target.apply_damage(12 * successes, AGGRAVATED)
	owner.adjust_blood_pool(2)
	var/obj/item/ammo_casing/magic/tentacle/casing = new (get_turf(owner))
	casing.fire_casing(target, owner, null, null, null, ran_zone(), 0,  owner)
	qdel(casing)

//THE SKIN OF THE ADDER
/datum/discipline_power/serpentis/the_skin_of_the_adder
	name = "The Skin of the Adder"
	desc = "Become like a snake and harden your skin into scales."
	level = 3
	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_LYING
	toggled = TRUE
	vitae_cost = 0 //handling blood cost in pre_activation because this power asks for one bloodpoint, but can be on forever without consuming more
	violates_masquerade = TRUE
	var/choice

/datum/discipline_power/serpentis/the_skin_of_the_adder/pre_activation_checks()
	. = ..()
	owner.adjust_blood_pool(-1)

/datum/discipline_power/serpentis/the_skin_of_the_adder/activate()
	. = ..()
	//this needs a sprite
	choice = tgui_alert(owner, "How do you manifest the scales along your body?", "Scales", list("Subtle", "Obvious"))
	if(choice == "Obvious")
		owner.st_add_stat_mod(STAT_INTIMIDATION, 2, "Serpentis") // 'reduce intimidation difficulties by two' placeholder
		owner.st_add_stat_mod(STAT_STAMINA, 3, "Serpentis") // 'reduces all soak difficulty to 5' placeholder
		ADD_TRAIT(owner, TRAIT_MASQUERADE_VIOLATING_FACE, DISCIPLINE_TRAIT(type))
	else
		owner.st_add_stat_mod(STAT_STAMINA, 2, "Serpentis") // permanently on with no downsides according to dav20. its staying at fort one bro
	ADD_TRAIT(owner, TRAIT_SERPENTIS_SKIN, DISCIPLINE_TRAIT(type)) //ideally this would either be blatantly obvious or not so much depending on the choice. I guess masq violating face trait will work for obvious.
	owner.st_add_stat_mod(STAT_APPEARANCE, -(owner.st_get_stat(STAT_APPEARANCE) - 1), "Serpentis")
	/*
	owner.Stun(duration_length)
	owner.petrify(duration_length, "Serpentis")
	*/

/datum/discipline_power/serpentis/the_skin_of_the_adder/deactivate()
	. = ..()
	if(choice == "Obvious")
		owner.st_remove_stat_mod(STAT_INTIMIDATION, 2, "Serpentis")
		owner.st_remove_stat_mod(STAT_STAMINA, 3, "Serpentis")
		REMOVE_TRAIT(owner, TRAIT_MASQUERADE_VIOLATING_FACE, DISCIPLINE_TRAIT(type))
	else
		owner.st_remove_stat_mod(STAT_STAMINA, 2, "Serpentis")
	REMOVE_TRAIT(owner, TRAIT_SERPENTIS_SKIN, DISCIPLINE_TRAIT(type))
	owner.st_remove_stat_mod(STAT_APPEARANCE, "Serpentis")


//THE FORM OF THE COBRA
/datum/discipline_power/serpentis/the_form_of_the_cobra
	name = "The Form of the Cobra"
	desc = "Become a huge, black cobra and eviscerate your enemies."
	level = 4
	check_flags = DISC_CHECK_IMMOBILE | DISC_CHECK_CAPABLE | DISC_CHECK_LYING
	vitae_cost = 1
	violates_masquerade = TRUE
	cancelable = TRUE
	toggled = TRUE
	duration_length = 0
	cooldown_length = 30 SECONDS
	var/datum/action/cooldown/spell/shapeshift/cobra/cobra_form

/datum/discipline_power/serpentis/the_form_of_the_cobra/pre_activation_checks()
	. = ..()
	if(do_after(owner, 4 SECONDS))
		return TRUE
	else
		return FALSE

/datum/discipline_power/serpentis/the_form_of_the_cobra/activate()
	. = ..()
	if(cobra_form)
		CRASH("[src] somehow already has a spell?")

	owner.drop_all_held_items()
	cobra_form = new(owner.mind)
	cobra_form.Grant(owner)
	cobra_form.Activate(owner)
	RegisterSignal(owner, COMSIG_LIVING_RETURNED_FROM_SHAPESHIFT, PROC_REF(deactivate))

/datum/discipline_power/serpentis/the_form_of_the_cobra/deactivate()
	UnregisterSignal(owner, COMSIG_LIVING_RETURNED_FROM_SHAPESHIFT)
	. = ..()
	cobra_form.Remove(owner)
	QDEL_NULL(cobra_form)
	owner.Stun(1.5 SECONDS)
	owner.do_jitter_animation(3 SECONDS)

/datum/action/cooldown/spell/shapeshift/cobra
	name = "Cobra"
	desc = "Take on the shape a beast."
	button_icon = 'modular_darkpack/modules/vampire_the_masquerade/icons/vampire_clans.dmi'
	button_icon_state = "setite"
	background_icon = 'modular_darkpack/master_files/icons/mob/actions/backgrounds.dmi'
	background_icon_state = "bg_discipline"
	overlay_icon_state = null
	spell_requirements = NONE
	cooldown_time = 5 SECONDS
	revert_on_death = TRUE
	die_with_shapeshifted_form = FALSE
	possible_shapes = list(/mob/living/basic/cobra,
	/mob/living/basic/cobra/typhon)

/mob/living/basic/cobra
	name = "cobra form"
	desc = "Hssssss..."
	icon = 'modular_darkpack/modules/deprecated/icons/48x48.dmi'
	icon_state = "cobra"
	icon_living = "cobra"
	mob_biotypes = MOB_ORGANIC | MOB_HUMANOID
	speed = -1
	maxHealth = 300
	health = 300
	melee_damage_lower = 30
	melee_damage_upper = 30
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/items/weapons/slash.ogg'
	pixel_w = -8

/mob/living/basic/cobra/typhon
	name = "Typhonic beast"
	desc = "A massive supernatural jackal with long, spiked ears, a hard, forked tail and a long snout."
	icon = 'modular_darkpack/modules/deprecated/icons/icons.dmi'
	icon_state = "protean4"
	icon_living = "protean4"
	mob_size = MOB_SIZE_LARGE
	pixel_w = 0
	initial_size = 1.4

/mob/living/basic/cobra/typhon/Life(seconds_per_tick)
	. = ..()
	SEND_SIGNAL(src, COMSIG_MASQUERADE_VIOLATION)

//THE HEART OF DARKNESS
/datum/discipline_power/serpentis/the_heart_of_darkness
	name = "The Heart of Darkness"
	desc = "Remove your heart and place it in an urn to protect it from stakes and Diablerie."

	level = 5
	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_LYING | DISC_CHECK_FREE_HAND
	vitae_cost = 0

	violates_masquerade = TRUE

	cooldown_length = 20 SECONDS

	var/obj/item/urn/urn

/datum/discipline_power/serpentis/the_heart_of_darkness/activate()
	. = ..()
	if(!urn)
		if(owner.dna?.species)
			owner.dna.species.inherent_traits |= TRAIT_STUNIMMUNE
			owner.dna.species.inherent_traits |= TRAIT_SLEEPIMMUNE
			owner.dna.species.inherent_traits |= TRAIT_NOSOFTCRIT
			ADD_TRAIT(owner, TRAIT_STAKE_IMMUNE, DISCIPLINE_TRAIT(type))
			urn = new(owner.loc)
			urn.own = owner
			//var/obj/item/organ/heart/heart = owner.get_organ_slot(ORGAN_SLOT_HEART) DARKPACK TODO - Vampire Organs need to be made useless
			//heart.forceMove(urn)
	else
		if(owner.dna?.species)
			owner.dna.species.inherent_traits -= TRAIT_STUNIMMUNE
			owner.dna.species.inherent_traits -= TRAIT_SLEEPIMMUNE
			owner.dna.species.inherent_traits -= TRAIT_NOSOFTCRIT
			REMOVE_TRAIT(owner, TRAIT_STAKE_IMMUNE, DISCIPLINE_TRAIT(type))
			//for(var/obj/item/organ/heart/heart in urn)
				//heart.forceMove(owner)
				//heart.Insert(owner)
		urn.own = null
		qdel(urn)
		urn = null

/obj/item/urn
	name = "organ urn"
	desc = "Stores some precious organs..."
	icon = 'modular_darkpack/modules/powers/icons/serpentis.dmi'
	icon_state = "urn"
	var/mob/living/own

/obj/item/urn/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	qdel(src)

/obj/item/urn/attack_self(mob/user)
	. = ..()
	qdel(src)

/obj/item/urn/Destroy()
	. = ..()
	if(own)
		own.death()
