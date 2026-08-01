/datum/quirk/darkpack/pale_aura
	name = "Pale Aura"
	desc = {"Any color your character's aura takes has a pale cast to it, as though he was a vampire."}
		/*{"Any color your character's aura takes has a pale cast to it, as though he was a vampire.
		Unless her player gains five chapter two or more successes on an Aura Perception roll,
		any vampire discerns your character's aura as one belonging to the Kindred"}
		*/
	ttrpg_sources = list(
		/datum/source_book/ghouls_and_revenants = 137,
		/datum/source_book/hunterhunted2 = 43,
	)
	value = 2
	mob_trait = TRAIT_PALE_AURA
	icon = FA_ICON_TEMPERATURE_EMPTY
	allowed_splats = list(SPLAT_NONE, SPLAT_GHOUL)
