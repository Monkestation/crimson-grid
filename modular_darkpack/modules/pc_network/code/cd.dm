/obj/item/pc_cd
	name = "compact disc"
	desc = "A blank CD-R."
	icon = 'modular_darkpack/modules/pc_network/icons/computer.dmi'
	icon_state = "cd"
	w_class = WEIGHT_CLASS_TINY

	/// Tracks burned onto this disc. Empty = blank.
	var/list/datum/media_track/tracks = list()
	/// Soft limit so people can't make 200-track monstrosities.
	var/max_tracks = 20

/obj/item/pc_cd/Destroy()
	QDEL_LIST(tracks)
	return ..()

/obj/item/pc_cd/examine(mob/user)
	. = ..()
	if(!length(tracks))
		. += span_notice("It's blank.")
		return
	. += span_notice("It contains [length(tracks)] track\s:")
	for(var/i in 1 to length(tracks))
		var/datum/media_track/T = tracks[i]
		. += span_notice("  [i]. [T.title] — [T.artist] ([round(T.duration / 10)]s)")

/// Adds a track. Returns FALSE if the disc is full or the arguments are invalid.
/obj/item/pc_cd/proc/burn_track(url, title, artist, genre, duration)
	if(length(tracks) >= max_tracks)
		return FALSE
	if(!url || !title)
		return FALSE

	var/datum/media_track/new_track = new /datum/media_track(url, title, duration, artist, genre)
	tracks += new_track

	// Nice name / desc once the first track is burned
	if(length(tracks) == 1)
		name = "CD: [title]"
		desc = "A burned CD. [title] by [artist]."
	else
		name = "CD: [tracks[1].title] + [length(tracks) - 1] more"
		desc = "A burned multi-track CD ([length(tracks)] tracks)."

	return TRUE

/obj/item/pc_cd/proc/update_labels()
	switch(length(tracks))
		if(0)
			name = initial(name)
			desc = initial(desc)
		if(1)
			var/datum/media_track/T = tracks[1]
			name = "CD: [T.title]"
			desc = "A burned CD. [T.title] by [T.artist]."
		else
			var/datum/media_track/T = tracks[1]
			name = "CD: [T.title] + [length(tracks) - 1] more"
			desc = "A burned multi-track CD ([length(tracks)] tracks)."

/// Removes the track at the given 1-based index. Returns FALSE if out of range.
/obj/item/pc_cd/proc/remove_track(index)
	if(index < 1 || index > length(tracks))
		return FALSE
	var/datum/media_track/T = tracks[index]
	tracks -= T
	qdel(T)
	update_labels()
	return TRUE

/obj/item/pc_cd/proc/clear_tracks()
	QDEL_LIST(tracks)
	tracks = list()
	update_labels()

/obj/item/pc_cd/test_track/Initialize(mapload)
	. = ..()
	burn_track("https://files.catbox.moe/pnd2ni.ogg", "Test Track", "Unknown", "Electronic", 1800)
	burn_track("https://files.catbox.moe/pnd2ni.ogg", "Test Track 2", "Unknown", "Electronic", 1800)
