/obj/machinery/telecomms/hub/darkpack
	id = "Communications Hub"
	network = "global"
	autolinkers = list(
		"relay",
		"receiver",
		"broadcaster",
		"police",
		"clinic",
		"camarilla",
		"anarch",
	)

/obj/machinery/telecomms/receiver/darkpack
	id = "Communications Receiver"
	network = "global"
	autolinkers = list("receiver")

/obj/machinery/telecomms/broadcaster/darkpack
	id = "Communications Broadcaster"
	network = "global"
	autolinkers = list("broadcaster")

/obj/machinery/telecomms/relay/darkpack
	id = "Communications Relay"
	network = "global"
	autolinkers = list("relay")

// All in one public telecomms mainframe, used for when you dont want to have a tcomms setup on your map and still have radios working.
/obj/machinery/telecomms/allinone/public
	name = "global telecommunications mainframe"
	desc = "A mainframe that allows for the processing of priority radio telecommunications."
	freq_listening = list(FREQ_POLICE, FREQ_CLINIC, FREQ_MILITARY, FREQ_CAMARILLA, FREQ_ANARCH, FREQ_ENDRON)
	syndicate = TRUE
