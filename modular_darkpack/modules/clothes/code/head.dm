//HATS

//HATS

//HATS

/obj/item/clothing/head/vampire
	icon = 'modular_darkpack/modules/clothes/icons/clothing.dmi'
	worn_icon = 'modular_darkpack/modules/clothes/icons/worn.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/clothes/icons/clothing_onfloor.dmi')
	armor_type = /datum/armor/vampire_hat

/datum/armor/vampire_hat
	melee = 10
	laser = 10
	energy = 10
	bomb = 10
	acid = 10
	wound = 10

/obj/item/clothing/head/vampire/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 5, "headwear", FALSE)

/obj/item/clothing/head/vampire/malkav
	name = "weirdo hat"
	desc = "Can look dangerous or sexy despite the circumstances. Provides some kind of protection."
	icon_state = "malkav_hat"
	armor_type = /datum/armor/malkavian_hat

/datum/armor/malkavian_hat
	melee = 25
	bullet = 25
	laser = 10
	energy = 10
	bomb = 10
	acid = 10
	wound = 10

/obj/item/clothing/head/vampire/bandana
	name = "brown bandana"
	desc = "A stylish bandana."
	icon_state = "bandana"

/obj/item/clothing/head/vampire/bandana/red
	name = "red bandana"
	icon_state = "bandana_red"

/obj/item/clothing/head/vampire/bandana/black
	name = "black bandana"
	icon_state = "bandana_black"

/obj/item/clothing/head/vampire/baseballcap
	name = "baseball cap"
	desc = "A soft hat with a rounded crown and a stiff bill projecting in front. Giants baseball, there's nothing like it!"
	icon_state = "baseballcap"

/obj/item/clothing/head/vampire/ushanka
	name = "ushanka"
	desc = "A heavy fur cap with ear-covering flaps."
	icon_state = "ushanka"

/obj/item/clothing/head/vampire/beanie
	name = "beanie"
	desc = "A stylish beanie."
	icon_state = "hat"

/obj/item/clothing/head/vampire/beanie/black
	name = "black beanie"
	icon_state = "hat_black"

/obj/item/clothing/head/vampire/beanie/homeless
	name = "raggedy beanie"
	icon_state = "hat_homeless"

/obj/item/clothing/head/vampire/wizard/blue
	name = "blue wizard hat"
	desc = "A watery-looking wizard hat."
	icon_state = "wizardhat_blue"

/obj/item/clothing/head/vampire/wizard/black
	name = "black wizard hat"
	desc = "A sinister-looking wizard hat."
	icon_state = "wizardhat_black"

/obj/item/clothing/head/vampire/wizard/darkred
	name = "dark red wizard hat"
	desc = "A zealous-looking wizard hat."
	icon_state = "wizardhat_darkred"

/obj/item/clothing/head/vampire/wizard/green
	name = "green wizard hat"
	desc = "An earthy looking wizard hat."
	icon_state = "wizardhat_green"

/obj/item/clothing/head/vampire/wizard/grey
	name = "grey wizard hat"
	desc = "A somber-looking wizard hat."
	icon_state = "wizardhat_grey"

/obj/item/clothing/head/vampire/wizard/purple
	name = "purple wizard hat"
	desc = "An elegant-looking wizard hat."
	icon_state = "wizardhat_purple"

/obj/item/clothing/head/vampire/wizard/red
	name = "red wizard hat"
	desc = "A furious-looking wizard hat."
	icon_state = "wizardhat_red"

/obj/item/clothing/head/vampire/wizard/white
	name = "white wizard hat"
	desc = "An angelic-looking wizard hat."
	icon_state = "wizardhat_white"

/obj/item/clothing/head/vampire/wizard/yellow
	name = "yellow wizard hat"
	desc = "A happy-looking wizard hat."
	icon_state = "wizardhat_yellow"

/obj/item/clothing/head/vampire/police
	name = "police hat"
	desc = "Can look dangerous or sexy despite the circumstances. Provides some kind of protection."
	icon_state = "law"
	armor_type = /datum/armor/armored_hat

/datum/armor/armored_hat
	melee = 20
	bullet = 20
	laser = 10
	energy = 10
	bomb = 10
	acid = 10
	wound = 10

/obj/item/clothing/head/vampire/cowboy
	name = "cowboy hat"
	desc = "Looks cool anyway. Provides some kind of protection."
	icon_state = "cowboy"
	armor_type = /datum/armor/armored_hat

/obj/item/clothing/head/vampire/cowboy/armorless
	name = "cowboy hat"
	desc = "Yee, and I do not often say this, haw."
	armor_type = /datum/armor/none

/obj/item/clothing/head/vampire/british
	name = "british police hat"
	desc = "Want some tea? Provides some kind of protection."
	icon_state = "briish"
	armor_type = /datum/armor/armored_hat

/obj/item/clothing/head/vampire/napoleon
	name = "french admiral hat"
	desc = "Dans mon esprit tout divague, je me perds dans tes yeux... Je me noie dans la vague de ton regard amoureux..."
	icon_state = "french"
	armor_type = /datum/armor/none

/obj/item/clothing/head/vampire/top
	name = "top hat"
	desc = "Want some tea? Provides some kind of protection."
	icon_state = "top"
	armor_type = /datum/armor/none

/obj/item/clothing/head/vampire/skull
	name = "skull helmet"
	desc = "Damn... Provides some kind of protection."
	icon_state = "skull"
	armor_type = /datum/armor/armored_hat

/obj/item/clothing/head/vampire/helmet
	name = "police helmet"
	desc = "Looks dangerous. Provides good protection."
	icon_state = "helmet"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR
	armor_type = /datum/armor/police_helmet
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	masquerade_violating = TRUE

/datum/armor/police_helmet
	melee = 40
	bullet = 40
	laser = 40
	energy = 40
	bomb = 20
	fire = 20
	acid = 40
	wound = 25

/obj/item/clothing/head/vampire/helmet/egorium
	name = "strange mask"
	desc = "Looks mysterious. Provides good protection."
	icon_state = "masque"
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	visor_flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	masquerade_violating = FALSE

/obj/item/clothing/head/vampire/helmet/spain
	name = "spain helmet"
	desc = "Concistador! Provides good protection."
	icon_state = "spain"
	flags_inv = HIDEEARS
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	masquerade_violating = FALSE

/obj/item/clothing/head/vampire/army
	name = "army helmet"
	desc = "Looks dangerous. Provides great protection against blunt force."
	icon_state = "viet"
	flags_inv = HIDEEARS|HIDEHAIR
	armor_type = /datum/armor/army_helmet
	masquerade_violating = TRUE

/datum/armor/army_helmet
	melee = 60
	bullet = 60
	laser = 60
	energy = 60
	bomb = 40
	fire = 20
	acid = 40
	wound = 25

/obj/item/clothing/head/vampire/hardhat
	name = "construction helmet"
	desc = "A thermoplastic hard helmet used to protect the head from injury."
	icon_state = "hardhat"
	armor_type = /datum/armor/construction_helmet
	custom_price = 50

/datum/armor/construction_helmet
	melee = 20
	bullet = 5
	bomb = 10
	fire = 5
	wound = 15

/obj/item/clothing/head/vampire/eod
	name = "EOD helmet"
	desc = "Looks dangerous. Provides best protection against nearly everything."
	icon_state = "bomb"
	armor_type = /datum/armor/eod_helmet
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR
	visor_flags_inv = HIDEFACE|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	w_class = WEIGHT_CLASS_BULKY
	masquerade_violating = TRUE

/datum/armor/eod_helmet
	melee = 70
	bullet = 70
	laser = 90
	energy = 90
	bomb = 100
	fire = 50
	acid = 90
	wound = 40

/obj/item/clothing/head/vampire/bogatyr
	name = "Bogatyr helmet"
	desc = "A regal helmet made of unknown materials."
	icon_state = "bogatyr_helmet"
	armor_type = /datum/armor/bogatyr_helmet
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR
	visor_flags_inv = HIDEFACE|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	w_class = WEIGHT_CLASS_BULKY

/datum/armor/bogatyr_helmet
	melee = 55
	bullet = 50
	laser = 60
	energy = 60
	bomb = 20
	fire = 40
	acid = 70
	wound = 30

/obj/item/clothing/head/vampire/bahari_mask
	name = "Dark mother's mask"
	desc = "When I first tasted the fruit of the Trees, \
			felt the seeds of Life and Knowledge burn within me, \
			I swore that day I would not turn back..."
	icon_state = "bahari_mask"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR

/obj/item/clothing/head/vampire/straw_hat
	name = "straw hat"
	desc = "A straw hat."
	icon_state = "strawhat"

/obj/item/clothing/head/vampire/hijab
	name = "hijab"
	desc = "A traditional headscarf worn by Muslim women."
	icon_state = "hijab"
	flags_inv = HIDEEARS|HIDEHAIR

/obj/item/clothing/head/vampire/taqiyah
	name = "taqiyah"
	desc = "A traditional hat worn by Muslim men."
	icon_state = "taqiyah"

/obj/item/clothing/head/vampire/noddist_mask
	name = "Noddist mask"
	desc = "Shine black the sun! Shine blood the moon! Gehenna is coming soon."
	icon_state = "noddist_mask"

/obj/item/clothing/head/vampire/kalimavkion
	name = "Kalimavkion"
	desc = "A traditional hat worn by Orthodox priests."
	icon_state = "kalimavkion"

/obj/item/clothing/head/vampire/prayer_veil
	name = "Prayer veil"
	desc = "A traditional veil."
	icon_state = "prayer_veil"
	flags_inv = HIDEEARS|HIDEHAIR

/obj/item/clothing/head/vampire/pentex_yellowhardhat
	name = "\improper " + MAIN_EVIL_COMPANY + " hardhat"
	desc = "A yellow hardhat. This one has an " + MAIN_EVIL_COMPANY + "  logo on it!"
	icon_state = "pentex_hardhat_yellow"
	flags_inv = HIDEHAIR

/obj/item/clothing/head/vampire/pentex_whitehardhat
	name = "\improper " + MAIN_EVIL_COMPANY + " hardhat"
	desc = "A white hardhat. This one has an " + MAIN_EVIL_COMPANY + " logo on it!"
	icon_state = "pentex_hardhat_white"
	flags_inv = HIDEHAIR

/obj/item/clothing/head/vampire/pentex_beret
	name = "First Team beret"
	desc = "A black beret with a mysterious golden insigna bearing a spiral."
	icon_state = "pentex_beret"
	flags_inv = HIDEHAIR

/obj/item/clothing/head/vampire/blackbag
	name = "black bag"
	desc = "Used by kidnappers, sadists, and three letter agencies. Easily fits over the head to obscure vision."
	icon_state = "black_bag"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR

	flash_protect = FLASH_PROTECTION_WELDER
	tint = 3

/obj/item/clothing/head/vampire/blackbag/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_HEAD)
		user.become_blind("blindfold_[REF(src)]")

/obj/item/clothing/head/vampire/blackbag/dropped(mob/living/carbon/human/user)
	. = ..()
	user.cure_blind("blindfold_[REF(src)]")

/obj/item/clothing/head/vampire/blackbag/attack(mob/living/target, mob/living/user)
	var/obj/item/clothing/head/H = target.get_item_by_slot(ITEM_SLOT_HEAD)
	if(H?.clothing_flags & SNUG_FIT)
		to_chat(user, span_warning("You can't fit the blackbag over [target.p_their()] headgear!"))
		return
	if(do_after(user, 0.5 SECONDS, target)) //Mainly to prevent black_bagging mid combat.
		target.visible_message(span_warning("[user] forces [src] onto [target]'s head!"))
		to_chat(target, span_bolddanger("[target] forces [src] onto your head!"))
		target.emote("scream")
		target.Stun(0.5 SECONDS)

		H = target.get_item_by_slot(ITEM_SLOT_HEAD) // Refetch it if it changes between do_after
		target.dropItemToGround(H)
		target.equip_to_slot_if_possible(src, ITEM_SLOT_HEAD)

/obj/item/clothing/head/beret/black
	name = "black beret"
	desc = "A black beret, perfect for war veterans and dark, brooding, anti-hero mimes."
	greyscale_colors = "#3f3c40"
