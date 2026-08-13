//#define SHOW_INVENTORY_ICONS //uncomment this to make mapping software use inventory icons rather then world icons // DARKPACK EDIT ADD

#ifndef MINIMAL_CENTCOM
#include "map_files\Vampire\admin_central.dmm" // DARKPACK EDIT CHANGE - ORIGINAL: #include "map_files\generic\CentCom.dmm"
#else
#include "map_files\generic\CentCom_minimal.dmm"
#endif

#ifdef ALL_MAPS
	// DARKPACK EDIT CHANGE START
	#include "map_files\Vampire\san_fangsisco\sanfangsisco.dmm" // CRIMSON EDIT - Map
	#include "map_files\Vampire\oakland\bomby_oakland.dmm" // CRIMSON EDIT ADD - Oakland
	#include "map_files\Vampire\westfield_mall\westfield_mall.dmm"
	#include "map_files\Vampire\runtimetown.dmm"
	#include "map_files\debug\multiz.dmm"
	#include "map_files\debug\runtimestation.dmm"
	// DARKPACK EDIT CHANGE END
#endif
#ifdef ALL_TEMPLATES
	#include "templates.dm"
#endif
