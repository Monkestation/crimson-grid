/datum/quirk/darkpack/eat_food
	name = "Eat Food"
	desc = "Unlike most of the Undead, you retain the ability to eat and digest food normally, a semblance of your mortal life. While you gain no nourishment from it, you can consume food without the usual revulsion Kindred experience. Be warned: what goes down must come up, eventually."
	ttrpg_sources = list(/datum/source_book/vtm20 = 480)
	value = 1
	mob_trait = TRAIT_EAT_FOOD
	gain_text = span_notice("Your stomach stirs as you feel the organ come to life. You can now eat food.")
	lose_text = span_notice("The ability to eat food fades from you.")
	allowed_splats = list(SPLAT_KINDRED)
	icon = FA_ICON_UTENSILS

/datum/quirk/darkpack/eat_food/add(client/client_source)
	var/mob/living/carbon/human/human_holder = astype(quirk_holder)
	if(!human_holder)
		return
	var/obj/item/organ/tongue/tongue = human_holder.get_organ_by_type(/obj/item/organ/tongue)
	tongue?.liked_foodtypes = initial(tongue.liked_foodtypes)
	tongue?.disliked_foodtypes = initial(tongue.disliked_foodtypes)
	tongue?.toxic_foodtypes = initial(tongue.toxic_foodtypes)
