/datum/job/vampire/red_news_reporter
	title = JOB_RED_NEWS_REPORTER
	description = "You are a reporter for the Pentex holding company owned brand RED news. You are responsible for reporting on the events of the city and keeping the public informed - or, as RED news also hosts many info-tainment broadcasts, host your own entertainment show. Either way, you have your own timeslot, better make the most of it!"
	faction = FACTION_PENTEX
	total_positions = 2
	spawn_positions = 2
	outfit = /datum/outfit/job/vampire/red_news_reporter
	exp_granted_type = EXP_TYPE_SPIRAL
	config_tag = "RED_NEWS_REPORTER"
	display_order = JOB_DISPLAY_ORDER_RED_NEWS_REPORTER
	departments_list = list(
		/datum/job_department/citizen
	)
	job_flags = CITY_JOB_FLAGS
	minimum_masquerade = 0
	alt_titles = list(
		"Red News Cameraman",
		"Red News Talking Head",
		"Red News Infomercial Salesperson",
		"Red News Entertainment Host",
		"Red News Late Night Talkshow Host"
	)
	disallowed_clans = list(VAMPIRE_CLAN_CAPPADOCIAN, VAMPIRE_CLAN_SAMEDI, VAMPIRE_CLAN_GARGOYLE, VAMPIRE_CLAN_KIASYD, VAMPIRE_CLAN_NOSFERATU)

	known_contacts = list(
		JOB_RED_NEWS_REPORTER
	)

/datum/outfit/job/vampire/red_news_reporter
	name = JOB_RED_NEWS_REPORTER
	jobtype = /datum/job/vampire/red_news_reporter
	l_pocket = /obj/item/smartphone/red_news
	backpack_contents = list(/obj/item/card/credit)
	uniform = /obj/item/clothing/under/vampire/suit
	l_hand = /obj/item/broadcast_camera
