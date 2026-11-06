// extra fluff text for examines
/mob/proc/p_handsome_gorgeous(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	var/list/male_descriptors = list("красив", "хорош собой", "по всем меркам привлекателен")
	var/list/female_descriptors = list("ослепительна", "великолепна", "чертовски хороша", "красива", "хороша собой")
	var/list/other_descriptors = list("привлекательны, хотя пол вам разобрать не удаётся", "чертовски хороши... или красивы? В общем, привлекательны", "просто ослепительны", "красивы до оторопи", "хороши собой")
	if(temp_gender == MALE)
		return pick(male_descriptors)
	if(temp_gender == FEMALE)
		return pick(female_descriptors)
	return pick(other_descriptors)

/mob/living/carbon/proc/display_darkpack_examine_text(mob/user)
	. = list()
	// WEREWOLF
	var/datum/splat/werewolf/werewolf_splat = get_werewolf_splat(user)
	if(werewolf_splat && !(obscured_slots & HIDEFACE))
		. += werewolf_splat.examine_other_human(src)
	// WEREWOLF

	// CORVAX EDIT START
	if(HAS_TRAIT(user, TRAIT_VENTRUE_SENSE) && get_dist(user, src) <= 1)
		var/ventrue_text = user.get_ventrue_blood_sense_text(src)
		if(ventrue_text)
			. += ventrue_text
	// CORVAX EDIT END

/mob/living/carbon/human/display_darkpack_examine_text(mob/user)
	. = ..()

	var/smell_range = 1 // range to smell someone in examine
	if(HAS_TRAIT(user, TRAIT_KEEN_NOSE)) // if they have acute sense smell
		smell_range += 2
	if (astype(user, /mob/living/carbon)?.dna.get_mutation(/datum/mutation/olfaction)) // auspex smell
		smell_range += 2

	var/list/zero = list("Поразительное уродство. Это что, какой-то жуткий косплей?..", genderize_decode(src, "ГОСПОДИ, да [ru_p_they()] будто из фильма ужасов сбежал%(*,а,о,и)%!"), genderize_decode(src, "БОЖЕ, до чего же [ru_p_they()] уродлив%(*,а,о,ы)%."), "Уродство такое, что хоть плачь.")
	var/list/one = list("Ох. Смотреть на [ru_p_theirs()] - то ещё удовольствие.", "Вы невольно морщитесь от одного взгляда на [ru_p_theirs()].", "Кому-то явно не повезло в генетической лотерее.", "На конкурсе красоты тут ловить нечего.")
	var/list/two = list("Внешность самая заурядная. Ничего примечательного.", "По части внешности - ни то ни сё.", "Совершенно обычная внешность.", "Просто образец невзрачности.", "Красотой не назовёшь, но и уродством тоже.")
	var/list/three = list(genderize_decode(src, "[ru_p_they(TRUE)] довольно привлекател%(ен,ьна,ьно,ьны)%."), "В общем-то, приятное лицо.", "Довольно привлекательная внешность.", "[ru_p_they(TRUE)] [p_handsome_gorgeous()].")
	var/list/four = list(genderize_decode(src, "[ru_p_they(TRUE)] весьма привлекател%(ен,ьна,ьно,ьны)%."), "Приятно посмотреть.", "Внешность заметно выше среднего.", "Вы ловите себя на том, что не сводите с [ru_p_theirs()] глаз.")
	var/list/five = list("У [ru_p_theirs()] очень яркая внешность.", "[ru_p_they(TRUE)] [p_handsome_gorgeous()].", "Прохожим трудно [ru_p_them()] не заметить.", "Взгляд сам собой цепляется за [ru_p_theirs()].", genderize_decode(src, "[ru_p_they(TRUE)] на редкость хорош%(*,а,о,и)% собой."), genderize_decode(src, "Когда [ru_p_they()] проход%(ит,ят)% мимо, люди оборачиваются."))
	if(obscured_slots & HIDEFACE)
		return

	if(HAS_TRAIT(src, TRAIT_MASQUERADE_VIOLATING_FACE) || HAS_TRAIT(src, TRAIT_MASQUERADE_VIOLATING_EYES))
		switch(get_clan()?.alt_sprite)
			if("nosferatu")
				. += span_warning("Уродливый, нечеловеческий облик!<br>")
			if("gargoyle")
				. += span_warning("Это тело словно высечено из камня!<br>")
			if("kiasyd")
				if (!is_eyes_covered())
					. += span_boldwarning("В [ru_p_them()] глазах совсем нет белков!</b><br>")
			if("rotten1")
				. += span_warning("Странная, нездоровая худоба.<br>")
			if("rotten2")
				. += span_warning("Цвет лица у [ru_p_theirs()] как у покойника.<br>")
			if("rotten3")
				. += span_boldwarning("Это же разложившийся труп!<br>")
			if("rotten4")
				. += span_boldwarning("Это же скелет, обтянутый остатками плоти!</b><br>")

	if(iszomboid(src) && !(obscured_slots & HIDEFACE)) // for necromancy player-controlled zombies
		. += span_danger("<b>Это же разложившийся труп!</b><br>")

	if(HAS_TRAIT(src, TRAIT_SERPENTIS_SKIN) && !(HIDEJUMPSUIT)) // 'hidden by modest clothing'
		. += span_danger("[ru_p_them(TRUE)] тело покрыто... чешуёй?!<br>")

	if(get_dist(user, src) <= smell_range)
		if(HAS_TRAIT(src, TRAIT_ANIMAL_MUSK))
			. += span_warning("От [ru_p_theirs()] странно пахнет зверем...<br>")
		if(HAS_TRAIT(src, TRAIT_GRAVE_SMELL))
			. += span_warning("От [ru_p_theirs()] пахнет дождём и свежевскопанной землёй.<br>")

	if(HAS_TRAIT(src, TRAIT_BEACON_OF_THE_UNHOLY))
		if(isliving(user))
			var/mob/living/living_user = user
			if(living_user.mind.holy_role)
				. += span_cult("От [ru_p_theirs()] исходит осязаемое зло! С этим существом что-то очень не так!")

	if((!is_eyes_covered()) && HAS_TRAIT(src, TRAIT_GLOWING_EYES))
		. += span_warning("[ru_p_them(TRUE)] глаза неестественно светятся!<br>")

	if((!is_eyes_covered()) && HAS_TRAIT(src, TRAIT_REFLECTIVE_EYES))
		. += span_warning("[ru_p_them(TRUE)] глаза неестественно блестят!<br>")

	if((!is_eyes_covered()) && HAS_TRAIT(src, TRAIT_ABYSSAL_EYES))
		. += span_warning("[ru_p_them(TRUE)] глаза залиты чернильной тьмой!<br>")

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
		if(HAS_TRAIT(src, TRAIT_PERMAFANGS) && !HAS_TRAIT(src, TRAIT_DULLFANGS))
			. += span_warning("У [ru_p_theirs()] во рту видны клыки.<br>")
		if(HAS_TRAIT(src, TRAIT_DISFIGURED_APPEARANCE))
			. += span_warning("[ru_p_them(TRUE)] внешность заметно обезображена.<br>")
	if(!src.head)
		if(HAS_TRAIT(src, TRAIT_THIRD_EYE))
			. += span_bolddanger("У [ru_p_theirs()] на лбу третий глаз!<br>")
		if(HAS_TRAIT(src, TRAIT_BETRAYERS_MARK))
			if(isliving(user))
				var/mob/living/living_user = user
				if(living_user.is_clan(/datum/subsplat/vampire_clan/tremere))
					. += span_bolddanger("У [ru_p_theirs()] на лбу светится буква \"T\" - клеймо предателя клана Тремер!<br>")
