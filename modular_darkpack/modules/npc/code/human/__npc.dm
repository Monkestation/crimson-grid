#define BANDIT_TYPE_NPC /mob/living/carbon/human/npc/bandit
#define POLICE_TYPE_NPC /mob/living/carbon/human/npc/police

/mob/living/carbon/human/npc
	name = "NPC"

	// NPCs normally walk around slowly
	move_intent = MOVE_INTENT_WALK

	// NPC humans get the area of effect, player humans dont.
	violation_aoe = TRUE

	/// Until we do a full NPC refactor (see: rewriting every single bit of code)
	/// use this to determine NPC weapons and their chances to spawn with them -- assuming you want the NPC to do that
	/// Otherwise just set it under the NPC's type as
	/// my_weapon = type_path
	/// my_backup_weapon = type_path
	/// This only determines my_weapon, you set my_backup_weapon yourself
	/// The last entry in the list for a type of NPC should always have 100 as the index
	var/static/list/role_weapons_chances = list(
		BANDIT_TYPE_NPC = list(
			/obj/item/gun/ballistic/automatic/pistol/darkpack/deagle = 33,
			/obj/item/gun/ballistic/revolver/darkpack/snub = 33,
			/obj/item/melee/baseball_bat/vamp = 100,
		),
		POLICE_TYPE_NPC = list(
			/obj/item/gun/ballistic/revolver/darkpack/magnum = 66,
			/obj/item/gun/ballistic/automatic/darkpack/ar15 = 100,
		)
	)
	var/datum/socialrole/socialrole

	var/is_talking = FALSE
	COOLDOWN_DECLARE(annoyed_cooldown)
	COOLDOWN_DECLARE(car_dodge)
	var/hostile = FALSE
	var/aggressive = FALSE
	var/last_antagonised = 0
	var/mob/living/danger_source
	var/obj/effect/abstract/turf_fire/afraid_of_fire
	var/mob/living/last_attacker
	var/last_health = 100
	var/mob/living/last_damager

	var/turf/walktarget	//dlya movementa

	var/last_grab = 0

	var/tupik_steps = 0
	var/tupik_loc

	var/stopturf = 1

	var/extra_mags = 2
	var/extra_loaded_rounds = 10

	var/has_weapon = FALSE

	var/my_weapon_type = null
	var/obj/item/my_weapon = null

	var/my_backup_weapon_type = null
	var/obj/item/my_backup_weapon = null

	var/spawned_weapon = FALSE

	var/spawned_backup_weapon = FALSE

	var/staying = FALSE

	var/lifespan = 0	//How many cycles. He'll be deleted if over than a ten thousand
	var/old_movement = FALSE
	var/max_stat = 2

	var/list/spotted_bodies = list()

	var/is_criminal = FALSE

	var/list/drop_on_death_list = null

/mob/living/carbon/human/npc/Initialize(mapload)
	. = ..()

	GLOB.npc_list += src
	GLOB.alive_npc_list += src

	AddElement(/datum/element/relay_attackers)
	RegisterSignal(src, COMSIG_ATOM_WAS_ATTACKED, PROC_REF(handle_attacked))

	// Annoy the NPC when pushed around
	RegisterSignal(src, COMSIG_LIVING_MOB_BUMPED, PROC_REF(handle_bumped))
	// Be annoyed if helped
	RegisterSignal(src, COMSIG_CARBON_HELP_ACT, PROC_REF(handle_helped))
	return INITIALIZE_HINT_LATELOAD

/mob/living/carbon/human/npc/LateInitialize(mapload)
	if (role_weapons_chances.Find(type))
		for(var/weapon in role_weapons_chances[type])
			if(prob(role_weapons_chances[type][weapon]))
				my_weapon = new weapon(src)
				break

	if (!my_weapon && my_weapon_type)
		my_weapon = new my_weapon_type(src)

	if (my_weapon)
		has_weapon = TRUE
		equip_to_appropriate_slot(my_weapon)
		if(istype(my_weapon, /obj/item/gun/ballistic))
			RegisterSignal(my_weapon, COMSIG_GUN_FIRED, PROC_REF(handle_gun))
			RegisterSignal(my_weapon, COMSIG_GUN_EMPTY, PROC_REF(handle_empty_gun))
		register_sticky_item(my_weapon)

	if (my_backup_weapon_type)
		my_backup_weapon = new my_backup_weapon_type(src)
		equip_to_appropriate_slot(my_backup_weapon)
		register_sticky_item(my_backup_weapon)

/mob/living/carbon/human/npc/Destroy()
	UnregisterSignal(src, list(COMSIG_ATOM_WAS_ATTACKED, COMSIG_LIVING_MOB_BUMPED, COMSIG_CARBON_HELP_ACT))
	QDEL_NULL(socialrole)
	danger_source = null
	QDEL_NULL(afraid_of_fire)
	last_attacker = null
	last_damager = null
	walktarget = null
	tupik_loc = null
	my_weapon_type = null
	my_weapon = null
	my_backup_weapon_type = null
	my_backup_weapon = null
	spotted_bodies = null
	drop_on_death_list = null
	GLOB.npc_list -= src
	GLOB.alive_npc_list -= src
	SShumannpcpool.try_repopulate()
	return ..()

//====================Sticky Item Handling====================
/mob/living/carbon/human/npc/proc/register_sticky_item(obj/item/my_item)
	ADD_TRAIT(my_item, TRAIT_NODROP, NPC_ITEM_TRAIT)
	if(!drop_on_death_list?.len)
		drop_on_death_list = list()
	drop_on_death_list += my_item

/mob/living/carbon/human/npc/death(gibbed)
	. = ..()

	if (!LAZYLEN(drop_on_death_list))
		return

	for (var/obj/item/dropping_item in drop_on_death_list)
		LAZYREMOVE(drop_on_death_list, dropping_item)
		REMOVE_TRAIT(dropping_item, TRAIT_NODROP, NPC_ITEM_TRAIT)
		dropItemToGround(dropping_item, TRUE)

//============================================================

/mob/living/carbon/human/npc/proc/realistic_say(message)
	GLOB.move_manager.stop_looping(src)

	if (!message)
		return
	if (stat >= HARD_CRIT)
		return
	if (is_talking)
		return
	is_talking = TRUE

	addtimer(CALLBACK(src, PROC_REF(start_talking), message), 2 SECONDS)

/mob/living/carbon/human/npc/proc/start_talking(message)
	create_typing_indicator()
	var/typing_delay = round(length_char(message) * 0.5)
	addtimer(CALLBACK(src, PROC_REF(finish_talking), message), max(3 SECONDS, typing_delay))

/mob/living/carbon/human/npc/proc/finish_talking(message)
	remove_typing_indicator()
	say(message)
	is_talking = FALSE

/mob/living/carbon/human/npc/proc/Annoy(atom/source)
	GLOB.move_manager.stop_looping(src)

	if (!can_npc_move())
		return
	if (danger_source)
		return

	if (!COOLDOWN_FINISHED(src, annoyed_cooldown))
		return
	COOLDOWN_START(src, annoyed_cooldown, 5 SECONDS)

	if(source)
		addtimer(CALLBACK(src, PROC_REF(face_atom), source), rand(0.3 SECONDS, 0.7 SECONDS))

	var/phrase = "Wow."
	if (prob(50))
		phrase = pick(socialrole?.neutral_phrases)
	else
		if (gender == MALE)
			phrase = pick(socialrole?.male_phrases)
		else
			phrase = pick(socialrole?.female_phrases)
	realistic_say(phrase)

/mob/living/carbon/human/npc/proc/handle_attacked(datum/source, atom/attacker, attack_flags)
	// Only aggro nearby npcs if its lethal.
	if(!(attack_flags & (ATTACKER_STAMINA_ATTACK|ATTACKER_SHOVING)))
		for(var/mob/living/carbon/human/npc/nearby_npcs in oviewers(DEFAULT_SIGHT_DISTANCE, src))
			nearby_npcs.Aggro(attacker)
		SEND_SIGNAL(SSdcs, COMSIG_GLOB_REPORT_CRIME, CRIME_FIREFIGHT, get_turf(src))
	Aggro(attacker, TRUE)

/mob/living/carbon/human/npc/proc/handle_bumped(mob/living/carbon/human/npc/source, mob/living/bumping)
	SIGNAL_HANDLER

	if (bumping.can_mobswap_with(source) && prob(25))
		return

	source.Annoy(bumping)

/mob/living/carbon/human/npc/proc/handle_helped(mob/living/carbon/human/npc/source, mob/living/helper)
	SIGNAL_HANDLER

	source.Annoy(helper)

/mob/living/carbon/human/npc/Move(NewLoc, direct)
	if (!can_npc_move())
		GLOB.move_manager.stop_looping(src)

	var/getaway = stopturf + 1

	if (!old_movement)
		getaway = 2

	if (get_dist(src, walktarget) <= getaway)
		GLOB.move_manager.stop_looping(src)
		walktarget = null

	. = ..()

/mob/living/carbon/human/npc/grabbedby(mob/living/carbon/user, supress_message = FALSE)
	. = ..()

	last_grab = world.time

/mob/living/carbon/human/npc/ghoulificate(mob/owner)
	deadchat_broadcast(span_ghostalert("[owner] is ghoulificating [src]."), owner, src)

	AddComponent(\
		/datum/component/ghost_direct_control,\
		ban_type = ROLE_GHOUL,\
		poll_candidates = TRUE,\
		role_name = "[owner]'s ghoul",\
		poll_length = 30 SECONDS,\
		poll_question = "Do you want to play as [owner]'s ghoul?",\

		assumed_control_message = "You are now [owner]'s ghoul!",\
		after_assumed_control = CALLBACK(src, PROC_REF(ghoul_player_controlled), owner)\
	)

	//poll_ignore_key = POLL_IGNORE_GHOUL,

	. = ..()
	return TRUE

/mob/living/carbon/human/npc/proc/ghoul_player_controlled(mob/owner)
	message_admins("[key_name_admin(src)] has became a ghoul by [key_name_admin(owner)].")
