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

- `code/__DEFINES/~~crimson_defines/twitch.dm`: NO_TWITCH_SUB, TWITCH_SUB_TIER_1, TWITCH_SUB_TIER_2, TWITCH_SUB_TIER_3, ACCESS_TWITCH_UNSUBBED, ACCESS_TWITCH_SUB_TIER_1, ACCESS_TWITCH_SUB_TIER_2, ACCESS_TWITCH_SUB_TIER_3
- `code/__DEFINES/~~crimson_defines/patreon.dm`: NO_RANK, UNSUBBED, THANKS_RANK, ASSISTANT_RANK, COMMAND_RANK, TRAITOR_RANK, NUKIE_RANK, OLD_NUKIE_RANK, REALLY_ANOTHER_FUCKING_NUKIE_RANK, ACCESS_NONE_RANK, ACCESS_THANKS_RANK, ACCESS_ASSISTANT_RANK, ACCESS_COMMAND_RANK, ACCESS_TRAITOR_RANK, ACCESS_NUKIE_RANK

### Included files that are not contained in this module:

- `code/controllers/configuration/entries/~crimson.dm`
- `config/crimson/config.txt`

### Credits:

<!-- Here go the credits to you, dear coder, and in case of collaborative work or ports, credits to the original source of the code. -->

- Flleeppyy
- dwasint
