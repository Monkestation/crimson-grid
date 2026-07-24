/obj/item/ritual_tome/abyss
	name = "mystic tome"
	desc = "The secrets of Abyss Mysticism..."
	icon_state = "mystic"
	icon = 'modular_darkpack/modules/ritual_abyss_mysticism/icons/abyss_mysticism_tome.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/ritual_abyss_mysticism/icons/abyss_mysticism_onfloor.dmi')
	rune_type = /obj/ritual_rune/abyss
	discipline_type = /datum/discipline/obtenebration
	custom_materials = list(/datum/material/paper = SHEET_MATERIAL_AMOUNT * 0.75, /datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT)

/obj/item/ritual_tome/abyss/attack_self(mob/user)
	var/mob/living/living_user = astype(user)
	if(!living_user)
		return
	if(!living_user.get_discipline(/datum/discipline/obtenebration))
		to_chat(user, span_cult("A very dark book in color whose appearance swallows up your vision. You find it impossible to decipher without proper guidance."))
		return
	. = ..()

/datum/crafting_recipe/mystome
	name = "Abyss Mysticism Tome"
	time = 10 SECONDS
	reqs = list(/obj/item/paper = 3, /obj/item/reagent_containers/blood = 1)
	result = /obj/item/ritual_tome/abyss
	category = CAT_MISC
	skill_required_for_use = STAT_OCCULT
	skill_dots_minimum = 1

/datum/crafting_recipe/mystome/is_recipe_available(mob/user)
	. = ..()
	var/mob/living/living_user = astype(user)
	if(!living_user?.get_discipline(/datum/discipline/obtenebration))
		return FALSE

