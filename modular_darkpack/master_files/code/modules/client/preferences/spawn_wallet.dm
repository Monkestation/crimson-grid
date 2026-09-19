/datum/preference/toggle/spawn_with_wallet
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	should_update_preview = FALSE
	savefile_key = "spawn_wallet"
	can_randomize = FALSE

/datum/preference/toggle/spawn_with_wallet/apply_to_human(mob/living/carbon/human/target, value)
	if(!value)
		ADD_TRAIT(target, TRAIT_WALLET_HATER, ROUNDSTART_TRAIT)
	return
