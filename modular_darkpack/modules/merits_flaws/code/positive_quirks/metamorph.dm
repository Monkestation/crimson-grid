// W20 p. 473
/datum/quirk/darkpack/metamorph
	name = "Metamorph"
	desc = {"Shapechanging for you is as easy as breathing.
		You do not need to roll to change forms, nor is it necessary to spend a Rage point for an instantaneous shift.
		You make your changes as if you scored five successes on your roll to shift forms.
		If you lose consciousness from wounds or for some other reason, you may roll Wits + Primal Urge (difficulty 8) to choose which form you assume rather than reverting to breed form."}
	value = 7
	mob_trait = TRAIT_METAMORPH
	// I love the greg sam. sa
	icon = FA_ICON_BUG
	allowed_splats = SPLAT_SHIFTERS

/datum/storyteller_roll/metamorph
	bumper_text = "metamorph"
	applicable_stats = list(STAT_WITS) // + PRIMAL_URGE
	difficulty = 8
	roll_output_type = ROLL_PRIVATE
