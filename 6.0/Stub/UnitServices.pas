unit UnitServices;

interface

uses
  Windows, WinSvc, UnitFunctions, SysUtils;

function InstallService(ServiceName, DisplayName, FileName, Desc: string;
  StartType: integer): Boolean;

implementation
          
function xStartService(ServiceName: string): Boolean;
var
  SCManager: SC_Handle;
  Service: SC_Handle;
  ARgs: pchar;
begin
  Result := False;
  SetTokenPrivileges('SeDebugPrivilege');
  SCManager := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
  try
    Service := OpenService(SCManager, PChar(ServiceName), SERVICE_ALL_ACCESS);
    Args := nil;
    Result := winsvc.StartService(Service, 0, ARgs);
  finally
    CloseServiceHandle(SCManager);
  end;
end;

function EditService(ServiceName, DisplayName, FileName, Desc: string;
  StartType: Integer): Boolean;
var
  SCManager: SC_Handle;
  Service: SC_Handle;
begin
  Result := false;
  if (Trim(ServiceName) = '') and not FileExists(PChar(Filename)) then Exit;

  SetTokenPrivileges('SeDebugPrivilege');
  SCManager := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
  if SCManager = 0 then Exit;
  try
    Service := OpenService(SCManager,PChar(ServiceName),SERVICE_CHANGE_CONFIG);
    Result := ChangeServiceConfig(Service, SERVICE_NO_CHANGE, StartType,
       SERVICE_NO_CHANGE,PChar(FileName), nil, nil, nil, nil, nil, PChar(DisplayName));
    if Result = True then
    CreateKeyString(HKEY_LOCAL_MACHINE,
                    'SYSTEM\CurrentControlSet\Services\' + ServiceName,
                    'Description', Desc);
  finally
    CloseServiceHandle(SCManager);
  end;
end;

function InstallService(ServiceName, DisplayName, FileName, Desc: string;
  StartType: integer): Boolean;
var
  SCManager: SC_Handle;
begin
  Result := false;
  if (Trim(ServiceName) = '') and not FileExists(PChar(Filename)) then Exit;

  SetTokenPrivileges('SeDebugPrivilege');
  SCManager := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
  if SCManager = 0 then Exit;
  try
    Result := CreateService(SCManager, PChar(ServiceName), PChar(DisplayName),
      SERVICE_ALL_ACCESS, SERVICE_WIN32_OWN_PROCESS, STartType, SERVICE_ERROR_IGNORE, PChar(FileName), nil, nil, nil, nil, nil) <> 0;
    if Result = True then
    Result := EditService(ServiceName, DisplayName, FileName, Desc, StartType);
    if Result = True then xStartService(ServiceName);
  finally
    CloseServiceHandle(SCManager);
  end;
end;

end.
