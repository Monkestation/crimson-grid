/datum/crafting_recipe/tzi_armblade
	name = "Armblade"
	time = 50
	reqs = list(/obj/item/stack/sheet/meat = 30, /obj/item/spine = 1)
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

/datum/crafting_recipe/tzi_cat
	name = "flesh feline"
	time = 50
	// use the tzi plush once it transfers consciousness
	reqs = list(/obj/item/stack/sheet/meat = 20, /obj/item/guts = 1, /obj/item/spine = 1, /obj/item/organ/brain = 1)
	result = /mob/living/basic/pet/cat/darkpack/tzi
	category = CAT_TZIMISCE
	skill_required_for_use = STAT_MEDICINE
	skill_dots_minimum = 3

/mob/living/basic/pet/cat/darkpack/tzi/on_craft_completion(list/components, datum/crafting_recipe/current_recipe, atom/crafter)
	. = ..()
	var/obj/item/organ/brain/candidate = locate(/obj/item/organ/brain) in contents
	if(isnull(candidate?.brainmob?.mind))
		return
	var/datum/mind/candidate_mind = candidate.brainmob.mind
	candidate_mind.transfer_to(src)
	candidate_mind.grab_ghost()
	var/default_name = initial(name)
	var/new_name = sanitize_name(reject_bad_text(tgui_input_text(src, "You are \the [src]. Would you like to change your name to something else?", "Name change", default_name, MAX_NAME_LEN)), cap_after_symbols = FALSE)
	if(new_name)
		to_chat(src, span_notice("Your name is now <b>[new_name]</b>!"))
		name = new_name
