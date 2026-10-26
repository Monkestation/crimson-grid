/obj/ritual_rune/dark/infernal_sigil // The ritual is unofficial however I think it fits
	name = "infernal sigil"
	desc = "Creates a sigil to earn favor from The Infernal"
	icon_state = "rune8"
	word = "SIG'NUM"
	level = 1
	sacrifices = list(
		/obj/item/reagent_containers/blood,
		/obj/item/reagent_containers/blood,
		/obj/item/reagent_containers/blood,
		/obj/item/reagent_containers/blood,
		/obj/item/reagent_containers/blood,
	)

/obj/ritual_rune/dark/infernal_sigil/complete()
	. = ..()
	new /obj/structure/retail/occult/baali(get_turf(src))
	qdel(src)
