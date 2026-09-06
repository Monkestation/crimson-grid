/datum/antagonist/sabbatist
	name = "Sabbatist"
	roundend_category = "sabbattites"
	antagpanel_category = FACTION_SABBAT
	pref_flag = ROLE_SABBAT
	antag_moodlet = /datum/mood_event/revolution
	antag_hud_name = "pack"
	ui_name = null
	hud_icon = 'modular_darkpack/modules/jobs/icons/sabbat.dmi'

/datum/antagonist/sabbatist/apply_innate_effects(mob/living/mob_override)
	. = ..()
	add_team_hud(owner.current, /datum/antagonist/sabbatist) // CRIMSON EDIT - Sabbat Identifier Fix - Original: add_team_hud(owner.current)

/datum/antagonist/sabbatist/on_removal()
	to_chat(owner.current, span_userdanger("You are no longer the part of Sabbat!"))
	return ..()

/datum/antagonist/sabbatist/greet()
	to_chat(owner.current, span_alertsyndie("You are now part of the Sabbat."))
	//owner.announce_objectives()
