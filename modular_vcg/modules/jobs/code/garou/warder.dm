/datum/outfit/job/vampire/warder
	id = /obj/item/card/police/ranger/chief_ranger
	ears = /obj/item/radio/headset/darkpack/nps_rangers
	uniform = /obj/item/clothing/under/vampire/turtleneck_black/ranger
	suit = /obj/item/clothing/suit/vampire/vest/police/captain/ranger
	belt = /obj/item/storage/belt/security/police
	suit_store = /obj/item/storage/belt/sheath/vamp/sabre
	r_pocket = /obj/item/vamp/keys/nps
	backpack_contents = list(/obj/item/gun/ballistic/automatic/pistol/darkpack/deagle=1, /obj/item/ammo_box/darkpack/c9mm = 1, /obj/item/ammo_box/magazine/glock9mm = 2, /obj/item/veil_contract, /obj/item/card/credit/rich=1, /obj/item/storage/medkit/darkpack/ifak=1) // This overwrites modular_darkpack list, not append.

/datum/outfit/job/vampire/warder/post_equip(mob/living/carbon/human/user, visuals_only = FALSE)
	. = ..()
	if(visuals_only) // don't bother teaching dummies
		return
	var/datum/martial_art/cqc/kailindo/kailindo = new
	kailindo.teach(user)
