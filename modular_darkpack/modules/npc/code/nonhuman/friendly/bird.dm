// DARKPACK TODO - CORAX - (Corax kinfolk and thus should be grouped into WTA soon.)
/mob/living/basic/corvid
	name = "corvid"
	desc = "Caw."
	abstract_type = /mob/living/basic/corvid
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	icon_state = "black"
	icon_living = "black"
	icon_dead = "black"
	icon = 'modular_darkpack/modules/werewolf_the_apocalypse/icons/corax_forms/corvid.dmi'
	density = FALSE
	butcher_results = list(/obj/item/food/meat/slab/chicken = 1)
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "pecks"
	response_harm_simple = "peck"
	attack_verb_continuous = "pecks"
	attack_verb_simple = "peck"
	friendly_verb_continuous = "headbutts"
	friendly_verb_simple = "headbutt"
	verb_say = "caws"
	verb_exclaim = "squawks"
	verb_yell = "shrieks"
	speak_emote = list("caws")
	health = 20
	maxHealth = 20
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_SMALL
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	gold_core_spawnable = FRIENDLY_SPAWN
	basic_mob_flags = FLIP_ON_DEATH

	ai_controller = /datum/ai_controller/basic_controller/corvid

	var/sprite_color = "black"
	var/sprite_eye_color = "#FFFFFF"

/mob/living/basic/corvid/Initialize(mapload)
	. = ..()
	add_verb(src, /mob/living/proc/toggle_resting)
	var/datum/action/innate/togglecorvidflight/toggleflight = new()
	toggleflight.Grant(src)
	AddElement(/datum/element/ai_retaliate)
	AddElement(/datum/element/pet_bonus, "caw")
	AddElement(/datum/element/footstep, FOOTSTEP_MOB_CLAW)
	update_appearance(UPDATE_ICON)

/mob/living/basic/corvid/update_icon_state()
	. = ..()
	if(stat == DEAD)
		return
	if(HAS_TRAIT(src, TRAIT_MOVE_FLYING))
		icon_state = "[sprite_color]_flying"
	else if(resting)
		icon_state = "[sprite_color]_rest"
	else
		icon_state = "[sprite_color]"

/mob/living/basic/corvid/update_overlays()
	. = ..()

	var/mutable_appearance/eyes_overlay = mutable_appearance(icon, "eyes[HAS_TRAIT(src, TRAIT_MOVE_FLYING) ? "_flying" : ""]")
	SET_PLANE(eyes_overlay, ABOVE_LIGHTING_PLANE, src)
	eyes_overlay.color = sprite_eye_color
	// eyes_overlay.layer = ABOVE_LIGHTING_LAYER
	. += eyes_overlay

/datum/action/innate/togglecorvidflight // this action handles corvid forms toggle their flight, and swaps their sprite to be of the relevant type, I'm making it a gift because it's also what Hispo is under
	name = "Toggle Flight"
	desc = "Unfurl or withdraw your wings, toggling your ability to fly"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_IMMOBILE
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "flight"

/datum/action/innate/togglecorvidflight/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return

	var/mob/living/basic/corvid/corvid = owner
	if(!istype(corvid))
		return
	// Consider giving them instant do after for moving up and down z levels but require time to get into the air
	// if(!do_after(src, 0.5 SECONDS, timed_action_flags = IGNORE_USER_LOC_CHANGE))
	// 	return
	if (!(HAS_TRAIT(corvid, TRAIT_MOVE_FLYING)))
		to_chat(corvid, span_notice("You beat your wings and begin to hover gently above the ground..."))
		corvid.set_resting(FALSE, TRUE)
		// sadly, "is flying animal" does not give us flying traits when life() is called, only during VV or upon Init. We're doing this the hard way.
		// the corax sprites already animate up-and-down bobbing, no need to float
		corvid.add_traits(list(TRAIT_MOVE_FLYING, TRAIT_NO_FLOATING_ANIM), ACTION_TRAIT)
		// we set this while we wait for the icons to update, otherwise there is latency
	else
		to_chat(corvid, span_notice("You settle gently back onto the ground..."))
		corvid.remove_traits(list(TRAIT_MOVE_FLYING, TRAIT_NO_FLOATING_ANIM), ACTION_TRAIT)

	corvid.update_icon(UPDATE_ICON)

/datum/emote/corvid
	mob_type_allowed_typecache = /mob/living/basic/corvid
	mob_type_blacklist_typecache = list()

/datum/emote/corvid/caw
	key = "caw"
	key_third_person = "caws"
	message = "caws!"
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE
	vary = TRUE
	// DARKPACK TODO - CORAX - (Move to wta folder)
	sound = 'modular_darkpack/modules/npc/sound/caw.ogg'

/mob/living/basic/corvid/crow
	name = "crow"
	desc = "Unlike a raven, it has a fan shaped tail."

/mob/living/basic/corvid/raven
	name = "raven"
	desc = "Unlike a crow, it has a wedge shaped tail."
	verb_say = "gronks"
	speak_emote = list("gronks")

/mob/living/basic/corvid/raven/Initialize(mapload)
	. = ..()
	update_transform(1.2)
