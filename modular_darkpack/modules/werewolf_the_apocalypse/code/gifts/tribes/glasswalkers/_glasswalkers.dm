/*
/datum/action/cooldown/power/gift/hands_full_of_thunder
	name = "Hands Full of Thunder"
	desc = "Invoke the machine spirits to support you in these trying times. Abstain from needing bullets when you fire a gun."
	button_icon_state = "hands_full_of_thunder"
	rank = 2
	gnosis_cost = 1

/datum/action/cooldown/power/gift/hands_full_of_thunder/Activate(atom/target)
	. = ..()
	ADD_TRAIT(owner, TRAIT_THUNDERSHOT, "thunder")
	to_chat(owner, span_notice("You feel your fingers tingling with electricity...!"))
	spawn(1 SCENES)
		REMOVE_TRAIT(owner, TRAIT_THUNDERSHOT, "thunder")
		to_chat(owner, span_notice("The buzz in your fingertips ebbs..."))
*/
