/obj/item/organ/cyberimp/arm/toolkit/surgery/vicissitude
	icon_state = "toolkit_implant_vic"
	icon = 'modular_darkpack/modules/powers/icons/fleshcrafting_surgery_tools.dmi'
	organ_flags = ORGAN_ORGANIC
	aug_overlay = ""
	items_to_create = list(
		/obj/item/retractor/augment/vicissitude,
		/obj/item/hemostat/augment/vicissitude,
		/obj/item/cautery/augment/vicissitude,
		/obj/item/surgicaldrill/augment/vicissitude,
		/obj/item/scalpel/augment/vicissitude,
		/obj/item/circular_saw/augment/vicissitude,
		/obj/item/surgical_drapes/vicissitude,
		/obj/item/bonesetter/augment/vicissitude,
		/obj/item/blood_filter/augment/vicissitude,
		/obj/item/healthanalyzer/vicissitude,
		/obj/item/shockpaddles/cyborg/vicissitude)
	extend_sound = 'modular_darkpack/modules/powers/sounds/vicissitude.ogg'
	retract_sound =  'modular_darkpack/modules/powers/sounds/vicissitude.ogg'

/obj/item/retractor/augment/vicissitude
	name = "retracting appendage"
	desc = "A pair of prehensile pincers."
	icon_state = "retractor_vic"
	inhand_icon_state = "clamps_vic"
	lefthand_file = 'modular_darkpack/modules/powers/icons/righthand.dmi'
	righthand_file = 'modular_darkpack/modules/powers/icons/lefthand.dmi'
	icon = 'modular_darkpack/modules/powers/icons/fleshcrafting_surgery_tools.dmi'

/obj/item/hemostat/augment/vicissitude
	name = "hemostatic pincers"
	desc = "A pair of thin appendages that were once fingers, secreting a hemostatic fluid from the tips."
	icon_state = "hemostat_vic"
	inhand_icon_state = "clamps_vic"
	lefthand_file = 'modular_darkpack/modules/powers/icons/righthand.dmi'
	righthand_file = 'modular_darkpack/modules/powers/icons/lefthand.dmi'
	icon = 'modular_darkpack/modules/powers/icons/fleshcrafting_surgery_tools.dmi'

/obj/item/cautery/augment/vicissitude
	name = "chemical cautery"
	desc = "A specialized organ drooling a chemical package that releases an extreme amount of heat, very quickly."
	icon_state = "cautery_vic"
	inhand_icon_state = "cautery_vic"
	lefthand_file = 'modular_darkpack/modules/powers/icons/righthand.dmi'
	righthand_file = 'modular_darkpack/modules/powers/icons/lefthand.dmi'
	icon = 'modular_darkpack/modules/powers/icons/fleshcrafting_surgery_tools.dmi'

/obj/item/surgicaldrill/augment/vicissitude
	name = "surgical fang"
	desc = "A spiral fang that bores into the flesh with reckless glee."
	icon_state = "drill_vic"
	inhand_icon_state = "drill_vic"
	hitsound = 'sound/effects/wounds/blood2.ogg'
	lefthand_file = 'modular_darkpack/modules/powers/icons/righthand.dmi'
	righthand_file = 'modular_darkpack/modules/powers/icons/lefthand.dmi'
	icon = 'modular_darkpack/modules/powers/icons/fleshcrafting_surgery_tools.dmi'

/obj/item/scalpel/augment/vicissitude
	name = "scalpel claw"
	desc = "An altered nail, adjusted to make fine incisions."
	icon_state = "scalpel_vic"
	inhand_icon_state = "scalpel_vic"
	lefthand_file = 'modular_darkpack/modules/powers/icons/righthand.dmi'
	righthand_file = 'modular_darkpack/modules/powers/icons/lefthand.dmi'
	icon = 'modular_darkpack/modules/powers/icons/fleshcrafting_surgery_tools.dmi'

/obj/item/circular_saw/augment/vicissitude
	name = "circular jaw"
	desc = "A spinning disc of teeth, screaming, as it bites through the flesh."
	icon_state = "saw_vic"
	inhand_icon_state = "saw_vic"
	hitsound = 'sound/effects/wounds/blood2.ogg'
	lefthand_file = 'modular_darkpack/modules/powers/icons/righthand.dmi'
	righthand_file = 'modular_darkpack/modules/powers/icons/lefthand.dmi'
	icon = 'modular_darkpack/modules/powers/icons/fleshcrafting_surgery_tools.dmi'

/obj/item/surgical_drapes/vicissitude
	name = "skin drape"
	desc = "A stretch of skin, sweating out antibiotics and disinfectants, to provide a sterile-ish environment to work in."
	icon_state = "surgical_drapes_vic"
	inhand_icon_state = "drapes_vic"
	lefthand_file = 'modular_darkpack/modules/powers/icons/righthand.dmi'
	righthand_file = 'modular_darkpack/modules/powers/icons/lefthand.dmi'
	icon = 'modular_darkpack/modules/powers/icons/fleshcrafting_surgery_tools.dmi'

/obj/item/bonesetter/augment/vicissitude
	name = "bonesetting appendage"
	desc = "A pair of organic clamps for setting bones."
	icon_state = "bone setter_vic"
	inhand_icon_state = "clamps_vic"
	lefthand_file = 'modular_darkpack/modules/powers/icons/righthand.dmi'
	righthand_file = 'modular_darkpack/modules/powers/icons/lefthand.dmi'
	icon = 'modular_darkpack/modules/powers/icons/fleshcrafting_surgery_tools.dmi'

/obj/item/blood_filter/augment/vicissitude
	name = "filtering organ"
	desc = "A specialised set of organs capable of filtering blood non-harmfully."
	icon_state = "bone-gel_vic"
	inhand_icon_state = "clamps_vic"
	lefthand_file = 'modular_darkpack/modules/powers/icons/righthand.dmi'
	righthand_file = 'modular_darkpack/modules/powers/icons/lefthand.dmi'
	icon = 'modular_darkpack/modules/powers/icons/fleshcrafting_surgery_tools.dmi'

/obj/item/healthanalyzer/vicissitude
	name = "synaptic tendrils"
	desc = "A set of sensory tendrils that swiftly assess the health conditions of a patient"
	icon = 'icons/obj/medical/organs/organs.dmi'
	icon_state = "hivenode"
	scanpower = SCANPOWER_ADVANCED

/obj/item/shockpaddles/cyborg/vicissitude
	name = "electrocyte stack"
	desc = "A stack of electrocyte cells - they take too long to recharge for combat uses, but are able to produce powerful shocks."
	icon = 'modular_darkpack/modules/powers/icons/fleshcrafting_surgery_tools.dmi'
	icon_state = "shockpaddles0"
	inhand_icon_state = "syndiepaddles0"
	base_icon_state = "shockpaddles"
	req_defib = FALSE

/obj/item/shockpaddles/cyborg/vicissitude/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NEEDS_TWO_HANDS, "implant_requirement")
