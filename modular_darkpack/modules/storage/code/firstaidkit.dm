// Inside is: Standard, Doctor, Advanced, Brute, Burn, Oxygen, Toxins, IFAK & Combat First aid/Medical kits

/obj/item/storage/medkit/darkpack
	name = "first-aid kit"
	desc = "A first aid kit ideal for handling common, non-life threatening injuries."
	icon_state = "firstaid"
	inhand_icon_state = "firstaid"
	icon = 'modular_darkpack/modules/storage/icons/firstaidkit.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/storage/icons/firstaidkit_onfloor.dmi')
	lefthand_file = 'modular_darkpack/modules/storage/icons/firstaidkit_lefthand.dmi'
	righthand_file = 'modular_darkpack/modules/storage/icons/firstaidkit_righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/storage/medkit/darkpack/standard
	name = "first-aid kit"
	desc = "A handheld medical kit ideal for handling common, non-life threatening injuries."

/obj/item/storage/medkit/darkpack/standard/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/stack/medical/wrap/gauze = 1,
		/obj/item/stack/medical/suture = 2,
		/obj/item/stack/medical/mesh = 2,
		/obj/item/reagent_containers/hypospray/medipen = 1,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/medkit/darkpack/doctor
	name = "doctors kit"
	desc = "A handheld medical suite containing basic medical tools and some surgery equipment."
	icon_state = "firstaid_doctor"
	inhand_icon_state = "firstaid_doctor"
	storage_type = /datum/storage/medkit/darkpack/doctor

/obj/item/storage/medkit/darkpack/doctor/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/healthanalyzer = 1,
		/obj/item/stack/medical/wrap/gauze/twelve = 1,
		/obj/item/stack/medical/suture = 2,
		/obj/item/stack/medical/mesh = 2,
		/obj/item/reagent_containers/hypospray/medipen = 1,
		/obj/item/surgical_drapes = 1,
		/obj/item/scalpel = 1,
		/obj/item/hemostat = 1,
		/obj/item/cautery = 1,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/medkit/darkpack/advanced
	name = "advanced first-aid kit"
	desc = "A handheld medical kit designed for handling advanced injuries."
	icon_state = "firstaid_advanced"
	inhand_icon_state = "firstaid_advanced"

/obj/item/storage/medkit/darkpack/advanced/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/reagent_containers/applicator/patch/synthflesh = 3,
		/obj/item/reagent_containers/hypospray/medipen/atropine = 2,
		/obj/item/stack/medical/wrap/gauze = 1,
		/obj/item/storage/pill_bottle/penacid = 1,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/medkit/darkpack/brute
	name = "brute treatment kit"
	desc = "A handheld medical kit ideal for handling someone who has found the front of a moving truck."
	icon_state = "firstaid_brute"
	inhand_icon_state = "firstaid_brute"

/obj/item/storage/medkit/darkpack/brute/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/reagent_containers/applicator/patch/libital = 3,
		/obj/item/stack/medical/wrap/gauze = 1,
		/obj/item/storage/pill_bottle/probital = 1,
		/obj/item/reagent_containers/hypospray/medipen/salacid = 1,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/medkit/darkpack/burn
	name = "burn treatment kit"
	desc = "A handheld medical kit ideal for handling someone who has fought fire."
	icon_state = "firstaid_burn"
	inhand_icon_state = "firstaid_burn"

/obj/item/storage/medkit/darkpack/burn/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/reagent_containers/applicator/patch/aiuri = 3,
		/obj/item/reagent_containers/spray/hercuri = 1,
		/obj/item/reagent_containers/hypospray/medipen/oxandrolone = 1,
		/obj/item/reagent_containers/hypospray/medipen = 1,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/medkit/darkpack/oxy
	name = "o2 treatment kit"
	desc = "A handheld medical kit ideal for handling someone who has been left breathless."
	icon_state = "firstaid_oxy"
	inhand_icon_state = "firstaid_oxy"

/obj/item/storage/medkit/darkpack/oxy/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/reagent_containers/applicator/patch/aiuri = 3,
		/obj/item/reagent_containers/spray/hercuri = 1,
		/obj/item/reagent_containers/hypospray/medipen/oxandrolone = 1,
		/obj/item/reagent_containers/hypospray/medipen = 1,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/medkit/darkpack/tox
	name = "toxin treatment kit"
	desc = "A handheld medical kit ideal for handling someone who has fallen into a vat of radioactive goop."
	icon_state = "firstaid_tox"
	inhand_icon_state = "firstaid_tox"

/obj/item/storage/medkit/darkpack/tox/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/storage/pill_bottle/multiver/less = 1,
		/obj/item/reagent_containers/syringe/syriniver = 3,
		/obj/item/storage/pill_bottle/potassiodide = 1,
		/obj/item/reagent_containers/hypospray/medipen/penacid = 1,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/medkit/darkpack/ifak
	name = "IFAK"
	desc = "An Individual First-Aid Kit, for when it's just you and me."
	icon_state = "firstaid_ifak"
	inhand_icon_state = "firstaid_ifak"

/obj/item/storage/medkit/darkpack/ifak/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/reagent_containers/hypospray/medipen/ifak = 3,
		/obj/item/stack/medical/wrap/gauze = 1,
		/obj/item/healthanalyzer = 1,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/medkit/darkpack/combat
	name = "combat medical kit"
	desc = "A medical suite designed for when you need your strongest potions to take into battle."
	icon_state = "firstaid_combat"
	inhand_icon_state = "firstaid_combat"
	storage_type = /datum/storage/medkit/darkpack/combat

/obj/item/storage/medkit/darkpack/combat/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/stack/medical/wrap/gauze = 1,
		/obj/item/defibrillator/compact/combat/loaded = 1,
		/obj/item/reagent_containers/hypospray/combat = 1,
		/obj/item/reagent_containers/applicator/patch/libital = 2,
		/obj/item/reagent_containers/applicator/patch/aiuri = 2,
		/obj/item/clothing/glasses/hud/health/night = 1,
	)
	generate_items_inside(items_inside,src)


/datum/storage/medkit/darkpack/doctor/New(atom/parent, max_slots, max_specific_storage, max_total_storage, rustle_sound, remove_rustle_sound, list/holdables)
	holdables = list_of_everything_medkits_can_hold
	return ..()

/datum/storage/medkit/darkpack/combat/New(atom/parent, max_slots, max_specific_storage, max_total_storage, rustle_sound, remove_rustle_sound, list/holdables)
	holdables = list_of_everything_medkits_can_hold
	return ..()
