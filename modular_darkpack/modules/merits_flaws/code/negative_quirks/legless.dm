// VTM pg. 482 (Lame, taken to its extreme)
/datum/quirk/darkpack/legless
	name = "Legless"
	desc = "Both of your legs are gone. You get around in a wheelchair, and nothing is ever going to change that."
	icon = FA_ICON_WHEELCHAIR
	value = -10
	gain_text = span_warning("You can't feel your legs!")
	lose_text = span_notice("Huh? Your legs are back...")
	failure_message = span_notice("You can feel your legs again.")
	quirk_flags = QUIRK_CHANGES_APPEARANCE

/datum/quirk/darkpack/legless/add(client/client_source)
	. = ..()
	var/mob/living/carbon/human/human_holder = astype(quirk_holder)
	if(!human_holder)
		return
	human_holder.gain_trauma(/datum/brain_trauma/severe/paralysis/paraplegic, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/darkpack/legless/add_unique(client/client_source)
	var/mob/living/carbon/human/human_holder = astype(quirk_holder)
	if(!human_holder)
		return

	qdel(human_holder.get_item_by_slot(ITEM_SLOT_FEET))
	qdel(human_holder.get_bodypart(BODY_ZONE_L_LEG))
	qdel(human_holder.get_bodypart(BODY_ZONE_R_LEG))

	if(human_holder.buckled)
		human_holder.buckled.unbuckle_mob(human_holder)

	var/turf/holder_turf = get_turf(human_holder)
	var/obj/vehicle/ridden/wheelchair/wheels = new(holder_turf)
	wheels.buckle_mob(human_holder)

	// The paralysis can make them drop what they spawned holding
	for(var/obj/item/dropped_item in holder_turf)
		if(dropped_item.fingerprintslast == human_holder.ckey)
			human_holder.put_in_hands(dropped_item)

/datum/quirk/darkpack/legless/remove()
	. = ..()
	var/mob/living/carbon/human/human_holder = astype(quirk_holder)
	human_holder?.cure_trauma_type(/datum/brain_trauma/severe/paralysis/paraplegic, TRAUMA_RESILIENCE_ABSOLUTE)
