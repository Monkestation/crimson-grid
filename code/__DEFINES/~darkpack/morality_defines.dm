/**
 * Morality defines
 */

#define MIN_PATH_SCORE 1
#define MAX_PATH_SCORE 10

// Very simplified version of virtues
#define MORALITY_HUMANITY "morality_humanity"
#define MORALITY_ENLIGHTENMENT "morality_enlightenment"

// Bearings
// example: BEARING_SILENCE reduces the difficulty of all stealth rolls by minus one if the follower of the path is above path score 5.
#define BEARING_MUNDANE (1<<0)
#define BEARING_RESOLVE (1<<1)
#define BEARING_JUSTICE (1<<2)
#define BEARING_INHUMANITY (1<<3)
#define BEARING_COMMAND (1<<4)
#define BEARING_INTELLECT (1<<5)
#define BEARING_DEVOTION (1<<6)
#define BEARING_HOLINESS (1<<7)
#define BEARING_SILENCE (1<<8)
#define BEARING_MENACE (1<<9)
#define BEARING_FAITH (1<<10)
#define BEARING_GUILT (1<<11)
#define BEARING_TRIBULATION (1<<12)
#define BEARING_SEDUCTION (1<<13)
#define BEARING_BALANCE (1<<14)
#define BEARING_CONFIDENCE (1<<15)
#define BEARING_CORRUPTION (1<<16)
#define BEARING_DARKNESS (1<<17)
#define BEARING_FURY (1<<18)
#define BEARING_RAPTURE (1<<19)

// Path hits
#define PATH_SCORE_DOWN -1
#define PATH_SCORE_UP 1

// Path hit signals
#define COMSIG_PATH_HIT "path_hit"

// Path cooldowns
#define COOLDOWN_PATH_HIT "path_hit_cooldown"
