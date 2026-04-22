//#define LOWMEMORYMODE //uncomment this to load centcom and runtime station and thats it.
//#define ABSOLUTE_MINIMUM //uncomment this to load a smaller centcomm and smaller runtime station, only works together with LOWMEMORYMODE
//#define SHOW_INVENTORY_ICONS //uncomment this to make mapping software use inventory icons rather then world icons // DARKPACK EDIT ADD

#ifdef ABSOLUTE_MINIMUM
#define LOWMEMORYMODE
#endif

#ifndef ABSOLUTE_MINIMUM
#include "map_files\Vampire\admin_central.dmm" // DARKPACK EDIT CHANGE - ORIGINAL: #include "map_files\generic\CentCom.dmm"
#else
#include "map_files\generic\CentCom_minimal.dmm"
#endif

#ifndef LOWMEMORYMODE
	#ifdef ALL_MAPS
		// DARKPACK EDIT CHANGE START
		#include "map_files\Vampire\westfield_mall\westfield_mall.dmm"
		#include "map_files\Vampire\runtimetown.dmm"
		#include "map_files\debug\multiz.dmm"
		#include "map_files\debug\runtimestation.dmm"
		// DARKPACK EDIT CHANGE END
	#endif
	#ifdef ALL_TEMPLATES
		#include "templates.dm"
	#endif
#endif
