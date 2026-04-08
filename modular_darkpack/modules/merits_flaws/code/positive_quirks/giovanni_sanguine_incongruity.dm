/datum/quirk/darkpack/giovanni_sanguine_incongruity
	name = "Sanguine Incongruity"
	desc = "Bearing the curse of a corpselike pallor and appearance of the Cappadocian blood that came before the usurpation of Clan Cappadocian, a Giovanni with this merit is afforded more leeway in the Clan, as they are either a Premascine (before the diablerie) Elder, or closer to Death than the rest of the Clan, a superstition of great Necromantic prowess. Giovanni with this merit also don't suffer the Curse of Lamia - the supernaturally painful bite that makes feeding for the Giovanni difficult. Only Giovanni may take this merit."
	value = 5
	mob_trait = TRAIT_SANGUINE_INCONGRUITY
	gain_text = span_notice("The Curse of Lamia leaves your body allowing you to feed normally, but your skin pales and becomes more corpselike.")
	lose_text = span_notice("Somehow the Giovanni's Curse of Lamia returns, and your bite becomes far more painful. At least now your skin is more flush with life.")
	allowed_splats = list(SPLAT_KINDRED)
	included_clans = list(VAMPIRE_CLAN_GIOVANNI)
	icon = FA_ICON_SKULL_CROSSBONES
	failure_message = "Somehow the Giovanni's Curse of Lamia returns, and your bite becomes far more painful. At least now your skin is more flush with life."

/datum/quirk/darkpack/giovanni_sanguine_incongruity/add_to_holder(mob/living/new_holder, quirk_transfer, client/client_source, unique, announce)
	. = ..()
	if(!ishuman(new_holder))
		return

	var/mob/living/carbon/human/human_holder = new_holder
	var/datum/splat/vampire/kindred/kindred = get_kindred_splat(human_holder)
	if(kindred)
		if(istype(kindred.clan, /datum/subsplat/vampire_clan/giovanni))
			REMOVE_TRAIT(human_holder, TRAIT_PAINFUL_VAMPIRE_KISS, CLAN_TRAIT)

			if(human_holder.chronological_age >= 300)
				human_holder.rot_body(2)
			else
				human_holder.rot_body(1)

