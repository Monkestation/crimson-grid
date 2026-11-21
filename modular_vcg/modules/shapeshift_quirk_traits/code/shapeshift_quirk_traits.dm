/datum/quirk/darkpack
	/// Copy mob_trait onto the animal form while the holder is shapeshifted. Only for quirks whose whole effect is the trait.
	var/keep_trait_on_shapeshift = FALSE

/datum/quirk/darkpack/add_to_holder(mob/living/new_holder, quirk_transfer = FALSE, client/client_source, unique = TRUE, announce = TRUE)
	. = ..()
	if(. && mob_trait && keep_trait_on_shapeshift)
		RegisterSignal(quirk_holder, COMSIG_LIVING_SHAPESHIFTED, PROC_REF(on_holder_shapeshifted))

/datum/quirk/darkpack/remove_from_current_holder(quirk_transfer = FALSE)
	UnregisterSignal(quirk_holder, COMSIG_LIVING_SHAPESHIFTED)
	return ..()

/datum/quirk/darkpack/proc/on_holder_shapeshifted(mob/living/source, mob/living/shape)
	SIGNAL_HANDLER
	ADD_TRAIT(shape, mob_trait, QUIRK_TRAIT)

/datum/quirk/darkpack/touch_of_the_wyld
	keep_trait_on_shapeshift = TRUE

/datum/quirk/darkpack/pale_aura
	keep_trait_on_shapeshift = TRUE

/datum/quirk/darkpack/deceptive_aura
	keep_trait_on_shapeshift = TRUE

/datum/quirk/darkpack/hidden_diablerie
	keep_trait_on_shapeshift = TRUE

/datum/quirk/darkpack/iron_will
	keep_trait_on_shapeshift = TRUE

/datum/quirk/darkpack/unbondable
	keep_trait_on_shapeshift = TRUE

/datum/quirk/darkpack/untamable
	keep_trait_on_shapeshift = TRUE

/datum/quirk/darkpack/weak_willed
	keep_trait_on_shapeshift = TRUE

/datum/quirk/darkpack/calm_heart
	keep_trait_on_shapeshift = TRUE

/datum/quirk/darkpack/coldly_logical
	keep_trait_on_shapeshift = TRUE

/datum/quirk/darkpack/time_sense
	keep_trait_on_shapeshift = TRUE

/datum/quirk/darkpack/uncontrollable
	keep_trait_on_shapeshift = TRUE

/datum/quirk/darkpack/betrayers_mark
	keep_trait_on_shapeshift = TRUE

/datum/quirk/darkpack/beacon_of_the_unholy
	keep_trait_on_shapeshift = TRUE

/datum/quirk/darkpack/pierced_veil
	keep_trait_on_shapeshift = TRUE

/datum/quirk/darkpack/smell_of_the_grave
	keep_trait_on_shapeshift = TRUE

/datum/quirk/darkpack/animal_musk
	keep_trait_on_shapeshift = TRUE

/datum/quirk/darkpack/light_sensitive
	keep_trait_on_shapeshift = TRUE

/datum/quirk/darkpack/thirst_of_ages
	keep_trait_on_shapeshift = TRUE
