/obj/item/card/park_ranger/staff
	name = "Park Staff badge"
	desc = "A pretty park attracts more visitors. Keep the park clean and tidy."

GLOBAL_DATUM(bank_funds, /obj/item/card/credit/giovanniboss)

/obj/item/card/credit/giovanniboss/Initialize(mapload)
	. = ..()
	GLOB.bank_funds = src

/obj/item/card/credit/giovanniboss/Destroy()
	if (GLOB.bank_funds == src)
		GLOB.bank_funds = null
