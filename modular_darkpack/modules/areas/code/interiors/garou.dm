/area/vtm/interior/cog

/area/vtm/interior/cog/caern
	name = "Children of Gaia Caern"
	icon_state = "cog_caern"
	music_index = MUSIC_CAERN
	zone_type = ZONE_ELYSIUM
	gauntlet_rating = 5

/area/vtm/interior/cog/caern/bawn
	name = "Children of Gaia Bawn"

/area/vtm/interior/cog/caern/bawn/LateInitialize()
	. = ..()
	AddComponent(/datum/component/bawn_area, /obj/structure/werewolf_totem/children_of_gaia)

/area/vtm/interior/cog/pantry
	name = "Earth's Bounty Food Pantry"
	icon_state = "cog_pantry"
	fire_controled = TRUE

// CRIMSON EDIT ADD START - Oakland Forest
/area/vtm/interior/wyld

/area/vtm/interior/wyld/caern
	name = "Forest Caern"
	icon_state = "cog_caern"
	music_index = MUSIC_CAERN
	zone_type = ZONE_ELYSIUM
	gauntlet_rating = 5

/area/vtm/interior/wyld/caern/bawn
	name = "Forest Bawn"

/area/vtm/interior/wyld/caern/bawn/LateInitialize()
	. = ..()
	AddComponent(/datum/component/bawn_area, /obj/structure/werewolf_totem/generic/gaia)

// CRIMSON EDITT ADD END - Oakland Forest

// CRIMSON EDIT START - Move Wyrm Taint

/area/vtm/interior/wyrm_corrupted
	name = "Wyrm Corruption"
	icon_state = "graveyard"
	zone_type = ZONE_NO_MASQUERADE
	music_index = MUSIC_FOREST
	fire_controled = FALSE
	gauntlet_rating = 5

/area/vtm/interior/wyrm_corrupted/bawn
	name = "Wyrm Corruption Bawn"

/area/vtm/interior/wyrm_corrupted/bawn/LateInitialize()
	. = ..()
	AddComponent(/datum/component/bawn_area, /obj/structure/werewolf_totem/generic/wyrm)
// CRIMSON EDIT END - Move Wyrm Taint
