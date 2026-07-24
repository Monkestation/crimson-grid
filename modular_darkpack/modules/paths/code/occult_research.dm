SUBSYSTEM_DEF(occult_research)
	name = "Occult Research"
	ss_flags = SS_BACKGROUND|SS_NO_INIT
	wait = 60 SECONDS // How often to process research points
	var/base_research_rate = 0.5 // Base points per tick
	var/necromancy_bonus = 0.5
	var/obtenebration_bonus = 0.5
	var/list/collected_blood //lazylist since i've noticed people haven't been using this feature so much
	COOLDOWN_DECLARE(research_notification_cooldown)

/datum/controller/subsystem/occult_research/fire(resumed = FALSE)
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!H.client)
			continue
		if(H.stat >= HARD_CRIT)
			continue
		if(!H.get_discipline(/datum/discipline/thaumaturgy))
			continue

		process_research_points(H)

/datum/controller/subsystem/occult_research/proc/process_research_points(mob/living/carbon/human/user)
	var/research_gain = base_research_rate

	//if this thaumaturge has successfully learned the magics of an outsider clan, they gain a research bonus
	for(var/datum/action/discipline/D in user.actions)
		if(!D || !D.discipline)
			continue

		switch(D.discipline.name)
			if("Necromancy")
				research_gain += necromancy_bonus
			if("Obtenebration")
				research_gain += obtenebration_bonus

		user.research_points += research_gain

	if(COOLDOWN_FINISHED(src, research_notification_cooldown))
		COOLDOWN_START(src, research_notification_cooldown, 10 MINUTES)
		to_chat(user, span_notice("Your occult studies have yielded [research_gain] research points. Total: [user.research_points]"))

GAME_VERB_PROC_DESC(/mob/living/carbon/human, check_research_points, "Check Research Points", "Check your current research point balance.", null)
	if(!get_discipline(/datum/discipline/thaumaturgy))
		to_chat(src, span_alert("You lack occult knowledge."))
		return

	to_chat(src, span_notice("You currently have [research_points] research points."))


/datum/controller/subsystem/occult_research/proc/process_blood_collection(mob/living/carbon/human/caster, datum/reagent/blood/blood_sample)
	if(!blood_sample || !blood_sample.data)
		return

	var/blood_data = blood_sample.data
	var/blood_splat = blood_data["splat"]
	var/blood_name = blood_data["real_name"]

	var/list/allowed_splats = list(SPLAT_KINDRED, SPLAT_GAROU, SPLAT_CORAX, SPLAT_GHOUL/*, SPLAT_KUEI_JIN*/)
	if(!(blood_splat in allowed_splats))
		return

	var/blood_identifier = "[blood_name]_[blood_splat]"

	// check if the bloods already been collected
	if(LAZYFIND(collected_blood, blood_identifier))
		to_chat(caster, span_notice("This blood was already identified."))
		return

	LAZYADD(collected_blood, blood_identifier)

	var/research_award = 0
	var/splat_name = ""
	var/research_message = ""

	if(blood_splat)
		var/datum/splat/splat_type = GLOB.splat_list[blood_splat]
		splat_name = splat_type::name

	switch(blood_splat)
		if(SPLAT_KINDRED)
			var/generation = blood_data["generation"]
			var/clan = blood_data["clan"]
			research_award = (GHOUL_GENERATION - generation) * 5
			research_message = "You gain new insights into the [splat_name] from clan [clan]! You gain [research_award] research points."
		if(SPLAT_GAROU)
			research_award = 30
			research_message = "You gain [research_award] research points."
		if(SPLAT_CORAX)
			research_award = 30
			research_message = "You gain [research_award] research points."
		if(SPLAT_GHOUL)
			research_award = 5
			research_message = "You gain [research_award] research points."
		/*
		if(SPLAT_KUEI_JIN)
			research_award = 15
			research_message = "You gain [research_award] research points."
		*/

	caster.research_points += research_award
	to_chat(caster, span_notice("[research_message]"))
