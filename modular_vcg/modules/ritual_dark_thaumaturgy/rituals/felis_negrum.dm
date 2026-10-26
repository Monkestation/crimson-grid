/obj/ritual_rune/dark/felis_negrum
	name = "felis negrum"
	desc = "Turns your target into a black cat"
	icon_state = "rune7"
	word = "FE'LIS"
	cost = 1
	level = 3
	sacrifices = list(/obj/item/stack/sheet/animalhide/cat, /obj/item/shard)
	var/datum/action/cooldown/spell/shapeshift/black_cat/shapeshift_spell

/datum/storyteller_roll/felis_negrum
	bumper_text = "felis negrum"
	applicable_stats = list(STAT_PERMANENT_WILLPOWER)
	numerical = TRUE

/obj/ritual_rune/dark/felis_negrum/complete()
	. = ..()
	if(ishuman(usr))
		var/mob/living/carbon/human/user = usr
		var/found = FALSE
		var/target_name = tgui_input_text(user, "Choose target name:", "Curse Rune")
		if(!target_name) // Check if user is still nearby
			to_chat(user, span_warning("You must specify a target!"))
			return
		for(var/mob/living/carbon/human/human_target in src.loc)
			if(human_target.real_name == target_name)
				found = TRUE
				var/user_success_count = SSroll.storyteller_roll_datum(user, human_target, /datum/storyteller_roll/felis_negrum, difficulty = 6)
				var/target_success_count = SSroll.storyteller_roll_datum(human_target, user, /datum/storyteller_roll/felis_negrum, difficulty = 6)
				if(target_success_count > user_success_count)
					to_chat(user, span_warning("The rite fails to take hold."))
					qdel(src)
					return
				log_combat(last_activator, human_target, "Felis Negrum")
				to_chat(human_target, span_warning("You feel dark energy twisting your body!"))
				if(human_target == user)
					var/datum/action/cooldown/spell/shapeshift/black_cat/cat = new(human_target)
					cat.remove_on_restore = TRUE
					cat.Grant(human_target)
					cat.cast(human_target)
				else
					var/duration = 24 MINUTES // Hours in lore but too op
					if(get_kindred_splat(human_target))
						duration = 12 SCENES - human_target.st_get_stat(STAT_PERMANENT_WILLPOWER) // Nights in lore but too op
					human_target.felis_negrum(duration)
		if(!found)
			to_chat(user, span_warning("The target must be on the rune!"))
		qdel(src)

/mob/living/carbon/human/proc/felis_negrum(duration)
	var/mob/living/new_shape = new /mob/living/basic/pet/cat/darkpack/black(get_turf(src))
	var/datum/status_effect/shapechange_mob/shapechange = new_shape.apply_status_effect(/datum/status_effect/shapechange_mob, src)
	if(!shapechange)
		to_chat(src, span_warning("You can't shapeshift in this form!"))
		qdel(new_shape)
		return
	addtimer(CALLBACK(shapechange, TYPE_PROC_REF(/datum/status_effect/shapechange_mob, restore_caster)), duration)

/mob/living/basic/pet/cat/darkpack/black
	maxHealth = 300
	health = 300
	speed = -0.8
	melee_damage_lower = 10
	melee_damage_upper = 10
	melee_attack_cooldown = 4
	attack_vis_effect = ATTACK_EFFECT_CLAW
	icon_state = "cat5"
	base_icon_state = "cat5"
	icon = 'modular_darkpack/master_files/icons/mobs/simple/pets.dmi'
	icon_living = "cat5"
	icon_dead = "cat5_dead"
	random_cat_color = FALSE

/datum/status_effect/shapechange_mob/from_spell/black_cat
	allow_unshapeshift = FALSE

/datum/action/cooldown/spell/shapeshift/black_cat
	name = "Black Cat"
	desc = "Take on the shape of a black cat."
	button_icon_state = "shapeshift"
	cooldown_time = 5 SECONDS
	spell_requirements = NONE
	revert_on_death = TRUE
	die_with_shapeshifted_form = FALSE
	convert_damage = TRUE
	convert_damage_type = AGGRAVATED // So people can either choose to wait it out or die and heal the dmg slowly
	shapeshift_type = /mob/living/basic/pet/cat/darkpack/black
	possible_shapes = list(/mob/living/basic/pet/cat/darkpack/black)
	shapechange_type = /datum/status_effect/shapechange_mob/from_spell/black_cat

	var/remove_on_restore = FALSE

/datum/action/cooldown/spell/shapeshift/black_cat/do_unshapeshift(mob/living/caster)
	. = ..()
	if(!.)
		return

	if(remove_on_restore)
		qdel(src)
