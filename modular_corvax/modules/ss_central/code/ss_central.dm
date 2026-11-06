/datum/config_entry/string/ss_central_url
	default = ""
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/string/ss_central_token
	default = ""
	protection = CONFIG_ENTRY_LOCKED | CONFIG_ENTRY_HIDDEN

/// Адрес для ссылок, которые открывает игрок, если пуст, берётся ss_central_url
/datum/config_entry/string/ss_central_public_url
	default = ""
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/flag/force_discord_verification
	default = FALSE
	protection = CONFIG_ENTRY_LOCKED

/atom/movable/screen/lobby/button/ready/Click(location, control, params)
	var/mob/dead/new_player/new_player = hud?.mymob
	if(usr == new_player && new_player.ready == PLAYER_NOT_READY && !usr.client?.discord_link_allows())
		return
	return ..()

/atom/movable/screen/lobby/button/join/Click(location, control, params)
	if(usr == hud?.mymob && !usr.client?.discord_link_allows())
		return
	return ..()

/atom/movable/screen/lobby/button/observe/Click(location, control, params)
	if(usr == hud?.mymob && !usr.client?.discord_link_allows())
		return
	return ..()

/mob/dead/new_player/Login()
	. = ..()
	if(. && client && CONFIG_GET(flag/force_discord_verification))
		SScentral.prefetch_link(client.ckey)

/client
	COOLDOWN_DECLARE(discord_link_cooldown)

/client/proc/discord_link_allows()
	if(!CONFIG_GET(flag/force_discord_verification) || holder)
		return TRUE
	if(!SScentral.can_run())
		to_chat(src, span_warning("Привязка Discord сейчас недоступна, напишите администрации"))
		return FALSE
	if(SScentral.is_linked(ckey))
		return TRUE
	if(!COOLDOWN_FINISHED(src, discord_link_cooldown))
		to_chat(src, span_warning("Сначала привяжите Discord в открывшемся окне, потом нажмите кнопку ещё раз"))
		return FALSE
	COOLDOWN_START(src, discord_link_cooldown, 10 SECONDS)
	to_chat(src, span_warning("Чтобы играть, привяжите аккаунт Discord. Сейчас откроется окно входа, после привязки нажмите кнопку ещё раз"))
	SScentral.start_linking(ckey)
	return FALSE

SUBSYSTEM_DEF(central)
	name = "SS Central"
	ss_flags = SS_NO_FIRE | SS_NO_INIT
	/// ckey -> discord id, only confirmed links are kept so a fresh link is picked up on the next check
	var/list/discord_links = list()

/datum/controller/subsystem/central/vv_edit_var(var_name, var_value)
	return FALSE

/datum/controller/subsystem/central/CanProcCall(procname)
	return FALSE

/datum/controller/subsystem/central/Recover()
	discord_links = SScentral.discord_links.Copy()

/datum/controller/subsystem/central/proc/can_run()
	return CONFIG_GET(string/ss_central_url) && CONFIG_GET(string/ss_central_token)

/datum/controller/subsystem/central/proc/prefetch_link(ckey)
	if(!can_run() || discord_links[ckey])
		return
	SShttp.create_async_request(RUSTG_HTTP_METHOD_GET, player_endpoint(ckey), "", list(), CALLBACK(src, PROC_REF(remember_link), ckey))

/datum/controller/subsystem/central/proc/is_linked(ckey)
	if(discord_links[ckey])
		return TRUE
	var/datum/http_request/request = new()
	request.prepare(RUSTG_HTTP_METHOD_GET, player_endpoint(ckey), "", list(), timeout_seconds = 5)
	request.begin_async()
	UNTIL(request.is_complete())
	return remember_link(ckey, request.into_response())

/datum/controller/subsystem/central/proc/player_endpoint(ckey)
	return "[CONFIG_GET(string/ss_central_url)]/players/ckey/[ckey]"

/datum/controller/subsystem/central/proc/remember_link(ckey, datum/http_response/response)
	if(response.errored || response.status_code != 200)
		if(response.errored || response.status_code != 404)
			log_access("SS Central lookup for [ckey] failed: [response.status_code] [response.error]")
		return FALSE
	var/list/data = json_decode(response.body)
	discord_links[ckey] = data["discord_id"]
	return TRUE

/datum/controller/subsystem/central/proc/start_linking(ckey)
	var/endpoint = "[CONFIG_GET(string/ss_central_url)]/oauth/token?ckey=[ckey]"
	var/list/headers = list("Authorization" = "Bearer [CONFIG_GET(string/ss_central_token)]")
	SShttp.create_async_request(RUSTG_HTTP_METHOD_POST, endpoint, "", headers, CALLBACK(src, PROC_REF(open_login), ckey))

/datum/controller/subsystem/central/proc/open_login(ckey, datum/http_response/response)
	var/client/player = GLOB.directory[ckey]
	if(!player)
		return
	if(response.errored || response.status_code != 201)
		log_access("SS Central token for [ckey] failed: [response.status_code] [response.error]")
		to_chat(player, span_warning("Не получилось начать привязку Discord, попробуйте позже"))
		return
	var/public_url = CONFIG_GET(string/ss_central_public_url) || CONFIG_GET(string/ss_central_url)
	var/login_url = "[public_url]/oauth/login?token=[json_decode(response.body)]"
	to_chat(player, boxed_message("<a href='[login_url]'>Привязать Discord</a>"))
	// в системном браузере игрок обычно уже вошёл в Discord, во встроенном окне BYOND нет
	player << link(login_url)
