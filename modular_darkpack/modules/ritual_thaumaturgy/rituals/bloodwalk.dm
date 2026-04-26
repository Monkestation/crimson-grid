/obj/ritual_rune/thaumaturgy/bloodwalk
	name = "blood walk"
	desc = "Trace the subject's lineage from a blood syringe."
	icon_state = "rune7"
	word = "Reveal thy bloodline for mine eyes."
	level = 2

/obj/ritual_rune/thaumaturgy/bloodwalk/complete()
	. = ..()
	for(var/obj/item/reagent_containers/syringe/S in loc)
		for(var/datum/reagent/blood/B in S.reagents.reagent_list)
			var/blood_data = B.data
			if(blood_data)
				var/generation = blood_data["generation"]
				var/clan = blood_data["clan"]
				var/real_name = blood_data["real_name"]
				var/message = generate_message(generation, clan, real_name)
				to_chat(last_activator, "[message]")
				// Process blood collection for research points
				if(ishuman(last_activator))
					SSoccult_research.process_blood_collection(last_activator, B)
			else
				to_chat(last_activator, "The blood speaks not; it is empty of power!")
		color = rgb(255,0,0)
		activated = TRUE
		qdel(src)

/obj/ritual_rune/thaumaturgy/bloodwalk/proc/generate_message(generation, clan, real_name)
	var/message = ""
	message += "The owner of the blood's true name is [real_name].\n"
	switch(generation)
		if(4)
			message += "The blood is incredibly ancient and powerful! It must be from an ancient Methuselah!\n"
		if(5)
			message += "The blood is incredibly ancient and powerful! It must be from a Methuselah!\n"
		if(6)
			message += "The blood is incredibly ancient and powerful! It must be from an Elder!\n"
		if(7, 8, 9)
			message += "The blood is powerful. It must come from an Ancilla or Elder!\n"
		if(10, 11)
			message += "The blood is of middling strength. It must come from someone young.\n"
		if(12, 13)
			message += "The blood is of waning strength. It must come from a neonate.\n"
		else
			if(generation >= 14)
				message += "This is the vitae of a thinblood!\n"
	clan = lowertext(clan)
	switch(clan)
		if(VAMPIRE_CLAN_TOREADOR, VAMPIRE_CLAN_DAUGHTERS_OF_CACOPHONY)
			message += "The blood is sweet and rich. The owner must, too, be beautiful.\n"
		if(VAMPIRE_CLAN_VENTRUE, VAMPIRE_CLAN_VENTRUE_ANTITRIBU)
			message += "The blood has kingly power in it, descending from Mithras or Hardestadt.\n"
		if(VAMPIRE_CLAN_LASOMBRA)
			message += "Cold and dark, this blood has a mystical connection to the Abyss.\n"
		if(VAMPIRE_CLAN_TZIMISCE)
			message += "The vitae is mutable and twisted. Is there any doubt to the cursed line it belongs to?\n"
		if(VAMPIRE_CLAN_OLD_CLAN_TZIMISCE)
			message += "This vitae is old and ancient. It reminds you of a more twisted and cursed blood...\n"
		if(VAMPIRE_CLAN_GANGREL, VAMPIRE_CLAN_CITY_GANGREL)
			message += "The blood emits a primal and feral aura. The same is likely of the owner.\n"
		if(VAMPIRE_CLAN_MALKAVIAN, VAMPIRE_CLAN_DOMINATE_MALKAVIAN)
			message += "You can sense chaos and madness within this blood. It's owner must be maddened too.\n"
		if(VAMPIRE_CLAN_BRUJAH)
			message += "The blood is filled with passion and anger. So must be the owner of the blood.\n"
		if(VAMPIRE_CLAN_NOSFERATU)
			message += "The blood is foul and disgusting. Same must apply to the owner.\n"
		if(VAMPIRE_CLAN_TREMERE)
			message += "The blood is filled with the power of magic. The owner must be a thaumaturge.\n"
		if(VAMPIRE_CLAN_BAALI)
			message += "Tainted and corrupt. Vile and filthy. You see your reflection in the blood, but something else stares back.\n"
		if(VAMPIRE_CLAN_BANU_HAQIM, VAMPIRE_CLAN_BANU_HAQIM_VIZIER)
			message += "Potent... deadly... and cursed. You know well the curse laid by Tremere on the assassins.\n"
		if(VAMPIRE_CLAN_TRUE_BRUJAH)
			message += "The blood is cold and static... It's hard to feel any emotion within it.\n"
		if(VAMPIRE_CLAN_HEALER_SALUBRI)
			message += "The cursed blood of the Salubri! The owner of this blood must be slain.\n"
		if(VAMPIRE_CLAN_WARRIOR_SALUBRI)
			message += "The avatar of Samiel's vengeance stands before you, do you dare return their bitter hatred?\n"
		if(VAMPIRE_CLAN_GIOVANNI, VAMPIRE_CLAN_CAPPADOCIAN, VAMPIRE_CLAN_HARBINGER)
			message += "The blood is very cold and filled with death. The owner must be a necromancer.\n"
		if(VAMPIRE_CLAN_KIASYD)
			message += "The blood is filled with traces of fae magic.\n"
		if(VAMPIRE_CLAN_GARGOYLE)
			message += "The blood of our stone servants.\n"
		if(VAMPIRE_CLAN_SETITE, VAMPIRE_CLAN_WARRIOR_SETITE)
			message += "Seduction and allure are in the blood. Ah, one of the snakes.\n"
		if(VAMPIRE_CLAN_NAGARAJA)
			message += "This blood has an unsettling hunger to it, cold and stained with death.\n"
		else
			message += "The blood's origin is hard to trace. Perhaps it is one of the clanless?\n"

	return message
