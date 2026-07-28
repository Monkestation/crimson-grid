<!-- This should be copy-pasted into the root of your module folder as readme.md -->

https://github.com/Monkestation/crimson-grid/pull/<!--PR Number-->

## Change Character Slot in Lobby menu <!--Title of your addition.-->

Module ID: CHANGE_CHARACTER_SLOT<!-- Uppercase, UNDERSCORE_CONNECTED name of your module, that you use to mark files. This is so people can case-sensitive search for your edits, if any. -->

### Description:

<!-- Here, try to describe what your PR does, what features it provides and any other directly useful information. -->

### TG Proc/File Changes:

- N/A
<!-- If you edited any core procs, you should list them here. You should specify the files and procs you changed.
E.g:
- `code/modules/mob/living.dm`: `proc/overriden_proc`, `var/overriden_var`
  -->

### Modular Overrides:

- N/A
<!-- If you added a new modular override (file or code-wise) for your module, you should list it here. Code files should specify what procs they changed, in case of multiple modules using the same file.
E.g:
- `modular_nova/master_files/sound/my_cool_sound.ogg`
- `modular_nova/master_files/code/my_modular_override.dm`: `proc/overriden_proc`, `var/overriden_var`
  -->
- `code/_onclick/hud/new_player.dm`: `/atom/movable/screen/lobby/button/ready/Click`
- `code/modules/mob/dead/new_player/latejoin_menu.dm`: `/datum/latejoin_menu/ui_data`, `/datum/latejoin_menu/ui_act`
- `code/modules/mob/dead/dead.dm`: `/mob/dead/get_status_tab_items`

### Defines:

N/A

### Included files that are not contained in this module:

- N/A
<!-- Likewise, be it a non-modular file or a modular one that's not contained within the folder belonging to this specific module, it should be mentioned here. Good examples are icons or sounds that are used between multiple modules, or other such edge-cases. -->

### Credits:

Flleeppyy
