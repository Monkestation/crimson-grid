/// Register pointing signals and grant actions on the owner.
/mob/living/carbon/human/proc/register_beastmaster_signals()
	if(!locate(/datum/action/beastmaster_command/toggle_follow) in actions)
		var/datum/action/beastmaster_command/toggle_follow/toggle_follow = new()
		toggle_follow.Grant(src)
		var/datum/action/beastmaster_command/end_aggression/endaggro = new()
		endaggro.Grant(src)

/mob/living/carbon/human/proc/unregister_beastmaster_signals()
	//remove action buttons
	for(var/datum/action/beastmaster_command/beastmaster_cmd in actions)
		beastmaster_cmd.Remove(src)
