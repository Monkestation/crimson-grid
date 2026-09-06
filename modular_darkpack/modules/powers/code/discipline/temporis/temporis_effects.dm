/obj/effect/temporis
	name = "Za Warudo"
	desc = "..."
	anchored = TRUE
	var/effect_alpha = 255
	var/effect_fadeout = 1 SECONDS

/obj/effect/temporis/Initialize(mapload, mob/living/creator)
	. = ..()

	name = creator?.name
	appearance = creator?.appearance
	dir = creator?.dir

	animate(src, pixel_x = rand(-32,32), pixel_y = rand(-32,32), alpha = effect_alpha, time = effect_fadeout)

	// Delete this effect after half a second
	QDEL_IN(src, effect_fadeout)

/obj/effect/temporis/patience_of_the_norns

/obj/effect/temporis/clothos_gift
	effect_alpha = 155
	effect_fadeout = 0.5 SECONDS

//VCG EDIT START - MARTIAL ARTS
/obj/effect/temporis/weskar
	effect_alpha = 155
	effect_fadeout = 0.3 SECONDS
//VCG EDIT END
