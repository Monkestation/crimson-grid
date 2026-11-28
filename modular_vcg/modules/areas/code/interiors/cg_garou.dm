/area/vtm/interior/wyld/caern/internal
	name = "Forest Caern Interior"
	icon_state = "cog_caern"
	music_index = MUSIC_CAERN
	zone_type = ZONE_ELYSIUM
	gauntlet_rating = 5
	outdoors = FALSE

/area/vtm/interior/wyrm_corrupted/bawn
	name = "Wyrm Corruption Bawn"

/area/vtm/interior/wyrm_corrupted/bawn/LateInitialize()
	. = ..()
	AddComponent(/datum/component/bawn_area, /obj/structure/werewolf_totem/generic/wyrm)
