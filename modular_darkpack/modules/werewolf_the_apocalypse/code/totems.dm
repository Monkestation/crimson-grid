/obj/structure/werewolf_totem
	abstract_type = /obj/structure/werewolf_totem
	name = "tribe totem"
	desc = "Gives power to all Garou of that tribe."
	icon = 'modular_darkpack/modules/werewolf_the_apocalypse/icons/totems.dmi'
	icon_state = "wendigo"
	base_icon_state = "wendigo"
	anchored = TRUE
	density = TRUE

	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	max_integrity = 500 // Fuck you flav for having this orginally be snowflaked health

	// light_color = "#FFFFFF"
	light_range = 3
	light_power = 0.5
	damage_deflection = 5

	var/tribes = list()

	COOLDOWN_DECLARE(rage_notify_cd)

	var/turf/teleport_turf
	var/opening = FALSE


/obj/structure/werewolf_totem/Initialize(mapload)
	. = ..()
	var/list/candidates = list()
	for(var/obj/effect/landmark/teleport_mark/T in GLOB.landmarks_list)
		for(var/entry in T.tribes)
			if(entry in tribes)
				candidates += T
				break

	if(!length(candidates))
		if(mapload)
			log_mapping("[src] failed to find a candidate for an exit point.")
	else
		var/candidate = pick(candidates)
		teleport_turf = get_turf(candidate)
		qdel(candidate)
	GLOB.totems += src

	update_icon(UPDATE_ICON)

/obj/structure/werewolf_totem/update_icon_state()
	. = ..()

	if(broken)
		icon_state = "[base_icon_state]_broken"
	else
		icon_state = base_icon_state

/obj/structure/werewolf_totem/update_overlays()
	. = ..()

	var/mutable_appearance/totem_light_overlay = mutable_appearance(icon, "[icon_state]_overlay")
	SET_PLANE(totem_light_overlay, ABOVE_LIGHTING_PLANE, src)
	totem_light_overlay.color = light_color
	// totem_light_overlay.layer = ABOVE_LIGHTING_LAYER
	. += totem_light_overlay

/obj/structure/werewolf_totem/Destroy(force)
	. = ..()
	GLOB.totems -= src

/obj/structure/werewolf_totem/take_damage(damage_amount, damage_type = BRUTE, damage_flag = "", sound_effect = TRUE, attack_dir, armour_penetration = 0)
	. = ..()
	if(. && !broken)
		if(!COOLDOWN_FINISHED(src, rage_notify_cd))
			return .
		notify_fera(-damage_amount)
		COOLDOWN_START(src, rage_notify_cd, 5 SECONDS)

/obj/structure/werewolf_totem/atom_break(damage_flag)
	. = ..()
	break_totem()

/obj/structure/werewolf_totem/atom_destruction(damage_flag)
	SHOULD_CALL_PARENT(FALSE)
	break_totem()

/obj/structure/werewolf_totem/atom_fix()
	. = ..()
	set_light(initial(light_range))
	update_icon(UPDATE_ICON)
	notify_fera(1)

/obj/structure/werewolf_totem/proc/break_totem()
	if(broken)
		return
	broken = TRUE
	set_light(0)
	update_icon(UPDATE_ICON)
	var/obj/umbra_portal/prev = locate() in get_step(src, SOUTH)
	if(prev)
		collapse_portal(prev)
	notify_fera(-1)

/obj/structure/werewolf_totem/proc/notify_fera(damage_change)
	for(var/mob/living/carbon/human/human in GLOB.player_list)
		var/datum/splat/werewolf/shifter/shifter_splat = get_shifter_splat(human)
		if(!istype(shifter_splat))
			continue
		if(human.stat == DEAD)
			continue
		if(!(shifter_splat.tribe.name in tribes))
			continue

		if(damage_change < 0)
			if(broken)
				to_chat(human, span_userdanger("<b>YOUR TOTEM IS DESTROYED</b>"))
				SEND_SOUND(human, sound('sound/effects/tendril_destroyed.ogg', volume = 50))
				shifter_splat.adjust_gnosis(-5, FALSE)
			else
				to_chat(human, span_userdanger("<b>YOUR TOTEM IS BREAKING DOWN</b>"))
				SEND_SOUND(human, sound('modular_darkpack/modules/werewolf_the_apocalypse/sounds/bumps.ogg', volume = 50))
				shifter_splat.adjust_rage(1, FALSE)
		else
			to_chat(human, span_boldnotice("<b>YOUR TOTEM IS RESTORED</b>"))
			SEND_SOUND(human, sound('modular_darkpack/modules/werewolf_the_apocalypse/sounds/gifts/inspire.ogg', volume = 50))
			shifter_splat.adjust_gnosis(1, FALSE)

/obj/structure/werewolf_totem/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(user.combat_mode)
		attack_generic(user, rand(user.melee_damage_lower, user.melee_damage_upper))
	else
		var/datum/splat/werewolf/shifter/shifter_splat = get_shifter_splat(user)
		if(!istype(shifter_splat))
			return .
		if(broken)
			to_chat(user, span_warning("[src] is broken!"))
			return
		var/obj/umbra_portal/prev = locate() in get_step(src, SOUTH)
		if(!prev)
			if(shifter_splat.auspice.name == AUSPICE_THEURGE)
				if(!opening)
					opening = TRUE
					if(do_after(user, 10 SECONDS, src))
						spawn_portal()
					opening = FALSE
			else
				to_chat(user, span_warning("You need a Theurge to open the Moon Gates!"))
		else
			if(shifter_splat.auspice.name == AUSPICE_THEURGE)
				collapse_portal(prev)

/obj/structure/werewolf_totem/proc/spawn_portal()
	var/obj/umbra_portal/prev = locate() in get_step(src, SOUTH)
	if(prev)
		collapse_portal(prev)
	playsound(src, 'modular_darkpack/modules/deprecated/sounds/portal.ogg', 50, FALSE)
	var/obj/umbra_portal/U = new (get_step(src, SOUTH))
	// New code doesnt relay on ID for these two's connections buy why not.
	U.id = "[pick(tribes)][rand(1, 999)]"
	var/obj/umbra_portal/P = new (teleport_turf)
	P.id = U.id
	U.link_portal(P)

/obj/structure/werewolf_totem/proc/collapse_portal(obj/umbra_portal/old_portal)
	playsound(src, 'modular_darkpack/modules/deprecated/sounds/portal.ogg', 50, FALSE)
	qdel(old_portal.exit)
	qdel(old_portal)

/obj/structure/werewolf_totem/wendigo
	name = "\improper " + TRIBE_GALESTALKERS + " totem"
	tribes = list(TRIBE_GALESTALKERS)
	light_color = "#81ff4f"

/obj/structure/werewolf_totem/children_of_gaia
	name = "\improper " + TRIBE_CHILDREN_OF_GAIA + " totem"
	tribes = list(TRIBE_CHILDREN_OF_GAIA)
	light_color = "#00CEC8"

/obj/structure/werewolf_totem/bone_gnawer
	name = "\improper " + TRIBE_BONE_GNAWERS + " totem"
	light_color = "#FFA500"
	tribes = list(TRIBE_BONE_GNAWERS)

/obj/structure/werewolf_totem/glasswalker
	name = "\improper " + TRIBE_GLASS_WALKERS + " totem"
	icon_state = "glassw"
	base_icon_state = "glassw"
	light_color = "#35b0ff"
	tribes = list(TRIBE_GLASS_WALKERS)

/obj/structure/werewolf_totem/spiral
	name = "spiral totem"
	icon = 'modular_darkpack/modules/werewolf_the_apocalypse/icons/spiral_totem.dmi'
	icon_state = "spiral"
	base_icon_state = "spiral"
	light_color = "#ff5235"
	tribes = list(TRIBE_BLACK_SPIRAL_DANCERS)


/obj/structure/werewolf_totem/generic
	light_color = "#81ff4f"
	tribes = TRIBE_LIST_GAIA

/obj/structure/werewolf_totem/generic/wyld
	light_color = "#81ff4f"
	tribes = TRIBE_LIST_WYLD

/obj/structure/werewolf_totem/generic/weaver
	icon_state = "glassw"
	base_icon_state = "glassw"
	light_color = "#35b0ff"
	tribes = TRIBE_LIST_WEAVER

/obj/structure/werewolf_totem/generic/wyrm
	icon = 'modular_darkpack/modules/werewolf_the_apocalypse/icons/spiral_totem.dmi'
	icon_state = "spiral"
	base_icon_state = "spiral"
	light_color = "#ff5235"
	tribes = TRIBE_LIST_WYRM

/obj/structure/werewolf_totem/generic/alltribes
	tribes = TRIBE_LIST_ALL


// This things type path sucks
/obj/effect/landmark/teleport_mark
	name = "totem Exit Mark"
	icon_state = "portal_exit"
	var/tribes = list()

/obj/effect/landmark/teleport_mark/gaia
	tribes = TRIBE_LIST_GAIA

/obj/effect/landmark/teleport_mark/wyld
	tribes = TRIBE_LIST_WYLD

/obj/effect/landmark/teleport_mark/weaver
	tribes = TRIBE_LIST_WEAVER

/obj/effect/landmark/teleport_mark/wyrm
	tribes = TRIBE_LIST_WYRM

/obj/effect/landmark/teleport_mark/alltribes
	tribes = TRIBE_LIST_ALL
