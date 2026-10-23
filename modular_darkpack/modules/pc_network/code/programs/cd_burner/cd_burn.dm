#define CD_BURN_TIME (4 SECONDS)
#define CD_MAX_URL_LENGTH 300
#define CD_MAX_TEXT_LENGTH 64
#define CD_MAX_DURATION_SECONDS 3600

/// Exact hostnames burnable URLs may point at (no subdomain wildcards, so lookalike hosts can't slip through).
GLOBAL_LIST_INIT(cd_burn_allowed_hosts, list(
	"files.catbox.moe",
	"litter.catbox.moe",
	"cdn.discordapp.com",
	"media.discordapp.net",
	"raw.githubusercontent.com",
	"github.com",
	"archive.org",
))

/datum/pc_program/cd_burner
	name = "CD Burner"
	icon_state = "compact-disc"
	tgui_id = "PcCdBurner"

	var/obj/machinery/computer/pc/host_atom
	/// TRUE while a burn is in progress
	var/burning = FALSE
	var/burn_start = 0
	var/burn_timer
	/// Weakref to the disc being burned, so swapping discs mid-burn fails the burn
	var/datum/weakref/burn_disc_ref
	/// Data for the track currently being burned
	var/list/pending_burn
	/// Last error / status message shown in the UI
	var/last_message
	var/last_message_good = FALSE
	/// https links to audio files BYOND can play. Group 1 is the host, which is checked against the whitelist.
	var/static/regex/audio_url_regex = regex(@"^https://([a-z0-9][a-z0-9.\-]*)/[a-zA-Z0-9_\-.~/!$&()*+,;=%@:]*\.(ogg|mp3|wav|mid|midi)(\?[a-zA-Z0-9_\-.~:/?#\[\]@!$&()*+,;=%]*)?$", "i")

/datum/pc_program/cd_burner/proc/validate_url(url)
	if(length(url) > CD_MAX_URL_LENGTH || !audio_url_regex.Find(url))
		return "Invalid URL. Use a direct https link to an .ogg, .mp3, .wav or .mid file."
	var/host = lowertext(audio_url_regex.group[1])
	if(!(host in GLOB.cd_burn_allowed_hosts))
		return "That host isn't allowed. Allowed hosts: [english_list(GLOB.cd_burn_allowed_hosts)]."
	return null

/datum/pc_program/cd_burner/New(obj/machinery/computer/pc/host)
	. = ..()
	host_atom = host

/datum/pc_program/cd_burner/Destroy()
	if(burn_timer)
		deltimer(burn_timer)
		burn_timer = null
	pending_burn = null
	burn_disc_ref = null
	host_atom = null
	return ..()

/datum/pc_program/cd_burner/proc/set_message(text, good = FALSE)
	last_message = text
	last_message_good = good

/datum/pc_program/cd_burner/proc/finish_burn()
	burn_timer = null
	burning = FALSE
	var/list/job = pending_burn
	pending_burn = null

	var/obj/item/pc_cd/disc = host_atom?.inserted_cd
	if(!job || QDELETED(host_atom) || QDELETED(disc) || disc != burn_disc_ref?.resolve())
		burn_disc_ref = null
		set_message("Burn failed: the disc was removed during writing.")
		return

	burn_disc_ref = null
	if(!disc.burn_track(job["url"], job["title"], job["artist"], job["genre"], job["duration"]))
		set_message("Burn failed: the disc is full or the track was rejected.")
		return

	set_message("Successfully burned \"[job["title"]]\".", TRUE)

/datum/pc_program/cd_burner/ui_data(mob/user)
	var/obj/item/pc_cd/disc = host_atom?.inserted_cd
	var/list/track_list = list()
	if(disc)
		for(var/i in 1 to length(disc.tracks))
			var/datum/media_track/T = disc.tracks[i]
			track_list += list(list(
				"index" = i,
				"title" = T.title,
				"artist" = T.artist,
				"genre" = T.genre,
				"duration" = T.duration / 10,
			))

	return list(
		"has_disc" = !!disc,
		"tracks" = track_list,
		"max_tracks" = disc?.max_tracks || 0,
		"burning" = burning,
		"burn_progress" = burning ? clamp((world.time - burn_start) / CD_BURN_TIME, 0, 1) : 0,
		"message" = last_message,
		"message_good" = last_message_good,
		"permission" = GLOB.cd_burn_permissions.get_status(user),
	)

/datum/pc_program/cd_burner/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	var/obj/item/pc_cd/disc = host_atom?.inserted_cd

	switch(action)
		if("burn")
			if(burning)
				return FALSE
			if(!disc)
				set_message("No disc inserted.")
				return TRUE
			if(length(disc.tracks) >= disc.max_tracks)
				set_message("The disc is full.")
				return TRUE

			// Permission gate.
			var/datum/cd_burn_permissions/perms = GLOB.cd_burn_permissions
			switch(perms.get_status(ui.user))
				if("none")
					perms.request(ui.user)
					set_message("Burning requires admin approval. A request has been sent; try again once approved.")
					return TRUE
				if("pending")
					set_message("Your request is awaiting admin approval.")
					return TRUE
				if("denied")
					set_message("An admin denied your request. You can ask again in a few minutes.")
					return TRUE

			var/url = trim("[params["url"]]")
			var/url_error = validate_url(url)
			if(url_error)
				set_message(url_error)
				return TRUE

			var/title = clean_text(params["title"], CD_MAX_TEXT_LENGTH)
			if(!title)
				set_message("A title is required.")
				return TRUE

			var/artist = clean_text(params["artist"], CD_MAX_TEXT_LENGTH) || "Unknown"
			var/genre = clean_text(params["genre"], CD_MAX_TEXT_LENGTH) || "Unknown"

			var/seconds = text2num(params["duration"])
			if(isnull(seconds) || seconds < 1)
				set_message("Enter the track length in seconds.")
				return TRUE
			seconds = clamp(round(seconds), 1, CD_MAX_DURATION_SECONDS)

			pending_burn = list(
				"url" = url,
				"title" = title,
				"artist" = artist,
				"genre" = genre,
				"duration" = seconds * 10,
			)
			burn_disc_ref = WEAKREF(disc)
			burning = TRUE
			burn_start = world.time
			set_message(null)
			burn_timer = addtimer(CALLBACK(src, PROC_REF(finish_burn)), CD_BURN_TIME, TIMER_STOPPABLE)
			return TRUE

		if("remove_track")
			if(burning || !disc)
				return FALSE
			var/index = text2num(params["index"])
			if(isnull(index) || !disc.remove_track(round(index)))
				return FALSE
			set_message("Track removed.", TRUE)
			return TRUE

		if("erase")
			if(burning || !disc)
				return FALSE
			disc.clear_tracks()
			set_message("Disc erased.", TRUE)
			return TRUE

		if("eject_cd")
			if(burning)
				if(burn_timer)
					deltimer(burn_timer)
					burn_timer = null
				burning = FALSE
				pending_burn = null
				burn_disc_ref = null
				set_message("Burn cancelled.")
			return TRUE

	return FALSE

#undef CD_BURN_TIME
#undef CD_MAX_URL_LENGTH
#undef CD_MAX_TEXT_LENGTH
#undef CD_MAX_DURATION_SECONDS
