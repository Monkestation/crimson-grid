/datum/quirk/darkpack/forked_tongue
	name = "Forked Tongue"
	desc = "You have a forked tongue that makes pronouncing the letter s sound like hissing."
	icon = FA_ICON_S
	value = -1
	allowed_splats = list(SPLAT_KINDRED)
	included_clans = list(VAMPIRE_CLAN_SETITE, VAMPIRE_CLAN_WARRIOR_SETITE, VAMPIRE_CLAN_TLACIQUE)
	/// The original tongue from before the forked one was applied
	var/obj/item/organ/old_organ

/datum/quirk/darkpack/forked_tongue/add_unique(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	old_organ = human_holder.get_organ_slot(ORGAN_SLOT_TONGUE)
	var/obj/item/organ/tongue/lizard/forked = new
	forked.Insert(human_holder, special = TRUE)
	if(old_organ)
		old_organ.moveToNullspace()
		STOP_PROCESSING(SSobj, old_organ)

/datum/quirk/darkpack/forked_tongue/remove()
	if(old_organ)
		old_organ.Insert(quirk_holder, special = TRUE)
	old_organ = null

/datum/quirk/darkpack/permafangs/fake
	name = "Cosmetic Fangs"
	desc = "You've had your teeth filed or are wearing prosthetics for one reason or another, giving the appearance of fangs in your mouth. Many view your fangs as something exotic or eccentric but a few superstitious may find this more than exotic..."
	value = -1
	gain_text = span_notice("Your feel your teeth becoming sharp")
	lose_text = span_notice("You feel your teeth becoming normal again.")
	allowed_splats = list(SPLAT_NONE, SPLAT_GHOUL)
	failure_message = "You feel your teeth becoming normal again."

/datum/quirk/darkpack/homestuck
	name = "Home Stuck"
	desc = "Your speech is hard to understand for others."
	value = 0
	icon = FA_ICON_HOUSE_USER
	allowed_splats = list(SPLAT_KINDRED, SPLAT_GHOUL)
	included_clans = list(VAMPIRE_CLAN_MALKAVIAN)

/datum/quirk/darkpack/homestuck/add(client/client_source)
	quirk_holder.AddComponent(/datum/component/speechmod, replacements = list("a"="4", "A"="4", "i"="1", "I"="1", "e"="3", "E"="3"), uppercase = TRUE)

/datum/quirk/darkpack/ghoul_armblade
	name = "Armblade"
	desc = "Through vicissitude, one of your arms has been given a horrifyingly sharp bone blade that is concealed."
	value = 5
	icon = FA_ICON_PERSON_RIFLE
	allowed_splats = list(SPLAT_GHOUL)
	included_clans = list(VAMPIRE_CLAN_TZIMISCE)

/datum/quirk/darkpack/ghoul_armblade/add_unique(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/obj/item/organ/cyberimp/arm/toolkit/tzimisce/arm_blade = new()
	arm_blade.Insert(human_holder)
