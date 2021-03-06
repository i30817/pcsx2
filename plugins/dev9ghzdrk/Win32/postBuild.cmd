::@echo off
::
:: Usage: postBuild.cmd SourcePath DestFile DestExt {plugins}
::
::     SourcePath - $(TargetPath) - Fully qualified path of the generated target file.
::     DestFile - Base filename of the target/dest, without extension!
::     DestExt - Extension of the target/dest!
::     plugins - optional parameter used to generate plugins into the /plugins folder
::
::  The destination file is determined by the PCSX2_TARGET_DIR environment var.

SETLOCAL ENABLEEXTENSIONS
if defined PCSX2_TARGET_COPY CALL :TestAndCopy "%PCSX2_TARGET_COPY%" %1 %2 %3 %4
ENDLOCAL
exit 0

if exists postBuild.inc.cmd call postBuild.inc.cmd

:TestAndCopy
:: Subroutine.  First parameter is our Target Dir.  Since it's a parameter into
:: the subroutine, we can use tilda expansion to handle quotes correctly. :)

if NOT EXIST "%~1" (
    md "%~1"
)

:: Error checking.  Try to change to the dir.  If it fails, it means the dir is
:: actually a file, and we should cancel the script.

set mycwd="%CD%"
cd "%~1"
if %ERRORLEVEL% NEQ 0 goto :eof
cd %mycwd%

set pcsxoutdir=%~1\%~5
set pcsxoutname=%pcsxoutdir%\%~3%4

IF NOT EXIST "%pcsxoutdir%" (
    md "%pcsxoutdir%"
)

copy /Y "%~2" "%pcsxoutname%"
if %ERRORLEVEL% EQU 0 (
    echo Target copied to %pcsxoutname%
)

goto :eof

:quit
