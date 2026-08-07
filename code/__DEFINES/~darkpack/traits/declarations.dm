// This file contains all of the "static" define strings that tie to a trait.
// WARNING: The sections here actually matter in this file as it's tested by CI. Please do not toy with the sections."

// BEGIN TRAIT DEFINES

/*
Remember to update _globalvars/traits.dm if you're adding/removing/renaming traits.
*/

// CITY_TRAITS
#define STATION_TRAIT_BLACKOUT "station_trait_blackout"
#define STATION_TRAIT_COSPLAY_CONVENTION "station_trait_cosplay_convention"
#define STATION_TRAIT_INFESTATION "station_trait_infestation"
#define STATION_TRAIT_PEST_CONTROL "station_trait_pest_control"
#define STATION_TRAIT_RED_STAR "station_trait_red_star"
#define STATION_TRAIT_STRAY_MIGRATION "station_trait_stray_migration"
#define STATION_TRAIT_WILD_MASQUERADE "station_trait_wild_masquerade"

// Mob traits

// If the user is unbondable via blood bonds.
#define TRAIT_UNBONDABLE "unbondable"
// If the kindred's blood can't bond others.
#define TRAIT_DEFICIENT_VITAE "deficient_vitae"
//If the kindred is obfuscated.
#define TRAIT_OBFUSCATED "obfuscated"
#define TRAIT_BLOODY_LOVER "bloody_lover"
#define TRAIT_TOUGH_FLESH "tough_flesh"
#define TRAIT_BLOODY_SUCKER "bloody_sucker"
#define TRAIT_NON_INT "non_intellectual"
#define TRAIT_COFFIN_THERAPY "coffin_therapy"
#define TRAIT_RUBICON "rubicon"
#define TRAIT_HUNGRY "hungry"
#define TRAIT_STAKE_RESISTANT "stake_resistant"
#define TRAIT_STAKE_IMMUNE "stake_immune"
#define TRAIT_STAKED "staked"
#define TRAIT_LAZY "lazy"
#define TRAIT_HOMOSEXUAL "homosexual"
#define TRAIT_HUNTED "hunted"
#define TRAIT_VIOLATOR "violator"
#define TRAIT_DIABLERIE "diablerie"
#define TRAIT_GULLET "gullet"
#define TRAIT_CHARMER "charmer"

// Mutates the apperance of auras
#define TRAIT_PALE_AURA "pale_aura"
#define TRAIT_DECEPTIVE_AURA "deceptive_aura"
#define TRAIT_FRENETIC_AURA "frenetic_aura"
#define TRAIT_HIDDEN_DIABLERIE "hidden_diablerie"

#define TRAIT_HIDDEN_WYRMTAINT "hidden_wyrmtaint"
#define TRAIT_BLUSH_OF_HEALTH "blush_of_health"
/// The mob will automatically breach the Masquerade when seen by others, with no exceptions
#define TRAIT_UNMASQUERADE "unmasquerade"
/// The mob always dodges melee attacks
#define TRAIT_ENHANCED_MELEE_DODGE "enhanced_melee_dodge"
/// Can pass through walls so long as it doesn't move the mob into a new area
#define TRAIT_PASS_THROUGH_WALLS "pass_through_walls"
/// Technology supernaturally refuses to work or doesn't work properly for this person
#define TRAIT_REJECTED_BY_TECHNOLOGY "rejected_by_technology"
/// Vampire cannot drink from anyone who doesn't consent to it
#define TRAIT_CONSENSUAL_FEEDING_ONLY "consensual_feeding_only"
/// Instead of knocking someone out when fed on, this vampire's Kiss inflicts pain
#define TRAIT_PAINFUL_VAMPIRE_KISS "painful_vampire_kiss"
/// Vampires will always diablerise this vampire given the chance
#define TRAIT_IRRESISTIBLE_VITAE "irresistible_vitae"
/// Vampire cannot feed from poor people
#define TRAIT_FEEDING_RESTRICTION "feeding_restriction"
/// Will always fail to resist supernatural mind-influencing powers
#define TRAIT_CANNOT_RESIST_MIND_CONTROL "cannot_resist_mind_control"
/// Cannot leave the vicinity of whoever's vitae you've drank
#define TRAIT_VITAE_ADDICTION "vitae_addiction"
/// Is hurt by holiness/holy symbols and repelled by them
#define TRAIT_REPELLED_BY_HOLINESS "repelled_by_holiness"
/// Any changes in this Kindred's Humanity will be doubled
#define TRAIT_SENSITIVE_HUMANITY "sensitive_humanity"
/// Difficulty rolls to resist or guide frenzy are two higher. They can also never spend willpower to avoid frenzy
#define TRAIT_DIFFICULT_FRENZY "difficult_frenzy"
/// Difficulty rolls to rage roles are one higher.
#define TRAIT_DIFFICULT_RAGE "difficult_rage"
// Setite weakness, sunlight is particularly bad bad.
#define TRAIT_LIGHT_WEAKNESS "light_weakness"
// DARKPACK TODO - refactor these traits into mutant bodyparts and a component maybe
/// If eyes are uncovered, they will be obviously supernatural to everyone nearby
#define TRAIT_MASQUERADE_VIOLATING_EYES "masquerade_violating_eyes"
/// If face is uncovered, they will be obviously supernatural to everyone nearby
#define TRAIT_MASQUERADE_VIOLATING_FACE "masquerade_violating_face"
/// A special form of fakedeath that vampires go into rather than dying above -200 health
#define TRAIT_TORPOR "torpor"
/// Instead of dying at -100 health, enters a deathcoma and properly dies at -200 health
#define TRAIT_CAN_ENTER_TORPOR "can_enter_torpor"
/// Uses Vampire: The Masquerade morality systems
#define TRAIT_VTM_MORALITY "vtm_morality"
/// Uses Vampire: The Masquerade Clans/Bloodlines
#define TRAIT_VTM_CLANS "vtm_clans"
/// Does not biologically age, and so has a disconnected biological and chronological age
#define TRAIT_UNAGING "unaging"
// Does the mob have ghostsight?
#define TRAIT_GHOST_VISION "ghost_vision"
// Does the mob have hardened skin via Serpentis?
#define TRAIT_SERPENTIS_SKIN "serpent_skin"
// Is the mob melted into a wall via Visceratika?
#define TRAIT_BOND_WITHIN_THE_MOUNTAIN "bond_within_the_mountain"
// Is the mob unable to be cuffed? (For Tzimisce zulo form and others)
#define TRAIT_NO_CUFF "no_cuff" //Used for uncuffable forms such as Tenebrous and Blood form.
#define TRAIT_SCARRING_RESISTANT "scarring_resistant"// Temporal scars wont save
/// Stepping on glass shards immunity. Currently used for a couple Garou forms but could be used elsewhere.
#define TRAIT_HARDENED_SOLES "hardened_soles"


// Allows the user to pass through doors
#define TRAIT_IN_FRENZY "in_frenzy"

// Is the mob silenced (by Quietus 1 for example)
#define TRAIT_SILENCED "silenced"
// is the vampire weak to Dominate?
#define TRAIT_WEAK_TO_DOMINATE "dominate_weak"

/// They have warped time at some point in this round
#define TRAIT_TIMEWARPER "timewarper"

// Is the Vampire currently hungry? Hunger is defined at a bloodpool rating of 7 - self control (if humanity alignment) or instincts (enlightenment alignment)
// its called this because theres apparently already a defined quirk called 'hungry' which appears to lower your blood drawn from biting by half.
#define TRAIT_NEEDS_BLOOD "vampire_hungry"

// Is the character's emotion currently forced? Blocks emotion panel usage - Melpominee
#define TRAIT_FORCED_EMOTION "forced_emotion"
// Are we under the effects of Melpominee 5?
#define TRAIT_VIRTUOSA "virtuosa"
// If the vampire can't perform mental abilities that require eye contact, as an example: dominate.
#define TRAIT_NO_EYE_CONTACT "no_eye_contact"

// If the splat shifts between diffrent forms as a fera
#define TRAIT_FERA_FORMS "fera_forms"
// If the splat uses the WTA renown system described in W20 p. 245
#define TRAIT_FERA_RENOWN "wta_fera_renown"
// This mob has fur!
#define TRAIT_FERA_FUR "fera_fur"
/// If the fera is wyrm tainted.
#define TRAIT_WYRMTAINTED "wyrm_tainted"
/// If the fera is wyrm tainted. Affects their sprite.
#define TRAIT_WYRMTAINTED_SPRITE "wyrm_tainted_sprite"
/// For living mobs to prevent adjustments to their lying angle. Used primarly for fera.
#define TRAIT_NO_LYING_ANGLE "no_lying_angle"
// Expensive but allows us to ensure there resting gets updated.
#define TRAIT_TRANSFORM_UPDATES_ICON "transform_updates_icon"
// Fera both grants a flight ability, and has the sprites to support such a thing. (Presently only designed to supprot feral form.)
#define TRAIT_FERA_FLIGHT "fera_flight"
#define TRAIT_SILVER_WEAKNESS "silver_weakness"
#define TRAIT_GOLD_WEAKNESS "gold_weakness"
// Delirium is effectivly two levels weaker
#define TRAIT_WEAK_DELIRIUM "weak_delirium"
// Massivly boosts the range of your howl emote.
#define TRAIT_LOUD_WARCRY "loud_warcry"
/// Prevents the mob from picking up items larger then small
#define TRAIT_SMALL_HANDS "small_hands"
// Traits granted via gifts
#define TRAIT_RAZOR_CLAWS "razor_claws"
#define TRAIT_JAMMING_WEAPONS "jamming_weapons"
#define TRAIT_NATURAL "natural"
#define TRAIT_AURA_OF_CONFIDENCE "aura_of_confidence"

/// Mob has had atleast one tooth yanked out while having no method of regenerating it.
#define TRAIT_TOOTH_PULLED "tooth_pulled"

/// Sixth sense restricted to view range
#define TRAIT_LOCAL_SIXTHSENSE "local_sixth_sense"
/// If the mob can't have surgery done on it. See: Blood form Tzimisce
#define TRAIT_SURGERY_INAPPLICABLE "surgery_inapplicable"
// BELOW ARE ALL MERITS/FLAWS
#define TRAIT_ILLEGAL_IDENTITY "illegal_identity" // GOVERNMENT
#define TRAIT_ANIMAL_MUSK "animal_musk"
#define TRAIT_PERMAFANGS "permafangs"
#define TRAIT_DULLFANGS "dullfangs"
#define TRAIT_ORGANOVORE "organovore"
#define TRAIT_SANGUINE_INCONGRUITY "sanguine_incongruity"
#define TRAIT_MONSTROUS "monstrous"
#define TRAIT_HORRIFIC_APPEARANCE "horrific_appearance"
#define TRAIT_STILLNESS_OF_DEATH "stillness_of_death"
#define TRAIT_THIRD_EYE "third_eye"
#define TRAIT_PREY_EXCLUSION "prey_exclusion"
#define TRAIT_VICTIM_OF_THE_MASQUERADE "victim_of_the_masquerade"
#define TRAIT_VAMPIRE_TERRITORIAL "territorial"
#define TRAIT_BETRAYERS_MARK "betrayers_mark"
#define TRAIT_EFFICIENT_DIGESTION "efficient_digestion"
#define TRAIT_GRIP_OF_THE_DAMNED "grip_of_the_damned"
#define TRAIT_THE_LARGEST_MAW "the_largest_maw"
#define TRAIT_PIERCED_VEIL "pierced_veil"
#define TRAIT_WEAK_WILLED "weak_willed"
#define TRAIT_TIME_SENSE "time_sense"
#define TRAIT_METAMORPH "metamorph"
#define TRAIT_MERIT_UNTAMABLE "merit_untamable"
#define TRAIT_FAIR_GLABRO "fair_glabro"
#define TRAIT_EAT_FOOD "eat_food"
#define TRAIT_CALM_HEART "calm_heart"
#define TRAIT_ACUTE_HEARING "acute_hearing"
#define TRAIT_DISFIGURED_APPEARANCE "disfigured_appearance"
#define TRAIT_GRAVE_SMELL "grave_smell"
#define TRAIT_GLOWING_EYES "glowing_eyes"
#define TRAIT_PROMETHEAN_CLAY "promethean_clay"
#define TRAIT_UNCONTROLLABLE "uncontrollable"

// END TRAIT DEFINES
