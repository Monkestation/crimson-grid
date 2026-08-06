#define ROLL_COOLDOWN -2
#define ROLL_BOTCH -1
#define ROLL_FAILURE 0
#define ROLL_SUCCESS 1

/// Output is shown to everyone near you
#define ROLL_PUBLIC "public"
/// Output is only shown to the roller
#define ROLL_PRIVATE "private"
/// Output is shown to both the roller and the target
#define ROLL_PRIVATE_AND_TARGET "roller+target"
/// Output of the roll to admins + you
#define ROLL_PRIVATE_ADMIN "private+admin"
/// Output of the roll to admins only
#define ROLL_ADMIN "admin"
/// Output is show to no one and is not logged
#define ROLL_NONE "none"
/// Output is shown to the roller only if it's a success.
#define ROLL_PRIVATE_UNLESS_FAILURE "private_unless_failure"

/// Time at which the roll was recorded
#define OLD_ROLL_TIME 1
/// Dice output of the old roll (roll define or just raw number depending on numerical)
#define OLD_ROLL_OUTPUT 2
