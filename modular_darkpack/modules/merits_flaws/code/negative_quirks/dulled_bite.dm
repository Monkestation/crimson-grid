// V20 p. 481
/datum/quirk/darkpack/dulled_bite
	name = "Dulled Bite"
	desc = "For some reason your fangs never developed fully, or they may not have manifested at all. When feeding, you need to find some other method of making the blood flow. A number of Caitiff and high Generation vampires often manifest this Flaw."
	value = -2
	mob_trait = TRAIT_DULLFANGS
	gain_text = span_notice("Your fangs feel dull.")
	lose_text = span_notice("Your fangs feel sharp.")
	allowed_splats = list(SPLAT_KINDRED)
	icon = FA_ICON_TEETH
	failure_message = "Your fangs feel sharp."


/datum/status_effect/dull_fangs // Applied when pliers are used on vampires without the dulled bite quirk.
	id = "dulled_fangs"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 10 SCENES // Around 30 minutes
	remove_on_fullheal = TRUE
	alert_type = /atom/movable/screen/alert/status_effect/dull_fangs

/atom/movable/screen/alert/status_effect/dull_fangs
	name = "Pulled Teeth"
	desc = "Your canines have been yanked out!"
	icon = 'modular_darkpack/modules/deprecated/icons/hud/screen_alert.dmi'
	icon_state = "default"

/datum/status_effect/dull_fangs/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_DULLFANGS, MAGIC_TRAIT)

/datum/status_effect/dull_fangs/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_DULLFANGS, MAGIC_TRAIT)

/datum/status_effect/dull_fangs/permanent // Applied when pliers are used on vampires without the dulled bite quirk.
	id = "dulled_fangs_permanent"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1 // Lasts all round.
	remove_on_fullheal = FALSE // Doesn't remove on fullheal.
	alert_type = /atom/movable/screen/alert/status_effect/dull_fangs
