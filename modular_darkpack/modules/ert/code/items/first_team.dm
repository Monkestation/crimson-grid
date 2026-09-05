//------------EQUIPMENT------------
/datum/armor/first_team
	melee = 70
	bullet = 70
	laser = 70
	energy = 70
	fire = 70
	bomb = 70
	acid = 70
	wound = 70

//------------SHOES------------
/obj/item/clothing/shoes/vampire/darkpack_ert
	name = "shoes"
	desc = "Comfortable-looking shoes."
	icon = 'modular_darkpack/modules/ert/icons/clothing.dmi'
	worn_icon = 'modular_darkpack/modules/ert/icons/worn.dmi'
	icon_state = "ftboots"
	inhand_icon_state = null
	gender = PLURAL
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/ert/icons/onfloor.dmi')
	brand = "pentex"

/obj/item/clothing/shoes/vampire/darkpack_ert/firstteam
	name = "\improper First team boots"
	desc = "Pitch-black boots with hard, industrial laces."
	armor_type = /datum/armor/shoes_jackboots

//------------GLOVES------------

/obj/item/clothing/gloves/vampire/darkpack_ert
	icon = 'modular_darkpack/modules/ert/icons/clothing.dmi'
	worn_icon = 'modular_darkpack/modules/ert/icons/worn.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/ert/icons/onfloor.dmi')
	icon_state = "ftgloves"
	undyeable = TRUE
	brand = "pentex"

/obj/item/clothing/gloves/vampire/darkpack_ert/firstteam
	name = "\improper First Team gloves"
	desc = "Provides protection from the good, the bad and the ugly."
	body_parts_covered = HANDS
	armor_type = /datum/armor/gloves_combat

//------------HELMET------------

/obj/item/clothing/head/vampire/darkpack_ert
	icon_state = "fthelmet"
	icon = 'modular_darkpack/modules/ert/icons/clothing.dmi'
	inhand_icon_state = null
	worn_icon = 'modular_darkpack/modules/ert/icons/worn.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/ert/icons/onfloor.dmi')
	brand = "pentex"

/obj/item/clothing/head/vampire/darkpack_ert/firstteam_helmet
	name = "\improper First Team helmet"
	desc = "A black helmet with two, green-glowing eye-pieces that seem to stare through your soul."
	armor_type = /datum/armor/first_team
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR
	visor_flags_inv = HIDEFACE|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF

//------------ARMOR------------

/obj/item/clothing/suit/vampire/darkpack_ert
	icon_state = "ftarmor"
	icon = 'modular_darkpack/modules/ert/icons/clothing.dmi'
	worn_icon = 'modular_darkpack/modules/ert/icons/worn.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/ert/icons/onfloor.dmi')
	inhand_icon_state = null

	body_parts_covered = CHEST
	cold_protection = CHEST|GROIN
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	max_integrity = 250
	resistance_flags = NONE
	brand = "pentex"

/obj/item/clothing/suit/vampire/darkpack_ert/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 200, "suit", FALSE)


/obj/item/clothing/suit/vampire/darkpack_ert/firstteam_armor
	name = "\improper First Team Armoured Vest"
	desc = "A strong looking, armoured-vest with a large '1' engraved onto the breast."
	inhand_icon_state = null
	armor_type = /datum/armor/first_team
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	clothing_traits = list(TRAIT_BRAWLING_KNOCKDOWN_BLOCKED)

//------------SUIT------------

/obj/item/clothing/under/vampire/darkpack_ert
	name = "\improper First Team uniform"
	desc = "A completely blacked out uniform with a large '1' symbol sewn onto the shoulder-pad."
	icon_state = "ftuni"
	has_sensor = NO_SENSORS
	random_sensor = FALSE
	can_adjust = FALSE
	icon = 'modular_darkpack/modules/ert/icons/clothing.dmi'
	worn_icon = 'modular_darkpack/modules/ert/icons/worn.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/ert/icons/onfloor.dmi')
	brand = "pentex"

/obj/item/clothing/under/vampire/darkpack_ert/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 100, "undersuit", FALSE)

/obj/item/clothing/under/vampire/darkpack_ert/firstteam_uniform
	name = "First Team uniform"
	desc = "A completely blacked out uniform with a large '1' symbol sewn onto the shoulder-pad."
	armor_type = /datum/armor/clothing_under/security_head_of_security
	brand = "pentex"

//------------Glasses------------

/obj/item/clothing/glasses/night/thermal
	vision_flags = SEE_MOBS
//	brand = "mars" // TODO: implement the rest of the non-top 21 pentex subsids

//------------Weapons------------/obj/item/ammo_casing/vampire/c12gvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
/obj/item/ammo_box/darkpack/c556/bale //DONT EVER PUT THIS IN A MAP
	name = "balefire ammo box (5.56)"
	icon = 'modular_darkpack/modules/ert/icons/ammo.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/ert/icons/onfloor.dmi')
	icon_state = "556box-bale"
	ammo_type = /obj/item/ammo_casing/vampire/c556mm/bale

/obj/item/ammo_casing/vampire/c556mm/bale
	name = "green 5.56mm bullet casing"
	desc = "A modified 5.56mm bullet casing."
	caliber = CALIBER_556NATO
	projectile_type = /obj/projectile/bullet/darkpack/vamp556mm/bale
	icon = 'modular_darkpack/modules/ert/icons/ammo.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/ert/icons/onfloor.dmi')
	icon_state = "b556"
	base_icon_state = "b556"

/obj/projectile/bullet/darkpack/vamp556mm/bale
	armour_penetration = 50
	damage = 45
	var/bloodloss = 1

/obj/projectile/bullet/darkpack/vamp556mm/bale/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	bale_fire_damage(target, 4, bloodloss)

/obj/projectile/bullet/proc/bale_fire_damage(mob/living/carbon/human/target, dice = 0, bloodloss = 1)
	if(!istype(target))
		return

	var/datum/splat/werewolf/shifter/shot_pup_splat = get_shifter_splat(target)
	if(shot_pup_splat)
		target.apply_status_effect(STATUS_EFFECT_SILVER_BULLET_STACKS)
		target.apply_damage(dice TTRPG_DAMAGE, AGGRAVATED)
		playsound(target, 'modular_darkpack/modules/ert/sounds/balefire.ogg', rand(10,15), TRUE)
		return

	var/datum/splat/vampire/shot_vampire_splat = get_vampire_splat(target)
	if(shot_vampire_splat)
		if(target.bloodpool <= 0)
			to_chat(target, span_warning("Only ash remains in my veins!"))
			target.apply_damage(dice TTRPG_DAMAGE, BURN)
			return
		target.adjust_blood_pool(-bloodloss)
		playsound(target, 'modular_darkpack/modules/ert/sounds/balefire.ogg', rand(10,15), TRUE)
		to_chat(target, span_warning("Green flames errupt from the bullets impact, boiling your blood!"))


/obj/item/ammo_casing/vampire/c12g/f12g
	name = "Frag-12g shell casing"
	desc = "A 12g explosive shell casing."
	caliber = CALIBER_SHOTGUN
	projectile_type = /obj/projectile/bullet/darkpack/f12g
	icon = 'modular_darkpack/modules/ert/icons/ammo.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/ert/icons/onfloor.dmi')
	icon_state = "f12"
	base_icon_state = "f12"
//	brand = "fullforce" // TODO: implement the rest of the non-top 21 pentex subsids

/obj/projectile/bullet/darkpack/f12g
	name = "12g explosive slug"
	damage = 60
	armour_penetration = 50
	exposed_wound_bonus = 10
	wound_bonus = 5
//	brand = "fullforce" // TODO: implement the rest of the non-top 21 pentex subsids

/obj/projectile/bullet/darkpack/f12g/on_hit(atom/target, blocked = 0, pierce_hit)
	..()
	explosion(target, devastation_range = -1, light_impact_range = 2, explosion_cause = src)
	return BULLET_ACT_HIT

/obj/item/ammo_box/darkpack/f12g //DO NOT DISTRIBUTE NORMALLY
	name = "ammo box (f12g)"
	icon = 'modular_darkpack/modules/ert/icons/ammo.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/ert/icons/onfloor.dmi')
	icon_state = "12box_frag"
	ammo_type = /obj/item/ammo_casing/vampire/c12g/f12g
	max_ammo = 40
//	brand = "fullforce" // TODO: implement the rest of the non-top 21 pentex subsids

/obj/item/ammo_box/magazine/darkpack/px66f
	name = "\improper PX66F magazine (5.56mm)"
	icon = 'modular_darkpack/modules/ert/icons/ammo.dmi'
	lefthand_file = 'modular_darkpack/modules/ert/icons/righthand.dmi'
	righthand_file = 'modular_darkpack/modules/ert/icons/lefthand.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/ert/icons/onfloor.dmi')
	icon_state = "px66f"
	inhand_icon_state = null
	ammo_type = /obj/item/ammo_casing/vampire/c556mm/bale
	caliber = CALIBER_556NATO
	max_ammo = 30
	multiple_sprites = AMMO_BOX_FULL_EMPTY
//	brand = "fullforce" // TODO: implement the rest of the non-top 21 pentex subsids

/obj/item/ammo_box/magazine/darkpack/px249f
	name = "\improper PX249F box magazine (5.56mm)"
	icon = 'modular_darkpack/modules/ert/icons/ammo.dmi'
	lefthand_file = 'modular_darkpack/modules/ert/icons/righthand.dmi'
	righthand_file = 'modular_darkpack/modules/ert/icons/lefthand.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	inhand_icon_state = null
	icon_state = "px249f"
	ammo_type = /obj/item/ammo_casing/vampire/c556mm/bale
	caliber = CALIBER_556NATO
	max_ammo = 200
	multiple_sprites = AMMO_BOX_FULL_EMPTY
//	brand = "fullforce" // TODO: implement the rest of the non-top 21 pentex subsids

/obj/item/ammo_box/magazine/internal/px12r
	name = "shotgun internal magazine"
	ammo_type = /obj/item/ammo_casing/vampire/c12g
	caliber = CALIBER_SHOTGUN
	max_ammo = 8
	masquerade_violating = FALSE

/obj/item/ammo_box/magazine/darkpack/mk23
	name = "\improper automatic pistol magazine (.45 ACP)"
	icon = 'modular_darkpack/modules/ert/icons/ammo.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/ert/icons/onfloor.dmi')
	inhand_icon_state = null
	icon_state = "mk23_mag"
	ammo_type = /obj/item/ammo_casing/vampire/c45acp
	caliber = CALIBER_45
	max_ammo = 12
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	brand = "herculean"

/obj/item/ammo_box/magazine/darkpack/mk23/silver
	name = "automatic pistol magazine (.45 ACP Silver)"
	ammo_type = /obj/item/ammo_casing/vampire/c45acp/silver
	brand = "herculean"

/obj/item/ammo_box/magazine/darkpack/mk23/hp
	name = "automatic pistol magazine (.45 ACP HP)"
	ammo_type = /obj/item/ammo_casing/vampire/c45acp/HP
	brand = "herculean"

/obj/item/gun/ballistic/automatic/pistol/darkpack/mk23_socom
	name = "\improper Mark 23 SOCOM Pistol"
	desc = "A specialized .45 ACP Pistol featuring an integrated supressor and laser sight"
	icon = 'modular_darkpack/modules/ert/icons/48x32weapons.dmi'
	lefthand_file = 'modular_darkpack/modules/ert/icons/righthand.dmi'
	righthand_file = 'modular_darkpack/modules/ert/icons/lefthand.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/ert/icons/onfloor.dmi')
	icon_state = "mk23"
	//onflooricon_state = "mk23"
	inhand_icon_state = "mk23"
	w_class = WEIGHT_CLASS_SMALL
	accepted_magazine_type = /obj/item/ammo_box/magazine/darkpack/mk23
	burst_size = 1
	recoil = 0
	projectile_damage_multiplier = 1.3
	actions_types = list()
	bolt_type = BOLT_TYPE_LOCKING
	suppressed = SUPPRESSED_QUIET
	can_suppress = FALSE
	can_unsuppress = FALSE
	fire_sound = 'modular_darkpack/modules/weapons/sounds/glock.ogg' //Doesnt matter when it's always using the supressed SFX
	brand = "herculean"

/obj/item/gun/ballistic/automatic/darkpack/px66f //DO NOT DISTRIBUTE IN MAPPING
	name = "\improper PX66F Rifle"
	desc = "A three-round burst 5.56 death machine, with a Spiral brand below the barrel."
	icon = 'modular_darkpack/modules/ert/icons/48x32weapons.dmi'
	lefthand_file = 'modular_darkpack/modules/ert/icons/righthand.dmi'
	righthand_file = 'modular_darkpack/modules/ert/icons/lefthand.dmi'
	worn_icon = 'modular_darkpack/modules/weapons/icons/worn_guns.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/ert/icons/onfloor.dmi')
	icon_state = "px66f"
	inhand_icon_state = "px66f"
	worn_icon_state = "rifle"
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_MEDIUM //Bullpup makes it easy to fire with one hand, but we still don't want these dual-wielded
	accepted_magazine_type = /obj/item/ammo_box/magazine/darkpack/px66f
	burst_size = 3
	spread = 2
	recoil = 1.5
	bolt_type = BOLT_TYPE_LOCKING
	show_bolt_icon = FALSE
	mag_display = TRUE
	can_suppress = FALSE
	fire_sound = 'modular_darkpack/modules/ert/sounds/silenced_rifle.ogg'
	masquerade_violating = TRUE
//	brand = "fullforce" // TODO: implement the rest of the non-top 21 pentex subsids

/obj/item/gun/ballistic/automatic/darkpack/px66f/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 350, "aug", FALSE)
	AddComponent(/datum/component/automatic_fire, 0.5 SECONDS)

/obj/item/gun/ballistic/shotgun/darkpack/px12r  //DONT DISTRIBUTE IN MAPPING
	name = "\improper PX12R Breaching Shotgun"
	desc = "A highly modified 12G Shotgun designed to fire Frag-12 explosive breaching rounds"
	icon = 'modular_darkpack/modules/ert/icons/48x32weapons.dmi'
	lefthand_file = 'modular_darkpack/modules/ert/icons/righthand.dmi'
	righthand_file = 'modular_darkpack/modules/ert/icons/lefthand.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/ert/icons/onfloor.dmi')
	worn_icon = 'modular_darkpack/modules/weapons/icons/worn_guns.dmi'
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_MEDIUM
	worn_icon_state = "pomp"
	icon_state = "px12r"
	inhand_icon_state = "px12r"
	recoil = 3
	fire_delay = 6
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/px12r
	can_be_sawn_off	= FALSE
	fire_sound = 'modular_darkpack/modules/ert/sounds/shotgun_firing.ogg'
	load_sound = 'modular_darkpack/modules/ert/sounds/shell_load.ogg'
	rack_sound = 'modular_darkpack/modules/ert/sounds/cycling.ogg'
	inhand_x_dimension = 32
	inhand_y_dimension = 32
//	brand = "fullforce" // TODO: implement the rest of the non-top 21 pentex subsids

/obj/item/gun/ballistic/automatic/l6_saw/darkpack
	name = "\improper PX249F Light Machine Gun"
	desc = "A modified M249 Machine Gun with an engraving of a Hydra on the grip"
	icon = 'modular_darkpack/modules/ert/icons/48x32weapons.dmi'
	lefthand_file = 'modular_darkpack/modules/ert/icons/righthand.dmi'
	righthand_file = 'modular_darkpack/modules/ert/icons/lefthand.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/ert/icons/onfloor.dmi')
	icon_state = "px249f"
	inhand_icon_state = "px249f"
	base_icon_state = "px249f"
	w_class = WEIGHT_CLASS_HUGE
	bolt_type = BOLT_TYPE_LOCKING
	show_bolt_icon = FALSE
	slot_flags = 0
	pin = /obj/item/firing_pin
	accepted_magazine_type = /obj/item/ammo_box/magazine/darkpack/px249f
	weapon_weight = WEAPON_HEAVY
	burst_size = 1
	recoil = 6 //With good firearm skill it's not an issue
	spread = 6
	fire_sound = 'modular_darkpack/modules/ert/sounds/m249fire.ogg'
	rack_sound = 'modular_darkpack/modules/ert/sounds/m249rack.ogg'
//	brand = "fullforce" // TODO: implement the rest of the non-top 21 pentex subsids

/obj/item/gun/ballistic/automatic/l6_saw/darkpack/update_icon_state()
	. = ..()
	if(item_flags & ACTIVE_ONFLOOR_ICON)
		return
	inhand_icon_state = "[base_icon_state][magazine ? "mag":"nomag"]"

/obj/item/gun/ballistic/automatic/l6_saw/darkpack/update_overlays()
	. = ..()
	if(item_flags & ACTIVE_ONFLOOR_ICON)
		return
	. += "px249f_door_[cover_open ? "open" : "closed"]"

/obj/item/gun/ballistic/automatic/l6_saw/darkpack/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.1 SECONDS)

//------------Medical------------
//To be done at a later date
