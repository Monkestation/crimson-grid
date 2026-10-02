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

/obj/item/ammo_box/magazine/darkpack762x51fal/hk51
	name = "hk51 magazine (7.62x51mm)"
	icon = 'modular_vcg/modules/custom_weapon/icons/ammo.dmi'
	ONFLOOR_ICON_HELPER('modular_vcg/modules/custom_weapon/icons/ammo_onfloor.dmi')
	icon_state = "hk51mag"
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/gun/ballistic/automatic/darkpack/hk51
	name = "\improper HK51"
	desc = "A highly compact battle rifle small enough to fit in a bag to avoid drawing the ire of secular authorities while still packing enough punch to put down those who threaten God's kingdom"
	icon_state = "hk51"
	icon = 'modular_vcg/modules/custom_weapon/icons/48x32.dmi'
	lefthand_file = 'modular_vcg/modules/custom_weapon/icons/lefthand.dmi'
	righthand_file = 'modular_vcg/modules/custom_weapon/icons/righthand.dmi'
	ONFLOOR_ICON_HELPER('modular_vcg/modules/custom_weapon/icons/weapon_onfloor.dmi')
	inhand_icon_state = "hk51"
	accepted_magazine_type = /obj/item/ammo_box/magazine/darkpack762x51fal
	spawn_magazine_type = /obj/item/ammo_box/magazine/darkpack762x51fal/hk51
	burst_size = 1
	spread = 3
	recoil = 3
	weapon_weight = WEAPON_MEDIUM
	bolt_type = BOLT_TYPE_LOCKING
	show_bolt_icon = FALSE
	mag_display = TRUE
	rack_sound = 'sound/items/weapons/gun/pistol/slide_lock.ogg'
	fire_sound = 'modular_darkpack/modules/deprecated/sounds/rifle.ogg'
	serial_type = "H&K"
	var/rof = 0.15 SECONDS

/obj/item/gun/ballistic/automatic/darkpack/hk51/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, rof)
