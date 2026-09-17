/obj/item/masquerade_contract
	name = "\improper elegant scroll"
	desc = "An elegant looking scroll."
	icon = 'modular_darkpack/modules/masquerade/icons/masquerade_contract.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/masquerade/icons/onfloor.dmi')
	icon_state = "masquerade"
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	armor_type = /datum/armor/masquerade_contract
	resistance_flags = FIRE_PROOF | ACID_PROOF

/datum/armor/masquerade_contract
	fire = 100
	acid = 100

/obj/item/masquerade_contract/attack_self(mob/user, modifiers)
	. = ..()
	if(!get_vampire_splat(user))
		return
	var/turf/current_location = get_turf(user)
	to_chat(user, "[span_bold("YOU")], [get_area_name(user)] X:[current_location.x] Y:[current_location.y] Z:[current_location.z]")
	for(var/mob/living/carbon/breacher in GLOB.masquerade_breakers_list)
		var/location_info
		var/turf/turf = get_turf(breacher)
		if(breacher.masquerade_score <= 2)
			location_info = "[get_area_name(turf)], X:[turf.x] Y:[turf.y] Z:[turf.z]"
		else
			location_info = "[get_area_name(turf)]"
		to_chat(user, span_info("[breacher.real_name], Masquerade Breaches: [5 - breacher.masquerade_score], Diablerist: [(HAS_TRAIT(breacher, TRAIT_DIABLERIE) && !HAS_TRAIT(breacher, TRAIT_HIDDEN_DIABLERIE)) ? "<b>YES</b>" : "NO"], [location_info]")) // CRIMSON EDIT CHANGE - Original: to_chat(user, span_info("[breacher.real_name], Masquerade: [breacher.masquerade_score], Diablerist: [(HAS_TRAIT(breacher, TRAIT_DIABLERIE) && !HAS_TRAIT(breacher, TRAIT_HIDDEN_DIABLERIE)) ? "<b>YES</b>" : "NO"], [location_info]"))

	if(!GLOB.masquerade_breakers_list)
		to_chat(user, span_info("No available Masquerade breakers in city..."))

/obj/item/veil_contract
	name = "\improper brass pocketwatch"
	desc = "A posh looking pocketwatch."
	icon = 'modular_darkpack/modules/masquerade/icons/masquerade_contract.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/masquerade/icons/onfloor.dmi')
	icon_state = "pocketwatch"
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	armor_type = /datum/armor/masquerade_contract
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/veil_contract/attack_self(mob/user, modifiers)
	. = ..()
	if(!get_werewolf_splat(user))
		return
	var/turf/current_location = get_turf(user)
	to_chat(user, "[span_bold("YOU")], [get_area_name(user)] X:[current_location.x] Y:[current_location.y] Z:[current_location.z]")
	for(var/mob/living/breacher in GLOB.veil_breakers_list)
		var/location_info
		var/turf/turf = get_turf(breacher)
		if(breacher.masquerade_score <= 2)
			location_info = "[get_area_name(turf)], X:[turf.x] Y:[turf.y] Z:[turf.z]"
		else
			location_info = "[get_area_name(turf)]"
		to_chat(user, span_info("[breacher.real_name], Veil: [breacher.masquerade_score], [location_info]"))

	if(!GLOB.veil_breakers_list)
		to_chat(user, span_info("No available Veil breakers in city..."))

/obj/item/intel_report
	name = "intelligence report"
	desc = "A file with information of note on local operations, listing persons of interests."
	icon = 'icons/obj/service/bureaucracy.dmi'
	icon_state = "docs_part"
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	armor_type = /datum/armor/masquerade_contract
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/intel_report/attack_self(mob/user, modifiers)
	. = ..()
	var/turf/current_location = get_turf(user)
	to_chat(user, span_info("[span_bold("YOU")], [get_area_name(user)] X:[current_location.x] Y:[current_location.y] Z:[current_location.z]"))
	for(var/mob/living/breacher in GLOB.supernatural_breakers_list)
		var/location_info
		var/turf/turf = get_turf(breacher)
		if(breacher.masquerade_score <= 2)
			location_info = "[get_area_name(turf)], X:[turf.x] Y:[turf.y] Z:[turf.z]"
		else
			location_info = "[get_area_name(turf)]"
		to_chat(user, span_info("[breacher.real_name], Veil: [breacher.masquerade_score], [location_info]"))

	if(!GLOB.supernatural_breakers_list)
		to_chat(user, span_info("No available freaks of nature in city..."))

// CRIMSON EDIT ADD START - Sell Valuables
/obj/item/veil_contract/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 100, "watch", FALSE)
// CRIMSON EDIT ADD END - Sell Valuables
