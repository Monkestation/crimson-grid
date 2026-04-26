/obj/ritual_rune/thaumaturgy/curse
	name = "blood curse"
	desc = "Curse your enemies from afar. Place multiple hearts on the rune to increase the curse duration."
	icon_state = "rune7"
	word = "MAL'DICTO-SANGUINIS"
	level = 5
	sacrifices = list() //checking for number of hearts in the function
	var/channeling = FALSE
	var/mob/living/channeler = null
	var/curse_target = null

/obj/ritual_rune/thaumaturgy/curse/complete()
	. = ..()
	if(!activated)
		color = rgb(255,0,0)
		activated = TRUE

/obj/ritual_rune/thaumaturgy/curse/attack_hand(mob/user)
	if(!activated)
		var/mob/living/living_user = astype(user)
		if(!living_user || !living_user.get_discipline(/datum/discipline/thaumaturgy))
			return
		living_user.say(word)
		living_user.Immobilize(30)
		last_activator = user
		activator_bonus = living_user.thaum_damage_plus
		animate(src, color = rgb(255, 64, 64), time = 10)
		complete()
		addtimer(CALLBACK(src, PROC_REF(start_curse), user), 1 SECONDS)
		return

	// If already activated but not channeling, allow restarting
	if(!channeling && last_activator == user)
		start_curse(user)
		return

	// only the activator can use the activated rune
	if(last_activator != user)
		to_chat(user, span_warning("You are not the one who activated this rune!"))
		return

	// check if already channeling
	if(channeling)
		to_chat(user, span_warning("The curse is already being channeled!"))
		return

/obj/ritual_rune/thaumaturgy/curse/proc/start_curse(mob/user)
	if(!user || !activated || channeling)
		return

	// Count heart sacrifices
	var/list/hearts = list()
	for(var/obj/item/organ/heart/H in get_turf(src))
		hearts += H

	// at least one heart for the ritual
	if(hearts.len == 0)
		to_chat(user, span_warning("You need at least one heart to channel the curse!"))
		return

	// target name input
	var/target_name = tgui_input_text(user, "Choose target name:", "Curse Rune")
	if(!target_name || !user.Adjacent(src)) // Check if user is still nearby
		to_chat(user, span_warning("You must specify a target and remain close to the rune!"))
		return

	// begin channeling
	curse_target = target_name
	channeler = user
	channeling = TRUE

	// Begin the curse ritual
	to_chat(user, span_warning("You begin channeling dark energy through [hearts.len] heart[hearts.len > 1 ? "s" : ""]..."))
	channel_curse(hearts)
	do_after(hearts.len * 5)

/obj/ritual_rune/thaumaturgy/curse/proc/channel_curse(list/hearts)
	if(!channeling || !channeler || !curse_target)
		return

	if(!hearts.len)
		to_chat(channeler, span_warning("No more hearts remain for the ritual!"))
		channeling = FALSE
		qdel(src)
		return

	if(!channeler.Adjacent(src))
		to_chat(channeler, span_warning("The curse ritual has been interrupted because you moved away!"))
		channeling = FALSE
		return

	// Take the first heart
	var/obj/item/organ/heart/heart = hearts[1]
	if(!heart || QDELETED(heart) || heart.loc != get_turf(src))
		hearts -= heart
		if(hearts.len > 0)
			channel_curse(hearts) // Skip this heart and continue
		else
			to_chat(channeler, span_warning("The curse ritual has ended as no valid hearts remain!"))
			channeling = FALSE
			qdel(src)
		return

	hearts -= heart

	// Apply visual effects
	playsound(loc, 'modular_darkpack/modules/powers/sounds/thaum.ogg', 25, FALSE)
	animate(src, color = rgb(255, 0, 0), time = 1.5)
	animate(color = rgb(128, 0, 0), time = 1.5)

	// Find the target and apply damage
	var/found_target = FALSE
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.real_name == curse_target)
			found_target = TRUE
			H.adjust_agg_loss(25)
			playsound(H.loc, 'modular_darkpack/modules/powers/sounds/thaum.ogg', 50, FALSE)
			to_chat(H, span_warning("You feel dark energy tearing at your very being!"))
			H.Stun(2)
			break

	if(!found_target)
		to_chat(channeler, span_warning("There is no one by that name in the city!"))
		channeling = FALSE
		qdel(heart)
		return

	// Consume the heart
	qdel(heart)

	// Display feedback
	to_chat(channeler, span_warning("A heart is consumed by the ritual. [hearts.len] heart[hearts.len != 1 ? "s" : ""] remain[hearts.len != 1 ? "" : "s"]."))

	// If we still have hearts, continue the channel
	if(hearts.len > 0)
		// After 4 seconds, process the next heart
		channeler.visible_message(span_warning("[channeler.name] continues channeling dark energy into the rune!"))

		addtimer(CALLBACK(src, PROC_REF(channel_curse), hearts), 4 SECONDS)
	else
		// after using all hearts
		to_chat(channeler, span_warning("The last heart is consumed, completing the curse ritual!"))
		channeling = FALSE
		qdel(src)

