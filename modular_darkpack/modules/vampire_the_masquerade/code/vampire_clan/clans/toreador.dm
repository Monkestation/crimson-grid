/datum/subsplat/vampire_clan/toreador
	name = "Toreador"
	id = VAMPIRE_CLAN_TOREADOR
	desc = "Known for their seductive nature, enthralling demeanor, and eloquent grace to the point of obsession, Toreador vampires Embrace artists and lovers into their ranks, forever trying to stir their own deadened hearts. Supernaturally graceful and charming, the Divas are always looking for the next thrill, leaving a detritus of discarded lovers and victims in their wake. The Toreador are lovers of beauty and anything artistic, who are common in Kindred high society. Strongly aligned with the Camarilla, they concern themselves with culture and influence. Some are patrons of the arts, while others obsess over modern trends and fleeting sensations. Anything can be art, if the Toreador regards it as such. Their curse causes them to become dangerously entranced by beauty and emotion."
	icon = "toreador"
	curse = "Doubled humanity changes."
	roleplay_level = "Beginner Friendly"
	sense_the_sin_text = "is obsessive to a fault."
	clan_disciplines = list(
		/datum/discipline/auspex,
		/datum/discipline/celerity,
		/datum/discipline/presence
	)
	subsplat_traits = list(
		TRAIT_SENSITIVE_HUMANITY
	)
	male_clothes = /obj/item/clothing/under/vampire/toreador
	female_clothes = /obj/item/clothing/under/vampire/toreador/female
	subsplat_keys = /obj/item/vamp/keys/toreador

/datum/subsplat/vampire_clan/toreador/psychomania_effect(mob/living/target, mob/living/owner)
	// CRIMSON GRID ADD: DARK THAUMATURGY. BEFORE:
	/* target.playsound_local(target, "modular_darkpack/modules/powers/sounds/daimonion_laughs/demonlaugh2.ogg", 50, FALSE)
	new /datum/hallucination/fire(target, TRUE)
	to_chat(target, span_cult("FLAMES ENGULF MY BEAUTY"))
	target.Paralyze(5 SECONDS) */
	to_chat(target, span_cult("THE BEAST SCREAMS IN MY MIND TO RUN"))
	new /obj/effect/client_image_holder/baali_demon(get_turf(target), list(target))
	// CRIMSON GRID ADD END: DARK THAUMATURGY

/datum/subsplat/vampire_clan/toreador/volgirre
	name = "Volgirre Toreador"
	id = VAMPIRE_CLAN_VOLGIRRE_TOREADOR
	icon = "volgirre_toreador"
	desc = "'Art is the truth. Life is the lie.'\n\nBeauty as suffering, and flesh as canvas- the one-to-two dozen descendents of Baron Volgirre, one of the biggest influences on the Toreador clan- and disciple of the fleshcrafting Dragons, are masters of the patrician arts just as much as they are masters of fleshcrafting- and what passion they feel for their gifts they likely also feel in hate for their collective sirer. Though nominally aligned with the Sabbat as part of their rebellion, many of this bloodline's members find themselves among the Camarilla and Anarchs. Their unique teachings, however, force them to hide their learned urges and sadistic proclivities from the sects at large."
	roleplay_level = "Advanced"
	sense_the_sin_text = "sees you as a canvas, too."
	clan_disciplines = list(
		/datum/discipline/auspex,
		/datum/discipline/celerity,
		/datum/discipline/presence,
		/datum/discipline/vicissitude
	)
