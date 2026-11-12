@echo off
rem Build the GMX board simulator for one firmware variant (testbench).
rem   build.cmd orig      models\orig    (original FLEX bitstreams and CPLD configuration)
rem   build.cmd rebuilt   models\rebuilt (FLEX and CPLD built from the sources of this repository)
rem Requires: Verilator 5.x (environment variable VERILATOR_ROOT, bin\verilator_bin.exe inside),
rem Microsoft Visual C++ (searched in Program Files\Microsoft Visual Studio, or set VCVARS to vcvars64.bat,
rem or run from a "x64 Native Tools" prompt).
rem Output: out\build_<variant>\gmxsim.exe. Runs at low priority.
setlocal
cd /d "%~dp0"
set "VAR=%~1"
if "%VAR%"=="" set "VAR=orig"
if not exist "models\%VAR%\flex_scorpion.v" (echo ERROR: models\%VAR% not found & exit /b 1)
if "%VERILATOR_ROOT%"=="" (echo ERROR: set VERILATOR_ROOT to the Verilator installation & exit /b 1)
where cl >nul 2>nul
if not errorlevel 1 goto :have_cl
if "%VCVARS%"=="" (
  for /d %%v in ("%ProgramFiles%\Microsoft Visual Studio\*" "%ProgramFiles(x86)%\Microsoft Visual Studio\*") do (
    for /d %%e in ("%%~v\*") do if exist "%%~e\VC\Auxiliary\Build\vcvars64.bat" set "VCVARS=%%~e\VC\Auxiliary\Build\vcvars64.bat"
  )
)
if "%VCVARS%"=="" (echo ERROR: MSVC not found, set VCVARS to vcvars64.bat & exit /b 1)
call "%VCVARS%" >nul 2>nul
:have_cl
set "BD=out\build_%VAR%"
if not exist "%BD%" mkdir "%BD%"
set "VI=%VERILATOR_ROOT%\include"
start "" /low /b /wait "%VERILATOR_ROOT%\bin\verilator_bin.exe" --cc --compiler msvc --top gmx_board --prefix Vgmx_board ^
  --Mdir "%BD%\obj" -O3 --savable --x-assign fast --x-initial fast --output-split 20000 -DTV80_REFRESH ^
  -Wno-fatal -Wno-lint -Wno-style -Werror-PINMISSING -Wno-UNOPTFLAT -Wno-MULTIDRIVEN -Wno-COMBDLY -Wno-LATCH ^
  -Wno-INITIALDLY -Wno-TIMESCALEMOD -Imodels\%VAR% rtl\gmx_board.v rtl\tv80z.v rtl\vl_prims.v ^
  third_party\tv80\tv80_core.v third_party\tv80\tv80_alu.v third_party\tv80\tv80_mcode.v third_party\tv80\tv80_reg.v ^
  models\%VAR%\flex_scorpion.v models\%VAR%\flex_pentagon.v models\%VAR%\cpld_gmx.v || exit /b 1
pushd "%BD%"
start "" /low /b /wait cl /nologo /O2 /EHsc /std:c++17 /MP4 /w /I obj /I "%VI%" /I "%VI%\vltstd" ^
  /Fe:gmxsim.exe ..\..\sim_main.cpp obj\*.cpp "%VI%\verilated.cpp" "%VI%\verilated_dpi.cpp" ^
  "%VI%\verilated_save.cpp" "%VI%\verilated_threads.cpp" >build.log
set "RC=%errorlevel%"
popd
if not "%RC%"=="0" (type "%BD%\build.log" & echo BUILD FAILED & exit /b 1)
echo built %BD%\gmxsim.exe
exit /b 0
