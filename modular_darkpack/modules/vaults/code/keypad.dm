GLOBAL_LIST_EMPTY(vault_doors)

/proc/create_unique_pincode()
	var/pincode = ""
	for(var/i in 1 to 5)
		pincode += "[rand(0, 9)]" //Generates a random digit and adds it to the pincode
	return pincode

/obj/keypad
	name = "keypad"
	desc = "Requires a password to open."
	icon = 'modular_darkpack/modules/vaults/icons/keypad.dmi'
	icon_state = "keypad"
	layer = SIGN_LAYER
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	var/list/connected_shutters = list()
	var/pincode
	var/id = 0

/obj/keypad/Initialize(mapload)
	. = ..()
	pincode = create_unique_pincode()
	return INITIALIZE_HINT_LATELOAD

/obj/keypad/LateInitialize()
	if(!id)
		return
	connect_to_shutters()

/obj/keypad/proc/connect_to_shutters()
	for(var/obj/machinery/door/poddoor/shutters/S in range(20, src))
		if(S.id == id)
			connected_shutters += S

/obj/keypad/attack_hand(mob/user)
	. = ..()
	if(!length(connected_shutters))
		to_chat(user, span_warning("No connected shutters."))
		return

	var/choice = tgui_alert(user, "Enter pincode or close shutters?", "Keypad", list("Enter Pincode", "Close Shutters", "Cancel"))
	if(choice == "Enter Pincode")
		var/input = tgui_input_text(user, "Enter 5-digit pincode:", "Keypad")
		if("[input]" == pincode)
			to_chat(user, span_notice("ACCESS GRANTED"))
			for(var/obj/machinery/door/poddoor/shutters/S in connected_shutters)
				if(S.density)
					INVOKE_ASYNC(S, TYPE_PROC_REF(/obj/machinery/door/poddoor/shutters, open))
		else
			to_chat(user, span_warning("ACCESS DENIED"))

	else if(choice == "Close Shutters")
		for(var/obj/machinery/door/poddoor/shutters/S in connected_shutters)
			if(!S.density)
				INVOKE_ASYNC(S, TYPE_PROC_REF(/obj/machinery/door/poddoor/shutters, close))

/obj/keypad/armory
	id = 10

/obj/keypad/bankvault
	id = 11

/obj/keypad/panic_room
	id = 12
