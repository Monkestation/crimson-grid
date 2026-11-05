#define CARGO_TRAIN_STORED 0
#define CARGO_TRAIN_ARRIVING 1
#define CARGO_TRAIN_DOCKED 2
#define CARGO_TRAIN_DEPARTING 3

/// One segment people can climb into while the train is docked.
/obj/cargotrain/boardable
	name = "cargo cart"
	desc = "A cargo cart. Its door looks usable while it's stopped."

/obj/cargotrain/boardable/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(SScargo_train.train_state != CARGO_TRAIN_DOCKED)
		balloon_alert(user, "it's moving!")
		return TRUE
	if(!SScargo_train.interior_entry)
		return TRUE
	if(user.pulling)
		var/atom/pulled = user.pulling
		user.pulling.forceMove(SScargo_train.interior_entry)
		user.start_pulling(pulled)
	user.forceMove(SScargo_train.interior_entry)
	return TRUE

/obj/structure/cargo_train_exit
	name = "cart door"
	desc = "Leads back out to the tracks."
	icon = 'modular_darkpack/modules/deprecated/icons/doors.dmi'
	icon_state = "old-1"
	anchored = TRUE

/obj/structure/cargo_train_exit/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(SScargo_train.train_state != CARGO_TRAIN_DOCKED)
		balloon_alert(user, "the train is moving!")
		return TRUE
	var/turf/exit = SScargo_train.get_exit_turf()
	if(exit)
		if(user.pulling)
			var/atom/pulled = user.pulling
			user.pulling.forceMove(exit)
			user.start_pulling(pulled)
		user.forceMove(exit)
	return TRUE

#undef CARGO_TRAIN_STORED
#undef CARGO_TRAIN_ARRIVING
#undef CARGO_TRAIN_DOCKED
#undef CARGO_TRAIN_DEPARTING
