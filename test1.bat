@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

set "path_code=code"
set "path_test=Test"
set "CC=gcc"

for %%X in ("%path_code%\*.c") do (
    set "name=%%~nX"
    %CC% "%%~fX" -o "%path_code%\!name!.exe" 2>nul
    if not exist "%path_code%\!name!.exe" (
        echo !name!: COMPILE FAIL
    ) else if exist "%path_test%\!name!-out.txt" (
        set "infile=%path_test%\!name!-in.txt"
        if exist "!infile!" (
            "%path_code%\!name!.exe" < "!infile!" > "%path_test%\actual-!name!.txt"
        ) else (
            "%path_code%\!name!.exe" > "%path_test%\actual-!name!.txt"
        )
        call :compare_files "%path_test%\actual-!name!.txt" "%path_test%\!name!-out.txt"
        if errorlevel 1 (
            echo !name!-out.txt: FAIL
        ) else (
            echo !name!-out.txt: PASS
        )
        del "%path_test%\actual-!name!.txt" 2>nul
    ) else if exist "%path_test%\!name!-out0.txt" (
        call :run_numbered !name!
    ) else (
        echo !name!: SKIP ^(no !name!-out.txt in Test^)
    )
)

endlocal
goto :eof

:compare_files
set "CMP_ACT=%~1"
set "CMP_EXP=%~2"
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$aPath = $env:CMP_ACT; $ePath = $env:CMP_EXP;" ^
  "if (-not (Test-Path -LiteralPath $aPath)) { exit 1 };" ^
  "if (-not (Test-Path -LiteralPath $ePath)) { exit 1 };" ^
  "$e = [IO.File]::ReadAllText($ePath, [Text.Encoding]::Unicode);" ^
  "$bytes = [IO.File]::ReadAllBytes($aPath);" ^
  "$utf8 = New-Object System.Text.UTF8Encoding $false;" ^
  "$a = $utf8.GetString($bytes);" ^
  "function Norm([string]$t) { return $t.Replace([char]13+[char]10,[char]10).Replace([char]13,[char]10) };" ^
  "if ((Norm $a) -eq (Norm $e)) { exit 0 } else { exit 1 }"
exit /b !errorlevel!

:run_numbered
set "rn_name=%~1"
set /a rn_n=0
:rn_loop
if not exist "%path_test%\%rn_name%-out%rn_n%.txt" goto rn_done
set "rn_in=%path_test%\%rn_name%-in%rn_n%.txt"
if exist "%rn_in%" (
    "%path_code%\%rn_name%.exe" < "%rn_in%" > "%path_test%\actual-%rn_name%-%rn_n%.txt"
) else (
    "%path_code%\%rn_name%.exe" > "%path_test%\actual-%rn_name%-%rn_n%.txt"
)
call :compare_files "%path_test%\actual-%rn_name%-%rn_n%.txt" "%path_test%\%rn_name%-out%rn_n%.txt"
if errorlevel 1 (
    echo %rn_name%-out%rn_n%.txt: FAIL
) else (
    echo %rn_name%-out%rn_n%.txt: PASS
)
del "%path_test%\actual-%rn_name%-%rn_n%.txt" 2>nul
set /a rn_n+=1
goto rn_loop
:rn_done
exit /b 0
