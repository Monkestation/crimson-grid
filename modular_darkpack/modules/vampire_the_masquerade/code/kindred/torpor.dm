/mob/living/proc/torpor(source = DAMAGE_TRAIT, force)
	if(HAS_TRAIT(src, TRAIT_TORPOR))
		return

	fakedeath(source)

	to_chat(src, span_danger("You have fallen into Torpor. Use the button in the top right to learn more, or attempt to wake up."))
	throw_alert(ALERT_UNTORPOR, /atom/movable/screen/alert/untorpor)
	ADD_TRAIT(src, TRAIT_TORPOR, source)
	if(get_kindred_splat(src) && !force)
		var/mob/living/carbon/human/vampire = src
		var/datum/splat/vampire/kindred/vampirism = get_kindred_splat(vampire)
		var/morality_score = st_get_stat(STAT_MORALITY)
		var/torpor_time = (14 - morality_score) MINUTES
		COOLDOWN_START(vampirism, torpor_timer, torpor_time)
//	RegisterSignal(new_kindred, COMSIG_PATH_HIT, PROC_REF(adjust_morality))

/mob/living/proc/cure_torpor(source, force)
	if(!HAS_TRAIT_FROM(src, TRAIT_TORPOR, source))
		return

	// Heal to a tiny bit above crit, with less severe damage types being healed first
	var/amount_to_heal = HEALTH_THRESHOLD_CRIT + 5 - health
	if((amount_to_heal > 0) && !force)
		heal_ordered_damage(amount_to_heal, list(STAMINA, OXY, BRUTE, TOX, BURN))

	cure_fakedeath(source)
	clear_alert(ALERT_UNTORPOR)
	REMOVE_TRAIT(src, TRAIT_TORPOR, source)
	to_chat(src, span_notice("You have awoken from your Torpor."))

/mob/living/proc/untorpor()
	if(!HAS_TRAIT(src, TRAIT_TORPOR))
		return

	if(get_kindred_splat(src))
		if(bloodpool > 0)
			adjust_blood_pool(-1)
			cure_torpor(DAMAGE_TRAIT)
			to_chat(src, span_notice("You have awoken from your Torpor."))
		else
			to_chat(src, span_warning("You have no blood to re-awaken with..."))

/atom/movable/screen/alert/untorpor
	name = "Awaken"
	desc = "Free yourself of your Torpor."
	icon = 'modular_darkpack/modules/deprecated/icons/hud/screen_alert.dmi'
	icon_state = "awaken"

/atom/movable/screen/alert/untorpor/Click()
	. = ..()
	if(!.)
		return

	if(!isliving(owner))
		return
	var/mob/living/living_owner = owner

	if(living_owner.stat == DEAD)
		to_chat(living_owner, span_warning("You have suffered Final Death. You will not wake up."))
		return

	if(get_kindred_splat(living_owner))
		var/mob/living/carbon/human/vampire = living_owner
		var/datum/splat/vampire/kindred/vampirism = get_kindred_splat(vampire)
		if(!COOLDOWN_STARTED(vampirism, torpor_timer))
			to_chat(owner, span_purple(span_italics("You are in Torpor, the sleep of death that vampires go into when injured, starved, or exhausted.")))
			to_chat(owner, span_danger(span_italics("You will re-awaken once the stake in your heart is removed by an outside source.")))
			return
		if(COOLDOWN_FINISHED(vampirism, torpor_timer) && (vampire.bloodpool > 0))
			vampire.untorpor()
		else
			to_chat(owner, span_purple(span_italics("You are in Torpor, the sleep of death that vampires go into when injured, starved, or exhausted.")))
			if (vampire.bloodpool > 0)
				to_chat(owner, span_purple(span_italics("You will be able to awaken in <b>[DisplayTimeText(COOLDOWN_TIMELEFT(vampirism, torpor_timer))]</b>.")))
			else
				to_chat(owner, span_danger(span_italics("You will not be able to re-awaken, because you have no blood available to do so.")))
