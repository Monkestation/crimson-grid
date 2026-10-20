/obj/item/clothing/mask/gas/vampire
	name = "respirator"
	desc = "A face-covering mask that can be connected to an air supply. While good for concealing your identity, it isn't good for blocking gas flow." //More accurate
	icon_state = "respirator"
	clothing_flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	flags_inv = HIDEFACE | HIDEFACIALHAIR|HIDESNOUT
	icon = 'modular_darkpack/modules/clothes/icons/clothing.dmi'
	worn_icon = 'modular_darkpack/modules/clothes/icons/worn.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/clothes/icons/clothing_onfloor.dmi')
	inhand_icon_state = ""
	w_class = WEIGHT_CLASS_NORMAL
	flags_cover = MASKCOVERSMOUTH | PEPPERPROOF
	resistance_flags = NONE
	custom_price = 30

/obj/item/clothing/mask/vampire
	// This USED to be the default resperatior for wod13 moved that to /obj/item/clothing/mask/gas/vampire
	abstract_type = /obj/item/clothing/mask/vampire
	flags_inv = HIDEFACE | HIDEFACIALHAIR | HIDESNOUT
	icon = 'modular_darkpack/modules/clothes/icons/clothing.dmi'
	worn_icon = 'modular_darkpack/modules/clothes/icons/worn.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/clothes/icons/clothing_onfloor.dmi')
	inhand_icon_state = ""
	w_class = WEIGHT_CLASS_NORMAL
	flags_cover = MASKCOVERSMOUTH
	resistance_flags = NONE

/obj/item/clothing/mask/vampire/Initialize(mapload)
	.=..()
	AddComponent(/datum/component/selling, 15, "mask", FALSE)

/obj/item/clothing/mask/vampire/balaclava
	name = "balaclava"
	desc = "LOADSAMONEY"
	icon_state = "balaclava"
	inhand_icon_state = "balaclava"
	flags_inv = HIDEFACE | HIDEHAIR | HIDEFACIALHAIR | HIDESNOUT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/clothing/mask/vampire/pentex_balaclava
	name = "Thick balaclava"
	desc = "A black balaclava. This one is particularly thick."
	icon_state = "pentex_balaclava"
	flags_inv = HIDEFACE | HIDEHAIR | HIDEFACIALHAIR | HIDESNOUT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/clothing/mask/vampire/tragedy
	name = "tragedy"
	desc = "The Greek Tragedy mask."
	icon_state = "tragedy"
	flags_inv = HIDEFACE | HIDEFACIALHAIR | HIDESNOUT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/clothing/mask/vampire/comedy
	name = "comedy"
	desc = "The Greek Comedy mask."
	icon_state = "comedy"
	flags_inv = HIDEFACE | HIDEFACIALHAIR | HIDESNOUT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/clothing/mask/vampire/shemagh
	name = "shemagh"
	desc = "Covers your face pretty well."
	icon_state = "shemagh"
	flags_inv = HIDEFACE | HIDEHAIR | HIDEFACIALHAIR | HIDESNOUT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/clothing/mask/vampire/venetian_mask
	name = "Venetian mask"
	desc = "You could wear this to a real masquerade."
	icon_state = "venetian_mask"
	flags_inv = HIDEFACE | HIDEFACIALHAIR | HIDESNOUT
	flags_cover = MASKCOVERSMOUTH

/obj/item/clothing/mask/vampire/venetian_mask/fancy
	name = "fancy Venetian mask"
	desc = "Weird rich people definitely wear this kind of stuff."
	icon_state = "venetian_mask_fancy"

/obj/item/clothing/mask/vampire/venetian_mask/jester
	name = "jester mask"
	desc = "They will all be amused, every last one of them."
	icon_state = "venetian_mask_jester"

/obj/item/clothing/mask/vampire/venetian_mask/scary
	name = "bloody mask"
	desc = "With this, you'll look ready to butcher someone."
	icon_state = "venetian_mask_scary"
	flags_inv = HIDEFACE
	flags_cover = NONE

/obj/item/clothing/mask/vampire/fomori_chaser
	name = "scary mask"
	desc = "Do you like scary movies?"
	icon_state = "chaser"

//Bandanas use TG sprites except the inventory icon sprite, we use Flav's for that.
/obj/item/clothing/mask/bandana/vampire
	desc = "A bandana, perfect for covering your face, neck, or head!"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/clothes/icons/clothing_onfloor.dmi')
	greyscale_config_onfloor = /datum/greyscale_config/bandana/onfloor/vampire

/obj/item/clothing/mask/bandana/striped/vampire
	desc = "A striped bandana, perfect for covering your face, neck, or head!"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/clothes/icons/clothing_onfloor.dmi')
	greyscale_config_onfloor = /datum/greyscale_config/bandana/striped/onfloor/vampire

/obj/item/clothing/mask/bandana/skull/vampire
	desc = "A skull bandana, perfect for covering your face, neck, or head!"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/clothes/icons/clothing_onfloor.dmi')
	greyscale_config_onfloor = /datum/greyscale_config/bandana/skull/onfloor/vampire

/obj/item/clothing/mask/facescarf/vampire
	desc = "A heavy face scarf, perfect to keep your neck and face warm, or to cover your identity.."
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/clothes/icons/clothing_onfloor.dmi')
	greyscale_config_onfloor = /datum/greyscale_config/facescarf/onfloor/vampire
