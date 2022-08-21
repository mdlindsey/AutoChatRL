# Rocket League Auto Chat

If you don't already have `AutoHotKey` you can [download it here](https://autohotkey.com/download).

Run `app.ahk` to load the script; edit `cfg.ahk` to alter configuration.

## Simplified Alt Accounts for Epic/Steam

Some people choose to run this script with an alternate account as the brief input disruption can be consequential in higher level gameplay.

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
