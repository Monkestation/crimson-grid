/obj/effect/landmark/cargo_train_stop
	name = "cargo train stop"

/obj/effect/landmark/cargo_train_interior_entry
	name = "cargo train interior entry"

/// Where crates land inside the cart interior.
/obj/effect/abstract/cargo_train_spot
	name = "cargo train landing spot"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x2"
	invisibility = INVISIBILITY_ABSTRACT

/obj/effect/abstract/cargo_train_spot/Initialize(mapload)
	. = ..()
	SScargo_train.landing_spots += src

/obj/effect/abstract/cargo_train_spot/Destroy(force)
	SScargo_train.landing_spots -= src
	return ..()
