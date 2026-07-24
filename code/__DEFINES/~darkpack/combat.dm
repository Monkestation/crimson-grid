//normal duration defines
/// W20 p. 239, V20 p. 254: lists turns as taking between 3 seconds (the norm for combat) to three minutes, depending on the pace of the scene
///Duration of one "turn", which is 5 seconds according to us
#define TURNS * 5 SECONDS
// Scenes have 0 hard defined rules for length.
///Duration of one "scene", which is 3 minutes according to us
#define SCENES * 3 MINUTES
#define TURNS_PER_SCENE ((1 SCENES) / (1 TURNS))

// To eyeball damage as its calcuated in the ttrpg
#define TTRPG_DAMAGE * 10
// Heavy placeholder to represent that lethal is ... twice as bad as bashing (brute basiclly)
#define LETHAL_TTRPG_DAMAGE * 20

#define FORCE_TO_DICE_POOL(force) round(force / (1 TTRPG_DAMAGE))
#define FORCE_TO_DICE_POOL_UNROUNDED(force) (force / (1 TTRPG_DAMAGE))
#define LEFTOVER_FORCE_TO_PERCENT(force) ((force % (1 TTRPG_DAMAGE) / (1 TTRPG_DAMAGE)) * 100)

// Unused for now
#define BASHING "bashing"
#define LETHAL "lethal"
// exists in code/__DEFINES/~darkpack/aggravated_damage.dm
//#define AGGRAVATED
