// WoD13 component
// Items with this component can be sold and will also dictate how much humanity is gained or lost from it.
// To make an item sellable, add component with the args (/datum/component/selling, cost at 5 successes of the roll, category, illegality true or false, humanity lost selling one item, humanity loss limit)

/datum/component/selling
	///Sale price of the item
	var/cost
	///Items of the same category will be mass-sold when click-dragging them
	var/object_category
	///Dictates whether the item can be sold at a pawn shop or black market
	var/illegal
	///Will affect humanity by a specific value when sold, most often with a negative value (such as -1).
	var/humanity_loss
	///Down to what point humanity can be reduced when selling the item.
	var/humanity_loss_limit
	///Does selling this object threaten the masquerade? if so, make a (stat) + subterfuge roll to avoid losing masq
	var/masquerade_violating

/datum/component/selling/Initialize(new_cost, new_object_category, new_illegal, new_humanity_loss, new_humanity_loss_limit, new_masquerade_sensitivity = FALSE)
	if(!isobj(parent)) //Only items can be sold
		return COMPONENT_INCOMPATIBLE
	cost = new_cost
	object_category = new_object_category
	illegal = new_illegal
	humanity_loss = new_humanity_loss
	humanity_loss_limit = new_humanity_loss_limit
	masquerade_violating = new_masquerade_sensitivity

//Whether it can be sold -- overriden by subtypes such as organs, which can only be sold if they have a certain health.
/datum/component/selling/proc/can_sell()
	return TRUE

//Will display a message if it has been sold successfully
/datum/component/selling/proc/sale_success_message()
	return span_notice("You've sold [parent]!")

//Will display a message if it hasn't been sold successfully (such as failing can_sell())
/datum/component/selling/proc/sale_fail_message()
	return span_notice("You cannot sell [parent].")

/datum/component/selling/organ/Initialize(new_cost, new_object_category, new_illegal, new_humanity_loss, new_humanity_loss_limit, new_masquerade_sensitivity = FALSE)
	if(!istype(parent, /obj/item/organ))
		return COMPONENT_INCOMPATIBLE
	..()

/datum/component/selling/organ/can_sell()
	var/obj/item/organ/organ = parent
	if(organ.damage > round(organ.maxHealth / 2))
		return FALSE
	return TRUE

/datum/component/selling/organ/sale_success_message()
	var/obj/item/organ/organ = parent
	var/mob/living/carbon/human/seller

	// Try to find who's selling this (check if it's in someone's hands)
	if(ishuman(organ.loc))
		seller = organ.loc

	// If we found a seller and they're on Enlightenment path, no warning
	if(seller && get_kindred_splat(seller))
		if(seller.is_enlightenment())
			return span_notice("You've sold [parent]!")

	// Default warning for Humanity path or non-vampires
	return span_userdanger("Selling organs is a depraved act! If I keep doing this I will become a wight.")

/datum/component/selling/organ/sale_fail_message()
	var/obj/item/organ/organ = parent
	return span_warning("The [organ.name] is too damaged to sell!")
