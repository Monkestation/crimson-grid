/obj/effect/decal/wallpaper
	name = "wall paint"
	icon = 'modular_darkpack/modules/walls/icons/wallpaper.dmi'
	icon_state = "wallpaper"
	plane = GAME_PLANE
	layer = ABOVE_NORMAL_TURF_LAYER	//WALLPAPER_LAYER dont work
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

// This sucks. Not within the scope of this pr to fix.
/obj/effect/decal/wallpaper/NeverShouldHaveComeHere(turf/here_turf)
	return FALSE

/obj/effect/decal/wallpaper/Initialize(mapload)
	. = ..()
	if(isclosedturf(loc))
		forceMove(get_step(src, SOUTH))
		pixel_y = 32

/obj/effect/decal/wallpaper/low
	icon_state = "wallpaper_low"

/obj/effect/decal/wallpaper/paint
	icon_state = "paint-white"

/obj/effect/decal/wallpaper/paint/low
	icon_state = "paint-white_low"

/obj/effect/decal/wallpaper/paint/gray
	icon_state = "paint-gray"

/obj/effect/decal/wallpaper/paint/gray/low
	icon_state = "paint-gray_low"

/obj/effect/decal/wallpaper/paint/red
	icon_state = "paint-red"

/obj/effect/decal/wallpaper/paint/red/low
	icon_state = "paint-red_low"

/obj/effect/decal/wallpaper/paint/yellow
	icon_state = "paint-yellow"

/obj/effect/decal/wallpaper/paint/yellow/low
	icon_state = "paint-yellow_low"

/obj/effect/decal/wallpaper/paint/green
	icon_state = "paint-green"

/obj/effect/decal/wallpaper/paint/green/low
	icon_state = "paint-green_low"

/obj/effect/decal/wallpaper/paint/blue
	icon_state = "paint-blue"

/obj/effect/decal/wallpaper/paint/blue/low
	icon_state = "paint-blue_low"

/obj/effect/decal/wallpaper/grey
	icon_state = "wallpaper-grey"

/obj/effect/decal/wallpaper/grey/low
	icon_state = "wallpaper-grey_low"

/obj/effect/decal/wallpaper/light
	icon_state = "wallpaper-light"

/obj/effect/decal/wallpaper/light/low
	icon_state = "wallpaper-light_low"

/obj/effect/decal/wallpaper/red
	icon_state = "wallpaper-asylum"

/obj/effect/decal/wallpaper/red/low
	icon_state = "wallpaper-asylum_low"

/obj/effect/decal/wallpaper/blue
	icon_state = "wallpaper-club"

/obj/effect/decal/wallpaper/blue/low
	icon_state = "wallpaper-club_low"

/obj/effect/decal/wallpaper/paper
	name = "wallpapers"
	icon_state = "wallpaper-cheap"

/obj/effect/decal/wallpaper/paper/low
	icon_state = "wallpaper-cheap_low"

/obj/effect/decal/wallpaper/paper/fancy
	icon_state = "wallpaper-greenfancy"

/obj/effect/decal/wallpaper/paper/fancy/low
	icon_state = "wallpaper-greenfancy_low"

/obj/effect/decal/wallpaper/paper/fancy/stripe
	icon_state = "wallpaper-stripesfancy"

/obj/effect/decal/wallpaper/paper/fancy/stripe/low
	icon_state = "wallpaper-stripesfancy_low"

/obj/effect/decal/wallpaper/paper/fancy/red
	icon_state = "wallpaper-redfancy"

/obj/effect/decal/wallpaper/paper/fancy/red/low
	icon_state = "wallpaper-redfancy_low"

/obj/effect/decal/wallpaper/paper/fancy/blue
	icon_state = "wallpaper-bluefancy"

/obj/effect/decal/wallpaper/paper/fancy/blue/low
	icon_state = "wallpaper-bluefancy_low"

/obj/effect/decal/wallpaper/paper/green
	icon_state = "wallpaper-green"

/obj/effect/decal/wallpaper/paper/green/low
	icon_state = "wallpaper-green_low"

/obj/effect/decal/wallpaper/paper/stripe
	icon_state = "wallpaper-stripe"

/obj/effect/decal/wallpaper/paper/stripe/low
	icon_state = "wallpaper-stripe_low"

/obj/effect/decal/wallpaper/paper/rich
	icon_state = "wallpaper-rich"

/obj/effect/decal/wallpaper/paper/rich/low
	icon_state = "wallpaper-rich_low"

/obj/effect/decal/wallpaper/paper/darkred
	icon_state = "wallpaper-dred"

/obj/effect/decal/wallpaper/paper/darkred/low
	icon_state = "wallpaper-dred_low"

/obj/effect/decal/wallpaper/paper/darkgreen
	icon_state = "wallpaper-dgreen"

/obj/effect/decal/wallpaper/paper/darkgreen/low
	icon_state = "wallpaper-dgreen_low"

/obj/effect/decal/wallpaper/paper/purple
	icon_state = "wallpaper-dpurple"

/obj/effect/decal/wallpaper/paper/purple/low
	icon_state = "wallpaper-dpurple_low"

/obj/effect/decal/wallpaper/stone
	name = "wall decoration"
	icon_state = "wallpaper-stone"

/obj/effect/decal/wallpaper/stone/low
	icon_state = "wallpaper-stone_low"

/obj/effect/decal/wallpaper/stone/low/tilt
	icon_state = "wallpaper-stone_low_tilt"

/obj/effect/decal/wallpaper/gold
	icon_state = "wallpaper-gold"

/obj/effect/decal/wallpaper/gold/alt
	icon_state = "wallpaper-gold_alt"

/obj/effect/decal/wallpaper/gold/low
	icon_state = "wallpaper-gold_low"

/obj/effect/decal/wallpaper/padded
	icon_state = "wallpaper-padded"

/obj/effect/decal/wallpaper/padded/low
	icon_state = "wallpaper-padded_low"

/obj/effect/decal/wallpaper/lightpadded
	icon_state = "wallpaper-lightpadded"

/obj/effect/decal/wallpaper/lightpadded/low
	icon_state = "wallpaper-lightpadded_low"

/obj/effect/decal/wallpaper/absorbingfoam
	icon_state = "absorbingfoam"

/obj/effect/decal/wallpaper/absorbingfoam/low
	icon_state = "absorbingfoam_low"

/obj/effect/decal/wallpaper/papers
	name = "papers"
	layer = SIGN_LAYER

/obj/effect/decal/wallpaper/papers/random
	icon_state = "wallpapers_1"

/obj/effect/decal/wallpaper/papers/random/Initialize(mapload)
	. = ..()
	if(icon_state == src::icon_state)
		icon_state = "wallpapers_[rand(1, 8)]"

/obj/effect/decal/wallpaper/papers/one
	icon_state = "wallpapers_1"

/obj/effect/decal/wallpaper/papers/two
	icon_state = "wallpapers_2"

/obj/effect/decal/wallpaper/papers/three
	icon_state = "wallpapers_3"

/obj/effect/decal/wallpaper/papers/four
	icon_state = "wallpapers_4"

/obj/effect/decal/wallpaper/papers/five
	icon_state = "wallpapers_5"

/obj/effect/decal/wallpaper/papers/six
	icon_state = "wallpapers_6"

/obj/effect/decal/wallpaper/papers/seven
	icon_state = "wallpapers_7"

/obj/effect/decal/wallpaper/papers/eight
	icon_state = "wallpapers_8"

/obj/effect/decal/wallpaper/trim
	icon_state = "trimgrey"

/obj/effect/decal/wallpaper/trim/green
	icon_state = "trimgreen"

/obj/effect/decal/wallpaper/trim/purple
	icon_state = "trimpurple"

/obj/effect/decal/wallpaper/stripes
	icon_state = "stripesgreen"

/obj/effect/decal/wallpaper/stripes/purple
	icon_state = "stripespurple"
