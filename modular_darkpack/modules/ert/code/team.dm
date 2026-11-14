/datum/ert
	/// Splat ID every member of this team is forced into on spawn. Null keeps each character's own splat.
	var/forced_splat
	/// If TRUE, members are told on spawn that they know about the supernatural.
	var/supernatural_aware = FALSE

/datum/ert/darkpack
	abstract_type = /datum/ert/darkpack
	forced_splat = SPLAT_NONE

/datum/ert/darkpack/swat
	leader_role = /datum/antagonist/ert/darkpack/swat/leader
	roles = list(/datum/antagonist/ert/darkpack/swat/medic, /datum/antagonist/ert/darkpack/swat/rifleman, /datum/antagonist/ert/darkpack/swat/negotiations)
	rename_team = "SWAT Unit"
	mission = "Assess the situation and assist the Police Department. Ensure that law and order is restored in the City."
	polldesc = "the City's Special Weapons and Tactics Unit"

/datum/ert/darkpack/national_guard
	leader_role = /datum/antagonist/ert/darkpack/national_guard/leader
	roles = list(/datum/antagonist/ert/darkpack/national_guard/medic, /datum/antagonist/ert/darkpack/national_guard/rifleman, /datum/antagonist/ert/darkpack/national_guard/explosives)
	rename_team = "National Guard Platoon"
	mission = "Stabilize the area. Establish a curfew. Disperse the riots. Ensure safety and restore order immediately - by any means."
	polldesc = "the National Guard Emergency Response Unit"

/datum/ert/darkpack/pentex
	leader_role = /datum/antagonist/ert/darkpack/pentex/leader
	roles = list(/datum/antagonist/ert/darkpack/pentex/medic, /datum/antagonist/ert/darkpack/pentex/exterminator, /datum/antagonist/ert/darkpack/pentex/specialist)
	rename_team = "First Team"
	mission = "Liquidate all hostile anomolous entities"
	polldesc = "an elite FIRST Team"
	supernatural_aware = TRUE

/datum/ert/darkpack/pentex/budget
	leader_role = /datum/antagonist/ert/darkpack/pentex/budget_leader
	roles = list(/datum/antagonist/ert/darkpack/pentex/budget_intern, /datum/antagonist/ert/darkpack/pentex/budget_medic)
	rename_team = "First Team" //For when you need a death-squad on a budget
	mission = "Remove all hostile anomolous entities"
	polldesc = "an 'elite' FIRST Team"

/datum/ert/darkpack/fbi
	leader_role = /datum/antagonist/ert/darkpack/fbi/leader
	roles = list(/datum/antagonist/ert/darkpack/fbi/medic, /datum/antagonist/ert/darkpack/fbi/rifleman, /datum/antagonist/ert/darkpack/fbi/marksman)
	rename_team = "FBI SWAT Unit"
	mission = "Assess the situation and assist the deployed FBI Special Agents."
	polldesc = "the FBI's Special Weapons and Tactics Unit"

/mob/living/carbon/human/proc/apply_ert_splat(splat_id)
	ADD_TRAIT(src, TRAIT_NO_CANON, INNATE_TRAIT)
	if(splat_id != SPLAT_NONE && get_splat(GLOB.splat_list[splat_id]))
		return
	QDEL_LAZYLIST(splats)
	if(splat_id != SPLAT_NONE)
		add_splat(GLOB.splat_list[splat_id])
