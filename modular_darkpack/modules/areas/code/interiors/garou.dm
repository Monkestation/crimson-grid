/area/vtm/interior/cog

/area/vtm/interior/cog/caern
	name = "Children of Gaia Caern"
	icon_state = "cog_caern"
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
