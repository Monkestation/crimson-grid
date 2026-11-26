GLOBAL_LIST_EMPTY(drug_dropoffs)

///sitting spot for drop offs
/obj/effect/landmark/drug_dropoff
	name = "Drug Dropoff"
	icon = 'modular_darkpack/modules/deprecated/icons/effects/landmarks_static.dmi'
	icon_state = "bullets"
	var/in_use = FALSE

/obj/effect/landmark/drug_dropoff/Initialize(mapload)
	. = ..()
	GLOB.drug_dropoffs += src

/obj/effect/landmark/drug_dropoff/Destroy()
	GLOB.drug_dropoffs -= src
	return ..()

/mob/living/carbon/human/npc
	/// The drug deal this NPC is part of, if any.
	var/datum/drug_deal/drug_deal

/datum/component/dealer_app
	var/list/datum/drug_deal/deals = list()
	var/max_deals = 3
	var/next_deal_time = 0
	var/datum/drug_deal/tracked
	var/datum/component/pinpointer/pointer

/datum/component/dealer_app/Initialize()
	. = ..()
	if(!istype(parent, /obj/item/smartphone))
		return COMPONENT_INCOMPATIBLE
	pointer = parent.AddComponent(/datum/component/pinpointer)
	next_deal_time = world.time + rand(30 SECONDS, 60 SECONDS)
	START_PROCESSING(SSprocessing, src)

/datum/component/dealer_app/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	for(var/datum/drug_deal/deal as anything in deals.Copy())
		deal.end()
	tracked = null
	QDEL_NULL(pointer)
	return ..()

/datum/component/dealer_app/proc/get_holder()
	var/obj/item/smartphone/phone = parent
	return isliving(phone.loc) ? phone.loc : null

/datum/component/dealer_app/process(seconds_per_tick)
	var/obj/item/smartphone/phone = parent
	var/mob/living/holder = get_holder()
	if(tracked && holder && tracked.accepted && tracked.drop_turf)
		pointer.point_to(holder, tracked.drop_turf)
	if(world.time < next_deal_time || length(deals) >= max_deals)
		return
	// Only deal while a real person is carrying a working phone
	if(!holder?.mind || !phone.sim_card?.phone_number)
		return
	next_deal_time = world.time + rand(90 SECONDS, 240 SECONDS)
	var/datum/drug_deal/deal = new()
	if(!deal.setup(phone, holder))
		qdel(deal)
		return
	deals += deal
	deal.send_text(deal.offer_text())

/datum/component/dealer_app/proc/deal_ended(datum/drug_deal/deal)
	deals -= deal
	if(tracked == deal)
		tracked = null
	SStgui.update_uis(parent)

/datum/component/dealer_app/proc/find_deal(deal_id)
	for(var/datum/drug_deal/deal as anything in deals)
		if(REF(deal) == deal_id)
			return deal
	return null

/datum/component/dealer_app/proc/handle_action(mob/user, action, deal_id)
	var/datum/drug_deal/deal = find_deal(deal_id)
	if(!deal)
		return FALSE
	switch(action)
		if("deal_accept")
			deal.accept(user)
		if("deal_decline")
			deal.decline()
		if("deal_track")
			tracked = (tracked == deal) ? null : deal
	return TRUE

/datum/component/dealer_app/proc/get_ui_data()
	var/list/out = list()
	for(var/datum/drug_deal/deal as anything in deals)
		UNTYPED_LIST_ADD(out, list(
			"id" = REF(deal),
			"drug" = deal.product_name(),
			"amount" = deal.wanted_amount,
			"delivered" = deal.delivered,
			"min_purity" = deal.min_purity,
			"est_pay" = deal.estimated_pay(),
			"accepted" = deal.accepted,
			"tracking" = (tracked == deal),
			"seconds_left" = max(round(((deal.accepted ? deal.deadline : deal.offer_expires) - world.time) / (1 SECONDS)), 0),
		))
	return out
