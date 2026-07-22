// TOWER ROLES BEGIN HERE

/datum/outfit/job/towerwork/towercleaner
	name = "Tower Employee (Tower Cleaner)"
	uniform = /obj/item/clothing/under/vampire/janitor
	suit = null
	shoes = /obj/item/clothing/shoes/vampire/jackboots/work
	gloves = /obj/item/clothing/gloves/vampire/cleaning
	r_pocket = /obj/item/vamp/keys/camarilla/ghoul
	l_pocket = /obj/item/smartphone/tower_employee
	backpack_contents = list(/obj/item/card/credit=1)

/datum/outfit/job/towerwork/towerassistant
	name = "Tower Employee (Tower Assistant)"
	uniform = /obj/item/clothing/under/vampire/office
	gloves = null
	suit = null
	r_pocket = /obj/item/vamp/keys/camarilla/ghoul
	l_pocket = /obj/item/smartphone/tower_employee
	backpack_contents = list(/obj/item/passport=1, /obj/item/watch=1, /obj/item/flashlight=1, /obj/item/card/credit=1, /obj/item/clipboard=1, /obj/item/pen=1, /obj/item/folder/blue=1)

/datum/outfit/job/towerwork/towersecurityguard
	name = "Tower Employee (Tower Security Guard)"
	uniform = /obj/item/clothing/under/vampire/guard
	shoes = /obj/item/clothing/shoes/vampire
	gloves = null
	suit = null
	belt = /obj/item/gun/ballistic/automatic/pistol/darkpack/m1911
	r_pocket = /obj/item/vamp/keys/camarilla/ghoul
	l_pocket = /obj/item/smartphone/tower_employee
	backpack_contents = list(/obj/item/flashlight=1, /obj/item/card/credit=1,/obj/item/storage/fancy/donut_box=1, /obj/item/watch=1)

/datum/outfit/job/towerwork/towerpersonaldriver
	name = "Tower Employee (Tower Personal Driver)"
	uniform = /obj/item/clothing/under/vampire/suit
	suit = null
	head = /obj/item/clothing/head/vampire/top
	gloves = /obj/item/clothing/gloves/vampire/white
	r_pocket = /obj/item/vamp/keys/camarilla/ghoul
	l_pocket = /obj/item/smartphone/tower_employee
	backpack_contents = list(/obj/item/passport=1, /obj/item/watch=1, /obj/item/flashlight=1, /obj/item/card/credit=1, /obj/item/clipboard=1, /obj/item/pen=1, /obj/item/folder/red=1)

/datum/outfit/job/towerwork/towerpersonaldriver/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/suit/female

/datum/outfit/job/towerwork/towerpersonalattendant
	name = "Tower Employee (Tower Personal Attendant)"
	uniform = /obj/item/clothing/under/vampire/suit
	r_pocket = /obj/item/vamp/keys/camarilla/ghoul
	l_pocket = /obj/item/smartphone/tower_employee
	backpack_contents = list(/obj/item/passport=1, /obj/item/watch=1, /obj/item/flashlight=1, /obj/item/card/credit=1, /obj/item/clipboard=1, /obj/item/pen=1, /obj/item/folder/red=1)

/datum/outfit/job/towerwork/towerpersonalattendant/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/suit/female
		shoes = /obj/item/clothing/shoes/vampire/heels

// TOWER ROLES END HERE
