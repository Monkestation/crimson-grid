/// Associative list of Discipline names to typepaths
GLOBAL_LIST_INIT(discipline_list, init_discipline_list(/datum/discipline))

/// Associative list of Discipline typepaths to singletons
GLOBAL_LIST_INIT_TYPED(disciplines, /datum/discipline, init_subtypes_w_path_keys(/datum/discipline, list()))

/proc/init_discipline_list()
	var/list/discipline_list = list()
	for(var/datum/discipline/discipline_path as anything in valid_typesof(/datum/discipline))
		discipline_list[discipline_path::id] = discipline_path
	return discipline_list
