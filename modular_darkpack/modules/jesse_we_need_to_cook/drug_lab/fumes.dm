/obj/effect/particle_effect/fluid/smoke/lab_fumes
	name = "toxic fumes"
	color = "#a9c24a"
	opacity = FALSE
	lifetime = 15 SECONDS
	/// Toxin damage dealt to each exposed mob. smoke_mob is rate limited to once a second, so this is damage per second.
	var/tox_damage = 2

/// Smoke that spreads is created by the parent cloud, so it has to inherit the damage from it.
/obj/effect/particle_effect/fluid/smoke/lab_fumes/Initialize(mapload, datum/fluid_group/group, obj/effect/particle_effect/fluid/smoke/lab_fumes/parent)
	. = ..()
	if(istype(parent))
		tox_damage = parent.tox_damage

/obj/effect/particle_effect/fluid/smoke/lab_fumes/smoke_mob(mob/living/carbon/smoker, seconds_per_tick)
	. = ..()
	if(!.)
		return
	smoker.adjust_tox_loss(tox_damage)
	smoker.emote("cough")
	if(prob(25))
		to_chat(smoker, span_danger("The fumes burn your lungs!"))

/datum/effect_system/fluid_spread/smoke/lab_fumes
	effect_type = /obj/effect/particle_effect/fluid/smoke/lab_fumes
	/// Handed to the first cloud, and from there to everything that spreads from it.
	var/tox_damage = 2

/datum/effect_system/fluid_spread/smoke/lab_fumes/start(log = FALSE)
	var/start_loc = holder ? get_turf(holder) : location
	var/obj/effect/particle_effect/fluid/smoke/lab_fumes/fumes = new effect_type(start_loc, new /datum/fluid_group(amount))
	fumes.tox_damage = tox_damage
	if(log)
		help_out_the_admins(fumes, holder, location)
	fumes.spread() // Making the smoke spread immediately.
