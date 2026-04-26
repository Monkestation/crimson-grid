/obj/ritual_rune/abyss/calling_the_hungry_shade
	name = "calling the hungry shade"
	desc = "call forth a hungry, and furious, shade of the Abyss, and seek to tame it. Beware if you fail - it will attack you instead!"
	icon_state = "rune8"
	word = "Spirit of Hunger."
	level = 3
	cost = 1
	difficulty = 9

/obj/ritual_rune/abyss/calling_the_hungry_shade/complete()
	. = ..()
	if(ishuman(last_activator))
		var/mob/living/carbon/human/human_activator = last_activator
		human_activator.add_beastmaster_minion(/mob/living/basic/shadow_guard/hungry_shade)
		if(length(human_activator.beastmaster_minions) > human_activator.st_get_stat(STAT_OCCULT))
			var/mob/living/beastmaster_minion = pick(human_activator.beastmaster_minions)
			beastmaster_minion.death()
	qdel(src)

/obj/ritual_rune/abyss/calling_the_hungry_shade/ritual_failure()
	. = ..()
	var/mob/living/basic/shadow_guard/hungry_shade/shade = new(get_turf(src))
	shade.ai_controller = new /datum/ai_controller/basic_controller/simple/simple_hostile(shade)
	shade.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, last_activator)
	shade.remove_faction(VAMPIRE_CLAN_LASOMBRA)
	to_chat(last_activator, span_warning("The ritual slips from your grasp - something answers the call regardless!"))
	qdel(src)

/obj/ritual_rune/abyss/calling_the_hungry_shade/ritual_botch()
	. = ..()
	var/mob/living/basic/shadow_guard/hungry_shade/shade = new(get_turf(src))
	shade.ai_controller = new /datum/ai_controller/basic_controller/simple/simple_hostile(shade)
	shade.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, last_activator)
	shade.remove_faction(VAMPIRE_CLAN_LASOMBRA)
	to_chat(last_activator, span_warning("You lose control over the ritual!"))
	last_activator.apply_damage(30, AGGRAVATED)
	qdel(src)
