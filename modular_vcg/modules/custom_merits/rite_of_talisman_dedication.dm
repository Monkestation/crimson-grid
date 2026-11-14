// code for Rite of Talisman Dedication. Fairly long, so splitting into its own file to keep merits.dm clean.

/datum/quirk/darkpack/rite_of_talisman_dedication
	name = "Rite of Talisman Dedication"
	desc = "You have performed a Rite of Talisman Dedication. Your equipped items meld into your form when shifting into one that cannot equip them, to be returned to you upon shifting into one that can. Your clothing is no longer damaged by shifting."
	value = 3
	mob_trait = TRAIT_RITE_OF_TALISMAN_DEDICATION
	icon = FA_ICON_SHIRT
	allowed_splats = SPLAT_SHIFTERS // This is one of the most common generic level 1 rites for fera.

// slots that depend on suit/uniform, so these need to be available first
#define DEDICATION_DEPENDENT_SLOTS (ITEM_SLOT_LPOCKET|ITEM_SLOT_RPOCKET|ITEM_SLOT_SUITSTORE|ITEM_SLOT_ID|ITEM_SLOT_BELT)

/datum/splat/werewolf/shifter
	var/list/dedicated_items // Items stashed by the Rite, as item = slot

/datum/splat/werewolf/shifter/transform_finish(form_to_transform, time_taken)
	if(!HAS_TRAIT(owner, TRAIT_RITE_OF_TALISMAN_DEDICATION))
		return ..()
	var/datum/species/new_form = form_to_transform
	if(initial(new_form.no_equip_flags))
		stash_dedicated_items()
	. = ..()
	restore_dedicated_items()

/datum/splat/werewolf/shifter/proc/stash_dedicated_items()
	for(var/obj/item/worn as anything in owner.get_equipped_items(INCLUDE_POCKETS)) // held items are not included as this is unnecessary and may cause certain shenanigans
		LAZYSET(dedicated_items, worn, owner.get_slot_by_item(worn)) // records item and slot, creates the list if it is needed
		owner.temporarilyRemoveItemFromInventory(worn, force = TRUE, idrop = FALSE) // unequip and move into character's contents without dropping it or any dependencies, stashed items are deleted/dropped with everything else
		for(var/atom/movable/stored as anything in worn.get_all_contents()) // close equipped containers such as bags when shifting so they are not accessible when not actually equipped
			stored.atom_storage?.close_all()

/datum/splat/werewolf/shifter/proc/restore_dedicated_items()
	if(!LAZYLEN(dedicated_items) || owner.dna?.species?.no_equip_flags) // do nothing if current form can't equip anything (Lupus, Hispo, Crinos, etc) or if stash is empty
		return
	for(var/dependent_pass in list(FALSE, TRUE)) // two passes, first over independent slots (uniform, vest, etc), second over the dependent slots (pockets, suit storage)
		for(var/obj/item/stashed as anything in dedicated_items)
			var/slot = dedicated_items[stashed] // grab origin slot of item
			if(QDELETED(stashed) || (!!(slot & DEDICATION_DEPENDENT_SLOTS) != dependent_pass)) // skip if the item was somehow deleted or slot type isn't included in the current pass
				continue
			if(!owner.equip_to_slot_if_possible(stashed, slot, disable_warning = TRUE, bypass_equip_delay_self = TRUE)) // puts back in original slot, ignores unequippable warnings and skips any equip delays, such as for armour
				stashed.forceMove(owner.drop_location()) // failsafe to drop item on the ground if it can't be automatically re-equipped for some reason.
	dedicated_items = null

#undef DEDICATION_DEPENDENT_SLOTS
