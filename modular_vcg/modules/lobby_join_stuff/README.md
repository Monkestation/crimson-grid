https://github.com/Monkestation/crimson-grid/pull/57

## Change Character Slot in Lobby menu

Module ID: CHANGE_CHARACTER_SLOT

### Description:

It adds a "Change Character" button to late join, letting you choose from a list of saved characters instead of opening the preferences menu clunkily. It also shows your current selected character when you ready up, and also in the stat panel.

### TG Proc/File Changes:

- `tgui/packages/tgui/interfaces/JobSelection.tsx`

### Modular Overrides:

- N/A
- `code/_onclick/hud/new_player.dm`: `/atom/movable/screen/lobby/button/ready/Click`
- `code/modules/mob/dead/new_player/latejoin_menu.dm`: `/datum/latejoin_menu/ui_data`, `/datum/latejoin_menu/ui_act`
- `code/modules/mob/dead/dead.dm`: `/mob/dead/get_status_tab_items`

### Defines:

N/A

### Included files that are not contained in this module:

- N/A

### Credits:

Flleeppyy
