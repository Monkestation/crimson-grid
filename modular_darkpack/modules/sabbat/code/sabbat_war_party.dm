/obj/item/sabbat_war_party
	name = "Sabbat War Party Totem"
	desc = "A totem made from a Vampire's skull, made to summon all Sabbat packs to the Ductus' lair."
	icon = 'modular_darkpack/modules/sabbat/icons/sabbat_war_party.dmi'
	icon_state = "sabbat_warparty"
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL

/obj/item/sabbat_war_party/attack_self(mob/user)
	. = ..()

	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user

	if(!is_sabbat_ductus(H.mind.assigned_role) && !is_sabbat_priest(H.mind.assigned_role))
		to_chat(H, span_cult("Only the Ductus or the Priest may call a War Party from the Totem!"))
		return

	var/choice = tgui_alert(H, "Do you wish to send a message to all Sabbat in the city instructing them to return to the Sabbat lair?", "Return", list("Yes", "No"), 10 SECONDS)
	if(choice == "Yes")

		// Inform the user about the current status of the totem
		to_chat(H, span_notice("The skull's eyes flare with crimson light as you invoke its power."))
		for(var/mob/living/carbon/human/sabbat_member in GLOB.player_list)
			if(sabbat_member.mind && is_sabbatist(sabbat_member.mind.assigned_role))
				to_chat(sabbat_member, span_cult("The Ductus calls all pack members back to the lair, return at once!"))
				SEND_SOUND(sabbat_member, sound('modular_darkpack/master_files/sounds/announce.ogg'))
				sabbat_member.emote("twitch")
	else
		to_chat(user, span_warning("You decide not to call a war party."))
