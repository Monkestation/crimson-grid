/obj/item/occult_artifact/holy/crusader_sword
	name = "Old Sword"
	desc = "An old, rusty sword that seems to gleam in the light."
	true_name = "Crusader Sword"
	true_desc = "A mastercrafted sword emblazoned with a cross. Holy energy radiates from its blade, granting its faithful wielder strength and willpower. Activate it in hand to unleash the light of God."

	icon = 'modular_vcg/modules/leopold_artifacts/icons/relics.dmi'
	icon_state = "crusader_sword"
	inhand_icon_state = "crusader_sword"
	lefthand_file = 'modular_vcg/modules/leopold_artifacts/icons/relic_inhand_left.dmi'
	righthand_file = 'modular_vcg/modules/leopold_artifacts/icons/relic_inhand_right.dmi'
	worn_icon = 'modular_vcg/modules/leopold_artifacts/icons/relics_worn.dmi'
	worn_icon_state = "crusader_sword"
	ONFLOOR_ICON_HELPER('modular_vcg/modules/leopold_artifacts/icons/relic_floor.dmi')
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BELT
	sharpness = SHARP_EDGED
	hitsound = 'sound/items/weapons/slash.ogg'
	attack_verb_continuous = list("slashes", "cuts")
	attack_verb_simple = list("slash", "cut")
	research_value = 0

	// Inactive damage.
	force = 1 LETHAL_TTRPG_DAMAGE
	damtype = BRUTE

	// Declare each variable once.
	var/holy_abilities_active = FALSE
	var/mob/living/empowered_wielder
	COOLDOWN_DECLARE(holy_flash_timer)

/obj/item/occult_artifact/holy/crusader_sword/proc/remove_wielder_bonuses()
	if(empowered_wielder)
		empowered_wielder.st_remove_stat_mod(STAT_STRENGTH, src)
		empowered_wielder.st_remove_stat_mod(STAT_PERMANENT_WILLPOWER, src)

	empowered_wielder = null

/obj/item/occult_artifact/holy/crusader_sword/proc/set_holy_abilities(active, mob/living/wielder)
	remove_wielder_bonuses()

	holy_abilities_active = FALSE
	force = initial(force)
	damtype = initial(damtype)

	if(!active || !identified || !wielder?.mind?.holy_role)
		return

	if(!wielder.get_held_index_of_item(src))
		return

	holy_abilities_active = TRUE
	force = 2 LETHAL_TTRPG_DAMAGE
	damtype = AGGRAVATED

	empowered_wielder = wielder
	empowered_wielder.st_add_stat_mod(STAT_STRENGTH, 1, src)
	empowered_wielder.st_add_stat_mod(STAT_PERMANENT_WILLPOWER, 3, src)

/obj/item/occult_artifact/holy/crusader_sword/equipped(mob/user, slot, initial = FALSE)
	. = ..()

	if((slot & ITEM_SLOT_HANDS) && isliving(user))
		set_holy_abilities(TRUE, user)
	else
		set_holy_abilities(FALSE)

/obj/item/occult_artifact/holy/crusader_sword/dropped(mob/user, silent = FALSE)
	set_holy_abilities(FALSE)
	. = ..()

/obj/item/occult_artifact/holy/crusader_sword/Destroy()
	remove_wielder_bonuses()
	return ..()

/obj/item/occult_artifact/holy/crusader_sword/identify(mob/living/artifact_identifier)
	. = ..()

	// Identification may succeed while the sword is already in the holder's hand.
	if(!identified || !ismob(loc))
		return

	var/mob/holder = loc
	if(holder.get_held_index_of_item(src))
		set_holy_abilities(TRUE, holder)

/obj/item/occult_artifact/holy/crusader_sword/attack_self(mob/user, modifiers)
	if(!identified)
		return ..()

	if(!holy_abilities_active || !isliving(user))
		return

	if(!user.mind?.holy_role || empowered_wielder != user)
		return

	if(!user.get_held_index_of_item(src))
		return

	if(!COOLDOWN_FINISHED(src, holy_flash_timer))
		return

	COOLDOWN_START(src, holy_flash_timer, 60 SECONDS)

	do_sparks(rand(5, 9), FALSE, user)
	playsound(
		user.loc,
		'modular_darkpack/modules/jobs/sounds/cross.ogg',
		100, FALSE, 8, 0.9
	)

	for(var/mob/living/victim in get_hearers_in_view(4, src))
		holy_bang(victim, empowered_wielder)

/obj/item/occult_artifact/holy/crusader_sword/proc/holy_bang(mob/living/victim, mob/living/user)
	if(victim.stat == DEAD || victim == user || victim.mind?.holy_role)
		return

	victim.show_message(
		span_warning(span_bold("GOD'S WRATH IS COMING!")),
		MSG_AUDIBLE
	)

	if(HAS_TRAIT(victim, TRAIT_REPELLED_BY_HOLINESS))
		victim.emote("scream")
		victim.pointed(user)

	var/distance = max(1, get_dist(src, victim))
	victim.flash_act(affect_silicon = TRUE)
	victim.Paralyze(max(10 / distance, 5))
	victim.Knockdown(max(100 / distance, 40))
