/obj/item/chainsaw/vamp
	force_on = 3 LETHAL_TTRPG_DAMAGE

/obj/item/knife/vamp
	throwforce = 1 LETHAL_TTRPG_DAMAGE
	embed_type = /datum/embedding/combat_knife/weak

/obj/item/claymore/machete
	force = 1.5 LETHAL_TTRPG_DAMAGE
	throwforce = 1 LETHAL_TTRPG_DAMAGE
	embed_type = /datum/embedding/combat_knife/weak

/obj/item/melee/vamp/tire
	force = 1 LETHAL_TTRPG_DAMAGE

/obj/item/fireaxe/vamp
	force_wielded = 2 LETHAL_TTRPG_DAMAGE
	block_chance = 15

/obj/item/darkpack/spear
	force = 2 LETHAL_TTRPG_DAMAGE
	reach = 2
	throwforce = 2 LETHAL_TTRPG_DAMAGE 	// WTA pg. 302
	throw_speed = 4
	embed_type = /datum/embedding/spear
	wound_bonus = 15

/obj/item/sheriffblade/vamp
	name = "sheriff's special"
	desc = "A sword that was brought by the Sheriff from parts unknown. An odd but efficient design to say the least."
	icon = 'modular_vcg/modules/weapons/icons/weapons64x32.dmi'
	icon_state = "sheriffblade0"
	base_icon_state = "sheriffblade"
	lefthand_file = 'modular_vcg/modules/weapons/icons/melee_lefthand.dmi'
	righthand_file = 'modular_vcg/modules/weapons/icons/melee_righthand.dmi'
	worn_icon = 'modular_vcg/modules/weapons/icons/worn_melee.dmi'
	ONFLOOR_ICON_HELPER('modular_vcg/modules/weapons/icons/weapons_onfloor.dmi')
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_BELT
	sharpness = SHARP_EDGED
	/// How much damage to do unwielded
	var/force_unwielded = 0
	/// How much damage to do wielded
	var/force_wielded = 0

	force_unwielded = 2 LETHAL_TTRPG_DAMAGE // Dual wield if u want smth good.
	force_wielded = 5 TTRPG_DAMAGE
	attack_difficulty = 7
	armour_penetration = 50 // Normally 75 pen, that pens army armor. Instead, 50. Pens bullet proof.
	w_class = WEIGHT_CLASS_BULKY
	block_chance = 45
	attack_verb_continuous = list("slashes", "cuts")
	attack_verb_simple = list("slash", "cut")
	hitsound = 'sound/items/weapons/rapierhit.ogg'
	wound_bonus = 5

	pixel_w = -8
	custom_price = 3750 // Sheriff's either dead or stupid.

/obj/item/sheriffblade/vamp/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=force_unwielded, force_wielded=force_wielded, icon_wielded="[base_icon_state]1")

/obj/item/fireaxe/update_icon_state()
	icon_state = "[base_icon_state]0"
	return ..()

/obj/item/fireaxe/vamp/battle
	name = "battle axe"
	desc = "For going medieval on someone. A beastly war axe with two heads!"
	icon = 'modular_vcg/modules/weapons/icons/weapons.dmi'
	icon_state = "battleaxe0"
	inhand_icon_state = null
	base_icon_state = "battleaxe"
	lefthand_file = 'modular_vcg/modules/weapons/icons/melee_lefthand.dmi'
	righthand_file = 'modular_vcg/modules/weapons/icons/melee_righthand.dmi'
	worn_icon = 'modular_vcg/modules/weapons/icons/worn_melee.dmi'
	ONFLOOR_ICON_HELPER('modular_vcg/modules/weapons/icons/weapons_onfloor.dmi')
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_BELT // Should really be suit storage
	w_class = WEIGHT_CLASS_BULKY
	// WTA pg. 302
	force_unwielded = 2 TTRPG_DAMAGE
	force_wielded = 2.5 LETHAL_TTRPG_DAMAGE
	block_chance = 10
	attack_speed = 9
	attack_difficulty = 7

	pixel_w = -8
	custom_price = 2250  // credit to Infared Baron for the sprite

//Crimson Grid Addition: A Brujah's Primogen Best Friend
/obj/item/melee/baseball_bat/vamp/lucille
	name = "Lucille"
	desc = "A sturdy baseball bat armed with barbed wire, nails, and it's somehow constantly dragging wind around it, as if rebellious forces feed it's swing."
	attack_verb_continuous = list("bludgeons", "bashes", "beats", "smacks", "destroys")
	attack_verb_simple = list("bludgeon", "bash", "beat", "smack", "destroy")
	w_class = WEIGHT_CLASS_BULKY	//TG parent bat is huge

	force = 3 TTRPG_DAMAGE
	attack_difficulty = 4 // Slightly better to swing with the winds guiding it
	wound_bonus = 2 // The rusted barbed wire really does SUCK to be hit with

	icon = 'modular_vcg/modules/weapons/icons/weapons.dmi'
	lefthand_file = 'modular_vcg/modules/weapons/icons/melee_lefthand.dmi'
	righthand_file = 'modular_vcg/modules/weapons/icons/melee_righthand.dmi'
	worn_icon = 'modular_vcg/modules/weapons/icons/worn_melee.dmi'
	ONFLOOR_ICON_HELPER('modular_vcg/modules/weapons/icons/weapons_onfloor.dmi')
	icon_state = "lucille"
	inhand_icon_state = "lucille"
	worn_icon_state = "lucille"
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_BELT
	var/knockback_min = 2
	var/knockback_max = 4
	var/knockback_speed = 3
	var/crater_chance = 60

/obj/item/melee/baseball_bat/vamp/lucille/attack(mob/living/target, mob/living/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(. || HAS_TRAIT(user, TRAIT_PACIFISM))
		return
	target.throwing?.finalize(hit = FALSE)
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	user.visible_message(
		span_danger("[user]'s swing with [src] sends [target] flying!"),
	)
	playsound(get_turf(src), 'modular_darkpack/modules/powers/sounds/heavypunch.ogg', 50, TRUE)
	target.throw_at(throw_target, rand(knockback_min, knockback_max), knockback_speed, user, gentle = TRUE, callback = CALLBACK(src, PROC_REF(wall_crater), target, user.dir))

/obj/item/melee/baseball_bat/vamp/lucille/attack_atom(atom/attacked_atom, mob/living/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(. || !istype(attacked_atom, /obj/darkpack_car))
		return
	var/obj/darkpack_car/car = attacked_atom
	var/atom/throw_target = get_edge_target_turf(car, user.dir)
	playsound(get_turf(car), 'modular_darkpack/modules/cars/sounds/bump.ogg', 100, FALSE)
	log_combat(user, car, "batted")
	car.throw_at(throw_target, rand(knockback_min, knockback_max), knockback_speed, user, gentle = TRUE, callback = CALLBACK(src, PROC_REF(wall_crater), car, user.dir))

/obj/item/melee/baseball_bat/vamp/lucille/proc/wall_crater(atom/movable/thrown, throw_dir)
	if(!get_step(thrown, throw_dir).density)
		return
	if(!prob(crater_chance))
		return
	new /obj/effect/temp_visual/dir_setting/crack_effect(get_turf(thrown))
	playsound(get_turf(thrown), 'modular_darkpack/modules/jumping/sounds/jump_slam.ogg', 40, FALSE)
	if(ismob(thrown))
		shake_camera(thrown, 4, 3)
