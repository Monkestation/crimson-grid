/datum/mind
	/// Guestbook datum, in case we actually make use of the guestbook mechanics
	var/datum/guestbook/guestbook
	/// assigned when a player takes a job with a splat slot, stores the splat ID so if this var is non-null on cryo, we can increment the job datum's splat slots by one for this ID
	var/splat_slot_id

/datum/mind/New(_key)
	. = ..()
	guestbook = new()
	if(current?.real_name)
		LAZYADDASSOC(guestbook.known_names, current.real_name, current.real_name)

/datum/mind/Destroy()
	QDEL_NULL(guestbook)
	return ..()
