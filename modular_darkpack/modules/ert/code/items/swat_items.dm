/obj/item/storage/belt/police/swat
	name = "swat belt"
	desc = "Can hold SWAT gear like handcuffs."
	icon_state = "security"
	inhand_icon_state = "security"
	worn_icon_state = "security"
	content_overlays = TRUE
	storage_type = /datum/storage/security_belt

/obj/item/storage/belt/police/swat/full

/obj/item/storage/belt/police/swat/full/PopulateContents()
	new /obj/item/reagent_containers/spray/pepper(src)
	new /obj/item/restraints/handcuffs(src)
	new /obj/item/restraints/handcuffs(src)
	new /obj/item/melee/baton/vamp(src)

/obj/item/card/swat
	name = "dogtags"
	desc = "The dogtags of an elite law enforcement officer. It prints the officer's name in case they're captured or killed."
	icon = 'modular_darkpack/modules/ert/icons/badges.dmi'
	icon_state = "dogtags"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/ert/icons/badges_onfloor.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	worn_icon_state = "police_badge"

	shows_name = TRUE

/obj/item/card/lieutenant
	name = "elite officer badge"
	desc = "The shiny badge of an elite law enforcement officer. It shines with golden authority."
	icon = 'modular_darkpack/modules/ert/icons/badges.dmi'
	icon_state = "leader"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/ert/icons/badges_onfloor.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	worn_icon_state = "police_badge"

	shows_name = TRUE

/obj/item/card/first_aid
	name = "first aid officer card"
	desc = "The professional laminated card of a field medic. Did you know it's a war crime to specifically target field medics?"
	icon = 'modular_darkpack/modules/ert/icons/badges.dmi'
	icon_state = "first_aid"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/ert/icons/badges_onfloor.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	worn_icon_state = "grey_id"

	shows_name = TRUE

/obj/item/clothing/suit/vampire/darkpack_ert/swat_armor
	name = "\improper SWAT vest"
	desc = "Highly protective vest marked for SWAT usage. Make sure to throw the flashbang BEFORE you breach the room."
	icon_state = "swatvest"
	inhand_icon_state = null
	w_class = WEIGHT_CLASS_BULKY
	armor_type = /datum/armor/highly_protective_vest
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	clothing_traits = list(TRAIT_BRAWLING_KNOCKDOWN_BLOCKED)

/obj/item/clothing/suit/vampire/darkpack_ert/swat_armor/fbi
	name = "\improper FBI SWAT vest"
	icon_state = "fbivest"

/obj/item/clothing/head/vampire/darkpack_ert/swat_helmet
	name = "\improper SWAT Helmet"
	desc = "Modified SFPD helmet with improved performance. Isnt it great to be on the good side of police militarization?"
	icon_state = "swathelmet"
	armor_type = /datum/armor/army_helmet
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR
	visor_flags_inv = HIDEFACE|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF

/obj/item/clothing/head/vampire/darkpack_ert/swat_helmet/fbi
	name = "\improper FBI SWAT Helmet"
	icon_state = "fbihelmet"
