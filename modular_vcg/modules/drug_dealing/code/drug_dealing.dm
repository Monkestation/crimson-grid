#define NPC_DRUG_SALE_BOTCH_PENALTY 0.5
#define NPC_DRUG_LINE_COOLDOWN 3 SECONDS

/datum/storyteller_roll/npc_drug_sale
	bumper_text = "dealing"
	applicable_stats = list(STAT_CHARISMA, STAT_STREETWISE)
	numerical = TRUE

//drug dealing
/mob/living/carbon/human/npc/proc/cancel_talking()
	if(!is_talking)
		return
	is_talking = FALSE
	deltimer(talk_start_timer)
	deltimer(talk_finish_timer)
	talk_start_timer = null
	talk_finish_timer = null
	remove_typing_indicator()
	REMOVE_TRAIT(src, TRAIT_THINKING_IN_CHARACTER, CURRENTLY_TYPING_TRAIT)

/mob/living/carbon/human/npc/proc/announce_drug_line(list/phrases)
	if(!LAZYLEN(phrases))
		return
	if(!COOLDOWN_FINISHED(src, drug_line_cooldown))
		return
	COOLDOWN_START(src, drug_line_cooldown, NPC_DRUG_LINE_COOLDOWN)
	cancel_talking()
	say(pick(phrases))

/mob/living/carbon/human/npc/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	. = ..()
	if(.)
		return
	return handle_drug_sale(user, tool)

/mob/living/carbon/human/npc/proc/handle_drug_sale(mob/living/user, obj/item/tool)
	if(user.combat_mode)
		return NONE

	var/datum/component/selling/selling_comp = tool.GetComponent(/datum/component/selling)
	if(!selling_comp || !(selling_comp.object_category in npc_buyable_categories))
		return NONE
	// dont deal drugs to cops
	if(istype(src, /mob/living/carbon/human/npc/police))
		announce_drug_line(socialrole?.drug_witness_phrases)
		last_antagonised = world.time
		Aggro(user, TRUE)
		SEND_SIGNAL(SSdcs, COMSIG_GLOB_REPORT_CRIME, CRIME_DRUG_SALE, get_turf(src))
		return ITEM_INTERACT_SUCCESS
	// dont deal drugs to drug dealers
	if(istype(src, /mob/living/carbon/human/npc/bandit) && prob(50))
		announce_drug_line(socialrole?.drug_turf_phrases)
		last_antagonised = world.time
		Aggro(user, TRUE)
		return ITEM_INTERACT_SUCCESS

	if(danger_source == user)
		return ITEM_INTERACT_SUCCESS

	// drug purchases reset after 10 minutes
	if(COOLDOWN_FINISHED(src, drug_purchase_reset))
		drug_purchases = 0

	if(drug_price <= 0 || drug_purchases >= drug_purchase_limit)
		cancel_talking()
		realistic_say(pick(socialrole?.drug_refusal_phrases))
		return ITEM_INTERACT_SUCCESS

	drug_purchases++
	if(drug_purchases == 1)
		COOLDOWN_START(src, drug_purchase_reset, drug_purchase_reset_time)

	if(!drug_sell_roll)
		drug_sell_roll = new()
	var/success_count = drug_sell_roll.st_roll(user, src)
	var/stack_multiplier = 1
	if(istype(tool, /obj/item/stack))
		var/obj/item/stack/stack_item = tool
		stack_multiplier = stack_item.amount
	var/sale_price = round(selling_comp.cost * stack_multiplier * drug_price * (success_count > 0 ? success_count : NPC_DRUG_SALE_BOTCH_PENALTY))

	log_game("[key_name(user)] sold [tool] to [src] for $[sale_price]")
	qdel(tool)

	var/obj/item/stack/dollar/cash = new(get_turf(src), sale_price)
	user.put_in_hands(cash)

	// dont deal drugs infront of cops
	for(var/mob/living/carbon/human/npc/police/witness in oviewers(DEFAULT_SIGHT_DISTANCE, src))
		witness.announce_drug_line(witness.socialrole?.drug_witness_phrases)
		witness.last_antagonised = world.time
		witness.Aggro(user, TRUE)
		fleeing_from = witness
		cancel_talking()
		SEND_SIGNAL(SSdcs, COMSIG_GLOB_REPORT_CRIME, CRIME_DRUG_SALE, get_turf(src))

	if(!fleeing_from)
		cancel_talking()
		realistic_say(pick(socialrole?.drug_purchase_phrases))

	return ITEM_INTERACT_SUCCESS

/mob/living/carbon/human/npc/display_darkpack_examine_text(mob/user)
	. = ..()
	if(!isliving(user))
		return
	var/mob/living/examiner = user
	if(examiner.st_get_stat(STAT_STREETWISE) <= 3)
		return
	if(istype(src, /mob/living/carbon/human/npc/police))
		. += span_warning("[p_They()] [p_are()] an officer of the SFPD. Committing a crime in [p_their()] view is a bad idea.")
	else if(istype(src, /mob/living/carbon/human/npc/bandit))
		. += span_warning("[p_They()] [p_have()] several gang tattoos. It may be a bad idea to provoke [p_them()].")
	else if(istype(src, /mob/living/carbon/human/npc/hobo))
		. += span_notice("[p_They()] look[p_s()] like [p_theyre()] down on [p_their()] luck and [p_do()]n't have much money to spare.")
	else if(drug_price >= 2)
		. += span_notice("[p_They()] look[p_s()] well dressed, [p_theyre()] probably carrying a lot of money.")
	else if(drug_price > 0)
		. += span_notice("[p_They()] look[p_s()] about as average as they come.")

#undef NPC_DRUG_SALE_BOTCH_PENALTY
#undef NPC_DRUG_LINE_COOLDOWN
