@echo off

:: Commands
REM DOSKEY cb=win32yank.exe $*
REM todo make a bat file and call it
REM DOSKEY runmyahk=ahk.exe foo bar baz
DOSKEY alias=code "%USERPROFILE%\alias.cmd"
DOSKEY myahk=code "%USERPROFILE%\_workspace\myahk"
DOSKEY npp=start notepad++ $*
DOSKEY spy=start ahk.exe "C:\Program Files\AutoHotkey\WindowSpy.ahk"
DOSKEY gb="C:\Program Files\Git\git-bash.exe" $*
DOSKEY expl=explorer $*
DOSKEY acosetting=code "D:\Documents\Assassin's Creed Odyssey\ACOdyssey.ini"
DOSKEY firefox="C:\Program Files\Mozilla Firefox\firefox.exe" $*
DOSKEY scene="C:\Users\andre\AppData\Local\SceneBuilder\SceneBuilder.exe" $*

:: Chocolatey
DOSKEY ci=choco install $*
DOSKEY cs=choco list $*
DOSKEY cll=choco list --local-only $*
DOSKEY cif=choco info $*
REM cup.exe is already choco upgrade
DOSKEY cunin=choco uninstall $*

:: Common directories
DOSKEY ~=cd /d "%USERPROFILE%"
DOSKEY desktop=cd /d "%USERPROFILE%\desktop"
DOSKEY cdd=cd /d "F:\IDM"
DOSKEY cdw=cd /d "%USERPROFILE%\_workspace"

:: Clink
IF EXIST "%CLINK_DIR%\clink.bat" ("%CLINK_DIR%\clink.bat" inject)
