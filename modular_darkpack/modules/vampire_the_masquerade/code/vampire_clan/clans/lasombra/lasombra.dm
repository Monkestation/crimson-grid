/datum/subsplat/vampire_clan/lasombra
	name = "Lasombra"
	id = VAMPIRE_CLAN_LASOMBRA
	desc = "The Lasombra exist for their own success, fighting for personal victories rather than solely for a crown to wear or a throne to sit upon. They believe that might makes right, and are willing to sacrifice anything to achieve their goals. A clan that uses spirituality as a tool rather than seeking honest enlightenment, their fickle loyalties are currently highlighted by half their clan's defection from the Sabbat."
	icon = "lasombra"
	curse = "Technology refuse."
	sense_the_sin_text = "fears change itself evermore."
	clan_disciplines = list(
		/datum/discipline/potence,
		/datum/discipline/dominate,
		/datum/discipline/obtenebration
	)
	clan_traits = list(
		TRAIT_REJECTED_BY_TECHNOLOGY,
		TRAIT_NO_MIRROR_REFLECTION,
		TRAIT_INVISIBLE_TO_CAMERA
	)
	male_clothes = /obj/item/clothing/under/vampire/emo
	female_clothes = /obj/item/clothing/under/vampire/business
	enlightenment = TRUE
	subsplat_keys = /obj/item/vamp/keys/lasombra


/datum/subsplat/vampire_clan/lasombra/psychomania_effect(mob/living/target, mob/living/owner)
	to_chat(target, span_cult("THE SHADOWS BETRAY ME, SEEKING MY LIFE"))
	target.playsound_local(target, "modular_darkpack/modules/powers/sounds/daimonion_laughs/eldritchlaugh.ogg", 50, FALSE)
	target.Paralyze(6 SECONDS)

// Not TTRPG accurate and is pending a rework to use real rolls after #633
/proc/scramble_lasombra_message(message, mob/living/lasombra)
	var/static/list/zalgo_letters = list(
	"̨a", "̡b", "̢c", "̷d", "̶e", "̸f", "̹g", "̺h", "̻i",
	"̼j", "̽k", "̾l", "̿m", "͈n", "͍o", "͎p", "q", "͕r",
	"͓s", "͒t", "̱u", "̲v", "̳w", "͡x", "̨y", "̨z", "̨A",
	"̨B", "̨C", "̨D", "̨E", "̨F", "̨G", "̨H", "̨I", "̨J",
	"̨K", "̨L", "̨M", "̨N", "̨O", "̨P", "̨Q", "̨R", "̨S",
	"̨T", "̨U", "̨V", "̨W", "̨X", "̨Y", "̨Z"
	)
	var/gibberish_message = ""
	var/total_stats = 0
	if(istype(lasombra))
		total_stats = lasombra.st_get_stat(STAT_TECHNOLOGY) * 3 // +3% chance per tech. 15 max, 18 avg, 24 beauty.9
	for(var/i = 1 to length(message))
		var/char = message[i]
		// Randomize or replace characters with gibberish
		var/chance = 70 + total_stats // 70% + total_stats chance per point of social to keep intact.
		if(prob(chance))
			gibberish_message += char
		else
			gibberish_message += pick(zalgo_letters) // Replace with random gibberish letters
	return gibberish_message
