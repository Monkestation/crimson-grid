#define BOUNTY_MAX_TITLE 60
#define BOUNTY_MAX_DESC 800
#define BOUNTY_MAX_REWARD 60
#define BOUNTY_MAX_ALIAS 30
/// Active (open or claimed) bounties one address may have at once
#define BOUNTY_MAX_PER_OWNER 3
/// Total bounties stored per network, fulfilled ones are pruned first
#define BOUNTY_MAX_PER_NETWORK 40
#define BOUNTY_POST_COOLDOWN (15 SECONDS)
/// Longest side, in pixels, of a stored bounty photo thumbnail
#define BOUNTY_THUMB_SIZE 192

#define BOUNTY_OPEN "open"
#define BOUNTY_CLAIMED "claimed"
#define BOUNTY_FULFILLED "fulfilled"

GLOBAL_VAR_INIT(bounty_counter, 0)

/datum/pc_bounty
	var/id
	var/title
	var/description
	/// Free text reward ("500 credits", "a favour", "a vial of vitae")
	var/reward
	var/category
	var/status = BOUNTY_OPEN
	/// Network address of whoever posted it, used for ownership checks, never shown on the blackmarket
	var/owner_address
	/// What other people see (address on public networks, alias on the blackmarket)
	var/poster_display
	var/claimant_address
	var/claimant_display
	/// Asset-cache key of an attached photo (registered with SSassets.transport).
	/// Only the key is kept, not the /datum/picture, so the board never holds the original alive, WILL HARD DELETE IF YOU DO.
	var/photo_key
	var/photo_name
	var/timestamp

/datum/pc_program/bountyboard
	name = "Bounty Board"
	icon_state = "bullseye"
	tgui_id = "PcBountyBoard"
	var/current_bounty
	var/next_post_time = 0
	/// Photo asset keys referenced by whatever ui_data is currently showing.
	var/list/visible_photo_keys = list()

/datum/pc_program/bountyboard/proc/is_blackmarket(datum/pc_network/net)
	return net?.id == PC_NETWORK_SCHRECKNET

/datum/pc_program/bountyboard/proc/get_categories(datum/pc_network/net)
	if(is_blackmarket(net))
		return list("Acquisition", "Retrieval", "Information", "Elimination")
	return list("Item", "Service", "Information", "Other")

/datum/pc_program/bountyboard/proc/get_bounties(datum/pc_network/net)
	RETURN_TYPE(/list)
	if(!islist(net.bounties))
		net.bounties = list()
	return net.bounties

/datum/pc_program/bountyboard/proc/find_bounty(datum/pc_network/net, id)
	for(var/datum/pc_bounty/B in get_bounties(net))
		if(B.id == id)
			return B
	return null

/datum/pc_program/bountyboard/proc/count_active(datum/pc_network/net, address)
	var/count = 0
	for(var/datum/pc_bounty/B in get_bounties(net))
		if(B.owner_address == address && B.status != BOUNTY_FULFILLED)
			count++
	return count

/// Makes room for a new bounty by dropping the oldest fulfilled one. Returns FALSE if the board is full of live bounties.
/datum/pc_program/bountyboard/proc/make_room(datum/pc_network/net)
	var/list/all = get_bounties(net)
	while(length(all) >= BOUNTY_MAX_PER_NETWORK)
		var/datum/pc_bounty/oldest_done
		for(var/datum/pc_bounty/B in all)
			if(B.status == BOUNTY_FULFILLED)
				oldest_done = B
				break
		if(!oldest_done)
			return FALSE
		all -= oldest_done
		qdel(oldest_done)
	return TRUE

/// Scales a /datum/picture down and registers it as a permanent asset, same approach as the imageboard.
/datum/pc_program/bountyboard/proc/register_photo_asset(datum/picture/pic)
	var/icon/thumb = icon(pic.picture_image)
	var/w = thumb.Width()
	var/h = thumb.Height()
	var/biggest = max(w, h)
	if(biggest > BOUNTY_THUMB_SIZE)
		var/factor = BOUNTY_THUMB_SIZE / biggest
		thumb.Scale(max(1, round(w * factor)), max(1, round(h * factor)))
	var/key = SSmodular_computers.get_next_picture_name()
	SSassets.transport.register_asset(key, thumb)
	return key

/datum/pc_program/bountyboard/proc/bounty_to_list(datum/pc_bounty/B, address)
	if(B.photo_key)
		visible_photo_keys |= B.photo_key
	return list(
		"id" = B.id,
		"title" = B.title,
		"description" = B.description,
		"reward" = B.reward,
		"category" = B.category,
		"status" = B.status,
		"poster" = B.poster_display,
		"claimant" = B.claimant_display,
		"photo" = B.photo_key ? SSassets.transport.get_asset_url(B.photo_key) : null,
		"photo_name" = B.photo_name,
		"time" = B.timestamp,
		"mine" = (B.owner_address == address),
		"claimed_by_me" = (B.claimant_address && B.claimant_address == address),
	)

/datum/pc_program/bountyboard/ui_data(mob/user)
	visible_photo_keys = list()
	var/list/data = build_ui_data(user)
	// send_assets skips anything this client already has, so calling it every refresh is cheap.
	if(user && length(visible_photo_keys))
		SSassets.transport.send_assets(user, visible_photo_keys)
	return data

/datum/pc_program/bountyboard/proc/build_ui_data(mob/user)
	var/list/data = list()
	var/datum/pc_network/net = computer.current_network

	data["view"] = "list"
	data["blackmarket"] = FALSE
	data["network_name"] = net?.name
	data["bounties"] = list()
	data["categories"] = list()
	data["cooldown_left"] = max(0, round((next_post_time - world.time) / 10))
	data["limits"] = list(
		"title" = BOUNTY_MAX_TITLE,
		"description" = BOUNTY_MAX_DESC,
		"reward" = BOUNTY_MAX_REWARD,
		"alias" = BOUNTY_MAX_ALIAS,
	)

	data["photos"] = list()
	for(var/obj/item/photo/P as anything in get_carried_photos(user))
		data["photos"] += list(list(
			"ref" = REF(P),
			"name" = P.picture.picture_name || "photo",
		))

	if(!net)
		return data

	var/address = computer.get_formatted_address()
	data["blackmarket"] = is_blackmarket(net)
	data["categories"] = get_categories(net)

	if(current_bounty)
		var/datum/pc_bounty/B = find_bounty(net, current_bounty)
		if(B)
			data["view"] = "detail"
			data["selected"] = bounty_to_list(B, address)
			return data
		current_bounty = null

	// Newest first
	var/list/all = get_bounties(net)
	for(var/i in length(all) to 1 step -1)
		data["bounties"] += list(bounty_to_list(all[i], address))
	return data

/datum/pc_program/bountyboard/proc/build_bounty(datum/pc_network/net, list/params, mob/user, address)
	var/datum/pc_bounty/B = new
	B.title = clean_text(params["title"], BOUNTY_MAX_TITLE)
	if(!B.title)
		qdel(B)
		return null
	B.description = clean_text(params["description"], BOUNTY_MAX_DESC)
	B.reward = clean_text(params["reward"], BOUNTY_MAX_REWARD) || "Negotiable"

	var/category = params["category"]
	var/list/categories = get_categories(net)
	B.category = (istext(category) && (category in categories)) ? category : categories[length(categories)]

	B.owner_address = address
	if(is_blackmarket(net))
		B.poster_display = clean_text(params["alias"], BOUNTY_MAX_ALIAS) || "Unknown"
	else
		B.poster_display = address

	var/photo_ref = params["photo"]
	if(istext(photo_ref) && photo_ref)
		for(var/obj/item/photo/photo as anything in get_carried_photos(user))
			if(REF(photo) != photo_ref)
				continue
			B.photo_key = register_photo_asset(photo.picture)
			B.photo_name = clean_text(photo.picture.picture_name, BOUNTY_MAX_TITLE)
			break

	B.id = ++GLOB.bounty_counter
	B.timestamp = time_to_twelve_hour()
	return B

/datum/pc_program/bountyboard/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	var/datum/pc_network/net = computer.current_network
	if(!net)
		return FALSE

	var/address = computer.get_formatted_address()

	switch(action)
		if("open")
			var/id = text2num(params["id"])
			if(!find_bounty(net, id))
				return FALSE
			current_bounty = id
			return TRUE

		if("back")
			current_bounty = null
			return TRUE

		if("post")
			if(world.time < next_post_time)
				return FALSE
			if(count_active(net, address) >= BOUNTY_MAX_PER_OWNER)
				computer.say("You already have the maximum number of active bounties.")
				return FALSE
			if(!make_room(net))
				computer.say("The board is full.")
				return FALSE
			var/datum/pc_bounty/B = build_bounty(net, params, ui?.user, address)
			if(!B)
				return FALSE
			var/list/bounty_list = get_bounties(net)
			bounty_list += B
			next_post_time = world.time + BOUNTY_POST_COOLDOWN
			current_bounty = B.id
			return TRUE

		if("claim")
			var/datum/pc_bounty/B = find_bounty(net, current_bounty)
			if(!B || B.status != BOUNTY_OPEN || B.owner_address == address)
				return FALSE
			B.status = BOUNTY_CLAIMED
			B.claimant_address = address
			if(is_blackmarket(net))
				B.claimant_display = clean_text(params["alias"], BOUNTY_MAX_ALIAS) || "Anonymous"
			else
				B.claimant_display = address
			return TRUE

		if("release")
			var/datum/pc_bounty/B = find_bounty(net, current_bounty)
			if(!B || B.status != BOUNTY_CLAIMED)
				return FALSE
			if(B.claimant_address != address && B.owner_address != address)
				return FALSE
			B.status = BOUNTY_OPEN
			B.claimant_address = null
			B.claimant_display = null
			return TRUE

		if("fulfill")
			var/datum/pc_bounty/B = find_bounty(net, current_bounty)
			if(!B || B.owner_address != address || B.status != BOUNTY_CLAIMED)
				return FALSE
			B.status = BOUNTY_FULFILLED
			return TRUE

		if("cancel")
			var/datum/pc_bounty/B = find_bounty(net, current_bounty)
			if(!B || B.owner_address != address)
				return FALSE
			var/list/bounty_list = get_bounties(net)
			bounty_list -= B
			qdel(B)
			current_bounty = null
			return TRUE

	return FALSE

#undef BOUNTY_MAX_TITLE
#undef BOUNTY_MAX_DESC
#undef BOUNTY_MAX_REWARD
#undef BOUNTY_MAX_ALIAS
#undef BOUNTY_MAX_PER_OWNER
#undef BOUNTY_MAX_PER_NETWORK
#undef BOUNTY_POST_COOLDOWN
#undef BOUNTY_THUMB_SIZE
#undef BOUNTY_OPEN
#undef BOUNTY_CLAIMED
#undef BOUNTY_FULFILLED
