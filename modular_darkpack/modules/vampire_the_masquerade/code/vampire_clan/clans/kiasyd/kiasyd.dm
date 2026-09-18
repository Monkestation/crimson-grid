/datum/subsplat/vampire_clan/kiasyd
	name = "Kiasyd"
	id = VAMPIRE_CLAN_KIASYD
	desc = "The Kiasyd are a bloodline of the Lasombra founded after a mysterious \"accident\" involving the Lasombra Marconius of Strasbourg. The \"accident\", involving faeries and the blood of \"Zeernebooch, a god of the Underworld\", resulted in Marconius gaining several feet in height, turning chalky white and developing large, elongated black eyes."
	icon = "kiasyd"
	curse = "At a glance they look unsettling or perturbing to most, their appearance closely resembles fae from old folklore. Kiasyd are also in some way connected with changelings and they are vulnerable to cold iron."
	sense_the_sin_text = "is afraid of cold iron."
	clan_disciplines = list(
		/datum/discipline/dominate,
		/datum/discipline/obtenebration,
		/datum/discipline/mytherceria
	)
	subsplat_traits = list(
		TRAIT_MASQUERADE_VIOLATING_EYES
	)
	alt_sprite = "kiasyd"
	no_facial = TRUE
	male_clothes = /obj/item/clothing/under/vampire/archivist
	female_clothes = /obj/item/clothing/under/vampire/archivist
	whitelisted = TRUE
	clan_marks = list(/datum/bodypart_overlay/simple/clan_mark/fae_ears)

/datum/subsplat/vampire_clan/kiasyd/on_gain(mob/living/carbon/human/gaining_mob, datum/splat/gaining_splat, joining_round)
	. = ..()
	/*
	// Kiasyd are made taller and thinner
	if (gaining_mob.has_quirk(/datum/quirk/dwarf))
		gaining_mob.remove_quirk(/datum/quirk/dwarf)
	else if (!gaining_mob.has_quirk(/datum/quirk/tower))
		gaining_mob.add_quirk(/datum/quirk/tower)
	*/

	var/obj/item/organ/eyes/kiasyd/weird_eyes = new()
	weird_eyes.Insert(gaining_mob, TRUE, DELETE_IF_REPLACED)

/datum/subsplat/vampire_clan/kiasyd/on_lose(mob/living/carbon/human/losing_mob)
	. = ..()

	/*
	if (losing_mob.has_quirk(/datum/quirk/tower))
		losing_mob.remove_quirk(/datum/quirk/tower)
	else
		losing_mob.add_quirk(/datum/quirk/dwarf)
	*/

	// replace eyes
	var/eye_type = /obj/item/organ/eyes
	if(losing_mob.dna.species && losing_mob.dna.species.mutanteyes)
		eye_type = losing_mob.dna.species.mutanteyes
	var/obj/item/organ/eyes/new_eyes = new eye_type()
	new_eyes.Insert(losing_mob, TRUE, DELETE_IF_REPLACED)

	losing_mob.update_body()

/datum/subsplat/vampire_clan/kiasyd/on_join_round(mob/living/carbon/human/joining)
	. = ..()

	//give them sunglasses to hide their freakish eyes
	var/obj/item/clothing/glasses/vampire/sun/new_glasses = new(joining.loc)
	joining.equip_to_appropriate_slot(new_glasses, TRUE)


/obj/item/organ/eyes/kiasyd
	eye_icon = 'modular_darkpack/modules/vampire_the_masquerade/icons/human_eyes.dmi'
	eye_icon_state = "kiasyd"
	eye_color_left = "#FFFFFF"
	eye_color_right = "#FFFFFF"

	iris_overlay = null
	blink_animation = FALSE
