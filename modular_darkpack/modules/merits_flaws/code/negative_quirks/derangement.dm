
#define FLOOR_DISAPPEAR 3 SECONDS

/datum/quirk/darkpack/derangement
	name = "Derangement"
	desc = "Suffer from a permanent, incurable derangement that alters your perception."
	icon = FA_ICON_HOUSE_MEDICAL_CIRCLE_EXCLAMATION
	gain_text = span_hypnophrase("You feel off...")
	lose_text = span_notice("You start to feel normal again...")
	medical_record_text = "Patient suffers from a treatment-resistant mental illness."
	value = -8
	hardcore_value = 6
	quirk_flags = QUIRK_PROCESSES
	mob_trait = TRAIT_SHIFTY_EYES // they're deranged, so give them the trait that tells people around them about their crazy eyes
	mail_goodies = list(/obj/effect/spawner/random/contraband/narcotics) // happy pills! :)
	excluded_clans = list(VAMPIRE_CLAN_MALKAVIAN)
	var/process_interval = 3 SECONDS
	var/list/derangements
	COOLDOWN_DECLARE(next_process)

/datum/quirk/darkpack/derangement/add()
	derangements = subtypesof(/datum/hallucination/malk)

/datum/quirk/darkpack/derangement/process(seconds_per_tick)
	if(!quirk_holder.client)
		return
	if(!COOLDOWN_FINISHED(src, next_process))
		return
	if(SPT_PROB(2, seconds_per_tick))
		quirk_holder.cause_hallucination( \
			pick(derangements), \
			"derangement", \
		)
	COOLDOWN_START(src, next_process, process_interval)
	handle_malk_floors()

// largely taken from https://github.com/The-Final-Nights/The-Final-Nights/pull/287
// based on the work of maaacha
/datum/quirk/darkpack/derangement/proc/handle_malk_floors()
	if(!quirk_holder?.client)
		return
	//Floors go crazy go stupid
	for(var/turf/open/floor in view(quirk_holder))
		if(!prob(7))
			continue
		if(isgroundlessturf(floor))
			continue
		handle_malk_floor(floor)

/datum/quirk/darkpack/derangement/proc/handle_malk_floor(turf/open/floor)
	var/mutable_appearance/fake_floor = image(floor.icon, floor, floor.icon_state, floor.layer)
	quirk_holder?.client.images += fake_floor
	var/offset = pick(-3,-2, -1, 1, 2, 3)
	var/disappearfirst = rand(1 SECONDS, 3 SECONDS) * abs(offset)
	animate(fake_floor, pixel_y = offset, time = disappearfirst, flags = ANIMATION_RELATIVE)
	addtimer(CALLBACK(src, PROC_REF(malk_floor_stage1), quirk_holder, offset, fake_floor), disappearfirst, TIMER_CLIENT_TIME)

/datum/quirk/darkpack/derangement/proc/malk_floor_stage1(mob/living/malk, offset, mutable_appearance/fake_floor)
	animate(fake_floor, pixel_y = -offset, time = FLOOR_DISAPPEAR, flags = ANIMATION_RELATIVE)
	addtimer(CALLBACK(src, PROC_REF(malk_floor_stage2), malk, fake_floor), FLOOR_DISAPPEAR, TIMER_CLIENT_TIME)

/datum/quirk/darkpack/derangement/proc/malk_floor_stage2(mob/living/malk, mutable_appearance/fake_floor)
	malk.client?.images -= fake_floor

/datum/hallucination/malk
	random_hallucination_weight = 0 // so it doesn't show up for kine that drink absinthe or something

/datum/hallucination/malk/ambience

/datum/hallucination/malk/ambience/start()
	var/static/list/ambient_sounds = list(
		'modular_darkpack/modules/powers/sounds/dementation/comic1.ogg',
		'modular_darkpack/modules/powers/sounds/dementation/comic2.ogg',
		'modular_darkpack/modules/powers/sounds/dementation/comic3.ogg',
		'modular_darkpack/modules/powers/sounds/dementation/comic4.ogg',
		'modular_darkpack/modules/powers/sounds/dementation/man_cry.ogg',
		'modular_darkpack/modules/powers/sounds/dementation/woman_cry.ogg',
		'modular_darkpack/modules/powers/sounds/dementation/child_cry.ogg',
		'modular_darkpack/modules/powers/sounds/dementation/man_moan.ogg', // zombie like moaning sounds
		'modular_darkpack/modules/powers/sounds/dementation/woman_moan.ogg',
		'modular_darkpack/modules/powers/sounds/dementation/evillaugh.ogg'
	)
	hallucinator.playsound_local(hallucinator, pick(ambient_sounds), vol = 20, vary = FALSE)

/datum/hallucination/malk/object
	var/static/list/audible_hallucinations = GLOB.derangement_phrases

/datum/hallucination/malk/object/start()
	var/list/objects = list()

	for(var/obj/object in view(hallucinator))
		if((object.invisibility > hallucinator.see_invisible) || !object.loc || !object.name || (object in hallucinator.contents))
			continue
		var/weight = 1
		if(isitem(object))
			weight = 3
		else if(isstructure(object))
			weight = 2
		else if(ismachinery(object))
			weight = 2
		objects[object] = weight
	if(!length(objects))
		return

	var/obj/speaker = pick_weight(objects)
	var/speech = spooky_font_replace(pick(audible_hallucinations))
	var/language = hallucinator.get_random_understood_language()
	var/message = hallucinator.compose_message(speaker, language, speech)
	hallucinator.playsound_local(hallucinator, audible_hallucinations[speech], vol = 20, vary = TRUE)
	if(hallucinator.client.prefs.read_preference(/datum/preference/toggle/see_rc_emotes))
		hallucinator.create_chat_message(speaker, language, speech, spans = list("italics"))
	to_chat(hallucinator, span_cult_italic(message))

	return TRUE

// override for the your_mother hallucination for malkavians
/datum/hallucination/your_mother/malk
	var/malk_file = "~darkpack/malk_mother_hallucination.json" //malkavian specific file
	mother = /obj/effect/client_image_holder/hallucination/your_mother/malk

/datum/hallucination/your_mother/malk/start()
	var/mob/living/carbon/human/malk = hallucinator
	var/age = malk.chronological_age
	if(!malk.client || malk.stat >= UNCONSCIOUS)
		return FALSE

	var/list/spawn_locs = list()
	for(var/turf/open/floor in view(malk, 4))
		if(floor.is_blocked_turf(exclude_mobs = TRUE))
			continue
		spawn_locs += floor

	if(!length(spawn_locs))
		return FALSE
	var/turf/spawn_loc = pick(spawn_locs)
	mother = new /obj/effect/client_image_holder/hallucination/your_mother/malk(spawn_loc, malk, src)
	mother.AddComponent(/datum/component/leash, owner = malk, distance = get_dist(malk, mother)) //basically makes mother follow them
	point_at(malk)
	talk("[capitalize(malk.real_name)]!!") // Your mother won't be fooled by paltry disguises
	var/list/scold_lines = list(
		pick_list_replacements(malk_file, "do_something"),
		pick_list_replacements(malk_file, "be_upset"),
		pick_list_replacements(malk_file, "get_reprimanded"),
	)

	if(age >= 50)
		scold_lines = list(
			pick_list_replacements(malk_file, "do_something_old"),
			pick_list_replacements(malk_file, "be_upset"),
			pick_list_replacements(malk_file, "get_reprimanded_old"),
		)
	var/delay = 4 SECONDS
	for(var/line in scold_lines)
		addtimer(CALLBACK(src, PROC_REF(talk), line), delay)
		delay += 5 SECONDS
	addtimer(CALLBACK(src, PROC_REF(exit)), delay + 10 SECONDS)
	return TRUE


/obj/effect/client_image_holder/hallucination/your_mother/malk
	gender = FEMALE
	image_icon = 'icons/mob/simple/simple_human.dmi'
	name = "your mother"
	desc = "... but, that can't be her, can it?"
	image_state = ""

/obj/effect/client_image_holder/hallucination/your_mother/malk/Initialize(mapload, list/mobs_which_see_us, datum/hallucination/parent)
	var/mob/living/carbon/human/hallucinator = parent.hallucinator
	var/outfits = subtypesof(/datum/outfit/mafia)
	if (ishuman(hallucinator))
		var/mob/living/carbon/dna_haver = hallucinator
		image_icon = image(get_dynamic_human_appearance(pick(outfits), dna_haver.dna.species.type))
		return ..()

	image_icon = hallucinator.icon
	image_state = hallucinator.icon_state
	image_pixel_x = hallucinator.pixel_x
	image_pixel_y = hallucinator.pixel_y
	return ..()

// the random hallucination type will store overrides and extensions of basegame hallucinations, as well as untouched basegame hallucinations like eyes_in_the_dark
/datum/hallucination/malk/random
	var/list/hallucinations = list(/datum/hallucination/eyes_in_dark, /datum/hallucination/your_mother/malk, /datum/hallucination/blood_flow/malk)

/datum/hallucination/malk/random/start()
	hallucinator.cause_hallucination(pick(hallucinations), "malkavian derangement")
	return TRUE

// 'Blood Flow'
/datum/hallucination/blood_flow/malk
	random_hallucination_weight = 0

/datum/hallucination/blood_flow/malk/by_god()
	if(QDELETED(src) || QDELETED(hallucinator) || QDELETED(bleeding_bodypart))
		return

	to_chat(hallucinator, span_warning("The blood doesn't stop flowing from my injury, yet it doesn't seem to hurt..."))

#undef FLOOR_DISAPPEAR
