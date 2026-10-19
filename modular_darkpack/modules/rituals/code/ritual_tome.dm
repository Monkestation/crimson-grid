//the parent type of necromancy, arcane, abyss mysticism tomes
/obj/item/ritual_tome
	abstract_type = /obj/item/ritual_tome
	name = "ritual tome"
	desc = "A mysterious tome. This shouldnt be spawning ingame, if it is, something's wrong."
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/paper = SHEET_MATERIAL_AMOUNT * 0.75)
	var/list/rituals = list()
	var/rune_type //ritual_rune/abyss, ritual_rune/thaumaturgy, etc
	var/static/list/ritual_cache = list()
	var/discipline_type // set in subtypes, such as arcane tome having discipline_type = /datum/discipline/thaumaturgy

/obj/item/ritual_tome/Initialize(mapload)
	. = ..()
	if(!rune_type)
		return

	if(!ritual_cache[rune_type])
		ritual_cache[rune_type] = list()
		for(var/rune_path in subtypesof(rune_type))
			var/obj/R = new rune_path()
			ritual_cache[rune_type] += R

	rituals = ritual_cache[rune_type]

/obj/item/ritual_tome/attack_self(mob/user)
	. = ..()
	var/mob/living/reader = astype(user)
	if(!reader)
		return

	if(!get_splat_with_discipline(user))
		if(reader.st_get_stat(STAT_OCCULT) < 3)
			to_chat(reader, span_cult("A strange book that looks like it belongs in a dusty Library or a garage sale. You find yourself not caring, or understanding, too much about it."))
			return
	display_rituals(reader)

// code/_HELPERS/_lists.dm. used in sort_list to sort a list by ritual level
/proc/compare_ritual_levels_ascend(obj/ritual_rune/A, obj/ritual_rune/B)
	return A.level - B.level

/obj/item/ritual_tome/proc/display_rituals(mob/living/user)
	var/list/sorted_rituals = sort_list(rituals, GLOBAL_PROC_REF(compare_ritual_levels_ascend))
	var/user_level = discipline_type ? (user.get_discipline_dots(discipline_type) || user.st_get_stat(STAT_OCCULT)) : user.st_get_stat(STAT_OCCULT)
	for(var/obj/ritual_rune/R in sorted_rituals)
		if(R.level > user_level)
			continue
		var/requirements = get_ritual_requirements(R)
		to_chat(user, span_cult("[get_ritual_level(R)] <b>[R.ritual_name]</b> - [R.desc][requirements ? " Requirements: [requirements]." : ""]"))

/obj/item/ritual_tome/proc/get_ritual_requirements(obj/ritual_rune/rune)
	if(!islist(rune.sacrifices) || !length(rune.sacrifices))
		return ""

	var/list/required_items = list()
	for(var/obj/item/item_type as anything in rune.sacrifices)
		required_items += item_type::name

	return required_items.Join("\n")

/obj/item/ritual_tome/proc/get_ritual_level(obj/ritual_rune/rune)
	if(rune.level)
		return rune.level
	return ""
