
/obj/item/card
	var/shows_name = FALSE
	var/lastname_only = FALSE
	var/title_if_lastname_only
	var/listed_name
	var/item_type
	var/forged_id = FALSE
	var/mob/living/carbon/human/our_wearer
	var/datum/storyteller_roll/investigation/examine_roll_id

/obj/item/card/equipped(mob/user, slot, initial)
	. = ..()
	if(!shows_name)
		return
	if(slot == ITEM_SLOT_ID)
		RegisterSignal(user, COMSIG_ATOM_EXAMINE, PROC_REF(add_to_guestbook_if_relevant))
		our_wearer = user
	else
		UnregisterSignal(user, COMSIG_ATOM_EXAMINE)
		our_wearer = null

/obj/item/card/dropped(mob/user, silent)
	. = ..()
	UnregisterSignal(user, COMSIG_ATOM_EXAMINE)
	our_wearer = null

/obj/item/card/proc/add_to_guestbook_if_relevant(atom/source, mob/user, list/examine_texts)
	SIGNAL_HANDLER
	if(!isliving(user) || user == our_wearer)
		return

	if(forged_id)
		examine_roll_id.difficulty = min(our_wearer.st_get_stat(STAT_STREETWISE) * 2, 10)
		examine_roll_id.successes_needed = round(our_wearer.st_get_stat(STAT_STREETWISE))
		var/roll_result = examine_roll_id.st_roll(user, src)
		if(roll_result == ROLL_SUCCESS)
			examine_texts += span_boldwarning("You look more closely at [p_their(our_wearer)] [item_type], and realize it's forged! [p_Their(our_wearer)] identification is fake!")
			return
	if(our_wearer && !QDELETED(our_wearer) && user?.mind?.guestbook.visibility_checks(user, our_wearer, TRUE))
		var/check_name = LAZYACCESS(user.mind.guestbook.known_names, our_wearer.real_name)
		if(check_name && listed_name != check_name)
			examine_texts += span_boldwarning("You recognize [check_name], but [p_their(our_wearer)] [item_type] says [p_their(our_wearer)] name is [listed_name]!")
			return
		user.mind.guestbook.add_guest(user, our_wearer, our_wearer.real_name, listed_name, TRUE) // add them to your guestbook under the name on the ID

/obj/item/card/proc/link_human_id(mob/living/carbon/human/linked)
	QDEL_NULL(examine_roll_id)
	examine_roll_id = new()
	examine_roll_id.roll_output_type = ROLL_PRIVATE_UNLESS_FAILURE
	examine_roll_id.reroll_cooldown = 1 SCENES
	if(HAS_TRAIT(linked, TRAIT_ILLEGAL_IDENTITY))
		forged_id = TRUE
		if(lastname_only)
			listed_name = "[title_if_lastname_only] [last_name(linked.dna.fake_name_identity)]"
		else
			listed_name = linked.dna.fake_name_identity
	else
		if(lastname_only)
			listed_name = "[title_if_lastname_only] [last_name(linked.real_name)]"
		else
			listed_name = linked.real_name
	if(shows_name)
		name = "[initial(name)] - ([listed_name])"

/obj/item/card/prince
	name = "leader badge"
	desc = "King in the castle!"
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "prince_id"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	shows_name = TRUE
	lastname_only = TRUE
	title_if_lastname_only = "Leader"
	item_type = "badge"

/obj/item/card/sheriff
	name = "head security badge"
	desc = "A badge which shows honour and dedication."
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "head_sec_badge"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	shows_name = TRUE
	lastname_only = TRUE
	title_if_lastname_only = "Chief of Security"
	item_type = "badge"

/obj/item/card/camarilla
	name = "security badge"
	desc = "A badge which shows honour and dedication."
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "sec_badge"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	shows_name = TRUE
	lastname_only = TRUE
	title_if_lastname_only = "Security Officer"
	item_type = "badge"

/obj/item/card/clerk
	name = "clerk lanyard"
	desc = "A lanyard which shows buerocracy qualification."
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "red_id"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	worn_icon_state = "red_id"
	shows_name = TRUE
	item_type = "lanyard"

/obj/item/card/clerk/harpy
	name = "public relations manager lanyard"
	desc = "A lanyard which denotes the wearer as a PR Manager of Transamerica."

/obj/item/card/tower_employee
	name = "Millenium Tower Employee ID"
	desc = "An ID showing employment with the Millenium Tower - Maybe they give you free donuts."
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "green_id"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	worn_icon_state = "green_id"
	shows_name = TRUE
	item_type = "lanyard"

/obj/item/card/bruiser
	name = "bruiser badge"
	desc = "A badge which shows grit."
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "bruiser_badge"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	worn_icon_state = "bruiser_badge"

/obj/item/card/sweeper
	name = "sweeper badge"
	desc = "A badge which shows perspective."
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "sweeper_badge"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	worn_icon_state = "sweeper_badge"

/obj/item/card/emissary
	name = "emissary badge"
	desc = "A badge which shows a favored voice, interlaced with gold thread."
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "emissary_badge"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	worn_icon_state = "emissary_badge"

/obj/item/card/baron
	name = "eagle badge"
	desc = "The badge of a leader. The eagle stands proud, surrounded by the gold of their nest."
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "eagle_badge"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	worn_icon_state = "eagle_badge"

/obj/item/card/tapster
	name = "bartender badge"
	desc = "A badge displaying a beverage glass."
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "tapster_badge"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	ONFLOOR_ICONSTATE_HELPER("brusier_badge")
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	worn_icon_state = "bruiser_badge"

/obj/item/card/clinic
	name = "medical lanyard"
	desc = "A lanyard which shows medical qualification."
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "green_id"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	shows_name = TRUE
	lastname_only = TRUE
	title_if_lastname_only = "Doctor"
	item_type = "lanyard"

/obj/item/card/clinic/director
	name = "clinic director's lanyard"
	desc = "A badge which shows not only medical qualification, but also an authority over the clinic."
	title_if_lastname_only = "Director"

/obj/item/card/archive
	name = "scholar lanyard"
	desc = "A lanyard which shows a love of culture."
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "grey_id"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	shows_name = TRUE
	lastname_only = TRUE
	title_if_lastname_only = "Librarian"
	item_type = "lanyard"

/obj/item/card/regent
	name = "erudite scholar badge"
	desc = "A badge which shows a deep understanding of culture."
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "regent_id"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	ONFLOOR_ICONSTATE_HELPER("grey_id")
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	shows_name = TRUE
	lastname_only = TRUE
	title_if_lastname_only = "Head Librarian"
	item_type = "lanyard"

/obj/item/card/cleaning
	name = "janitor ID card"
	desc = "An ID card which shows cleaning employment."
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "blue_card"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	worn_icon_state = "blue_card"
	shows_name = TRUE
	item_type = "ID card"

/obj/item/card/graveyard
	name = "keeper ID card"
	desc = "An ID card which shows graveyard employment."
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "blue_card"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	shows_name = TRUE
	item_type = "ID card"

/obj/item/card/dealer
	name = "business ID card"
	desc = "A badge which shows business."
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "red_card"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	shows_name = TRUE
	item_type = "ID card"

/obj/item/card/supplytech
	name = "technician nametag"
	desc = "A nametag which shows supply employment."
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "supply_badge"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	worn_icon_state = "head_sec_badge"
	shows_name = TRUE
	item_type = "nametag"

/obj/item/card/hunter
	name = "cross"
	desc = "When you come into the land that the Lord your God is giving you, you must not learn to imitate the abhorrent practices of those nations. \
	No one shall be found among you who makes a son or daughter pass through fire, or who practices divination, or is a soothsayer, or an augur, or a sorcerer, \
	or one who casts spells, or who consults ghosts or spirits, or who seeks oracles from the dead. For whoever does these things is abhorrent to the Lord; \
	it is because of such abhorrent practices that the Lord your God is driving them out before you (Deuteronomy 18:9-12)."
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "hunter_badge"
	slot_flags = ITEM_SLOT_ID | ITEM_SLOT_NECK | ITEM_SLOT_BELT
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	COOLDOWN_DECLARE(detonation_timer)

/obj/item/card/hunter/silver
	name = "silver cross"
	icon_state = "hunter_silver"

/obj/item/card/hunter/gothic
	name = "gothic cross"
	icon_state = "hunter_gothic"

/obj/item/card/hunter/attack_self(mob/user)
	. = ..()
	if(!COOLDOWN_FINISHED(src, detonation_timer))
		return
	if(!user.mind)
		return
	if(user.mind.holy_role != HOLY_ROLE_PRIEST)
		return
	COOLDOWN_START(src, detonation_timer, 30 SECONDS)
	do_sparks(rand(5, 9), FALSE, user)
	playsound(user.loc, 'modular_darkpack/modules/jobs/sounds/cross.ogg', 100, FALSE, 8, 0.9)
	for(var/mob/living/M in get_hearers_in_view(4, src))
		bang(get_turf(src), M, user)

/obj/item/card/hunter/proc/bang(turf/turf, mob/living/living_mob, mob/living/user)
	if(living_mob.stat == DEAD) //They're dead!
		return
	living_mob.show_message(span_warning(span_bold("GOD SEES YOU!")), MSG_AUDIBLE)

	if(HAS_TRAIT(living_mob, TRAIT_REPELLED_BY_HOLINESS))
		living_mob.emote("scream")
		living_mob.pointed(user)

	var/distance = max(0, get_dist(get_turf(src), turf))
	if(living_mob.flash_act(affect_silicon = 1))
		living_mob.Paralyze(max(10/max(1, distance), 5))
		living_mob.Knockdown(max(100/max(1, distance), 40))

/obj/item/card/hunter/attack(mob/living/target, mob/living/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		return
	if(!COOLDOWN_FINISHED(src, detonation_timer))
		return
	if(HAS_TRAIT(target, TRAIT_REPELLED_BY_HOLINESS))
		COOLDOWN_START(src, detonation_timer, 30 SECONDS)
		lightningbolt(target)
		to_chat(target, span_userdanger("The gods have punished you for your sins!"))


// POLICE
/obj/item/card/police
	name = "police officer badge"
	desc = "A silver star made of smooth polished metal, indicating the wearer to be a police officer of the San Francisco Police Department."
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "police_badge"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	worn_icon_state = "police_badge"
	shows_name = TRUE
	lastname_only = TRUE
	title_if_lastname_only = "Officer"
	item_type = "badge"

/obj/item/card/government
	name = "emergency dispatcher ID card"
	desc = "Sponsored by the Government."
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "red_id"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	worn_icon_state = "red_id"
	shows_name = TRUE
	item_type = "ID card"

/obj/item/card/police/sergeant
	name = "police sergeant badge"
	desc = "A silver star with intricate silver engravings, indicating the wearer to be a sergeant of the San Francisco Police Department."
	title_if_lastname_only = "Sergeant"

/obj/item/card/police/captain
	name = "police captain badge"
	desc = "A gold star with intricate 10k gold-filled engravings, indicating the wearer to be a captain of the San Francisco Police Department."
	title_if_lastname_only = "Captain"

/obj/item/card/police/fbi
	name = "fbi special agent badge"
	desc = "A rather ornate badge made of polished gold-like metal. It has the words \"Federal Bureau of Investigation\" engraved on it."
	title_if_lastname_only = "Special Agent"

// CULTISTS
/obj/item/card/bahari
	name = "cultist badge"
	desc = "This shows your devotion to the dark mother."
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "id14"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	worn_icon_state = "police_badge"

/obj/item/card/noddist
	name = "cultist badge"
	desc = "This shows your devotion to the dark father."
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "id15"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	worn_icon_state = "police_badge"

//TZIMISCE ROLES
/obj/item/card/voivode
	name = "ancient badge"
	desc = "You have to wear this filthy thing to be recognized."
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "id12"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	worn_icon_state = "head_sec_badge"

/obj/item/card/bogatyr
	name = "dusty badge"
	desc = "You have to wear this because the Voivode wants you to."
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "id12"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	worn_icon_state = "head_sec_badge"

// PRIMOGEN STUFF
/obj/item/card/primogen
	name = "mysterious primogen badge"
	desc = "Sponsored by the Shadow Government."
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "id12"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	worn_icon_state = "head_sec_badge"

/obj/item/card/whip
	name = "primogen's whip badge"
	desc = "This badge shows your servitude to an important person."
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "onyx_badge"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	worn_icon_state = "onyx_badge"

/obj/item/card/steward
	name = "primogen's steward badge"
	desc = "This badge shows you're very good at taking care of someone else's property."
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "emerald_badge"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	worn_icon_state = "emerald_badge"

/obj/item/card/myrmidon
	name = "primogen's myrmidon badge"
	desc = "A badge which shows you're responsible enough to protect someone important but not responsible enough to protect the most important."
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "ruby_badge"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	worn_icon_state = "ruby_badge"

/obj/item/card/park_ranger
	name = "Park Ranger lanyard"
	desc = "Only you can prevent forest fires."
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "grey_id"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	worn_icon_state = "grey_id"
	shows_name = TRUE
	lastname_only = TRUE
	title_if_lastname_only = "Ranger"
	item_type = "lanyard"

/obj/item/card/park_ranger/oversight
	name = "NPS Oversight Committee lanyard"
	desc = "You have been out in the woods to know that you arent afraid of anything but one specific topic out there. Leadership."
	lastname_only = FALSE

/obj/item/card/park_ranger/leader
	name = "Lead Park Ranger lanyard"
	desc = "These are your woods and your lands. Keep them safe."
	title_if_lastname_only = "Lead Ranger"

/obj/item/card/park_ranger/guide
	name = "Park Guide lanyard"
	desc = "Remember, Dire Wolves arent real, as far as you tell people."
	lastname_only = FALSE

/obj/item/card/park_ranger/biologist
	name = "NPS Biologist lanyard"
	desc = "You love the outdoors? Good, you are now taking care of a wide outdoors area."
	lastname_only = FALSE

/obj/item/card/pentex
	name = "\improper " + MAIN_EVIL_COMPANY + " employee lanyard"
	desc = "Congratulations, wagie."
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "green_id"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	worn_icon_state = "green_id"
	shows_name = TRUE
	item_type = "lanyard"

/obj/item/card/pentex/branch_lead
	name = "\improper " + MAIN_EVIL_COMPANY + " Branch Lead lanyard"
	desc = "How bad can I be?"

/obj/item/card/pentex/executive
	name = "\improper " + MAIN_EVIL_COMPANY + " Executive lanyard"
	desc = "All the customers are buying."

/obj/item/card/pentex/affairs
	name = "\improper " + MAIN_EVIL_COMPANY + " Internal Affairs lanyard"
	desc = "And the Lawyers are denying."

/obj/item/card/pentex/secchief
	name = "\improper " + MAIN_EVIL_COMPANY + " Chief of Security lanyard"
	desc = "Its not illegal if nobody finds out about it. Now if only " + MAIN_EVIL_COMPANY + " would pay for a single tank for you."
	lastname_only = TRUE
	title_if_lastname_only = "Chief of Security"

/obj/item/card/pentex/sec
	name = "\improper " + MAIN_EVIL_COMPANY + " Security Agent lanyard"
	desc = "Corporate Security, a step above a mall cop. Better paid than a real cop."
	lastname_only = TRUE
	title_if_lastname_only = "Security Agent"
