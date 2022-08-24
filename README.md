# Rocket League Auto Chat

If you don't already have `AutoHotKey` you can [download it here](https://autohotkey.com/download).

Run `app.ahk` to load the script; edit `config.ahk` to alter configuration. The script will need to be restarted to reflect configuration changes made in `config.ahk`.

## How to use

Hotkeys can be changed in `config.ahk`.

Press `F5` to start sending messages; press `F6` to stop sending messages. 

Press `F7` to change the time between messages (`CFG_INTERVAL` in `config.ahk`) via prompt without the need to restart the script.

Press `F8` for the multi-user prompt if multiple people are running this script; users are not zero-indexed.

### Message source

By default, the script pulls `messages/CatFacts.txt` from the `main` branch of this repo. If you prefer to load facts from your local PC, change `CFG_MSG_SRC` in `config.ahk` to the filepath you wish to use (eg: `messages/CatFacts.txt`).

You can assign static messages to hotkeys of your choice via `CFG_MSG_STATIC` in `config.ahk`; sending static messages will stop the script to prevent input conflict.

## Simplified alt accounts for Epic/Steam

Some people choose to run this script with an alternate Rocket League account as the brief input disruption can be consequential in higher level gameplay.

### Setting up an alt account

1. Create new Windows user
2. Sign into alt Epic/Steam on new Windows user account
3. Sign out of new Windows account and back into main Windows account
4. Duplicate (copy/paste) your desktop shortcut for Epic/Steam/Bakkes
5. Replace the `Target` property of the shortcut with its respective snippet below
6. Change `Alt` to the name of your new Windows user from `#1` in each snippet below

Steam shortcut `Target` property
```
%windir%\system32\runas.exe /user:Alt /savecred "C:\Program Files (x86)\Steam\Steam.exe"
```

Epic shortcut `Target` property
```
%windir%\system32\runas.exe /user:Alt /savecred "C:\Program Files (x86)\Epic Games\Launcher\Portal\Binaries\Win32\EpicGamesLauncher.exe"
```

Bakkes shortcut `Target` property
```
%windir%\system32\runas.exe /user:Alt /savecred "C:\Program Files\BakkesMod\BakkesMod.exe"
```

This will cause the shortcut icon to break. To fix, select `Change Icon` and select the respective `exe` from the file paths listed above.

If you created the alt Windows user with a password you will be prompted for the password the first time you run it but never again.
