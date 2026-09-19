@echo off
echo ===================================
echo     Git Auto-Update ^& Push Script
echo ===================================
echo.

:: Stage all changes
echo Staging all changes...
git add .
echo.

:: Prompt for commit message
set /p msg="Enter commit message (or press Enter for 'update'): "
if "%msg%"=="" set msg=update

:: Commit changes
echo.
echo Committing changes...
git commit -m "%msg%"
echo.

:: Push to main branch
echo Pushing to remote main branch...
git push origin main
echo.

echo ===================================
echo     Git Update Completed!
echo ===================================
pause
