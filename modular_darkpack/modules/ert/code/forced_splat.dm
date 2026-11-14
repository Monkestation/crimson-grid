/datum/ert
	/// Splat ID every member of this team is forced into on spawn. Null keeps each character's own splat.
	var/forced_splat
	/// If TRUE, members are told on spawn that they know about the supernatural.
	var/supernatural_aware = FALSE

/mob/living/carbon/human/proc/apply_ert_splat(splat_id)
	ADD_TRAIT(src, TRAIT_NO_CANON, INNATE_TRAIT)
	if(splat_id != SPLAT_NONE && get_splat(GLOB.splat_list[splat_id]))
		return
	QDEL_LAZYLIST(splats)
	if(splat_id != SPLAT_NONE)
		add_splat(GLOB.splat_list[splat_id])
