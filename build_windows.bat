@echo off
setlocal

where flutter >nul 2>&1
if errorlevel 1 (
  echo Flutter was not found on PATH. Install the stable Flutter SDK first.
  exit /b 1
)

call flutter pub get
if errorlevel 1 exit /b 1

call flutter build windows --release
if errorlevel 1 exit /b 1

echo.
echo Windows release built successfully:
echo %CD%\build\windows\x64\runner\Release\quranmemhelp.exe
echo Keep the executable beside its DLLs and data folder.

endlocal