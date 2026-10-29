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
	name = "\improper Braddock 9mm"
	recoil = 4

/obj/item/gun/ballistic/automatic/darkpack/mac10/super
	recoil = 3

/obj/item/gun/ballistic/automatic/darkpack/mp7
	recoil = 1

// Rifles
/obj/item/gun/ballistic/automatic/darkpack/ar15
	recoil = 3

/obj/item/gun/ballistic/automatic/darkpack/fal
	recoil = 3

/obj/item/gun/ballistic/automatic/darkpack/huntrifle
	recoil = 1

/obj/item/gun/ballistic/automatic/darkpack/huntrifle/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = 1.5)

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

/obj/item/gun/ballistic/automatic/darkpack/musket
	projectile_damage_multiplier = 1

/obj/item/gun/ballistic/automatic/darkpack/musket/sawn
	projectile_damage_multiplier = 0.75

// Sniper
/obj/item/gun/ballistic/automatic/darkpack/sniper
	recoil = 6
	item_flags = SLOWS_WHILE_IN_HAND
	slowdown = 3

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

/obj/item/gun/ballistic/shotgun/vamp_remington
	recoil = 4

/obj/item/gun/ballistic/shotgun/vamp_remington/sawnoff
	recoil = 6

// Magazine Modifications

/obj/item/ammo_box/magazine/darkpack556/hunt
	name = "rifle magazine (7.62x51mm)"
	caliber = CALIBER_762NATO
	ammo_type = /obj/item/ammo_casing/vampire/c762x51mm
	max_ammo = 8

/obj/item/ammo_box/magazine/darkpack45smg
	name = "9mm SMG magazine"
	ammo_type = /obj/item/ammo_casing/vampire/c9mm
	caliber = CALIBER_9MMPARA

// Pulemet "Kulak"

/obj/item/ammo_box/magazine/machinegun/kulak
	name = "machinegun's box (7.62x54mm)"
	icon = 'modular_vcg/modules/weapons/icons/ammo.dmi'
	ONFLOOR_ICON_HELPER('modular_vcg/modules/weapons/icons/ammo_onfloor.dmi')
	icon_state = "pecheneg"

	ammo_type = /obj/item/ammo_casing/vampire/c762x54mm

	caliber = CALIBER_762SOVIET
	max_ammo = 100
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/gun/ballistic/automatic/machinegun/kulak
	name = "\improper Kulak .54"
	desc = "many bullets"
	icon = 'modular_vcg/modules/weapons/icons/weapons48x32.dmi'
	lefthand_file = 'modular_vcg/modules/weapons/icons/lefthand.dmi'
	righthand_file = 'modular_vcg/modules/weapons/icons/righthand.dmi'
	worn_icon = 'modular_vcg/modules/weapons/icons/worn_guns.dmi'
	ONFLOOR_ICON_HELPER('modular_vcg/modules/weapons/icons/weapons_onfloor.dmi')
	icon_state = "pecheneg"
	inhand_icon_state = "pecheneg"
	worn_icon_state = "pecheneg"

	recoil = 6
	fire_delay = 6

	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY

	accepted_magazine_type = /obj/item/ammo_box/magazine/machinegun/kulak

	spread = 100 // on the 100 m ->
	can_suppress = TRUE

	mag_display = TRUE

	serial_type = ""

	var/rof = 0.09 SECONDS // 650 RPM

/obj/item/gun/ballistic/automatic/machinegun/kulak/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, rof)

