/datum/species/human/shifter/war/on_species_gain(mob/living/carbon/human/human_who_gained_species, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	human_who_gained_species.apply_status_effect(/datum/status_effect/fortitude/three)

/datum/species/human/shifter/war/on_species_loss(mob/living/carbon/human/human, datum/species/new_species, pref_load)
	. = ..()
	human.remove_status_effect(/datum/status_effect/fortitude/three)

/datum/species/human/shifter/dire/on_species_gain(mob/living/carbon/human/human_who_gained_species, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	human_who_gained_species.apply_status_effect(/datum/status_effect/fortitude/two)

/datum/species/human/shifter/dire/on_species_loss(mob/living/carbon/human/human, datum/species/new_species, pref_load)
	. = ..()
	human.remove_status_effect(/datum/status_effect/fortitude/two)
