@echo off
setlocal enabledelayedexpansion
title SW Mehuli's Kitchen - Git Auto Updater
color 0F

echo ===================================================
echo     SW Mehuli's Kitchen - Git Auto-Update Tool
echo ===================================================
echo.

:: Check if Git is installed
where git >nul 2>nul
if %errorlevel% neq 0 (
    color 0C
    echo [ERROR] Git is not installed or not in your system's PATH.
    echo Please install Git and try again.
    echo.
    pause
    exit /b
)

:: Check Git Status
echo Checking repository status...
git status --short
echo.

:: Check if there are any changes to commit
set "CHANGES_DETECTED="
for /f "tokens=*" %%i in ('git status --porcelain') do (
    set "CHANGES_DETECTED=1"
)

if not defined CHANGES_DETECTED (
    color 0A
    echo ===================================================
    echo  No changes detected. Working tree is clean.
    echo  Everything is already up to date!
    echo ===================================================
    echo.
    pause
    exit /b
)

:: Prompt to stage and commit
echo Changes detected. Staging all files...
git add -A

echo.
set /p commit_msg="Enter commit message [Default: 'Update website files']: "
if "%commit_msg%"=="" set commit_msg=Update website files

echo.
echo Committing changes...
git commit -m "%commit_msg%"
if %errorlevel% neq 0 (
    color 0C
    echo.
    echo [ERROR] Failed to commit changes.
    pause
    exit /b
)

echo.
echo Pushing changes to GitHub (origin main)...
git push origin main

if %errorlevel% equ 0 (
    color 0A
    echo.
    echo ===================================================
    echo  SUCCESS: All changes pushed to GitHub successfully!
    echo ===================================================
) else (
    color 0C
    echo.
    echo ===================================================
    echo  ERROR: Failed to push changes.
    echo  Please check your internet connection or Git permissions.
    echo ===================================================
)

echo.
pause
