@echo off
rem Remove build outputs, simulator outputs (vlsim\out) and MAX+PLUS II artifacts (see tools\clean.js).
rem The firmware gmx.rom, gmx_cpld.pof in the root is kept.
rem   clean.bat         clean
rem   clean.bat dry     only list what would be removed
setlocal
cd /d "%~dp0"
where node >nul 2>nul || (echo ERROR: node.js not found in PATH & exit /b 1)
if /i "%~1"=="dry" (node tools\clean.js --dry) else (node tools\clean.js)
exit /b %errorlevel%
