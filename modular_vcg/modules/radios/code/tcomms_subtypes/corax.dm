/obj/machinery/telecomms/server/presets/corax
	id = "Corax Server"
	network = "corax"
	freq_listening = list(FREQ_CORAX)
	autolinkers = list("corax")

/obj/machinery/telecomms/server/presets/corax/New()
	. = ..()
	frequency_infos["[FREQ_CORAX]"] = list(
		"name" = RADIO_CHANNEL_CORAX,
		"color" = RADIO_COLOR_CORAX,
	)

/obj/machinery/telecomms/bus/darkpack/corax
	id = "Corax Bus"
	network = "corax"
	freq_listening = list(FREQ_CORAX)
	autolinkers = list("corax_processor", "corax")

/obj/machinery/telecomms/processor/darkpack/corax
	id = "Corax Processor"
	network = "corax"
	autolinkers = list("corax_processor")

/obj/machinery/telecomms/receiver/darkpack/corax
	id = "Corax Communications Receiver"
	network = "corax"
	autolinkers = list("corax_receiver")

/obj/machinery/telecomms/broadcaster/darkpack/corax
	id = "Corax Communications Broadcaster"
	network = "corax"
	autolinkers = list("corax_broadcaster")

/obj/machinery/telecomms/relay/darkpack/corax
	id = "Corax Communications Relay"
	network = "corax"
	autolinkers = list("corax_relay")

/obj/machinery/telecomms/hub/darkpack/corax
	id = "Communications Hub"
	network = "global"
	autolinkers = list(
		"corax_relay",
		"corax_receiver",
		"corax_broadcaster",
		"corax",
	)
