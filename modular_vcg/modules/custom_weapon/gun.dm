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
	worn_icon_state = "mp5"
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
	var/rof = 0.2 SECONDS

/obj/item/gun/ballistic/automatic/darkpack/hk51/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, rof)
