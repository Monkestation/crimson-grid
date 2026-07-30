GLOBAL_LIST_EMPTY(fuseboxes)

/datum/looping_sound/generator/fusebox
	volume = 8
	falloff_exponent = 4 //Ultra quiet very fast
	extra_range = -12
	falloff_distance = 1 //Instant falloff after initial tile

// The way this completely bypasses the entire power system is so strange
/obj/fusebox
	name = "fuse box"
	desc = "Power the controlled area with pure electricity."
	icon = 'modular_darkpack/modules/electricity/icons/electricity.dmi'
	icon_state = "fusebox"
	base_icon_state = "fusebox"
	layer = SIGN_LAYER
	anchored = TRUE
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	pixel_y = 32
	max_integrity = 100
	prevent_destruction = TRUE
	//Damage on the fusebox
	var/damaged = 0
	//Repairing var for the loop
	var/repairing = FALSE
	//Soundloop for Transformers
	var/datum/looping_sound/generator/fusebox/soundloop

/obj/fusebox/Initialize(mapload)
	. = ..()
	GLOB.fuseboxes += src

/obj/fusebox/atom_destruction(damage_flag)
	. = ..()
	power_off()


//they shouldnt really ever be destroyed, but...
/obj/fusebox/Destroy()
	GLOB.fuseboxes -= src
	return ..()

/obj/fusebox/update_icon_state()
	. = ..()
	if(atom_integrity <= 0)
		icon_state = "[base_icon_state]_off"
	else
		icon_state = base_icon_state

/obj/fusebox/proc/update_sound_state()
	if(!isnull(soundloop))
		if(atom_integrity <= 0)
			soundloop.stop()
		else
			soundloop.start(src)

/obj/fusebox/proc/power_off()
	var/area/power_area = get_area(src)
	power_area.power_light = FALSE
	power_area.power_equip = FALSE
	power_area.power_environ = FALSE
	power_area.power_change()
	power_area.fire_controled = FALSE
	var/datum/effect_system/basic/spark_spread/local_spark = new(get_turf(src), 5, 1)
	local_spark.start()
	for(var/obj/machinery/light/L in power_area)
		L.update(FALSE)
	playsound(loc, 'modular_darkpack/modules/electricity/sounds/generator_break.ogg', 100, TRUE)
	for(var/mob/living/M in range(1, src))
		M.electrocute_act(50, src, siemens_coeff = 1, flags = NONE)
	update_icon()
	update_sound_state()

/datum/storyteller_roll/fusebox_repair
	bumper_text = "electrical repair"
	applicable_stats = list(STAT_INTELLIGENCE, STAT_TECHNOLOGY)
	difficulty = 7
	numerical = TRUE

/obj/fusebox/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(tool.tool_behaviour == TOOL_WIRECUTTER)
		if(!repairing)
			repairing = TRUE
			if(!do_after(user, 10 SECONDS, src))
				repairing = FALSE
				return ITEM_INTERACT_BLOCKING

			var/datum/storyteller_roll/fusebox_repair/fusebox_roll = new()
			var/successes = fusebox_roll.st_roll(user, src)
			var/repair_amount = successes * 40
			if(repair_amount > 0)
				repair_damage(repair_amount)
				update_icon_state()
				update_sound_state()
				playsound(get_turf(src), 'modular_darkpack/modules/electricity/sounds/fusebox_fix.ogg', 50, FALSE)
				var/area/power_area = get_area(src)
				power_area.power_light = TRUE
				power_area.power_equip = TRUE
				power_area.power_environ = TRUE
				power_area.power_change()
				if(initial(power_area.fire_controled))
					power_area.fire_controled = TRUE
				for(var/obj/machinery/light/L in power_area)
					L.update(FALSE)

				repairing = FALSE
				return ITEM_INTERACT_SUCCESS
			if(repair_amount <= 0)
				user.electrocute_act(50, src, siemens_coeff = 1, flags = NONE)
				repairing = FALSE
	return NONE

// transformers (another type of fusebox)
/obj/fusebox/transformer
	name = "transformer"
	icon_state = "sstation"
	base_icon_state = "sstation"
	pixel_y = 0
	density = 1

/obj/fusebox/transformer/Initialize(mapload)
	. = ..()
	soundloop = new(src, TRUE)
