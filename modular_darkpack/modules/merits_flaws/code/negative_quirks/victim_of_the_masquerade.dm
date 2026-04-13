/datum/quirk/darkpack/victim_of_the_masquerade
	name = "Victim of the Masquerade"
	desc = "The Camarilla's propaganda machine did a good job with you. Even after your character's Embrace, they refused to believe they are a vampire. They remain convinced there must be some logical explanation for their condition, and spend as much time as possible justifying it. You must make a willpower roll whenever feeding and each time you draw a bloodpoint from your victim. When you fail, your character faints for five seconds while also losing a point in their Humanity. You are expected to roleplay this flaw - such as insisting on eating regular food and not feeding."
	value = -2
	mob_trait = TRAIT_VICTIM_OF_THE_MASQUERADE
	gain_text = span_notice("Pff, I'm not a vamprie. Those don't exist.")
	lose_text = span_notice("I might be a vampire.")
	allowed_splats = list(SPLAT_KINDRED)
	icon = FA_ICON_DIZZY
	failure_message = "I might be a vampire."
	var/datum/storyteller_roll/victim_of_the_masquerade/victim_of_the_masquerade_roll

/datum/storyteller_roll/victim_of_the_masquerade
	bumper_text = "victim of the masquerade"
	applicable_stats = list(STAT_TEMPORARY_WILLPOWER)
	difficulty = 6
	roll_output_type = ROLL_PRIVATE
