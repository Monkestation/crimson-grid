/// Associative list of Clan names to typepaths
GLOBAL_LIST_INIT(vampire_clan_list, init_subsplat_list(/datum/subsplat/vampire_clan))

/// Associative list of Clan typepaths to singletons
GLOBAL_LIST_INIT_TYPED(vampire_clans, /datum/subsplat/vampire_clan, init_subtypes_w_path_keys(/datum/subsplat/vampire_clan, list()))

/// All frenzied players
GLOBAL_LIST_EMPTY(frenzy_list)


GLOBAL_ALIST_INIT(beast_marks_to_names, beast_marks_to_names())
GLOBAL_ALIST_INIT(beast_marks_to_names_reverse, beast_marks_to_names(TRUE))
GLOBAL_ALIST_INIT(beast_mark_names_by_clan, beast_mark_names_by_clan())
