# NorKEY
A keyboard layout for Norwegian coders and translators on macOS and Windows.
The Mac layout is a Norwegian version of [EurKEY-Mac](https://github.com/jonasdiemer/EurKEY-Mac).
It only includes Æ, Ø and Å of the special symbols in the original layout - making it less error prone to typos for Norwegian users.

Æ, Ø and Å
=======
Both layouts type å, ø and æ (Shift for capitals) on the Japanese/Brazilian extra keys International 1, International 3 and Keypad Comma, not with AltGr/Option. Normal keyboards lack these keys, so NorKEY is meant for programmable keyboards that can send them. Unlike AltGr, they carry no modifier that apps can read as a shortcut; World of Warcraft chat reads AltGr+W as Ctrl+W and deletes the previous word.

Mac
=======

Install
-------
Copy the two files `mac/NorKEY.keylayout` and `mac/NorKEY.icns` to your library, either system-wide (`/Library/Keyboard Layouts`) or for your local user (`~/Library/Keyboard Layouts`). A system-wide installation is preferred to ensure the layout is available to all applications. For the changes to take effect a restart is required.

How to use the Keyboard
-------
After the restart go to `System Settings` > `Keyboard` > `Edit` > `+` and search for `NorKEY v1.0`. After adding the layout select its symbol from the menu bar icon.

Windows
=======
`windows/NorKEY.klc` is [EurKEY for Windows](https://eurkey.steffen.bruentjen.eu/) 1.3 with the AltGr (right Alt) letters removed. AltGr+Space gives a non-breaking space and AltGr+` is a dead key for accents.

Build
-----
Windows only loads compiled layouts. To build the installer, open the `Build Windows installer` workflow under `Actions` on GitHub, click `Run workflow`, and download `NorKEY-setup` from the finished run. The workflow compiles `windows/NorKEY.klc` with Microsoft Keyboard Layout Creator and packages it using `windows/NorKEY.iss`.

Install
-------
Run `NorKEY-setup.exe`. It is not signed, so Windows may warn about it; choose `More info` > `Run anyway`. Then sign out and back in, and add `NorKEY v1.0` under `Settings` > `Time & language` > `Language & region` > `Norwegian` > `Language options` > `Keyboards`.

To uninstall, first remove NorKEY from the keyboards in every Windows account that uses it, then uninstall `NorKEY keyboard layout` under `Settings` > `Apps`.

License
=======

The Layout itself is licensed under [GPLv3](http://www.gnu.org/licenses/gpl-3.0.html).
