#define ROLL_COOLDOWN -2
#define ROLL_BOTCH -1
#define ROLL_FAILURE 0
#define ROLL_SUCCESS 1


/// Time at which the roll was recorded
#define OLD_ROLL_TIME 1
/// Dice output of the old roll (roll define or just raw number depending on numerical)
#define OLD_ROLL_OUTPUT 2


/// Output is shown to view/nearby mobs
#define ROLL_FLAG_NEARBY (1 << 0)
/// Output is shown to roller
#define ROLL_FLAG_ROLLER (1 << 1)
/// Output is shown to target
#define ROLL_FLAG_TARGET (1 << 2)
/// Output is shown to admins
#define ROLL_FLAG_ADMIN (1 << 3)

/// Output is shown to everyone near you
#define ROLL_PUBLIC ROLL_FLAG_ROLLER|ROLL_FLAG_TARGET|ROLL_FLAG_NEARBY

#define ROLL_OUTPUT_IC list( \
	"Nearby", \
	"Roller", \
	"Target", \
	"Admin", \
)

DEFINE_BITFIELD(roll_output_type, list(
	"NEARBY" = ROLL_FLAG_NEARBY,
	"ROLLER" = ROLL_FLAG_ROLLER,
	"TARGET" = ROLL_FLAG_TARGET,
	"ADMIN" = ROLL_FLAG_ADMIN,
))

#define ROLL_DIFFICULTY_MIN 2
#define ROLL_DIFFICULTY_MAX 10
