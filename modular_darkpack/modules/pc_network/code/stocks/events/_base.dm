/datum/stock_event
	/// PUBLIC headline.
	var/headline = ""
	/// PUBLIC article body.
	var/body = ""
	/// What is really going on. NEVER published; only shown to those who know. (in the future :3)
	var/whisper = ""
	var/list/effects = list()

/datum/stock_event/New(headline, body, whisper, list/effects)
	src.headline = headline
	src.body = body
	src.whisper = whisper
	src.effects = effects

/datum/stock_event/proc/is_big()
	for(var/sector in effects)
		if(abs(effects[sector]) >= STOCK_BIG_EVENT)
			return TRUE
	return FALSE
