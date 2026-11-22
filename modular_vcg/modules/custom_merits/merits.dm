/datum/quirk/darkpack/forked_tongue
	name = "Forked Tongue"
	desc = "You have a forked tongue that makes pronouncing the letter s sound like hissing."
	icon = FA_ICON_S
	value = -1
	allowed_splats = list(SPLAT_KINDRED)
	included_clans = list(VAMPIRE_CLAN_SETITE, VAMPIRE_CLAN_WARRIOR_SETITE, VAMPIRE_CLAN_TLACIQUE)
	/// The original tongue from before the forked one was applied
	var/obj/item/organ/old_organ

/datum/quirk/darkpack/forked_tongue/add_unique(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	old_organ = human_holder.get_organ_slot(ORGAN_SLOT_TONGUE)
	var/obj/item/organ/tongue/lizard/forked = new
	forked.Insert(human_holder, special = TRUE)
	if(old_organ)
		old_organ.moveToNullspace()
		STOP_PROCESSING(SSobj, old_organ)

/datum/quirk/darkpack/forked_tongue/remove()
	if(old_organ)
		old_organ.Insert(quirk_holder, special = TRUE)
	old_organ = null

/datum/quirk/darkpack/permafangs/fake
	name = "Cosmetic Fangs"
	desc = "You've had your teeth filed or are wearing prosthetics for one reason or another, giving the appearance of fangs in your mouth. Many view your fangs as something exotic or eccentric but a few superstitious may find this more than exotic..."
	value = -1
	gain_text = span_notice("Your feel your teeth becoming sharp")
	lose_text = span_notice("You feel your teeth becoming normal again.")
	allowed_splats = list(SPLAT_NONE, SPLAT_GHOUL)
	failure_message = "You feel your teeth becoming normal again."

/datum/quirk/darkpack/homestuck
	name = "Home Stuck"
	desc = "Your speech is hard to understand for others."
	value = 0
	icon = FA_ICON_HOUSE_USER
	allowed_splats = list(SPLAT_KINDRED, SPLAT_GHOUL)
	included_clans = list(VAMPIRE_CLAN_MALKAVIAN)

/datum/quirk/darkpack/homestuck/add(client/client_source)
	quirk_holder.AddComponent(/datum/component/speechmod, replacements = list("a"="4", "A"="4", "i"="1", "I"="1", "e"="3", "E"="3"), uppercase = TRUE)

/datum/quirk/darkpack/ghoul_armblade
	name = "Armblade"
	desc = "Through vicissitude, one of your arms has been given a horrifyingly sharp bone blade that is concealed."
	value = 5
	icon = FA_ICON_PERSON_RIFLE
	allowed_splats = list(SPLAT_GHOUL)
	included_clans = list(VAMPIRE_CLAN_TZIMISCE)

/datum/quirk/darkpack/ghoul_armblade/add_unique(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/obj/item/organ/cyberimp/arm/toolkit/tzimisce/arm_blade = new()
	arm_blade.Insert(human_holder)

/datum/quirk/darkpack/persistent_scars
	name = "Persistent Scars"
	desc = "You have scars that seem to persist for a longer time. "
	value = 0
	icon = FA_ICON_HAND_DOTS
	allowed_splats = list(SPLAT_KINDRED)

/datum/quirk/darkpack/wyrmtainted
	name = "Wyrm Tainted"
	desc = "Due to some supernatural accident, an unfortunate quirk of heredity, or whatever reason, you have the stink of the Wyrm, a God of destruction in the eyes of most shapeshifters. Some shapeshifters are able to notice your stink and may seek to KILL you for your association with the Wyrm."
	value = -1
	mob_trait = TRAIT_WYRMTAINTED
	gain_text = span_notice("You feel tainted.")
	lose_text = span_notice("You don't feel tainted anymore.")
	allowed_splats = list(SPLAT_NONE, SPLAT_GHOUL, SPLAT_KINFOLK)
	icon = FA_ICON_WORM
	failure_message = "You don't feel tainted anymore."

/datum/quirk/darkpack/item_quirk/gun_license
	name = "Concealed Carry Permit"
	desc = "You have a permit to carry small concealed firearms."
	value = 2
	icon = FA_ICON_GUN

/datum/quirk/darkpack/item_quirk/gun_license/add_unique(client/client_source)
	var/mob/living/carbon/human/holder = astype(quirk_holder)
	var/obj/item/card/carry_permit/permit = new(get_turf(holder))
	permit.link_human(holder)
	give_item_to_holder(
		permit,
		list(
			LOCATION_LPOCKET,
			LOCATION_RPOCKET,
			LOCATION_BACKPACK,
			LOCATION_HANDS,
		),
		flavour_text = "This is your concealed carry permit.",
		notify_player = TRUE,
	)

/obj/item/card/carry_permit
	/// Owner
	var/owner = ""
	/// If the ID is a counterfit.
	var/fake = FALSE
	/// If the NAME does not belong to the person.
	var/fake_identity = FALSE
	var/datum/storyteller_roll/investigation/examine_roll

/obj/item/card/carry_permit/Initialize(mapload)
	. = ..()
	var/mob/living/carbon/human/user = null
	if(ishuman(loc)) // In pockets
		user = loc
	else if(ishuman(loc?.loc)) // In backpack
		user = loc.loc
	if(user)
		link_human(user)

/obj/item/card/carry_permit/proc/link_human(mob/living/carbon/human/user)
	if(HAS_TRAIT(user, TRAIT_ILLEGAL_IDENTITY))
		fake = TRUE
		fake_identity = TRUE

	if(fake_identity)
		owner = user.generate_random_mob_name(TRUE)
	else
		owner = user.real_name

/obj/item/card/carry_permit/examine(mob/user)
	. = ..()
	if(!examine_roll)
		examine_roll = new()
		examine_roll.reroll_cooldown = 1 SCENES
	var/roll_result = examine_roll.st_roll(user, src)
	if(owner)
		. += span_notice("It reads as belonging to [owner], issued by the local police department.")
		if(fake && (roll_result == ROLL_SUCCESS))
			. += span_notice("It looks like a crude counterfeit.")
