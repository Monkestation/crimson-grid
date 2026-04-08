/datum/quirk/darkpack/horrific_appearance
	name = "Horrific Appearance"
	desc = "An increasingly common occurance among Clan Cappadocian is the excentuation of their Clan's curse. Numerous Cappadocians, already prone to appearing as walking corpses, have shown signs of accelerated corpse decay. Their skin draws tight over their bones and scales off in patches, along with excessive decomposition of the body, resulting in the loss of the nose and ears. Cappadocians suffering this flaw must always have an appearance of zero, and their face causes a masquerade breach, requiring the hiding of their appearance through disciplines or masks."
	value = -3
	mob_trait = TRAIT_HORRIFIC_APPEARANCE
	gain_text = span_notice("Your corpsely body shows signs of accelerated decay!")
	lose_text = span_notice("The skin on your corpsely flesh returns to normal.")
	allowed_splats = list(SPLAT_KINDRED)
	included_clans = list(VAMPIRE_CLAN_CAPPADOCIAN)
	icon = FA_ICON_SKULL
	failure_message = "The skin on your corpsely flesh returns to normal."

/datum/quirk/darkpack/horrific_appearance/add_to_holder(mob/living/new_holder, quirk_transfer, client/client_source, unique, announce)
	. = ..()
	if(ishuman(new_holder))
		var/mob/living/carbon/human/human_holder = new_holder
		var/years_undead = human_holder.chronological_age - human_holder.age
		switch(years_undead)
			if (-INFINITY to 500)
				human_holder.rot_body(3)
			if (500 to INFINITY)
				human_holder.rot_body(4)
		if(human_holder.st_get_stat(STAT_APPEARANCE) > 0)
			human_holder.st_add_stat_mod(STAT_APPEARANCE, -(STAT_APPEARANCE), "Monstrous")
