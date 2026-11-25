/mob/living/carbon/human/register_init_signals()
	. = ..()

	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_STAKED), PROC_REF(on_staked))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_STAKED), PROC_REF(on_unstaked))

/// Gaining [TRAIT_STAKED] forces us into torpor if we're kindred, and just murders us if we're not.
/mob/living/carbon/human/proc/on_staked(datum/source)
	SIGNAL_HANDLER

	if(get_kindred_splat(src))
		INVOKE_ASYNC(src, PROC_REF(torpor), STAKE_TRAIT, TRUE)
	else
		INVOKE_ASYNC(src, PROC_REF(death))

/// Losing [TRAIT_STAKED] forces us out of torpor if we're kindred.
/mob/living/carbon/human/proc/on_unstaked(datum/source)
	SIGNAL_HANDLER

	if(get_kindred_splat(src))
		cure_torpor(STAKE_TRAIT, TRUE)
