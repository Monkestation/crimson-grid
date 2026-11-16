/client
	/// Number of times this client has adminwho'd since the last logging cooldown
	var/awho_count_since = 0
	COOLDOWN_DECLARE(adminwho_alert_cooldown)
