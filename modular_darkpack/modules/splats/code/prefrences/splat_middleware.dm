/// Handles the assets for splat icons
/datum/preference_middleware/splat

/datum/preference_middleware/splat/get_ui_assets()
	return list(
		get_asset_datum(/datum/asset/spritesheet/splat),
	)

/datum/asset/spritesheet/splat
	name = "splat"
	early = TRUE


/datum/asset/spritesheet/splat/create_spritesheets()
	var/list/to_insert = list()

	for (var/splat_id in get_selectable_splats())
		var/datum/splat/splat_type = GLOB.splat_list[splat_id]

		var/mob/living/carbon/human/dummy/consistent/dummy = new
		var/datum/splat/my_splat = dummy.add_splat(splat_type)
		dummy.equipOutfit(/datum/outfit, visuals_only = TRUE)
		my_splat.prepare_human_for_preview(dummy)

		var/icon/dummy_icon = getFlatIcon(dummy)
		dummy_icon.Scale(64, 64)
		dummy_icon.Crop(15, 64 - 31, 15 + 31, 64)
		dummy_icon.Scale(64, 64)
		to_insert[sanitize_css_class_name(initial(splat_type.name))] = dummy_icon

		SSatoms.prepare_deletion(dummy)

	var/icon/dummy_icon = icon('icons/hud/radial.dmi', "radial_center")
	dummy_icon.Scale(64, 64)
	to_insert[SPLAT_NONE] = dummy_icon

	for (var/spritesheet_key in to_insert)
		Insert(spritesheet_key, to_insert[spritesheet_key])

/datum/preference_middleware/splat/get_ui_static_data(mob/user)
	. = ..()

	var/list/names_to_key = list()
	for(var/datum/subsplat/vampire_clan/clan as anything in GLOB.vampire_clans)
		names_to_key[clan::name] = clan::id
	.["clan_names_to_key"] = names_to_key

