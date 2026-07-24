// VTM pg. 482
/datum/quirk/darkpack/glowing_eyes
	name = "Glowing Eyes"
	desc = {"You have the stereotypical glowing eyes of vampire legend, giving you a -1 difficulty when intimidating mortals.
However, you MUST constantly disguise your condition, and the glow impairs your vision."}
	icon = FA_ICON_EYE
	value = -3
	gain_text = span_notice("Your eyes glow with an unnatural light!")
	lose_text = span_notice("The light in your eyes fades.")
	failure_message = span_notice("The light in your eyes fades.")
	mob_trait = TRAIT_GLOWING_EYES
	allowed_splats = list(SPLAT_KINDRED)
	excluded_clans = list(VAMPIRE_CLAN_KIASYD)// They already have masq violating eyes!

/*You have the stereotypical glowing eyes of vampire
legend, which gives you a -1 difficulty on Intimidation
rolls when you’re dealing with mortals. However, the
tradeoffs are many; you must constantly disguise your
condition (no, contacts don’t cut it); the glow impairs
your vision and puts you at +1 difficulty on all sight
based rolls (including the use of ranged weapons); and
the radiance emanating from your eye sockets makes
it difficult to hide (+2 difficulty to Stealth rolls) in the
dark.*/

/datum/quirk/darkpack/glowing_eyes/add(client/client_source)
	. = ..()
	var/mob/living/carbon/human/human_holder = astype(quirk_holder)
	if(!human_holder)
		return
	ADD_TRAIT(quirk_holder, TRAIT_LUMINESCENT_EYES, QUIRK_TRAIT)
	ADD_TRAIT(quirk_holder, TRAIT_MASQUERADE_VIOLATING_EYES, QUIRK_TRAIT)
	human_holder.st_add_stat_mod(STAT_PERCEPTION, -1, "Glowing Eyes") // I guess this works. what would count as a sight-based roll is beyond me rn
	var/obj/item/clothing/glasses/vampire/sun/new_glasses = new(human_holder.loc) // Give them glasses so they aren't immediately breaching on spawn or anything
	human_holder.equip_to_appropriate_slot(new_glasses, TRUE)

/datum/quirk/darkpack/glowing_eyes/remove()
	. = ..()
	var/mob/living/carbon/human/human_holder = astype(quirk_holder)
	if(!human_holder)
		return
	REMOVE_TRAIT(quirk_holder, TRAIT_LUMINESCENT_EYES, QUIRK_TRAIT)
	REMOVE_TRAIT(quirk_holder, TRAIT_MASQUERADE_VIOLATING_EYES, QUIRK_TRAIT)
	human_holder.st_remove_stat_mod(STAT_PERCEPTION, "Glowing Eyes")

