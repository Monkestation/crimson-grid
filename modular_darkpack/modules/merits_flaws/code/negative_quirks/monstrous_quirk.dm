/datum/quirk/darkpack/monstrous
	name = "Monstrous"
	desc = "Your physical form was twisted and reflects your beastly state openly, clearly not of natural source to any who lay eyes upon it. You barely recognize yourself in the mirror as you look more like a savage monster than human. Your appearance rating must always be zero, and your appearance violates the Masquerade, meaning you must always wear a mask in public. Nosferatu and other bloodlines whose appearance start at zero cannot take this flaw."
	value = -3
	mob_trait = TRAIT_MONSTROUS
	gain_text = span_notice("Your physical form is corrupted, taking a horrific appearance...")
	lose_text = span_notice("Your appearance softens, as though a great weight is lifted - you may bare your face again.")
	allowed_splats = list(SPLAT_KINDRED, SPLAT_GAROU)
	excluded_clans = list(VAMPIRE_CLAN_KIASYD, VAMPIRE_CLAN_GARGOYLE, VAMPIRE_CLAN_NOSFERATU, VAMPIRE_CLAN_CAPPADOCIAN, VAMPIRE_CLAN_SAMEDI, VAMPIRE_CLAN_HARBINGER)
	icon = FA_ICON_FACE_ANGRY
	failure_message = "Your appearance softens, as though a great weight is lifted - you may bare your face again."
	quirk_flags = QUIRK_CHANGES_APPEARANCE

/datum/quirk/darkpack/monstrous/add(client/client_source)
	var/mob/living/carbon/human/human_holder = astype(quirk_holder)
	if(!human_holder)
		return
	human_holder.rot_body(1)
	ADD_TRAIT(human_holder, TRAIT_MASQUERADE_VIOLATING_FACE, type)
	human_holder.st_add_stat_clamp(STAT_APPEARANCE, 0, type)

/datum/quirk/darkpack/monstrous/remove()
	. = ..()
	quirk_holder.st_remove_stat_clamp(STAT_APPEARANCE, type)
