@echo off
setlocal
cd /d "%~dp0"
title SkillSync AI - Local Demo
where py >nul 2>nul
if %errorlevel%==0 goto usepy
where python >nul 2>nul
if %errorlevel%==0 goto usepython
echo Python was not found on this computer.
echo Install Python from https://www.python.org/downloads/ and select "Add Python to PATH".
pause
exit /b 1
:usepy
start "SkillSync AI server" /D "%~dp0" cmd /k py -3 -m http.server 5500
goto openbrowser
:usepython
start "SkillSync AI server" /D "%~dp0" cmd /k python -m http.server 5500
:openbrowser
timeout /t 2 /nobreak >nul
start "" http://localhost:5500
echo.
echo SkillSync AI is opening at http://localhost:5500
echo Keep the black server window open while using the website.
echo Close that window to stop the local website.
endlocal
