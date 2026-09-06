/datum/subsplat/vampire_clan/salubri
	name = "Salubri"
	id = VAMPIRE_CLAN_HEALER_SALUBRI
	desc = "The Salubri are one of the original 13 clans of the vampiric descendants of Caine. Salubri believe that vampiric existence is torment from which Golconda or death is the only escape. Consequently, the modern Salubri would Embrace, teach a childe the basics of the route, leave clues for the childe to follow to achieve Golconda, and then have their childe diablerize them."
	icon = "salubri"
	curse = "Hunted and consensual feeding."
	sense_the_sin_text = "is ruled by consent."
	clan_disciplines = list(
		/datum/discipline/auspex,
		/datum/discipline/fortitude,
		/datum/discipline/obeah
	)
	subsplat_traits = list(
		TRAIT_CONSENSUAL_FEEDING_ONLY,
		TRAIT_IRRESISTIBLE_VITAE
	)
	male_clothes = /obj/item/clothing/under/vampire/salubri
	female_clothes = /obj/item/clothing/under/vampire/salubri/female
	enlightenment = FALSE
	subsplat_keys = /obj/item/vamp/keys/salubri

/datum/subsplat/vampire_clan/salubri/on_gain(mob/living/carbon/human/gaining_mob, datum/splat/gaining_splat, joining_round)
	. = ..()

	var/obj/item/organ/eyes/salubri/three_eyes = new()
	three_eyes.Insert(gaining_mob, TRUE, DELETE_IF_REPLACED)

/datum/subsplat/vampire_clan/salubri/on_lose(mob/living/carbon/human/losing_mob)
	. = ..()

	// replace eyes
	var/eye_type = /obj/item/organ/eyes
	if(losing_mob.dna.species && losing_mob.dna.species.mutanteyes)
		eye_type = losing_mob.dna.species.mutanteyes
	var/obj/item/organ/eyes/new_eyes = new eye_type()
	new_eyes.Insert(losing_mob, TRUE, DELETE_IF_REPLACED)

/obj/item/organ/eyes/salubri
	eye_icon = 'modular_darkpack/modules/vampire_the_masquerade/icons/human_eyes.dmi'
	eye_icon_state = "salubri"

	blink_animation = FALSE

/datum/subsplat/vampire_clan/salubri/psychomania_effect(mob/living/target, mob/living/owner)
	target.playsound_local(target, "modular_darkpack/modules/powers/sounds/daimonion_laughs/demonlaugh1.ogg", 50, FALSE)
	to_chat(target, span_warning("My third eye begins to reflexively open.."))
	target.visible_message(span_warning("[target] tightly grasps their forehead, trying to conceal something"), span_cult("I MUST HIDE MY NATURE"))
	target.apply_damage(50, BRUTE, BODY_ZONE_HEAD)
	target.Paralyze(6 SECONDS)
