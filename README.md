# Castlevania: Belmont's Curse – USB/Joystick Menu Bug

A PowerShell-based launcher for **Castlevania: Belmont's Curse** on PC through the Xbox App or Steam, designed to work around an issue where menus continuously scroll upward when certain Razer keyboards are connected.

## ISSUE

Some USB devices (keyboards, controllers, etc) may interfere with controller input in Castlevania: Belmont's Curse.

**Symptoms:**
- Menus continuously scroll upward.
- Controller navigation becomes difficult or impossible.
- Disconnecting the Razer keyboard resolves the issue.
- Restarting the game or disabling overlays does not resolve the problem.

## What This Tool Does

The launcher automates a temporary keyboard-disable workaround:

1. Opens an elevated command window.
2. Disables the configured interfaces.
3. Launches Castlevania through the Xbox App or Steam
4. Monitors the game's processes.
5. Attempts to re-enable the keyboard automatically when the game exits.

No permanent keyboard configuration changes are intended.



## Installation & Usage

1. Download or clone this repository.
2. Place both launcher scripts in the same directory.
3. Open `Castlevania-Keyboard-Fix.ps1` and verify the keyboard instance IDs.
4. Right-click `Castlevania-Launcher.cmd`.
5. Select **Run as administrator**.
6. Approve the Windows UAC prompt.
7. Play Castlevania using your controller.

When the game closes, the launcher should attempt to restore the keyboard.

**Keep the command window open while playing.**



## Disclaimer

This is an unofficial, community-created workaround and is not affiliated with Konami, Microsoft, or Razer.

Use at your own risk. The author assumes no responsibility for device interruptions, unexpected keyboard behavior, or software compatibility issues.

---

**Developed as a workaround
