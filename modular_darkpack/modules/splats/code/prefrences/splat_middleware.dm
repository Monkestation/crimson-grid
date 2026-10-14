/// Handles the assets for splat icons
/datum/preference_middleware/splat

/datum/preference_middleware/splat/get_ui_assets()
	return list(
		get_asset_datum(/datum/asset/spritesheet_batched/splat),
	)

/datum/asset/spritesheet_batched/splat
	name = "splat"

/datum/asset/spritesheet_batched/splat/create_spritesheets()
	var/list/to_insert = list()

	var/mob/living/carbon/human/dummy/consistent/dummy = new
	for (var/splat_id in get_selectable_splats())
		var/datum/splat/splat_type = GLOB.splat_list[splat_id]

		var/datum/splat/my_splat = dummy.add_splat(splat_type)
		dummy.equipOutfit(/datum/outfit, visuals_only = TRUE)
		my_splat.prepare_human_for_preview(dummy)

		var/datum/universal_icon/dummy_icon = get_flat_uni_icon(dummy)
		dummy_icon.scale(64, 64)
		dummy_icon.crop(15, 64 - 31, 15 + 31, 64)
		dummy_icon.scale(64, 64)
		to_insert[sanitize_css_class_name(initial(splat_type.name))] = dummy_icon

		dummy.delete_equipment()

	SSatoms.prepare_deletion(dummy)

	var/datum/universal_icon/dummy_icon = uni_icon('icons/hud/radial.dmi', "radial_center")
	dummy_icon.scale(64, 64)
	to_insert[SPLAT_NONE] = dummy_icon

	for (var/spritesheet_key in to_insert)
		insert_icon(spritesheet_key, to_insert[spritesheet_key])

/datum/preference_middleware/splat/get_ui_static_data(mob/user)
	. = ..()

	var/list/names_to_key = list()
	for(var/datum/subsplat/vampire_clan/clan as anything in GLOB.vampire_clans)
		names_to_key[clan::name] = clan::id
	.["clan_names_to_key"] = names_to_key
