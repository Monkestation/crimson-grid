#define TRAIT_MESMERIZED "mesmerized"

/datum/discipline/dominate
	name = "Dominate"
	desc = "Suppresses will of your targets and forces them to obey you, if their will is not more powerful than yours."
	icon_state = "dominate"
	power_type = /datum/discipline_power/dominate
	var/list/botched_targets //a lazylist of weakrefs

/datum/discipline/dominate/post_gain()
	. = ..()
	if(level >= 4)
		RegisterSignal(owner, COMSIG_MOB_EMOTE, PROC_REF(on_snap))

/datum/discipline/dominate/proc/on_snap(atom/source, datum/emote/emote_args)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(handle_snap), source, emote_args)

/datum/discipline/dominate/proc/handle_snap(atom/source, datum/emote/emote_args)
	var/list/emote_list = list("snap", "snap2", "snap3", "whistle")
	if(!emote_list.Find(emote_args.key))
		return
	for(var/mob/living/carbon/human/target in get_hearers_in_view(6, owner))
		var/mob/living/carbon/human/conditioner = target.conditioner?.resolve()
		if(conditioner != owner)
			continue
		switch(emote_args.key)
			if("snap")
				target.SetSleeping(0)
				target.dir = get_dir(target, owner)
				target.emote("me", 1, "faces towards <b>[owner]</b> attentively.", TRUE)
				to_chat(target, span_danger("ATTENTION"))
			if("snap2")
				target.dir = get_dir(target, owner)
				target.Immobilize(50)
				target.emote("me",1,"flinches in response to <b>[owner]'s</b> snapping.", TRUE)
				to_chat(target, span_danger("HALT"))
			if("snap3")
				target.Knockdown(50)
				target.Immobilize(80)
				target.emote("me",1,"'s knees buckle under the weight of their body.",TRUE)
				target.do_jitter_animation(0.1 SECONDS)
				to_chat(target, span_danger("DROP"))
			if("whistle")
				target.apply_status_effect(STATUS_EFFECT_AWE, owner)
				to_chat(target, span_danger("HITHER"))


/datum/discipline_power/dominate
	name = "Dominate power name"
	desc = "Dominate power description"
	vitae_cost = 0 //No Dominate 1-5 abilities cost blood.

	activate_sound = 'modular_darkpack/modules/powers/sounds/dominate.ogg'

/datum/discipline_power/dominate/activate(mob/living/carbon/human/target)
	. = ..()

	var/mob/living/carbon/human/dominate_target = target
	dominate_target.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/dominate_overlay = mutable_appearance('modular_darkpack/modules/powers/icons/dominate.dmi', "dominate", -MUTATIONS_LAYER)
	dominate_overlay.pixel_z = 2
	dominate_target.overlays_standing[MUTATIONS_LAYER] = dominate_overlay
	dominate_target.apply_overlay(MUTATIONS_LAYER)

	//dominate compels the target to have their gaze absolutely entrapped by the dominator
	dominate_target.face_atom(owner)
	to_chat(dominate_target, span_danger("You find yourself completely entranced by the stare of [owner]. You can't bring yourself to look away, call for help, or even attempt resistance. Pray that someone comes to save you by dragging or pushing you away."))
	owner.face_atom(dominate_target)
	addtimer(CALLBACK(dominate_target, TYPE_PROC_REF(/mob/living/carbon/human, post_dominate_checks), dominate_target), 2 SECONDS)
	return TRUE

//dicerolling
//all dominate rolls involve rolling some stat against the victim's permanent willpower with many caveats. this proc rolls and considers those caveats
/datum/discipline_power/dominate/proc/dominate_check(mob/living/carbon/human/owner, mob/living/carbon/human/target, owner_stat, numerical = FALSE)
	var/datum/discipline/dominate/parent_disc = discipline

	if(HAS_TRAIT(owner, TRAIT_NO_EYE_CONTACT))
		to_chat(owner, span_warning("You are unable to make eye contact!"))
		return FALSE

	//someone has botched a dominate against this human
	if(LAZYLEN(parent_disc.botched_targets))
		for(var/datum/weakref/ref in parent_disc.botched_targets)
			var/mob/living/carbon/human/botched = ref.resolve()
			if(!botched)
				LAZYREMOVE(parent_disc.botched_targets, ref)
				continue
			if(botched == target)
				to_chat(owner, span_warning("Your previous botched attempt has made [target] resistant to your Dominate for the rest of the night."))
				return FALSE

	//automatically succeed against my conditioned servant
	var/mob/living/carbon/human/conditioner = target.conditioner?.resolve()
	if(owner == conditioner)
		if(numerical == TRUE)
			return 8
		else
			return TRUE

	if(HAS_TRAIT(target, TRAIT_CANNOT_RESIST_MIND_CONTROL))
		if(numerical == TRUE)
			return 8
		else
			return TRUE

	var/theirpower = target.st_get_stat(STAT_TEMPORARY_WILLPOWER)
	var/mypower = SSroll.storyteller_roll(owner_stat, difficulty = theirpower, roller = owner, numerical = TRUE)

	//tremere have built-in safeguards to easily dominate their stone servitors
	if(HAS_TRAIT(target, TRAIT_WEAK_TO_DOMINATE))
		theirpower -= 2

	if(HAS_TRAIT(target, TRAIT_WEAK_WILLED))
		theirpower -= 2

	//wearing dark sunglasses makes it harder for the Dominator to capture the victim's gaze and raises difficulty -- V20 'Dominate' section titled 'Eye Contact'
	var/total_tint = 0
	var/mob/living/carbon/human/human_target = target
	for(var/obj/item/clothing/worn_item in human_target.get_equipped_items(INCLUDE_ABSTRACT))
		total_tint += worn_item.tint

	if(total_tint > 0)
		if(total_tint >= 2)
			theirpower += 2
		else
			theirpower += 1

	//if anyone else tries to dominate my conditioned servant its much harder for them but not for me
	if(target.conditioner?.resolve())
		theirpower += 3

	//i've botched so now this person is immune to dominate for the rest of the round
	if(mypower < 0)
		LAZYADD(parent_disc.botched_targets, WEAKREF(target))
		to_chat(owner, span_warning("Your Dominate attempt has botched! [target] is now resistant to your Dominate for the rest of the night."))
		return FALSE

	var/datum/splat/vampire/kindred/owner_splat = get_kindred_splat(owner)
	var/datum/splat/vampire/kindred/target_splat = get_kindred_splat(target)
	if(target_splat)
		if(owner_splat.generation > target_splat.generation)
			to_chat(owner, span_warning("You fail to dominate [target], as their blood is more potent than yours!"))
			return FALSE

	if(HAS_TRAIT(target, TRAIT_MERIT_UNTAMABLE))
		to_chat(owner, span_warning("You fail to dominate [target], they are an untamable beast!"))
		return FALSE

	if(numerical == TRUE)
		return mypower

	//did we succeed or fail the roll
	return (mypower > 0)

//dominate involves capturing the victim's gaze, leaving them completely helpless as you hypnotically invade their mind.
/datum/discipline_power/dominate/proc/immobilize_target(mob/living/carbon/human/target, duration = 5 SECONDS)
	ADD_TRAIT(target, TRAIT_IMMOBILIZED, TRAIT_GENERIC)
	RegisterSignals(target, list(COMSIG_ATOM_ATTACKBY, COMSIG_MOB_ITEM_ATTACK, COMSIG_PROJECTILE_PREHIT), PROC_REF(on_target_attacked))
	if(do_after(owner, duration, target))
		release_target(target)
		return TRUE
	else
		release_target(target)
		return FALSE

/datum/discipline_power/dominate/proc/on_target_attacked(datum/source)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/target = source
	release_target(target)
	to_chat(owner, span_warning("Your concentration is broken as [target] is attacked!"))
	to_chat(target, span_warning("The mental hold on you breaks as you're attacked!"))

/datum/discipline_power/dominate/proc/release_target(mob/living/carbon/human/target)
	UnregisterSignal(target, list(COMSIG_ATOM_ATTACKBY, COMSIG_MOB_ITEM_ATTACK, COMSIG_PROJECTILE_PREHIT))
	to_chat(target, span_danger("You feel your concentration become your own once more, able to look away from the commanding gaze."))
	REMOVE_TRAIT(target, TRAIT_IMMOBILIZED, TRAIT_GENERIC)

/mob/living/carbon/human/proc/post_dominate_checks(mob/living/carbon/human/dominate_target)
	dominate_target?.remove_overlay(MUTATIONS_LAYER)

//COMMAND
/datum/discipline_power/dominate/command
	name = "Command"
	desc = "Speak one word and force others to obey."
	level = 1
	check_flags = DISC_CHECK_SPEAK|DISC_CHECK_SEE|DISC_CHECK_DIRECT_SEE
	target_type = TARGET_HUMAN
	cooldown_length = 15 SECONDS
	duration_length = 3 SECONDS
	range = 7
	var/successes
	var/custom_command = ""

//successes for dominate 1
/datum/discipline_power/dominate/command/proc/get_success_message(successes)
	switch(successes)
		if(1)
			return "mild vigor and short duration"
		if(2)
			return "normal compulsion"
		if(3)
			return "moderate vigor and extended duration"
		if(4)
			return "great vigor and long duration"
		if(5)
			return "supernatural vigor"
		else
			return "immediate and vigorous completion"

/datum/discipline_power/dominate/command/pre_activation_checks(mob/living/carbon/human/target)

	custom_command = tgui_input_text(owner, "Dominate Command", "What is your command?", encode = FALSE)
	owner.say(custom_command)

	successes = dominate_check(owner, target, owner.st_get_stat(STAT_MANIPULATION) + owner.st_get_stat(STAT_INTIMIDATION), numerical = TRUE)
	if(successes > 0)
		var/command_strength = get_success_message(successes)
		to_chat(owner, span_notice("You have the power to Command your target with [command_strength]!"))
		var/mob/living/carbon/human/conditioner = target.conditioner?.resolve()
		if(owner != conditioner)
			//V20 Dominate 'Command' section
			if(length(splittext(custom_command, " ")) > 1)
				to_chat(owner, span_warning("Commands must be only ONE word!"))
				return FALSE
		if(!custom_command)
			return FALSE
		return TRUE

	to_chat(owner, span_warning("[target] has resisted your domination!"))
	to_chat(target, span_warning("[owner] intensely stares at you."))
	do_cooldown(TRUE)
	return FALSE

/datum/discipline_power/dominate/command/activate(mob/living/carbon/human/target)
	. = ..()
	to_chat(owner, span_warning("You've successfully dominated [target]'s mind!"))
	log_combat(owner, target, "Dominated with Command: [custom_command]")
	to_chat(target, span_big("[custom_command]"))
	var/command_strength = get_success_message(successes)
	to_chat(target, span_warning("[owner] has successfully dominated your mind with [successes] successes. You feel compelled to [custom_command] with [command_strength]."))
	SEND_SOUND(target, sound('modular_darkpack/modules/powers/sounds/dominate.ogg'))

// MESMERIZE
/datum/discipline_power/dominate/mesmerize
	name = "Mesmerize"
	desc = "Plant a hypnotic suggestion in a target's head that will repeatedly echo in their mind."
	level = 2
	check_flags = DISC_CHECK_SPEAK|DISC_CHECK_SEE|DISC_CHECK_DIRECT_SEE
	target_type = TARGET_HUMAN
	cooldown_length = 30 SECONDS
	range = 7
	var/custom_message = ""
	var/pulse_interval
	var/datum/weakref/current_target_ref
	var/datum/weakref/end_action_ref
	var/pulse_active = FALSE

/datum/discipline_power/dominate/mesmerize/pre_activation_checks(mob/living/carbon/human/target)
	//you can't mesmerize someone already mesmerized
	if(HAS_TRAIT(target, TRAIT_MESMERIZED))
		to_chat(owner, span_warning("[target] is already under a hypnotic suggestion!"))
		return FALSE

	if(pulse_active)
		to_chat(owner, span_warning("You already have an active mesmerization!"))
		return FALSE

	var/successes = dominate_check(owner, target, owner.st_get_stat(STAT_MANIPULATION) + owner.st_get_stat(STAT_LEADERSHIP), numerical = TRUE)
	if(successes > 0)
		custom_message = tgui_input_text(owner, "Hypnotic Suggestion", "What hypnotic message will echo in their mind?", encode = FALSE)
		if(!custom_message)
			return FALSE
		pulse_interval = successes
		return TRUE
	pulse_interval = 0

	to_chat(owner, span_warning("[target] has resisted your domination!"))
	to_chat(target, span_warning("[owner] intensely stares at you."))

	do_cooldown(cooldown_length)
	return FALSE

/datum/discipline_power/dominate/mesmerize/activate(mob/living/carbon/human/target)
	. = ..()
	if(!immobilize_target(target, 10 SECONDS))
		to_chat(owner, span_warning("You have broken concentration with [target] while implanting your hypnosis!"))
		return
	target.throw_alert("mesmerize", /atom/movable/screen/alert/mesmerize)
	log_combat(owner, target, "Dominated with Mesmerize: [custom_message]")
	to_chat(owner, span_warning("You've successfully planted a hypnotic suggestion in [target]'s mind!"))
	owner.say(custom_message)
	to_chat(target, span_info("An urging, subconcious thought has entered your mind. Youre not sure how this happened - but it keeps pulsing, forcing your conscious thought to bend toward it."))
	to_chat(target, span_hypnophrase(custom_message))
	SEND_SOUND(target, sound('modular_darkpack/modules/powers/sounds/dominate.ogg'))
	current_target_ref = WEAKREF(target)
	ADD_TRAIT(target, TRAIT_MESMERIZED, TRAIT_GENERIC)

	//allow the dominator to end the mesmerization pulses early if the target completes the directive, assuming its an objective rather than a hypnotic suggestion (which is allowed)
	var/datum/action/vampire/end_mesmerization/end_action = new(owner, src)
	end_action.Grant(owner)
	end_action_ref = WEAKREF(end_action)
	pulse_active = TRUE
	start_mesmerization_cycle(target)

/datum/discipline_power/dominate/mesmerize/proc/start_mesmerization_cycle(mob/living/carbon/human/target)
	if(!pulse_active)
		return

	//the message pangs in the victim's mind every couple minutes depending on successes rolled.
	var/interval_minutes = max(1, 5 - pulse_interval)
	var/interval_deciseconds = interval_minutes * 60 * 10
	addtimer(CALLBACK(src, PROC_REF(mesmerization_pulse), target, interval_deciseconds, 1), interval_deciseconds)

/datum/discipline_power/dominate/mesmerize/proc/mesmerization_pulse(mob/living/carbon/human/target, interval, pulse_count)
	if(!pulse_active || !target || target.stat == DEAD)
		if(target)
			REMOVE_TRAIT(target, TRAIT_MESMERIZED, TRAIT_GENERIC)
		cleanup_mesmerization()
		return

	to_chat(target, span_hypnophrase("<font size='4'><b>[custom_message]</b></font>"))
	SEND_SOUND(target, sound('modular_darkpack/modules/powers/sounds/dominate.ogg', volume = 30))

	//once its pulsed 5 times, end the mesmerization. we don't need people seeing 'shit yourself' every minute til roundend.
	if(pulse_count >= 5)
		REMOVE_TRAIT(target, TRAIT_MESMERIZED, TRAIT_GENERIC)
		to_chat(target, span_notice("The hypnotic suggestion's pulsing fades, either taking root, or fading silently as your concious slowly returns to its natural state."))
		cleanup_mesmerization()
		return

	if(pulse_active)
		addtimer(CALLBACK(src, PROC_REF(mesmerization_pulse), target, interval, pulse_count + 1), interval)

//for use in the /datum/action/vampire/end_mesmerization
/datum/discipline_power/dominate/mesmerize/proc/force_end_mesmerization()
	var/mob/living/carbon/human/current_target = current_target_ref?.resolve()
	if(!current_target || !pulse_active)
		return
	pulse_active = FALSE
	REMOVE_TRAIT(current_target, TRAIT_MESMERIZED, TRAIT_GENERIC)
	to_chat(current_target, span_hypnophrase("<font size='4'><b>[custom_message]</b></font>"))
	to_chat(current_target, span_notice("The hypnotic suggestion's pulsing fades, either taking root, or fading silently as your concious slowly returns to its natural state."))
	current_target.clear_alert("mesmerize")
	cleanup_mesmerization()

/datum/discipline_power/dominate/mesmerize/proc/cleanup_mesmerization()
	var/mob/living/carbon/human/current_target = current_target_ref?.resolve()
	pulse_active = FALSE
	if(current_target)
		current_target.clear_alert("mesmerize")
	current_target_ref = null
	var/datum/action/vampire/end_mesmerization/action = end_action_ref?.resolve()
	if(action)
		action.Remove(owner)
	end_action_ref = null

/datum/action/vampire/end_mesmerization
	name = "End Mesmerization"
	desc = "Forcibly end your active mesmerization effect."
	button_icon_state = "dominate"
	var/datum/discipline_power/dominate/mesmerize/linked_power

/datum/action/vampire/end_mesmerization/New(Target, datum/discipline_power/dominate/mesmerize/power)
	..()
	linked_power = power

/datum/action/vampire/end_mesmerization/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return

	if(!linked_power)
		Remove(owner)
		return FALSE
	linked_power.force_end_mesmerization()

// THE FORGETFUL MIND
/datum/discipline_power/dominate/the_forgetful_mind
	name = "The Forgetful Mind"
	desc = "Invade a person's mind and recreate their memories."
	level = 3
	check_flags = DISC_CHECK_SPEAK|DISC_CHECK_SEE|DISC_CHECK_DIRECT_SEE
	target_type = TARGET_HUMAN
	cooldown_length = 1 MINUTES
	duration_length = 3 SECONDS
	range = 7
	var/custom_memory = ""
	var/successes

/datum/discipline_power/dominate/the_forgetful_mind/proc/get_success_message(successes)
	switch(successes)
		if(1)
			return "a single memory is permanently removed, and no alteration takes its place, leaving a void for the true memory to bubble up with the right circumstances"
		if(2)
			return "multiple memories may be permanently removed, but not altered, leaving a void for the true memories to potentially re-emerge with intense recollection"
		if(3)
			return "multiple memories may be permanently altered or removed, but without careful and precise alteration, the true memories may crawl forth much later"
		if(4)
			return "deep and intense alterations or removals may take place in the memory, changing entire events or conversations with great strength"
		if(5 to INFINITY)
			return "entire periods of life may be completely restructured or otherwise as the subconcious completely collapses"

/datum/discipline_power/dominate/the_forgetful_mind/pre_activation_checks(mob/living/carbon/human/target)

	successes = dominate_check(owner, target, owner.st_get_stat(STAT_WITS) + owner.st_get_stat(STAT_SUBTERFUGE), numerical = TRUE)
	if(successes > 0)
		var/mindwipe_strength = get_success_message(successes)
		to_chat(owner, span_notice("Your hypnotic glare captures [target] to the point where [mindwipe_strength]"))
		custom_memory = tgui_input_text(owner, "Memory Alteration", "What memory will you implant or alter?", encode = FALSE)
		if(!custom_memory)
			return FALSE
		return TRUE
	to_chat(owner, span_warning("[target] has resisted your domination!"))
	to_chat(target, span_warning("[owner] intensely stares at you."))
	do_cooldown(cooldown_length)
	return FALSE

/datum/discipline_power/dominate/the_forgetful_mind/activate(mob/living/carbon/human/target)
	. = ..()
	if(!immobilize_target(target, 10 SECONDS))
		to_chat(owner, span_danger("Youve broken concentration with [target] and your Domination fails..."))
		return
	log_combat(owner, target, "Dominated with The Forgetful Mind: [custom_memory]")
	to_chat(owner, span_warning("You've successfully invaded [target]'s mind and altered their memories!"))
	owner.say(custom_memory, forced = FALSE, bubble_type = SPEECH_BUBBLE_TYPE)
	to_chat(target, span_hypnophrase(custom_memory))
	SEND_SOUND(target, sound('modular_darkpack/modules/powers/sounds/dominate.ogg'))
	SEND_SIGNAL(target, COMSIG_ALL_MASQUERADE_REINFORCE)
	var/mindwipe_strength = get_success_message(successes)
	to_chat(target, span_warning("[owner] has successfully dominated your mind with [successes] success[successes == 1 ? "" : "es"]. Their hypnotism is so strong that [mindwipe_strength]"))

// CONDITIONING
/datum/discipline_power/dominate/conditioning
	name = "Conditioning"
	desc = "Break a person's mind over time and bend them to your will."
	level = 4
	check_flags = DISC_CHECK_SPEAK|DISC_CHECK_SEE|DISC_CHECK_DIRECT_SEE
	target_type = TARGET_HUMAN
	cooldown_length = 15 SECONDS
	duration_length = 6 SECONDS
	range = 2

/datum/discipline_power/dominate/conditioning/pre_activation_checks(mob/living/carbon/human/target)

	var/roll_success = dominate_check(owner, target, owner.st_get_stat(STAT_CHARISMA) + owner.st_get_stat(STAT_LEADERSHIP))
	if(!roll_success)
		to_chat(owner, span_warning("[target]'s mind has resisted your domination!"))
		do_cooldown(cooldown_length)
	return roll_success

/datum/discipline_power/dominate/conditioning/activate(mob/living/carbon/human/target)
	. = ..()
	target.dir = get_dir(target, owner)
	to_chat(target, span_danger("LOOK AT ME"))
	owner.say("Look at me.")
	if(!immobilize_target(target, 20 SECONDS))
		to_chat(owner, span_warning("Your concentration was broken!"))
		to_chat(target, span_notice("The oppressive mental presence suddenly withdraws."))
		return
	target.conditioner = WEAKREF(owner)
	target.throw_alert("conditioning", /atom/movable/screen/alert/conditioning)
	to_chat(target, span_hypnophrase("Your mind is filled with thoughts surrounding [owner]. Their every word and gesture carries immense weight to you."))
	SEND_SOUND(target, sound('modular_darkpack/modules/powers/sounds/dominate.ogg'))

// POSSESSION
/datum/discipline_power/dominate/possession
	name = "Possession"
	desc = "Take full control of your target's mind and body."
	level = 5
	check_flags = DISC_CHECK_SPEAK|DISC_CHECK_SEE|DISC_CHECK_DIRECT_SEE
	target_type = TARGET_HUMAN
	cooldown_length = 5 MINUTES
	range = 7
	var/datum/weakref/active_possession

/datum/discipline_power/dominate/possession/pre_activation_checks(mob/living/carbon/human/target)

	if(get_kindred_splat(target) || get_garou_splat(target)) //DARKPACK TODO: reimplement Kuei-Jin
		to_chat(owner, span_warning("You cannot possess [get_kindred_splat(target) ? "another kindred" : "this creature - the beast within resists"]!"))
		return FALSE

	if(target.possessed)
		to_chat(owner, span_warning("This mortal is already possessed!"))
		return FALSE

	var/roll_success = dominate_check(owner, target, owner.st_get_stat(STAT_CHARISMA) + owner.st_get_stat(STAT_INTIMIDATION))
	if(!roll_success)
		to_chat(owner, span_warning("[target] has resisted your domination!"))
		to_chat(target, span_warning("[owner] intensely stares at you."))
		do_cooldown(cooldown_length)
	return roll_success

/datum/discipline_power/dominate/possession/activate(mob/living/carbon/human/target)
	. = ..()
	target.dir = get_dir(target, owner)
	to_chat(target, span_danger("Your body freezes as an overwhelming presence invades your mind..."))

	to_chat(owner, span_warning("You begin weaving your consciousness into [target]'s mind..."))

	if(!immobilize_target(target, 30 SECONDS))
		to_chat(owner, span_warning("Your concentration was broken!"))
		to_chat(target, span_notice("The oppressive mental presence suddenly withdraws."))
		return
	var/datum/possession_controller/controller = new(owner, target, src)
	active_possession = WEAKREF(controller)
	to_chat(owner, span_warning("You have seized control of [target]'s body!"))
	to_chat(target, span_danger("Your consciousness is violently displaced as another mind takes control!"))
	target.possessed = TRUE
	log_combat(owner, target, "Possessed via Dominate Possession")
	SEND_SOUND(target, sound('modular_darkpack/modules/powers/sounds/dominate.ogg'))

//AUTONOMIC MASTERY
/datum/discipline_power/dominate/autonomic_mastery
	name = "Autonomic Mastery"
	desc = "Control the Autonomic Systems of a target."

	level = 6

	check_flags = DISC_CHECK_SPEAK|DISC_CHECK_SEE
	target_type = TARGET_HUMAN

	cooldown_length = 15 SECONDS
	range = 7

/datum/discipline_power/dominate/autonomic_mastery/pre_activation_checks(mob/living/carbon/human/target)

	var/roll_success = dominate_check(owner, target)
	if(roll_success)
		return TRUE
	else
		do_cooldown(cooldown_length)
		return FALSE

/datum/discipline_power/dominate/autonomic_mastery/activate(mob/living/carbon/human/target)
	. = ..()
	to_chat(owner, span_warning("You've successfully dominated [target]'s bodily functions!"))
	var/list/orders = list("Sleep", "Wake", "Heart Attack", "Revive")
	var/order = tgui_input_list(owner, "Select a Command","Command Selection", orders)
	if(!order)
		return
	switch(order)
		if("Sleep")
			owner.say("Sleep")
			target.Sleeping(200)
			to_chat(target, span_danger("You feel suddenly exhausted"))
			SEND_SOUND(target, sound('modular_darkpack/modules/powers/sounds/dominate.ogg'))
		if("Wake")
			owner.say("Wake")
			target.SetSleeping(0)
			to_chat(target, span_danger("You feel suddenly energetic"))
			SEND_SOUND(target, sound('modular_darkpack/modules/powers/sounds/dominate.ogg'))
		if("Heart Attack")
			owner.say("Die")
			target.adjust_stamina_loss(60, FALSE)
			target.set_heartattack(TRUE)
			to_chat(target, span_danger("You feel a terrible pain in your chest!"))
			SEND_SOUND(target, sound('modular_darkpack/modules/powers/sounds/dominate.ogg'))
		if("Revive")
			owner.say("Live")
			target.set_heartattack(FALSE)
			to_chat(target, span_danger("You feel your heart pound!"))
			target.revive()
			SEND_SOUND(target, sound('modular_darkpack/modules/powers/sounds/dominate.ogg'))

#undef TRAIT_MESMERIZED
