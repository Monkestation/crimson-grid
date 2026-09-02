https://github.com/Monkestation/crimson-grid/pull/116

## Subsplat Bans

Module ID: SUBSPLAT_BANS<!-- Uppercase, UNDERSCORE_CONNECTED name of your module, that you use to mark files. This is so people can case-sensitive search for your edits, if any. -->

### Description:

ability to ban splats and subsplats. yes the name is misleading, no i dont wanna rename it.

### TG Proc/File Changes:

- `code/modules/admin/sql_ban_system.dm`: added Splats, Clans, Tribes, and Auspice's to `long_job_lists`
- `code/modules/mob/dead/new_player/latejoin_menu.dm`: `/datum/latejoin_menu/ui_data` added `mob` argument to `get_job_unavailable_error_message`
- `code/modules/mob/dead/new_player/new_player.dm`: `get_job_unavailable_error_message` message additions, also the above
- `modular_darkpack/modules/jobs/code/_job_assignment.dm`: added `is_banned_from` check for everything applicable
- `tgui/packages/tgui/interfaces/PreferencesMenu/CharacterPreferences/MainPage.tsx`
- `tgui/packages/tgui/interfaces/PreferencesMenu/types.ts`

### Modular Overrides:

- N/A
<!-- If you added a new modular override (file or code-wise) for your module, you should list it here. Code files should specify what procs they changed, in case of multiple modules using the same file.
E.g:
- `modular_nova/master_files/sound/my_cool_sound.ogg`
- `modular_nova/master_files/code/my_modular_override.dm`: `proc/overriden_proc`, `var/overriden_var`
  -->

### Defines:

- `code/__DEFINES/jobs.dm`: JOB_UNAVAILABLE_BANNED_SPLAT, JOB_UNAVAILABLE_BANNED_TRIBE, JOB_UNAVAILABLE_BANNED_CLAN, JOB_UNAVAILABLE_BANNED_AUSPICE

<!-- If you needed to add any defines, mention the files you added those defines in, along with the name of the defines. -->

### Included files that are not contained in this module:

- `code/__HELPERS/~~crimson_helpers/text.dm`: `snake_to_pascal`
<!-- Likewise, be it a non-modular file or a modular one that's not contained within the folder belonging to this specific module, it should be mentioned here. Good examples are icons or sounds that are used between multiple modules, or other such edge-cases. -->

### Credits:

<!-- Here go the credits to you, dear coder, and in case of collaborative work or ports, credits to the original source of the code. -->

Flleeppyy
