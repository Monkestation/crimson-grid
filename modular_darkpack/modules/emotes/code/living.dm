/datum/emote/living/nodnod
	key = "nod2"
	key_third_person = "nod2s"
	message = "nods twice."
	message_param = "nods twice at %t."

/datum/emote/living/blush
	sound = 'modular_darkpack/modules/emotes/sound/blush.ogg'

/datum/emote/living/snap2
	key = "snap2"
	key_third_person = "snaps twice"
	message = "snaps twice."
	message_param = "snaps twice at %t."
	emote_type = EMOTE_AUDIBLE
	hands_use_check = TRUE
	vary = TRUE
	sound = 'modular_darkpack/modules/emotes/sound/snap2.ogg'

/datum/emote/living/snap3
	key = "snap3"
	key_third_person = "snaps thrice"
	message = "snaps thrice."
	message_param = "snaps thrice at %t."
	emote_type = EMOTE_AUDIBLE
	hands_use_check = TRUE
	vary = TRUE
	sound = 'modular_darkpack/modules/emotes/sound/snap3.ogg'

/datum/emote/living/mousesqueak
	key = "squeak"
	key_third_person = "squeaks"
	message = "squeaks!"
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	sound = 'sound/mobs/non-humanoids/mouse/mousesqueek.ogg'

/datum/emote/living/pop
	key = "pop"
	key_third_person = "pops"
	message = "makes a popping sound."
	message_param = "makes a popping sound at %t."
	message_mime = "makes a silent pop."
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	sound = 'modular_darkpack/modules/emotes/sound/slime_pop.ogg'

/datum/emote/living/meow
	key = "meow"
	key_third_person = "meows"
	message = "meows!"
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	sound = /datum/sound_effect/assoc/cat_meow

/datum/emote/living/headtilt
	key = "tilt"
	key_third_person = "tilts"
	message = "tilts their head."
	message_AI = "tilts the image on their display."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/blink2
	key = "blink2"
	key_third_person = "blinks twice"
	message = "blinks twice."
	message_AI = "has their display flicker twice."

/datum/emote/living/rblink
	key = "rblink"
	key_third_person = "rapidly blinks"
	message = "rapidly blinks!"
	message_AI = "has their display port flash rapidly!"
	sound = 'modular_darkpack/modules/emotes/sound/blinkrapid.ogg'

/datum/emote/living/smirk
	key = "smirk"
	key_third_person = "smirks"
	message = "smirks."

/datum/emote/living/eyeroll
	key = "eyeroll"
	key_third_person = "rolls their eyes"
	message = "rolls their eyes."

/datum/emote/living/huff
	key = "huff"
	key_third_person = "huffs"
	message = "huffs!"

/datum/emote/living/etwitch
	key = "etwitch"
	key_third_person = "twitches their ears"
	message = "twitches their ears"

/datum/emote/living/caw
	key = "caw"
	key_third_person = "caws"
	message = "caws!"
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	sound = 'modular_darkpack/modules/emotes/sound/caw.ogg'

/datum/emote/living/caw2
	key = "caw2"
	key_third_person = "caws twice"
	message = "caws twice!"
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	sound = 'modular_darkpack/modules/emotes/sound/caw2.ogg'

/datum/emote/living/cackle
	key = "cackle"
	key_third_person = "cackles"
	message = "cackles hysterically!"
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	sound = 'modular_darkpack/modules/emotes/sound/cackle_yeen.ogg'

/datum/emote/living/mggaow
	key = "mggaow"
	key_third_person = "meows loudly"
	message = "meows loudly!"
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	sound = 'modular_darkpack/modules/emotes/sound/mggaow.ogg'

/datum/emote/living/thump
	key = "thump"
	key_third_person = "thumps"
	message = "thumps their foot!"
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	sound = 'sound/effects/glass/glassbash.ogg'

/datum/emote/living/gulp
	key = "gulp"
	key_third_person = "gulps"
	message = "gulps nervously."
	message_mime = "gulps silently!"
	vary = TRUE
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/living/gulp/get_sound(mob/living/user)
	return pick(
		'modular_darkpack/modules/emotes/sound/gulp1.ogg',
		'modular_darkpack/modules/emotes/sound/gulp2.ogg',
	)

/datum/emote/living/carbon/wink
	sound = 'modular_darkpack/modules/emotes/sound/wink.ogg'

/datum/emote/living/carbon/human/blink
	sound = 'modular_darkpack/modules/emotes/sound/blink.ogg'

/datum/emote/living/giggle/get_sound(mob/living/carbon/human/user)
	if(!istype(user))
		return
	if(user.physique == FEMALE)
		return pick(
			'modular_darkpack/modules/emotes/sound/female/female_giggle_1.ogg',
			'modular_darkpack/modules/emotes/sound/female/female_giggle_2.ogg',
			'modular_darkpack/modules/emotes/sound/female/female_giggle_3.ogg',
			'modular_darkpack/modules/emotes/sound/female/female_giggle_4.ogg',
		)
	return pick(
		'modular_darkpack/modules/emotes/sound/male/male_giggle_1.ogg',
		'modular_darkpack/modules/emotes/sound/male/male_giggle_1.ogg',
		'modular_darkpack/modules/emotes/sound/male/male_giggle_1.ogg',
	)
