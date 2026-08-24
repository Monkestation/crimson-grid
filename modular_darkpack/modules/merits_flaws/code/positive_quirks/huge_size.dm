/datum/quirk/darkpack/huge_size
	name = "Huge size"
	desc = {"You are abnormally large in size, at least 6'10" and
300 pounds in weight (well over two meters tall and
over 130 kgs). Aside from making you extremely no
ticeable in public, this extra mass bestows an additional
20 health. Characters with this Merit may also gain bonuses to
bash down doors."}
/* Characters with this Merit may
also gain bonuses to push objects, open barred doors,
avoid being knocked down, etc*/
	ttrpg_sources = list(/datum/source_book/vtm20 = 480)
	mob_trait = TRAIT_HUGE_SIZE
	icon = FA_ICON_ARROW_UP
	value = 4
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_CHANGES_APPEARANCE
	gain_text = span_notice("You feel larger than average.")
	lose_text = span_notice("You don't feel so big now.")
	failure_message = span_notice("You don't feel so big now.")


/datum/quirk/darkpack/huge_size/add(client/client_source)
	. = ..()
	var/mob/living/carbon/human/human_holder = astype(quirk_holder)
	if(!human_holder)
		return
	human_holder.maxHealth += 20
	human_holder.health += 20
	human_holder.update_transform(1.25) //Same as TRAIT_GIANT. Maybe a bit excessive.

/datum/quirk/darkpack/huge_size/remove()
	. = ..()
	var/mob/living/carbon/human/human_holder = astype(quirk_holder)
	if(!human_holder)
		return
	human_holder.maxHealth -= 20
	human_holder.health -= 20
	human_holder.update_transform(1)
