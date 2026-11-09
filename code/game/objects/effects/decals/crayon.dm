/obj/effect/decal/cleanable/crayon
	name = "rune"
	desc = "Graffiti. Damn kids."
	icon = 'icons/effects/crayondecal.dmi'
	icon_state = "rune1"
	gender = NEUTER
	mergeable_decal = FALSE
	flags_1 = ALLOW_DARK_PAINTS_1
	var/do_icon_rotate = TRUE
	var/rotation = 0
	var/paint_colour = COLOR_WHITE
	///Used by `create_outline` to determine how strong (how wide) the outline itself will be.
	var/color_strength

/obj/effect/decal/cleanable/crayon/Initialize(mapload, main, type, e_name, graf_rot, alt_icon = null, desc_override = null, color_strength)
	. = ..()
	if(isclosedturf(loc) && loc.density)
		// allows for wall graffiti to be seen
		SET_PLANE_IMPLICIT(src, GAME_PLANE)
		layer = CLEANABLE_OBJECT_LAYER
	if(e_name)
		name = e_name
	if(desc_override)
		desc = "[desc_override]"
	else
		desc = "A [name] vandalizing the station."
	if(alt_icon)
		icon = alt_icon
	if(type)
		icon_state = type
	if(graf_rot)
		rotation = graf_rot
	if(rotation && do_icon_rotate)
		var/matrix/M = matrix()
		M.Turn(rotation)
		src.transform = M
	if(main)
		paint_colour = main
	src.color_strength = color_strength
	add_atom_colour(paint_colour, FIXED_COLOUR_PRIORITY)
	RegisterSignal(src, COMSIG_OBJ_PAINTED, PROC_REF(on_painted))

/obj/effect/decal/cleanable/crayon/NeverShouldHaveComeHere(turf/here_turf)
	return isgroundlessturf(here_turf)

/obj/effect/decal/cleanable/crayon/proc/on_painted(datum/source, mob/user, obj/item/toy/crayon/spraycan/spraycan, is_dark_color)
	SIGNAL_HANDLER
	var/cost = spraycan.all_drawables[icon_state] || CRAYON_COST_DEFAULT
	if (HAS_TRAIT(user, TRAIT_TAGGER))
		cost *= 0.5
	spraycan.use_charges(user, cost, requires_full = FALSE)
	return DONT_USE_SPRAYCAN_CHARGES

/**
 * Using a given atom, gives this decal an outline of said atom, then masks the contents,
 * leaving us with solely the outline.
 * This also deletes the previous icon, so the decal turns into JUST an outline.
 * Args:
 * outlined_atom: Anything you wish to draw an outline of.
 * add_mouse_opacity: Boolean on whether you want mouse opacity, which allows the outline to be clickable/examinable without the context menu.
 */
/obj/effect/decal/cleanable/crayon/proc/create_outline(atom/outlined_atom, add_mouse_opacity = FALSE)
	icon = null
	icon_state = null
	if(add_mouse_opacity)
		mouse_opacity = MOUSE_OPACITY_OPAQUE

	if(ishuman(outlined_atom))
		//humans are special, we want to exclude things like wounds so the outline isn't animated.
		var/mob/living/carbon/human/human_outline = outlined_atom
		add_overlay(human_outline.get_overlays_copy(list(WOUND_LAYER)))
	else
		icon = outlined_atom.icon
		icon_state = outlined_atom.icon_state
		copy_overlays(outlined_atom)
	transform = outlined_atom.transform
	dir = outlined_atom.dir
	add_filter("batong_outline", 1, outline_filter(color_strength, paint_colour))
	add_filter("alpha_mask", 2, alpha_mask_filter(
		icon = getFlatIcon(outlined_atom.appearance, defdir = outlined_atom.dir, no_anim = TRUE),
		flags = MASK_INVERSE,
	))

///Common crayon decals in map.
/obj/effect/decal/cleanable/crayon/rune4
	icon_state = "rune4"
	paint_colour = COLOR_CRAYON_RED

/obj/effect/decal/cleanable/crayon/rune2
	icon_state = "rune2"

/obj/effect/decal/cleanable/crayon/x
	icon_state = "x"
	name = "graffiti"
	paint_colour = COLOR_CRAYON_ORANGE

/obj/effect/decal/cleanable/crayon/l
	icon_state = "l"

/obj/effect/decal/cleanable/crayon/i
	icon_state = "i"

/obj/effect/decal/cleanable/crayon/e
	icon_state = "e"

/obj/effect/decal/cleanable/crayon/i/orange
	name = "graffiti"
	paint_colour = COLOR_CRAYON_ORANGE

/obj/effect/decal/cleanable/crayon/scribble
	icon_state = "scribble"

/obj/effect/decal/cleanable/crayon/scribble1
	icon_state = "scribble1"

/obj/effect/decal/cleanable/crayon/scribble2
	icon_state = "scribble2"

/obj/effect/decal/cleanable/crayon/scribble3
	icon_state = "scribble3"

/obj/effect/decal/cleanable/crayon/scribble4
	icon_state = "scribble4"

/obj/effect/decal/cleanable/crayon/scribble5
	icon_state = "scribble5"

/obj/effect/decal/cleanable/crayon/scribble6
	icon_state = "scribble6"

/obj/effect/decal/cleanable/crayon/scribble7
	icon_state = "scribble7"

/obj/effect/decal/cleanable/crayon/scribble8
	icon_state = "scribble8"

/obj/effect/decal/cleanable/crayon/scribble9
	icon_state = "scribble9"

/obj/effect/decal/cleanable/crayon/scribble10
	icon_state = "scribble10"

/obj/effect/decal/cleanable/crayon/scribble11
	icon_state = "scribble11"

/obj/effect/decal/cleanable/crayon/scribble12
	icon_state = "scribble12"

/obj/effect/decal/cleanable/crayon/scribble13
	icon_state = "scribble13"

/obj/effect/decal/cleanable/crayon/scribble14
	icon_state = "scribble14"

/obj/effect/decal/cleanable/crayon/scribble15
	icon_state = "scribble15"

/obj/effect/decal/cleanable/crayon/scribble16
	icon_state = "scribble16"

/obj/effect/decal/cleanable/crayon/scribble17
	icon_state = "scribble17"

/obj/effect/decal/cleanable/crayon/scribble18
	icon_state = "scribble18"

/obj/effect/decal/cleanable/crayon/scribble19
	icon_state = "scribble19"
