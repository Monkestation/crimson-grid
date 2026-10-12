/datum/guestbook/proc/on_examine(mob/living/examiner, mob/living/examined, result_combined)
	if(!istype(examiner) || !istype(examined))
		return

	var/datum/known_identity/identity = memorize_guy(examined)

	var/image/examined_image = image(icon = examined.icon, icon_state = examined.icon_state)
	examined_image.overlays = examined.overlays
	identity.last_examine_image = examined_image

	identity.last_examine_time = world.time
	identity.last_examine_block = result_combined

/datum/guestbook/proc/memorize_guy(mob/living/target)
	if(!istype(target))
		return

	if(known_identity_datums && known_identity_datums[target])
		return known_identity_datums[target]

	RegisterSignal(target, COMSIG_QDELETING, PROC_REF(retcon_guy))

	var/datum/known_identity/new_entry = new()
	LAZYSET(known_identity_datums, target, new_entry)

	return new_entry

/datum/guestbook/proc/unmemorize_guy(mob/living/target)
	UnregisterSignal(target, COMSIG_QDELETING)
	LAZYREMOVE(known_identity_datums, target)

/datum/guestbook/proc/retcon_guy(mob/living/source)
	SIGNAL_HANDLER

	unmemorize_guy(source)

/datum/guestbook/proc/pick_known_guy(mob/living/user)
	RETURN_TYPE(/mob/living)

	var/list/choosable_targets = list()
	var/list/possible_chooseable_atoms = list()

	for(var/mob/living/known_guy as anything in known_identity_datums)
		choosable_targets[GET_GUESTBOOK_NAME(user, known_guy)] = known_identity_datums[known_guy].last_examine_image
		possible_chooseable_atoms[GET_GUESTBOOK_NAME(user, known_guy)] = known_guy

	var/name_choice = show_radial_menu(
		user,
		user,
		choosable_targets,
		radius = 40,
		require_near = TRUE,
		tooltips = TRUE,
		autopick_single_option = FALSE,
	)

	if(isnull(name_choice))
		return null

	return possible_chooseable_atoms[name_choice]


/datum/known_identity
	var/last_examine_time
	var/last_examine_image
	var/last_examine_block
