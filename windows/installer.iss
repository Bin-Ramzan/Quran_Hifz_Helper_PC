#define AppName "Quran Revision Companion"
#ifndef AppVersion
  #define AppVersion "1.0.0"
#endif

[Setup]
AppId={{6A9E7E6C-452B-41E4-9C74-9BF76D865044}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisher=Quran Revision Companion
DefaultDirName={localappdata}\Programs\Quran Revision Companion
DefaultGroupName={#AppName}
DisableProgramGroupPage=yes
UninstallDisplayName={#AppName}
UninstallDisplayIcon={app}\quranmemhelp.exe
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
PrivilegesRequired=lowest
OutputDir=..\dist
OutputBaseFilename=Quran-Revision-Companion-Setup-{#AppVersion}
SetupIconFile=runner\resources\app_icon.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Tasks]
Name: "desktopicon"; Description: "Create a desktop shortcut"; GroupDescription: "Additional shortcuts:"

[Files]
Source: "..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\{#AppName}"; Filename: "{app}\quranmemhelp.exe"
Name: "{autodesktop}\{#AppName}"; Filename: "{app}\quranmemhelp.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\quranmemhelp.exe"; Description: "Launch {#AppName}"; Flags: postinstall nowait skipifsilent