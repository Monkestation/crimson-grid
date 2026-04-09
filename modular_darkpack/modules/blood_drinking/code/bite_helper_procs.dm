//Wrapper function for adjusting a kindred/ghoul's blood pool
/mob/living/proc/adjust_blood_pool(amount, updating_health = TRUE, on_spawn)
	if(on_spawn)
		bloodpool = 0

	var/datum/splat/vampire/kindred/kindred_splat = get_kindred_splat(src)
	if(kindred_splat)
		var/hunger_threshold = 7 - (is_enlightenment() ? st_get_stat(STAT_INSTINCT) : st_get_stat(STAT_SELF_CONTROL))
		var/previous_hunger = HAS_TRAIT(src, TRAIT_NEEDS_BLOOD)
		var/will_be_hungry = (clamp(bloodpool + amount, 0, maxbloodpool) < hunger_threshold)

		if(!previous_hunger && will_be_hungry) // enter hunger
			ADD_TRAIT(src, TRAIT_NEEDS_BLOOD, TRAIT_GENERIC)
			to_chat(src, span_bolddanger("The Beast awakens as the pangs of hunger set in..."))

		else if(previous_hunger && !will_be_hungry) // leave hunger
			REMOVE_TRAIT(src, TRAIT_NEEDS_BLOOD, TRAIT_GENERIC)
			to_chat(src, span_notice("Your hunger is satisfied as the Beast inside retreats."))

		//DARKPACK TODO: roll for frenzy when hungry and seeing, smelling, tasting blood, maybe like the old system where you roll every once in a while. the roll is
		//self control 3 for seeing blood, 4 for smelling it, i think 6 for tasting it, all while hungry?
	bloodpool = clamp(bloodpool+amount, 0, maxbloodpool)
	if(updating_health)
		update_blood_hud()

/mob/living/proc/set_blood_pool(amount, updating_health = TRUE, on_spawn)
	amount = amount - bloodpool

	adjust_blood_pool(amount, updating_health, on_spawn)

//runs a bite animation for biting people and biting people and biting p
/mob/living/carbon/human/proc/add_bite_animation()
	remove_overlay(HALO_LAYER)
	var/mutable_appearance/bite_overlay = mutable_appearance('modular_darkpack/modules/deprecated/icons/icons.dmi', "bite", -HALO_LAYER)
	overlays_standing[HALO_LAYER] = bite_overlay
	apply_overlay(HALO_LAYER)
	addtimer(CALLBACK(src, PROC_REF(clear_bite_animation_overlay)), 1.5 SECONDS)

/mob/living/carbon/human/proc/clear_bite_animation_overlay()
	if(src)
		remove_overlay(HALO_LAYER)


//Here is where you handle any circumstantial modifiers to bloodpool gains
//VTR has a lot of these.
/mob/living/carbon/human/proc/calculate_drink_modifier(mob/living/drunk_from)
	var/drink_mod = 1
	if(HAS_TRAIT(src, TRAIT_HUNGRY))
		drink_mod *= 0.5
	if(HAS_TRAIT(src, TRAIT_EFFICIENT_DIGESTION))
		drink_mod *= 1.5

	return drink_mod

//Removes the circular suck bar that displays the amount of blood a victim has left.
/mob/living/carbon/human/proc/remove_drinking_overlay()
	stop_sound_channel(CHANNEL_BLOOD)
	COOLDOWN_RESET(src, drinkblood_use_cd)
	if(client)
		client.images -= suckbar
	QDEL_NULL(suckbar)
	return

//Updates the circular suck bar that displays the amount of blood a victim has left.
/mob/living/carbon/human/proc/update_drinking_overlay(mob/living/drunk_from)
	if(client)
		client.images -= suckbar
	QDEL_NULL(suckbar)
	suckbar_loc = drunk_from
	suckbar = image('modular_darkpack/modules/blood_drinking/icons/bloodcounter.dmi', suckbar_loc, "[round(14*(drunk_from.bloodpool/drunk_from.maxbloodpool))]", HUD_PLANE)
	suckbar.pixel_z = 40
	suckbar.plane = ABOVE_HUD_PLANE
	suckbar.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA

	if(client)
		client.images += suckbar
	var/sound/heartbeat = sound('modular_darkpack/modules/blood_drinking/sounds/drinkblood2.ogg', repeat = TRUE)
	playsound_local(src, heartbeat, 75, 0, channel = CHANNEL_BLOOD, use_reverb = FALSE)
