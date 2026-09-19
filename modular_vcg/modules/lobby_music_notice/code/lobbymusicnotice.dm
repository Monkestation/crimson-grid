/datum/controller/subsystem/ticker
	var/title_music_name

/datum/controller/subsystem/ticker/set_lobby_music(new_music, override = FALSE)
	if(!override && login_music)
		return

	var/list/forms = list()
	for(var/key in SSsounds.byond_sound_formats)
		forms += key

	var/regex/valid_ext = new("\\.([jointext(forms, "|")])$", "i")

	var/ughh = splittext(new_music, "/")
	var/music_track = ughh[length(ughh)]
	music_track = replacetext(music_track, valid_ext, "")

	title_music_name = music_track
	. = ..()

/client/playtitlemusic(volume_multiplier = 1)
	. = ..()
	to_chat(src, span_notice("Lobby music: [span_bold(SSticker.title_music_name)]"))
