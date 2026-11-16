// V20 Lore of the Clans - pages 238-239
/datum/quirk/darkpack/promethean_clay
	name = "Promethean Clay"
	desc = "(Note: currently RP-only merit. Actual functionality is still in development) Your flesh ripples and molds itself to your preternatural will, almost before you consciously invoke the change. The difficulty to use any Vicissitude power on yourself is two less than normal, and you may activate Vicissitude powers reflexively at your full dice pool while taking other actions. Powers that require multiple turns to activate still require the usual duration. The change simply occurs without conscious direction. As a final benefit, you need no physical sculpting to use the first three levels of Vicissitude on yourself, as your flesh undulates and extrudes to its desired shape. Only characters with at least one dot of Vicissitude may purchase this Merit."
	ttrpg_sources = list(/datum/source_book/vtm20/lotc = 238)
	value = 5
	mob_trait = TRAIT_PROMETHEAN_CLAY
	gain_text = span_notice("You feel a profound oneness with your undead flesh. You are writhing under your own skin, and it shimmers in response, eager to answer your will and mold like clay to your designs.")
	lose_text = span_notice("Something feels... off. You are disconnected from your flesh. The indelible unity of your will and your undead form feels strained, and the preternatural responsiveness of your flesh fades.")
	allowed_splats = list(SPLAT_KINDRED)
	included_clans = list(VAMPIRE_CLAN_TZIMISCE)
	icon = FA_ICON_PERSON_BURST
	failure_message = "Something is wrong. The preternatural responsiveness of your flesh fades."
	roleplay_only = TRUE // REMOVE THIS WHEN PROMETHEAN CLAY MERIT IS IMPLEMENTED IN FULL

// hey, have you removed roleplay only after fully developing this merit? remove this too. did you remove it yet?
