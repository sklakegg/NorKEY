# NorKEY-Mac
A great keyboard layout for Norwegian coders and translators, for Mac and Windows.
Norwegian version of [EurKEY-Mac](https://github.com/jonasdiemer/EurKEY-Mac).
It only includes Æ, Ø and Å of the special symbols in the original layout - making it less error prone to typos for Norwegian users.

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
`windows/NorKEY.klc` is a port of the Mac layout. Option maps to AltGr (right Alt). The Caps Lock + Option symbols are not available on Windows.

Build
-----
Windows only loads compiled layouts, so the `.klc` source must be built once:

1. Install [Microsoft Keyboard Layout Creator](https://www.microsoft.com/en-us/download/details.aspx?id=102134).
2. Open `windows/NorKEY.klc` and choose `Project` > `Build DLL and Setup Package`.

This creates an installer package that can be reused on any Windows PC.

Install
-------
Run `setup.exe` from the built package, then sign out and back in. The layout is installed under Norwegian (Bokmål) as `NorKEY v1.0`. Add it in `Settings` > `Time & language` > `Language & region` if it is not listed.

License
=======

The Layout itself is licensed under [GPLv3](http://www.gnu.org/licenses/gpl-3.0.html).
