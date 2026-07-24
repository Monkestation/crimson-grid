/obj/item/reagent_containers/cup/silver_goblet
	name = "silver goblet"
	desc = "A gleaming goblet used in ancient vampire rites."
	icon = 'modular_darkpack/modules/sabbat/icons/vaulderie_goblet.dmi'
	icon_state = "pewter_cup"
	base_icon_state = "pewter_cup"
	w_class = WEIGHT_CLASS_TINY
	force = 1
	throwforce = 1
	amount_per_transfer_from_this = 5
	custom_materials = list(/datum/material/silver = SHEET_MATERIAL_AMOUNT)
	possible_transfer_amounts = list(1, 5)
	volume = 80
	spillable = TRUE
	resistance_flags = FIRE_PROOF
	var/list/blood_donors = list()

/obj/item/reagent_containers/cup/silver_goblet/is_drainable()
	return TRUE

/obj/item/reagent_containers/cup/silver_goblet/Initialize(mapload)
	. = ..()
	blood_donors = list()

/obj/item/reagent_containers/cup/silver_goblet/update_icon_state()
	. = ..()
	if(reagents && (reagents.has_reagent(/datum/reagent/blood)))
		icon_state = "[base_icon_state]_filled_blood"
	else
		icon_state = base_icon_state

/obj/item/reagent_containers/cup/silver_goblet/attack_self(mob/living/carbon/human/user)
	if(!istype(user))
		return ..()

	if(!get_kindred_splat(user))
		to_chat(user, span_warning("You have no urge to spill your blood into this cup."))
		return

	if(reagents.total_volume >= volume)
		to_chat(user, span_warning("The [src] is already full!"))
		return

	if(user.bloodpool < 2)
		to_chat(user, span_warning("You don't have enough blood to spare!"))
		return

	user.visible_message(span_notice("[user] prepares to cut their wrist to add blood to the [src]."), span_notice("You prepare to cut your wrist and add your blood to the [src]."))

	if(!do_after(user, 5 SECONDS, target = src))
		to_chat(user, span_warning("You decide not to add your blood to the [src]."))
		return

	user.visible_message(span_notice("[user] cuts their wrist and lets blood drip into the [src]."), span_notice("You cut your wrist and let your blood flow into the [src]."))

	playsound(user, 'sound/items/weapons/bladeslice.ogg', 30, TRUE)
	user.adjust_brute_loss(5)

	reagents.add_reagent(/datum/reagent/blood/vitae, 10)
	user.adjust_blood_pool(-2)

	if(!(user in blood_donors))
		blood_donors += user

	update_appearance()

/obj/item/reagent_containers/cup/silver_goblet/try_drink(mob/living/target_mob, mob/living/user)
	if(!reagents.has_reagent(/datum/reagent/blood) && !reagents.has_reagent(/datum/reagent/blood/vitae))
		return ..()

	if(!get_kindred_splat(target_mob))
		return ..()

	if(length(blood_donors) >= 2)
		var/choice = tgui_alert(target_mob, "Do you wish to take part in the Vaulderie? This will bind you to the other participants, and remove any previous bonds... (This will cause your character to change sects to the Sabbat!)", "Vaulderie Ritual", list("Yes", "No"), 10 SECONDS)
		if(choice != "Yes")
			to_chat(target_mob, span_cult("You decide not to participate in the Vaulderie."))
			return ITEM_INTERACT_BLOCKING

	if(length(blood_donors) > 0 && (reagents.has_reagent(/datum/reagent/blood/vitae) || reagents.has_reagent(/datum/reagent/blood)))
		for(var/mob/living/carbon/human/donor in blood_donors)
			if(target_mob != donor)
				to_chat(target_mob, span_warning("You feel a strange connection to <b>[donor]</b> forming as their blood mingles with yours!"))
				to_chat(donor, span_notice("You sense that <b>[target_mob]</b> has consumed your blood and is now bound to you."))
				target_mob.visible_message(span_notice("[target_mob]'s eyes flash briefly as they become bound to [donor]."), span_notice("Your eyes flash as the blood bond forms."))
				playsound(target_mob, 'sound/effects/magic/smoke.ogg', 20, TRUE)

	if(length(blood_donors) > 1)
		if(!is_sabbatist(target_mob))
			to_chat(target_mob, span_cult("You feel your previous blood bonds vanishing as you take part in the Vaulderie and join the Sabbat..."))
			target_mob.mind.set_assigned_role(SSjob.get_job_type(/datum/job/vampire/sabbatpack))
			//var/datum/antagonist/temp_antag = new()
			//qdel(temp_antag)
	else
		var/antag_transferred = FALSE

		for(var/mob/living/carbon/human/donor in blood_donors)
			if(donor.mind && is_sabbatist(donor))
				if(target_mob.mind && !is_sabbatist(target_mob))
					to_chat(target_mob, span_warning("You feel a strange connection to [donor] as you drink their blood..."))
					target_mob.mind.set_assigned_role(SSjob.get_job_type(/datum/job/vampire/sabbatpack))
					//var/datum/antagonist/temp_antag = new()
					//qdel(temp_antag)
					antag_transferred = TRUE
					break

		if(antag_transferred)
			to_chat(target_mob, span_cult("Your mind floods with alien thoughts and philosophies. You now serve the Sabbat!"))

	return ..()

/obj/item/reagent_containers/cup/silver_goblet/on_reagent_change()
	. = ..()
	if(reagents.total_volume == 0)
		blood_donors.Cut()
	update_appearance()

/obj/item/reagent_containers/cup/silver_goblet/afterattack(obj/target, mob/user, proximity)
	if(!proximity || !check_allowed_items(target, 1))
		return

	if(target.is_refillable() && !istype(target, /obj/item/reagent_containers/cup/silver_goblet))
		if(reagents.total_volume > 0 && target.reagents.total_volume < target.reagents.maximum_volume)
			blood_donors.Cut()

	return ..()

/obj/item/reagent_containers/cup/silver_goblet/vaulderie_goblet
	name = "Vaulderie Goblet"
	desc = "An obsidian-black goblet used in ancient vampire rites."
	icon_state = "vaulderie_goblet"
	base_icon_state = "vaulderie_goblet"
