/obj/item/gun/ballistic/automatic/darkpack
	icon_state = "revolver"
	inhand_icon_state = "revolver"
	worn_icon_state = null
	icon = 'modular_darkpack/modules/weapons/icons/weapons.dmi'
	lefthand_file = 'modular_darkpack/modules/deprecated/icons/lefthand.dmi'
	righthand_file = 'modular_darkpack/modules/deprecated/icons/righthand.dmi'
	worn_icon = 'modular_darkpack/modules/weapons/icons/worn_guns.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	recoil = 5

	//Leave serial_type blank for no serial number/obliterated serial number.
	serial_type = "SF"

/*
/obj/item/ammo_box/magazine/darkpack
	icon = 'modular_darkpack/modules/weapons/icons/ammo.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/ammo_onfloor.dmi')
*/

//REVOLVERS
/obj/item/ammo_box/magazine/internal/cylinder/rev44
	name = "revolver cylinder"
	ammo_type = /obj/item/ammo_casing/vampire/c44
	caliber = CALIBER_44MAG
	max_ammo = 6

/obj/item/gun/ballistic/revolver/darkpack
	name = "evil coder revolver"
	icon_state = "revolver"
	inhand_icon_state = "revolver"
	worn_icon_state = "gun"
	icon = 'modular_darkpack/modules/weapons/icons/weapons.dmi'
	lefthand_file = 'modular_darkpack/modules/deprecated/icons/lefthand.dmi'
	righthand_file = 'modular_darkpack/modules/deprecated/icons/righthand.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/cylinder/rev44
	initial_caliber = CALIBER_44MAG
	fire_sound = 'modular_darkpack/modules/weapons/sounds/revolver.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 85
	recoil = 4

/obj/item/gun/ballistic/revolver/darkpack/magnum
	name = "magnum revolver"
	desc = "Feelin' lucky, punk?"

/obj/item/gun/ballistic/revolver/darkpack/snub
	name = "snub-nosed revolver"
	desc = "a cheap Saturday night special revolver. Sometimes called a 'purse gun'. It takes 9mm rounds."
	icon_state = "revolver_snub"
	inhand_icon_state = "revolver_snub"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/cylinder/rev9mm
	w_class = WEIGHT_CLASS_SMALL
	initial_caliber = CALIBER_9MM
	fire_sound_volume = 65
	projectile_damage_multiplier = 1.2 //21.6 damage, slightly higher than the m1911, just so it is possible to kill NPCs within 6 bullets
	serial_type = "SN"

/obj/item/ammo_box/magazine/internal/cylinder/rev9mm
	name = "revolver cylinder"
	ammo_type = /obj/item/ammo_casing/vampire/c9mm
	caliber = CALIBER_9MMPARA
	max_ammo = 6

//PISTOLS
/obj/item/gun/ballistic/automatic/pistol/darkpack
	icon_state = "revolver"
	inhand_icon_state = "revolver"
	worn_icon_state = "gun"
	icon = 'modular_darkpack/modules/weapons/icons/weapons.dmi'
	lefthand_file = 'modular_darkpack/modules/deprecated/icons/lefthand.dmi'
	righthand_file = 'modular_darkpack/modules/deprecated/icons/righthand.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	recoil = 3

/obj/item/ammo_box/magazine/m44
	name = "handgun magazine (.44)"
	icon = 'modular_darkpack/modules/weapons/icons/ammo.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/ammo_onfloor.dmi')
	icon_state = "deagle"
	ammo_type = /obj/item/ammo_casing/vampire/c44
	caliber = CALIBER_44MAG
	max_ammo = 7
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/gun/ballistic/automatic/pistol/darkpack/deagle
	name = "\improper Desert Eagle"
	desc = "A powerful .44 handgun."
	icon_state = "deagle"
	inhand_icon_state = "deagle"
	w_class = WEIGHT_CLASS_NORMAL
	accepted_magazine_type = /obj/item/ammo_box/magazine/m44
	recoil = 3
	fire_sound = 'modular_darkpack/modules/weapons/sounds/deagle.ogg'
	serial_type = "MR"

/obj/item/ammo_box/magazine/m50
	name = "handgun magazine (.50)"
	icon = 'modular_darkpack/modules/weapons/icons/ammo.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/ammo_onfloor.dmi')
	icon_state = "deagle"
	ammo_type = /obj/item/ammo_casing/vampire/c50
	caliber = CALIBER_50CAL
	max_ammo = 7
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/gun/ballistic/automatic/pistol/darkpack/deagle/c50
	name = "\improper McLusky .50 caliber "
	desc = "An extremely powerful, and rare, handcannon."
	icon_state = "deagle50"
	inhand_icon_state = "deagle"
	accepted_magazine_type = /obj/item/ammo_box/magazine/m50
	fire_sound_volume = 125 //MY EARS
	weapon_weight = WEAPON_MEDIUM	//Firing .50 at 70 dam, think this is fair.

/obj/item/ammo_box/magazine/darkpack45acp
	name = "pistol magazine (.45 ACP)"
	icon = 'modular_darkpack/modules/weapons/icons/ammo.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/ammo_onfloor.dmi')
	icon_state = "m1911"
	ammo_type = /obj/item/ammo_casing/vampire/c45acp
	caliber = CALIBER_45ACP
	max_ammo = 8
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/gun/ballistic/automatic/pistol/darkpack/m1911
	name = "\improper Colt 1911"
	desc = "A reliable .45 ACP handgun."
	icon_state = "m1911"
	inhand_icon_state = "m1911"
	accepted_magazine_type = /obj/item/ammo_box/magazine/darkpack45acp
	fire_sound = 'modular_darkpack/modules/weapons/sounds/m1911.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 100
	serial_type = "CM"

/obj/item/ammo_box/magazine/glock9mm
	name = "automatic pistol magazine (9mm)"
	icon = 'modular_darkpack/modules/weapons/icons/ammo.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/ammo_onfloor.dmi')
	icon_state = "glock19"
	ammo_type = /obj/item/ammo_casing/vampire/c9mm
	caliber = CALIBER_9MMPARA
	max_ammo = 15
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/gun/ballistic/automatic/pistol/darkpack/glock19
	name = "\improper Brokk 19"
	desc = "Very fast 9mm handgun."
	icon_state = "glock19"
	inhand_icon_state = "glock19"
	w_class = WEIGHT_CLASS_SMALL
	accepted_magazine_type = /obj/item/ammo_box/magazine/glock9mm
	burst_size = 3
	fire_delay = 1
	actions_types = list()
	bolt_type = BOLT_TYPE_LOCKING
	fire_sound = 'modular_darkpack/modules/weapons/sounds/glock.ogg'
	fire_sound_volume = 100
	serial_type = "GG"

/obj/item/ammo_box/magazine/glock45acp
	name = "automatic pistol magazine (.45 ACP)"
	icon = 'modular_darkpack/modules/weapons/icons/ammo.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/ammo_onfloor.dmi')
	icon_state = "glock21"
	ammo_type = /obj/item/ammo_casing/vampire/c45acp
	caliber = CALIBER_45ACP
	max_ammo = 12
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/ammo_box/magazine/glock45acp/hp
	ammo_type = /obj/item/ammo_casing/vampire/c45acp/HP

/obj/item/gun/ballistic/automatic/pistol/darkpack/glock21
	name = "\improper Brokk 21"
	desc = "Very fast 45 ACP handgun."
	icon_state = "glock19"
	inhand_icon_state = "glock19"
	w_class = WEIGHT_CLASS_SMALL
	accepted_magazine_type = /obj/item/ammo_box/magazine/glock45acp
	burst_size = 3
	fire_delay = 1
	actions_types = list()
	bolt_type = BOLT_TYPE_LOCKING
	fire_sound = 'modular_darkpack/modules/weapons/sounds/glock.ogg'
	fire_sound_volume = 100
	serial_type = "GG"

/obj/item/gun/ballistic/automatic/pistol/darkpack/beretta
	name = "\improper Elite 92G"
	desc = "A 9mm pistol favored among law enforcement and criminal alike due to it's use in action movies. Often, it is wielded in pairs."
	icon_state = "beretta"
	inhand_icon_state = "beretta"
	w_class = WEIGHT_CLASS_SMALL
	accepted_magazine_type = /obj/item/ammo_box/magazine/semi9mm
	burst_size = 1
	fire_delay = 0 //spam it
	dual_wield_spread = 10 //DUAL ELITES!
	actions_types = list()
	bolt_type = BOLT_TYPE_LOCKING
	fire_sound = 'modular_darkpack/modules/weapons/sounds/glock.ogg'
	fire_sound_volume = 75
	custom_price = 1200
	serial_type = "BH"

/obj/item/gun/ballistic/automatic/pistol/darkpack/beretta/toreador
	name = "\improper Sword Series S 9mm"
	desc = "A handgun that has been heavily decorated and customized. The improvements seem almost supernaturally good, you feel like the engravings have given you a tactical advantage."
	icon_state = "beretta_toreador"
	projectile_damage_multiplier = 2.5
	fire_sound_volume = 110

/obj/item/ammo_box/magazine/semi9mm
	name = "pistol magazine (9mm)"
	icon = 'modular_darkpack/modules/weapons/icons/ammo.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/ammo_onfloor.dmi')
	icon_state = "semi9mm"
	ammo_type = /obj/item/ammo_casing/vampire/c9mm
	caliber = CALIBER_9MMPARA
	max_ammo = 18
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	custom_price = 200

/obj/item/ammo_box/magazine/semi9mm/toreador
	name = "custom pistol magazine (9mm)"
	ammo_type = /obj/item/ammo_casing/vampire/c9mm/silver

//AUTOMATICS
/obj/item/ammo_box/magazine/darkpack9mm
	name = "uzi magazine (9mm)"
	icon = 'modular_darkpack/modules/weapons/icons/ammo.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/ammo_onfloor.dmi')
	icon_state = "uzi"
	ammo_type = /obj/item/ammo_casing/vampire/c9mm
	caliber = CALIBER_9MMPARA
	max_ammo = 32
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/gun/ballistic/automatic/darkpack/uzi
	name = "\improper Killamatic Uzi"
	desc = "A lightweight, burst-fire submachine gun, for when you really want someone dead. Uses 9mm rounds."
	icon_state = "uzi"
	inhand_icon_state = "uzi"
	accepted_magazine_type = /obj/item/ammo_box/magazine/darkpack9mm
	burst_size = 5
	spread = 11
	recoil = 5
	weapon_weight = WEAPON_MEDIUM
	bolt_type = BOLT_TYPE_OPEN
	show_bolt_icon = FALSE
	mag_display = TRUE
	rack_sound = 'sound/items/weapons/gun/pistol/slide_lock.ogg'
	fire_sound = 'modular_darkpack/modules/deprecated/sounds/uzi.ogg'
	serial_type = "IWI"

/obj/item/ammo_box/magazine/darkpack9mp5
	name = "mp5 magazine (9mm)"
	icon = 'modular_darkpack/modules/weapons/icons/ammo.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/ammo_onfloor.dmi')
	icon_state = "mp5"
	ammo_type = /obj/item/ammo_casing/vampire/c9mm
	caliber = CALIBER_9MMPARA
	max_ammo = 30
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/gun/ballistic/automatic/darkpack/mp5
	name = "\improper HK MP5"
	desc = "A lightweight submachine gun, for when you really want to do some dirty cool job. Uses 9mm rounds."
	icon_state = "mp5"
	icon = 'modular_darkpack/modules/deprecated/icons/48x32.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	inhand_icon_state = "mp5"
	accepted_magazine_type = /obj/item/ammo_box/magazine/darkpack9mp5
	burst_size = 1
	spread = 4
	recoil = 3
	weapon_weight = WEAPON_MEDIUM
	bolt_type = BOLT_TYPE_LOCKING
	show_bolt_icon = FALSE
	mag_display = TRUE
	rack_sound = 'sound/items/weapons/gun/pistol/slide_lock.ogg'
	fire_sound = 'modular_darkpack/modules/deprecated/sounds/mp5.ogg'
	serial_type = "H&K"
	var/rof = 0.15 SECONDS

/obj/item/gun/ballistic/automatic/darkpack/mp5/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, rof)


/obj/item/ammo_box/magazine/darkpack45smg
	name = ".45 SMG magazine"
	icon = 'modular_darkpack/modules/weapons/icons/ammo.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/ammo_onfloor.dmi')
	icon_state = "mac10" //uzi sprite placeholder
	ammo_type = /obj/item/ammo_casing/vampire/c45acp
	caliber = CALIBER_45ACP
	max_ammo = 30
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/gun/ballistic/automatic/darkpack/mac10
	name = "\improper Braddock .45"
	desc = "A box filled with bullets. The high cyclic rate and low weight means it's only good for spraying and then praying. Uses .45 caliber rounds."
	icon = 'modular_darkpack/modules/deprecated/icons/48x32.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	icon_state = "mac10"
	inhand_icon_state = "mac10"
	accepted_magazine_type = /obj/item/ammo_box/magazine/darkpack45smg
	burst_size = 1
	spread = 16 //spray and pray
	burst_delay = 1
	recoil = 6
	weapon_weight = WEAPON_MEDIUM
	bolt_type = BOLT_TYPE_OPEN
	show_bolt_icon = FALSE
	can_suppress = TRUE
	mag_display = TRUE
	rack_sound = 'sound/items/weapons/gun/pistol/slide_lock.ogg'
	fire_sound = 'modular_darkpack/modules/weapons/sounds/mac10.ogg' // DARKPACK sound effect
	serial_type = "GBI"
	var/rof = 0.055 SECONDS //1090 RPM, if any other gun has the same fire rate as this gun, increase this gun so its the new fastest

/obj/item/gun/ballistic/automatic/darkpack/mac10/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, rof)

/obj/item/ammo_box/magazine/darkpack45custom
	name = ".45 custom magazine"
	icon = 'modular_darkpack/modules/weapons/icons/ammo.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/ammo_onfloor.dmi')
	icon_state = "mac10" //uzi sprite placeholder
	ammo_type = /obj/item/ammo_casing/vampire/c45acp
	caliber = CALIBER_45ACP
	max_ammo = 50
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/gun/ballistic/automatic/darkpack/mac10/super
	name = "\improper Cleaner Custom"
	desc = "A .45 submachine gun with a suppressor installed on the tip, which helps balance it out when firing. Dark Blood magic has enabled the wire stock to be used"
	icon = 'modular_darkpack/modules/deprecated/icons/64x32.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	icon_state = "mac10_super"
	recoil = 4
	spread = 8 //magic stock
	suppressed = SUPPRESSED_QUIET
	fire_sound = 'modular_darkpack/modules/weapons/sounds/mac10suppress.ogg'  //mac-10 recording
	suppressed_sound = 'modular_darkpack/modules/weapons/sounds/mac10suppress.ogg'
	suppressed_volume = 70
	accepted_magazine_type = /obj/item/ammo_box/magazine/darkpack45custom
	can_unsuppress = FALSE

/obj/item/ammo_box/magazine/darkpack/c46pdw
	name = "4.6mm MP7 magazine"
	icon = 'modular_darkpack/modules/weapons/icons/ammo.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/ammo_onfloor.dmi')
	icon_state = "mp7"
	ammo_type = /obj/item/ammo_casing/vampire/c46pdw
	caliber = CALIBER_46HK
	max_ammo = 20
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/ammo_box/magazine/darkpack/c46pdw/ext
	name = "4.6mm MP7 extended magazine"
	icon = 'modular_darkpack/modules/weapons/icons/ammo.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/ammo_onfloor.dmi')
	icon_state = "mp7"
	ammo_type = /obj/item/ammo_casing/vampire/c46pdw
	caliber = CALIBER_46HK
	max_ammo = 40
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/gun/ballistic/automatic/darkpack/mp7
	name = "\improper HK MP7"
	desc = "A Machine Pistol recently adopted by the German Military. Comes loaded with armor-piercing rounds, use responsibly."
	icon = 'modular_darkpack/modules/deprecated/icons/48x32.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	icon_state = "mp7"
	inhand_icon_state = "mp7"
	accepted_magazine_type = /obj/item/ammo_box/magazine/darkpack/c46pdw
	burst_size = 1
	spread = 3
	recoil = 2
	weapon_weight = WEAPON_MEDIUM
	bolt_type = BOLT_TYPE_LOCKING
	show_bolt_icon = FALSE
	mag_display = TRUE
	rack_sound = 'sound/items/weapons/gun/pistol/slide_lock.ogg'
	fire_sound = 'modular_darkpack/modules/deprecated/sounds/mp5.ogg'
	serial_type = "H&K"
	var/rof = 0.1 SECONDS //600 RPM,

/obj/item/gun/ballistic/automatic/darkpack/mp7/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, rof)

/obj/item/ammo_box/magazine/darkpack556
	name = "carbine magazine (5.56mm)"
	icon = 'modular_darkpack/modules/weapons/icons/ammo.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/ammo_onfloor.dmi')
	icon_state = "rifle"
	ammo_type = /obj/item/ammo_casing/vampire/c556mm
	caliber = CALIBER_556NATO
	max_ammo = 30
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/ammo_box/magazine/darkpack556/hunt
	name = "rifle magazine (5.56mm)"
	icon_state = "hunt556"
	max_ammo = 20
	custom_price = 200

/obj/item/gun/ballistic/automatic/darkpack/ar15
	name = "\improper CAR-15 Carbine"
	desc = "The black sexy assault rifle, designated 'CAR-15'."
	icon = 'modular_darkpack/modules/deprecated/icons/48x32.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	icon_state = "rifle"
	inhand_icon_state = "rifle"
	worn_icon_state = "rifle"
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_MEDIUM
	accepted_magazine_type = /obj/item/ammo_box/magazine/darkpack556
	burst_size = 2
	fire_delay = 2
	recoil = 5
	spread = 4
	bolt_type = BOLT_TYPE_LOCKING
	show_bolt_icon = FALSE
	mag_display = TRUE
	fire_sound = 'modular_darkpack/modules/deprecated/sounds/rifle.ogg'
	masquerade_violating = TRUE
	serial_type = "CAR"

/obj/item/gun/ballistic/automatic/darkpack/huntrifle
	name = "hunting rifle"
	desc = "A semi-automatic hunting rifle, just like what your dad used to shoot. If your dad didn't go out to get milk, anyways."
	icon = 'modular_darkpack/modules/deprecated/icons/48x32.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	worn_icon = 'icons/mob/clothing/back.dmi'
	icon_state = "huntrifle"
	inhand_icon_state = "huntrifle"
	worn_icon_state = "sks"
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_MEDIUM
	accepted_magazine_type = /obj/item/ammo_box/magazine/darkpack556/hunt
	burst_size = 1
	fire_delay = 1
	spread = 2
	recoil = 3
	bolt_type = BOLT_TYPE_LOCKING
	show_bolt_icon = FALSE
	mag_display = TRUE
	fire_sound = 'modular_darkpack/modules/deprecated/sounds/rifle.ogg'
	masquerade_violating = FALSE
	custom_price = 2000
	serial_type = "R&C"

/obj/item/ammo_box/magazine/darkpack545
	name = "rifle magazine (5.45mm)"
	icon = 'modular_darkpack/modules/weapons/icons/ammo.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/ammo_onfloor.dmi')
	icon_state = "ak"
	ammo_type = /obj/item/ammo_casing/vampire/c545mm
	caliber = CALIBER_545SOVIET
	max_ammo = 30
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/gun/ballistic/automatic/darkpack/ak74
	name = "\improper Kalashnikov's Automatic Rifle 74"
	desc = "Pretty old, but also easy fireable and cleanable by vodka.Uses 5.45 rounds."
	icon = 'modular_darkpack/modules/deprecated/icons/48x32.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	worn_icon = 'icons/mob/clothing/back.dmi'
	icon_state = "ak74"
	inhand_icon_state = "ak74"
	worn_icon_state = "sks"
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_MEDIUM
	accepted_magazine_type = /obj/item/ammo_box/magazine/darkpack545
	recoil = 5
	burst_size = 1
	spread = 8
	bolt_type = BOLT_TYPE_LOCKING
	show_bolt_icon = FALSE
	mag_display = TRUE
	fire_sound = 'modular_darkpack/modules/deprecated/sounds/ak.ogg'
	masquerade_violating = TRUE
	serial_type = "KA"
	var/rof = 0.2 SECONDS //300 RPM

/obj/item/gun/ballistic/automatic/darkpack/ak74/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, rof)

/obj/item/ammo_box/magazine/darkpackaug
	name = "AUG magazine (5.56mm)"
	icon = 'modular_darkpack/modules/weapons/icons/ammo.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/ammo_onfloor.dmi')
	icon_state = "aug"
	ammo_type = /obj/item/ammo_casing/vampire/c556mm
	caliber = CALIBER_556NATO
	max_ammo = 30
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/gun/ballistic/automatic/darkpack/aug
	name = "\improper Steyr AUG-77"
	desc = "An Austrian 5.56 bullpup design, designated 'Steyr AUG-77'."
	icon = 'modular_darkpack/modules/deprecated/icons/48x32.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	icon_state = "aug"
	inhand_icon_state = "aug"
	worn_icon_state = "aug"
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_MEDIUM
	accepted_magazine_type = /obj/item/ammo_box/magazine/darkpackaug
	burst_size = 3
	fire_delay = 2
	spread = 3
	recoil = 5
	bolt_type = BOLT_TYPE_LOCKING
	show_bolt_icon = FALSE
	mag_display = TRUE
	fire_sound = 'modular_darkpack/modules/deprecated/sounds/rifle.ogg'
	masquerade_violating = TRUE
	obj_flags = NONE
	serial_type = "SA"

/obj/item/ammo_box/magazine/darkpackthompson
	name = "tommy gun magazine (.45 ACP)"
	icon_state = "thompson"
	icon = 'modular_darkpack/modules/weapons/icons/ammo.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/ammo_onfloor.dmi')
	ammo_type = /obj/item/ammo_casing/vampire/c45acp
	caliber = CALIBER_45ACP
	max_ammo = 50
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/gun/ballistic/automatic/darkpack/thompson
	name = "\improper Thompson Submachine Gun"
	desc = "\"Arrivederci, you dumb motherfucker.\"" // a legendary wod13 screenshot
	icon = 'modular_darkpack/modules/deprecated/icons/48x32.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	icon_state = "thompson"
	inhand_icon_state = "thompson"
	w_class = WEIGHT_CLASS_NORMAL
	weapon_weight = WEAPON_MEDIUM
	accepted_magazine_type = /obj/item/ammo_box/magazine/darkpackthompson
	recoil = 5
	burst_size = 1
	spread = 15
	bolt_type = BOLT_TYPE_OPEN
	show_bolt_icon = FALSE
	mag_display = TRUE
	fire_sound = 'modular_darkpack/modules/deprecated/sounds/thompson.ogg'
	masquerade_violating = TRUE
	serial_type = "AO"
	var/rof = 0.15 SECONDS //400 RPM

/obj/item/gun/ballistic/automatic/darkpack/thompson/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, rof)

/obj/item/ammo_box/magazine/internal/darkpack/lever
	name = "lever action internal magazine"
	ammo_type = /obj/item/ammo_casing/vampire/c44
	caliber = CALIBER_44MAG
	max_ammo = 13

/obj/item/gun/ballistic/rifle/darkpack/lever
	name = "lever action rifle"
	desc = "A .44 caliber lever action rifle, perfect for casual hunters, reenactors, and urban cowboys. Yeehaw!"
	icon = 'modular_darkpack/modules/deprecated/icons/48x32.dmi'
	lefthand_file = 'modular_darkpack/modules/deprecated/icons/lefthand.dmi'
	righthand_file = 'modular_darkpack/modules/deprecated/icons/righthand.dmi'
	worn_icon = 'modular_darkpack/modules/weapons/icons/worn_guns.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	icon_state = "lever"
	inhand_icon_state = "lever"
	worn_icon_state = "lever"
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_MEDIUM
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/darkpack/lever
	bolt_wording = "bolt"
	need_bolt_lock_to_interact = TRUE
	bolt_type = BOLT_TYPE_LOCKING
	semi_auto = FALSE
	internal_magazine = TRUE
	fire_sound = 'modular_darkpack/modules/weapons/sounds/lever.ogg'
	vary_fire_sound = FALSE
	rack_sound = 'modular_darkpack/modules/weapons/sounds/bolt/lever_out.ogg'
	bolt_drop_sound = 'modular_darkpack/modules/weapons/sounds/bolt/lever_in.ogg'
	tac_reloads = FALSE
	recoil = 2
	fire_delay = 1					//It's bolt-action. Fast as you can go really; which is still pretty slow.
	burst_size = 1
	slot_flags = ITEM_SLOT_BACK
	projectile_damage_multiplier = 1.5 //~52 damage vs 35 base .44 damage. It's ok, on par with 5.56 but lower pen and slower to fire due to bolt action.
	masquerade_violating = FALSE
	serial_type = "WN"

/obj/item/ammo_box/magazine/internal/vampire/sniper
	name = "sniper rifle internal magazine"
	desc = "Oh god, this shouldn't be here"
	ammo_type = /obj/item/ammo_casing/vampire/c50
	caliber = CALIBER_50CAL
	max_ammo = 5
	//multiload = TRUE

/obj/item/gun/ballistic/automatic/darkpack/sniper
	name = "sniper rifle"
	desc = "A long ranged weapon that does significant damage. No, you can't quickscope."
	icon = 'modular_darkpack/modules/deprecated/icons/48x32.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	icon_state = "sniper"
	inhand_icon_state = "sniper"
	worn_icon_state = "sniper"
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/vampire/sniper
	bolt_wording = "bolt"
	bolt_type = BOLT_TYPE_STANDARD
	semi_auto = FALSE
	internal_magazine = TRUE
	fire_sound = 'modular_darkpack/modules/deprecated/sounds/sniper.ogg'
	fire_sound_volume = 90
	vary_fire_sound = FALSE
	rack_sound = 'sound/items/weapons/gun/rifle/bolt_out.ogg'
	bolt_drop_sound = 'sound/items/weapons/gun/rifle/bolt_in.ogg'
	tac_reloads = FALSE
	fire_delay = 40
	recoil = 7
	burst_size = 1
	//zoomable = TRUE
	//zoom_amt = 10 //Long range, enough to see in front of you, but no tiles behind you.
	//zoom_out_amt = 5
	slot_flags = ITEM_SLOT_BACK
	projectile_damage_multiplier = 2 //140 damage. Nice.
	actions_types = list()
	masquerade_violating = TRUE
	serial_type = "RB"

/obj/item/gun/ballistic/automatic/darkpack/autosniper
	name = "auto-sniper rifle"
	desc = "A semi-automatic marksman rifle. This particular model is very popular in video games as of late."
	icon = 'modular_darkpack/modules/deprecated/icons/48x32.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	icon_state = "psg1"
	inhand_icon_state = "psg1"
	worn_icon_state = "sniper"
	weapon_weight = WEAPON_HEAVY
	w_class = WEIGHT_CLASS_BULKY
	accepted_magazine_type = /obj/item/ammo_box/magazine/vamp762x51PSG1
	bolt_wording = "bolt"
	bolt_type = BOLT_TYPE_LOCKING
	semi_auto = TRUE

	//zoomable = TRUE
	//zoom_amt = 4 //It's known for having a shitty scope
	//zoom_out_amt =  1

	fire_sound = 'modular_darkpack/modules/deprecated/sounds/sniper.ogg'
	fire_sound_volume = 90
	tac_reloads = TRUE
	burst_size = 1
	fire_delay = 5
	spread = 2
	recoil = 6
	slot_flags = ITEM_SLOT_BACK
	projectile_damage_multiplier = 1.5
	actions_types = list()
	masquerade_violating = TRUE
	serial_type = "DS"

/obj/item/ammo_box/magazine/vamp762x51PSG1
	name = "PSG1 magazine (7.62x51mm)"
	desc = "A magazine for the PSG1 loaded in 7.62 NATO."
	icon = 'modular_darkpack/modules/weapons/icons/ammo.dmi'
	//lefthand_file = 'code/modules/wod13/lefthand.dmi'
	//righthand_file = 'code/modules/wod13/righthand.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/ammo_onfloor.dmi') // DARKPACK TODO: this needs a sprite
	icon_state = "psg1"
	ammo_type = /obj/item/ammo_casing/vampire/c762x51mm
	caliber = CALIBER_762NATO
	max_ammo = 10
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/ammo_box/magazine/internal/vampshotgun
	name = "shotgun internal magazine"
	ammo_type = /obj/item/ammo_casing/vampire/c12g
	caliber = CALIBER_12G
	//multiload = FALSE
	max_ammo = 6
	masquerade_violating = FALSE

/obj/item/gun/ballistic/shotgun/vampire
	name = "shotgun"
	desc = "A traditional shotgun with wood furniture and a six-round tube magazine."
	icon = 'modular_darkpack/modules/deprecated/icons/48x32.dmi'
	lefthand_file = 'modular_darkpack/modules/deprecated/icons/lefthand.dmi'
	righthand_file = 'modular_darkpack/modules/deprecated/icons/righthand.dmi'
	worn_icon = 'modular_darkpack/modules/weapons/icons/worn_guns.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	w_class = WEIGHT_CLASS_BULKY
	icon_state = "pomp"
	inhand_icon_state = "pomp"
	worn_icon_state = "pomp"
	recoil = 6
	fire_delay = 6
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/vampshotgun
	can_be_sawn_off	= FALSE
	fire_sound = 'modular_darkpack/modules/deprecated/sounds/pomp.ogg'
	recoil = 4
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	custom_price = 1000
	serial_type = "L"

/obj/item/ammo_box/magazine/internal/darkpack_dbarrel
	name = "double barrel internal magazine"
	ammo_type = /obj/item/ammo_casing/vampire/c12g
	caliber = CALIBER_12G
	max_ammo = 2
	masquerade_violating = FALSE

/obj/item/gun/ballistic/shotgun/vampire/doublebarrel
	name = "double barrel shotgun"
	desc = "A old fashioned double barrel shotgun with fine wood furnishing, complete with a double-trigger system."
	sawn_desc = "A old fashioned double barrel shotgun, complete with a double-trigger system. This one's sawn down well past the legal barrel length.."
	icon = 'modular_darkpack/modules/deprecated/icons/48x32.dmi'
	lefthand_file = 'modular_darkpack/modules/deprecated/icons/lefthand.dmi'
	righthand_file = 'modular_darkpack/modules/deprecated/icons/righthand.dmi'
	worn_icon = 'modular_darkpack/modules/weapons/icons/worn_guns.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	w_class = WEIGHT_CLASS_BULKY
	semi_auto = TRUE
	bolt_type = BOLT_TYPE_NO_BOLT
	icon_state = "dbarrel"
	inhand_icon_state = "dbarrel"
	base_icon_state = "dbarrel"
	worn_icon_state = "pomp"
	actions_types = list(/datum/action/item_action/toggle_firemode)
	burst_fire_selection = TRUE
	burst_size = 2	//So you can fire both barrels at once.
	burst_delay = 2
	recoil = 4
	fire_delay = 3
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/darkpack_dbarrel
	can_be_sawn_off	= TRUE
	fire_sound = 'modular_darkpack/modules/deprecated/sounds/pomp.ogg'
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	custom_price = 1200
	serial_type = "BH"	//Beretta makes a lot of hunting shotguns so - w/e

// Allows break-action appearance when shells are ejected.
/obj/item/gun/ballistic/shotgun/vampire/doublebarrel/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state][!chambered ? "_empty" : ""][sawn_off ? "_sawn" : ""]"

//Unique sawn-off checks
/obj/item/gun/ballistic/shotgun/vampire/doublebarrel/sawoff(mob/user, obj/item/saw, handle_modifications = TRUE)
	. = ..()
	weapon_weight = WEAPON_MEDIUM	//Lets you one-hand it on sawing.

/obj/item/ammo_box/magazine/darkpackautoshot
	name = "shotgun magazine (12ga)"
	icon = 'modular_darkpack/modules/weapons/icons/ammo.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/ammo_onfloor.dmi')
	icon_state = "spas15"
	ammo_type = /obj/item/ammo_casing/vampire/c12g/buck
	caliber = CALIBER_12G
	max_ammo = 6
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/gun/ballistic/automatic/darkpack/autoshotgun
	name = "\improper Jaegerspas-XV"
	desc = "A semi-automatic shotgun. It looks more like an assault rifle than a shotgun and fires at a deadly pace."
	icon = 'modular_darkpack/modules/deprecated/icons/48x32.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	icon_state = "spas15"
	inhand_icon_state = "spas15"
	worn_icon_state = "rifle"
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	accepted_magazine_type = /obj/item/ammo_box/magazine/darkpackautoshot
	burst_size = 1
	fire_delay = 2
	spread = 4
	bolt_type = BOLT_TYPE_LOCKING
	show_bolt_icon = FALSE
	mag_display = TRUE
	fire_sound = 'modular_darkpack/modules/deprecated/sounds/pomp.ogg'
	slot_flags = ITEM_SLOT_BACK
	projectile_damage_multiplier = 0.9
	masquerade_violating = TRUE
	recoil = 6
	serial_type = "AL"

/obj/item/gun/ballistic/shotgun/toy/crossbow/vampire
	name = "crossbow"
	desc = "Welcome to the Middle Ages!"
	icon = 'modular_darkpack/modules/deprecated/icons/48x32.dmi'
	lefthand_file = 'modular_darkpack/modules/deprecated/icons/lefthand.dmi'
	righthand_file = 'modular_darkpack/modules/deprecated/icons/righthand.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	icon_state = "crossbow0"
	inhand_icon_state = "crossbow0"
	fire_delay = 16
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/vampcrossbow
	fire_sound = 'sound/items/syringeproj.ogg'
	w_class = WEIGHT_CLASS_NORMAL
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	masquerade_violating = FALSE
	obj_flags = NONE
	serial_shown = FALSE	//No serial, it's a crossbow.

/obj/item/ammo_box/magazine/internal/vampcrossbow
	ammo_type = /obj/item/ammo_casing/caseless/bolt
	caliber = CALIBER_CROSSBOWBOLT
	max_ammo = 2

/obj/item/ammo_box/magazine/internal/vampire/musket
	name = "musket internal magazine"
	ammo_type = /obj/item/ammo_casing/vampire/c75
	caliber = CALIBER_75BALL
	max_ammo = 1	//It's a fucking musket

/obj/item/gun/ballistic/automatic/darkpack/musket
	name = "antique musket"
	desc = "A antique musket, likely from the mid 19th century. Luckily this appears to be a simple cartrige loader; just load it, ram, cock, and fire!"
	icon = 'modular_darkpack/modules/deprecated/icons/48x32.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	icon_state = "musket"
	inhand_icon_state = "musket"
	worn_icon_state = "musket"
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/vampire/musket
	bolt_type = BOLT_TYPE_NO_BOLT
	semi_auto = TRUE	//This is so it ejects/destroys the casing on firing.
	internal_magazine = TRUE
	fire_sound = 'modular_darkpack/modules/weapons/sounds/musket.ogg'
	vary_fire_sound = FALSE
	fire_delay = 50
	burst_size = 1
	recoil = 10	//tee hee
	spread = 14
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	projectile_damage_multiplier = 1.5 //150 damage; it is a single-shot.
	serial_shown = FALSE	//No serial, it's a musket.
	actions_types = list()

/obj/item/gun/ballistic/automatic/darkpack/musket/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	..()
	new /obj/effect/particle_effect/fluid/smoke(get_ranged_target_turf(user, user.dir, 1))
