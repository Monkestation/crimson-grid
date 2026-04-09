/datum/quirk/darkpack/the_largest_maw
	name = "The Largest Maw"
	desc = "Due to the size of your shark-like rows of teeth, you find it hard to communicate verbally. Instead, you speak through pools of spit and sometimes bite your own teeth in the process. This makes you quieter than other Nagaraja, always stuck whispering."
	icon = FA_ICON_COMMENT
	value = -2
	mob_trait = TRAIT_SOFTSPOKEN
	gain_text = span_danger("Your teeth shift uncomfortably, taking more room in your mouth - it seems difficult to speak.")
	lose_text = span_notice("Your teeth seemingly retract, leaving your voice louder than it was before.")
	allowed_splats = list(SPLAT_KINDRED)
	included_clans = list(VAMPIRE_CLAN_NAGARAJA)
