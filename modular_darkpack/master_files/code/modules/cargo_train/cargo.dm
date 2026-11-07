#define CARGO_TRAIN_STORED 0
#define CARGO_TRAIN_ARRIVING 1
#define CARGO_TRAIN_DOCKED 2
#define CARGO_TRAIN_DEPARTING 3

/obj/machinery/computer/cargo/proc/apply_train_ui_data(list/data)
	data["location"] = SScargo_train.get_status_text()
	data["away"] = (SScargo_train.train_state == CARGO_TRAIN_STORED)
	data["docked"] = (SScargo_train.train_state == CARGO_TRAIN_STORED || SScargo_train.train_state == CARGO_TRAIN_DOCKED)
	data["loan"] = FALSE
	data["loan_dispatched"] = FALSE

/obj/machinery/computer/cargo/proc/train_send(mob/user)
	if(!SScargo_train.enabled)
		say("The cargo train is unavailable.")
		return TRUE
	switch(SScargo_train.train_state)
		if(CARGO_TRAIN_STORED)
			SScargo_train.recall()
			say("The cargo train has been called and will arrive shortly.")
			user.investigate_log("called the cargo train.", INVESTIGATE_CARGO)
		if(CARGO_TRAIN_DOCKED)
			var/error = SScargo_train.request_departure()
			if(error)
				say("The cargo train can't leave: [error].")
			else
				say("The cargo train is departing.")
				user.investigate_log("sent the cargo train away.", INVESTIGATE_CARGO)
		else
			say("The cargo train is already moving.")
	return TRUE

/datum/export/crate/train
	sales_market = EXPORT_MARKET_CARGO_TRAIN

#undef CARGO_TRAIN_STORED
#undef CARGO_TRAIN_ARRIVING
#undef CARGO_TRAIN_DOCKED
#undef CARGO_TRAIN_DEPARTING
