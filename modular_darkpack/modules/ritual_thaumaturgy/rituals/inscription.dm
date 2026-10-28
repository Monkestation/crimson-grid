// from clanbook tremere revised page 58

/obj/ritual_rune/thaumaturgy/inscription
	name = "inscription"
	desc = "Create a scroll inscribed with vitae to allow unskilled thaumaturgists or those without thaumaturgy to use a level one or two ritual."
	icon_state = "rune5"
	word = ""
	level = 2
	sacrifices = list(/obj/item/paper)
	var/ritual_selected

/obj/ritual_rune/thaumaturgy/inscription/attack_hand(mob/living/user)
	var/datum/action/ritual_drawing/ritual_action = locate() in user.actions
	if(!ritual_action)
		return

	var/list/ritual_selection = ritual_action.get_available_runes()

	// gonna inscription the inscription ritual
	ritual_selection -= "inscription"

	for(var/ritual_name in ritual_selection)
		var/ritual_level = ritual_selection[ritual_name]["level"]
		if(ritual_level > 2)
			ritual_selection -= ritual_name

	var/selection = tgui_input_list(user, "What ritual do you wish to inscribe onto the scroll?", "Ritual Inscription", ritual_selection)
	if(!selection)
		to_chat(user, span_cult("You decide not to inscribe a ritual onto the parchment."))
		return FALSE

	ritual_selected = ritual_selection[selection]["path"]
	. = ..()

/obj/ritual_rune/thaumaturgy/inscription/complete()
	. = ..()

	if(!ritual_selected)
		to_chat(last_activator, span_cult("You haven't chosen a ritual to inscribe."))
		return

	var/obj/item/thaumaturgy_scroll/ritual_scroll = new(loc)
	ritual_scroll.name = "thaumaturgy scroll ([initial(ritual_selected:name)])"
	ritual_scroll.desc = "A scroll inscribed with vitae, allowing its holder to perform the '[initial(ritual_selected:name)]' ritual without thaumaturgical skill. The ritual is described as follows: [initial(ritual_selected:desc)]."
	ritual_scroll.ritual = ritual_selected

	to_chat(last_activator, span_cult("You inscribe your vitae onto the paper using Thaumaturgy, allowing the scroll, and the ritual inscribed, to be used by unskilled thaumaturgists, or those without any skill in Thaumaturgy at all."))
	qdel(src)

/obj/item/thaumaturgy_scroll
	name = "thaumaturgy scroll"
	desc = "A scroll allowing non-thaumaturgists to use ritual thaumaturgy."
	icon = 'modular_darkpack/modules/ritual_thaumaturgy/icons/ritual_scroll.dmi'
	icon_state = "scroll"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/ritual_thaumaturgy/icons/onfloor.dmi')
	var/ritual

/obj/item/thaumaturgy_scroll/attack_self(mob/living/user)
	. = ..()
	if(!ritual)
		to_chat(user, span_cult("The scroll is blank - there is nothing to invoke."))
		return

	to_chat(user, span_cult("You unfurl the scroll and follow the instructions, invoking the '[initial(ritual:name)]' ritual."))

	var/obj/ritual_rune/R = new ritual(user.loc)
	R.required_discipline = null // no discipline required to use the ritual
	R.attack_hand(user)

	qdel(src)
