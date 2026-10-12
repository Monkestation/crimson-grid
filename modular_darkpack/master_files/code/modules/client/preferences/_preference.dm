/datum/preference
	/// If set to TRUE, this preference will not be applied unless the character has the preference's relevant inherent trait
	var/must_have_relevant_trait = FALSE

	/// If set to TRUE, only apply preference to the mob if it acctually shows up on their sheet
	var/must_be_accessible = FALSE

/datum/preference/proc/post_set_preference(mob/user, value)
	SHOULD_CALL_PARENT(FALSE)
	return
