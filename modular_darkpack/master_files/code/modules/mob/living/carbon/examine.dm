// extra fluff text for examines
/mob/proc/p_handsome_gorgeous(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	var/list/male_descriptors = list("handsome", "attractive", "conventionally attractive")
	var/list/female_descriptors = list("stunning", "gorgeous", "hot.", "beautiful", "pretty")
	var/list/other_descriptors = list("attractive, but you struggle to make out their gender", "hot... or, handsome? Attractive", "absolutely stunning", "confoundingly gorgeous", "beautiful")
	if(temp_gender == MALE)
		return pick(male_descriptors)
	if(temp_gender == FEMALE)
		return pick(female_descriptors)
	return pick(pick(other_descriptors), pick(male_descriptors), pick(female_descriptors)) // drank all the gender fluid

/mob/living/carbon/proc/display_darkpack_examine_text(mob/user)
	. = list()
	// WEREWOLF
	var/datum/splat/werewolf/werewolf_splat = get_werewolf_splat(user)
	if(werewolf_splat && !(obscured_slots & HIDEFACE))
		. += werewolf_splat.examine_other_human(src)
	// WEREWOLF

/mob/living/carbon/human/display_darkpack_examine_text(mob/user)
	. = ..()

	var/list/zero = list("Startlingly ugly. [p_are()] [p_they()] doing some awful cosplay...?", "JESUS, [p_they()] look like [p_they()] [p_are()] straight out of a horror movie!", "GOODNESS [p_they()] [p_are()] ugly.", "So ugly you could almost cry.")
	var/list/one = list("Yikes. [p_They()] [p_are()] not easy on the eyes.", "You wince slightly just looking at [p_them()].", "Someone clearly didn't win the genetic lottery.", "Definitely not winning any beauty contests.")
	var/list/two = list("Pretty average looking. Nothing to write home about.", "Neither here nor there in the looks department.", "Completely ordinary in appearance.", "The very definition of 'plain'.", "Not attractive, but not unattractive, either.")
	var/list/three = list("[p_They()] seem[p_s()] fairly attractive.", "A pleasant face, all things considered.", "Fairly attractive.", "[p_They()] [p_are()] [p_handsome_gorgeous()].")
	var/list/four = list("[p_They()] [p_are()] quite attractive.", "Easy on the eyes.", "Notably good looking.", "You find yourself staring at [p_them()].")
	var/list/five = list("[p_They()] [p_are()] very striking.", "[p_They()] [p_are()] [p_handsome_gorgeous()].", "Passersby struggle not to notice [p_them()].", "You find your eyes drawn to [p_them()].", "[p_They()] [p_are()] remarkably good looking.", "Heads turn as [p_they()] walk[p_s()] by.")
	if(obscured_slots & HIDEFACE)
		return

	switch(get_clan()?.alt_sprite)
		if("nosferatu")
			. += span_warning("[p_They()] look[p_s()] utterly deformed and inhuman!<br>")
		if("gargoyle")
			. += span_warning("[p_They()] seem[p_s()] to be made out of stone!<br>")
		if("kiasyd")
			if (!is_eyes_covered())
				. += span_boldwarning("[p_They()] [p_have()] no whites in [p_their()] eyes!</b><br>")
		if("rotten1")
			. += span_warning("[p_They()] seem[p_s()] oddly gaunt.<br>")
		if("rotten2")
			. += span_warning("[p_They()] [p_have()] a corpselike complexion.<br>")
		if("rotten3")
			. += span_boldwarning("[p_They()] [p_are()] a decayed corpse!<br>")
		if("rotten4")
			. += span_boldwarning("[p_They()] [p_are()] a skeletonised corpse!</b><br>")

	if(iszomboid(src) && !(obscured_slots & HIDEFACE)) // for necromancy player-controlled zombies
		. += span_danger("<b>[p_They()] [p_are()] a decayed corpse!</b><br>")

	if(HAS_TRAIT(src, TRAIT_SERPENTIS_SKIN) && !(HIDEJUMPSUIT)) // 'hidden by modest clothing'
		. += span_danger("[p_They()] [p_are()] covered in... scales!?<br>")

	if(HAS_TRAIT(src, TRAIT_ANIMAL_MUSK))
		. += span_warning("[p_they(TRUE)] smell[p_s()] weirdly animal like...<br>")

	if(!(obscured_slots & HIDEFACE))
		switch(st_get_stat(STAT_APPEARANCE))
			if(0)
				. += span_bolddanger("[pick(zero)]<br>")
			if(1)
				. += span_danger("[pick(one)]<br>")
			if(2)
				. += span_notice("[pick(two)]<br>")
			if(3)
				. += span_nicegreen("[pick(three)]<br>")
			if(4)
				. += span_purple("[pick(four)]<br>")
			if(5 to INFINITY)
				. += span_rose(span_bold("[pick(five)]<br>"))
		if(HAS_TRAIT(src, TRAIT_PERMAFANGS))
			. += span_warning("[p_They()] [p_have()] visible fangs in [p_their()] mouth.<br>")
