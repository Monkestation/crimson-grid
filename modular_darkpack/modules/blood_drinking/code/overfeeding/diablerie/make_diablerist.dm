
/mob/living/carbon/human/proc/make_diablerist()
	write_preference_midround(/datum/preference/toggle/diablerist, TRUE)
	// CORVAX EDIT ADD START
	write_preference_midround(/datum/preference/toggle/diablerie_locked, TRUE)
	write_preference_midround(/datum/preference/toggle/diablerie_generation_locked, TRUE)
	// CORVAX EDIT ADD END
	ADD_TRAIT(src, TRAIT_DIABLERIE, TRAIT_DIABLERIE)
	SEND_SIGNAL(src, COMSIG_MOB_UPDATE_AURA)
