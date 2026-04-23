/datum/storage/holster/darkpack
	max_slots = 3 // Pistol + two mags
	max_total_storage = 16
	open_sound = 'sound/items/handling/holster_open.ogg'
	open_sound_vary = TRUE
/datum/storage/holster/darkpack/New(atom/parent, max_slots, max_specific_storage, max_total_storage, rustle_sound, remove_rustle_sound, list/holdables)
	. = ..()
	if(length(holdables))
		set_holdable(holdables)
		return

	set_holdable(list(
		/obj/item/gun/ballistic/automatic/pistol,
		/obj/item/gun/ballistic/revolver,
		/obj/item/ammo_box/magazine,
		/obj/item/ammo_box/darkpack/c9mm/moonclip
	))

/obj/item/storage/belt/holster/detective/darkpack // TODO: Get unique sprites for these
	name = "holster"
	desc = "a holster for your gun."
	storage_type = /datum/storage/holster/darkpack

/obj/item/storage/belt/holster/detective/darkpack/police
	desc = "standard issue holster for standard issue sidearms."

/obj/item/storage/belt/holster/detective/darkpack/police/PopulateContents()
	new /obj/item/ammo_box/darkpack/c9mm/moonclip(src)
	new /obj/item/ammo_box/darkpack/c9mm/moonclip(src)
	new /obj/item/gun/ballistic/revolver/darkpack/snub(src)

/obj/item/storage/belt/holster/detective/darkpack/officer

/obj/item/storage/belt/holster/detective/darkpack/officer/PopulateContents()
	new /obj/item/gun/ballistic/automatic/pistol/darkpack/glock19(src)
	new /obj/item/ammo_box/magazine/glock9mm(src)
	new /obj/item/ammo_box/magazine/glock9mm(src)

/obj/item/storage/belt/holster/detective/darkpack/fbi

/obj/item/storage/belt/holster/detective/darkpack/fbi/PopulateContents()
	new /obj/item/gun/ballistic/automatic/pistol/darkpack/glock21(src)
	new /obj/item/ammo_box/magazine/glock45acp/hp(src)
	new /obj/item/ammo_box/magazine/glock45acp/hp(src)

/obj/item/storage/belt/holster/detective/darkpack/endron

/obj/item/storage/belt/holster/detective/darkpack/endron/PopulateContents()
	new /obj/item/gun/ballistic/automatic/pistol/darkpack/glock19(src)
	new /obj/item/ammo_box/magazine/glock9mm(src)

/obj/item/storage/belt/security/police
	name = "duty belt"
	desc = "A black leather belt for holding patrol gear."
	storage_type = /datum/storage/security_belt/darkpack

/obj/item/storage/belt/security/police/PopulateContents()
	new /obj/item/gun/energy/taser/darkpack(src)
	new /obj/item/gun/ballistic/automatic/pistol/darkpack/m1911(src)

/obj/item/storage/belt/security/police/swat

/obj/item/storage/belt/security/police/swat/full/PopulateContents()
	new /obj/item/gun/energy/taser/darkpack(src)
	new /obj/item/reagent_containers/spray/pepper(src)
	new /obj/item/restraints/handcuffs(src)
	new /obj/item/ammo_box/magazine/darkpack556(src)
	new /obj/item/ammo_box/magazine/darkpack556(src)

/datum/storage/security_belt/darkpack/New(atom/parent, max_slots, max_specific_storage, max_total_storage, rustle_sound, remove_rustle_sound)
	. = ..()
	set_holdable(list(
		/obj/item/ammo_box,
		/obj/item/ammo_casing,
		/obj/item/assembly/flash/handheld,
		/obj/item/clothing/glasses,
		/obj/item/clothing/gloves,
		/obj/item/flashlight/seclite,
		/obj/item/food/donut,
		/obj/item/grenade,
		/obj/item/holosign_creator/security,
		/obj/item/knife/combat,
		/obj/item/melee/baton,
		/obj/item/radio,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/restraints/handcuffs,
		/obj/item/restraints/legcuffs/bola,
		/obj/item/gun/energy/taser,
	))
