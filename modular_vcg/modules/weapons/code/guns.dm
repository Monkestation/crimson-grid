/obj/item/gun/ballistic/automatic/darkpack
	recoil = 3

/obj/item/gun/ballistic/automatic/pistol/darkpack
	recoil = 2

/obj/item/gun/ballistic/revolver/darkpack
	recoil = 2

// Revolvers
/obj/item/gun/ballistic/revolver/darkpack/snub
	recoil = 1

// Pistols
/obj/item/gun/ballistic/automatic/pistol/darkpack/deagle
	recoil = 2

/obj/item/gun/ballistic/automatic/pistol/darkpack/deagle/c50
	recoil = 3

/obj/item/gun/ballistic/automatic/pistol/darkpack/glock21
	recoil = 2

// SMGs
/obj/item/gun/ballistic/automatic/darkpack/uzi
	recoil = 3

/obj/item/gun/ballistic/automatic/darkpack/mp5
	recoil = 2

/obj/item/gun/ballistic/automatic/darkpack/mac10
	recoil = 4

/obj/item/gun/ballistic/automatic/darkpack/mac10/super
	recoil = 3

/obj/item/gun/ballistic/automatic/darkpack/mp7
	recoil = 1

// Rifles
/obj/item/gun/ballistic/automatic/darkpack/ar15
	recoil = 3

/obj/item/gun/ballistic/automatic/darkpack/huntrifle
	recoil = 1

/obj/item/gun/ballistic/automatic/darkpack/ak74
	recoil = 3

/obj/item/gun/ballistic/automatic/darkpack/ak74/sawn
	recoil = 4

/obj/item/gun/ballistic/automatic/darkpack/aug
	recoil = 3

/obj/item/gun/ballistic/automatic/darkpack/aug/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = 1.2)

/obj/item/gun/ballistic/automatic/darkpack/thompson
	recoil = 3

/obj/item/gun/ballistic/rifle/darkpack/lever
	recoil = 1

// Sniper
/obj/item/gun/ballistic/automatic/darkpack/sniper
	recoil = 6

/obj/item/gun/ballistic/automatic/darkpack/sniper/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = 4)

/obj/item/gun/ballistic/automatic/darkpack/autosniper
	recoil = 4

/obj/item/gun/ballistic/automatic/darkpack/autosniper/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = 4)

// Shotguns
/obj/item/gun/ballistic/shotgun/vampire
	recoil = 4

/obj/item/gun/ballistic/shotgun/vampire/sawnoff
	recoil = 6

/obj/item/gun/ballistic/shotgun/vampire/doublebarrel
	recoil = 3

/obj/item/gun/ballistic/automatic/darkpack/autoshotgun
	recoil = 4

/obj/item/ammo_box/magazine/darkpack556/hunt
	name = "rifle magazine (7.62x51mm)"
	caliber = CALIBER_762NATO
	ammo_type = /obj/item/ammo_casing/vampire/c762x51mm
	max_ammo = 8
