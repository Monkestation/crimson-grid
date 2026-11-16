/obj/structure/sign/flag/pride
	name = "coder pride flag"
	desc = "You probably shouldn't be seeing this. Yell at the coders about it."
	icon = 'modular_darkpack/modules/flags/icons/pride_flags.dmi'

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/flag/pride, 32)

/obj/structure/sign/flag/pride/click_alt(mob/user)
	var/init_icon_state = initial(icon_state)
	if(icon_state == init_icon_state)
		icon_state = "[icon_state]_vertical"
	else
		icon_state = init_icon_state
	return CLICK_ACTION_SUCCESS

/obj/structure/sign/flag/pride/gay
	name = "gay pride flag"
	desc = "The flag of gay pride."
	icon_state = "flag_pride"
	item_flag = /obj/item/sign/flag/pride/gay

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/flag/pride/gay, 32)

/obj/structure/sign/flag/pride/ace
	name = "asexual pride flag"
	desc = "The flag of asexual pride."
	icon_state = "flag_ace"
	item_flag = /obj/item/sign/flag/pride/ace

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/flag/pride/ace, 32)

/obj/structure/sign/flag/pride/bi
	name = "bisexual pride flag"
	desc = "The flag of bisexual pride."
	icon_state = "flag_bi"
	item_flag = /obj/item/sign/flag/pride/bi

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/flag/pride/bi, 32)

/obj/structure/sign/flag/pride/lesbian
	name = "lesbian pride flag"
	desc = "The flag of lesbian pride."
	icon_state = "flag_lesbian"
	item_flag = /obj/item/sign/flag/pride/lesbian

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/flag/pride/lesbian, 32)

/obj/structure/sign/flag/pride/pan
	name = "pansexual pride flag"
	desc = "The flag of pansexual pride."
	icon_state = "flag_pan"
	item_flag = /obj/item/sign/flag/pride/pan

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/flag/pride/pan, 32)

/obj/structure/sign/flag/pride/trans
	name = "trans pride flag"
	desc = "The flag of trans pride."
	icon_state = "flag_trans"
	item_flag = /obj/item/sign/flag/pride/trans

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/flag/pride/trans, 32)

/obj/structure/sign/flag/pride/mlm
	name = "men-loving-men pride flag"
	desc = "The flag of men-loving-men pride."
	icon_state = "flag_mlm"
	item_flag = /obj/item/sign/flag/pride/mlm

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/flag/pride/mlm, 32)

/obj/structure/sign/flag/pride/rabies
	name = "rabies pride flag"
	desc = "The flag of rabies pride."
	icon_state = "flag_rabies"
	item_flag = /obj/item/sign/flag/pride/rabies

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/flag/pride/rabies, 32)

/obj/structure/sign/flag/pride/enby
	name = "non-binary pride flag"
	desc = "The flag of non-binary pride."
	icon_state = "flag_enby"
	item_flag = /obj/item/sign/flag/pride/enby

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/flag/pride/enby, 32)

/obj/structure/sign/flag/pride/inter
	name = "intersex pride flag"
	desc = "The flag of intersex pride."
	icon_state = "flag_inter"
	item_flag = /obj/item/sign/flag/pride/inter

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/flag/pride/inter, 32)

// FOLDED

/obj/item/sign/flag/pride
	name = "folded coder pride flag"
	desc = "You probably shouldn't be seeing this. Yell at the coders about it."
	icon = 'modular_darkpack/modules/flags/icons/pride_flags.dmi'

/obj/item/sign/flag/pride/choose
	name = "folded unknown pride flag"
	desc = "Attack in hand to choose a flag."

/obj/item/sign/flag/pride/choose/attack_hand(mob/user)
	. = ..()
	var/obj/item/chosen_flag = tgui_input_list(user, "What pride flag did you have again?", "Choose a flag", subtypesof(/obj/item/sign/flag/pride) - /obj/item/sign/flag/pride/choose)
	if(!ispath(chosen_flag))
		return
	var/obj/item/created_flag = new chosen_flag(loc)
	qdel(src)
	user.put_in_hands(created_flag)

/obj/item/sign/flag/pride/gay
	name = "folded gay pride flag"
	desc = "The folded flag of gay pride."
	icon_state = "folded_pride"
	sign_path = /obj/structure/sign/flag/pride/gay

/obj/item/sign/flag/pride/ace
	name = "folded asexual pride flag"
	desc = "The folded flag of asexual pride."
	icon_state = "folded_pride_ace"
	sign_path = /obj/structure/sign/flag/pride/ace

/obj/item/sign/flag/pride/bi
	name = "folded bisexual pride flag"
	desc = "The folded flag of bisexual pride."
	icon_state = "folded_pride_bi"
	sign_path = /obj/structure/sign/flag/pride/bi

/obj/item/sign/flag/pride/lesbian
	name = "folded lesbian pride flag"
	desc = "The folded flag of lesbian pride."
	icon_state = "folded_pride_lesbian"
	sign_path = /obj/structure/sign/flag/pride/lesbian

/obj/item/sign/flag/pride/pan
	name = "folded pansexual pride flag"
	desc = "The folded flag of pansexual pride."
	icon_state = "folded_pride_pan"
	sign_path = /obj/structure/sign/flag/pride/pan

/obj/item/sign/flag/pride/trans
	name = "folded trans pride flag"
	desc = "The folded flag of trans pride."
	icon_state = "folded_pride_trans"
	sign_path = /obj/structure/sign/flag/pride/trans

/obj/item/sign/flag/pride/mlm
	name = "folded men-loving-men pride flag"
	desc = "The folded flag of men-loving-men pride."
	icon_state = "folded_pride_mlm"
	sign_path = /obj/structure/sign/flag/pride/mlm

/obj/item/sign/flag/pride/rabies
	name = "folded rabies pride flag"
	desc = "The folded flag of rabies pride."
	icon_state = "folded_pride_rabies"
	sign_path = /obj/structure/sign/flag/pride/rabies

/obj/item/sign/flag/pride/enby
	name = "folded non-binary pride flag"
	desc = "The folded flag of non-binary pride."
	icon_state = "folded_pride_enby"
	sign_path = /obj/structure/sign/flag/pride/enby

/obj/item/sign/flag/pride/inter
	name = "folded intersex pride flag"
	desc = "The folded flag of intersex pride."
	icon_state = "folded_pride_inter"
	sign_path = /obj/structure/sign/flag/pride/inter
