/// All human NPCs, living or dead
GLOBAL_LIST_EMPTY(npc_list)
/// All living human NPCs
GLOBAL_LIST_EMPTY(alive_npc_list)
/// Landmarks that NPCs will navigate towards
GLOBAL_LIST_EMPTY(npc_activities)
/// Landmarks that NPCs will spawn at
GLOBAL_LIST_EMPTY(npc_spawn_points)

/// Assoc list of npc social rolls by paths: instances
GLOBAL_LIST_INIT_TYPED(npc_social_roles, /datum/socialrole, init_subtypes_w_path_keys(/datum/socialrole, list()))
