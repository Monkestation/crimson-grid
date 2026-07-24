// useful proc to announce events as endposts
/proc/endpost_announce(body, author = EVIL_NEWS_COMPANY)
	UNTYPED_LIST_ADD(SSphones.endpost_posts, list(
		"body" = body,
		"date" = server_timestamp("Day, Month DD, "),
		"time" = server_timestamp("hh:mm", ic_time = TRUE),
		"author" = author,
		//"thumbsup_voters" = list(),
		//"thumbsdown_voters" = list(),
	))

	// I dont love this, idealy this should be sending code directly to a /datum/app/ or something and having that handle this behavoir as like a signal.
	for(var/obj/item/smartphone/listening_phone in GLOB.phones_list)
		listening_phone.receive_notification("EndPost", author, body)
