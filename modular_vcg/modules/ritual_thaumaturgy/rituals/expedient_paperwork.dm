/obj/ritual_rune/thaumaturgy/expedient_paperwork
	name = "expedient paperwork"
	desc = "Create a set of paperwork that appears as official and complete as possible"
	icon_state = "rune5"
	word = ""
	level = 1
	sacrifices = list(/obj/item/paper, /obj/item/watch) // we don't have dog hair
	var/paperwork_name
	var/paperwork_icon
	var/static/list/paperwork_icons = list("docs_generic", "docs_part", "docs_verified", "docs_red", "docs_blue")

/obj/ritual_rune/thaumaturgy/expedient_paperwork/attack_hand(mob/living/user)
	if(activated)
		return

	var/chosen_name = tgui_input_text(user, "Document name?", "Expedient Paperwork", max_length = MAX_NAME_LEN)
	if(!chosen_name)
		to_chat(user, span_warning("You decide not to expedite any paperwork"))
		return FALSE

	var/list/icon_choices = list()
	for(var/state in paperwork_icons)
		icon_choices[state] = image(icon = 'icons/obj/service/bureaucracy.dmi', icon_state = state)

	var/chosen_icon = show_radial_menu(user, src, icon_choices, require_near = TRUE, tooltips = TRUE)
	if(!chosen_icon)
		to_chat(user, span_warning("You decide not to expedite any paperwork."))
		return FALSE

	paperwork_name = chosen_name
	paperwork_icon = chosen_icon
	. = ..()

/obj/ritual_rune/thaumaturgy/expedient_paperwork/complete()
	. = ..()

	var/obj/item/paperwork/documents = new(loc)
	documents.name = paperwork_name
	documents.icon_state = paperwork_icon
	documents.desc = "A set of paperwork and document that are painstakingly filled with every detail seeming complete and with the uttermost attention"
	qdel(src)
