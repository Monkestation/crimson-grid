
// ALTERNATIVE_JOB_TITLES

/**
 * Shows a list of all current and future polls and buttons to edit or delete them or create a new poll.
 *
 * All extra functionality to run on new player mobs, in a place where we actually have the client,
 * and haven't called COMSIG_GLOB_JOB_AFTER_SPAWN yet,
 * and other things that rely on items already being settled.
 */
/datum/controller/subsystem/job/proc/setup_alt_job_items(mob/living/carbon/human/equipping, datum/job/job, client/player_client, alt_title)
	if(!player_client)
		return

	var/list/all_items = equipping.gather_belongings()

	for(var/obj/possible_item as anything in all_items)
		if(istype(possible_item, /obj/item/card))
			var/obj/item/card/found_card = possible_item
			if(found_card.shows_name)
				found_card.link_to_human(equipping, alt_title)
			continue
		if(istype(possible_item, /obj/item/identification))
			var/obj/item/identification/found_identification = possible_item
			found_identification.link_human(equipping)
			continue
