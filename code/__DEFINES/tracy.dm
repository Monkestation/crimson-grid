/// File path used for the "enable tracy next round" functionality
#define TRACY_ENABLE_PATH	"data/enable_tracy"

/// The DLL path for byond-tracy.
#define TRACY_DLL_PATH		(world.system_type == MS_WINDOWS ? "replay_recorder.dll" : "./libreplay_recorder.so") // CRIMSON EDIT CHANGE - REPLAYS - byond-tracy is linked into the replay recorder's library - ORIGINAL: #define TRACY_DLL_PATH		(world.system_type == MS_WINDOWS ? "prof.dll" : "./libprof.so")
// CRIMSON EDIT ADDITION START - REPLAYS
/// What modular_vcg/modules/replays/code/byond_tracy.dm calls into.
#define BYOND_TRACY_DLL		TRACY_DLL_PATH
// CRIMSON EDIT ADDITION END
