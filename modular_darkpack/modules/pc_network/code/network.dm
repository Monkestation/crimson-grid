GLOBAL_LIST_EMPTY(pc_networks)
GLOBAL_DATUM_INIT(schrecknet, /datum/pc_network/schrecknet, new)
GLOBAL_DATUM_INIT(public_network, /datum/pc_network, new)
GLOBAL_VAR_INIT(player_network_counter, 0)

/datum/memory/key/network_password
	var/network_name
	var/master_password

/datum/memory/key/network_password/New(
	datum/mind/memorizer_mind,
	atom/protagonist,
	atom/deuteragonist,
	atom/antagonist,
	network_name,
	master_password,
)
	src.network_name = network_name
	src.master_password = master_password
	return ..()

/datum/memory/key/network_password/get_names()
	return list("The master password for the [network_name] network, [master_password].")

/datum/memory/key/network_password/get_starts()
	return list(
		"[protagonist_name] typing [master_password] into a server console and committing it to memory.",
		"A scrap of paper reading [network_name]: [master_password], which [protagonist_name] then burns.",
	)

/datum/storyteller_roll/hack_network
	bumper_text = "hack network"
	applicable_stats = list(STAT_COMPUTER, STAT_INTELLIGENCE)
	// reroll_cooldown = 1 TURNS
	roll_output_type = ROLL_FLAG_ROLLER
	difficulty = 3

/datum/pc_network
	var/id = PC_NETWORK_PUBLIC
	var/name = "Local Area Network"
	var/list/connected = list()             // weakrefs to devices / networked objects
	var/list/mailboxes = list()             // address -> list of /datum/pc_mail
	var/list/records = list()             // record_id -> /datum/pc_record
	var/list/access_flags = list()         // required flags / clans / stats
	var/is_restricted = FALSE
	var/private = FALSE
	/// Real name of whoever first created this network (for logs/admins)
	var/creator_name

	/// Master password for unconfigured or locked networks
	var/master_password = "ChangeMe123!"
	/// Mapping of login_name -> role string
	var/list/user_roles = list()
	/// Ordered list of roles from most important to least important
	var/list/role_hierarchy = list(
		PC_NETWORK_MASTER,
		PC_NETWORK_ADMIN,
		PC_NETWORK_USER,
		PC_NETWORK_GUEST
	)
	/// Unlocked sessions via master password (login_name -> TRUE)
	var/list/authenticated_sessions = list()
	var/list/imageboard = list()
	var/list/bounties = list()
	var/datum/pc_automation/automation
	/// Computers successes-difficulty to hack into this network from a device
	var/hack_difficulty = 7
	/// Newest entry last. Each entry: list("time", "type", "device_id", "device_name")
	var/list/event_log = list()
	/// device_id -> weakref of every device currently on this network
	var/list/connected_devices = list()
	/// Names of every account that has logged in on this network
	var/list/known_users = list()
	/// lowercase crew name -> /datum/pc_medical_record (network-local overrides)
	var/list/medical_records = list()

/datum/pc_network/schrecknet
	id = PC_NETWORK_SCHRECKNET
	name = "SchreckNet"
	is_restricted = TRUE
	access_flags = list("nosferatu", "tech_savvy")

/datum/pc_network/New()
	GLOB.pc_networks[id] = src
	generate_network_password()
	automation = new(src)

/// Record an event on this network. Call from join(), leave() and failed hack attempts.
/// Membership is always tracked; pass silent = TRUE (e.g. at mapload) to skip the log entry.
/datum/pc_network/proc/log_event(event_type, atom/device, silent = FALSE)
	if(!device)
		return
	switch(event_type)
		if(NETWORK_LOG_JOIN)
			connected_devices[device.get_network_device_id()] = WEAKREF(device)
		if(NETWORK_LOG_LEAVE)
			connected_devices -= device.get_network_device_id()
	if(silent)
		return
	event_log += list(list(
		"time" = time_to_twelve_hour(),
		"type" = event_type,
		"device_id" = device.get_network_device_id(),
		"device_name" = "[device.name]",
	))
	if(length(event_log) > NETWORK_LOG_MAX_ENTRIES)
		event_log.Cut(1, length(event_log) - NETWORK_LOG_MAX_ENTRIES + 1)

/// Finds a working printer among the devices connected to this network.
/// Prefers one that has at least paper_needed sheets and is off cooldown, but falls back to any
/// working printer so the UI can tell "no printer" apart from "printer out of paper".
/datum/pc_network/proc/find_printer(paper_needed = 1)
	var/obj/machinery/pc_printer/fallback
	for(var/datum/weakref/ref as anything in connected)
		var/obj/machinery/pc_printer/printer = ref.resolve()
		if(!istype(printer) || !printer.is_operational)
			continue
		if(printer.paper >= paper_needed && COOLDOWN_FINISHED(printer, print_cooldown))
			return printer
		fallback ||= printer
	return fallback

/datum/pc_network/proc/get_user_role(login_name)
	if(!login_name)
		return "Guest"
	return user_roles[login_name] || (is_restricted ? "Guest" : "User")

/datum/pc_network/proc/has_access(login_name, minimum_role = "User")
	if(authenticated_sessions[login_name])
		return TRUE
	var/current_role = get_user_role(login_name)
	var/current_idx = role_hierarchy.Find(current_role)
	var/min_idx = role_hierarchy.Find(minimum_role)

	// Lower index or equal in a ordered list means higher or equal importance
	if(current_idx && min_idx && current_idx <= min_idx)
		return TRUE
	return FALSE

/datum/pc_network/proc/join(atom/device)
	LAZYADD(connected, WEAKREF(device))
	log_event(NETWORK_LOG_JOIN, device)

/datum/pc_network/proc/leave(atom/device)
	LAZYREMOVE(connected, WEAKREF(device))
	log_event(NETWORK_LOG_LEAVE, device)

/datum/pc_network/proc/is_connected(atom/device)
	return !!device && (WEAKREF(device) in connected)

/// Resolves a UI-supplied REF string, but only if it is actually on THIS network.
/datum/pc_network/proc/resolve_device(ref_string)
	if(!istext(ref_string) || !length(ref_string))
		return null
	var/atom/A = locate(ref_string)
	if(A && is_connected(A))
		return A
	return null

/datum/pc_network/proc/register_user(address, display_name)
	if(!address || address == "anonymous")
		return FALSE
	address = LOWER_TEXT(address)
	known_users[address] = display_name || address
	return TRUE

/datum/pc_network/proc/deliver_mail(datum/pc_mail/mail)
	if(!mail?.to_address)
		return FALSE
	mail.timestamp ||= world.time
	var/address = LOWER_TEXT(mail.to_address)
	if(!mailboxes[address])
		mailboxes[address] = list()
	mailboxes[address] += mail
	automation?.on_mail(mail)
	return TRUE

/datum/pc_network/proc/generate_network_password(length = 10)
	var/static/charset = "abcdefghjkmnpqrstuvwxyz23456789"
	var/result = ""
	for(var/i in 1 to length)
		var/pos = rand(1, length(charset))
		result += copytext(charset, pos, pos + 1)
	master_password = result

/datum/pc_network/proc/send_password_to(mob/user)
	if(!user)
		return
	creator_name ||= user.real_name
	to_chat(user, span_boldnotice("You are the owner of [name]. Its master password is: <b>[master_password]</b>. Keep it safe."))
	user.mind?.add_memory(/datum/memory/key/network_password, network_name = name, master_password = master_password)

/datum/pc_network/proc/get_medical_record(crew_name)
	return medical_records[LOWER_TEXT(crew_name)]

/datum/pc_network/proc/set_medical_record(crew_name, text, editor)
	var/key = LOWER_TEXT(crew_name)
	var/datum/pc_medical_record/rec = medical_records[key]
	if(!rec)
		rec = new
		rec.name = crew_name
		medical_records[key] = rec
	rec.text = text
	rec.last_editor = editor
	rec.last_edited = time_to_twelve_hour()
	return rec

/datum/pc_network/proc/clear_medical_record(crew_name)
	medical_records -= LOWER_TEXT(crew_name)

/// A network made by players through a server. It exists only while at least one server is tuned to it.
/// The servers' owners can make it private (hidden from PC network lists) and/or restricted.
/// Tuning to or hacking into a private or restricted network needs a Computers roll.
/datum/pc_network/player
	is_restricted = FALSE
	private = FALSE
	hack_difficulty = 6
	/// Servers currently tuned to this network
	var/list/servers = list()
	/// Everything that has joined this network (PCs, networked components' parents)
	var/list/members = list()

/datum/pc_network/player/New(new_name)
	id = "player_[++GLOB.player_network_counter]"
	name = new_name
	master_password = generate_network_password()
	. = ..()

/datum/pc_network/player/join(device)
	. = ..()
	members |= device

/datum/pc_network/player/leave(device)
	. = ..()
	members -= device

/datum/pc_network/player/proc/add_server(obj/machinery/pc_server/server)
	servers |= server
	recalculate_difficulty()

/// Removes a server. The network goes away when the last one is gone.
/datum/pc_network/player/proc/remove_server(obj/machinery/pc_server/server)
	servers -= server
	if(!length(servers))
		qdel(src)
		return
	recalculate_difficulty()

/// Closest operational computer on this network that has the given program, on the same z-level
/// and within max_range tiles of origin. Null if there isn't one.
/datum/pc_network/proc/find_closest_program(program_type, atom/origin, max_range = 15)
	var/turf/origin_turf = get_turf(origin)
	if(!origin_turf)
		return null
	var/datum/pc_program/closest
	var/closest_dist = max_range + 1
	for(var/datum/weakref/ref as anything in connected)
		var/obj/machinery/computer/pc/pc = ref.resolve()
		if(!istype(pc) || !pc.is_operational)
			continue
		var/turf/pc_turf = get_turf(pc)
		if(!pc_turf || pc_turf.z != origin_turf.z)
			continue
		var/dist = get_dist(origin_turf, pc_turf)
		if(dist >= closest_dist)
			continue
		var/datum/pc_program/found = pc.get_program(program_type)
		if(!found)
			continue
		closest = found
		closest_dist = dist
	return closest

/datum/pc_network/player/proc/recalculate_difficulty()
	var/highest = 0
	for(var/obj/machinery/pc_server/server as anything in servers)
		highest = max(highest, server.hack_contribution)
	hack_difficulty = highest

/datum/pc_network/player/Destroy()
	// Evacuate while we are still in GLOB.pc_networks, since leave() looks us up there.
	for(var/atom/device as anything in members.Copy())
		if(istype(device, /obj/machinery/computer/pc))
			var/obj/machinery/computer/pc/pc = device
			pc.revert_network()
			to_chat(pc.loc, span_warning("The network [name] has gone offline."))
		else
			SEND_SIGNAL(device, COMSIG_NETWORKED_SET_NETWORK, PC_NETWORK_OFFLINE)
	members.Cut()
	servers.Cut()
	GLOB.pc_networks -= id
	return ..()


/datum/pc_mail
	var/from_address
	var/to_address
	var/subject
	var/body
	var/timestamp
	var/read = FALSE

/datum/pc_record
	var/id
	var/title
	var/body
	var/author
	var/access_level = PC_ACCESS_USER
	var/timestamp
	var/tags = list()
