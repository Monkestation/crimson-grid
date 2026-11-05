#define CARGO_TRAIN_STORED 0
#define CARGO_TRAIN_ARRIVING 1
#define CARGO_TRAIN_DOCKED 2
#define CARGO_TRAIN_DEPARTING 3

#define CARGO_TRAIN_LENGTH 3
#define CARGO_TRAIN_CART_LENGTH 4     // turfs each cart occupies
#define CARGO_TRAIN_STEP_DELAY (0.2 SECONDS)
#define CARGO_TRAIN_DWELL_TIME (3 MINUTES)
#define CARGO_TRAIN_RECHECK_TIME (30 SECONDS)
#define CARGO_TRAIN_FIRST_ARRIVAL (1 MINUTES)

/datum/map_template/cargo_train_interior
	name = "Cargo Train Interior"
	mappath = "_maps/cargo_train_interior.dmm"
	width = 9
	height = 5

SUBSYSTEM_DEF(cargo_train)
	name = "Cargo Train"
	ss_flags = SS_NO_FIRE
	dependencies = list(
		/datum/controller/subsystem/atoms,
		/datum/controller/subsystem/lighting,
	)

	///this only really exists in the weird case something is broken on init
	var/enabled = FALSE
	var/train_state = CARGO_TRAIN_STORED
	/// Ordered turfs in travel order (index 1 = where the train enters).
	var/list/turf/path = list()
	/// Index in path where the head of the train rests.
	var/stop_index = 0
	/// Path index of the head. 0 = just off the start of the track.
	var/progress = 0
	var/list/obj/cargotrain/segments = list()
	var/list/obj/effect/abstract/cargo_train_spot/landing_spots = list()
	var/turf/interior_entry
	var/list/turf/interior_turfs = list()
	var/obj/cargotrain/boardable/door_segment
	/// Crates we delivered that are (probably) still in the cart.
	var/list/atom/movable/tracked_crates = list()
	var/step_timer
	var/dwell_timer

	///we pull these from the stop basically the dir we travel in to leave and enter
	var/leaving_dir
	var/travelling_dir
	// current direction the train is actually moving
	var/movement_dir
	var/departing_reverse = FALSE

/datum/controller/subsystem/cargo_train/Initialize()
	var/obj/effect/landmark/cargo_train_stop/stop = locate() in GLOB.landmarks_list
	if(!stop)
		log_mapping("Cargo train: no /obj/effect/landmark/cargo_train_stop mapped, train disabled.")
		return SS_INIT_NO_NEED

	leaving_dir = stop.leaving_dir
	travelling_dir = stop.travel_dir

	var/turf/stop_turf = get_turf(stop)
	path = build_path(stop_turf)
	stop_index = path.Find(stop_turf)
	if(length(path) < (CARGO_TRAIN_LENGTH * CARGO_TRAIN_CART_LENGTH) + 1)
		log_mapping("Cargo train: track at [AREACOORD(stop_turf)] is too short ([length(path)] tiles).")

	load_interior()

	var/door_index = round(CARGO_TRAIN_LENGTH / 2) + 1
	for(var/i in 1 to CARGO_TRAIN_LENGTH)
		var/obj/cargotrain/segment
		if(i == door_index)
			segment = new /obj/cargotrain/boardable(null)
			door_segment = segment
		else
			segment = new /obj/cargotrain(null)
		segments += segment

	enabled = TRUE
	addtimer(CALLBACK(src, PROC_REF(recall)), CARGO_TRAIN_FIRST_ARRIVAL)
	return SS_INIT_SUCCESS

/// Contiguous rails through the stop tile, ordered in travel direction.
/datum/controller/subsystem/cargo_train/proc/build_path(turf/stop_turf)
	var/list/line = list(stop_turf)

	// Scan both ways along the track axis
	var/turf/cursor = get_step(stop_turf, WEST)
	while(istype(cursor, /turf/open/misc/dirt/rails))
		line.Insert(1, cursor)
		cursor = get_step(cursor, WEST)

	cursor = get_step(stop_turf, EAST)
	while(istype(cursor, /turf/open/misc/dirt/rails))
		line += cursor
		cursor = get_step(cursor, EAST)

	// travelling_dir is the direction the train moves while arriving / departing.
	if(travelling_dir == WEST)
		line = reverseList(line)

	return line

/datum/controller/subsystem/cargo_train/proc/load_interior()
	var/datum/map_template/cargo_train_interior/template = new
	var/datum/turf_reservation/reservation = SSmapping.request_turf_block_reservation(template.width, template.height, 1)
	if(!reservation)
		CRASH("Cargo train: couldn't reserve space for the interior.")
	template.load(reservation.bottom_left_turfs[1])
	interior_turfs = block(reservation.bottom_left_turfs[1], reservation.top_right_turfs[1])
	var/obj/effect/landmark/cargo_train_interior_entry/entry = locate() in GLOB.landmarks_list
	if(entry)
		interior_entry = get_turf(entry)

/// Sell empty crates that are still in the interior when the train departs.
/// Only exports that declare EXPORT_MARKET_CARGO_TRAIN will match.
/datum/controller/subsystem/cargo_train/proc/try_sell()
	var/datum/bank_account/cargo_budget = SSeconomy.get_dep_account(ACCOUNT_CAR)
	if(!cargo_budget)
		return

	var/datum/export_report/report = new

	for(var/turf/cart_turf as anything in interior_turfs)
		for(var/obj/structure/closet/crate/crate in cart_turf)
			// Strict: only completely empty crates
			if(length(crate.contents))
				continue
			export_single_item(crate, apply_elastic = TRUE, dry_run = FALSE, external_report = report, export_markets = list(EXPORT_MARKET_CARGO_TRAIN))

	var/msg = ""
	for(var/datum/export/exported_datum in report.total_amount)
		var/export_text = exported_datum.total_printout(report)
		if(!export_text)
			continue
		msg += export_text + "\n"
		cargo_budget.adjust_money(report.total_value[exported_datum])

/datum/controller/subsystem/cargo_train/proc/recall()
	if(!enabled || train_state != CARGO_TRAIN_STORED)
		return FALSE
	train_state = CARGO_TRAIN_ARRIVING
	progress = 0
	movement_dir = travelling_dir
	departing_reverse = FALSE
	train_step()
	return TRUE

/datum/controller/subsystem/cargo_train/proc/depart()
	if(train_state != CARGO_TRAIN_DOCKED)
		return FALSE
	if(dwell_timer)
		deltimer(dwell_timer)
		dwell_timer = null

	try_sell()
	 // clean up the delivery tracking list
	tracked_crates.Cut()

	train_state = CARGO_TRAIN_DEPARTING

	// Decide whether we continue forward or reverse
	if(leaving_dir == travelling_dir)
		departing_reverse = FALSE
		movement_dir = travelling_dir
	else
		departing_reverse = TRUE
		movement_dir = leaving_dir

	train_step()
	return TRUE

/datum/controller/subsystem/cargo_train/proc/train_step()
	step_timer = null

	if(departing_reverse)
		progress--
	else
		progress++

	for(var/i in 1 to length(segments))
		place_segment(segments[i], progress - (i - 1) * CARGO_TRAIN_CART_LENGTH)

	if(train_state == CARGO_TRAIN_ARRIVING && progress >= stop_index)
		on_dock()
		return

	if(train_state == CARGO_TRAIN_DEPARTING)
		if(departing_reverse)
			if(progress < 1)
				train_state = CARGO_TRAIN_STORED
				return
		else
			if((progress - (length(segments) - 1) * CARGO_TRAIN_CART_LENGTH) > length(path))
				train_state = CARGO_TRAIN_STORED
				return

	step_timer = addtimer(CALLBACK(src, PROC_REF(train_step)), CARGO_TRAIN_STEP_DELAY, TIMER_STOPPABLE)

/datum/controller/subsystem/cargo_train/proc/place_segment(obj/cargotrain/segment, index)
	if(index < 1 || index > length(path))
		segment.moveToNullspace()
		return
	var/turf/destination = path[index]
	segment.forceMove(destination)
	for(var/mob/living/crushed in destination)
		if(crushed.stat == DEAD || crushed.body_position == LYING_DOWN)
			crushed.gib(DROP_ALL_REMAINS)
		else
			var/atom/throw_target
			crushed.Paralyze(30 SECONDS, ignore_canstun = TRUE)
			if(!throw_target)
				throw_target = get_edge_target_turf(src, turn(WEST, pick(45, -45)))
			crushed.throw_at(throw_target, 200, 4)
			crushed.apply_damage(30, BRUTE, BODY_ZONE_CHEST, wound_bonus = 30)
			crushed.apply_damage(20, BRUTE, BODY_ZONE_HEAD, wound_bonus = 25)
			crushed.apply_damage(15, BRUTE, BODY_ZONE_L_LEG, wound_bonus = 15)
			crushed.apply_damage(15, BRUTE, BODY_ZONE_R_LEG, wound_bonus = 15)
			crushed.apply_damage(15, BRUTE, BODY_ZONE_L_ARM, wound_bonus = 15)
			crushed.apply_damage(15, BRUTE, BODY_ZONE_R_ARM, wound_bonus = 15)

/datum/controller/subsystem/cargo_train/proc/on_dock()
	train_state = CARGO_TRAIN_DOCKED
	deliver_orders()
	dwell_timer = addtimer(CALLBACK(src, PROC_REF(auto_depart)), CARGO_TRAIN_DWELL_TIME, TIMER_STOPPABLE)

/// Timer callback: leave only if the cart is empty of people and delivered crates.
/datum/controller/subsystem/cargo_train/proc/auto_depart()
	dwell_timer = null
	if(train_state != CARGO_TRAIN_DOCKED)
		return
	if(length(get_riders()) || count_crates_aboard())
		dwell_timer = addtimer(CALLBACK(src, PROC_REF(auto_depart)), CARGO_TRAIN_RECHECK_TIME, TIMER_STOPPABLE)
		return
	// Cart is clear. If orders are still waiting (it was full, or they were placed
	// while docked), load the next batch before leaving.
	if(length(SSshuttle.shopping_list))
		deliver_orders()
		if(count_crates_aboard())
			dwell_timer = addtimer(CALLBACK(src, PROC_REF(auto_depart)), CARGO_TRAIN_RECHECK_TIME, TIMER_STOPPABLE)
			return
	depart()

/// Manual departure (console / lever). Returns null on success, else a short reason.
/datum/controller/subsystem/cargo_train/proc/request_departure()
	if(train_state != CARGO_TRAIN_DOCKED)
		return "train isn't docked"
	if(length(get_riders()))
		return "someone is aboard"
	depart()
	return null

/datum/controller/subsystem/cargo_train/proc/get_riders()
	var/list/riders = list()
	for(var/turf/cart_turf as anything in interior_turfs)
		for(var/mob/living/rider in cart_turf)
			if(rider.stat != DEAD)
				riders += rider
	return riders

/datum/controller/subsystem/cargo_train/proc/count_crates_aboard()
	var/count = 0
	for(var/atom/movable/crate as anything in tracked_crates.Copy())
		if(QDELETED(crate) || !(get_turf(crate) in interior_turfs))
			tracked_crates -= crate
			continue
		count++
	return count

/datum/controller/subsystem/cargo_train/proc/get_status_text()
	switch(train_state)
		if(CARGO_TRAIN_ARRIVING)
			return "Arriving"
		if(CARGO_TRAIN_DOCKED)
			return "Docked"
		if(CARGO_TRAIN_DEPARTING)
			return "Departing"
	return "Away"

/datum/controller/subsystem/cargo_train/proc/deliver_orders()
	var/list/free_turfs = list()
	for(var/obj/effect/abstract/cargo_train_spot/spot as anything in landing_spots)
		var/turf/spot_turf = get_turf(spot)
		if(isopenturf(spot_turf) && !spot_turf.is_blocked_turf())
			free_turfs |= spot_turf
	if(!length(free_turfs))
		return 0

	var/delivered = 0
	var/list/goody_groups = list()

	for(var/datum/supply_order/order as anything in SSshuttle.shopping_list.Copy())
		var/is_goody = (order.pack.order_flags & ORDER_GOODY)
		var/group_key = order.paying_account || "cargo"
		// Need somewhere to put it before we take anyone's money.
		if(!length(free_turfs) && !(is_goody && goody_groups[group_key]))
			break

		var/price = order.get_final_cost()
		// Department orders are paid elsewhere.
		if(!order.department_destination && order.charge_on_purchase)
			var/datum/bank_account/payer = order.paying_account || SSeconomy.get_dep_account(ACCOUNT_CAR)
			if(payer && !payer.adjust_money(-price, "Cargo: [order.pack.name]"))
				if(order.paying_account)
					payer.bank_card_talk("Cargo order #[order.id] rejected due to lack of funds. Required: [price] [MONEY_NAME]")
				SSshuttle.shopping_list -= order
				qdel(order)
				continue
			if(order.paying_account)
				payer.bank_card_talk("Cargo order #[order.id] has been delivered.[order.charge_on_purchase ? " [price] [MONEY_NAME] charged to your account." : ""]")

		SSshuttle.shopping_list -= order
		delivered++

		if(is_goody)
			var/list/group = goody_groups[group_key]
			if(!group)
				group = list("turf" = pick_n_take(free_turfs), "account" = order.paying_account, "contents" = list(), "cost" = 0, "ids" = list())
				goody_groups[group_key] = group
			group["contents"] += order.pack.contains
			group["cost"] += order.pack.cost
			group["ids"] += "[order.id]"
			qdel(order)
			continue

		var/obj/structure/closet/crate = order.generate(pick_n_take(free_turfs))
		if(crate)
			crate.name += " - #[order.id]"
			tracked_crates += crate
		qdel(order)

	for(var/key in goody_groups)
		var/list/group = goody_groups[key]
		var/datum/bank_account/buyer = group["account"]
		var/obj/structure/closet/crate/box = new(group["turf"])
		box.name = "goody crate[buyer ? " - [buyer.account_holder]" : ""]"
		var/datum/supply_order/combo = new
		combo.id = jointext(group["ids"], ", ")
		combo.generateCombo(box, buyer ? buyer.account_holder : "Cargo", group["contents"], group["cost"])
		qdel(combo)
		tracked_crates += box

	return delivered

/datum/controller/subsystem/cargo_train/proc/get_exit_turf()
	if(!door_segment || !isturf(door_segment.loc))
		return null
	for(var/side in list(NORTH, SOUTH))
		var/turf/candidate = get_step(door_segment, side)
		if(candidate && !candidate.density)
			return candidate
	return get_turf(door_segment)

#undef CARGO_TRAIN_STORED
#undef CARGO_TRAIN_ARRIVING
#undef CARGO_TRAIN_DOCKED
#undef CARGO_TRAIN_DEPARTING

#undef CARGO_TRAIN_LENGTH
#undef CARGO_TRAIN_CART_LENGTH
#undef CARGO_TRAIN_STEP_DELAY
#undef CARGO_TRAIN_DWELL_TIME
#undef CARGO_TRAIN_RECHECK_TIME
#undef CARGO_TRAIN_FIRST_ARRIVAL
