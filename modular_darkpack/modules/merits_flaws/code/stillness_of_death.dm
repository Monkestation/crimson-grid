/datum/quirk/darkpack/stillness_of_death
	name = "Stillness of Death"
	desc = "Some Gargoyles are able to take advantage of their unnatural appearance, undeath, stone-hued skin, and the affinity for rock and concrete in their discipline of Visceratika to hide themselves as if they were literal statues. Purchasing this merit allows a Gargoyle to enter 'statue form', allowing them to stand as still as a statue to prevent from breaching the Masquerade, and trick onlookers."
	value = 2
	mob_trait = TRAIT_STILLNESS_OF_DEATH
	gain_text = span_notice("You feel brave enough to hide by pretending to be a statue.")
	lose_text = span_notice("You don't want to hide as a statue anymore.")
	allowed_splats = list(SPLAT_KINDRED)
	included_clans = list(VAMPIRE_CLAN_GARGOYLE)
	icon = FA_ICON_MOUNTAIN
	failure_message = "You don't want to hide as a statue anymore."

/datum/quirk/darkpack/stillness_of_death/add_to_holder(mob/living/new_holder, quirk_transfer, client/client_source, unique, announce)
	. = ..()
	var/datum/action/gargoyle_statue_form/statue_action = new()
	statue_action.Grant(new_holder)

/datum/action/gargoyle_statue_form
	name = "Statue Form"
	desc = "Stand so still that your stony appearance fools passers by into thinking that you're simply a statue."
	button_icon = 'modular_darkpack/master_files/icons/hud/actions.dmi'
	button_icon_state = "gargoyle"
	var/active = FALSE
	var/original_name

/datum/action/gargoyle_statue_form/Trigger(trigger_flags)
	if(!owner)
		return

	if(active)
		deactivate_statue()
	else
		activate_statue()

/datum/action/gargoyle_statue_form/proc/activate_statue()
	if(!owner || active)
		return
	original_name = owner.name
	active = TRUE
	ADD_TRAIT(owner, TRAIT_IMMOBILIZED, "statue_form")
	ADD_TRAIT(owner, TRAIT_MUTE, "statue_form")
	REMOVE_TRAIT(owner, TRAIT_MASQUERADE_VIOLATING_FACE, CLAN_TRAIT)
	owner.name = "Statue of a Gargoyle"
	var/newcolor = list(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))
	owner.add_atom_colour(newcolor, FIXED_COLOUR_PRIORITY)

	to_chat(owner, span_notice("You transform into a stone statue, becoming immobile and silent."))

/datum/action/gargoyle_statue_form/proc/deactivate_statue()
	if(!owner || !active)
		return

	active = FALSE

	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, "statue_form")
	REMOVE_TRAIT(owner, TRAIT_MUTE, "statue_form")
	ADD_TRAIT(owner, TRAIT_MASQUERADE_VIOLATING_FACE, CLAN_TRAIT)

	owner.remove_atom_colour(FIXED_COLOUR_PRIORITY)
	owner.name = original_name

	to_chat(owner, span_notice("You return to your normal form."))

/datum/action/gargoyle_statue_form/Remove(mob/remove_from)
	if(active)
		deactivate_statue()
	return ..()
