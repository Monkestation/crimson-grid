#define PC_NETWORK_PUBLIC "public"
#define PC_NETWORK_CAMARILLA "camarilla"
#define PC_NETWORK_SCHRECKNET "schrecknet"
#define PC_NETWORK_DEPARTMENT "department"

#define PC_PRINT_CHARS_PER_SHEET 3000
#define PC_PRINT_MAX_SHEETS 5
#define PC_PRINT_TIME (4.1 SECONDS)
#define PC_PRINT_COOLDOWN (6 SECONDS)

#define PC_NETWORK_ENDRON "Endron Internationals"
#define PC_NETWORK_BIANCHI_BANK "Bianchi Bank"

#define PC_ACCESS_NONE 0
#define PC_ACCESS_USER 1
#define PC_ACCESS_ADMIN 2
#define PC_ACCESS_NOSFERATU 3

#define PC_NETWORK_ADMIN "Admin"
#define PC_NETWORK_GUEST "Guest"
#define PC_NETWORK_MASTER "Master"
#define PC_NETWORK_USER "User"
///the device exists but is not on any network.
#define PC_NETWORK_OFFLINE "offline"

#define AUTOMATION_NAME "name"
#define AUTOMATION_DESC "desc"
#define AUTOMATION_MIN_ROLE "min_role"
#define AUTOMATION_SIGNAL "signal"
#define AUTOMATION_ALLOW_AUTOMATE "allow_automation"
#define AUTOMATION_CALLBACK "callback"

#define AUTOMATION_PAYLOAD "payload" // trigger def: names for the signal args, in order
#define PC_MAX_RENDERED_LEN 256

#define PC_TRIGGER_DEVICE "device"
#define PC_TRIGGER_TIMER "timer"
#define PC_TRIGGER_MAIL "mail"

#define PC_STEP_ACTION "action"
#define PC_STEP_WAIT "wait"
#define PC_STEP_MAIL "mail"
#define PC_STEP_SET_VAR "set_var"

#define PC_COND_VAR_EQUALS "var_equals"
#define PC_COND_VAR_NOT_EQUALS "var_not_equals"
#define PC_COND_MAIL_FROM "mail_from"
#define PC_COND_MAIL_SUBJECT "mail_subject_contains"
#define PC_COND_MAIL_BODY "mail_body_contains"
#define PC_COND_COMPARE "compare"
#define PC_STEP_READ_VAR "read_var"

#define PC_AUTOMATION_ADDRESS "automation@network"
#define PC_AUTOMATION_MIN_ROLE PC_NETWORK_USER
#define PC_AUTOMATION_MAX_RULES 25
#define PC_AUTOMATION_MAX_STEPS 10
#define PC_AUTOMATION_MAX_CONDITIONS 5
#define PC_AUTOMATION_MIN_TIMER (5 SECONDS)
#define PC_AUTOMATION_MIN_COOLDOWN (1 SECONDS)
#define PC_AUTOMATION_MAX_WAIT (60 SECONDS)

#define NIGHTCRAWLER_MAX_HEADLINE 80
#define NIGHTCRAWLER_MAX_BODY 1200
#define NIGHTCRAWLER_MAX_BYLINE 30
#define NIGHTCRAWLER_MAX_CHANNEL_NAME 40
#define NIGHTCRAWLER_MAX_CHANNEL_DESC 120
#define NIGHTCRAWLER_MAX_CHANNELS 12
#define NIGHTCRAWLER_MAX_STORIES 30
#define NIGHTCRAWLER_THUMB_SIZE 192
#define NIGHTCRAWLER_PUBLISH_COOLDOWN (30 SECONDS)
#define NIGHTCRAWLER_PRINT_COOLDOWN (30 SECONDS)
/// Sheets of paper one newspaper consumes
#define NIGHTCRAWLER_PRINT_SHEETS 2
#define NIGHTCRAWLER_LIVE_REFRESH (2 SECONDS)
/// c_tag prefix set by /obj/item/broadcast_camera on its internal camera
#define NIGHTCRAWLER_LIVE_PREFIX "LIVE: "
/// Headline and body are stored in the single feed_message body, joined by this
#define NIGHTCRAWLER_SEPARATOR " — "

#define NETWORK_LOG_JOIN "join"
#define NETWORK_LOG_LEAVE "leave"
#define NETWORK_LOG_HACK_FAIL "hack_fail"
#define NETWORK_LOG_INTRUSION "intrusion"
#define NETWORK_LOG_INTRUSION_TRACED "intrusion_traced"
#define NETWORK_LOG_MAX_ENTRIES 200

#define HACK_REVEAL_COOLDOWN (30 SECONDS)
#define HACK_ATTEMPT_COOLDOWN (45 SECONDS)
/// Used for networks that have no hack_difficulty of their own (public, SchreckNet)
#define HACK_DEFAULT_NET_DIFFICULTY 2
#define HACK_MAX_INTERCEPTS 50
#define HACK_MAX_RESULTS 20
#define HACK_TAP_DURATION (5 MINUTES)
#define HACK_ADWARE_DURATION (2 MINUTES)
/// Extra difficulty for forcing an action on a non-PC device
#define HACK_ACTION_DIFFICULTY_MOD 2

#define HACK_BANK_TAP_DURATION (5 MINUTES)
#define HACK_MAX_PAYMENTS 50
/// Percent chance that an intercepted payment gets skimmed
#define HACK_SKIM_CHANCE 25
/// Fraction of the payment taken on top of it when skimming
#define HACK_SKIM_FRACTION 0.1

/* Calculates the volume of a sound based on distance
 *
 * https://www.desmos.com/calculator/sqdfl8ipgf
 *
 * Arguments:
 * * volume: The initial volume of the sound being played
 * * distance: How far away the sound is in tiles from the source
 * * falloff_distance: Distance at which falloff begins. Sound is at peak volume (in regards to falloff) aslong as it is in this range.
 * * falloff_exponent: Rate of falloff for the audio. Higher means quicker drop to low volume. Should generally be over 1 to indicate a quick dive to 0 rather than a slow dive.
 * Returns: The max distance of a sound based on audible volume range
 */
#define CALCULATE_SOUND_VOLUME(volume, distance, max_distance, falloff_distance, falloff_exponent)\
	((max(distance - falloff_distance, 0) ** (1 / falloff_exponent)) / ((max(max_distance, distance) - falloff_distance) ** (1 / falloff_exponent)) * volume)
