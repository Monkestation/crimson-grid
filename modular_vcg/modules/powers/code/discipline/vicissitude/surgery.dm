/datum/surgery_operation/limb/bioware/reinforce_body
	name = "reinforce body"
	desc = "Reinforce the body with more meat and mass, reducing the severity of incoming damage"
	implements = list(/obj/item/stack/sheet/meat = 1)
	status_effect_gained = /datum/status_effect/bioware/body/reinforced

/datum/surgery_operation/limb/bioware/reinforce_body/get_default_radial_image()
	return image(/obj/item/stack/sheet/meat)

/datum/surgery_operation/limb/bioware/reinforce_body/tool_check(obj/item/tool)
	var/obj/item/stack/tool_stack = tool
	return tool_stack.amount >= 50

/datum/surgery_operation/limb/bioware/reinforce_body/on_preop(obj/item/bodypart/limb, mob/living/surgeon, tool)
	display_results(
		surgeon,
		limb.owner,
		span_notice("You start wrapping meat around [limb.owner]'s body."),
		span_notice("[surgeon] starts wrapping meat around [limb.owner]'s body."),
		span_notice("[surgeon] starts manipulating [limb.owner]'s body."),
	)
	display_pain(limb.owner, "Your entire body burns in agony!")

/datum/surgery_operation/limb/bioware/reinforce_body/on_success(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	. = ..()
	var/obj/item/stack/tool_stack = tool
	tool_stack.use(49)
	display_results(
		surgeon,
		limb.owner,
		span_notice("You reshape [limb.owner]'s body, adding more mass!"),
		span_notice("[surgeon] reshapes [limb.owner]'s body, adding more mass!"),
		span_notice("[surgeon] finishes manipulating [limb.owner]'s body."),
	)
	display_pain(limb.owner, "You can feel padding in your body!")

/datum/status_effect/bioware/body/reinforced

/datum/status_effect/bioware/body/reinforced/bioware_gained()
	var/mob/living/carbon/human/human_owner = owner
	human_owner.physiology.brute_mod *= 0.8
	owner.add_traits(TRAIT_HARDLY_WOUNDED, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/bioware/body/reinforced/bioware_lost()
	var/mob/living/carbon/human/human_owner = owner
	human_owner.physiology.brute_mod /= 0.8
	owner.remove_traits(TRAIT_HARDLY_WOUNDED, TRAIT_STATUS_EFFECT(id))
