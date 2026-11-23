/datum/emote/living/growl
	key = "growl"
	key_third_person = "growls"
	message = "growls!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/living/growl/get_sound(mob/living/carbon/human/user)
	if(!istype(user))
		return
	return user.dna.species.get_growl_sound(user)

/// Returns the species' growl sound
/datum/species/proc/get_growl_sound(mob/living/carbon/human/human)
	if(human.physique == FEMALE)
		return 'modular_darkpack/modules/werewolf_the_apocalypse/sounds/emotes/female_growl.ogg'
	return 'modular_darkpack/modules/werewolf_the_apocalypse/sounds/emotes/male_growl.ogg'

/datum/species/human/shifter/war/get_growl_sound(mob/living/carbon/human/human)
	return 'modular_darkpack/modules/werewolf_the_apocalypse/sounds/emotes/crinos_growl.ogg'
/datum/species/human/shifter/dire/get_growl_sound(mob/living/carbon/human/human)
	return 'modular_darkpack/modules/werewolf_the_apocalypse/sounds/emotes/crinos_growl.ogg'
/datum/species/human/shifter/feral/get_growl_sound(mob/living/carbon/human/human)
	return 'modular_darkpack/modules/werewolf_the_apocalypse/sounds/emotes/lupus_growl.ogg'

/datum/emote/living/warcry
	abstract_type = /datum/emote/living/warcry
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/living/warcry/get_range(mob/living/user)
	if(HAS_TRAIT(user, TRAIT_LOUD_WARCRY))
		return 60

/datum/emote/living/warcry/howl
	key = "howl"
	key_third_person = "howls"
	message = "howls!"
	message_param = "howls for %t!"

/datum/emote/living/warcry/howl/get_sound(mob/living/user)
	var/static/list/howl_sounds = list(
		'modular_darkpack/modules/werewolf_the_apocalypse/sounds/emotes/awo1.ogg',
		'modular_darkpack/modules/werewolf_the_apocalypse/sounds/emotes/awo2.ogg',
	)
	if(isdog(user) || istype(user, /mob/living/basic/mining/wolf))
		return pick(howl_sounds)

	if(get_garou_splat(user))
		return pick(howl_sounds)

	if(user.is_clan(/datum/subsplat/vampire_clan/gangrel))
		return pick(howl_sounds)

/datum/emote/living/warcry/howl/get_range(mob/living/user)
	. = ..()

	if(isdog(user) || istype(user, /mob/living/basic/mining/wolf))
		return 7

	if(get_garou_splat(user))
		return 15

	if(user.is_clan(/datum/subsplat/vampire_clan/gangrel))
		return 7


/datum/emote/living/warcry/caw
	key = "caw"
	key_third_person = "caws"
	message = "caws!"

/datum/emote/living/warcry/caw/get_sound(mob/living/carbon/human/user)
	if(!istype(user))
		return
	return user.dna.species.get_caw_sound(user)

/datum/species/proc/get_caw_sound(mob/living/carbon/human/human)
	return

/datum/species/human/shifter/get_caw_sound(mob/living/carbon/human/human)
	if(get_corax_splat(human))
		return 'modular_darkpack/modules/werewolf_the_apocalypse/sounds/emotes/caw.ogg'

/datum/species/human/shifter/war/get_caw_sound(mob/living/carbon/human/human)
	if(get_corax_splat(human))
		return 'modular_darkpack/modules/werewolf_the_apocalypse/sounds/emotes/cawcrinos.ogg'

/datum/species/human/shifter/war/get_roar_sound(mob/living/carbon/human/human)
	return 'modular_darkpack/modules/werewolf_the_apocalypse/sounds/emotes/crinos_roar.ogg'
