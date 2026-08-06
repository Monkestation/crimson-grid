/datum/subsplat/vampire_clan/true_brujah
	name = "True Brujah"
	id = VAMPIRE_CLAN_TRUE_BRUJAH
	desc = "The True Brujah are a bloodline of Clan Brujah that claim to be descendants of the original Antediluvian founder of the lineage and not his diablerist/childe Troile. They are also noted for their calm, detached behavior, which puts them in contrast to the main lineage who are known for their rather short, violent tempers and anti-establishment attitudes. "
	icon = "true_brujah"
	curse = "Absence of passion."
	sense_the_sin_text = "cant express emotions."
	clan_disciplines = list(
		/datum/discipline/potence,
		/datum/discipline/presence,
		/datum/discipline/temporis
	)
	/obj/item/vamp/keys/brujah
	enlightenment = TRUE
	male_clothes = /obj/item/clothing/under/vampire/rich
	female_clothes = /obj/item/clothing/under/vampire/business
	restricted_disciplines = list(/datum/discipline/celerity)
	whitelisted = TRUE
