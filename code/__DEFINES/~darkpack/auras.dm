// Base color auras
#define AURA_AFRAID COLOR_ORANGE // Orange
#define AURA_AGGRESSIVE COLOR_PURPLE // Purple
#define AURA_ANGRY COLOR_RED // Red
#define AURA_BITTER COLOR_BROWN // Brown
#define AURA_CALM COLOR_CARP_LIGHT_BLUE // Light Blue
#define AURA_COMPASSIONATE COLOR_PINK // Pink
#define AURA_CONSERVATIVE LIGHT_COLOR_LAVENDER // Lavender
#define AURA_DEPRESSED COLOR_GRAY // Gray
#define AURA_DESIROUS COLOR_DARK_RED // Deep Red
#define AURA_DISTRUSTFUL LIGHT_COLOR_GREEN // Light Green
#define AURA_ENVIOUS COLOR_CARP_DARK_GREEN // Dark Green
#define AURA_EXCITED COLOR_VIOLET // Violet
#define AURA_GENEROUS COLOR_LIGHT_PINK // Rose
#define AURA_HAPPY COLOR_VIVID_RED // Vermillion
#define AURA_HATEFUL COLOR_BLACK // Black
#define AURA_IDEALISTIC COLOR_YELLOW // Yellow
#define AURA_INNOCENT COLOR_OFF_WHITE // White
#define AURA_LOVESTRUCK COLOR_BLUE // Blue
#define AURA_OBSESSED COLOR_GREEN // Green
#define AURA_SAD COLOR_SILVER // Silver
#define AURA_SPIRITUAL COLOR_GOLD // Gold
#define AURA_SUSPICIOUS COLOR_STRONG_BLUE // Dark Blue

// Modifier auras.
#define AURA_ANXIOUS "Anxious" // Auras appear scrambled like static or white noise

#define AURA_CONFUSED "Confused" // Mottled, shifting colors -- Intermittent pauses in animation
#define AURA_DAYDREAMING "Daydreaming" // Sharp flickering colors -- Slow animation
#define AURA_PSYCHOTIC "Psychotic" // Hypnotic, swirling colors -- Fast animation

// Untoggleable auras. Left in here as reminders of what is used by outside variables.
#define AURA_DIABLERIST (FALSE) // Black veins in aura
#define AURA_FRENZIED (FALSE) // Rapidly rippling colors
#define AURA_VAMPIRE (FALSE) // Aura colors are pale
#define AURA_GHOUL (FALSE) // Pale blotches in the aura
#define AURA_MAGIC_USE (FALSE) // Myriad sparkles in aura -- Not implemented. Mages.
#define AURA_WEREBEAST (FALSE) // Bright, vibrant aura // WEREWOLF
#define AURA_GHOST (FALSE) // Weak, intermittent aura
#define AURA_FAERIE (FALSE) // Rainbow highlights in aura -- Not implemented. Changelings.

GLOBAL_LIST_INIT(aura_list, sort_list(list(
	"Afraid" = AURA_AFRAID,
	"Aggressive" = AURA_AGGRESSIVE,
	"Angry" = AURA_ANGRY,
	"Bitter" = AURA_BITTER,
	"Calm" = AURA_CALM,
	"Compassionate" = AURA_COMPASSIONATE,
	"Conservative" = AURA_CONSERVATIVE,
	"Depressed" = AURA_DEPRESSED,
	"Desirous" = AURA_DESIROUS,
	"Distrustful" = AURA_DISTRUSTFUL,
	"Envious" = AURA_ENVIOUS,
	"Excited" = AURA_EXCITED,
	"Generous" = AURA_GENEROUS,
	"Happy" = AURA_HAPPY,
	"Hateful" = AURA_HATEFUL,
	"Idealistic" = AURA_IDEALISTIC,
	"Innocent" = AURA_INNOCENT,
	"Lovestruck" = AURA_LOVESTRUCK,
	"Obsessed" = AURA_OBSESSED,
	"Sad" = AURA_SAD,
	"Spiritual" = AURA_SPIRITUAL,
	"Suspicious" = AURA_SUSPICIOUS,
	"Anxious" = AURA_ANXIOUS,
	"Confused" = AURA_CONFUSED,
	"Daydreaming" = AURA_DAYDREAMING,
	"Psychotic" = AURA_PSYCHOTIC
)))

GLOBAL_LIST_INIT(emotion_to_quality, sort_list(list(
	"Afraid" = "fear",
	"Aggressive" = "aggressiveness",
	"Angry" = "anger",
	"Bitter" = "bitterness",
	"Calm" = "calmness",
	"Compassionate" = "compassion",
	"Conservative" = "conservativeness",
	"Depressed" = "depression",
	"Desirous" = "desire",
	"Distrustful" = "distrust",
	"Envious" = "envy",
	"Excited" = "excitement",
	"Generous" = "generosity",
	"Happy" = "happiness",
	"Hateful" = "hate",
	"Idealistic" = "idealism",
	"Innocent" = "innocence",
	"Lovestruck" = "love",
	"Obsessed" = "obsessiveness",
	"Sad" = "sadness",
	"Spiritual" = "spirituality",
	"Suspicious" = "suspicion",
	"Anxious" = "anxiety",
	"Confused" = "confusion",
	"Daydreaming" = "absentmindedness",
	"Psychotic" = "psychosis"
)))
