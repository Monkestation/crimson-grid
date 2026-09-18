## The Second City codebase

[![resentment](.github/images/badges/built-with-resentment.svg)](.github/images/comics/131-bug-free.png) [![technical debt](.github/images/badges/contains-technical-debt.svg)](.github/images/comics/106-tech-debt-modified.png) [![forinfinityandbyond](.github/images/badges/made-in-byond.gif)](https://www.reddit.com/r/SS13/comments/5oplxp/what_is_the_main_problem_with_byond_as_an_engine/dclbu1a)

| Website                 | Link                                     |
| ----------------------- | -----------------------------------------|
| Code                    | https://github.com/DarkPack13/SecondCity |
| The Second City Discord | https://discord.gg/rmAbJcuChD            |
| Coderbus Discord        | https://discord.gg/Vh8TJp9               |
| Getting Started With Development | https://hackmd.io/@tgstation/HJ8OdjNBc#tgstation-Development-Guide |

This is the codebase for the Darkpack13 Project, a fork of TGstation 2025 for the purposes of being an upstream for The Final Nights, Apocrypha, Requiem and World of Darkness 13.

We are based on the Paradox Interactive World of Darkness(c) gamelines, with administrative oversight determining what we add to our game.

## DOWNLOADING

[Downloading](.github/guides/DOWNLOADING.md)

[Running a server](.github/guides/RUNNING_A_SERVER.md)

## Compilation

**The quick way**. Find `bin/server.cmd` in this folder and double click it to automatically build and host the server on port 1337.

**The long way**. Find `bin/build.cmd` in this folder, and double click it to initiate the build. It consists of multiple steps and might take around 1-5 minutes to compile. If it closes, it means it has finished its job. You can then [setup the server](.github/guides/RUNNING_A_SERVER.md) normally by opening `tgstation.dmb` in DreamDaemon.

**Building tgstation in DreamMaker directly is deprecated and might produce errors**, such as `'tgui.bundle.js': cannot find file`.

**[How to compile in VSCode and other build options](tools/build/README.md).**

## LICENSE

All code after [commit 333c566b88108de218d882840e61928a9b759d8f on 2014/12/31 at 4:38 PM PST](https://github.com/tgstation/tgstation/commit/333c566b88108de218d882840e61928a9b759d8f) is licensed under [GNU AGPL v3](https://www.gnu.org/licenses/agpl-3.0.html).

All code before [commit 333c566b88108de218d882840e61928a9b759d8f on 2014/12/31 at 4:38 PM PST](https://github.com/tgstation/tgstation/commit/333c566b88108de218d882840e61928a9b759d8f) is licensed under [GNU GPL v3](https://www.gnu.org/licenses/gpl-3.0.html).
(Including tools unless their readme specifies otherwise.)

See LICENSE and GPLv3.txt for more details.

The TGS DMAPI is licensed as a subproject under the MIT license.

See the footer of [code/\_\_DEFINES/tgs.dm](./code/__DEFINES/tgs.dm) and [code/modules/tgs/LICENSE](./code/modules/tgs/LICENSE) for the MIT license.

All assets including icons and sound are under a [Creative Commons 3.0 BY-SA license](https://creativecommons.org/licenses/by-sa/3.0/) unless otherwise indicated.

Darkpack13 is not official World of Darkness material. Portions of the materials are the copyrights and trademarks of Paradox Interactive AB, and are used with permission. All rights reserved. For more information please visit worldofdarkness.com.

![darkpack_logo2](https://github.com/user-attachments/assets/643ce14e-066c-4c81-998f-2e7881f0518d)
