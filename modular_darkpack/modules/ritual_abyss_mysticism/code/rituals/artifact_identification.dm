/obj/ritual_rune/abyss/identification
	name = "occult items identification"
	desc = "Identifies a single occult item"
	icon_state = "rune4"
	word = "WUS'ZAT"
	cost = 1

/obj/ritual_rune/abyss/identification/complete()
	. = ..()
	for(var/obj/item/vtm_artifact/VA in loc)
		VA.identify()
		qdel(src)
		return
