/obj/structure/lectern
	name = "lectern"
	desc = "This thing would be great cover if someone threw a pair of shoes at you."
	icon = 'modular_darkpack/modules/decor/icons/lectern.dmi'
	icon_state = "lectern"
	density = FALSE
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	pass_flags_self = PASSSTRUCTURE | PASSTABLE | LETPASSTHROW

/obj/structure/lectern/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/soapbox)

/obj/structure/lectern/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	if(default_unfasten_wrench(user, tool))
		return ITEM_INTERACT_SUCCESS

/obj/structure/lectern/pulpit // TODO: make holy for baali repulsion
	name = "pulpit"
	desc = "Like a lectern, but holy."
	icon_state = "pulpit"
