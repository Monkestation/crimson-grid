/datum/discipline/dementation
	name = "Dementation"
	desc = "Makes all humans in radius mentally ill for a moment, supressing their defending ability."
	icon_state = "dementation"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/dementation
	signature_clan = VAMPIRE_CLAN_MALKAVIAN

/datum/discipline/dementation/post_gain()
	. = ..()
	owner.add_quirk(/datum/quirk/darkpack/derangement)

/datum/discipline_power/dementation
	name = "Dementation power name"
	desc = "Dementation power description"

	activate_sound = 'modular_darkpack/modules/deprecated/sounds/insanity.ogg'

/datum/discipline_power/dementation/proc/remove_dementation_overlay(mob/living/carbon/human/target)
	target.remove_overlay(MUTATIONS_LAYER)

/*
From V20:
Passion
The vampire stirs his victim’s emotions, either
heightening them to a fevered pitch or blunting them
until the target is completely desensitized. The Cain-
ite may not choose which emotion is affected; she may
only amplify or dull emotions already present in the
target. In this way, a vampire can inflame mild irrita-
tion into quivering rage or atrophy true love into ca-
sual interest.

System: The character talks to their victim, and
the vampire’s player rolls Charisma + Empathy (dif-
ficulty equals the victim’s Humanity or Path rating).
The number of successes determines the duration of
the altered state of feeling. Effects of this power might
include one- or two-point additions or subtractions
to difficulties of frenzy rolls, Virtue rolls, rolls to resist
Presence powers, etc
*/
/datum/discipline_power/dementation/passion
	name = "Passion"
	desc = "Stir the deepest parts of your target to manipulate their psyche. Stuns target."
	level = 1
	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SPEAK
	target_type = TARGET_HUMAN
	range = 7
	multi_activate = TRUE
	cooldown_length = 2 TURNS
	duration_length = 1 TURNS
	vitae_cost = 1
	aggravating = TRUE
	hostile = TRUE
	var/dementation_phrase //will be filled when activated via tgui_input_text

/datum/discipline_power/dementation/passion/pre_activation_checks(mob/living/carbon/human/target)
	//var/theirpower = target.st_get_stat(STAT_MORALITY)
	var/mypower = SSroll.storyteller_roll(owner.st_get_stat(STAT_CHARISMA) + target.st_get_stat(STAT_EMPATHY), 6, owner)
	switch(mypower)
		if(ROLL_FAILURE, ROLL_BOTCH)
			to_chat(owner, span_warning("[target]'s mind is too powerful to influence!"))
			return FALSE
		if(ROLL_SUCCESS)
			dementation_phrase = tgui_input_text(owner, "What will you say to [target] to stir their emotions?")
			if(!dementation_phrase)
				to_chat(owner, span_warning("You must say something to your target to influence their emotions."))
				return FALSE
			return TRUE

/datum/discipline_power/dementation/passion/activate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/dementation_overlay = mutable_appearance('modular_darkpack/modules/deprecated/icons/icons.dmi', "dementation", -MUTATIONS_LAYER)
	dementation_overlay.pixel_z = 1
	target.overlays_standing[MUTATIONS_LAYER] = dementation_overlay
	target.apply_overlay(MUTATIONS_LAYER)
	target.Stun(duration_length)
	target.emote(pick("laugh","scream","cry")) // pick a random emotion for them to experience
	var/attack_text = spooky_font_replace(dementation_phrase) // malk-ify what the attacker said
	owner.say(attack_text, spans = list("bold", "singing")) // the malk speech uses bold and singing spans
	// TODO: when the derangement port is merged, update the sound paths here
	//owner.playsound_local(get_turf(H), pick('sound/items/SitcomLaugh1.ogg', 'sound/items/SitcomLaugh2.ogg', 'sound/items/SitcomLaugh3.ogg'), 100, FALSE)
	if(target.body_position == STANDING_UP)
		target.toggle_resting()

/datum/discipline_power/dementation/passion/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)


/*
From V20:
The Haunting
The vampire manipulates the sensory centers of their
victim’s brain, flooding the victim’s senses with visions,
sounds, scents, or feelings that aren’t really there. The
images, regardless of the sense to which they appeal,
are only fleeting “glimpses,” barely perceptible to the
victim. The vampire using Dementation cannot con-
trol what the victim perceives, but may choose which
sense is affected.

The “haunting” effects occur mainly when the vic-
tim is alone, and mostly at night. They may take the
form of the subject’s repressed fears, guilty memories,
or anything else that the Storyteller finds dramatically
appropriate. The effects are never pleasant or unobtru-
sive, however. The Storyteller should let her imagina-
tion run wild when describing these sensory impres-
sions; the victim may well feel as if she is going mad, or
as if the world is.

System: After the vampire speaks to the victim, the
player spends a blood point and rolls Manipulation +
Subterfuge (difficulty of his victim’s Perception + Self-
Control/Instinct). The number of successes determines
the length of the sensory “visitations.” The precise ef-
fects are up to the Storyteller, though particularly ee-
rie or harrowing apparitions can certainly reduce dice
pools for a turn or two after the manifestation.
*/
/datum/discipline_power/dementation/the_haunting
	name = "The Haunting"
	desc = "Manipulate your target's senses, making them perceive what isn't there."
	level = 2
	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SPEAK
	target_type = TARGET_HUMAN
	range = 7
	multi_activate = TRUE
	vitae_cost = 1
	cooldown_length = 3 TURNS
	duration_length = 2 TURNS //this determines how long the visual affected overlay will be applied to their mob sprite, not the hallucination duration
	aggravating = TRUE
	hostile = TRUE
	var/mypower
	var/dementation_phrase

/datum/discipline_power/dementation/the_haunting/pre_activation_checks(mob/living/carbon/human/target)
	var/resistence_stat = target.st_get_stat(STAT_SELF_CONTROL)
	if(get_kindred_splat(target))
		resistence_stat = target.st_get_stat(owner.is_enlightenment() ? STAT_CONVICTION : STAT_SELF_CONTROL)
	var/theirpower = target.st_get_stat(STAT_PERCEPTION) + resistence_stat
	mypower = SSroll.storyteller_roll(owner.st_get_stat(STAT_MANIPULATION) + owner.st_get_stat(STAT_SUBTERFUGE), theirpower, owner, numerical = TRUE)
	if(mypower <= 0)
		to_chat(owner, span_warning("[target]'s mind is too powerful to influence!"))
		return FALSE
	dementation_phrase = tgui_input_text(owner, "What will you say to [target] to haunt them?")
	if(!dementation_phrase)
		to_chat(owner, span_warning("You must say something to your target to haunt them."))
		return FALSE
	return TRUE

/datum/discipline_power/dementation/the_haunting/activate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/dementation_overlay = mutable_appearance('modular_darkpack/modules/deprecated/icons/icons.dmi', "dementation", -MUTATIONS_LAYER)
	dementation_overlay.pixel_z = 1
	target.overlays_standing[MUTATIONS_LAYER] = dementation_overlay
	target.apply_overlay(MUTATIONS_LAYER)
	target.cause_hallucination( \
			get_random_valid_hallucination_subtype(/datum/hallucination/delusion/preset), \
			"the haunting", \
			duration = 1 TURNS + (mypower SECONDS), \
			affects_us = FALSE, \
			affects_others = TRUE, \
			skip_nearby = FALSE, \
		)
	var/attack_text = spooky_font_replace(dementation_phrase)
	owner.say(attack_text, spans = list("bold", "singing"))

/datum/discipline_power/dementation/the_haunting/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)

/*
From V20:
Eyes of Chaos
This peculiar power allows the vampire to take ad-
vantage of the fleeting clarity hidden in insanity. She
may scrutinize the “patterns” of a person’s soul, the
convolutions of a vampire’s inner nature, or even ran-
dom events in nature itself. The Kindred with this
power can discern the most well-hidden psychoses, or
gain insight into a person’s true self. Malkavians with
this power often have (or claim to have) knowledge of
the moves and countermoves of the great Jyhad, or the
patterns of fate.

System: This power allows a vampire to determine a
person’s true Nature, among other things. The vampire
concentrates for a turn, then her player rolls Perception
+ Occult. The difficulty depends on the intricacy of the
pattern. Discerning the Nature of a stranger would be
difficulty 9, a casual acquaintance would be an 8, and
an established ally a 6. The vampire could also read
the message locked in a coded missive (difficulty 7), or
even see the doings of an invisible hand in such events
as the pattern of falling leaves (difficulty 6). Almost
anything might contain some hidden insight, no mat-
ter how trivial or meaningless. The patterns are pres-
ent in most things, but are often so intricate they can
keep a vampire spellbound for hours while she tries to
understand their message.

This is a potent power, subject to adjudication. Sto-
rytellers, this power is an effective way to introduce
plot threads for a chronicle, reveal an overlooked clue,
foreshadow important events, or communicate critical
149VAMPIRE THE MASQUERADE 20th ANNIVERSARY EDITION
information a player seeks. Important to its use, though,
is delivering the information properly. Secrets revealed
via Eyes of Chaos are never simple facts; they’re tanta-
lizing symbols adrift in a sea of madness. Describe the
results of this power in terms of allegory: “The man
before you appears as a crude marionette, with garish
features painted in bright stage makeup, and strings
vanishing up into the night sky.” Avoid stating plainly,
“You learn that this ghoul is the minion of a powerful
Methuselah.”
*/
/datum/discipline_power/dementation/eyes_of_chaos
	name = "Eyes of Chaos"
	desc = "See the hidden patterns in the world and uncover people's true selves."
	level = 3
	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SPEAK
	target_type = TARGET_HUMAN | TARGET_SELF
	range = 7
	multi_activate = TRUE
	cooldown_length = 5 TURNS
	duration_length = 1 TURNS
	activate_sound = null // dont play a sound
	vitae_cost = 5
	var/choice_options = list("Secrets", "Age")
	var/datum/tgui_window/eyes_of_chaos_window

/datum/discipline_power/dementation/eyes_of_chaos/proc/update_choices()
	for(var/i in choice_options)
		choice_options[i] = icon('icons/effects/effects.dmi', "quantum_sparks")

/datum/discipline_power/dementation/eyes_of_chaos/proc/open_chaos_eyes_window(mob/living/carbon/human/target)
	var/exploitable_information = sanitize_text(target.client?.prefs.read_preference(/datum/preference/text/exploitable))
	if(exploitable_information == EXPLOITABLE_DEFAULT_TEXT) //they havent set exploitable text
		exploitable_information = "You do not manage to uncover any secrets."
	to_chat(owner, span_notice("You search [target]'s mind... [exploitable_information]"))


/datum/discipline_power/dementation/eyes_of_chaos/proc/display_select_menu(mob/living/carbon/human/target)
	update_choices()
	var/chosen_option = show_radial_menu(owner, target, choice_options, target, radius = 36, tooltips = TRUE)
	if(!chosen_option)
		return FALSE
	if(!do_after(owner, 2 TURNS))
		return FALSE

	switch(chosen_option)
		if("Secrets")
			open_chaos_eyes_window(target)
		if("Age")
			var/total_age = target.chronological_age
			var/determined_age = "but can't seem to find anything."
			if(total_age < 100)
				determined_age = "[target] is less than a century old."
			else if(total_age < 200)
				determined_age = "[target] is in their second century."
			else
				determined_age = "[target] is an elder."
			to_chat(owner, span_abductor("You search [target]'s mind for information about their age... [determined_age]"))


/datum/discipline_power/dementation/eyes_of_chaos/pre_activation_checks(mob/living/carbon/human/target)
	var/mypower = SSroll.storyteller_roll(owner.st_get_stat(STAT_PERCEPTION) + owner.st_get_stat(STAT_OCCULT), 7, owner, numerical = FALSE)
	switch(mypower)
		if(ROLL_SUCCESS)
			return TRUE
		if(ROLL_FAILURE, ROLL_BOTCH)
			to_chat(owner, span_warning("[target]'s mind resists you!"))
			return FALSE

/datum/discipline_power/dementation/eyes_of_chaos/activate(mob/living/carbon/human/target)
	. = ..()
	display_select_menu(target)

/*
From V20:
Voice of Madness
By merely addressing their victims aloud, the Kindred
can drive targets into fits of blind rage or fear, forcing
them to abandon reason and higher thought. Victims
are plagued by hallucinations of their subconscious de-
mons, and try to flee or destroy their hidden shames.
Tragedy almost always follows in the wake of this pow-
er’s use, though offending Malkavians often claim that
they were merely encouraging people to act “according
to their natures.” Unfortunately for the vampire con-
cerned, he runs a very real risk of falling prey to their
own voice’s power.

System: The player spends a blood point and makes
a Manipulation + Empathy roll (difficulty 7). One tar-
get is affected per success, although all potential vic-
tims must be listening to the vampire’s voice.
Affected victims fly immediately into frenzy or a
blind fear like Rötschreck. Kindred or other creatures
capable of frenzy, such as Lupines, may make a frenzy
check or Rötschreck test (Storyteller’s choice as to how
they are affected) at +2 difficulty to resist the power.
Mortals are automatically affected and don’t remember
their actions while berserk. The frenzy or fear lasts for
a scene, though vampires and Lupines may test as usual
to snap out of it.

The vampire using Voice of Madness must also test
for frenzy or Rötschreck upon invoking this power,
though his difficulty to resist is one lower than nor-
mal. If the initial roll to invoke this power is a failure,
however, the roll to resist the frenzy is one higher than
normal. If the roll to invoke this power is a botch, the
frenzy or Rötschreck response is automatic.
*/

/datum/discipline_power/dementation/voice_of_madness
	name = "Voice of Madness"
	desc = "Your voice becomes a source of utter insanity, affecting you and all those around you."
	level = 4
	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SPEAK
	target_type = NONE
	range = 8
	vitae_cost = 1
	multi_activate = TRUE
	cooldown_length = 5 TURNS
	duration_length = 2 TURNS
	hostile = TRUE
	aggravating = TRUE
	violates_masquerade = TRUE
	var/dementation_phrase
	var/successes


//DARKPACK TODO - frenzy. this power requires it

/*
Affected victims fly immediately into frenzy or a
blind fear like Rötschreck. Kindred or other creatures
capable of frenzy, such as Lupines, may make a frenzy
check or Rötschreck test (Storyteller’s choice as to how
they are affected) at +2 difficulty to resist the power.


The vampire using Voice of Madness must also test
for frenzy or Rötschreck upon invoking this power,
though his difficulty to resist is one lower than normal. If the initial roll to invoke this power is a failure,
however, the roll to resist the frenzy is one higher than
normal. If the roll to invoke this power is a botch, the
frenzy or Rötschreck response is automatic.
*/
/datum/discipline_power/dementation/voice_of_madness/pre_activation_checks(mob/living/target)
	successes = SSroll.storyteller_roll(owner.st_get_stat(STAT_MANIPULATION) + owner.st_get_stat(STAT_EMPATHY), 7, owner, numerical = TRUE)
	if(successes >= 0)
		dementation_phrase = tgui_input_text(owner, "What will you say to cause people nearby to flee?")
		if(!dementation_phrase)
			to_chat(owner, span_warning("You must say something to use this discipline."))
			return FALSE
		return TRUE
	if(successes <= 0) // failure or botch, see above comment
		return FALSE



/datum/discipline_power/dementation/voice_of_madness/activate(mob/living/carbon/human/target)
	. = ..()
	var/attack_text = spooky_font_replace(dementation_phrase)
	owner.say(attack_text, spans = list("bold", "singing"))
	var/list/potential_targets = list()
	for(var/mob/living/carbon/human/hearer in (get_hearers_in_view(8, owner) - owner))
		if(!HAS_TRAIT(hearer, TRAIT_DEAF) || hearer.stat > CONSCIOUS)
			continue
		potential_targets += hearer
	var/targets_affected = 0
	while(targets_affected < successes && length(potential_targets)) //affects one target per success
		var/mob/living/carbon/human/chosen = pick(potential_targets)
		potential_targets -= chosen
		targets_affected++
		chosen.emote("scream")
		GLOB.move_manager.move_away(moving = chosen, chasing = owner, max_dist = 10, timeout = (duration_length * 2), delay = chosen.cached_multiplicative_slowdown)

		chosen.remove_overlay(MUTATIONS_LAYER)
		var/mutable_appearance/dementation_overlay = mutable_appearance('modular_darkpack/modules/deprecated/icons/icons.dmi', "dementation", -MUTATIONS_LAYER)
		dementation_overlay.pixel_z = 1
		chosen.overlays_standing[MUTATIONS_LAYER] = dementation_overlay
		chosen.apply_overlay(MUTATIONS_LAYER)
		addtimer(CALLBACK(src, PROC_REF(remove_dementation_overlay), chosen), duration_length)

/*
From V20:
Total Insanity
The vampire coaxes the madness from the deepest
recesses of their target’s mind, focusing it into an over-
whelming wave of insanity. This power has driven
countless victims, vampire and mortal alike, to unfor-
tunate ends.

System: The Kindred must gain their target’s undi-
vided attention for at least one full turn to enact this
power. The player spends a blood point and rolls Ma-
nipulation + Intimidation (difficulty of their victim’s
current Willpower points). If the roll is successful, the
victim is afflicted with five derangements of the Sto-
ryteller’s choice (see p. 290). The number of successes
determines the duration.
*/
//TOTAL INSANITY
/datum/discipline_power/dementation/total_insanity
	name = "Total Insanity"
	desc = "Bring out the darkest parts of a person's psyche, bringing them to utter insanity."
	level = 5
	vitae_cost = 1
	check_flags = DISC_CHECK_CAPABLE
	target_type = TARGET_HUMAN
	range = 7
	multi_activate = TRUE
	cooldown_length = 5 TURNS
	duration_length = 3 TURNS
	aggravating = TRUE
	hostile = TRUE
	var/mypower
	var/theirpower
	var/mob/living/carbon/human/attack_target

/datum/discipline_power/dementation/total_insanity/pre_activation_checks(mob/living/carbon/human/target)
	theirpower = target.st_get_stat(STAT_TEMPORARY_WILLPOWER)
	mypower = SSroll.storyteller_roll(owner.st_get_stat(STAT_MANIPULATION) + owner.st_get_stat(STAT_INTIMIDATION), theirpower, owner, numerical = TRUE)
	if(mypower <= 0)
		to_chat(owner, span_warning("[target]'s mind is too powerful to corrupt!"))
		return FALSE
	return TRUE

/datum/discipline_power/dementation/total_insanity/proc/self_attack(iteration)
	if(attack_target.stat > CONSCIOUS)
		return
	if(iteration <= 0)
		return
	attack_target.set_combat_mode(TRUE)
	var/obj/item/held_item = attack_target.get_active_held_item()
	if(held_item?.force)
		attack_target.ClickOn(attack_target)
	else
		if(held_item)
			attack_target.drop_all_held_items()
		attack_target.ClickOn(attack_target)
	addtimer(CALLBACK(src, PROC_REF(self_attack), iteration - 1), 1 SECONDS)

/datum/discipline_power/dementation/total_insanity/activate(mob/living/carbon/human/target)
	. = ..()
	attack_target = target
	attack_target.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/dementation_overlay = mutable_appearance('modular_darkpack/modules/deprecated/icons/icons.dmi', "dementation", -MUTATIONS_LAYER)
	dementation_overlay.pixel_z = 1
	attack_target.overlays_standing[MUTATIONS_LAYER] = dementation_overlay
	attack_target.apply_overlay(MUTATIONS_LAYER)

	addtimer(CALLBACK(src, PROC_REF(self_attack), max(mypower)), 0) // attack_target will attack themselves n times equaling the caster's manipulation + intimidation subtracted by the attack_target's willpower
	attack_target.cause_hallucination( \
			get_random_valid_hallucination_subtype(/datum/hallucination/delusion/preset), \
			"total insanity", \
			duration = duration_length + (mypower SECONDS), \
			affects_us = FALSE, \
			affects_others = TRUE, \
			skip_nearby = FALSE, \
		)
	addtimer(CALLBACK(src, PROC_REF(remove_dementation_overlay), attack_target), duration_length + (mypower SECONDS))
