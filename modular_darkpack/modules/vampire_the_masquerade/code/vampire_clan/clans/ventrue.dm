/datum/subsplat/vampire_clan/ventrue
	name = "Ventrue"
	id = VAMPIRE_CLAN_VENTRUE
	desc = "The Ventrue are not called the Clan of Kings for nothing. Carefully choosing their progeny from mortals familiar with power, wealth, and influence, the Ventrue style themselves the aristocrats of the vampire world. Their members are expected to assume command wherever possible, and they're willing to endure storms for the sake of leading from the front. The Ventrue are aristocrats, executives, and rulers who stand at the center of Camarilla authority in many cities. With a Ventrue elder often holding praxis as Prince, the Clan holds prestige and influence throughout local politics. Ventrue believe leadership is both their right and responsibility, though many see them as arrogant elitists obsessed with control. Full of pride, most Ventrue can trace their lineage of embraces back to the Clan Founder. Their curse restricts them to feeding only from highly specific vessels."
	icon = "ventrue"
	curse = "Low-rank and animal blood is disgusting."
	roleplay_level = "Intermediate"
	sense_the_sin_text = "finds no pleasure in poor's blood."
	clan_disciplines = list(
		/datum/discipline/dominate,
		/datum/discipline/fortitude,
		/datum/discipline/presence
	)
	clan_traits = list(
		TRAIT_FEEDING_RESTRICTION
	)
	male_clothes = /obj/item/clothing/under/vampire/ventrue
	female_clothes = /obj/item/clothing/under/vampire/ventrue/female
	subsplat_keys = /obj/item/vamp/keys/ventrue

/datum/subsplat/vampire_clan/ventrue/antitribu
	name = "Ventrue antitribu"
	id = VAMPIRE_CLAN_VENTRUE_ANTITRIBU
	desc = "While the traditional line of the Ventrue blood is famously associated with the 'magnanimous' lords and ladies of the Camarilla, who prefer to maintain their rule over humanity through the masquerade and intricate networks of ghouls and proxies in service of the Antediluvians and their sires, the Ventrue Antitribu are the Dark Knights and Crusaders of the Sabbat, sworn to combat the meek Camarilla who would rule with soft-power in service of the Third Generation of Kindred-kind who famously betrayed Caine, the Dark Father of all Vampires."
	icon = "ventrue_antitribu"
	roleplay_level = "Advanced"
	clan_disciplines = list(
		/datum/discipline/dominate,
		/datum/discipline/fortitude,
		/datum/discipline/auspex
	)
