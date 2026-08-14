/datum/discipline_power/vicissitude/bonecrafting/post_gain()
	. = ..()
	var/datum/action/vicissitude/boneblade/blade_ability = new()
	blade_ability.Grant(owner)

/datum/discipline_power/vicissitude/bonecrafting/post_loss()
	. = ..()
	for(var/datum/action/action as anything in owner.actions)
		if(istype(action, /datum/action/vicissitude/boneblade))
			qdel(action)

/obj/item/melee/vamp/boneblade
	name = "bone blade"
	desc = "A horifying blade of flesh and blones repurposed from a arm"
	// placeholder icons
	icon = 'icons/obj/weapons/changeling_items.dmi'
	icon_state = "arm_blade"
	inhand_icon_state = "arm_blade"
	lefthand_file = 'icons/mob/inhands/antag/changeling_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/changeling_righthand.dmi'
	force = 1 LETHAL_TTRPG_DAMAGE
	sharpness = SHARP_EDGED
	wound_bonus = 10
	armour_penetration = 40
	item_flags = ABSTRACT | DROPDEL
	w_class = WEIGHT_CLASS_HUGE
	throwforce = 0
	throw_range = 0
	throw_speed = 0
	masquerade_violating = TRUE
	hitsound = 'sound/items/weapons/bladeslice.ogg'
	attack_verb_continuous  = list("slashes", "slices", "tears", "lacerates", "rips", "cuts")
	attack_verb_simple = list("slash", "slice", "tear", "lacerate", "rip", "cut")
	block_chance = 30

/obj/item/melee/vamp/boneblade/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, INNATE_TRAIT)
	if(ismob(loc))
		loc.visible_message(span_warning("A grotesque blade forms around [loc.name]\'s arm as it twists and rips!"), span_warning("Your twist your arm's bone and flesh, transforming it into a deadly blade."), span_hear("You hear bones and flesh ripping and tearing!"))
	AddComponent(/datum/component/alternative_sharpness, SHARP_POINTY, attack_verb_continuous, attack_verb_simple, -5)
	AddComponent(/datum/component/butchering, \
	speed = 6 SECONDS, \
	effectiveness = 80, \
	)
	var/mob/living/carbon/human/wielder = loc
	if(istype(wielder))
		stat_scale(wielder)

/obj/item/melee/vamp/boneblade/proc/stat_scale(mob/living/carbon/human/wielder)
	var/skill = wielder.st_get_stat(STAT_MEDICINE)
	force = (1 + skill * 0.25) LETHAL_TTRPG_DAMAGE  // 1 lethal at 0 medical to 2 lethal at 4 medical

/datum/action/vicissitude/boneblade
	name = "Bone Blade"
	desc = "Reform one of your arms into a bone blade, costs 2 blood points"
	// placeholder icons
	button_icon = 'icons/mob/actions/actions_changeling.dmi'
	button_icon_state = "arm_blade"
	check_flags = AB_CHECK_HANDS_BLOCKED | AB_CHECK_IMMOBILE | AB_CHECK_LYING | AB_CHECK_CONSCIOUS
	vampiric = TRUE

	var/weapon_type = /obj/item/melee/vamp/boneblade
	var/weapon_name_simple = "blade"
	var/blood_cost = 2

/datum/action/vicissitude/boneblade/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return

	var/mob/living/carbon/human/user = owner

	if(unequip_held(user))
		return

	if(user.bloodpool < blood_cost)
		to_chat(user, span_warning("You need more <b>BLOOD</b> to do that!"))
		return

	extrude(user)

// Removes weapon if it exists, returns true if we removed something
/datum/action/vicissitude/boneblade/proc/unequip_held(mob/user)
	for(var/obj/item/held in user.held_items)
		if(!istype(held, weapon_type))
			continue
		user.temporarilyRemoveItemFromInventory(held, TRUE) //DROPDEL will delete the item
		user.visible_message(
			span_warning("With a sickening fleshy sound, [user] reforms [user.p_their()] [weapon_name_simple] into an arm!"),
			span_notice("You reform the fleshy and bony [weapon_name_simple] back into a arm."),
			span_hear("You hear bones and flesh ripping and tearing!"),
		)
		playsound(user, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, FALSE)
		user.update_held_items()
		return TRUE
	return FALSE

/datum/action/vicissitude/boneblade/proc/extrude(mob/living/carbon/human/user)
	var/obj/item/held = user.get_active_held_item()
	if(held && !user.dropItemToGround(held))
		user.balloon_alert(user, "hand occupied!")
		return
	if (!user.has_active_hand())
		user.balloon_alert(user, "not a valid arm!")
		return
	var/obj/item/blade = new weapon_type(user)
	if(!user.put_in_hands(blade))
		qdel(blade)
		return

	user.adjust_blood_pool(-blood_cost)
	playsound(user, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, FALSE)
	SEND_SIGNAL(user, COMSIG_MASQUERADE_VIOLATION)
