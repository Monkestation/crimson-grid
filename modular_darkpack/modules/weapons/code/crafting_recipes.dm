/datum/crafting_recipe/stake
	name = "Stake"
	time = 50
	reqs = list(/obj/item/stack/sheet/mineral/wood = 2)
	result = /obj/item/vampire_stake
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/molotov
	name = "Molotov"
	time = 50
	reqs = list(/obj/item/reagent_containers/cup/glass/bottle/beer/vampire = 1, /obj/item/stack/sheet/cloth = 1, /obj/item/gas_can = 1)
	result = /obj/item/molotov
	category = CAT_WEAPON_RANGED
