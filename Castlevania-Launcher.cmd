
@echo off
title Castlevania - Keyboard Fix
cd /d "%~dp0"

echo ========================================
echo  Castlevania: Belmont's Curse Launcher
echo ========================================
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Castlevania-Keyboard-Fix.ps1"

echo.
echo Launcher finished.
pause
