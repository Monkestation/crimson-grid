/client
	var/datum/patreon_data/patreon
	var/datum/twitch_data/twitch

/client/proc/is_donator()
	if(patreon?.has_access(ACCESS_ASSISTANT_RANK))
		return TRUE
	if(twitch?.has_access(ACCESS_TWITCH_SUB_TIER_1))
		return TRUE
	return FALSE

/datum/preferences
	/// If our owner is patreon or twitch sub
	var/donator = FALSE

/datum/preferences/New(client/parent)
	max_save_slots = CONFIG_GET(number/max_save_slots)
	donator = parent?.is_donator()

	if(donator)
		max_save_slots += 10
	..()

/datum/preference/text/headshot/is_valid(value)
	var/patreon_link = CONFIG_GET(string/patreon_link)
	var/twitch_link = CONFIG_GET(string/twitch_link)
	if(!usr?.client?.is_donator())
		// split into multiple lines for easier reading
		var/notice = "This is a donator exclusive feature, your headshot link will be applied but others will only be able to view it if you are a " + \
			"[patreon_link ? "<a href='[patreon_link]'>": ""]Patreon supporter[patreon_link ? "</a>": ""] or " + \
			"[twitch_link ? "<a href='[twitch_link]'>": ""]Twitch subscriber[twitch_link ? "</a>": ""]."
		to_chat(usr, span_boldnotice(notice))
	. = ..()

/datum/examine_panel/ui_data(mob/user)
	. = ..()
	if(.["headshot"] && !(holder?.client?.is_donator()))
		.["headshot"] = null

