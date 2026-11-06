/obj/item/phone_book
	name = "phone book"
	desc = "Все действующие номера города под одной обложкой."
	icon_state = "phonebook"
	icon = 'modular_darkpack/modules/phones/icons/phone.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/phones/icons/phone_onfloor.dmi')
	w_class = WEIGHT_CLASS_SMALL

/obj/item/phone_book/attack_self(mob/user)
	. = ..()
	/* CORVAX EDIT REMOVAL START - PHONE_BOOK
	for(var/i in SSphones.assigned_phone_numbers)
		to_chat(user, "[SSphones.assigned_phone_numbers[i]]")
	*/ // CORVAX EDIT REMOVAL END
	show_directory(user) // CORVAX EDIT ADD - PHONE_BOOK
