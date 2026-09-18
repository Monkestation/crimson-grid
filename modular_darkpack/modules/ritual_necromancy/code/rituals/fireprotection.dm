/obj/ritual_rune/necromancy/fireprotection
	name = "chill of oblivion"
	desc = "Invite the cold of the Shadowlands into your soul to undo the body's fire-weakness. This profane blessing <b>taints the recipient's aura</b>."
	icon_state = "rune1"
	word = "DHAI'AD BHA'II DAWH'N"
	level = 4

/obj/ritual_rune/necromancy/fireprotection/complete()

	var/list/valid_bodies = list()

	for(var/mob/living/carbon/human/targetbody in loc)
		if(targetbody.stat == DEAD)
			to_chat(usr, span_warning("The target is dead, the cold has long settled inside."))
			return

		else valid_bodies += targetbody

	if(valid_bodies.len < 1)
		to_chat(usr, span_warning("The ritual's target must remain over the rune."))
		return

	var/mob/living/carbon/victim = pick(valid_bodies)

	if(victim.fakediablerist)
		to_chat(usr, span_warning("The ritual's target has already been claimed by the cold."))
		return

	playsound(loc, 'sound/effects/ghost.ogg', 50, FALSE)
	victim.emote("shiver")
	victim.Immobilize(4 SECONDS)

	to_chat(victim, span_revendanger("Burning ice bleeds out of your soul and into everything else. Paralyzed, you stand in the cold as death lingers."))
	victim.fakediablerist = TRUE
	//removing iscathayan from line 38 -- DAKPACK TODO -- readd KJs (iscathayan(victim))
	if(get_kindred_splat(victim) || victim.has_status_effect(/datum/status_effect/zombie)) //made this a deduction rather than a flat set because of an artifact that independently changes damage mods
		// Im not even certin this does anything for kindred waying heatmod only affects the breath you take and kindred shouldnt be breathing really.
		victim.dna.species.heatmod = max(0.5, victim.dna.species.heatmod-1) // This sucks why are we touching species for this.
	else
		victim.dna.species.heatmod = max(0.5, victim.dna.species.heatmod-0.5)
	qdel(src)
