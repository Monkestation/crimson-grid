/obj/machinery/fax
	special_networks = list(
		nanotrasen = list(fax_name = "NT HR Department", fax_id = "central_command", color = "teal", emag_needed = TRUE),
		syndicate = list(fax_name = "Sabotage Department", fax_id = "syndicate", color = "red", emag_needed = TRUE),
		camarillaadmin = list(fax_name = "High Council", fax_id = "camarillaadmin", color = "teal", emag_needed = TRUE),
		anarchsadmin = list(fax_name = "Free State Movement", fax_id = "anarchsadmin", color = "red", emag_needed = TRUE),
		policeadmin = list(fax_name = "Federal Government", fax_id = "policeadmin", color = "blue", emag_needed = TRUE),
		fbiadmin = list(fax_name = "FBI National Headquarters", fax_id = "fbiadmin", color = "blue", emag_needed = TRUE),
		endronadmin = list(fax_name = EVIL_COMPANY + " Corporate", fax_id = "endronadmin", color = "green", emag_needed = TRUE),
		aasimitesadmin = list(fax_name = "Element Relay", fax_id = "aasimitesadmin", color = "purple", emag_needed = TRUE),
		glasswalkeradmin = list(fax_name = "Nightwolf Corporate", fax_id = "glasswalkeradmin", color = "grey", emag_needed = TRUE),
	)

/obj/machinery/fax/admin/camarilla
	fax_name = "High Council"
	fax_id = "camarillaadmin"

/obj/machinery/fax/admin/anarch
	fax_name = "Free State Movement"
	fax_id = "anarchsadmin"

/obj/machinery/fax/admin/police
	fax_name = "Federal Government"
	fax_id = "policeadmin"

/obj/machinery/fax/admin/fbi
	fax_name = "FBI National Headquarters"
	fax_id = "fbi"

/obj/machinery/fax/admin/endron
	fax_name = EVIL_COMPANY + " Corporate"
	fax_id = "endronadmin"

/obj/machinery/fax/admin/aasimites
	fax_name = "Element Relay"
	fax_id = "aasimitesadmin"

//The tremere dont get a fax machine because of what happened in Vienna

/obj/machinery/fax/admin/glasswalker
	fax_name = "Nightwolf Corporate"
	fax_id = "glasswalkeradmin"

/////////////////////////////////////////////

/obj/machinery/fax/camarilla
	fax_name = "Millenium Tower"
	fax_id = "camarilla"
	special_networks = list(camarillaadmin = list(fax_name = "High Council", fax_id = "camarillaadmin", color = "teal", emag_needed = FALSE))

/obj/machinery/fax/anarch
	fax_name = "Anarchy Rose Bar"
	fax_id = "anarchs"
	special_networks = list(anarchsadmin = list(fax_name = "Free State Movement", fax_id = "anarchsadmin", color = "red", emag_needed = FALSE))

/obj/machinery/fax/police
	fax_name = CITY_POLICE_DEPARTMENT
	fax_id = "police"
	special_networks = list(policeadmin = list(fax_name = "Federal Government", fax_id = "policeadmin", color = "blue", emag_needed = FALSE))

/obj/machinery/fax/fbi
	fax_name = "FBI"
	fax_id = "fbi"
	special_networks = list(fbiadmin = list(fax_name = "FBI National Headquarters", fax_id = "fbiadmin", color = "blue", emag_needed = TRUE))
	visible_to_network = FALSE

/obj/machinery/fax/endron
	fax_name = MAIN_EVIL_COMPANY + " HQ"
	fax_id = "endron"
	special_networks = list(endronadmim = list(fax_name = EVIL_COMPANY + " Corporate", fax_id = "endronadmin", color = "green", emag_needed = FALSE))

/obj/machinery/fax/aasimites
	fax_name = "Chubby Lion Coffee Shop"
	fax_id = "aasimites"
	special_networks = list(aasimitesadmin = list(fax_name = "Element Relay", fax_id = "aasimitesadmin", color = "purple", emag_needed = FALSE))

/obj/machinery/fax/tremere
	fax_name = "Library"
	fax_id = "library"
	special_networks = list()

/obj/machinery/fax/glasswalker
	fax_name = "Nightwolf Tech Shop"
	fax_id = "glasswalkers"
	special_networks = list(glasswalkeradmin = list(fax_name = "Nightwolf Corporate", fax_id = "glasswalkeradmin", color = "grey", emag_needed = FALSE))
