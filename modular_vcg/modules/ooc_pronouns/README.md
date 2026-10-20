<!-- This should be copy-pasted into the root of your module folder as readme.md -->

https://github.com/Monkestation/crimson-grid/pull/9

## OOC Pronouns <!--Title of your addition.-->

Module ID: ooc_pronouns<!-- Uppercase, UNDERSCORE_CONNECTED name of your module, that you use to mark files. This is so people can case-sensitive search for your edits, if any. -->

### Description:

Pronouns in OOC. Hover over username and it will show the users pronouns if set.

### TG Proc/File Changes:

<!-- If you edited any core procs, you should list them here. You should specify the files and procs you changed.
E.g:
- `code/modules/mob/living.dm`: `proc/overriden_proc`, `var/overriden_var`
  -->

- `code/modules/client/verbs/ooc.dm`: `/client/verb/ooc`

### Modular Overrides:

- N/A
<!-- If you added a new modular override (file or code-wise) for your module, you should list it here. Code files should specify what procs they changed, in case of multiple modules using the same file.
E.g:
- `modular_nova/master_files/sound/my_cool_sound.ogg`
- `modular_nova/master_files/code/my_modular_override.dm`: `proc/overriden_proc`, `var/overriden_var`
  -->

### Defines:

- N/A
<!-- If you needed to add any defines, mention the files you added those defines in, along with the name of the defines. -->
- `code/__DEFINES/~~crimson_defines/chat.dm`: `conditional_tooltip_alt`
- `code/__DEFINES/~~crimson_defines/span.dm`: `span_tooltip_alt`, `span_oocplain`

### Included files that are not contained in this module:

- `tgui/packages/tgui-panel/styles/tgchat/chat-dark.scss`: `.tooltip_alt`
- `tgui/packages/tgui-panel/styles/tgchat/chat-light.scss`: `.tooltip_alt`
- `tgui/packages/tgui/interfaces/PreferencesMenu/preferences/features/game_preferences/crimson/ooc.tsx`
<!-- Likewise, be it a non-modular file or a modular one that's not contained within the folder belonging to this specific module, it should be mentioned here. Good examples are icons or sounds that are used between multiple modules, or other such edge-cases. -->

### Credits:

Flleeppyy
