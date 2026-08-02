/datum/quirk/darkpack/speech_impediment
	name = "Speech Impediment"
	desc = "You have a stammer that hampers verbal communication."
	icon = FA_ICON_COMMENT_SLASH
	ttrpg_sources = list(/datum/source_book/vtm20 = 485)
	value = -1
	gain_text = span_danger("You start worrying about what you're saying.")
	lose_text = span_notice("You feel easier about talking again.")

/datum/quirk/darkpack/speech_impediment/add(client/client_source)
	quirk_holder.apply_status_effect(/datum/status_effect/speech/stutter/impediment, INFINITY)

/datum/quirk/darkpack/speech_impediment/remove()
	quirk_holder.remove_status_effect(/datum/status_effect/speech/stutter/impediment)


/datum/status_effect/speech/stutter/impediment
	id = "speech_impediment_stutter"
	stutter_prob = 10
	remove_on_fullheal = FALSE
