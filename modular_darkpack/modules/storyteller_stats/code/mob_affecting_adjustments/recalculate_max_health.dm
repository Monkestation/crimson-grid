//Function for updating a player's health based on their current stats.
/mob/living/proc/recalculate_max_health(initial = FALSE)
	var/old_max_health = maxHealth
	maxHealth = round(initial(maxHealth) + ((initial(maxHealth)/8) * st_get_stat(STAT_STAMINA)))
	if(HAS_TRAIT(src, TRAIT_HUGE_SIZE)) // CG addition to fix fera transformations not accounting for Huge Size flat HP bonus.
		maxHealth += 20
	if(initial)
		health = maxHealth
	else if(health > 0)
		health = max(health + maxHealth - old_max_health, 1)
