/datum/action/cooldown/power/gift/rage_heal
	name = "Rage Heal"
	desc = "This Gift allows the Garou to heal severe injuries with rage."
	button_icon_state = "rage_heal"
	rage_cost = 1
	check_flags = null

/datum/action/cooldown/power/gift/rage_heal/Activate(atom/target)
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/C = owner
		if(C.stat != DEAD)
			SEND_SOUND(owner, sound('modular_darkpack/modules/werewolf_the_apocalypse/sounds/rage_heal.ogg', volume = 50))
			C.adjust_brute_loss(-40*C.auspice.level, TRUE)
			C.adjust_fire_loss(-30*C.auspice.level, TRUE)
			C.adjust_agg_loss(-10*C.auspice.level, TRUE)
			C.adjustToxLoss(-10*C.auspice.level, TRUE)
			C.adjust_oxy_loss(-20*C.auspice.level, TRUE)
			C.adjust_blood_pool(C.auspice.level)
			C.blood_volume = min(C.blood_volume + 56 * C.auspice.level, BLOOD_VOLUME_NORMAL)
			if(ishuman(owner))
				var/mob/living/carbon/human/BD = owner
				if(length(BD.all_wounds))
					var/datum/wound/W = pick(BD.all_wounds)
					W.remove_wound()
				if(length(BD.all_wounds))
					var/datum/wound/W = pick(BD.all_wounds)
					W.remove_wound()
				if(length(BD.all_wounds))
					var/datum/wound/W = pick(BD.all_wounds)
					W.remove_wound()
				if(length(BD.all_wounds))
					var/datum/wound/W = pick(BD.all_wounds)
					W.remove_wound()
				if(length(BD.all_wounds))
					var/datum/wound/W = pick(BD.all_wounds)
					W.remove_wound()

/datum/action/change_apparel
	name = "Change Apparel"
	desc = "Choose the clothes of your Crinos form."
	button_icon_state = "choose_apparel"
	icon_icon = 'modular_darkpack/modules/werewolf_the_apocalypse/icons/werewolf_abilities.dmi'
	check_flags = AB_CHECK_IMMOBILE|AB_CHECK_CONSCIOUS

/datum/action/change_apparel/Activate(atom/target)
	. = ..()
	var/mob/living/carbon/werewolf/crinos/C = owner
	if(C.stat == CONSCIOUS)
		if(C.sprite_apparel == 4)
			C.sprite_apparel = 0
		else
			C.sprite_apparel = min(4, C.sprite_apparel+1)
