/datum/armor/weekapaug_thistle
	melee = 10
	bullet = 10

/obj/item/occult_artifact/vampire/weekapaug_thistle
	true_name = "Weekapaug Thistle"
	true_desc = "Increases combat defense."
	icon_state = "w_thistle"
	research_value = 10

/obj/item/occult_artifact/vampire/weekapaug_thistle/grant_powers()
	. = ..()
	owner.add_inner_armor(/datum/armor/weekapaug_thistle)

/obj/item/occult_artifact/vampire/weekapaug_thistle/ungrant_powers()
	. = ..()
	owner.remove_inner_armor(/datum/armor/weekapaug_thistle)
