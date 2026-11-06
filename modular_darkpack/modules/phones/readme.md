https://github.com/DarkPack13/SecondCity/pull/227

## \<PHONES>

Module ID: PHONES

### Description:

This module handles everything related to phones, contacts, sim cards, and so on.

Corvax adds a searchable phone book with abbreviated names and shared per-SIM aliases for unowned phones. Numbers appear only in chat after confirming a selection; service phones retain their service labels.

### TG Proc/File Changes:

- N/A

### Modular Overrides:

- `modular_corvax/modules/phones/code/phone_book.dm`: directory implementation (`/obj/item/phone_book/proc/show_directory`), `/obj/item/sim_card/directory_name`, and `/client/phone_book_open` (one pending directory per player across all books).
- `code/phone_book.dm`: marked `CORVAX EDIT` hook in `attack_self` replaces the upstream chat loop with `show_directory(user)`, preserving the parent call.

### Defines:

- `code/__DEFINES/~darkpack/phones.dm`

### Included files that are not contained in this module:

- `code/_globalvars/darkpack/lists/phone_contacts.dm`

### Credits:

XeonMations
Shadow for the initial TGUI work!
Marshmellow105 for inhand sprites + Sprite conversion!
Azlan (Github: SomeAngryMiner) for the sprites!
