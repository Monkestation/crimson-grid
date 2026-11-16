/datum/quirk/darkpack/beserker
	name = "Berserker"
	desc = {"You have uncanny control over your inner anger, and can use your Rage as most Garou cannot.
		You can enter a berserk frenzy at will, ignoring your wound penalties.
		You still suffer the consequences of any actions committed in the throes of frenzy.
		When circumstances might cause you to frenzy, you must make a standard roll to see if you do so or not."}
	ttrpg_sources = list(/datum/source_book/wta20 = 476)
	value = 2
	icon = FA_ICON_ANGRY
	allowed_splats = SPLAT_SHIFTERS

/datum/quirk/darkpack/beserker/add(client/client_source)
	. = ..()
	add_verb(quirk_holder, /mob/living/carbon/human/proc/manual_frenzy)

/datum/quirk/darkpack/beserker/remove()
	. = ..()
	remove_verb(quirk_holder, /mob/living/carbon/human/proc/manual_frenzy)
