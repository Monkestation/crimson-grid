#define RABBIT_CD_TIME (30 SECONDS)

/obj/item/clothing/head/vampire/voodoohat/magic
	name = "magical voodoo hat"
	desc = "an entire menagerie can be heard within this quite eccentrically-made hat."
	actions_types = list(/datum/action/cooldown/spell/hat_trick)

	/// Cooldown for how often we can pull rabbits out of here
	COOLDOWN_DECLARE(rabbit_cooldown)

/datum/action/cooldown/spell/hat_trick
	name = "Hat Trick"
	desc = "Reach into your hat and pull out what awaits you inside!"
	button_icon_state = "voodoo hat"

	cooldown_time = 30 SECONDS
	spell_requirements = NONE

///datum/action/cooldown/spell/hat_trick/cast(atom/cast_on)
//	. = ..()
//	abracadabra(cast_on)

///obj/item/clothing/head/voodoohat/vampire/magicvoodoohat/item_interaction(mob/living/user)

//	abracadabra(user)a
//return ITEM_INTERACT_SUCCESS

/obj/item/clothing/head/vampire/voodoohat/magic/proc/abracadabra(mob/magician)
	if(!COOLDOWN_FINISHED(src, rabbit_cooldown))
		to_chat(magician, span_warning("You can't find another rabbit in [src]! Seems another hasn't gotten lost in there yet..."))
		return

	COOLDOWN_START(src, rabbit_cooldown, RABBIT_CD_TIME)
	playsound(get_turf(src), 'sound/items/weapons/emitter.ogg', 70)
	do_smoke(1, src, src, effect_type = /obj/effect/particle_effect/fluid/smoke/quick)

	if(prob(10))
		magician.visible_message(span_danger("[magician] reaches in and pulls out a bu- wait, those are bees!"), span_danger("You rummage through your hat and pull out... <b>BEES!</b>"))
		var/wait_how_many_bees_did_that_guy_pull_out_of_his_hat = rand(4, 8)
		for(var/b in 1 to wait_how_many_bees_did_that_guy_pull_out_of_his_hat)
			var/mob/living/basic/bee/barry = new(get_turf(magician))
			if(prob(20))
				barry.say(pick("BUZZ BUZZ", "PULLING A RABBIT OUT OF A HAT IS A TIRED TROPE", "I DIDN'T ASK TO BEE HERE"), forced = "bee hat")
	else
		magician.visible_message(span_notice("[magician] wiggles their fingers, then reaches in and pulls out a bunny! Cute!"), span_notice("You reach into your hat and pull out a cute bunny!"))
		var/mob/living/basic/rabbit/bunbun = new(get_turf(magician))
		bunbun.mob_try_pickup(magician, instant=TRUE)
