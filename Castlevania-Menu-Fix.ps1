<#
Script  :  Castlevania-Menu-Fix.ps1
Version :  1.0
Date    :  10/17/2026
Author: Jody Ingram
Notes: This script is designed to fix the input issue when launching Castlevania: Belmont's Curse on PC. It temporarily disables the keyboard & controller interfaces, launches the game, and restores the keyboard after the game exits.
#>


$ErrorActionPreference = 'Stop'

# Your USB interfaces. Add additional ones as needed.
$KeyboardIDs = @(
    'HID\VID_1532&PID_02CF&MI_01&COL01\7&2481A4F9&0&0000',
    'HID\VID_1532&PID_02CF&MI_00\7&AA6737&0&0000'
)

# Xbox application ID
$AppID = 'KonamiDigitalEntertainmen.CastlevaniaBelmontsCurse_168atcksx2mfc!Game'
$SteamID = 'KonamiDigitalEntertainment.CastlevaniaBelmontsCurse'

# Track the game launcher and any child processes
$Tracked = [System.Collections.Generic.HashSet[int]]::new()
$RestoreIDs = @()

function Get-GameProcesses {
    $all = @(Get-CimInstance Win32_Process)

    foreach ($p in $all) {
        if (
            $p.ExecutablePath -like '*KonamiDigitalEntertainmen.CastlevaniaBelmontsCurse*' -or
            $p.Name -match 'Castlevania|Belmont'
        ) {
            [void]$Tracked.Add([int]$p.ProcessId)
        }
    }

    # Follow child processes launched by the game
    $changed = $true
    while ($changed) {
        $changed = $false
        foreach ($p in $all) {
            if (
                $Tracked.Contains([int]$p.ParentProcessId) -and
                -not $Tracked.Contains([int]$p.ProcessId)
            ) {
                [void]$Tracked.Add([int]$p.ProcessId)
                $changed = $true
            }
        }
    }

    $all | Where-Object {
        $Tracked.Contains([int]$_.ProcessId)
    }
}

# Verify administrator privileges
$admin = ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)

if (-not $admin) {
    Write-Host 'ERROR: Run the CMD launcher as Administrator.' -ForegroundColor Red
    exit 1
}

try {
    if (@(Get-GameProcesses).Count -gt 0) {
        throw 'Close Castlevania before running this launcher.'
    }

    Write-Host 'Disabling interfaces...' -ForegroundColor Yellow

    foreach ($id in $KeyboardIDs) {
        $device = Get-PnpDevice -InstanceId $id -ErrorAction Stop
        if ($device.Status -ne 'OK') {
            throw "USB interface is not ready: $id"
        }

        $RestoreIDs += $id
        Disable-PnpDevice -InstanceId $id -Confirm:$false -ErrorAction Stop
    }

    Write-Host 'Launching Castlevania...' -ForegroundColor Cyan

    Start-Process explorer.exe -ArgumentList "shell:AppsFolder\$AppID"

    $startDeadline = (Get-Date).AddSeconds(120)
    $gameStarted = $false
    $lastActive = Get-Date

    while ($true) {
        $active = @(Get-GameProcesses)

        if ($active.Count -gt 0) {
            if (-not $gameStarted) {
                Write-Host 'Game detected. Monitoring for exit...' -ForegroundColor Green
            }

            $gameStarted = $true
            $lastActive = Get-Date
        }

        if (-not $gameStarted -and (Get-Date) -gt $startDeadline) {
            throw 'Game did not start within 120 seconds.'
        }

        # Allow 20 seconds for launcher-to-game handoffs
        if (
            $gameStarted -and
            ((Get-Date) - $lastActive).TotalSeconds -ge 20
        ) {
            Write-Host 'Game processes have exited.' -ForegroundColor Cyan
            break
        }

        Start-Sleep -Seconds 2
    }
}
catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
}
finally {
    Write-Host 'Restoring interfaces...' -ForegroundColor Yellow

    foreach ($id in $RestoreIDs) {
        try {
            Enable-PnpDevice -InstanceId $id -Confirm:$false -ErrorAction Stop
        }
        catch {
            Write-Host "Failed to restore $id" -ForegroundColor Red
        }
    }

    Write-Host 'Interface restoration attempted.' -ForegroundColor Green
}
