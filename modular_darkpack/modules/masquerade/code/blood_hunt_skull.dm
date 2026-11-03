/obj/item/blood_hunt
	name = "ominous skull"
	desc = "A stylized skull, made out of marble."
	icon = 'modular_darkpack/modules/masquerade/icons/blood_hunt_skull.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/masquerade/icons/onfloor.dmi')
	icon_state = "skull"
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	armor_type = /datum/armor/blood_hunt_skull
	resistance_flags = FIRE_PROOF | ACID_PROOF

/datum/armor/blood_hunt_skull
	fire = 100
	acid = 100

/obj/item/blood_hunt/Initialize(mapload)
	. = ..()
	REGISTER_REQUIRED_MAP_ITEM(1, 1)
	GLOB.blood_hunt_announcers += src

/obj/item/blood_hunt/Destroy(force)
	GLOB.blood_hunt_announcers -= src
	return ..()

/obj/item/blood_hunt/examine(mob/user)
	. = ..()
	if(get_kindred_splat(user))
		. += span_notice("This thaumaturgically-created artifact allows you to announce a Blood Hunt to the city.")
		. += span_notice("It also allows you to pardon a kindred's masquerade violation by <b>interacting</b> with the kindred while holding the skull.")

/obj/item/blood_hunt/attack_self(mob/user)
	. = ..()
	var/chosen_name = tgui_input_text(user, "Write the hunted or forgiven character name:", "Blood Hunt")
	if(!chosen_name)
		return
	chosen_name = sanitize_name(chosen_name)
	var/reason = tgui_input_text(user, "Write the reason of the Blood Hunt:", "Blood Hunt Reason")
	if(!reason)
		return
	reason = sanitize(reason)

	for(var/mob/player_mob in GLOB.kindred_list)
		if(player_mob.real_name == chosen_name)
			if(HAS_TRAIT(player_mob, TRAIT_HUNTED))
				end_hunt(user, player_mob)
				return
			else
				start_hunt(user, player_mob, reason)
				return
	to_chat(user, span_danger("There is no such name in the city!"))

/obj/item/blood_hunt/proc/start_hunt(mob/user, mob/target, reason)
	to_chat(user, span_warning("You add [target.real_name] to the Hunted list."))
	RegisterSignals(target, list(COMSIG_LIVING_DEATH, COMSIG_QDELETING, COMSIG_LIVING_GIBBED), PROC_REF(complete_hunt))
	log_game("[user.real_name] started a bloodhunt on [target.real_name] for: [reason]")
	message_admins("[ADMIN_LOOKUPFLW(user)]] started a bloodhunt on [target.real_name] for: [reason]")
	target.start_blood_hunt(reason)

/obj/item/blood_hunt/proc/end_hunt(mob/user, mob/target)
	to_chat(user, span_warning("You remove [target.real_name] from the Hunted list."))
	UnregisterSignal(target, list(COMSIG_LIVING_DEATH, COMSIG_QDELETING, COMSIG_LIVING_GIBBED))
	log_game("[user.real_name] ended a bloodhunt on [target.real_name].")
	message_admins("[ADMIN_LOOKUPFLW(user)]] ended a bloodhunt on [target.real_name].")
	target.clear_blood_hunt()

/obj/item/blood_hunt/proc/complete_hunt(mob/target)
	SIGNAL_HANDLER

	UnregisterSignal(target, list(COMSIG_LIVING_DEATH, COMSIG_QDELETING, COMSIG_LIVING_GIBBED))
	target.clear_blood_hunt()

// This code is for reinforcing a player's masquerade.
/obj/item/blood_hunt/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!ishuman(interacting_with))
		return NONE
	if(!get_kindred_splat(interacting_with))
		return ITEM_INTERACT_BLOCKING

	to_chat(user, span_notice("You hold the [src] up to [interacting_with]..."))
	if(!do_after(user, 10 SECONDS, interacting_with))
		return ITEM_INTERACT_BLOCKING
	if(SSmasquerade.masquerade_reinforce(src, interacting_with, MASQUERADE_REASON_PREFERENCES))
		to_chat(user, span_notice("You pardon [interacting_with]'s masquerade breach!"))
		return ITEM_INTERACT_SUCCESS
	to_chat(user, span_notice("[interacting_with]'s masquerade breach isn't worthy enough to be pardoned!"))
	return ITEM_INTERACT_BLOCKING
