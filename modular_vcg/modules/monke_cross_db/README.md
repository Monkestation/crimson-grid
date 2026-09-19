<!-- This should be copy-pasted into the root of your module folder as readme.md -->

https://github.com/Monkestation/crimson-grid/pull/96

## Monke Cross DB

Module ID: MONKE_CROSS_DB

### Description:

adds support for connecting to a second databas, ported from Vanderlin, in this case the Monkestation database would be supported. adds additional param to NewQuery called cross_db db, as well as some new config entries for said database (`SQL_ENABLED_CROSS` and `FEEDBACK_DATABASE_CROSS`). this will be mostly used for the patreon

### TG Proc/File Changes:

- `code/controllers/subsystem/dbcore.dm`: `proc/NewQuery` (added `cross_db = FALSE` argument, and removed the last line that creates a new query, so the overriden proc we made does the check for cross.)

### Modular Overrides:

- `code/controllers/configuration/entries/~crimson.dm`: added `/datum/config_entry/flag/sql_enabled_cross`, `/datum/config_entry/string/feedback_database_cross`
- `config/crimson/dbconfig.txt`: new config file, added `SQL_ENABLED_CROSS` and `FEEDBACK_DATABASE_CROSS`
- `modular_vcg/modules/monke_cross_db/code/dbcore.dm`:
  - `datum/controller/subsystem/dbcore`: added `var/connection_cross`
  - `proc/Recover`
  - `proc/Shutdown`
  - `proc/NewQuery`

### Defines:

- N/A

### Included files that are not contained in this module:

- `code/controllers/configuration/entries/~crimson.dm`
- `config/crimson/dbconfig.txt`

### Credits:

- flleeppyy
- dwasint (original cross code)
