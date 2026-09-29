/datum/changelog
	var/static/list/changelog_items = list()

/datum/changelog/ui_state()
	return GLOB.always_state

/datum/changelog/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "Changelog")
		ui.open()

// DARKPACK EDIT ADD START - SPLIT_CHANGELOG
/datum/changelog/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/server_logos),
	)
// DARKPACK EIDT ADD END

/datum/changelog/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(action == "get_month")
		var/datum/asset/changelog_item/changelog_item = changelog_items[params["date"]]
		if (!changelog_item)
			changelog_item = new /datum/asset/changelog_item(params["date"])
			changelog_items[params["date"]] = changelog_item
		return ui.send_asset(changelog_item)

/datum/changelog/ui_static_data()
	var/list/data = list( "dates" = list() )
	var/regex/ymlRegex = regex(@"\.yml", "g")

	// DARKPACK EDIT CHANGE START - SPLIT_CHANGELOG
	var/list/tg_files = flist("html/changelogs/archive/")
	var/list/darkpack_files = flist("html/changelogs/darkpack_archive/")
	var/list/crimson_files = flist("html/changelogs/crimson_archive/") // CRIMSON EDIT ADD - SPLIT_CHANGELOG

	// for(var/archive_file in sort_list(flist("html/changelogs/archive/")))
	for(var/archive_file in sort_list(tg_files |= darkpack_files |= crimson_files)) // CRIMSON EDIT CHANGE - SPLIT_CHANGELOG
		var/archive_date = ymlRegex.Replace(archive_file, "")
		data["dates"] = list(archive_date) + data["dates"]
	// DARKPACK EDIT CHANGE END

	return data


// DARKPACK EDIT ADD START - SPLIT_CHANGELOG
/datum/asset/simple/server_logos
	assets = list(
		"tg_16.png" = 'icons/ui/common/tg_16.png',
		"darkpack_16.png" = 'icons/ui/common/darkpack_16.png',
		"crimson_16.png" = 'icons/ui/common/cg_16.png', // CRIMSON EDIT ADD - SPLIT_CHANGELOG
	)
// DARKPACK EDIT ADD END
