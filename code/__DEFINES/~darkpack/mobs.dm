/// Health level where mobs who can Torpor will actually die
#define HEALTH_THRESHOLD_TORPOR_DEAD -200

#define isavatar(A) (istype(A, /mob/living/basic/avatar))
#define iszomboid(A) (istype(A, /mob/living/basic/zombie) || (istype(A, /mob/living/basic/beastmaster/giovanni_zombie)))

#define SPECIES_FERA "fera"

#define SPECIES_FERA_HOMID "homid"
#define SPECIES_FERA_BESTIAL "bestial"
#define SPECIES_FERA_WAR "war"
#define SPECIES_FERA_DIRE "dire"
#define SPECIES_FERA_FERAL "feral"

// #define SPECIES_GAROU "garou"

// #define isshifted(A) (istype(A, /mob/living/carbon/human/fera))
//homid
#define ishomid(A) (is_species(A, /datum/species/human/shifter/homid))
//bestial e.g glabro
#define isglabro(A) (is_species(A, /datum/species/human/shifter/bestial))
//war e.g crinos
#define iscrinos(A) (is_species(A, /datum/species/human/shifter/war))
//dire e.g hispo
#define ishispo(A) (is_species(A, /datum/species/human/shifter/dire))
//feral e.g lupus
#define islupus(A) (is_species(A, /datum/species/human/shifter/feral))


#define isnpc(A) (istype(A, /mob/living/carbon/human/npc))

#define INCORPOREAL_MOVE_AVATAR 4 // Avatar incorporeal movement

// Required definition for Zulo carbon form rework
#define SPECIES_ZULO_FORM "zulo"
#define ZULO_DEFAULT_LIMB_ID "weretzi"
