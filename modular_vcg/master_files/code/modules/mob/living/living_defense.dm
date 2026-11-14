/mob/living/getarmor(def_zone, type)
	. = ..()
	var/inner_armor_rating = min(inner_armor?.get_rating(type) || 0, 100)
	if(!ISINRANGE(inner_armor_rating, 0, 100))
		return
	// math source: my ass
	var/worn_armor = 100 - (100 - .) / (1 - inner_armor_rating * 0.01)
	var/stronger = max(worn_armor, inner_armor_rating)
	var/weaker = min(worn_armor, inner_armor_rating)
	return stronger + (100 - stronger) * weaker * 0.01 * (weaker > 0 ? 0.5 : 1)
