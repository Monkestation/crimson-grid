/datum/outfit/job/vampire/sabbatist
	name = JOB_SABBAT_SABBATIST
	l_pocket = /obj/item/smartphone
	r_pocket = /obj/item/flashlight
	suit = /obj/item/clothing/suit/vampire/trench
	belt = /obj/item/scythe/vamp
	backpack_contents = list(/obj/item/vampire_stake=3, /obj/item/gun/ballistic/revolver/darkpack/magnum=1, /obj/item/knife/vamp=1, /obj/item/vamp/keys/hack=1, /obj/item/vamp/keys/sabbat=1)

/datum/outfit/job/vampire/sabbatist/post_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.add_antag_datum(/datum/antagonist/sabbatist)
	GLOB.sabbatites += H

	var/list/landmarkslist = list()
	for(var/obj/effect/landmark/start/S in GLOB.start_landmarks_list)
		if(S.name == name)
			landmarkslist += S
	var/obj/effect/landmark/start/D = pick(landmarkslist)
	H.forceMove(D.loc)

/datum/antagonist/sabbatist
	name = JOB_SABBAT_SABBATIST
	roundend_category = "sabbattites"
	antagpanel_category = FACTION_SABBAT
	pref_flag = ROLE_SABBAT
	antag_moodlet = /datum/mood_event/revolution
	antag_hud_name = "pack"
	ui_name = null
	hud_icon = 'modular_darkpack/modules/jobs/icons/sabbat.dmi'

/datum/antagonist/sabbatist/apply_innate_effects(mob/living/mob_override)
	. = ..()
	add_team_hud(owner.current)

/datum/antagonist/sabbatist/on_removal()
	to_chat(owner.current, span_userdanger("You are no longer the part of Sabbat!"))
	return ..()

/datum/antagonist/sabbatist/greet()
	to_chat(owner.current, span_alertsyndie("You are now part of the Sabbat."))
	//owner.announce_objectives()
