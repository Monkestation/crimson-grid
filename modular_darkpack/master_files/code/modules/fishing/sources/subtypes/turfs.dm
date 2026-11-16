/datum/fish_source/ocean
	fish_table = list(
		FISHING_DUD = 10,
		/obj/item/fish/darkpack/stickleback = 20,
		/obj/item/fish/darkpack/anchovy = 15,
		/obj/item/fish/darkpack/crab = 10,
		/obj/item/food/darkpack/horn_snail = 10,
		/obj/item/fish/darkpack/trout = 10,
		/obj/item/fish/darkpack/tuna = 5,
		/obj/item/fish/darkpack/shark = 5,
		/obj/item/fish/darkpack/salmon = 4,
		/obj/item/fish/darkpack/eagle_ray = 3,
		/obj/item/coin/gold = 3,
		/obj/effect/spawner/random/trash/garbage = 2,
		/obj/effect/spawner/message_in_a_bottle = 1,
		/obj/effect/spawner/random/occult/artifact = 1,
	)
	fish_counts = list(
		///obj/structure/mystery_box/fishing = 1,
	)
	fish_count_regen = list(
		///obj/structure/mystery_box/fishing = 32 MINUTES,
	)

/datum/fish_source/river
	fish_table = list(
		FISHING_DUD = 4,
		/obj/item/fish/darkpack/stickleback = 20,
		/obj/item/fish/darkpack/crappie = 15,
		/obj/item/fish/darkpack/trout = 10,
		/obj/item/fish/darkpack/salmon = 5,
		/obj/item/fish/darkpack/catfish = 5,
		/obj/item/food/darkpack/leech = 1,
		/obj/effect/spawner/random/trash/garbage = 1,
		/obj/effect/spawner/random/occult/artifact = 1,
	)
	fish_counts = list()
	fish_count_regen = list()
	safe_turfs_blacklist = list(/turf/open/water/hot_spring, /turf/open/water/beach)

/datum/fish_source/sand
	fish_table = list(
		FISHING_DUD = 15,
		/obj/item/food/darkpack/horn_snail = 15,
		/obj/item/fish/darkpack/crab = 10,
		/obj/effect/spawner/random/trash/garbage = 5,
		/obj/effect/spawner/random/occult/artifact = 1,
	)

/datum/fish_source/sewer
	catalog_description = "Sewage"
	fish_table = list(
		FISHING_DUD = 20,
		/obj/effect/spawner/random/trash/garbage = 35,
		/obj/item/food/darkpack/leech = 10,
		/mob/living/basic/mouse/vampire = 5,
		/obj/item/coin/iron = 5,
		/obj/item/fish/darkpack/stickleback = 5,
		/obj/item/fish/darkpack/crappie = 4,
		/obj/item/fish/darkpack/trout = 3,
		/obj/item/coin/silver = 2,
		/obj/item/fish/darkpack/catfish = 2,
		/obj/effect/spawner/random/weapon/small_melee = 2,
		/obj/effect/spawner/random/weapon/weak_large_melee = 2,
		/obj/item/coin/gold = 1,
		/obj/effect/spawner/random/weapon/good_large_melee = 1,
		/obj/effect/spawner/random/occult/artifact = 1,
	)
	fishing_difficulty = FISHING_DEFAULT_DIFFICULTY + 15

/datum/fish_source/blood
	catalog_description = "Blood Pool"
	fish_table = list(
		FISHING_DUD = 10,
		/obj/item/food/darkpack/leech = 20,
		/obj/item/stack/sheet/bone = 10,
		/obj/item/clothing/head/vampire/skull = 5,
		/obj/item/storage/wallet/darkpack = 2,
		/mob/living/basic/szlachta = 1,
		/obj/effect/spawner/random/occult/artifact = 1,
	)
	fishing_difficulty = FISHING_DEFAULT_DIFFICULTY + 30

/datum/fish_source/acid
	catalog_description = "Acid"
	fish_table = list(
		FISHING_DUD = 30,
		/obj/item/stack/sheet/bone = 10,
		/obj/item/clothing/head/vampire/skull = 5,
		/obj/effect/mob_spawn/corpse/human/charredskeleton = 4,
		/obj/effect/decal/remains/human = 3,
		/obj/effect/spawner/random/occult/artifact = 1,
	)
	fishing_difficulty = FISHING_DEFAULT_DIFFICULTY + 30
