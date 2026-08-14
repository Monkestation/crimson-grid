
/obj/item/clothing/suit/vampire/jacket/Initialize(mapload)
	. = ..()
	allowed += GLOB.security_vest_allowed
/obj/item/clothing/suit/vampire/trench/Initialize(mapload)
	. = ..()
	allowed += GLOB.security_vest_allowed

/obj/item/clothing/suit/vampire/vest/Initialize(mapload)
	. = ..()
	allowed += GLOB.security_vest_allowed

/obj/item/clothing/suit/vampire/eod/Initialize(mapload)
	. = ..()
	allowed += GLOB.security_vest_allowed

/obj/item/clothing/suit/vampire/bogatyr/Initialize(mapload)
	. = ..()
	allowed += GLOB.security_vest_allowed
	allowed += GLOB.darkpack_melee //Bogatyar armor knows how to hold melee stuff
