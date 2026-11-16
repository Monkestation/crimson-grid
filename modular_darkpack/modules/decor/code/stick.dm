/datum/storyteller_roll/avoid_stick
	bumper_text = "avoid stick"
	applicable_stats = list(STAT_PERCEPTION, STAT_STEALTH)
	roll_output_type = ROLL_FLAG_ROLLER
	roll_output_type_on_fail = ROLL_PUBLIC
	spammy_roll = TRUE

/obj/effect/mine/stick
	name = "stick"
	desc = "Sticky."
	icon = 'modular_darkpack/modules/decor/icons/stick.dmi'
	icon_state = "stick1"
	base_icon_state = "stick"
	var/stick_type = 0
	var/variants = 7 // Change this if you add new stick variants (lol)
	var/static/list/soundlist = list(
		'modular_darkpack/modules/decor/sound/stick_snap1.ogg',
		'modular_darkpack/modules/decor/sound/stick_snap2.ogg',
		'modular_darkpack/modules/decor/sound/stick_snap3.ogg',
		'modular_darkpack/modules/decor/sound/stick_snap4.ogg',
		'modular_darkpack/modules/decor/sound/stick_snap5.ogg',
		'modular_darkpack/modules/decor/sound/stick_snap6.ogg')

/obj/effect/mine/stick/Initialize(mapload)
	. = ..()
	if(!stick_type)
		stick_type = rand(1,variants)

	icon_state = "[base_icon_state][stick_type]"

	var/matrix/M = matrix()
	M.Turn(rand(0, 360))
	transform = M

	if(!pixel_x && !pixel_y)
		pixel_x = rand(-8, 8)
		pixel_y = rand(-8, 8)

/obj/effect/mine/stick/on_entered(datum/source, atom/movable/arrived, atom/old_loc)
	triggermine(arrived)

/obj/effect/mine/stick/on_exited(datum/source, atom/movable/gone, direction)
	return

/obj/effect/mine/stick/triggermine(atom/movable/triggerer)
	if(triggered) //too busy detonating to detonate again
		return

	if(ismob(triggerer))
		if(isliving(triggerer))
			var/mob/living/stepper = triggerer
			if(stepper.mob_size >= MOB_SIZE_HUMAN)
				var/roll_result = SSroll.storyteller_roll_datum(triggerer, src, /datum/storyteller_roll/avoid_stick)
				if(roll_result != ROLL_SUCCESS)
					mineEffect(triggerer)

	if(isitem(triggerer))
		var/obj/item/big_rock = triggerer
		if(big_rock.w_class >= WEIGHT_CLASS_NORMAL)
			mineEffect(triggerer)

	SEND_SIGNAL(src, COMSIG_MINE_TRIGGERED, triggerer)

/obj/effect/mine/stick/mineEffect(atom/movable/victim)
	if(HAS_TRAIT(victim, TRAIT_LIGHT_STEP))
		return
	if(prob(33))
		triggered = TRUE
	for(var/mob/guy in hearers(7, src))
		to_chat(guy, span_danger("*snap*"))
		playsound(src, pick(soundlist), 75, TRUE, 4, frequency = rand(0.8, 1.2))
		icon_state = "[base_icon_state][stick_type]-snapped"

/obj/effect/mine/stick/attack_hand(mob/living/user)
	. = ..()
	to_chat(user, span_notice("You discard [src]."))
	qdel(src)

/obj/effect/mine/stick/fire_act()
	new /obj/effect/decal/cleanable/ash(src.loc)
	qdel(src)

/obj/effect/mine/stick/one
	icon_state = "stick1"
	stick_type = 1

/obj/effect/mine/stick/two
	icon_state = "stick2"
	stick_type = 2

/obj/effect/mine/stick/three
	icon_state = "stick3"
	stick_type = 3

/obj/effect/mine/stick/four
	icon_state = "stick4"
	stick_type = 4

/obj/effect/mine/stick/five
	icon_state = "stick5"
	stick_type = 5

/obj/effect/mine/stick/six
	icon_state = "stick6"
	stick_type = 6

/obj/effect/mine/stick/seven
	icon_state = "stick7"
	stick_type = 7
