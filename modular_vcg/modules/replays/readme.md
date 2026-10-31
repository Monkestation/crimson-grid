## Replays

Module ID: REPLAYS

### Description:

Records every round into `data/replay/round-<round id>.replay` (`<unix time>.replay` with no
database), with the chat log, so it can be watched again later in byond-re's replay viewer. Hiding
ckeys is the `REPLAY_CKEY_KEY` config entry. Admins with +DEBUG get three verbs: start, stop and
status.

Also swaps byond-tracy for the one from byond-re, which is linked into the recorder's library and
has to start before the recorder does.

`replay_recorder.dll` and `libreplay_recorder.so` sit at the repo root, with byond-tracy inside
them. byond-re's `crates/replay-recorder/build_production.ps1 -Tree <this repo>` builds both.
`code/replay_recorder.dm` and `code/byond_tracy.dm` are copies of byond-re's
`crates/replay-recorder/replay_recorder.dm` and `crates/byond-tracy/byond_tracy.dm`: copy them again
when the libraries change.

The recorder only runs on BYOND 516.1687 and refuses anything else, so `dependencies.sh` and
`.tgs.yml` pin that build.

Chat sent with `confidential = TRUE` is left out of recordings. So is chat written straight to a
client with `<<` or `SEND_TEXT` instead of `to_chat`.

### TG Proc/File Changes:

- `dependencies.sh`, `.tgs.yml`: BYOND 516.1687
- `.gitignore`: tracks `libreplay_recorder.so`
- `code/_compile_options.dm`: `USE_BYOND_TRACY` comment
- `code/__DEFINES/tracy.dm`: `TRACY_DLL_PATH` names the recorder's library, adds `BYOND_TRACY_DLL`
- `code/__DEFINES/chat.dm`: `debug_admins` is confidential
- `code/__HELPERS/mobs.dm`
  - `/proc/deadchat_broadcast()`: admin-only messages are confidential
- `code/__HELPERS/priority_announce.dm`
  - `/proc/dispatch_announcement_to_players()`: records one copy for everyone
- `code/controllers/failsafe.dm`
  - `/datum/controller/failsafe/proc/Loop()`, `/proc/recover_all_SS_and_recreate_master()`, `/proc/delete_all_SS_and_recreate_master()`: admin messages are confidential
- `code/controllers/master.dm`
  - `/datum/controller/master/Recover()`: admin message is confidential
- `code/controllers/subsystem/chat.dm`
  - `/datum/controller/subsystem/chat/proc/queue()`, `proc/send_immediate()`: record chat that is not confidential
- `code/controllers/subsystem/ticker.dm`
  - `/datum/controller/subsystem/ticker/proc/display_roundstart_logout_report()`: confidential
- `code/game/objects/items/charter.dm`: rename request to admins is confidential
- `code/game/world.dm`
  - `/world/New()`: starts recording
  - `/world/Reboot()`, `/world/Del()`: stops recording
- `code/modules/admin/verbs/adminhelp.dm`
  - `/datum/admin_help/proc/send_message_to_tgs()`: urgent notice is confidential
- `code/modules/asset_cache/transports/asset_transport.dm`
  - `/datum/asset_transport/proc/register_asset()`: tells the recorder each asset's URL
- `code/modules/client/client_procs.dm`
  - `/client/New()`, `/client/Destroy()`: login and logout events
- `code/modules/client/verbs/ooc.dm`
  - `ooc`: stealthed-admin lines are confidential, records one copy for everyone
- `code/modules/debugging/tracy.dm`
  - `/datum/tracy/Destroy()`, `/datum/tracy/proc/enable()`: the new byond-tracy's API
- `code/modules/mob/login.dm`
  - `/mob/Login()`: which mob a client controls
- `code/modules/shuttle/shuttle_consoles/shuttle_console.dm`: shuttle request to admins is confidential
- `code/modules/tgchat/to_chat.dm`
  - `/proc/to_chat_immediate()`, `/proc/to_chat()`: pass `confidential` on
- `modular_darkpack/modules/looc/code/verbs.dm`: admin LOOC copies are confidential
- `modular_darkpack/modules/mentor/code/ahelp_reject.dm`, `mentor.dm`, `mentorpm.dm`: staff-only messages are confidential
- `config/config.txt`: `REPLAY_CKEY_KEY`

### Modular Overrides:

- N/A

### Defines:

- `code/__DEFINES/tracy.dm`: `BYOND_TRACY_DLL`

### Included files that are not contained in this module:

- `replay_recorder.dll`, `libreplay_recorder.so` at the repo root

### Credits:

Lucy
