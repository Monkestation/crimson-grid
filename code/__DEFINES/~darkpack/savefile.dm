#define SAVEFILE_DARKPACK_VERSION_MIN 0 // 0 would mean this was a sheet before versioning in theory
#define SAVEFILE_DARKPACK_VERSION_MAX 2

#define SHOULD_UPDATE_DATA_DARKPACK(version) (version >= SAVE_DATA_NO_ERROR && version < SAVEFILE_DARKPACK_VERSION_MAX)
