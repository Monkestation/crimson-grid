/obj/item/melee/vamp
	lefthand_file = 'modular_darkpack/modules/deprecated/icons/lefthand.dmi'
	righthand_file = 'modular_darkpack/modules/deprecated/icons/righthand.dmi'
	worn_icon = 'modular_darkpack/modules/weapons/icons/worn_melee.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	custom_price = 1000


/obj/item/melee/vamp/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 75, "melee", FALSE)


/obj/item/fireaxe/vamp
	name = "fire axe"
	desc = "Truly, the weapon of a madman. Who would think to fight fire with an axe?"
	icon = 'modular_darkpack/modules/deprecated/icons/48x32.dmi'
	lefthand_file = 'modular_darkpack/modules/deprecated/icons/lefthand.dmi'
	righthand_file = 'modular_darkpack/modules/deprecated/icons/righthand.dmi'
	worn_icon = 'modular_darkpack/modules/weapons/icons/worn_melee.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_BELT // Should really be suit storage

	// WTA pg. 302
	force_unwielded = 2 TTRPG_DAMAGE // Made up lol.
	force_wielded = 3 LETHAL_TTRPG_DAMAGE
	attack_difficulty = 7

	pixel_w = -8
	custom_price = 1800

/obj/item/katana/vamp
	name = "katana"
	desc = "An elegant weapon, its tiny edge is capable of cutting through flesh and bone with ease."
	icon = 'modular_darkpack/modules/deprecated/icons/48x32.dmi'
	lefthand_file = 'modular_darkpack/modules/deprecated/icons/lefthand.dmi'
	righthand_file = 'modular_darkpack/modules/deprecated/icons/righthand.dmi'
	worn_icon = 'modular_darkpack/modules/weapons/icons/worn_melee.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')

	// WTA pg. 302
	force = 2 LETHAL_TTRPG_DAMAGE

	pixel_w = -8
	custom_price = 1300
	slot_flags = ITEM_SLOT_BELT

/obj/item/katana/vamp/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 100, "katana", FALSE)

/obj/item/katana/vamp/fire
	name = "burning katana"
	icon_state = "katana_burning"
	item_flags = DROPDEL
	obj_flags = NONE
	masquerade_violating = TRUE


//Do not sell the magically summoned katanas for infinite cash
/obj/item/katana/vamp/fire/Initialize(mapload)
	. = ..()
	var/datum/component/selling/sell_component = GetComponent(/datum/component/selling)
	if(sell_component)
		qdel(sell_component)


/obj/item/katana/vamp/fire/afterattack(atom/target, mob/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(isliving(target))
		var/mob/living/burnt_mob = target
		burnt_mob.apply_damage(15, BURN)

/obj/item/katana/vamp/blood
	name = "bloody katana"
	color = "#bb0000"
	item_flags = DROPDEL
	obj_flags = NONE
	masquerade_violating = TRUE

/obj/item/katana/vamp/blood/Initialize(mapload)
	. = ..()
	var/datum/component/selling/sell_component = GetComponent(/datum/component/selling)
	if(sell_component)
		qdel(sell_component)

/obj/item/katana/vamp/blood/afterattack(atom/target, mob/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(isliving(target))
		var/mob/living/burnt_mob = target
		burnt_mob.apply_damage(15, AGGRAVATED)

/obj/item/melee/sabre/vamp
	name = "sabre"
	desc = "A curved sword, the sabre is a weapon of the cavalry, designed for slashing and thrusting."
	icon = 'modular_darkpack/modules/weapons/icons/weapons.dmi'
	lefthand_file = 'modular_darkpack/modules/deprecated/icons/lefthand.dmi'
	righthand_file = 'modular_darkpack/modules/deprecated/icons/righthand.dmi'
	worn_icon = 'modular_darkpack/modules/weapons/icons/worn_melee.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	icon_state = "sabre"

	// WTA pg. 302
	force = 2 LETHAL_TTRPG_DAMAGE

	armour_penetration = 50	 //Normally 75 pen, that pens army armor. Instead, 50. Pens bullet proof.
	var/value = 1000 // DARKPACK TODO: Move this up at some point. I hate the selling component with all my heart.

/obj/item/melee/sabre/vamp/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, value, "sabre", FALSE)

/obj/item/melee/sabre/rapier
	name = "rapier"
	desc = "A thin, elegant sword, the rapier is a weapon of the duelist, designed for thrusting."
	icon = 'modular_darkpack/modules/weapons/icons/weapons.dmi'
	lefthand_file = 'modular_darkpack/modules/deprecated/icons/lefthand.dmi'
	righthand_file = 'modular_darkpack/modules/deprecated/icons/righthand.dmi'
	worn_icon = 'modular_darkpack/modules/weapons/icons/worn_melee.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	icon_state = "rapier"
	// WTA pg. 302
	force = 2 LETHAL_TTRPG_DAMAGE
	armour_penetration = 50

/obj/item/melee/sabre/rapier/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 700, "rapier", FALSE)

/obj/item/melee/sabre/vamp/training
	name = "foam sabre"
	force = 0
	value = 3

/obj/item/claymore/longsword
	name = "longsword"
	desc = "A classic weapon of the knight, the longsword is a versatile weapon that can be used for both cutting and thrusting."
	icon = 'modular_darkpack/modules/weapons/icons/weapons.dmi'
	lefthand_file = 'modular_darkpack/modules/deprecated/icons/lefthand.dmi'
	righthand_file = 'modular_darkpack/modules/deprecated/icons/righthand.dmi'
	worn_icon = 'modular_darkpack/modules/weapons/icons/worn_melee.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	icon_state = "longsword"
	inhand_icon_state = "longsword"
	// WTA pg. 302
	force = 2 LETHAL_TTRPG_DAMAGE


/obj/item/claymore/longsword/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 600, "longsword", FALSE)

/obj/item/claymore/machete
	name = "machete"
	desc = "A certified chopper fit for the jungles...but you don't see any vines around. Well-weighted enough to be thrown."
	icon = 'modular_darkpack/modules/weapons/icons/weapons.dmi'
	lefthand_file = 'modular_darkpack/modules/deprecated/icons/lefthand.dmi'
	righthand_file = 'modular_darkpack/modules/deprecated/icons/righthand.dmi'
	worn_icon = 'modular_darkpack/modules/weapons/icons/worn_melee.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	icon_state = "machete"
	inhand_icon_state = "machete"
	pixel_w = -8
	masquerade_violating = FALSE
	custom_price = 500
	force = 1 LETHAL_TTRPG_DAMAGE
	attack_difficulty = 5 // Slightly worse handling then a knife.
	block_chance = 0

/obj/item/claymore/machete/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 70, "machete", FALSE)

// "Keepers" derived from "my brother's keeper" are an epithet for Lasombra but this seems to be a wholly unqiue item not found in any book.
/obj/item/claymore/longsword/keeper
	name = "The Brother's Keeper"
	desc = "The ancient yet classic weapon of times gone, this is a longsword. This exemplar is surprisingly well taken care of, despite its age, to the point that whatever blood or vitae it may have drawn in the past is not visible at all, while still functioning as well as it first did however long ago. Upon the flat side of this blade, a simple well-worn inscription is engraved in Latin. 'In Death, I Rise.'"
	color = "#C0C0C0"
	w_class = WEIGHT_CLASS_BULKY
	force = 50
	block_chance = 45
	armour_penetration = 40
	attack_verb_continuous = list("slashes", "cuts")
	attack_verb_simple = list("slash", "cut")
	hitsound = 'sound/items/weapons/rapierhit.ogg'
	wound_bonus = 5


/obj/item/claymore/longsword/keeper/afterattack(atom/target, mob/user, list/modifiers, list/attack_modifiers)
	. = ..()
	fera_silver_damage(target, 5, 1)

/obj/item/melee/baseball_bat/vamp
	name = "baseball bat"
	desc = "There ain't a skull in the league that can withstand a swatter."
	w_class = WEIGHT_CLASS_BULKY	//TG parent bat is huge

	// WTA pg. 302
	force = 2 TTRPG_DAMAGE
	attack_difficulty = 5

	icon = 'modular_darkpack/modules/weapons/icons/weapons.dmi'
	lefthand_file = 'modular_darkpack/modules/deprecated/icons/lefthand.dmi'
	righthand_file = 'modular_darkpack/modules/deprecated/icons/righthand.dmi'
	worn_icon = 'modular_darkpack/modules/weapons/icons/worn_melee.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	icon_state = "baseball"
	inhand_icon_state = "baseball"
	worn_icon_state = "baseball"
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_BELT // Should really be suit storage
	custom_price = 50

/obj/item/melee/baseball_bat/vamp/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 20, "baseball", FALSE)

/obj/item/melee/baseball_bat/vamp/hand
	name = "ripped arm"
	desc = "Wow, that was someone's arm."
	icon_state = "hand"
	force = 1 TTRPG_DAMAGE
	attack_difficulty = 5
	masquerade_violating = TRUE
	//is_wood = FALSE

/obj/item/melee/vamp/tire
	name = "tire iron"
	desc = "Can be used as a tool or as a weapon."
	icon = 'modular_darkpack/modules/weapons/icons/weapons.dmi'
	icon_state = "pipe"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	force = 2 LETHAL_TTRPG_DAMAGE
	attack_verb_continuous = list("beats", "smacks")
	attack_verb_simple = list("beat", "smack")
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BELT
	resistance_flags = FIRE_PROOF
	obj_flags = CONDUCTS_ELECTRICITY

/obj/item/knife/vamp
	name = "knife"
	desc = "Don't cut yourself accidentally."
	icon = 'modular_darkpack/modules/weapons/icons/weapons.dmi'
	lefthand_file = 'modular_darkpack/modules/deprecated/icons/lefthand.dmi'
	righthand_file = 'modular_darkpack/modules/deprecated/icons/righthand.dmi'
	worn_icon = 'modular_darkpack/modules/weapons/icons/worn_melee.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	// WTA pg. 302
	force = 1 LETHAL_TTRPG_DAMAGE
	attack_difficulty = 4

	custom_price = 85

/obj/item/knife/vamp/lasombra_tentacle
	name = "shadow tentacle"
	force = 7
	armour_penetration = 100
	block_chance = 0
	icon_state = "lasombra"
	item_flags = DROPDEL
	masquerade_violating = TRUE
	obj_flags = NONE

/obj/item/knife/vamp/lasombra_tentacle/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, INNATE_TRAIT)

/obj/item/knife/vamp/lasombra_tentacle/afterattack(atom/target, mob/user, list/modifiers, list/attack_modifiers)
	if(isliving(target))
		var/mob/living/L = target
		L.apply_damage(16, AGGRAVATED)
		L.apply_damage(7, BURN)

/obj/item/melee/vamp/handsickle
	name = "hand sickle"
	desc = "Reap what they have sowed."
	icon = 'modular_darkpack/modules/weapons/icons/weapons.dmi'
	icon_state = "handsickle"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	force = 2 LETHAL_TTRPG_DAMAGE
	attack_verb_continuous = list("slashes", "cuts", "reaps")
	attack_verb_simple = list("slash", "cut", "reap")
	hitsound = 'sound/items/weapons/slash.ogg'
	sharpness = SHARP_EDGED
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BELT
	resistance_flags = FIRE_PROOF
	obj_flags = CONDUCTS_ELECTRICITY

/obj/item/melee/touch_attack/werewolf
	name = "falling touch"
	desc = "This is kind of like when you rub your feet on a shag rug so you can zap your friends, only a lot less safe."
	icon = 'modular_darkpack/modules/weapons/icons/weapons.dmi'
	//catchphrase = null
	//on_use_sound = 'sound/magic/disintegrate.ogg'
	icon_state = "falling"
	inhand_icon_state = "disintegrate"

/obj/item/melee/touch_attack/werewolf/afterattack(atom/target, mob/user, list/modifiers, list/attack_modifiers)
	if(isliving(target))
		var/mob/living/L = target
		L.AdjustKnockdown(4 SECONDS)
		L.adjust_stamina_loss(50)
		L.Immobilize(3 SECONDS)
		if(L.body_position != LYING_DOWN)
			L.toggle_resting()
	return ..()

/obj/item/chainsaw/vamp
	name = "chainsaw"
	desc = "A versatile power tool. Useful for limbing trees and delimbing humans."
	icon = 'modular_darkpack/modules/weapons/icons/weapons.dmi'
	lefthand_file = 'modular_darkpack/modules/deprecated/icons/lefthand.dmi'
	righthand_file = 'modular_darkpack/modules/deprecated/icons/righthand.dmi'
	worn_icon = 'modular_darkpack/modules/weapons/icons/worn_melee.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')

	// WTA pg. 302
	// force_on = 7 LETHAL_TTRPG_DAMAGE // Holy fuck thats what its listed as but it also hurts you on a botch..
	force_on = 6 LETHAL_TTRPG_DAMAGE
	force = 2 TTRPG_DAMAGE
	attack_difficulty = 8

	custom_price = 2000

/obj/item/shovel/vamp
	name = "shovel"
	desc = "Great weapon against mortal or immortal."
	icon = 'modular_darkpack/modules/weapons/icons/weapons.dmi'
	lefthand_file = 'modular_darkpack/modules/deprecated/icons/lefthand.dmi'
	righthand_file = 'modular_darkpack/modules/deprecated/icons/righthand.dmi'
	worn_icon = 'modular_darkpack/modules/weapons/icons/worn_melee.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	icon_state = "shovel"
	custom_price = 150
	force = 1 TTRPG_DAMAGE
	attack_difficulty = 5

/obj/item/shovel/vamp/attack(mob/living/target, mob/living/user)
	. = ..()
	if(prob(10))
		to_chat(user, span_warning("You smash [target] over the head with the shovel!"))
		target.visible_message(
			span_userdanger("You are smashed over the head by [user]!"),
			span_warning("You see stars!"),
			span_hear("You hear a dull THUNK!"))
		var/head_protection = target.run_armor_check(BODY_ZONE_HEAD, MELEE)
		target.apply_effect(5 SECONDS, EFFECT_KNOCKDOWN, head_protection)
		target.drop_all_held_items()

/obj/item/scythe/vamp
	name = "scythe"
	desc = "More instrument, than a weapon. Instrumentally cuts heads..."
	icon = 'modular_darkpack/modules/weapons/icons/weapons.dmi'
	lefthand_file = 'modular_darkpack/modules/deprecated/icons/lefthand.dmi'
	righthand_file = 'modular_darkpack/modules/deprecated/icons/righthand.dmi'
	worn_icon = 'modular_darkpack/modules/weapons/icons/worn_melee.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	icon_state = "kosa"
	inhand_icon_state = "kosa"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	// Made up
	force = 2 LETHAL_TTRPG_DAMAGE


/obj/item/instrument/eguitar/vamp
	name = "electric guitar"
	desc = "You are pretty fly for a white guy..."
	icon = 'modular_darkpack/modules/deprecated/icons/48x32.dmi'
	lefthand_file = 'modular_darkpack/modules/deprecated/icons/lefthand.dmi'
	righthand_file = 'modular_darkpack/modules/deprecated/icons/righthand.dmi'
	worn_icon = 'modular_darkpack/modules/weapons/icons/worn_melee.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_BELT
	icon_state = "rock0"
	inhand_icon_state = "rock0"
	// Made up
	force = 2 TTRPG_DAMAGE
	attack_difficulty = 7

/obj/item/melee/baton/vamp
	name = "police baton"
	desc = "Blunt instrument of justice."
	icon = 'modular_darkpack/modules/weapons/icons/weapons.dmi'
	icon_state = "baton"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 2)
	custom_price = 20

/obj/item/switchblade/vamp
	name = "switchblade"
	desc = "A spring-loaded knife. Perfect for stabbing sharks and jets."
	icon = 'modular_darkpack/modules/weapons/icons/weapons.dmi'
	lefthand_file = 'modular_darkpack/modules/deprecated/icons/lefthand.dmi'
	righthand_file = 'modular_darkpack/modules/deprecated/icons/righthand.dmi'
	worn_icon = 'modular_darkpack/modules/weapons/icons/worn_melee.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')

	// WTA pg. 302
	force = 1 LETHAL_TTRPG_DAMAGE
	attack_difficulty = 4

/obj/item/melee/vamp/brick
	name = "Brick"
	desc = "Killer of gods and men alike, builder of worlds vast."
	icon = 'modular_darkpack/modules/weapons/icons/weapons.dmi'
	icon_state = "red_brick"
	lefthand_file = 'modular_darkpack/modules/deprecated/icons/lefthand.dmi'
	righthand_file = 'modular_darkpack/modules/deprecated/icons/righthand.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')
	w_class = WEIGHT_CLASS_NORMAL

	// Made up
	force = 2 TTRPG_DAMAGE
	throwforce = 2 TTRPG_DAMAGE

	attack_verb_continuous = list("bludgeons", "bashes", "beats")
	attack_verb_simple = list("bludgeon", "bash", "beat", "smacks")
	hitsound = 'sound/items/weapons/genhit3.ogg'
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_SUITSTORE
	//grid_width = 2 GRID_BOXES
	//grid_height = 1 GRID_BOXES
	var/broken = FALSE

/obj/item/melee/vamp/brick/after_throw(datum/callback/callback)
	if(prob(75))
		broken = FALSE
	if(broken)
		w_class = WEIGHT_CLASS_SMALL
		force = 1 TTRPG_DAMAGE
		throwforce = 1 TTRPG_DAMAGE
		icon_state = "red_brick2"
		hitsound = 'sound/items/weapons/genhit1.ogg'
		//grid_width = 1 GRID_BOXES
		//grid_height = 1 GRID_BOXES

//this should be a subtype of spear in the future but we lack the sprites
/obj/item/darkpack/spear
	name = "spear"
	desc = "A staple of warfare through centuries, the spear is great for poking at things."
	icon = 'modular_darkpack/modules/weapons/icons/weapons.dmi'
	icon_state = "spear"
	lefthand_file = 'modular_darkpack/modules/weapons/icons/melee_lefthand.dmi'
	righthand_file = 'modular_darkpack/modules/weapons/icons/melee_righthand.dmi'
	worn_icon = 'modular_darkpack/modules/weapons/icons/worn_melee.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/weapons/icons/weapons_onfloor.dmi')

	// WTA pg. 302
	force = 3 LETHAL_TTRPG_DAMAGE
	attack_difficulty = 7
	/// Grrr this should be twohanded.

	sharpness = SHARP_POINTY
	attack_verb_continuous = list("stabs", "pokes")
	attack_verb_simple = list("stab", "poke")
	hitsound = 'sound/items/weapons/rapierhit.ogg'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	resistance_flags = FIRE_PROOF
	custom_price = 1200

/obj/item/darkpack/spear/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 400, "spear", FALSE)
