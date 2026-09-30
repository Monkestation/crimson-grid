// This list holds icon for the character screen form selection UI
GLOBAL_LIST_INIT(zulo_forms, list(
	"Beast" = "weretzi",
	"Brust" = "4armstzi",
	// "Noble" = "nobletzi", //Nobletzi commented out for now pending a new 64x64 sprite
))
// This list holds w pixel offset for the character screen form selection UI
GLOBAL_LIST_INIT(zulo_w_offset, list(
	"Beast" = -16,
	"Brust" = -10,
	// "Noble" = 0, //Nobletzi commented out for now pending a new 64x64 sprite
))
// This list holds z pixel offset for the character screen form selection UI
GLOBAL_LIST_INIT(zulo_z_offset, list(
	"Beast" = 0,
	"Brust" = 0,
	// "Noble" = 0, //Nobletzi commented out for now pending a new 64x64 sprite
))

/datum/species/tzimisce_zulo_form
	abstract_type = /datum/species/tzimisce_zulo_form
	name = "Zulo"
	plural_form = "Zulo"
	id = SPECIES_ZULO_FORM
	examine_limb_id = SPECIES_ZULO_FORM
	inherent_biotypes = MOB_UNDEAD|MOB_HUMANOID
	changesource_flags = MIRROR_BADMIN
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_VIRUSIMMUNE,
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
		TRAIT_TOXIMMUNE,
		TRAIT_NOCRITDAMAGE,
		TRAIT_MASQUERADE_VIOLATING_FACE,
		TRAIT_STRONG_GRABBER,
		TRAIT_PUSHIMMUNE,
		TRAIT_HARDLY_WOUNDED,
		TRAIT_RAZOR_CLAWS,
		TRAIT_NO_UNDERWEAR,
		TRAIT_NO_BLOOD_OVERLAY,
		TRAIT_TRANSFORM_UPDATES_ICON,
		TRAIT_NO_CUFF, // hard to put cuffs on a warform that might even have multiple arms or be a were-beast. Waiting for cuffbreaking code.
		TRAIT_MUTANT_COLORS,
		// CRIMSON EDIT ADD START - Zulo Trait Buffs
		TRAIT_HARDENED_SOLES,
		TRAIT_GRABRESISTANCE,
		TRAIT_QUICK_CARRY,
		TRAIT_STRENGTH,
		TRAIT_NO_SLIP_WATER,
		TRAIT_HEAD_INJURY_BLOCKED,
		TRAIT_BRAWLING_KNOCKDOWN_BLOCKED,
		TRAIT_BATON_RESISTANCE,
		TRAIT_FEARLESS,
		// CRIMSON EDIT ADD END - Zulo Trait Buffs
	)
	no_equip_flags = ITEM_SLOT_MASK | ITEM_SLOT_OCLOTHING | ITEM_SLOT_GLOVES | ITEM_SLOT_FEET | ITEM_SLOT_ICLOTHING | ITEM_SLOT_SUITSTORE | ITEM_SLOT_HEAD | ITEM_SLOT_EYES | ITEM_SLOT_EARS
	var/obj/item/zulo_backpack_to_hide
	// important to retain at least backpack slot - the Tzimisce soil bag needs to remain on the character.
	// Zulo-specific bodyparts are defined in zulo_organs.dm.
	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/zulo,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/zulo,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/zulo,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/zulo,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/zulo,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/zulo,
	)
	var/old_size
	fixed_mut_color = "#e5e0d0"

/datum/species/tzimisce_zulo_form/on_species_gain(mob/living/carbon/human/human_who_gained_species, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	var/form_name = human_who_gained_species.client?.prefs.read_preference(/datum/preference/choiced/zulo_form)
	var/form_limb_id = GLOB.zulo_forms[form_name] || ZULO_DEFAULT_LIMB_ID // fallback to weretzi as a safety measure
	for(var/obj/item/bodypart/limb as anything in human_who_gained_species.bodyparts)
		limb.change_appearance(icon = 'modular_darkpack/modules/powers/icons/zulo_bodyparts.dmi', id = form_limb_id, greyscale = TRUE)
	var/form_w_offset = GLOB.zulo_w_offset[form_name] || 0   // fallback to no offset
	var/form_z_offset = GLOB.zulo_z_offset[form_name] || 0
	human_who_gained_species.add_offsets(type, w_add = form_w_offset, z_add = form_z_offset)
	human_who_gained_species.hairstyle = "Bald"
	human_who_gained_species.facial_hairstyle = "Shaved"
	human_who_gained_species.add_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown)
	human_who_gained_species.update_mob_height()
	old_size = human_who_gained_species.current_size
	// +3 stat boots to all physical stats, and socials to 0 as per V20 - pages: 242
	human_who_gained_species.st_add_stat_clamp(STAT_APPEARANCE, 0, type)
	human_who_gained_species.st_add_stat_clamp(STAT_MANIPULATION, 0, type)
	human_who_gained_species.st_add_stat_clamp(STAT_CHARISMA, 0, type)
	human_who_gained_species.st_add_stat_mod(STAT_STRENGTH, 3, type)
	human_who_gained_species.st_add_stat_mod(STAT_DEXTERITY, 3, type)
	human_who_gained_species.st_add_stat_mod(STAT_STAMINA, 3, type)
	human_who_gained_species.remove_overlay(BODY_ADJ_LAYER)
	zulo_backpack_to_hide = human_who_gained_species.get_item_by_slot(ITEM_SLOT_BACK)
	if(zulo_backpack_to_hide)
		zulo_backpack_to_hide.worn_icon_state = "empty"
		human_who_gained_species.update_worn_back()
	RegisterSignal(human_who_gained_species, COMSIG_LIVING_DEATH, PROC_REF(revert_on_zulo_death))


	// CRIMSON EDIT ADD START - Zulo Buffs
	human_who_gained_species.physiology.brute_mod *= 0.5
	// CRIMSON EDIT ADD END - Zulo Buffs

/datum/species/tzimisce_zulo_form/on_species_loss(mob/living/carbon/human/human, datum/species/new_species, pref_load)
	. = ..()
	if(human.client)
		human.hairstyle = human.client.prefs.read_preference(/datum/preference/choiced/hairstyle)
		human.facial_hairstyle = human.client.prefs.read_preference(/datum/preference/choiced/facial_hairstyle)
	human.remove_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown)
	human.remove_offsets(type)
	human.update_mob_height()
	human.update_transform(old_size/human.current_size)
	human.st_remove_stat_clamp(STAT_APPEARANCE, type)
	human.st_remove_stat_clamp(STAT_MANIPULATION, type)
	human.st_remove_stat_clamp(STAT_CHARISMA, type)
	human.st_remove_stat_mod(STAT_STRENGTH, type)
	human.st_remove_stat_mod(STAT_DEXTERITY, type)
	human.st_remove_stat_mod(STAT_STAMINA, type)
	if(zulo_backpack_to_hide)
		zulo_backpack_to_hide.worn_icon_state = initial(zulo_backpack_to_hide.worn_icon_state)
		human.update_worn_back()
		zulo_backpack_to_hide = null
	UnregisterSignal(human, COMSIG_LIVING_DEATH)

	// CRIMSON EDIT ADD START - Zulo Buffs
	human.physiology.brute_mod /= 0.5
	// CRIMSON EDIT ADD END - Zulo Buffs

/datum/species/tzimisce_zulo_form/proc/revert_on_zulo_death(mob/living/carbon/human/source)
	source.set_species(mrace = /datum/species/human, icon_update = TRUE, pref_load = TRUE, replace_missing = FALSE)

// needs to standardize Zulo size to medium to avoid pixel distortion on the sprites
/obj/item/bodypart/chest/zulo/update_mob_heights(mob/living/carbon/human/holder)
	return HUMAN_HEIGHT_MEDIUM
