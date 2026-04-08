/datum/quirk/darkpack/monstrous
	name = "Monstrous"
	desc = "Your physical form was twisted during the embrace and now reflects the Beast that rages inside you. You barely recognize yourself in the mirror as you look more like a savage monster than human, and obviously vampiric. Your appearance rating must always be zero, and your appearance violates the Masquerade, meaning you must always wear a mask in public. Nosferatu and other bloodlines whose appearance start at zero cannot take this flaw."
	value = -3
	mob_trait = TRAIT_MONSTROUS
	gain_text = span_notice("The Beast rages inside you and corrupts your physical form!")
	lose_text = span_notice("The Beast subsides and your appearance begins to look similar to how Kindred usually appear.")
	allowed_splats = list(SPLAT_KINDRED)
	excluded_clans = list(VAMPIRE_CLAN_KIASYD, VAMPIRE_CLAN_GARGOYLE, VAMPIRE_CLAN_NOSFERATU, VAMPIRE_CLAN_CAPPADOCIAN, VAMPIRE_CLAN_SAMEDI, VAMPIRE_CLAN_HARBINGER)
	icon = FA_ICON_FACE_ANGRY
	failure_message = "The Beast subsides and your appearance begins to look similar to how Kindred usually appear."

/datum/quirk/darkpack/monstrous/add_to_holder(mob/living/new_holder, quirk_transfer, client/client_source, unique, announce)
	. = ..()
	if(ishuman(new_holder))
		var/mob/living/carbon/human/human_holder = new_holder
		human_holder.rot_body(1)
		ADD_TRAIT(human_holder, TRAIT_MASQUERADE_VIOLATING_FACE, "Monstrous")
		if(human_holder.st_get_stat(STAT_APPEARANCE) > 0)
			human_holder.st_add_stat_mod(STAT_APPEARANCE, -(STAT_APPEARANCE), "Monstrous")
