/// How long it takes for a werewolf's Veil to naturally repair
// #define UMBRA_VEIL_COOLDOWN 15 MINUTES
/// How long it takes for a werewolf to regenerate a blood point
// #define FERA_BP_REGEN 60 SECONDS // I cant find a source to this.
/// Cooldown between Veil violations
// #define VEIL_COOLDOWN 20 SECONDS

#define MAX_RAGE 10
#define MAX_GNOSIS 10
#define PRIMAL_URGE_PLACEHOLDER 3

#define BREED_GAROU_HOMID "Garou Homid"
#define BREED_LUPUS "Lupus"
#define BREED_CRINOS "Crinos"

#define BREED_CORAX_HOMID "Corax Homid"
#define BREED_CORVID "Corvid"

#define FEATURE_FERA_FUR_COLOR "fera_fur_color"
#define FEATURE_FERA_HAIR(splat_id) "fera_hair" + splat_id
#define FEATURE_FERA_BODY(splat_id) "fera_body" + splat_id
#define FEATURE_FERA_CLOTHES(splat_id) "fera_clothes" + splat_id

GLOBAL_ALIST_INIT(fera_fur_colors, alist(
	SPLAT_GAROU = list(
		"black" = "black",
		"gray" = "gray",
		"red" = "red",
		"white" = "white",
		"ginger" = "ginger",
		"brown" = "brown",
	),
	SPLAT_CORAX = list(
		"black" = "black",
		"brown" = "brown",
		"white" = "white",
		"green" = "green",
		"red" = "red",
		"gray" = "gray",
	)
))

#define STATUS_EFFECT_DELIRIUM /datum/status_effect/delirium
#define STATUS_EFFECT_SILVER_BULLET_STACKS /datum/status_effect/stacking/silver_bullets
