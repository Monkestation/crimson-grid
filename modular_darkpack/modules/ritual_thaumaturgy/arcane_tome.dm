/obj/item/ritual_tome/arcane
	name = "arcane tome"
	desc = "The secrets of Blood Magic..."
	icon_state = "arcane"
	icon = 'modular_darkpack/modules/ritual_thaumaturgy/icons/arcane_tome.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/ritual_thaumaturgy/icons/arcane_tome_onfloor.dmi')
	rune_type = /obj/ritual_rune/thaumaturgy

/obj/item/ritual_tome/arcane/attack_self(mob/user)
	var/mob/living/living_user = astype(user)
	if(!living_user || !living_user.get_discipline(/datum/discipline/thaumaturgy))
		to_chat(user, span_cult("A book whose title is inscribed in latin and coated with various sigils and shapes. You'll need a teacher if you want to learn more. For some reason it wont open."))
		return
	. = ..()

/datum/crafting_recipe/arctome
	name = "Arcane Tome"
	time = 10 SECONDS
	reqs = list(/obj/item/paper = 3, /obj/item/reagent_containers/blood = 2)
	result = /obj/item/ritual_tome/arcane
	category = CAT_MISC

/datum/crafting_recipe/arctome/is_recipe_available(mob/user)
	var/mob/living/living_user = astype(user)
	if(living_user?.get_discipline(/datum/discipline/thaumaturgy))
		return TRUE

	return FALSE
