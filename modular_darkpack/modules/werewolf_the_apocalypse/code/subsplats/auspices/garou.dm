/datum/subsplat/werewolf/auspice/garou
	abstract_type = /datum/subsplat/werewolf/auspice/garou
	fera_restriction = SPLAT_GAROU


/datum/subsplat/werewolf/auspice/garou/ahroun
	name = AUSPICE_AHROUN
	desc = "The Ahroun is the archetype of the werewolf as murderous beast, though they range from unapologetic berserkers to hardened veterans tempering their Rage with discipline. Their high levels of Rage put them on the edge at all times - the Full Moon's blessing is a hair trigger, among other things. Those closer to the waxing moon tend to exult in the glory of the war, while those closer to the waning moon are more viciously pragmatic, ruthless in their bloodthirst. Every Ahroun is a dangerous individual to be around, but when the forces of the Wyrm attack, their packmates are glad to have a Full Moon warrior at the front of the charge."
	start_rage = 5
	gifts_provided= list(
		/datum/action/cooldown/power/gift/falling_touch,
		/datum/action/cooldown/power/gift/inspiration,
		/datum/action/cooldown/power/gift/razor_claws,
	)
	moons_born_under = list(MOON_FULL)

/datum/subsplat/werewolf/auspice/garou/ahroun/rank_requirments(list/renown)
	var/glory = renown[RENOWN_GLORY]
	var/honor = renown[RENOWN_HONOR]
	var/wisdom = renown[RENOWN_WISDOM]

	if(glory >= 10 && honor >= 9 && wisdom >= 4)
		return RANK_ELDER
	if(glory >= 9 && honor >= 4 && wisdom >= 2)
		return RANK_ATHRO
	if(glory >= 6 && honor >= 3 && wisdom >= 1)
		return RANK_ADREN
	if(glory >= 4 && honor >= 1 && wisdom >= 1)
		return RANK_FOSTERN
	if(glory >= 2 || honor >= 1)
		return RANK_CLIATH
	return RANK_CUB

/datum/subsplat/werewolf/auspice/garou/galliard
	name = AUSPICE_GALLIARD
	desc = "Where the Philodox is stoic, the Galliard is a creature of unbridled passion. The Gibbous Moon is a fiery muse, and stirs its children into great heights and depths of emotion. While all Galliards are prone to immense mirth and immense melancholy, those born under a waning moon fall more readily into dark, consuming passions; they are the tragedians of the Garou, mastering tales of doom, ruin, sacrifice and loss. Conversely, their waxing-moon cousins sing of triumph and conquest, of the pounding heart and the love of life. They tend to be the soul of their pack's morale - when the Galliard is willing to go on, so too are all the others."
	start_rage = 4
	gifts_provided = list(
		/datum/action/cooldown/power/gift/beast_speech,
		/datum/action/cooldown/power/gift/call_of_the_wyld,
		/datum/action/cooldown/power/gift/mindspeak
	)
	moons_born_under = list(MOON_WAXING_GIBBOUS, MOON_WANING_GIBBOUS)

/datum/subsplat/werewolf/auspice/garou/galliard/rank_requirments(list/renown)
	var/glory = renown[RENOWN_GLORY]
	var/honor = renown[RENOWN_HONOR]
	var/wisdom = renown[RENOWN_WISDOM]

	if(glory >= 9 && honor >= 5 && wisdom >= 9)
		return RANK_ELDER
	if(glory >= 7 && honor >= 2 && wisdom >= 6)
		return RANK_ATHRO
	if(glory >= 4 && honor >= 2 && wisdom >= 4)
		return RANK_ADREN
	if(glory >= 4 && wisdom >= 2)
		return RANK_FOSTERN
	if(glory >= 2 && wisdom >= 1)
		return RANK_CLIATH
	return RANK_CUB

/datum/subsplat/werewolf/auspice/garou/philodox
	name = AUSPICE_PHILODOX
	desc = "Buried so heavily in his role as impartial judge and jury, the Philodox may seem aloof, even surprisingly cold-blooded for a werewolf. Those born under the waxing Half Moon may seem unusually serene and disaffected, their emotions only emerging when their Rage comes to a boil. The waning-moon Philodox is more incisive and judgmental, his all-seeing eye always carefully watching his packmates and colleagues for any departure from the expected. The Half Moons' opinions are somewhat feared, yet highly respected - a word of praise or condemnation means much coming from those born to see both sides of every struggle."
	start_rage = 3
	gifts_provided= list(
		/datum/action/cooldown/power/gift/resist_pain,
		/datum/action/cooldown/power/gift/scent_of_the_true_form,
		/datum/action/cooldown/power/gift/truth_of_gaia,
	)
	moons_born_under = list(MOON_FIRST_QUARTER, MOON_LAST_QUARTER)

/datum/subsplat/werewolf/auspice/garou/philodox/rank_requirments(list/renown)
	var/glory = renown[RENOWN_GLORY]
	var/honor = renown[RENOWN_HONOR]
	var/wisdom = renown[RENOWN_WISDOM]

	if(glory >= 4 && honor >= 10 && wisdom >= 9)
		return RANK_ELDER
	if(glory >= 3 && honor >= 8 && wisdom >= 4)
		return RANK_ATHRO
	if(glory >= 2 && honor >= 6 && wisdom >= 2)
		return RANK_ADREN
	if(glory >= 1 && honor >= 4 && wisdom >= 1)
		return RANK_FOSTERN
	if(honor >= 3)
		return RANK_CLIATH
	return RANK_CUB


/datum/subsplat/werewolf/auspice/garou/theurge
	name = AUSPICE_THEURGE
	desc = "The Crescent Moons can be strange and enigmatic, prone to falling into the convoluted symbolic logic of the spirits they truck with rather than the more familiar logic of humanity. Those Theurges born under the waning moon frequently have a harsher, more adversarial relationship with the spirit world - they tend to excel at binding and forcing spirits to their will, and are more vicious when battling spirits. Theurges born under the waxing moon tend to be more generous and open with the spirits, charming and cajoling rather than intimidating and threatening."
	subsplat_traits = list(TRAIT_OPENS_MOONGATES)
	start_rage = 2
	gifts_provided = list(
		/datum/action/cooldown/power/gift/mothers_touch,
		/datum/action/cooldown/power/gift/sense_wyrm,
		/datum/action/cooldown/power/gift/spirit_speech
	)
	moons_born_under = list(MOON_WANING_CRESCENT, MOON_WAXING_CRESENT)

/datum/subsplat/werewolf/auspice/garou/theurge/rank_requirments(list/renown)
	var/glory = renown[RENOWN_GLORY]
	var/honor = renown[RENOWN_HONOR]
	var/wisdom = renown[RENOWN_WISDOM]

	if(glory >= 4 && honor >= 9 && wisdom >= 10)
		return RANK_ELDER
	if(glory >= 4 && honor >= 2 && wisdom >= 9)
		return RANK_ATHRO
	if(glory >= 2 && honor >= 1 && wisdom >= 7)
		return RANK_ADREN
	if(glory >= 1 && wisdom >= 5)
		return RANK_FOSTERN
	if(wisdom >= 3)
		return RANK_CLIATH
	return RANK_CUB


/datum/subsplat/werewolf/auspice/garou/ragabash
	name = AUSPICE_RAGABASH
	desc = "The Ragabash born under the waxing new moon is usually light-hearted and capricious, while one born under the waning new moon has a slightly more wicked and ruthless streak. It's a rare Ragabash indeed that lacks a keen wit and the capacity to find some humor in any situation, no matter how bleak. Many other werewolves are slow to take the Ragabash seriously, though, as it's difficult to tell the difference between a New Moon's mockery that points out a grievous flaw in a plan and similar mockery that simply amuses him. Sometimes a Ragabash points out that the emperor has no clothes - but sometimes they're the first to cry wolf, so to speak."
	start_rage = 1
	gifts_provided= list(
		/datum/action/cooldown/power/gift/blur_of_the_milky_eye,
		/datum/action/cooldown/power/gift/infectious_laughter,
		/datum/action/cooldown/power/gift/open_seal,
	)
	moons_born_under = list(MOON_NEW)

/datum/subsplat/werewolf/auspice/garou/ragabash/rank_requirments(list/renown)
	var/total_score = renown[RENOWN_GLORY] + renown[RENOWN_HONOR] + renown[RENOWN_WISDOM]

	if(total_score >= 25)
		return RANK_ELDER
	if(total_score >= 19)
		return RANK_ATHRO
	if(total_score >= 13)
		return RANK_ADREN
	if(total_score >= 7)
		return RANK_FOSTERN
	if(total_score >= 3)
		return RANK_CLIATH
	return RANK_CUB

/datum/subsplat/werewolf/auspice/garou/stolen_moon
	name = AUSPICE_NONE
	// DARKPACK TODO - WEREWOLF - (len lore)
	desc = "Your not a dog are you."
	// Stolen moon get no gifts
