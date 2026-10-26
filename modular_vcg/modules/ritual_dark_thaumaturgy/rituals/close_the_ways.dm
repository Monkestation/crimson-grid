/obj/ritual_rune/dark/close_the_ways
	name = "close the ways"
	desc = "Deluges your target with a tide of terrible misfortune"
	icon_state = "rune5"
	word = "VIAS'SEMITAS"
	level = 5
	cost = 1
	var/flames_extinguished = 0
	var/flames_needed = 14
	var/mob/living/carbon/human/owner
	var/mob/living/carbon/human/target
	var/duration

/obj/ritual_rune/dark/close_the_ways/complete()
	. = ..()
	if(ishuman(usr))
		owner = usr
		var/target_name = tgui_input_text(owner, "Choose target name:", "Curse Rune")
		if(!target_name || !owner.Adjacent(src)) // Check if user is still nearby
			to_chat(owner, span_warning("You must specify a target and remain close to the rune!"))
			return
		if(last_sucess_amount <= 0)
			to_chat(owner, span_warning("The rite fails to take hold."))
			qdel(src)
			return
		duration = last_sucess_amount * 15 MINUTES // Much longer times in lore, but would be unbalanced
		for(var/mob/living/carbon/human/human_target in GLOB.player_list)
			if(human_target.real_name == target_name)
				target = human_target
				RegisterSignal(owner, COMSIG_MOB_EQUIPPED_ITEM, PROC_REF(on_candle_equip))
				to_chat(owner, span_notice("The ritual is successful. Now extinguish [flames_needed] candles."))
				log_combat(owner, human_target, "Close the Ways Preparation")
				return
		to_chat(owner, span_warning("There's no such target, the rite fails to take hold."))
		qdel(src)

/obj/ritual_rune/dark/close_the_ways/Destroy(force)
	if(owner)
		UnregisterSignal(owner, COMSIG_MOB_EQUIPPED_ITEM)
	return ..()

/obj/ritual_rune/dark/close_the_ways/proc/on_candle_equip(datum/source, obj/item/item)
	SIGNAL_HANDLER

	if(!istype(item, /obj/item/flashlight/flare/candle))
		return
	if(QDELETED(target))
		UnregisterSignal(owner, COMSIG_MOB_EQUIPPED_ITEM)
		qdel(src)
		return
	if(!owner.Adjacent(src))
		return
	var/obj/item/flashlight/flare/candle/candle = item
	if(candle.light_on)
		owner.say(target.real_name)
		candle.visible_message(span_warning("The candle vanishes in a poof of smoke."))
		qdel(candle)
		flames_extinguished++
		to_chat(owner, span_notice("[flames_needed-flames_extinguished] candles remain."))
	if(flames_extinguished >= flames_needed)
		owner.st_change_stat(STAT_PERMANENT_WILLPOWER, -2)
		to_chat(owner, span_warning("As you extinguish the last candle, the rite takes hold."))
		log_combat(owner, target, "Close the Ways")
		UnregisterSignal(owner, COMSIG_MOB_EQUIPPED_ITEM)
		target.apply_status_effect(/datum/status_effect/close_the_ways, duration)
		qdel(src)
