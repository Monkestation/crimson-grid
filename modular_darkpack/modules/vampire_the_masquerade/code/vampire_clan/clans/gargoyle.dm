/datum/subsplat/vampire_clan/gargoyle
	name = "Gargoyle"
	id = VAMPIRE_CLAN_GARGOYLE
	desc = "The Gargoyles are a vampiric bloodline created by the Tremere as their servitors. Although technically not a Tremere bloodline, the bloodline is largely under their control. In the Final Nights, Gargoyle populations seem to be booming; this is largely because older, free Gargoyles are coming out of hiding to join the Camarilla, because more indentured Gargoyles break free from the clutches of the Tremere, and because the free Gargoyles have also begun to Embrace more mortals on their own."
	icon = "gargoyle"
	curse = "All Gargoyles, much like the Nosferatu, are hideous to look at, a byproduct of their occult origins (and the varied Kindred stock from which they originate). This means that Gargoyles, just like the Nosferatu, have to hide their existence from common mortals, as their mere appearance is a breach of the Masquerade. In addition, the nature of the bloodline's origin manifests itself in the fact that Gargoyles are highly susceptible to mind control of any source. This weakness is intentional; a flaw placed into all Gargoyles by the Tremere in the hope that it would make them easier to control (and less likely to rebel)."
	sense_the_sin_text = "has a mind like a fortress with gates open and unbarred. "
	clan_disciplines = list(
		/datum/discipline/fortitude,
		/datum/discipline/potence,
		/datum/discipline/visceratika
	)
	subsplat_traits = list(
		TRAIT_CANNOT_RESIST_MIND_CONTROL,
		TRAIT_MASQUERADE_VIOLATING_FACE,
		TRAIT_WEAK_TO_DOMINATE,
	)
	alt_sprite = "gargoyle"
	male_clothes = /obj/item/clothing/under/vampire/malkavian
	female_clothes = /obj/item/clothing/under/vampire/malkavian
	default_accessory = "gargoyle_full"
	clan_marks = list(
		/datum/bodypart_overlay/simple/clan_mark/gargoyle/full,
		/datum/bodypart_overlay/simple/clan_mark/gargoyle/left,
		/datum/bodypart_overlay/simple/clan_mark/gargoyle/right,
		/datum/bodypart_overlay/simple/clan_mark/gargoyle/broken,
		/datum/bodypart_overlay/simple/clan_mark/gargoyle/round,
		/datum/bodypart_overlay/simple/clan_mark/gargoyle/oni,
		/datum/bodypart_overlay/simple/clan_mark/gargoyle/devil,
	)
	whitelisted = TRUE

	// Type to use for the extra clan mark they get.
	var/datum/bodypart_overlay/simple/clan_mark/gargy_tail_type = /datum/bodypart_overlay/simple/clan_mark/gargoyle/tail

/datum/subsplat/vampire_clan/gargoyle/on_gain(mob/living/carbon/human/gaining_mob, datum/splat/gaining_splat, joining_round)
	. = ..()
	gaining_mob.physiology.brute_mod = 0.8

	var/obj/item/organ/wings/functional/gargoyle/wings = new()
	wings.Insert(gaining_mob)

/datum/subsplat/vampire_clan/gargoyle/on_lose(mob/living/carbon/human/losing_mob)
	. = ..()
	losing_mob.physiology.brute_mod = 1

	var/obj/item/organ/wings/functional/gargoyle/wings = losing_mob.get_organ_slot(ORGAN_SLOT_EXTERNAL_WINGS)
	if(wings)
		wings.Remove(losing_mob)
		qdel(wings)

	var/obj/item/bodypart/part = losing_mob.get_bodypart(BODY_ZONE_CHEST)
	part.remove_bodypart_overlay(gargy_tail_type)
