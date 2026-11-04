/obj/structure/bath/sabbatbath
	name = "sabbat bath"
	desc = "A large ceremonial bath, commonly used in Sabbat rituals. It appears to be designed to hold blood."
	icon_state = "tub"
	can_buckle = TRUE
	buckle_lying = 90
	layer = BELOW_MOB_LAYER
	var/blood_level = 0
	var/max_blood = 500
	var/list/blood_donors = list()

/obj/structure/bath/sabbatbath/Initialize(mapload)
	. = ..()
	create_reagents(max_blood, INJECTABLE)
	update_icon()

/obj/structure/bath/sabbatbath/examine(mob/user)
	. = ..()
	if(blood_level <= 0)
		. += span_notice("The bath is empty.")
	else
		. += span_notice("The bath is filled with blood.")

	if(length(blood_donors) > 0)
		. += span_notice("You can sense [length(blood_donors)] different blood donor[length(blood_donors) == 1 ? "" : "s"] in the mixture.")

/obj/structure/bath/sabbatbath/update_icon()
	. = ..()
	// Change the sprite when it contains blood
	if(blood_level > 0)
		icon = 'modular_darkpack/modules/sabbat/icons/sabbat_blood_bath.dmi'
		icon_state = "bath_full_blood"
	else
		icon = 'modular_darkpack/modules/decor/icons/bathroom.dmi'
		icon_state = "tub"

/obj/structure/bath/sabbatbath/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/sabbat_priest_tome))
		if(user.mind && is_sabbat_priest(user.mind.assigned_role) && has_buckled_mobs())
			var/mob/living/buckled_mob = buckled_mobs[1]
			if(buckled_mob.mind)
				// CRIMSON EDIT ADD START - Sabbat Identifier Fix
				if(!is_sabbatist(buckled_mob.mind.assigned_role))
					to_chat(user, span_warning("The vitae rejects them. They must join the pack before they can lead it."))
					return ITEM_INTERACT_BLOCKING
				// CRIMSON EDIT ADD END - Sabbat Identifier Fix
				// First, demote any existing Ductus to regular Sabbat Pack
				for(var/mob/living/carbon/human/H in GLOB.human_list) // CRIMSON EDIT - Sabbat Identifier Fix - Original: GLOB.player_list
					if(H.mind && is_sabbat_ductus(H.mind.assigned_role))
						H.mind.set_assigned_role(SSjob.get_job_type(/datum/job/vampire/sabbatpack))
						// CRIMSON EDIT ADD START - Sabbat Identifier Fix
						H.mind.remove_antag_datum(/datum/antagonist/sabbatist/ductus)
						H.mind.add_antag_datum(/datum/antagonist/sabbatist)
						// CRIMSON EDIT ADD END - Sabbat Identifier Fix
						var/datum/antagonist/temp_antag = new()
						//temp_antag.remove_antag_hud(ANTAG_HUD_REV, H)
						//temp_antag.add_antag_hud(ANTAG_HUD_REV, "rev", H)
						qdel(temp_antag)

						to_chat(H, span_cult("You feel your authority as Ductus slipping away... You are now a regular pack member..."))
				// Then promote the new Ductus
				buckled_mob.mind.set_assigned_role(SSjob.get_job_type(/datum/job/vampire/sabbatductus))
				// CRIMSON EDIT ADD START - Sabbat Identifier Fix
				buckled_mob.mind.remove_antag_datum(/datum/antagonist/sabbatist)
				buckled_mob.mind.add_antag_datum(/datum/antagonist/sabbatist/ductus)
				// CRIMSON EDIT ADD END - Sabbat Identifier Fix
				var/datum/antagonist/temp_antag = new()
				//temp_antag.add_antag_hud(ANTAG_HUD_REV, "rev_head", buckled_mob)
				qdel(temp_antag)
				// Notify all Sabbat members of the new Ductus
				for(var/mob/living/carbon/human/sabbat_member in GLOB.player_list)
					if(sabbat_member.mind && is_sabbatist(sabbat_member.mind.assigned_role))
						to_chat(sabbat_member, span_cult("[buckled_mob] has been anointed as the new Ductus of the pack!"))

				to_chat(buckled_mob, span_cult("You have been anointed as the new Ductus of the pack!"))
		return ITEM_INTERACT_SUCCESS
	if(istype(tool, /obj/item/knife/vamp))
		playsound(loc,'sound/items/weapons/bladeslice.ogg', 50, FALSE)
		if(do_after(user, 100))
			if(user.bloodpool <= 0)
				to_chat(user, span_warning("You have no blood to donate!"))
				return ITEM_INTERACT_BLOCKING

			user.visible_message(span_notice("[user] cuts [user.p_their()] wrist and lets blood flow into the bath."), span_notice("You cut your wrist and let blood flow into the bath."))

			var/amount_to_donate = min(user.bloodpool, 3)

			user.adjust_blood_pool(-amount_to_donate)

			blood_level = min(blood_level + amount_to_donate, max_blood)
			reagents.add_reagent(/datum/reagent/blood, amount_to_donate)

			if(!(user in blood_donors))
				blood_donors += user

			update_icon()

			return ITEM_INTERACT_SUCCESS
		else
			to_chat(user, span_warning("You decide not to add your blood to the bathtub..."))
			return ITEM_INTERACT_BLOCKING

	// Handle vaulderie goblet specifically so that the Priest can use the tub's blood for vaulderie (part of the blood bath rite)
	if(istype(tool, /obj/item/reagent_containers/cup/silver_goblet/vaulderie_goblet))
		var/obj/item/reagent_containers/cup/silver_goblet/vaulderie_goblet/goblet = tool
		if(blood_level <= 0)
			to_chat(user, span_warning("The bath is empty."))
			return ITEM_INTERACT_BLOCKING

		var/transfer_amount = min(goblet.volume - goblet.reagents.total_volume, blood_level)
		if(transfer_amount <= 0)
			to_chat(user, span_warning("The goblet is already full."))
			return ITEM_INTERACT_BLOCKING

		user.visible_message(span_notice("[user] scoops blood from the bath into [goblet]."), span_notice("You scoop blood from the bath into [goblet]."))

		reagents.trans_to(goblet, transfer_amount)
		blood_level -= transfer_amount

		if(length(blood_donors) > 0)
			goblet.blood_donors = blood_donors

		if(blood_level <= 0)
			update_icon()

		return  ITEM_INTERACT_SUCCESS

/obj/structure/bath/sabbatbath/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	. = ..()
	if(. && blood_level > 0)
		playsound(loc, 'modular_darkpack/modules/deprecated/sounds/catched.ogg', 50, FALSE)
		if(do_after(user, 100))
			if(M == user)
				M.visible_message(span_notice("[user] climbs into the blood-filled bath."), span_notice("You climb into the blood-filled bath."))
			else
				M.visible_message(span_notice("[user] places [M] in the blood-filled bath."), span_notice("[user] places you in the blood-filled bath."))


/obj/structure/bath/sabbatbath/user_unbuckle_mob(mob/living/buckled_mob, mob/user)
	. = ..()
	if(.)
		if(buckled_mob == user)
			buckled_mob.visible_message(span_notice("[buckled_mob] climbs out of the bath."), span_notice("You climb out of the bath."))
		else
			buckled_mob.visible_message(span_notice("[user] pulls [buckled_mob] out of the bath."), span_notice("[user] pulls you out of the bath."))

		// Create blood splatters as they exit
		if(blood_level > 0 && ishuman(buckled_mob))
			var/turf/T = get_turf(src)
			for(var/turf/adjacent in RANGE_TURFS(1, T))
				if(prob(40) && adjacent != T)
					buckled_mob.add_splatter_floor(adjacent)
