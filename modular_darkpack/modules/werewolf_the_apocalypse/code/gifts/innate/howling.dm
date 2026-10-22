/datum/action/cooldown/power/gift/howling
	name = "Howl"
	desc = "The werewolf may send her howl far beyond the normal range of hearing and communicate a single word or concept to all other Garou across the city."
	button_icon_state = "call_of_the_wyld"
	rage_cost = 1
	check_flags = null
	innate_ability = TRUE
	var/static/list/howls = list(
		"attack" = list(
			"menu" = "Attack",
			SPLAT_GAROU = "A wolf howls a fierce call to attack",
			SPLAT_CORAX = "A raven hisses a fierce call to attack"
		),
		"retreat" = list(
			"menu" = "Retreat",
			SPLAT_GAROU = "A wolf howls a warning to retreat",
			SPLAT_CORAX = "A raven squawks a warning to retreat"
		),
		"help" = list(
			"menu" = "Help",
			SPLAT_GAROU = "A wolf howls a desperate plea for help",
			SPLAT_CORAX = "A raven shrieks a a desperate plea for help"
		),
		"gather" = list(
			"menu" = "Gather",
			SPLAT_GAROU = "A wolf howls to gather the pack",
			SPLAT_CORAX = "A raven beckons the conspiracy"
		),
		"victory" = list(
			"menu" = "Victory",
			SPLAT_GAROU = "A wolf howls in celebration of victory",
			SPLAT_CORAX = "A raven croaks in celebration of victory"
		),
		"dying" = list(
			"menu" = "Dying",
			SPLAT_GAROU = "A wolf howls in pain and despair",
			SPLAT_CORAX = "A raven shrieks in pain and despair"
		),
		"mourning" = list(
			"menu" = "Mourning",
			SPLAT_GAROU = "A wolf howls in deep mourning for the fallen",
			SPLAT_CORAX = "A raven mourns the loss of the fallen"
		)
	)

/datum/action/cooldown/power/gift/howling/IsAvailable(feedback)
	. = ..()
	if(istype(get_area(owner), /area/vtm/interior/penumbra))
		if(feedback)
			to_chat(owner, span_warning("Your howl echoes and dissipates into the Umbra, it's sound blanketed by the spiritual energy of the Velvet Shadow."))
		return FALSE

/datum/action/cooldown/power/gift/howling/Activate(atom/target)
	. = ..()

	var/mob/living/living_mob = owner
	var/datum/splat/werewolf/shifter/shifter = get_shifter_splat(owner)
	var/list/menu_options = list()
	for(var/howl_key in howls)
		menu_options += howls[howl_key]["menu"]

	var/choice = tgui_input_list(owner, "Select a howl to use!", "Howl Selection", menu_options)
	if(!choice)
		return

	var/howl
	for(var/howl_key in howls)
		if(howls[howl_key]["menu"] == choice)
			howl = howls[howl_key]
			break

	var/garou_message = howl[shifter.id]
	// CRIMSON GRID CHANGES START - 447 - Allows howlers to be recognised if they are in Guestbook, and allow Galliards to identify Auspice and Tribe of howlers
	var/howler_subject = shifter.id == SPLAT_GAROU ? "A wolf" : "A raven" // select message type for howl recognition
	// CRIMSON GRID CHANGES PAUSE -- MORE TO FOLLOW - 447
	/*
	var/tribe = living_mob.auspice.tribe.name
	if (tribe)
		garou_message = replacetext(garou_message, "tribe", tribe)
	*/
	var/origin_turf = get_turf(living_mob)
	ADD_TRAIT(living_mob, TRAIT_LOUD_WARCRY, GIFT_TRAIT)
	living_mob.emote(shifter.warcry_emote)
	REMOVE_TRAIT(living_mob, TRAIT_LOUD_WARCRY, GIFT_TRAIT)

	var/howl_details
	var/final_message
	for(var/mob/living/howled_at in GLOB.player_list - owner)
		// CG CHANGES RESUME - 447 - Allows howlers to be recognised if they are in Guestbook, and allow Galliards to identify Auspice and Tribe of howlers
		var/datum/splat/werewolf/shifter/listener_splat = get_shifter_splat(howled_at) // get recipient's splat info
		if(listener_splat)
			var/howler_name = LAZYACCESS(howled_at.mind?.guestbook?.known_names, living_mob.real_name) // directly read names from Guestbook so known howlers don't become unknown when masked
			var/howler_message = garou_message // define this here so it isn't shared across the loop.
			var/is_stolen_moon = istype(shifter.auspice, /datum/subsplat/werewolf/auspice/garou/stolen_moon) // Stolen Moon needs special handling, may become redunant as they shouldn't be able to Howl.
			var/is_galliard = shifter.id == SPLAT_GAROU && istype(listener_splat.auspice, /datum/subsplat/werewolf/auspice/garou/galliard) // makes my head hurt less

			if(is_stolen_moon && is_galliard) // Galliards can see Stolen Moons sound weird, and don't have a listed tribe
				howler_message = replacetext(howler_message, "A wolf", "A strange, hollow wolf")
				if(howler_name)
					howler_message = replacetext(howler_message, "A strange, hollow wolf", "[howler_name], a strange, hollow wolf")

			if(is_galliard && !is_stolen_moon && shifter.tribe && shifter.auspice && shifter.auspice.name != AUSPICE_NONE) // Galliards can see howler tribe and auspice, even for unknown howlers. Stolen Moons will not literally be shown.
				var/howler_identity = "[shifter.auspice.name] of the [shifter.tribe.name]" // Galliards replace generic 'A wolf/raven' with Auspice / Tribe info and can see this for known howlers

				if(shifter.auspice.name == AUSPICE_AHROUN) // set article based on auspice, display name/auspice/tribe combo depending on if howler is known
					if(howler_name)
						howler_name = "[howler_name], an [howler_identity]"
					else
						howler_name = "An [howler_identity]"
				else
					if(howler_name)
						howler_name = "[howler_name], a [howler_identity]"
					else
						howler_name = "A [howler_identity]"

			if(!howler_name)
				howler_name = howler_subject // use generic howl text if howler is unknown
			howler_message = replacetext(howler_message, howler_subject, howler_name) // change text if howler IS known
			howl_details = get_message(howled_at, origin_turf)
			final_message = howler_message + howl_details
			// CG CHANGES END - 447 - Allows howlers to be recognised if they are in Guestbook, and allow Galliards to identify Auspice and Tribe of howlers
			to_chat(howled_at, span_boldnotice(final_message))


/datum/action/cooldown/power/gift/howling/proc/get_message(mob/living/howled_at, turf/origin_turf)
	var/distance = get_dist(howled_at, origin_turf)
	var/dirtext = " to the "
	var/direction = get_dir(howled_at, origin_turf)

	if(dir2text(direction))
		dirtext += dir2text(direction)
	else
		dirtext = " although I cannot make out an exact direction"

	var/disttext
	switch(distance)
		if(0 to 20)
			disttext = " within 20 feet"
		if(20 to 40)
			disttext = " 20 to 40 feet away"
		if(40 to 80)
			disttext = " 40 to 80 feet away"
		if(80 to 160)
			disttext = " far"
		else
			disttext = " very far"

	var/place = get_area_name(origin_turf)

	var/returntext = "[disttext],[dirtext], at [place]."

	return returntext
