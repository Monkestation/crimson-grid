/datum/discipline/path_of_flames
	name = "Path of Flames"
	desc = {"Gives Power over flames allowing one to command firey death upon ones enemies
	● Combust: Manipulation + Occult
	●● Magma Surge: Manipulation + Occult
	●●● Wall of Magma: Manipulation + Occult
	●●●● Heat Wave: Manipulation + Occult
	●●●●● Volcanic BLast: Manipulation + Occult"}
	icon = 'modular_vcg/modules/powers/icons/koldun_icon2.dmi'
	icon_state = "koldun_fire"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/path_of_flames
	signature_clan = VAMPIRE_CLAN_OLD_CLAN_TZIMISCE

/datum/discipline_power/path_of_flames
	name = "path of flames power name"
	desc = "path of flames power description"

	activate_sound = 'modular_darkpack/modules/powers/sounds/visceratika.ogg'//placeholder sound ignore



/datum/discipline_power/path_of_flames/combust
	name = "Combust"
	desc = "Instantly combust a target"

	level = 1
	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SEE
	target_type = TARGET_LIVING
	range = 3
	vitae_cost = 1

	aggravating = FALSE
	hostile = TRUE
	violates_masquerade = TRUE
	multi_activate = TRUE
	cooldown_length = 10 SECONDS

/datum/discipline_power/path_of_flames/combust/activate(mob/living/target)
	. = ..()
	if(!.)
		return
	owner.visible_message(span_warning("[owner] focuses on [target] as supernatural flames gather!"),span_notice("You focus on [target] and summon supernatural flames."))
	var/successes = SSroll.storyteller_roll_datum(owner,target,	difficulty = 7,applic_stats = list(STAT_MANIPULATION, STAT_OCCULT),	numerical = TRUE)

	if(successes <= 0)
		to_chat(owner, span_warning("Your flames fail to catch hold."))
		return

	target.adjust_fire_stacks(successes*1.5)
	target.ignite_mob()
	to_chat(target, span_userdanger("Supernatural flames engulf you!"))

//datum/discipline_power/path_of_flames/magma_surge
//	name = "Magma surge"
//	desc = "Cause the hot magma to erupt at a location"
//	level = 2
//	check_flags = DISC_CHECK_CONSCIOUS
//	vitae_cost = 2
//	cooldown_length = 40 SECONDS
//	target_type = TARGET_TURF
//	range = 5
