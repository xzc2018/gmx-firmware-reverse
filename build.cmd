@echo off
rem Scorpion GMX firmware build.
rem   build.cmd                     compile FLEX (scorpion, pentagon) and CPLD with MAX+PLUS II -> bitstream\,
rem                                 then roms\ + bitstream\ -> banks\ -> gmx.rom and gmx_cpld.pof
rem   build.cmd nocompile           skip MAX+PLUS II, use what is already in bitstream\
rem   build.cmd keepboot            as build.cmd, then also gmx_keepboot.rom: page 0 (Flash boot block: loader
rem                                 and Start Sch) from the original bitstream, identical to gmx12501.rom;
rem                                 the other blocks as in gmx.rom
rem   build.cmd nocompile keepboot  the same without MAX+PLUS II
rem   build.cmd cbr                 additionally FLEX designs with DRAM refresh by CAS-before-RAS cycles
rem                                 (parameter CBR = 1) -> bitstream\*_cbr.rbf -> gmx_cbr.rom; with keepboot
rem                                 also gmx_cbr_keepboot.rom (page 0 from gmx12501.rom); flags combine:
rem                                 build.cmd keepboot cbr, build.cmd nocompile keepboot cbr
rem   build.cmd verify              self-test: original bitstreams + roms\ must give the original gmx12501.rom
rem Needs Node.js (node in PATH) and, for compiling, MAX+PLUS II 10.x (set MAXPLUS2=path\maxplus2.exe,
rem default C:\maxplus2\maxplus2.exe).
setlocal
cd /d "%~dp0"
where node >nul 2>nul || (echo ERROR: node.js not found in PATH & exit /b 1)

set "COMPILE=1"
set "KEEPBOOT=0"
set "CBR=0"
:args
if "%~1"=="" goto :run
if /i "%~1"=="verify" (
  node tools\verify.js || goto :fail
  goto :ok
)
if /i "%~1"=="nocompile" (set "COMPILE=0") else if /i "%~1"=="keepboot" (set "KEEPBOOT=1") else if /i "%~1"=="cbr" (set "CBR=1") else (
  echo ERROR: unknown argument %~1
  goto :fail
)
shift
goto :args

:run
if "%COMPILE%"=="1" (
  node tools\compile.js scorpion || goto :fail
  node tools\compile.js pentagon || goto :fail
  node tools\compile.js cpld     || goto :fail
  if "%CBR%"=="1" (
    node tools\compile.js scorpion --cbr || goto :fail
    node tools\compile.js pentagon --cbr || goto :fail
  )
)
node tools\make_banks.js || goto :fail
node tools\make_rom.js   || goto :fail
if "%KEEPBOOT%"=="1" (
  node tools\make_banks.js --keepboot --out build\keepboot\banks           || goto :fail
  node tools\make_rom.js --banks build\keepboot\banks --out gmx_keepboot.rom --pof none || goto :fail
)
if "%CBR%"=="1" (
  node tools\make_banks.js --variant cbr --out build\cbr\banks                                  || goto :fail
  node tools\make_rom.js --banks build\cbr\banks --out gmx_cbr.rom --pof none                    || goto :fail
  if "%KEEPBOOT%"=="1" (
    node tools\make_banks.js --variant cbr --keepboot --out build\cbr_keepboot\banks             || goto :fail
    node tools\make_rom.js --banks build\cbr_keepboot\banks --out gmx_cbr_keepboot.rom --pof none || goto :fail
  )
)

:ok
echo.
echo BUILD OK
exit /b 0

:fail
echo.
echo BUILD FAILED
exit /b 1
