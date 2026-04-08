// Kinda fucked but needed with the current implementation of pref and job code.
#define SPLAT_NONE "none"

#define SPLAT_KINDRED "splat_kindred"
#define SPLAT_GHOUL "splat_ghoul"

#define SPLAT_KINFOLK "splat_kinfolk"
/// Parent type for shifters. Not player facing. Shouldnt be needed but put here for clarity.
//#define SPLAT_FERA "splat_fera"
#define SPLAT_GAROU "splat_garou"
#define SPLAT_CORAX "splat_corax" // DARKPACK TODO - CORAX
#define SPLAT_SHIFTERS list(SPLAT_GAROU, SPLAT_CORAX)

#define SPLAT_PRIO_HALFSPLAT 100
#define SPLAT_PRIO_SPLAT 200

#define SPLAT_PRIO_KINFOLK 40 + SPLAT_PRIO_HALFSPLAT
#define SPLAT_PRIO_GHOUL 70 + SPLAT_PRIO_HALFSPLAT

#define SPLAT_PRIO_SHIFTER 40 + SPLAT_PRIO_SPLAT
#define SPLAT_PRIO_KINDRED 60 + SPLAT_PRIO_SPLAT
