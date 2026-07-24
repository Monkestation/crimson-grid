/obj/item/ammo_casing/vampire
	icon_state = "9"
	base_icon_state = "9"
	icon = 'modular_darkpack/modules/weapons/icons/ammo.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/ammo_onfloor.dmi')
	abstract_type = /obj/item/ammo_casing/vampire

// 9x19mm Parabellum
/obj/item/ammo_casing/vampire/c9mm
	name = "9mm bullet casing"
	desc = "A 9mm bullet casing."
	caliber = CALIBER_9MMPARA
	projectile_type = /obj/projectile/bullet/darkpack/vamp9mm

/obj/item/ammo_casing/vampire/c9mm/plus
	name = "9mm HV bullet casing"
	projectile_type = /obj/projectile/bullet/darkpack/vamp9mm/plus
	caliber = CALIBER_9MMPARA

/obj/item/ammo_casing/vampire/c9mm/silver
	name = "9mm silver bullet casing"
	desc = "A 9mm silver bullet casing."
	projectile_type = /obj/projectile/bullet/darkpack/vamp9mm/silver
	icon_state = "s9"
	base_icon_state = "s9"

// .45 ACP
/obj/item/ammo_casing/vampire/c45acp
	name = ".45 ACP bullet casing"
	desc = "A .45 ACP bullet casing."
	caliber = CALIBER_45ACP
	projectile_type = /obj/projectile/bullet/darkpack/vamp45acp
	icon_state = "45"
	base_icon_state = "45"

/obj/item/ammo_casing/vampire/c45acp/HP
	projectile_type = /obj/projectile/bullet/darkpack/vamp45acp/HP

/obj/item/ammo_casing/vampire/c45acp/silver
	name = ".45 ACP silver bullet casing"
	desc = "A .45 ACP silver bullet casing."
	projectile_type = /obj/projectile/bullet/darkpack/vamp45acp/silver

// .44 Magnum
/obj/item/ammo_casing/vampire/c44
	name = ".44 bullet casing"
	desc = "A .44 bullet casing."
	caliber = CALIBER_44MAG
	projectile_type = /obj/projectile/bullet/darkpack/vamp44
	icon_state = "44"
	base_icon_state = "44"

/obj/item/ammo_casing/vampire/c44/silver
	name = ".44 silver bullet casing"
	desc = "A .44 silver bullet casing."
	projectile_type = /obj/projectile/bullet/darkpack/vamp44/silver
	icon_state = "s44"
	base_icon_state = "s44"

// .50 BMG/AE
/obj/item/ammo_casing/vampire/c50ae
	name = ".50 AE bullet casing"
	desc = "A .50 AE bullet casing."
	caliber = CALIBER_50CAL_AE
	projectile_type = /obj/projectile/bullet/darkpack/vamp50ae
	icon_state = "44"		//placeholder
	base_icon_state = "44"	//placeholder

/obj/item/ammo_casing/vampire/c50
	name = ".50 BMG bullet casing"
	desc = "A .50 BMG bullet casing."
	caliber = CALIBER_50CAL_BMG
	projectile_type = /obj/projectile/bullet/darkpack/vamp50
	icon_state = "50"
	base_icon_state = "50"

// 5.56mm NATO
/obj/item/ammo_casing/vampire/c556mm
	name = "5.56mm bullet casing"
	desc = "A 5.56mm bullet casing."
	caliber = CALIBER_556NATO
	projectile_type = /obj/projectile/bullet/darkpack/vamp556mm
	icon_state = "556"
	base_icon_state = "556"

/obj/item/ammo_casing/vampire/c556mm/silver
	name = "5.56mm silver bullet casing"
	desc = "A 5.56mm silver bullet casing."
	projectile_type = /obj/projectile/bullet/darkpack/vamp556mm/silver
	icon_state = "s556"
	base_icon_state = "s556"

// 5.45x39mm
/obj/item/ammo_casing/vampire/c545mm
	name = "5.45mm bullet casing"
	desc = "A 5.45mm bullet casing."
	caliber = CALIBER_545SOVIET
	projectile_type = /obj/projectile/bullet/darkpack/vamp545mm
	icon_state = "545"
	base_icon_state = "545"

// 4.6mm HK
/obj/item/ammo_casing/vampire/c46pdw
	name = "4.6mm bullet casing"
	desc = "A 4.6mm bullet casing."
	caliber = CALIBER_46HK
	projectile_type = /obj/projectile/bullet/darkpack/vamp46mm
	icon_state = "46"
	base_icon_state = "46"

/obj/item/ammo_casing/vampire/c556mm/incendiary
	projectile_type = /obj/projectile/bullet/darkpack/vamp556mm/incendiary

// 12 Gauge
/obj/item/ammo_casing/vampire/c12g
	name = "12g shell casing"
	desc = "A 12g shell casing."
	caliber = CALIBER_12G
	projectile_type = /obj/projectile/bullet/shotgun_slug/vamp
	icon_state = "12"
	base_icon_state = "12"

/obj/item/ammo_casing/vampire/c12g/silver
	name = "12g silver shell casing"
	desc = "A 12g silver shell casing."
	icon_state = "s12"
	base_icon_state = "s12"
	projectile_type = /obj/projectile/bullet/shotgun_slug/vamp/silver

/obj/item/ammo_casing/vampire/c12g/buck
	desc = "A 12g shell casing (00 buck)."
	projectile_type = /obj/projectile/bullet/darkpack/shotpellet
	pellets = 8
	variance = 25

/obj/item/ammo_casing/vampire/c12g/rubber
	desc = "A 12g shell casing."
	projectile_type = /obj/projectile/bullet/darkpack/rubber
	icon_state = "12r"
	base_icon_state = "12r"

/obj/item/ammo_casing/vampire/c12g/incap
	desc = "A 12g shell casing."
	projectile_type = /obj/projectile/bullet/darkpack/incap
	icon_state = "12i"
	base_icon_state = "12i"

/obj/item/ammo_casing/vampire/c12g/buck/incendiary
	name = "12g dragon's breath shell casing"
	desc = "An incendiary 12g shell casing."
	projectile_type = /obj/projectile/bullet/darkpack/dragonsbreath
	pellets = 8
	variance = 25
	icon_state = "12d"
	base_icon_state = "12d"

// Crossbow Bolt
/obj/item/ammo_casing/caseless/bolt
	name = "bolt"
	desc = "Welcome to the Middle Ages!"
	projectile_type = /obj/projectile/bullet/crossbow_bolt
	caliber = CALIBER_CROSSBOWBOLT
	icon_state = "arrow"
	icon = 'modular_darkpack/modules/weapons/icons/ammo.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/ammo_onfloor.dmi')
	harmful = TRUE

// 7.62x51mm NATO
/obj/item/ammo_casing/vampire/c762x51mm // DARKPACK TODO: can you believe these never had a sprite? tfn...
	name = "7.62x51mm bullet casing"
	desc = "A 7.62x51mm bullet casing."
	caliber = CALIBER_762NATO
	projectile_type = /obj/projectile/bullet/darkpack/vamp762x51mm
	icon_state = "762"
	base_icon_state = "762"

/obj/item/ammo_casing/vampire/c762x51mm/incendiary
	name = "7.62x51mm tracer bullet casing"
	projectile_type = /obj/projectile/bullet/darkpack/vamp762x51mm/incendiary

/obj/item/ammo_casing/vampire/c762x51mm/silver
	name = "7.62x51mm silver bullet casing"
	desc = "A 762x51mm silver bullet casing."
	projectile_type = /obj/projectile/bullet/darkpack/vamp762x51mm/silver
	icon_state = "s762"
	base_icon_state = "s762"

/obj/item/ammo_casing/vampire/c75
	name = ".75 cartrige"
	desc = "A .75 musket cartridge containing a musket ball and gunpowder."
	caliber = CALIBER_75BALL
	projectile_type = /obj/projectile/bullet/darkpack/vamp75
	icon_state = "cartridge"
	base_icon_state = "cartridge"

/obj/item/ammo_casing/vampire/c75/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/caseless)

/obj/item/ammo_casing/vampire/c75/silver
	name = ".75 silver cartrige"
	desc = "A .75 musket cartridge containing a musket ball, made in pure silver, and gunpowder."
	projectile_type = /obj/projectile/bullet/darkpack/vamp75/silver
	icon_state = "scartridge"
	base_icon_state = "scartridge"
