/datum/action/cooldown/power/gift/primal_anger
	name = "Primal Anger"
	desc = "The character may inflict a single level of aggravated damage on herself once per scene, and gain three points of Rage in exchange."
	button_icon_state = "primal_anger"
	rank = 1
	cooldown_time = 1 SCENES

/datum/action/cooldown/power/gift/primal_anger/Activate(atom/target)
	. = ..()

	var/mob/living/living_owner = astype(owner)
	living_owner?.adjust_agg_loss(1 TTRPG_DAMAGE)

	var/datum/splat/werewolf/werewolf_splat = get_werewolf_splat(owner)
	werewolf_splat?.adjust_rage(3)
