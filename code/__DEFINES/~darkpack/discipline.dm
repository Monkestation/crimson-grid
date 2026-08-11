//targeting bitflags, NONE or 0 if targeting self exclusively
///Allows for self to also be selected in ranged targeting, SET TO 0 IF NOT TARGETED OR RANGED
#define TARGET_SELF (1<<0)
///Targets anything of type /obj and its children
#define TARGET_OBJ (1<<1)
///Targets anything of type /turf and its children
#define TARGET_TURF (1<<2)
///Targets anything of type /mob/living and its children only if it is not dead
#define TARGET_LIVING (1<<3)
///Targets anything of type /mob/dead and its children, ie targets ghosts
#define TARGET_GHOST (1<<4)
///Targets anything of type /mob/living and its children, dead or not
#define TARGET_MOB (1<<5)
///Targets anything of type /mob/living/carbon/human and its children
#define TARGET_HUMAN (1<<6)
///Targets anything of type /mob/living and its children only if it has a client attached to it
#define TARGET_PLAYER (1<<7)
///Targets mobs only if they are vampires/Kindred
#define TARGET_VAMPIRE (1<<8)

//Aggregated targeting for /mob/living
#define MOB_LIVING_TARGETING (TARGET_MOB | TARGET_LIVING | TARGET_HUMAN | TARGET_PLAYER | TARGET_VAMPIRE)

//bitflags to check for certain conditions determining ability to actually cast a discipline
//flags overlap, like DISC_CHECK_CAPABLE covers DISC_CHECK_CONSCIOUS and DISC_CHECK_TORPOR
///Caster must not be in Torpor
#define DISC_CHECK_TORPORED (1<<0)
///Caster must be conscious
#define DISC_CHECK_CONSCIOUS (1<<1)
///Caster must be capable of taking actions (not stunned)
#define DISC_CHECK_CAPABLE (1<<2)
///Caster must be standing up (not knocked down)
#define DISC_CHECK_LYING (1<<3)
///Caster must be capable of moving
#define DISC_CHECK_IMMOBILE (1<<4)
///Caster must have usable hands
#define DISC_CHECK_FREE_HAND (1<<5)
///Caster must be able to speak
#define DISC_CHECK_SPEAK (1<<6)
///Caster must be able to see
#define DISC_CHECK_SEE (1<<7)
///Caster must see the target directly (without the usage of auspex for example)
#define DISC_CHECK_DIRECT_SEE (1<<8)

//power type defines, will be useful when it's made generic
///Power is a Discipline of the Vampire: The Masquerade game line
#define POWER_TYPE_DISCIPLINE "discipline"
///Power is a Chi Art of the Kindred of the East game line
#define POWER_TYPE_CHI_ART "chi_art"

// Defines for Discipline keybindings
/// How many keybinds you get for selecting Disciplines, should be the maximum amount of Disciplines players can normally have.
/// NOTE: If you set this to zero with the keybinds enabled, players can only use them for Bloodheal.
#define DISCIPLINE_SELECTION_KEYBINDS_AMOUNT 5
/// How many keybinds you get for activating Discipline powers, should be the maximum level players can normally have in Disciplines
#define DISCIPLINE_ACTIVATION_KEYBINDS_AMOUNT 5
/// Category for the keybinds where you select a Discipline and then activate its powers
#define CATEGORY_DISCIPLINES "DISCIPLINES"
/// Category for the keybinds where you activate individual powers
#define CATEGORY_DISCIPLINE_POWERS "DISCIPLINE POWERS"

#define ABYSS_TENTACLE_MODE_AGGRESSIVE "Aggressive"
#define ABYSS_TENTACLE_MODE_CONTROL "Control"
#define ABYSS_TENTACLE_MODE_PASSIVE "Passive"
