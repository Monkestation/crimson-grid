/datum/crafting_recipe/pipebomb
	name = "Pipe Bomb"
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER)
	time = 500
	reqs = list(/obj/item/stack/sheet/iron = 10,
	/obj/item/stack/sheet/cloth = 1,
	/obj/item/gas_can = 1,
	/obj/item/soil_sack/rich = 2,
	/obj/item/stack/cable_coil = 15,
	/obj/item/shard = 2)
	result = /obj/item/grenade/pipebomb
	category = CAT_WEAPON_RANGED
	crafting_flags = CRAFT_SKIP_MATERIALS_PARITY
	skill_dots_minimum = 3



/datum/crafting_recipe/pipebomb_ied
	name = "Improvised Explosive Device"
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER)
	time = 500
	reqs = list(
	/obj/item/soil_sack/rich = 1,
	/obj/item/stack/cable_coil = 15,
	/obj/item/smartphone = 1,
	/obj/item/shard = 2
	,/obj/item/grenade/pipebomb = 1)
	result = /obj/item/grenade/c4/pipebomb_ied
	category = CAT_WEAPON_RANGED
	crafting_flags = CRAFT_SKIP_MATERIALS_PARITY
	skill_dots_minimum = 4
/datum/crafting_recipe/pipe
	name = "a pipe"
	tool_behaviors = list(TOOL_WRENCH)
	result = /obj/item/pipe/quaternary/pipe/crafted
	reqs = list(/obj/item/stack/sheet/iron = 1)
	time = 0.5 SECONDS
	category = CAT_WEAPON_RANGED
	crafting_flags = CRAFT_SKIP_MATERIALS_PARITY

