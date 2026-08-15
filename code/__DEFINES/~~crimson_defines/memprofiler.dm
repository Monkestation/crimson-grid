#define MEMPROFILE_DLL (world.system_type == MS_WINDOWS ? "byond_memprofile.dll" : (__memprofile ||= __detect_auxtools("byond_memprofile")))
