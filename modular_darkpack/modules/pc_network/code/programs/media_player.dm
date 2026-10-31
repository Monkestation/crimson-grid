/datum/pc_program/media_player
	name = "Media Player"
	icon_state = "music"
	tgui_id = "PcMediaPlayer"

	var/obj/machinery/computer/pc/host_atom
	var/datum/media_source/object/source
	var/datum/media_track/playing_track
	var/volume = 80
	var/max_distance = 12
	var/started_at = 0

/datum/pc_program/media_player/New(obj/machinery/computer/pc/host)
	. = ..()
	host_atom = host

/datum/pc_program/media_player/Destroy()
	stop_playback()
	playing_track = null
	host_atom = null
	return ..()

/datum/pc_program/media_player/proc/get_disc_tracks()
	return host_atom?.inserted_cd?.tracks || list()

/datum/pc_program/media_player/proc/start_playback(datum/media_track/track)
	if(QDELETED(host_atom) || !track)
		return FALSE
	// Safety: only play tracks that are actually on the inserted disc
	if(!(track in get_disc_tracks()))
		return FALSE

	stop_playback()
	source = new /datum/media_source/object(track, volume, CHANNEL_JUKEBOX, host_atom, max_distance)
	source.start_time = REALTIMEOFDAY
	playing_track = track
	started_at = REALTIMEOFDAY
	source.update_for_all_listeners(TRUE)
	return TRUE

/datum/pc_program/media_player/proc/stop_playback()
	if(source)
		QDEL_NULL(source)
	playing_track = null
	started_at = 0

/datum/pc_program/media_player/proc/get_elapsed()
	if(!playing_track || !started_at)
		return 0
	return max(REALTIMEOFDAY - started_at, 0) / 10

/datum/pc_program/media_player/proc/is_playing()
	if(!playing_track || QDELETED(source))
		return FALSE
	// Disc was ejected / track removed from disc
	if(!(playing_track in get_disc_tracks()))
		stop_playback()
		return FALSE
	// Track finished
	if(playing_track.duration && (REALTIMEOFDAY - started_at) > playing_track.duration)
		stop_playback()
		return FALSE
	return TRUE

/datum/pc_program/media_player/proc/track_data(datum/media_track/track)
	return list(
		"ref" = REF(track),
		"title" = track.title,
		"artist" = track.artist,
		"genre" = track.genre,
		"duration" = track.duration / 10,
	)

/datum/pc_program/media_player/ui_data(mob/user)
	var/playing = is_playing()
	var/list/disc_tracks = get_disc_tracks()
	var/list/track_list = list()
	for(var/datum/media_track/T in disc_tracks)
		track_list += list(track_data(T))

	return list(
		"playing" = playing,
		"volume" = volume,
		"max_distance" = max_distance,
		"elapsed" = playing ? get_elapsed() : 0,
		"has_disc" = !!host_atom?.inserted_cd,
		"tracks" = track_list,
		"now_playing" = playing_track ? track_data(playing_track) : null,
	)

/datum/pc_program/media_player/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	switch(action)
		if("play")
			// Play a specific track by ref, or the first track if none given
			var/list/disc_tracks = get_disc_tracks()
			if(!length(disc_tracks))
				return FALSE

			var/datum/media_track/track
			var/track_ref = params["track"]
			if(track_ref)
				track = locate(track_ref)
				if(!(track in disc_tracks))
					return FALSE
			else
				track = disc_tracks[1]

			return start_playback(track)

		if("stop")
			stop_playback()
			return TRUE

		if("set_volume")
			var/new_volume = text2num(params["volume"])
			if(isnull(new_volume))
				return FALSE
			volume = clamp(round(new_volume), 0, 100)
			if(source)
				source.volume = volume
				source.update_for_all_listeners()
			return TRUE

		if("set_range")
			var/new_range = text2num(params["range"])
			if(isnull(new_range))
				return FALSE
			max_distance = clamp(round(new_range), 2, 20)
			if(is_playing())
				var/datum/media_track/track = playing_track
				var/old_start = started_at
				if(start_playback(track))
					started_at = old_start
					source.start_time = old_start
					source.update_for_all_listeners(TRUE)
			return TRUE

		if("eject_cd")
			// The computer itself should handle the actual eject; we just stop audio
			stop_playback()
			return TRUE

	return FALSE
