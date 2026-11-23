#define DRUG_DEAL_OFFER_TIME (90 SECONDS)
#define DRUG_DEAL_MEET_TIME (4 MINUTES)
#define DRUG_DEAL_MIN_RANGE 10
#define DRUG_DEAL_MAX_RANGE 60

/datum/drug_deal
	var/datum/weakref/customer_ref
	var/datum/weakref/phone_ref
	var/datum/weakref/spot_ref
	var/sender_name
	var/sender_number
	var/datum/drug_product/product
	/// Specific variant demanded (a cannabis strain reagent typepath), null = any
	var/variant
	var/wanted_amount = 1
	/// Minimum purity the customer accepts. Always 0 for products without purity.
	var/min_purity = 0
	var/unit_price = 0
	var/delivered = 0
	var/total_pay = 0
	var/turf/drop_turf
	var/accepted = FALSE
	var/arrived = FALSE
	var/offer_expires = 0
	var/deadline = 0

/datum/drug_deal/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	drop_turf = null
	return ..()

/datum/drug_deal/proc/get_customer()
	return customer_ref?.resolve()

/datum/drug_deal/proc/get_phone()
	RETURN_TYPE(/obj/item/smartphone)
	return phone_ref?.resolve()

/// Picks customer, product and drop-off. FALSE if there's nobody suitable right now.
/datum/drug_deal/proc/setup(obj/item/smartphone/phone, mob/living/owner)
	var/list/candidates = list()
	for(var/mob/living/carbon/human/npc/candidate as anything in GLOB.alive_npc_list)
		if(QDELETED(candidate) || candidate.z != owner.z || get_dist(candidate, owner) > DRUG_DEAL_MAX_RANGE)
			continue
		if(candidate.drug_price <= 0 || candidate.drug_deal || candidate.food_order || candidate.danger_source)
			continue
		if(istype(candidate, /mob/living/carbon/human/npc/police) || istype(candidate, /mob/living/carbon/human/npc/bandit))
			continue
		if(candidate.stat != STABLE || !candidate.can_npc_move())
			continue
		candidates += candidate
	if(!length(candidates))
		return FALSE

	var/list/spots = list()
	for(var/obj/effect/landmark/drug_dropoff/dropoff as anything in GLOB.drug_dropoffs)
		if(dropoff.in_use || dropoff.z != owner.z)
			continue
		var/dist = get_dist(dropoff, owner)
		if(dist < DRUG_DEAL_MIN_RANGE || dist > DRUG_DEAL_MAX_RANGE)
			continue
		spots += dropoff
	if(!length(spots))
		return FALSE

	var/mob/living/carbon/human/npc/customer = pick(candidates)
	var/obj/effect/landmark/drug_dropoff/spot = pick(spots)
	product = pick_weight(GLOB.drug_products)
	wanted_amount = rand(product.min_amount, product.max_amount)
	min_purity = product.roll_min_purity()
	variant = product.roll_variant()
	unit_price = round(product.base_price * product.variant_price_mult(variant) * customer.drug_price * (1 + min_purity / 100))

	customer.drug_deal = src
	customer_ref = WEAKREF(customer)
	phone_ref = WEAKREF(phone)
	spot_ref = WEAKREF(spot)
	spot.in_use = TRUE
	drop_turf = get_turf(spot)
	sender_name = customer.real_name
	sender_number = "555-[rand(1000, 9999)]"
	offer_expires = world.time + DRUG_DEAL_OFFER_TIME
	START_PROCESSING(SSprocessing, src)
	return TRUE

/datum/drug_deal/proc/product_name()
	if(variant)
		return "[product.variant_name(variant)] [product.name]"
	return product.name

/datum/drug_deal/proc/estimated_pay()
	return unit_price * wanted_amount

/datum/drug_deal/proc/offer_text()
	var/quality_text = ""
	if(product.purity_reagent)
		quality_text = " ([min_purity ? "at least [min_purity]% pure" : "any quality"])"
	return "Hey, heard you're the one to talk to. I need [wanted_amount]x [product_name()][quality_text]. About $[estimated_pay()]. Accept on your phone and I'll meet you at the spot."

/datum/drug_deal/proc/send_text(message)
	get_phone()?.receive_npc_text(sender_name, sender_number, message)

/datum/drug_deal/proc/accept(mob/living/user)
	if(accepted)
		return FALSE
	var/mob/living/carbon/human/npc/customer = get_customer()
	if(QDELETED(customer) || customer.stat != STABLE || customer.danger_source)
		send_text("Never mind, something came up.")
		end()
		return FALSE
	accepted = TRUE
	deadline = world.time + DRUG_DEAL_MEET_TIME
	if(customer.buckled)
		customer.buckled.unbuckle_mob(customer, force = TRUE)
	customer.loiter_spot = drop_turf
	customer.walktarget = drop_turf
	customer.stopturf = 1
	send_text("Cool, heading there now. Don't keep me waiting.")
	return TRUE

/datum/drug_deal/proc/decline()
	if(!accepted)
		send_text("Your loss.")
	end()

/datum/drug_deal/process(seconds_per_tick)
	if(!accepted)
		if(world.time >= offer_expires)
			end()
		return
	var/mob/living/carbon/human/npc/customer = get_customer()
	if(QDELETED(customer) || customer.stat != STABLE || customer.danger_source || customer.drug_deal != src)
		send_text("Forget it, this is too sketchy.")
		end()
		return
	if(world.time >= deadline)
		customer.say("Forget it, I'm out of here.")
		send_text("You took too long. Deal's off.")
		end()
		return
	// Keep them parked on the spot instead of wandering off
	customer.loiter_until = max(customer.loiter_until, world.time + 6 SECONDS)
	if(!customer.walktarget && get_dist(customer, drop_turf) > 1)
		customer.loiter_spot = drop_turf
		customer.walktarget = drop_turf
		customer.stopturf = 1
	if(!arrived && get_dist(customer, drop_turf) <= 1)
		arrived = TRUE
		send_text("I'm here. Hurry up.")

/// Player hands an item to the waiting customer. Returns an item_interaction value.
/datum/drug_deal/proc/receive_item(mob/living/user, obj/item/tool)
	var/mob/living/carbon/human/npc/customer = get_customer()
	if(QDELETED(customer) || !accepted || !product.matches(tool))
		return NONE
	if(get_dist(customer, drop_turf) > 1)
		customer.say("Not here, meet me at the spot.")
		return ITEM_INTERACT_SUCCESS
	if(!product.matches_variant(tool, variant))
		customer.say("That's not the [product.variant_name(variant)] I asked for.")
		return ITEM_INTERACT_SUCCESS
	// Null for products without purity (cannabis etc.), which pay a flat unit price
	var/purity = product.get_purity(tool)
	if(!isnull(purity) && purity < min_purity)
		customer.say("This is cut to hell. I'm not paying for this.")
		return ITEM_INTERACT_SUCCESS
	delivered++
	total_pay += round(unit_price * (isnull(purity) ? 1 : 0.5 + purity / 100))
	qdel(tool)
	if(delivered < wanted_amount)
		customer.say("Good. [wanted_amount - delivered] more.")
		return ITEM_INTERACT_SUCCESS
	complete(user, customer)
	return ITEM_INTERACT_SUCCESS

/datum/drug_deal/proc/complete(mob/living/user, mob/living/carbon/human/npc/customer)
	log_game("[key_name(user)] completed a drug deal with [customer] for $[total_pay]")
	var/obj/item/stack/dollar/cash = new(get_turf(customer), total_pay)
	user.put_in_hands(cash)
	customer.say(pick("Pleasure doing business.", "Nice. Hit me up again.", "Not bad."))
	send_text("Thanks. Pleasure doing business.")
	// dont deal drugs infront of cops
	for(var/mob/living/carbon/human/npc/police/witness in oviewers(DEFAULT_SIGHT_DISTANCE, customer))
		witness.announce_drug_line(witness.socialrole?.drug_witness_phrases)
		witness.last_antagonised = world.time
		witness.Aggro(user, TRUE)
		customer.fleeing_from = witness
		SEND_SIGNAL(SSdcs, COMSIG_GLOB_REPORT_CRIME, CRIME_DRUG_SALE, get_turf(customer))
	end()

/datum/drug_deal/proc/end()
	var/mob/living/carbon/human/npc/customer = get_customer()
	if(customer && customer.drug_deal == src)
		customer.drug_deal = null
		if(accepted)
			customer.loiter_spot = null
			customer.loiter_until = world.time + rand(1 SECONDS, 3 SECONDS)
	var/obj/effect/landmark/drug_dropoff/spot = spot_ref?.resolve()
	if(spot)
		spot.in_use = FALSE
	var/obj/item/smartphone/phone = get_phone()
	phone?.GetComponent(/datum/component/dealer_app)?.deal_ended(src)
	qdel(src)

#undef DRUG_DEAL_OFFER_TIME
#undef DRUG_DEAL_MEET_TIME
#undef DRUG_DEAL_MIN_RANGE
#undef DRUG_DEAL_MAX_RANGE
