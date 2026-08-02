<!-- This should be copy-pasted into the root of your module folder as readme.md -->

https://github.com/Monkestation/crimson-grid/pull/96

## Donator Module

Module ID: donator

### Description:

Donator module for retireving info from the database on players if they are a twitch subscriber or patreon supporter and allowing them access to benefits.

### TG Proc/File Changes:

- `code/modules/client/preferences.dm`: `/datum/preferences/New`
- `code/modules/mob/dead/new_player/new_player.dm`: `proc/get_job_unavailable_error_message`

### Modular Overrides:

- N/A

### Defines:

- N/A
<!-- If you needed to add any defines, mention the files you added those defines in, along with the name of the defines. -->

### Included files that are not contained in this module:

- `code/controllers/configuration/entries/~crimson.dm`
- `config/crimson/config.txt`

### Credits:

<!-- Here go the credits to you, dear coder, and in case of collaborative work or ports, credits to the original source of the code. -->

- Flleeppyy
- dwasint
