/obj/item/stack/dollar
	name = MONEY_NAME // Prob overkill to use the define here.
	desc = "Wow! With enough of these, you could buy a lot! ...Pssh, yeah right."
	singular_name = "dollar"
	icon_state = "money1"
	icon = 'modular_darkpack/modules/deprecated/icons/items.dmi'
	lefthand_file = null
	righthand_file = null
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/deprecated/icons/onfloor.dmi')
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	max_amount = 1000
	merge_type = /obj/item/stack/dollar

/obj/item/stack/dollar/Initialize(mapload, new_amount, merge = TRUE, list/mat_override = null, mat_amt = 1)
	. = ..()
	update_appearance()

/obj/item/stack/dollar/update_icon_state()
	. = ..()
	var/amount = get_amount()
	switch(amount)
		if(100 to INFINITY)
			icon_state = "money3"
		if(50 to 100)
			icon_state = "money2"
		if(1 to 50)
			icon_state = "money1"
		else
			icon_state = "money"

/obj/item/stack/dollar/get_item_credit_value()
	return amount

/obj/item/stack/dollar/five
	amount = 5

/obj/item/stack/dollar/ten
	amount = 10

/obj/item/stack/dollar/twenty
	amount = 20

/obj/item/stack/dollar/fifty
	amount = 50

/obj/item/stack/dollar/hundred
	amount = 100

/obj/item/stack/dollar/two_hundred
	amount = 200

/obj/item/stack/dollar/five_hundred
	amount = 500

/obj/item/stack/dollar/thousand
	amount = 1000


/obj/item/stack/dollar/rand
	amount = 15

/obj/item/stack/dollar/rand/Initialize(mapload, new_amount, merge = TRUE, list/mat_override = null, mat_amt = 1)
	amount = round(gaussian(amount, amount * 0.2))
	. = ..()
	update_appearance()

/obj/item/stack/dollar/rand/ten
	amount = 10

/obj/item/stack/dollar/rand/hundred
	amount = 100
