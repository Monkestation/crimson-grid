/obj/item/occult_artifact/holy
	abstract_type = /obj/item/occult_artifact/holy

/obj/item/occult_artifact/holy/identify(mob/living/artifact_identifier)
	// Identification rituals dont work for this mainly useful for later balancing to prevent holy wizards
	if(!artifact_identifier?.mind?.holy_role)
		return
	return ..()

/obj/item/occult_artifact/holy/examine(mob/user)
	if(!user?.mind?.holy_role)
		return list(span_warning("You cannot decipher this artifact."))
	return ..()

/obj/item/occult_artifact/holy/examine_more(mob/user)
	if(!user?.mind?.holy_role)
		return list(span_warning("You cannot decipher this artifact."))
	return ..()

/obj/item/occult_artifact/holy/attack_self(mob/user, modifiers)
	if(!user?.mind?.holy_role)
		to_chat(user, span_warning("You cannot decipher this artifact."))
		return
	return ..()

/obj/item/occult_artifact/holy/inquisitors_relic
	name = "silver ring"
	desc = "A old silver ring"
	true_name = "Ring of Chrysostom"
	true_desc = "Grants the wearer access to the power of true faith when worn"
	icon_state = "silver_ring"
	worn_icon = 'modular_darkpack/modules/occult_artifacts/icons/fetishes_worn.dmi'//if litterally anyone has better sprites replace this
	worn_icon_state = "bangle"
	slot_flags = ITEM_SLOT_GLOVES
	research_value = 1 //Shouldnt be applicable except for rare cases
	var/datum/mind/granted_mind
	var/previous_holy_role = NONE

/obj/item/occult_artifact/holy/inquisitors_relic/Destroy()
	restore_holy_role()
	return ..()

/obj/item/occult_artifact/holy/inquisitors_relic/grant_powers()
	. = ..()
	update_holy_role()

/obj/item/occult_artifact/holy/inquisitors_relic/ungrant_powers()
	. = ..()
	restore_holy_role()

/obj/item/occult_artifact/holy/inquisitors_relic/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	if(slot == ITEM_SLOT_GLOVES && owner == user)
		update_holy_role()

/obj/item/occult_artifact/holy/inquisitors_relic/dropped(mob/user, silent = FALSE)
	restore_holy_role()
	. = ..()

/obj/item/occult_artifact/holy/inquisitors_relic/process(seconds_per_tick)
	. = ..()
	update_holy_role()

/obj/item/occult_artifact/holy/inquisitors_relic/proc/restore_holy_role()
	if(!granted_mind)
		return
	if(granted_mind.holy_role == HOLY_ROLE_PRIEST)
		granted_mind.set_holy_role(previous_holy_role)
	granted_mind = null
	previous_holy_role = NONE

/obj/item/occult_artifact/holy/inquisitors_relic/proc/update_holy_role()
	var/mob/living/carbon/human/wearer = owner
	if(!istype(wearer) || wearer.gloves != src || !wearer.mind)
		restore_holy_role()
		return
	if(granted_mind == wearer.mind)
		return
	restore_holy_role()
	if(wearer.mind.holy_role >= HOLY_ROLE_PRIEST)
		return
	granted_mind = wearer.mind
	previous_holy_role = granted_mind.holy_role
	granted_mind.set_holy_role(HOLY_ROLE_PRIEST)
