/datum/discipline/mytherceria
	name = "Mytherceria"
	desc = {"Mytherceria is a Discipline that manifests in faerie-blooded vampires such as the Kiasyd and Maeghar. It grants the vampire mystical senses, the ability to steal knowledge, and other powers attributed to fae.
● Fey Sight: Passive
●● Darkling Trickery: Passive
●●● Goblinism: Passive
●●●● Chanjelin Ward: Passive
●●●●● Riddle Phantastique: Passive"}
	icon_state = "mytherceria"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/mytherceria

/datum/discipline_power/mytherceria
	name = "Mytherceria power name"
	desc = "Mytherceria power description"

	activate_sound = 'modular_darkpack/modules/deprecated/sounds/kiasyd.ogg'

//FEY SIGHT
/datum/discipline_power/mytherceria/fey_sight
	name = "Fey Sight"
	desc = "Sense magical items on another person."

	level = 1
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE
	target_type = TARGET_MOB
	range = 7

	cooldown_length = 10 SECONDS

/datum/discipline_power/mytherceria/fey_sight/activate(mob/living/target)
	. = ..()
	to_chat(owner, span_purple("Your fae senses reach out to detect what they're carrying..."))
	for(var/obj/item/item in target.get_all_contents())
		if(isorgan(item) || isbodypart(item))
			continue
		to_chat(owner, "- [item.name]")

//DARKLING TRICKERY
/datum/discipline_power/mytherceria/darkling_trickery
	name = "Darkling Trickery"
	desc = "Steal trinkets from your victims from afar."

	level = 2
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_FREE_HAND | DISC_CHECK_LYING
	target_type = TARGET_LIVING
	range = 3

	cooldown_length = 30 SECONDS

/datum/discipline_power/mytherceria/darkling_trickery/activate(mob/living/target)
	. = ..()

	var/list/choices = list()
	for(var/obj/item/thing in target.get_all_contents())
		if(isorgan(thing) || isbodypart(thing))
			continue
		choices[thing.name] = thing

	if(!length(choices))
		to_chat(owner, span_warning("[target] has nothing to steal."))
		return

	var/picked_name = tgui_input_list(owner, "Choose an item to steal", "Darkling Trickery", choices)
	var/obj/item/stolen_item = choices[picked_name]
	if(QDELETED(stolen_item) || !(stolen_item in target.get_all_contents()))
		return

	stolen_item.remove_item_from_storage(get_turf(owner), owner)
	owner.put_in_hands(stolen_item)

//GOBLINISM
/datum/discipline_power/mytherceria/goblinism
	name = "Goblinism"
	desc = "Summon a mischievous goblin to latch onto your enemies' faces."

	level = 3
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_FREE_HAND
	target_type = TARGET_MOB
	range = 5

	aggravating = TRUE
	hostile = TRUE
	violates_masquerade = TRUE

	cooldown_length = 10 SECONDS

/datum/discipline_power/mytherceria/goblinism/activate(mob/living/target)
	. = ..()
	var/obj/item/clothing/mask/facehugger/kiasyd/goblin = new (get_turf(owner))
	goblin.throw_at(target, 10, 14, owner)

/obj/item/clothing/mask/facehugger/kiasyd
	name = "goblin"
	desc = "A green changeling creature."
	worn_icon = 'modular_darkpack/modules/clothes/icons/worn.dmi'
	icon = 'modular_darkpack/modules/deprecated/icons/icons.dmi'
	icon_state = "goblin"
	base_icon_state = "goblin"
	worn_icon_state = "goblin"
	sterile = TRUE
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/deprecated/icons/icons.dmi')

/obj/item/clothing/mask/facehugger/kiasyd/attack_hand(mob/user)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		C.adjust_brute_loss(5)
		to_chat(user, span_warning("[src] bites!"))
		return
	. = ..()

/obj/item/clothing/mask/facehugger/kiasyd/die()
	qdel(src)

/obj/item/clothing/mask/facehugger/kiasyd/leap_to(mob/living/hit_mob)
	var/mob/living/carbon/human/target = astype(hit_mob)
	if(target)
		return FALSE
	if(target.wear_mask && istype(target.wear_mask, /obj/item/clothing/mask/facehugger/kiasyd))
		return FALSE
	target.visible_message(span_danger("[src] leaps at [target]'s face!"), \
		span_userdanger("[src] leaps at your face!"))

	if(target.head)
		var/obj/item/clothing/W = target.head
		target.dropItemToGround(W, TRUE)

	if(target.wear_mask)
		var/obj/item/clothing/W = target.wear_mask
		if(target.dropItemToGround(W, TRUE))
			target.visible_message(
				span_danger("[src] tears [W] off of [target]'s face!"), \
				span_userdanger("[src] tears [W] off of your face!"))
	target.equip_to_slot_if_possible(src, ITEM_SLOT_MASK, 0, 1, 1)
	var/datum/cb = CALLBACK(src,/obj/item/clothing/mask/facehugger/kiasyd/proc/eat_head)
	for(var/i in 1 to 10)
		addtimer(cb, (i - 1) * 1.5 SECONDS)
	spawn(16 SECONDS)
		qdel(src)
	return TRUE

/obj/item/clothing/mask/facehugger/kiasyd/proc/eat_head()
	if(iscarbon(loc))
		var/mob/living/carbon/C = loc
		to_chat(C, span_warning("[src] is eating your face!"))
		C.apply_damage(5, BRUTE)

//CHANJELIN WARD
/datum/discipline_power/mytherceria/chanjelin_ward
	name = "Chanjelin Ward"
	desc = "Create a symbol that disorientates your victim."

	level = 4
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE
	target_type = TARGET_LIVING
	range = 5

	aggravating = TRUE
	hostile = TRUE

	duration_length = 5 SECONDS
	cooldown_length = 10 SECONDS

/datum/discipline_power/mytherceria/chanjelin_ward/activate(mob/living/target)
	. = ..()
	target.apply_status_effect(/datum/status_effect/confusion, 10 SECONDS)


//RIDDLE PHANTASTIQUE
/datum/discipline_power/mytherceria/riddle_phantastique
	name = "Riddle Phantastique"
	desc = "Pose a confounding riddle to your victim, forcing them to answer it before they can do anything else."

	level = 5
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_SPEAK
	target_type = TARGET_LIVING
	range = 7

	cooldown_length = 0

	var/list/datum/riddle/stored_riddles = list()

/datum/discipline_power/mytherceria/riddle_phantastique/activate(mob/living/target)
	. = ..()
	if(length(stored_riddles))
		var/list/riddle_list = list("Create a new riddle...")
		for(var/datum/riddle/riddle in stored_riddles)
			riddle_list += riddle.riddle_text
		var/try_riddle = tgui_input_list(owner, "Select a Riddle:", "Riddle", riddle_list)
		if(try_riddle)
			if(try_riddle == "Create a new riddle...")
				var/datum/riddle/riddle = new ()
				if(riddle.create_riddle(owner))
					stored_riddles += riddle
					riddle.ask(target)
					owner.say(riddle.riddle_text)
				return
			var/datum/riddle/actual_riddle
			for(var/datum/riddle/RIDDLE in stored_riddles)
				if(RIDDLE.riddle_text == try_riddle)
					actual_riddle = RIDDLE
			target.add_movespeed_modifier(/datum/movespeed_modifier/riddle)
			actual_riddle.ask(target)
			owner.say(actual_riddle.riddle_text)
	else
		var/datum/riddle/riddle = new ()
		if(riddle.create_riddle(owner))
			stored_riddles += riddle
			riddle.ask(target)
			owner.say(riddle.riddle_text)
		else
			qdel(riddle)

/datum/movespeed_modifier/riddle
	multiplicative_slowdown = 5

/datum/riddle
	var/riddle_text
	var/list/riddle_options = list()
	var/riddle_answer

/atom/movable/screen/alert/riddle
	name = "Riddle"
	desc = "You have a riddle to solve!"
	icon_state = "riddle"
	icon = 'modular_darkpack/modules/deprecated/icons/hud/screen_alert.dmi'
	var/datum/riddle/riddle
	var/bad_answers = 0

/atom/movable/screen/alert/riddle/Click()
	. = ..()
	if(iscarbon(usr) && (usr == owner))
		var/mob/living/carbon/M = usr
		if(riddle)
			riddle.try_answer(M, src)

/datum/riddle/proc/try_answer(mob/living/answerer, atom/movable/screen/alert/riddle/new_alert)
	var/try_answer = tgui_input_list(answerer, riddle_text, "Riddle", shuffle(riddle_options.Copy()))
	if(try_answer)
		answer_riddle(answerer, try_answer, new_alert)

/datum/riddle/proc/ask(mob/living/asking)
	var/atom/movable/screen/alert/riddle/alert = asking.throw_alert("riddle", /atom/movable/screen/alert/riddle)
	alert.riddle = src

/datum/riddle/proc/create_riddle(mob/living/carbon/human/riddler)
	var/proceed = FALSE
	var/text_riddle = tgui_input_text(riddler, "Create a riddle:", "Riddle", "Is it something?")
	if(text_riddle)
		riddle_text = trim(copytext_char(sanitize(text_riddle), 1, MAX_MESSAGE_LEN))
		var/right_answer = tgui_input_text(riddler, "Create a right answer:", "Riddle", "Something")
		if(right_answer)
			riddle_answer = trim(copytext_char(sanitize(right_answer), 1, MAX_MESSAGE_LEN))
			riddle_options += trim(copytext_char(sanitize(right_answer), 1, MAX_MESSAGE_LEN))
			proceed = TRUE
			var/answer1 = tgui_input_text(riddler, "Create another answer:", "Riddle", "Anything")
			if(answer1)
				riddle_options += trim(copytext_char(sanitize(answer1), 1, MAX_MESSAGE_LEN))
				var/answer2 = tgui_input_text(riddler, "Create another answer:", "Riddle", "Anything")
				if(answer2)
					riddle_options += trim(copytext_char(sanitize(answer2), 1, MAX_MESSAGE_LEN))
					var/answer3 = tgui_input_text(riddler, "Create another answer:", "Riddle", "Anything")
					if(answer3)
						riddle_options += trim(copytext_char(sanitize(answer3), 1, MAX_MESSAGE_LEN))
						var/answer4 = tgui_input_text(riddler, "Create another answer:", "Riddle", "Anything")
						if(answer4)
							riddle_options += trim(copytext_char(sanitize(answer4), 1, MAX_MESSAGE_LEN))
	if(proceed)
		to_chat(riddler, "New riddle created.")
		return src
	else
		to_chat(riddler, span_danger("Your riddle is too complicated."))
		return FALSE

/datum/riddle/proc/answer_riddle(mob/living/answerer, the_answer, atom/movable/screen/alert/riddle/alert)
	if(the_answer != riddle_answer)
		alert.bad_answers++
		to_chat(answerer,
			span_danger("WRONG ANSWER."))
		if(alert.bad_answers >= round(length(riddle_options)/2))
			if(iscarbon(answerer))
				var/mob/living/carbon/C = answerer
				var/obj/item/organ/tongue/tongue = locate(/obj/item/organ/tongue) in C.organs
				if(tongue)
					tongue.Remove(C)
			to_chat(answerer,
				span_danger("THE RIDDLE REMOVES YOUR LYING TONGUE AS IT FLEES."))
			answerer.remove_movespeed_modifier(/datum/movespeed_modifier/riddle)
			alert.bad_answers = 0
			alert.riddle = null
			answerer.clear_alert("riddle")
	else
		to_chat(answerer,
			span_nicegreen("You feel the riddle's hold over you vanish."))
		alert.riddle = null
		answerer.remove_movespeed_modifier(/datum/movespeed_modifier/riddle)
		answerer.say(the_answer)
		answerer.clear_alert("riddle")
