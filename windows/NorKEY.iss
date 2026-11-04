; Inno Setup script for the NorKEY Windows layout. Built by .github/workflows/build-windows.yml,
; which compiles NorKEY.klc into the per-architecture DLLs under BuildDir first.
#ifndef BuildDir
  #define BuildDir "..\build"
#endif

[Setup]
AppId=NorKEY
AppName=NorKEY keyboard layout
AppVersion=1.0
AppPublisher=Simon Klakegg
AppPublisherURL=https://github.com/sklakegg/NorKEY
DefaultDirName={autopf}\NorKEY
DisableDirPage=yes
DisableProgramGroupPage=yes
PrivilegesRequired=admin
ArchitecturesAllowed=x86os or x64os
ArchitecturesInstallIn64BitMode=x64os
OutputBaseFilename=NorKEY-setup
WizardStyle=modern

[Messages]
FinishedLabel=NorKEY is installed. Sign out and back in, then add "NorKEY v1.0" under Settings > Time & language > Language & region > Norwegian > Language options > Keyboards.

[Files]
Source: "{#BuildDir}\amd64\NorKEY.dll"; DestDir: "{sys}"; Check: Is64BitInstallMode; \
  Flags: ignoreversion restartreplace uninsrestartdelete
Source: "{#BuildDir}\wow64\NorKEY.dll"; DestDir: "{syswow64}"; Check: Is64BitInstallMode; \
  Flags: ignoreversion restartreplace uninsrestartdelete
Source: "{#BuildDir}\i386\NorKEY.dll"; DestDir: "{sys}"; Check: not Is64BitInstallMode; \
  Flags: ignoreversion restartreplace uninsrestartdelete

[Code]
const
  LayoutsKey = 'SYSTEM\CurrentControlSet\Control\Keyboard Layouts';
  LayoutFile = 'NorKEY.dll';
  LangId = '0414';

{ Finds the layout registered with our DLL, so reinstalls and uninstalls reuse its key. }
function FindLayoutKey(var Klid: String): Boolean;
var
  Names: TArrayOfString;
  I: Integer;
  Value: String;
begin
  Result := False;
  if not RegGetSubkeyNames(HKLM, LayoutsKey, Names) then Exit;
  for I := 0 to GetArrayLength(Names) - 1 do
    if RegQueryStringValue(HKLM, LayoutsKey + '\' + Names[I], 'Layout File', Value) and
       (CompareText(Value, LayoutFile) = 0) then
    begin
      Klid := Names[I];
      Result := True;
      Exit;
    end;
end;

{ Custom layouts need a KLID of the form axxx<LangId> and a "Layout Id" unique across all layouts. }
function NewKlid: String;
var
  N: Integer;
begin
  for N := 0 to $FFF do
  begin
    Result := Lowercase(Format('a%.3x', [N])) + LangId;
    if not RegKeyExists(HKLM, LayoutsKey + '\' + Result) then Exit;
  end;
  RaiseException('No free keyboard layout ID found.');
end;

function NewLayoutId: String;
var
  Names: TArrayOfString;
  Used: String;
  Value: String;
  I, N: Integer;
begin
  Used := '';
  if not RegGetSubkeyNames(HKLM, LayoutsKey, Names) then
    RaiseException('Could not read the installed keyboard layouts.');
  for I := 0 to GetArrayLength(Names) - 1 do
    if RegQueryStringValue(HKLM, LayoutsKey + '\' + Names[I], 'Layout Id', Value) then
      Used := Used + '|' + Lowercase(Value) + '|';
  for N := $C0 to $FFF do
  begin
    Result := Lowercase(Format('%.4x', [N]));
    if Pos('|' + Result + '|', Used) = 0 then Exit;
  end;
  RaiseException('No free keyboard layout ID found.');
end;

procedure WriteValue(const Key, Name, Value: String);
begin
  if not RegWriteStringValue(HKLM, Key, Name, Value) then
    RaiseException('Could not write "' + Name + '" to HKLM\' + Key + '.');
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  Klid, Key, LayoutId: String;
  IsNew: Boolean;
begin
  if CurStep <> ssPostInstall then Exit;
  IsNew := not FindLayoutKey(Klid);
  if IsNew then Klid := NewKlid;
  Key := LayoutsKey + '\' + Klid;
  try
    if not RegQueryStringValue(HKLM, Key, 'Layout Id', LayoutId) or (Length(LayoutId) <> 4) then
      WriteValue(Key, 'Layout Id', NewLayoutId);
    WriteValue(Key, 'Layout File', LayoutFile);
    WriteValue(Key, 'Layout Text', 'NorKEY v1.0');
    WriteValue(Key, 'Layout Display Name', '@%SystemRoot%\system32\' + LayoutFile + ',-1000');
  except
    { Leave an existing registration in place; only roll back one this run created. }
    if IsNew then RegDeleteKeyIncludingSubkeys(HKLM, Key);
    RaiseException('Registering the NorKEY keyboard layout failed: ' + GetExceptionMessage);
  end;
end;

function InitializeUninstall: Boolean;
begin
  Result := SuppressibleMsgBox('Before uninstalling, remove NorKEY from the keyboards in every Windows account ' +
    'that uses it (Settings > Time & language > Language & region).' + #13#10#13#10 + 'Continue uninstalling?',
    mbConfirmation, MB_YESNO, IDYES) = IDYES;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
  Klid: String;
begin
  if (CurUninstallStep = usPostUninstall) and FindLayoutKey(Klid) then
    RegDeleteKeyIncludingSubkeys(HKLM, LayoutsKey + '\' + Klid);
end;
