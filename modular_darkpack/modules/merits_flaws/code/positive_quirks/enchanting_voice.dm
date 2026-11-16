/datum/quirk/darkpack/enchanting_voice
	name = "Enchanting Voice"
	desc = "There is something about your voice that others cannot ignore. When you command, they are cowed. When you seduce, they swoon. Whether thundering, soothing, persuading, or simply talking, your voice commands attention. The difficulties of all rolls involving the use of the voice (Such as Presence, Dominate or Melpominee) to persuade, charm, or command are reduced by two."
	ttrpg_sources = list(/datum/source_book/vtm20 = 480)
	value = 2
	mob_trait = TRAIT_ENCHANTING_VOICE
	gain_text = span_notice("Your voice is somehow more significant and people are sure to listen when you speak.")
	lose_text = span_notice("Your voice is back to average.")
	allowed_splats = list(SPLAT_KINDRED)
	icon = FA_ICON_PODCAST

