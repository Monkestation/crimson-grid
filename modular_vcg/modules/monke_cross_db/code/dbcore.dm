/datum/controller/subsystem/dbcore
	var/connection_cross   // Arbitrary handle returned from rust_g.

/datum/controller/subsystem/dbcore/proc/ConnectCross()
	if(IsConnected())
		return TRUE

	if(connection)
		Disconnect() //clear the current connection handle so isconnected() calls stop invoking rustg
		connection = null //make sure its cleared even if runtimes happened

	if(failed_connection_timeout <= world.time) //it's been long enough since we failed to connect, reset the counter
		failed_connections = 0
		failed_connection_timeout = 0

	if(failed_connection_timeout > 0)
		return FALSE

	if(!CONFIG_GET(flag/sql_enabled_cross))
		return FALSE

	// start_db_daemon()

	var/user = CONFIG_GET(string/feedback_login)
	var/pass = CONFIG_GET(string/feedback_password)
	var/db = CONFIG_GET(string/feedback_database_cross)
	var/address = CONFIG_GET(string/address)
	var/port = CONFIG_GET(number/port)
	var/timeout = max(CONFIG_GET(number/async_query_timeout), CONFIG_GET(number/blocking_query_timeout))
	var/min_sql_connections = CONFIG_GET(number/pooling_min_sql_connections)
	var/max_sql_connections = CONFIG_GET(number/pooling_max_sql_connections)

	var/result = json_decode(rustg_sql_connect_pool(json_encode(list(
		"host" = address,
		"port" = port,
		"user" = user,
		"pass" = pass,
		"db_name" = db,
		"read_timeout" = timeout,
		"write_timeout" = timeout,
		"min_threads" = min_sql_connections,
		"max_threads" = max_sql_connections,
	))))
	. = (result["status"] == "ok")
	if (.)
		connection = result["handle"]
	else
		connection = null
		last_error = result["data"]
		log_sql("ConnectCross() failed | [last_error]")
		++failed_connections
		//If it failed to establish a connection more than 5 times in a row, don't bother attempting to connect for a time.
		if(failed_connections > max_connection_failures)
			failed_connection_timeout_count++
			//basic exponential backoff algorithm
			failed_connection_timeout = world.time + ((2 ** failed_connection_timeout_count) SECONDS)


/datum/controller/subsystem/dbcore/proc/DisconnectCross()
	failed_connections = 0
	if (connection_cross)
		rustg_sql_disconnect_pool(connection_cross)
	connection_cross = null

/datum/controller/subsystem/dbcore/proc/IsConnectedCross()
	if (!CONFIG_GET(flag/sql_enabled))
		return FALSE
	if (!connection_cross)
		return FALSE
	return json_decode(rustg_sql_connected(connection_cross))["status"] == "online"

/datum/controller/subsystem/dbcore/Recover()
	. = ..()
	connection_cross = SSdbcore.connection_cross

/datum/controller/subsystem/dbcore/Shutdown()
	. = ..()
	if(IsConnectedCross())
		DisconnectCross()

/datum/controller/subsystem/dbcore/NewQuery(sql_query, arguments, allow_during_shutdown=FALSE, cross_db=FALSE)
	. = ..()
	if(. == FALSE)
		return

	if(!cross_db)
		return new /datum/db_query(connection, sql_query, arguments)
	else
		return new /datum/db_query(connection_cross, sql_query, arguments)
