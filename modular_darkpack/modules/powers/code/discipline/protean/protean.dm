/datum/discipline/protean
	name = "Protean"
	desc = "Lets your beast out, making you stronger and faster. Violates Masquerade."
	icon_state = "protean"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/protean
	signature_clan = VAMPIRE_CLAN_GANGREL

/datum/discipline_power/protean
	name = "Protean power name"
	desc = "Protean power description"
	abstract_type = /datum/discipline_power/protean

	activate_sound = 'modular_darkpack/modules/deprecated/sounds/protean_activate.ogg'
	deactivate_sound = 'modular_darkpack/modules/deprecated/sounds/protean_deactivate.ogg'

//EYES OF THE BEAST // VTM5 Corebook, page 270
/datum/discipline_power/protean/eyes_of_the_beast
	name = "Eyes of the Beast"
	desc = "Let your eyes be a gateway to your Beast. Gain its eyes."

	level = 1

	check_flags = DISC_CHECK_CONSCIOUS
	vitae_cost = 0
	violates_masquerade = FALSE

	toggled = TRUE
	var/original_eye_color

/datum/discipline_power/protean/eyes_of_the_beast/activate()
	. = ..()
	var/obj/item/organ/eyes/owners_eyes = owner.get_organ_by_type(/obj/item/organ/eyes)
	ADD_TRAIT(owner, TRAIT_TRUE_NIGHT_VISION, type)
	ADD_TRAIT(owner, TRAIT_LUMINESCENT_EYES, type)
	ADD_TRAIT(owner, TRAIT_UNNATURAL_RED_GLOWY_EYES, type)
	ADD_TRAIT(owner, TRAIT_MASQUERADE_VIOLATING_EYES, type)
	owners_eyes?.refresh()
	owner.st_add_stat_mod(STAT_CHARISMA, -1, type) // 20th edition
	owner.st_add_stat_mod(STAT_MANIPULATION, -1, type) // 20th edition
	owner.st_add_stat_mod(STAT_APPEARANCE, -1, type) // 20th edition
	owner.st_add_stat_mod(STAT_INTIMIDATION, 2, type) // 5th edition
	owner.add_eye_color(COLOR_RED, EYE_COLOR_DISC)

/datum/discipline_power/protean/eyes_of_the_beast/deactivate()
	. = ..()
	var/obj/item/organ/eyes/owners_eyes = owner.get_organ_by_type(/obj/item/organ/eyes)
	REMOVE_TRAIT(owner, TRAIT_TRUE_NIGHT_VISION, type)
	REMOVE_TRAIT(owner, TRAIT_LUMINESCENT_EYES, type)
	REMOVE_TRAIT(owner, TRAIT_UNNATURAL_RED_GLOWY_EYES, type)
	REMOVE_TRAIT(owner, TRAIT_MASQUERADE_VIOLATING_EYES, type)
	owners_eyes?.refresh()
	owner.st_remove_stat_mod(STAT_CHARISMA, type) // 20th edition
	owner.st_remove_stat_mod(STAT_MANIPULATION, type) // 20th edition
	owner.st_remove_stat_mod(STAT_APPEARANCE, type) // 20th edition
	owner.st_remove_stat_mod(STAT_INTIMIDATION, type) // 5th edition
	owner.remove_eye_color(EYE_COLOR_DISC)

/datum/discipline_power/protean/feral_claws
	name = "Feral Claws"
	desc = "Become a predator and grow hideous talons."

	level = 2

	check_flags = DISC_CHECK_IMMOBILE | DISC_CHECK_CAPABLE

	violates_masquerade = TRUE

	toggled = TRUE
	duration_length = 1 SCENES

	grouped_powers = list()

/datum/discipline_power/protean/feral_claws/activate()
	. = ..()
	owner.drop_all_held_items()
	owner.put_in_r_hand(new /obj/item/gangrel_claws(owner))
	owner.put_in_l_hand(new /obj/item/gangrel_claws(owner))

/datum/discipline_power/protean/feral_claws/deactivate()
	. = ..()
	for(var/obj/item/gangrel_claws/old_claws in owner.contents)
		qdel(old_claws)

//EARTH MELD
/datum/discipline_power/protean/earth_meld
	name = "Earth Meld"
	desc = "Hide yourself in the earth itself."

	level = 3

	check_flags = DISC_CHECK_IMMOBILE | DISC_CHECK_CAPABLE

	violates_masquerade = TRUE

	cancelable = TRUE
	duration_length = 1 SCENES
	cooldown_length = 1 TURNS

	grouped_powers = list(
		/datum/discipline_power/protean/shape_of_the_beast,
		/datum/discipline_power/protean/mist_form
	)
	var/obj/effect/decal/dirt_pile/D

/datum/discipline_power/protean/earth_meld/proc/become_soil()
	animate(owner, transform = matrix(), color = "#ffffff", time = 10) // Reset ourselves while we're invisible
	D = new (get_turf(owner)) // Spawn some dirt
	D.alpha = 64 // Subtle dirt
	owner.forceMove(D) // Put ourselves inside the dirt

/datum/discipline_power/protean/earth_meld/pre_activation_checks()
	var/allowed_turfs = list(
		/turf/open/misc,
	)

	if(!is_type_in_list(owner.loc, allowed_turfs)) // Check if the turf we're standing on is in allowed_turfs
		to_chat(owner, span_warning("You can't meld into the ground here!"))
		return FALSE
	else
		return TRUE

/datum/discipline_power/protean/earth_meld/activate()
	. = ..()
	owner.drop_all_held_items()
	owner.Stun(1 TURNS) // Dirt can't move, and neither can you!
	animate(owner, transform = matrix()/4, color = "#35240b", time = 1 SECONDS) // Sink into the earth
	addtimer(CALLBACK(src, PROC_REF(become_soil)), 1 SECONDS)

/datum/discipline_power/protean/earth_meld/deactivate()
	. = ..()
	if(owner.IsStun())
		owner.SetStun(0) // End the ongoing stun
	if(!D.expiring) // If D.expiring == 1, the following will occur anyways.
		owner.Knockdown(1 TURNS) // Get-up lag
		owner.forceMove(get_turf(D))
		D.remove_dirt_pile()

//SHAPE OF THE BEAST
/datum/discipline_power/protean/shape_of_the_beast
	name = "Shape of the Beast"
	desc = "Assume the form of an animal and retain your power."

	level = 4

	check_flags = DISC_CHECK_IMMOBILE | DISC_CHECK_CAPABLE

	violates_masquerade = TRUE
	toggled = TRUE
	cancelable = TRUE
	duration_length = 0
	cooldown_length = 1 TURNS

	grouped_powers = list(
		/datum/discipline_power/protean/earth_meld,
		/datum/discipline_power/protean/mist_form
	)

	var/datum/action/cooldown/spell/shapeshift/gangrel/beast_form/gangy_form

/datum/discipline_power/protean/shape_of_the_beast/activate()
	. = ..()
	if(gangy_form)
		CRASH("[src] somehow already has a spell?")
	owner.drop_all_held_items()
	gangy_form = new(owner.mind)
	gangy_form.Grant(owner)
	gangy_form.Activate(owner)
	RegisterSignal(owner, COMSIG_LIVING_RETURNED_FROM_SHAPESHIFT, PROC_REF(deactivate))

/datum/discipline_power/protean/shape_of_the_beast/deactivate()
	UnregisterSignal(owner, COMSIG_LIVING_RETURNED_FROM_SHAPESHIFT)
	. = ..()
	gangy_form.Remove(owner)
	QDEL_NULL(gangy_form)
	owner.Stun(1 TURNS)
	owner.do_jitter_animation(15)

//MIST FORM
/datum/discipline_power/protean/mist_form
	name = "Mist Form"
	desc = "Dissipate your body and move as mist."

	level = 5

	check_flags = DISC_CHECK_IMMOBILE | DISC_CHECK_CAPABLE

	violates_masquerade = TRUE

	cancelable = TRUE
	duration_length = 1 SCENES
	cooldown_length = 1 TURNS

	grouped_powers = list(
		/datum/discipline_power/protean/earth_meld,
		/datum/discipline_power/protean/shape_of_the_beast
	)

	var/datum/action/cooldown/spell/shapeshift/gangrel/mist/mist_form

/datum/discipline_power/protean/mist_form/activate()
	. = ..()
	if(mist_form)
		CRASH("[src] somehow already has a spell?")
	owner.drop_all_held_items()
	mist_form = new(owner.mind)
	mist_form.Grant(owner)
	mist_form.Activate(owner)
	RegisterSignal(owner, COMSIG_LIVING_RETURNED_FROM_SHAPESHIFT, PROC_REF(deactivate))

/datum/discipline_power/protean/mist_form/deactivate()
	UnregisterSignal(owner, COMSIG_LIVING_RETURNED_FROM_SHAPESHIFT)
	. = ..()
	mist_form.Remove(owner)
	QDEL_NULL(mist_form)
	owner.Stun(1 TURNS)
	owner.do_jitter_animation(15)

/datum/action/cooldown/spell/shapeshift/gangrel
	abstract_type = /datum/action/cooldown/spell/shapeshift/gangrel
	button_icon = 'modular_darkpack/modules/vampire_the_masquerade/icons/vampire_clans.dmi'
	button_icon_state = "gangrel"
	background_icon = 'modular_darkpack/master_files/icons/mob/actions/backgrounds.dmi'
	background_icon_state = "bg_discipline"
	overlay_icon_state = null
	spell_requirements = NONE
	cooldown_time = 5 SECONDS
	revert_on_death = TRUE
	die_with_shapeshifted_form = FALSE
