/datum/crafting_recipe/tzi_armblade
	name = "Armblade"
	time = 50
	reqs = list(/obj/item/stack/sheet/meat = 40, /obj/item/spine = 1, /obj/item/organ/heart = 1)
	result = /obj/item/organ/cyberimp/arm/toolkit/tzimisce
	category = CAT_TZIMISCE
	skill_required_for_use = STAT_MEDICINE
	skill_dots_minimum = 3

/datum/crafting_recipe/tzi_stomach
	name = "Secondary Stomach"
	time = 50
	reqs = list(/obj/item/stack/sheet/meat = 15, /obj/item/organ/stomach = 1)
	result = /obj/item/organ/cyberimp/chest/nutriment/tzimisce
	category = CAT_TZIMISCE

/datum/crafting_recipe/tzi_meat
	name = "meat"
	time = 50
	reqs = list(/obj/item/stack/sheet/meat = 4)
	result = /obj/item/food/meat/slab/human
	category = CAT_TZIMISCE
	skill_required_for_use = STAT_MEDICINE
	skill_dots_minimum = 3
