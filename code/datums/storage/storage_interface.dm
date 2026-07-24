/// Datum tracker for storage UI
/datum/storage_interface
	/// UI elements for this theme
	var/atom/movable/screen/close/closer
	var/atom/movable/screen/storage/cell/cells
	var/atom/movable/screen/storage/corner/corner_top_left
	var/atom/movable/screen/storage/corner/top_right/corner_top_right
	var/atom/movable/screen/storage/corner/bottom_left/corner_bottom_left
	var/atom/movable/screen/storage/corner/bottom_right/corner_bottom_right
	var/atom/movable/screen/storage/rowjoin/rowjoin_left
	var/atom/movable/screen/storage/rowjoin/right/rowjoin_right
	var/atom/movable/screen/storage_hover/hovering

	/// Storage that owns us
	var/datum/storage/parent_storage

/datum/storage_interface/New(ui_style, datum/storage/parent_storage, mob/user)
	..()
	src.parent_storage = parent_storage
	var/datum/hud/owner_hud = user.hud_used
	closer = new(null, owner_hud, parent_storage)
	cells = new(null, owner_hud, parent_storage)
	cells.owner_interface = src
	corner_top_left = new(null, owner_hud, parent_storage)
	corner_top_right = new(null, owner_hud, parent_storage)
	corner_bottom_left = new(null, owner_hud, parent_storage)
	corner_bottom_right = new(null, owner_hud, parent_storage)
	rowjoin_left = new(null, owner_hud, parent_storage)
	rowjoin_right = new(null, owner_hud, parent_storage)
	for (var/atom/movable/screen/ui_elem as anything in list_ui_elements(initializing = TRUE))
		ui_elem.icon = ui_style
	if(parent_storage.grid)
		hovering = new(null, owner_hud)
	for (var/atom/movable/screen/ui_elem as anything in list_ui_elements(initializing = TRUE))
		ui_elem.icon = ui_style

/// Returns all UI elements under this theme
/datum/storage_interface/proc/list_ui_elements(initializing = FALSE)
	return list(cells, corner_top_left, corner_top_right, corner_bottom_left, corner_bottom_right, rowjoin_left, rowjoin_right, closer)

/datum/storage_interface/Destroy(force)
	QDEL_NULL(closer)
	QDEL_NULL(cells)
	QDEL_NULL(corner_top_left)
	QDEL_NULL(corner_top_right)
	QDEL_NULL(corner_bottom_left)
	QDEL_NULL(corner_bottom_right)
	QDEL_NULL(rowjoin_left)
	QDEL_NULL(rowjoin_right)
	QDEL_NULL(hovering)
	parent_storage = null
	return ..()

/datum/storage_interface/proc/update_hover(mob/user, params)
	if(!user.client)
		return
	user.client.screen -= hovering

	if(! parent_storage.can_be_reached_by(user) || !isliving(user))
		return
	var/obj/item/held_item = user.get_active_held_item()
	if(!held_item)
		return

	var/list/modifiers = params2list(params)
	var/screen_loc = LAZYACCESS(modifiers, SCREEN_LOC)
	var/coordinates = parent_storage.screen_loc_to_grid_coordinates(screen_loc)
	if(!coordinates)
		return

	var/used_gridwidth = parent_storage.get_used_grid_size(held_item, TRUE)
	var/used_gridheight = parent_storage.get_used_grid_size(held_item, FALSE)

	if(parent_storage.validate_grid_coordinates(coordinates, used_gridwidth, used_gridheight, held_item))
		hovering.color = COLOR_ASSEMBLY_GOLD
	else
		hovering.color = COLOR_RED_LIGHT

	hovering.transform = matrix()
	var/scale_x = used_gridwidth / world.icon_size
	var/scale_y = used_gridheight / world.icon_size
	hovering.transform = hovering.transform.Scale(scale_x, scale_y)
	var/translate_x = (world.icon_size / 2) * (scale_x - 1)
	var/translate_y = (world.icon_size / 2) * (scale_y - 1)
	hovering.transform = hovering.transform.Translate(translate_x, translate_y)

	hovering.screen_loc = parent_storage.grid_coordinates_to_screen_loc(coordinates)
	user.client.screen |= hovering

/// Updates position of all UI elements
/datum/storage_interface/proc/update_position(
	screen_start_x,
	screen_pixel_x,
	screen_start_y,
	screen_pixel_y,
	columns,
	rows,
	mob/user_looking,
	atom/real_location,
	list/datum/numbered_display/numbered_contents,
)
	var/number_of_hands = user_looking.held_items.len
	while(number_of_hands > user_looking.default_hand_amount)
		number_of_hands /= user_looking.default_hand_amount
		screen_start_y++
	var/start_pixel_x = screen_start_x * 32 + screen_pixel_x
	var/start_pixel_y = screen_start_y * 32 + screen_pixel_y
	var/end_pixel_x = start_pixel_x + (columns - 1) * 32
	var/end_pixel_y = start_pixel_y + (rows - 1) * 32

	cells.screen_loc = spanning_screen_loc(start_pixel_x, start_pixel_y, end_pixel_x, end_pixel_y)
	var/left_edge_loc = spanning_screen_loc(min(start_pixel_x + 32, end_pixel_x), start_pixel_y, end_pixel_x, end_pixel_y)
	var/right_edge_loc = spanning_screen_loc(start_pixel_x, start_pixel_y, max(start_pixel_x, end_pixel_x - 32), end_pixel_y)
	corner_top_left.screen_loc = left_edge_loc
	corner_bottom_left.screen_loc = left_edge_loc
	corner_top_right.screen_loc = right_edge_loc
	corner_bottom_right.screen_loc = right_edge_loc

	var/row_left_loc = spanning_screen_loc(start_pixel_x, start_pixel_y + 27, start_pixel_x, start_pixel_y + 27 + max(0, rows - 2) * 32)
	rowjoin_left.screen_loc = row_left_loc
	rowjoin_left.alpha = (rows > 1) * 255

	var/row_right_loc = spanning_screen_loc(end_pixel_x, start_pixel_y + 27, end_pixel_x, start_pixel_y + 27 + max(0, rows - 2) * 32)
	rowjoin_right.screen_loc = row_right_loc
	rowjoin_right.alpha = (rows > 1) * 255

	closer.screen_loc = "[screen_start_x + columns]:[screen_pixel_x - 5],[screen_start_y]:[screen_pixel_y]"

	add_items(arglist(args))

/datum/storage_interface/proc/add_items(
	screen_start_x,
	screen_pixel_x,
	screen_start_y,
	screen_pixel_y,
	columns,
	rows,
	mob/user_looking,
	atom/real_location,
	list/datum/numbered_display/numbered_contents,
)
	if(parent_storage.grid)
		add_items_grid(screen_start_x, screen_pixel_x, screen_start_y, screen_pixel_y, real_location)
		return

	var/current_x = screen_start_x
	var/current_y = screen_start_y
	var/turf/our_turf = get_turf(real_location)

	var/list/obj/storage_contents = list()
	if (islist(numbered_contents))
		for(var/content_type in numbered_contents)
			var/datum/numbered_display/numberdisplay = numbered_contents[content_type]
			storage_contents[numberdisplay.sample_object] = MAPTEXT("<font color='white'>[(numberdisplay.number > 1)? "[numberdisplay.number]" : ""]</font>")
	else
		for(var/obj/item as anything in real_location)
			storage_contents[item] = ""

	for(var/obj/item as anything in storage_contents)
		item.mouse_opacity = MOUSE_OPACITY_OPAQUE
		item.screen_loc = "[current_x]:[screen_pixel_x + item.base_pixel_x],[current_y]:[screen_pixel_y + item.base_pixel_y]"
		if(parent_storage.numerical_stacking)
			item.maptext = storage_contents[item]
		SET_PLANE(item, ABOVE_HUD_PLANE, our_turf)
		current_x++
		if(current_x - screen_start_x < columns)
			continue
		current_x = screen_start_x

		current_y++
		if(current_y - screen_start_y >= rows)
			break

/datum/storage_interface/proc/add_items_grid(screen_start_x, screen_pixel_x, screen_start_y, screen_pixel_y, atom/real_location)
	var/turf/our_turf = get_turf(real_location)

	for(var/obj/item/thing as anything in real_location)
		if(QDELETED(thing))
			continue

		var/anchor = parent_storage.item_to_grid_anchor(thing)
		if(!anchor)
			continue // shouldn't happen once grid_add_item is called on insert, but don't render orphans

		thing.mouse_opacity = MOUSE_OPACITY_OPAQUE

		var/mutable_appearance/bound_underlay = parent_storage.get_bound_underlay(thing)
		thing.underlays = list(bound_underlay)

		thing.screen_loc = parent_storage.grid_coordinates_to_screen_loc(anchor, thing)
		SET_PLANE(thing, ABOVE_HUD_PLANE, our_turf)

		if(parent_storage.numerical_stacking)
			thing.maptext = "" // grid mode doesn't stack visually; each item occupies its own footprint

///Silicon subtype of storage interface used by their model storage.
/datum/storage_interface/silicon
	var/obj/item/robot_model/robot_model

/datum/storage_interface/silicon/New(ui_style, datum/storage/parent_storage, mob/user)
	. = ..()
	robot_model = parent_storage.real_location

/datum/storage_interface/silicon/add_items(
	screen_start_x,
	screen_pixel_x,
	screen_start_y,
	screen_pixel_y,
	columns,
	rows,
	mob/user_looking,
	atom/real_location,
	list/datum/numbered_display/numbered_contents,
)
	var/list/usable_modules = robot_model.get_usable_modules()

	var/current_x = screen_start_x
	var/current_y = screen_start_y
	var/turf/our_turf = get_turf(real_location)

	for(var/obj/item/item in usable_modules)
		//Only for non active modules
		if(item.item_flags & IN_STORAGE)
			item.mouse_opacity = MOUSE_OPACITY_OPAQUE
			SET_PLANE(item, ABOVE_HUD_PLANE, our_turf)
			item.screen_loc = "[current_x]:[screen_pixel_x + item.base_pixel_x],[current_y]:[screen_pixel_y + item.base_pixel_y]"

		current_x++
		if(current_x - screen_start_x < columns)
			continue
		current_x = screen_start_x

		current_y++
		if(current_y - screen_start_y >= rows)
			break
