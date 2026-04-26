/mob/living
	has_emotion = TRUE

	//Damage related vars, NOTE: THESE SHOULD ONLY BE MODIFIED BY PROCS
	///Aggravated damage caused by supernatural attacks.
	var/aggloss = 0

	var/list/storyteller_stats = list() // STORYTELLER_STATS

	/// List of supernatural types that this mob is part of
	var/list/datum/splat/splats // SPLATS


	COOLDOWN_DECLARE(drinkblood_use_cd)
	COOLDOWN_DECLARE(drinkblood_click_cd)

	var/bloodpool = 5
	var/maxbloodpool = 5

	/// The quality of the mobs blood when drank from. Decides how much BP a vampire will regain.
	var/bloodquality = BLOOD_QUALITY_LOW

	COOLDOWN_DECLARE(masquerade_timer)
	var/masquerade_score = 5

	var/killed_count = 0
	var/warrant = FALSE
	var/ignores_warrant = FALSE

	var/discipline_time_plus = 0
	/// Multiplier for how efficently bloodpool is spent for BLOODPOWER SPECIFICLY
	var/blood_efficiency = 1
	var/thaum_damage_plus = 0
	var/frenzy_chance_boost = 10

	var/resistant_to_disciplines = FALSE

	// dogshit.
	var/dancing = FALSE

	//beastmaster
	var/list/beastmaster_minions = list()
	var/list/datum/component/obeys_commands/minion_command_components = list()

	var/tentacle_escape_attempt = 0
	var/tentacle_aggro_mode = "Aggressive"
	var/possessed = FALSE //dominate 5 body posession
	var/datum/weakref/conditioner // dominate 4
	//obfuscate icon, client side
	var/obf_icons

	//thaumaturgy & necro path stuff
	var/research_points = 0
	var/collected_souls = 0
