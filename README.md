# Castlevania: Belmont's Curse – Razer Keyboard Fix

A PowerShell-based launcher for **Castlevania: Belmont's Curse** on PC through the Xbox App, designed to work around an issue where menus continuously scroll upward when certain Razer keyboards are connected.

## 🎮 The Problem

Some Razer keyboards, particularly models with analog input or controller-emulation features, may interfere with controller input in Castlevania: Belmont's Curse.

**Symptoms:**
- Menus continuously scroll upward.
- Controller navigation becomes difficult or impossible.
- Disconnecting the Razer keyboard resolves the issue.
- Restarting the game or disabling overlays does not resolve the problem.

## 🛠️ What This Tool Does

The launcher automates a temporary keyboard-disable workaround:

1. Opens an elevated command window.
2. Disables the configured Razer keyboard interfaces.
3. Launches Castlevania through the Xbox App.
4. Monitors the game's processes.
5. Attempts to re-enable the keyboard automatically when the game exits.

No permanent keyboard configuration changes are intended.

## ✅ Requirements

- Windows 10/11
- Castlevania: Belmont's Curse installed through the Xbox App
- Windows PowerShell 5.1 or later
- Administrator privileges
- A controller or alternative input device

**Tested configuration target:**
- Keyboard: Razer Huntsman V3 Pro 8KHz
- USB Vendor ID: `1532`
- USB Product ID: `02CF`

> **Note:** This is an experimental workaround. It has not been confirmed to resolve the issue across all keyboard models or game configurations.

## 📁 Project Files

| File | Description |
|---|---|
| `Castlevania-Launcher.cmd` | Starts the PowerShell script in a visible command window |
| `Castlevania-Keyboard-Fix.ps1` | Disables the configured keyboard interfaces, launches the game, and handles restoration |
| `README.md` | Documentation |

## 🚀 Installation & Usage

1. Download or clone this repository.
2. Place both launcher scripts in the same directory.
3. Open `Castlevania-Keyboard-Fix.ps1` and verify the keyboard instance IDs.
4. Right-click `Castlevania-Launcher.cmd`.
5. Select **Run as administrator**.
6. Approve the Windows UAC prompt.
7. Play Castlevania using your controller.

When the game closes, the launcher should attempt to restore the keyboard.

**Keep the command window open while playing.**

## ⌨️ Finding Your Keyboard Instance IDs

Open PowerShell and run:

`Get-PnpDevice -PresentOnly -Class Keyboard | Format-List FriendlyName,InstanceId,Status`

Locate your Razer keyboard and copy the applicable `InstanceId` values into the `$KeyboardIDs` array in the PowerShell script.

Different Razer keyboard models may expose multiple HID interfaces. Do not disable unrelated devices.

## 🔧 Xbox App Configuration

The launcher currently uses the following Xbox application ID:

`KonamiDigitalEntertainmen.CastlevaniaBelmontsCurse_168atcksx2mfc!Game`

To verify the installed application ID, run:

`Get-StartApps | Where-Object {$_.Name -match 'Castlevania|Belmont'}`

If necessary, update `$AppID` in the PowerShell script.

## 🆘 Keyboard Recovery

If the keyboard is not automatically restored, connect another keyboard or use an alternative input method.

Open PowerShell as Administrator and run:

`Get-PnpDevice -Class Keyboard | Where-Object { $_.InstanceId -like 'HID\VID_1532&PID_02CF*' } | Enable-PnpDevice -Confirm:$false`

This recovery command targets the Huntsman V3 Pro 8KHz device interfaces identified above.

Reconnecting the keyboard or rebooting Windows may also help recover a disabled device, but restoration is not guaranteed.

## ⚠️ Known Limitations

- Administrator privileges are required to disable and enable devices.
- The game-process detection may require adjustments for different Xbox App installations.
- The launcher may not detect every game startup or shutdown scenario.
- Keyboard restoration can fail if PowerShell is forcibly terminated or Windows crashes.
- Some Razer keyboards expose virtual controller interfaces that are separate from their keyboard interfaces. Disabling keyboard interfaces alone may not eliminate the scrolling issue.

For your first test, keep an alternative input method available.

## 📌 Disclaimer

This is an unofficial, community-created workaround and is not affiliated with Konami, Microsoft, or Razer.

Use at your own risk. The author assumes no responsibility for device interruptions, unexpected keyboard behavior, or software compatibility issues.

---

**Developed as a workaround
