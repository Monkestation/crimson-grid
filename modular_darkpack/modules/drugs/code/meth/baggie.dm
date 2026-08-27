// CRIMSON EDIT ADD START - Drug Fixes
/obj/item/reagent_containers/applicator/baggie
	name = "tiny plastic baggie"
	desc = "A tiny zip bag. What could possibly fit inside it?"
	icon_state = "package_empty"
	icon = 'modular_darkpack/modules/drugs/icons/items.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/drugs/icons/onfloor.dmi')
	volume = 30
	amount_per_transfer_from_this = 10
	initial_reagent_flags = OPENCONTAINER | DRAWABLE | INJECTABLE
	apply_method = "snort"
	self_delay = 1 SECONDS

/obj/item/reagent_containers/applicator/baggie/update_icon_state()
	. = ..()
	icon_state = reagents.total_volume ? initial(icon_state) : "package_empty"

/obj/item/reagent_containers/applicator/baggie/update_name(updates)
	. = ..()
	name = reagents.total_volume ? initial(name) : /obj/item/reagent_containers/applicator/baggie::name

/obj/item/reagent_containers/applicator/baggie/update_desc(updates)
	. = ..()
	desc = reagents.total_volume ? initial(desc) : /obj/item/reagent_containers/applicator/baggie::desc

/obj/item/reagent_containers/applicator/baggie/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(ismob(interacting_with) && !reagents.total_volume)
		balloon_alert(user, "empty!")
		return ITEM_INTERACT_BLOCKING
	return ..()

/obj/item/reagent_containers/applicator/baggie/on_consumption(mob/consumer, mob/giver, list/modifiers)
	if(!reagents.total_volume)
		return
	if(isliving(consumer))
		var/mob/living/sniffer = consumer
		sniffer.emote("sniff")
	reagents.trans_to(consumer, amount_per_transfer_from_this, transferred_by = giver, methods = INHALE)

/obj/item/reagent_containers/applicator/baggie/meth
	name = "baggie of crank"
	desc = "A tiny zip bag of dirty blue-white meth."
	icon_state = "package_meth"
	list_reagents = list(/datum/reagent/drug/methamphetamine = 30)

/obj/item/reagent_containers/applicator/baggie/meth/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 100, "meth", TRUE, -1, 4)
	ADD_TRAIT(src, TRAIT_CONTRABAND, INNATE_TRAIT)

/obj/item/reagent_containers/applicator/baggie/cocaine
	name = "baggie of yayo"
	desc = "A tiny zip bag of fine white cocaine."
	icon_state = "package_cocaine"
	list_reagents = list(/datum/reagent/drug/methamphetamine/cocaine = 30)

/obj/item/reagent_containers/applicator/baggie/cocaine/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 100, "cocaine", TRUE, -1, 5)
	ADD_TRAIT(src, TRAIT_CONTRABAND, INNATE_TRAIT)
// CRIMSON EDIT ADD END - Drug Fixes
