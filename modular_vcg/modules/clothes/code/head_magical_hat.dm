#define RABBIT_CD_TIME (30 SECONDS)

/obj/item/clothing/head/vampire/voodoohat/magic
	name = "magical voodoo hat"
	desc = "an entire menagerie can be heard within this quite eccentrically-made hat."
	actions_types = list(/datum/action/cooldown/spell/hat_trick)

	/// Cooldown for how often we can pull rabbits out of here

/datum/action/cooldown/spell/hat_trick
	name = "Hat Trick"
	desc = "Reach into your hat and pull out what awaits you inside!"
	button_icon = 'modular_vcg/modules/clothes/icons/clothing.dmi'
	button_icon_state = "voodoo_hat"

	cooldown_time = 30 SECONDS
	spell_requirements = NONE

///obj/item/clothing/head/vampire/voodoohat/magic/proc/spell_cooldown(mob/caster)

/datum/action/cooldown/spell/hat_trick/cast(mob/living/carbon/cast_on)
	. = ..()

	if(prob(10))
		cast_on.visible_message(span_danger("[cast_on] reaches in and pulls out a bu- wait, those are bees!"), span_danger("You rummage through your hat and pull out... <b>BEES!</b>"))
		var/wait_how_many_bees_did_that_guy_pull_out_of_his_hat = rand(4, 8)
		for(var/b in 1 to wait_how_many_bees_did_that_guy_pull_out_of_his_hat)
			var/mob/living/basic/bee/spawned_bees = new(get_turf(cast_on))
			if(prob(20))
				spawned_bees.say(pick("BUZZ BUZZ!", "BZZZZZZZZZ!", "BZZZZZZZZ BUZZ!"))
	else
		cast_on.visible_message(span_notice("[cast_on] wiggles their fingers, then reaches in and pulls out a bunny! Cute!"), span_notice("You reach into your hat and pull out a cute bunny!"))
		var/mob/living/basic/rabbit/bunbun = new(get_turf(cast_on))
		bunbun.mob_try_pickup(cast_on, instant=TRUE)

