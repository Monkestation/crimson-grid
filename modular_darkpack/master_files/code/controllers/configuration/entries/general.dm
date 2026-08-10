/datum/config_entry/string/wikiurl
	default = ""

/datum/config_entry/string/forumurl
	default = "https://discord.gg/2EYyEnuBcW"

/datum/config_entry/string/rulesurl
	default = ""

/datum/config_entry/string/githuburl
	default = "https://github.com/DarkPack13/SecondCity"

// We have an upstream where we can be pretty confident often that its there instead. Makes it easier to report.
/datum/config_entry/str_list/extra_issue_urls // Not an existing override, bite me.
	default = list("https://github.com/DarkPack13/SecondCity")
	dupes_allowed = FALSE

/datum/config_entry/flag/disable_ghost_looc
	default = TRUE
