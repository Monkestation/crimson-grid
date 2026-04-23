/obj/item/ammo_box/darkpack
	icon = 'modular_darkpack/modules/weapons/icons/ammo.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/ammo_onfloor.dmi')
	w_class = WEIGHT_CLASS_NORMAL
	abstract_type = /obj/item/ammo_box/darkpack

// 9x19mm Parabellum

/obj/item/ammo_box/darkpack/c9mm
	name = "ammo box (9mm)"
	icon_state = "9box"
	ammo_type = /obj/item/ammo_casing/vampire/c9mm
	max_ammo = 100
	custom_price = 300

/obj/item/ammo_box/darkpack/c9mm/plus
	name = "ammo box (9mm, +P)"
	desc = "a box of High Velocity (HV) ammo."
	ammo_type = /obj/item/ammo_casing/vampire/c9mm/plus

/obj/item/ammo_box/darkpack/c9mm/silver
	name = "ammo box (9mm silver)"
	icon_state = "9box-silver"
	ammo_type = /obj/item/ammo_casing/vampire/c9mm/silver
	max_ammo = 100

/obj/item/ammo_box/darkpack/c9mm/moonclip // Speedloader, technically.
	name = "ammo clip (9mm)"
	desc = "a 3 round clip to hold 9mm rounds. For once, calling it a clip is accurate."
	icon_state = "9moonclip"
	max_ammo = 3
	w_class = WEIGHT_CLASS_TINY
	multiple_sprites = AMMO_BOX_PER_BULLET

// .45 ACP
/obj/item/ammo_box/darkpack/c45acp
	name = "ammo box (.45 ACP)"
	icon_state = "45box"
	ammo_type = /obj/item/ammo_casing/vampire/c45acp
	max_ammo = 100

/obj/item/ammo_box/darkpack/c45acp/hp
	name = "ammo box (.45 ACP HP)"
	ammo_type = /obj/item/ammo_casing/vampire/c45acp/HP
	max_ammo = 100

/obj/item/ammo_box/darkpack/c45acp/silver
	name = "ammo box (.45 ACP silver)"
	icon_state = "45box-silver"
	ammo_type = /obj/item/ammo_casing/vampire/c45acp/silver
	max_ammo = 100

// .44 Magnum
/obj/item/ammo_box/darkpack/c44
	name = "ammo box (.44)"
	icon_state = "44box"
	ammo_type = /obj/item/ammo_casing/vampire/c44
	max_ammo = 60

/obj/item/ammo_box/darkpack/c44/silver
	name = "ammo box (.44 silver)"
	icon_state = "44box-silver"
	ammo_type = /obj/item/ammo_casing/vampire/c44/silver
	max_ammo = 60

// .50 BMG/AE
/obj/item/ammo_box/darkpack/c50
	name = "ammo box (.50)"
	icon_state = "50box"
	ammo_type = /obj/item/ammo_casing/vampire/c50
	max_ammo = 20

// 5.56mm NATO
/obj/item/ammo_box/darkpack/c556
	name = "ammo box (5.56)"
	icon_state = "556box"
	ammo_type = /obj/item/ammo_casing/vampire/c556mm
	max_ammo = 60
	custom_price = 2000

/obj/item/ammo_box/darkpack/c556/incendiary
	name = "incendiary ammo box (5.56)"
	icon_state = "incendiary"
	ammo_type = /obj/item/ammo_casing/vampire/c556mm/incendiary

/obj/item/ammo_box/darkpack/c556/silver
	name = "ammo box (5.56 silver)"
	icon_state = "556box-silver"
	ammo_type = /obj/item/ammo_casing/vampire/c556mm/silver
	max_ammo = 60

// 5.45x39mm
/obj/item/ammo_box/darkpack/c545
	name = "ammo box (5.45)"
	icon_state = "545box"
	ammo_type = /obj/item/ammo_casing/vampire/c545mm
	max_ammo = 60

// 4.6mm HK // DARKPACK TODO: Ammo box for 4.6mm NATO
///obj/item/ammo_box/darkpack/c46pdw

// 12 Gauge
/obj/item/ammo_box/darkpack/c12g
	name = "ammo box (12g)"
	icon_state = "12box"
	ammo_type = /obj/item/ammo_casing/vampire/c12g
	max_ammo = 30

/obj/item/ammo_box/darkpack/c12g/buck
	name = "ammo box (12g, 00 buck)"
	icon_state = "12box_buck"
	ammo_type = /obj/item/ammo_casing/vampire/c12g/buck
	custom_price = 400

/obj/item/ammo_box/darkpack/c12g/rubber
	name = "ammo box (12g, rubber shot)"
	icon_state = "12box_rubber"
	ammo_type = /obj/item/ammo_casing/vampire/c12g/rubber

/obj/item/ammo_box/darkpack/c12g/incap
	name = "ammo box (12g, High Impact Incapacitation Round)"
	icon_state = "12box_incap"
	ammo_type = /obj/item/ammo_casing/vampire/c12g/incap

//obj/item/ammo_box/darkpack/c12g/buck/silver
//	name = "ammo box (12g, 00 buck silver)"
//	icon_state = "s12box_buck"
//	ammo_type = /obj/item/ammo_casing/vampire/c12g/buck/silver

// Crossbow Bolt
/obj/item/ammo_box/darkpack/arrows
	name = "ammo box (arrows)"
	icon_state = "arrows"
	ammo_type = /obj/item/ammo_casing/caseless/bolt
	max_ammo = 30

// 7.62x51mm NATO
/obj/item/ammo_box/darkpack/c762x51mm
	name = "ammo box (7.62x51mm)"
	icon_state = "762box"
	ammo_type = /obj/item/ammo_casing/vampire/c762x51mm
	max_ammo = 80

/obj/item/ammo_box/darkpack/c762x51mm/incendiary
	name = "incendiary ammo box (7.62x51)"
	icon_state = "762box-incendiary"
	ammo_type = /obj/item/ammo_casing/vampire/c762x51mm/incendiary
