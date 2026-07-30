// ~guestbook_flags variable on datum/job
/// We will know absolutely everyone, no matter the department
#define GUESTBOOK_OMNISCIENT (1 << 0)
/// We will know others of the same job type
#define GUESTBOOK_JOB (1 << 1)
/// We will know others in our departments
#define GUESTBOOK_DEPARTMENT (1 << 2)
/// We will not be known by others, even if they pass checks in any way otherwise
#define GUESTBOOK_FORGETMENOT (1 << 3)

/// Differs from GET_GUESTBOOK_NAME_TRUE as it returns the known name OR the whole mob for situations where we directly embed into a string for text macros.
#define GET_GUESTBOOK_NAME(mob, guest) (mob?.mind?.guestbook?.get_known_name(mob, guest) || guest)
/// Macro to get a STRING (never a mob) of the name we refer to them as.
#define GET_GUESTBOOK_NAME_TRUE(mob, guest) (mob?.mind?.guestbook?.get_known_name(mob, guest) || guest.name)
