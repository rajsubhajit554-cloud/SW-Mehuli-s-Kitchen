@echo off
title SW Mehuli's Kitchen - Auto Git Update
color 0B
echo ====================================================
echo      SW Mehuli's Kitchen - Auto Update Script
echo ====================================================
echo.

:: Check if git is installed
where git >nul 2>nul
if %errorlevel% neq 0 (
    color 0C
    echo [ERROR] Git is not installed or not in your system PATH.
    echo Please install Git and try again.
    pause
    exit /b
)

echo Checking for changes...
git status --short
echo.

:: Prompt for commit message
set /p commit_msg="Enter update message (press Enter for default 'Site updated'): "
if "%commit_msg%"=="" set commit_msg=Site updated

echo.
echo Adding all changes...
git add .

echo.
echo Committing changes...
git commit -m "%commit_msg%"

echo.
echo Pushing to GitHub...
git push origin main

if %errorlevel% equ 0 (
    color 0A
    echo.
    echo ====================================================
    echo      SUCCESS: Changes pushed to GitHub successfully!
    echo ====================================================
) else (
    color 0C
    echo.
    echo ====================================================
    echo      ERROR: Failed to push changes.
    echo      Please check your internet connection or git login.
    echo ====================================================
)

echo.
pause
