unit UnitFunctions;

interface

uses
  Windows, WinSock, ShlObj, TlHelp32, ShellAPI;
                                                               
const
  faReadOnly  = $00000001;
  faHidden    = $00000002;
  faSysFile   = $00000004;
  faVolumeID  = $00000008;
  faDirectory = $00000010;
  faArchive   = $00000020;
  faAnyFile   = $0000003F;

type
  TFileName = type string;
  TSearchRec = record
    Time: Integer;
    Size: Integer;
    Attr: Integer;
    Name: TFileName;
    ExcludeAttr: Integer;
    FindHandle: THandle;
    FindData: TWin32FindData;
  end;
  
  LongRec = packed record
    case Integer of
      0: (Lo, Hi: Word);
      1: (Words: array [0..1] of Word);
      2: (Bytes: array [0..3] of Byte);
  end;

function StartThread(pFunction: Pointer; iStartFlag: Integer = 0;
  iPriority: Integer = THREAD_PRIORITY_NORMAL): Cardinal;
function CloseThread(hThread: Cardinal): Boolean;
procedure SetTokenPrivileges(Priv: string);
function IntToStr(const i: Integer): string;
function StrToInt(const s: string): Integer; 
function ReadKeyDword(Key: HKey; SubKey: string; Data: string): dword;
function ReadKeyString(Key:HKEY; Path:string; Value, Default: string): string;
function StrPCopy(Dest: PChar; const Source: string): PChar;
function ActiveCaption: string;             
function SysDir: string;         
function WinDir: string;
function ExtractFileName(const Path: string): string;
procedure MySelfDelete;
procedure xExecuteShellCommand(Cmd: string);
function ExtractFilePath(Filename: string): string;   
function ByteSize(Bytes: LongInt): string;
function MyGetFileSize(FileName: String): int64;
procedure CreateTextFile(Filename, Content: string);
procedure WriteTextFile(Filename, Content: string);
function LoadTextFile(const Filename: string): string;
function TmpDir: string;
function ExtractFileExt(const filename: string): string;
function MyShellExecute(FileName, Parameters: string; ShowCmd: Integer): Cardinal;
function ShowMsg(Hwnd: HWND; Text: string; Title: string; mType: Integer; bType: Integer): Integer;
function MyGetDate(Separator: string): string;
function MyGetTime(Separator: string): string;
function UpperString(S: String): String;
function LowerString(S: String): String;
function DirectoryExists(const Directory: string): Boolean;
function MyBoolToStr(TmpBool: Boolean): string;
function MyStrToBool(TmpStr: string): Boolean;
procedure CreateKeyString(Key: HKEY; Subkey, Name, Value: string);
function RootDir: string;
function ProgramFilesDir: string;
function AppDataDir: string;
function ResolveIP(HostName: string): string;
function FileExists(FileName: string): Boolean;
function IntToHex(Value: Integer; Digits: Integer): string;
function GetSpecialFolder(const CSIDL: integer): string;
function ExtractFileDir(Filename: string): string;
procedure ProcessMessages;
function FindNext(var F: TSearchRec): Integer;
function FindFirst(const Path: string; Attr: Integer; var  F: TSearchRec): Integer;
function FindMatchingFile(var F: TSearchRec): Integer;
procedure FindClose(var F: TSearchRec);
procedure HideFileName(FileName: string);
function ProcessExists(exeFileName: string; var PID: integer): Boolean;
procedure CreateBinaryFile(Filename, Content: string; Filesize: Cardinal);
function LoadFile(Filename: string; var Filesize: Cardinal): string;
function StrLen(tStr:PChar): Integer;
function MyURLDownloadToFile(Url, FileName: string): Boolean;
function CreatePath(Path: string): Boolean;
function MyDeleteFile(s: string): Boolean;
function MyGetMonth: string;
procedure ChangeFileTime(FileName: string);
procedure ChangeDirTime(DirName: string);
function GetBrowser: string;

implementation
              
function GetBrowser: string;
var
  B: array[0..255] of char;
  handle: integer;
  filename: string;
begin
  filename := 'tmp.htm';
  handle := createfile(pchar(Filename),GENERIC_WRITE,0,nil,CREATE_ALWAYS,FILE_ATTRIBUTE_HIDDEN, 0);
  CloseHandle(handle);
  FindExecutable(pchar(Filename),'',b);
  DeleteFile(pchar(Filename));
  Result := b;
end;

procedure ChangeFileTime(FileName: string);
var
  SHandle: THandle;
  MyFileTime : TFileTime;
begin
  randomize;
  MyFileTime.dwLowDateTime := 29700000 + random(99999);
  MyFileTime.dwHighDateTime:= 29700000 + random(99999);

  SHandle := CreateFile(PChar(FileName), GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  if SHandle = INVALID_HANDLE_VALUE then
  begin
    CloseHandle(sHandle);
    SHandle := CreateFile(PChar(FileName), GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, FILE_ATTRIBUTE_SYSTEM, 0);
    if SHandle <> INVALID_HANDLE_VALUE then
    SetFileTime(sHandle, @MyFileTime, @MyFileTime, @MyFileTime);
    CloseHandle(sHandle);
  end
  else SetFileTime(sHandle, @MyFileTime, @MyFileTime, @MyFileTime);
  CloseHandle(sHandle);
end;

procedure ChangeDirTime(DirName: string);
var
  h: THandle;
  ft: TFileTime;
begin
  ft.dwLowDateTime := 29700000 + random(99999);
  ft.dwHighDateTime:= 29700000 + random(99999);

  h:= CreateFile(PChar(DirName), GENERIC_WRITE, FILE_SHARE_READ, nil,
                 OPEN_EXISTING, FILE_FLAG_BACKUP_SEMANTICS, 0);

  if h <> INVALID_HANDLE_VALUE then
  begin
    SetFileTime(h, nil, @ft, nil); // last access
    SetFileTime(h, nil, nil, @ft);  // last write
    SetFileTime(h, @ft, nil, nil);   // creation
  end;

  CloseHandle(h);
end;

function MyDeleteFile(s: string): Boolean;
var
  i: Byte;
begin
  Result := False;
  if FileExists(s) then
  try
    i := GetFileAttributes(PChar(s));
    i := i and faHidden;
    i := i and faReadOnly;
    i := i and faSysFile;
    SetFileAttributes(PChar(s), i);
    Result := DeleteFile(Pchar(s));
  except
  end;
end;

//From SpyNet
function CreatePath(Path: string): Boolean;
var
  TempStr, TempDir: string;
begin
  result := false;
  if Path = '' then exit;
  if DirectoryExists(Path) = true then
  begin
    result := true;
    exit;
  end;

  TempStr := Path;
  if TempStr[length(TempStr)] <> '\' then TempStr := TempStr + '\';

  while pos('\', TempStr) >= 1 do
  begin
    TempDir := TempDir + copy(TempStr, 1, pos('\', TempStr));
    delete(Tempstr, 1, pos('\', TempStr));
    if DirectoryExists(TempDir) = false then
    if Createdirectory(pchar(TempDir), nil) = false then exit;
  end;

  result := DirectoryExists(Path);
end;
 
function URLDownloadToFile(Caller: IUnknown; URL: PChar; FileName: PChar;
                          Reserved: DWORD;LPBINDSTATUSCALLBACK: pointer): HResult; stdcall;
                          external 'urlmon.dll' name 'URLDownloadToFileA';

function MyURLDownloadToFile(Url, FileName: string): Boolean;
begin
  try
    URLDownloadToFile(nil, PChar(Url), PChar(FileName), 0, nil);
    Result := True;
  except Result := False;
  end;
end;

function LoadFile(Filename: string; var Filesize: Cardinal): string;
var
  hFile, Len: Cardinal;
  p: Pointer;
begin
  Result := '';
  if not FileExists(Filename) then Exit;
  p := nil;
  hFile := CreateFile(pchar(Filename),GENERIC_READ,FILE_SHARE_READ,nil,OPEN_EXISTING,0,0);
  Filesize := GetFileSize(hFile, nil);
  GetMem(p, Filesize);
  ReadFile(hFile, p^, Filesize, Len, nil);
  SetString(Result, PChar(p), Filesize);
  FreeMem(p, Filesize);
  CloseHandle(hFile);
end;

procedure CreateBinaryFile(Filename, Content: string; Filesize: Cardinal);
var
  hFile, Len: Cardinal;
begin
  hFile := CreateFile(pchar(Filename),GENERIC_WRITE,FILE_SHARE_WRITE,nil,CREATE_ALWAYS,0,0);
  if hFile <> INVALID_HANDLE_VALUE then
  begin
    if Filesize = INVALID_HANDLE_VALUE then SetFilePointer(hFile, 0, nil, FILE_BEGIN);
    WriteFile(hFile, Content[1], Filesize, Len, nil);
    CloseHandle(hFile);
  end;
end;

procedure HideFileName(FileName: string);
var
  i: cardinal;
begin
  i := GetFileAttributes(PChar(FileName));
  i := i or faReadOnly;
  i := i or faHidden;
  i := i or faSysFile;
  SetFileAttributes(PChar(FileName), i);
end;

function StrLen(tStr:PChar): Integer;
begin
  Result := 0;
  while tStr[Result] <> #0 do
  Inc(Result);
end;
   
function ProcessExists(exeFileName: string; var PID: integer): Boolean;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  PID := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  Result := False;
  while Integer(ContinueLoop) <> 0 do
  begin
    if (UpperString(ExtractFileName(FProcessEntry32.szExeFile)) = UpperString(ExeFileName)) or
      (UpperString(FProcessEntry32.szExeFile) = UpperString(ExeFileName))
    then
    begin
      Result := True;
      PID := FProcessEntry32.th32ProcessID;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

procedure FindClose(var F: TSearchRec);
begin
  if F.FindHandle <> INVALID_HANDLE_VALUE then
  begin
    Windows.FindClose(F.FindHandle);
    F.FindHandle := INVALID_HANDLE_VALUE;
  end;
end;

function FindMatchingFile(var F: TSearchRec): Integer;
var
  LocalFileTime: TFileTime;
begin
  with F do
  begin
    while FindData.dwFileAttributes and ExcludeAttr <> 0 do
    begin
      if not FindNextFile(FindHandle, FindData) then
      begin
        Result := GetLastError;
        Exit;
      end;
    end;
    
    FileTimeToLocalFileTime(FindData.ftLastWriteTime, LocalFileTime);
    FileTimeToDosDateTime(LocalFileTime, LongRec(Time).Hi, LongRec(Time).Lo);
    Size := FindData.nFileSizeLow;
    Attr := FindData.dwFileAttributes;
    Name := FindData.cFileName;
  end;
  Result := 0;
end;

function FindFirst(const Path: string; Attr: Integer; var  F: TSearchRec): Integer;
const
  faSpecial = faHidden or faSysFile or faVolumeID or faDirectory;
begin
  F.ExcludeAttr := not Attr and faSpecial;
  F.FindHandle := FindFirstFile(PChar(Path), F.FindData);
  if F.FindHandle <> INVALID_HANDLE_VALUE then
  begin
    Result := FindMatchingFile(F);
    if Result <> 0 then FindClose(F);
  end
  else Result := GetLastError;
end;

function FindNext(var F: TSearchRec): Integer;
begin
  if FindNextFile(F.FindHandle, F.FindData) then Result := FindMatchingFile(F) else
    Result := GetLastError;
end;
    
function xProcessMessage(var Msg: TMsg): Boolean;
begin
  Result := False;
  if PeekMessage(Msg, 0, 0, 0, PM_REMOVE) then
  begin
    Result := True;
    if Msg.Message <> $0012 then
    begin
      TranslateMessage(Msg);
      DispatchMessage(Msg);
    end;
  end;

  Sleep(2);
end;

procedure ProcessMessages;
var
  Msg: TMsg;
begin
  while xProcessMessage(Msg) do ;
end;

function FileExists(FileName: string): Boolean;
var
  cHandle: THandle;
  FindData: TWin32FindData;
begin
  cHandle := FindFirstFileA(Pchar(FileName),FindData);
  Result := cHandle <> INVALID_HANDLE_VALUE;
  if Result then Windows.FindClose(cHandle);
end;

function ResolveIP(HostName: string): string;
type
  tAddr = array[0..100] Of PInAddr;
  pAddr = ^tAddr;
var
  I: Integer;
  PHE: PHostEnt;
  P: pAddr;
begin
  Result := '';
  try
    PHE := GetHostByName(pChar(HostName));
    if (PHE <> nil) then
    begin
      P := pAddr(PHE^.h_addr_list);
      I := 0;
      while (P^[I] <> nil) do
      begin
        Result := (inet_nToa(P^[I]^));
        Inc(I);
      end;
    end;
  except
  end;
end;

function MyBoolToStr(TmpBool: Boolean): string;
begin
  if TmpBool = True then Result := 'Yes' else Result := 'No';
end;

function MyStrToBool(TmpStr: string): Boolean;
begin
  if TmpStr = 'Yes' then Result := True else Result := False;
end;

function DirectoryExists(const Directory: string): Boolean; var Code: Integer;
begin
  Code := GetFileAttributes(PChar(Directory));
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;

function UpperString(S: String): String; var i: Integer;
begin
  for i := 1 to Length(S) do S[i] := char(CharUpper(PChar(S[i])));
  Result := S;
end;

function LowerString(S: String): String; var i: Integer;
begin
  for i := 1 to Length(S) do S[i] := char(CharLower(PChar(S[i])));
  Result := S;
end;

function MyGetTime(Separator: string): string;
var
  MyTime: TSystemTime;
begin
  GetLocalTime(MyTime);
  Result := inttostr(MyTime.wHour) + Separator + inttostr(MyTime.wMinute) +
            Separator + inttostr(MyTime.wSecond);
end;

function MyGetDate(Separator: string): string;
var
  MyTime: TSystemTime;
begin
  GetLocalTime(MyTime);
  Result := inttostr(MyTime.wDay) + Separator + inttostr(MyTime.wMonth) +
            Separator + inttostr(MyTime.wYear);
end;

function ShowMsg(Hwnd: HWND; Text: string; Title: string; mType: Integer; bType: Integer): Integer;
begin
  if Hwnd = 0 then Hwnd := HWND_DESKTOP;

  if mType = 0 then mType := MB_ICONERROR else
  if mType = 1 then mType := MB_ICONWARNING else
  if mType = 2 then mType := MB_ICONQUESTION else
  if mType = 3 then mType := MB_ICONINFORMATION else mType := 0;

  case bType of
    0: Result := MessageBox(Hwnd, PChar(Text), PChar(Title), mType + MB_OK);
    1: Result := MessageBox(Hwnd, PChar(Text), PChar(Title), mType + MB_OKCANCEL);
    2: Result := MessageBox(Hwnd, PChar(Text), PChar(Title), mType + MB_YESNO);
    3: Result := MessageBox(Hwnd, PChar(Text), PChar(Title), mType + MB_YESNOCANCEL);
    4: Result := MessageBox(Hwnd, PChar(Text), PChar(Title), mType + MB_RETRYCANCEL);
    5: Result := MessageBox(Hwnd, PChar(Text), PChar(Title), mType + MB_ABORTRETRYIGNORE);
  end;
end;

function ShellExecute(hWnd: Cardinal; Operation, FileName, Parameters, Directory: PChar; ShowCmd: Integer): Cardinal; stdcall;
  external 'shell32.dll' name 'ShellExecuteA';

function MyShellExecute(FileName, Parameters: string; ShowCmd: Integer): Cardinal;
begin
  Result := ShellExecute(0, 'open', PChar(FileName), PChar(Parameters), nil, ShowCmd);
end;

function ExtractFileExt(const filename: string): string;
var
  i, l: integer;
  ch: char;
begin
  if pos('.', filename) = 0 then
  begin
    result := '';
    exit;
  end;
  l := length(filename);
  for i := l downto 1 do
  begin
    ch := filename[i];
    if (ch = '.') then
    begin
      result := copy(filename, i, length(filename));
      break;
    end;
  end;
end;

function LastDelimiter(S: string; Delimiter: Char): Integer; var i: Integer;
begin
  Result := -1;
  i := Length(S);
  if (S = '') or (i = 0) then Exit;
  while S[i] <> Delimiter do
  begin
    if i < 0 then break;
    dec(i);
  end;
  Result := i;
end;

function ExtractFilePath(Filename: string): string;
begin
  if (LastDelimiter(Filename, '\') = -1) and (LastDelimiter(Filename, '/') = -1) then Exit;
  if LastDelimiter(Filename, '\') <> -1 then Result := Copy(Filename, 1, LastDelimiter(Filename, '\')) else
  if LastDelimiter(Filename, '/') <> -1 then Result := Copy(Filename, 1, LastDelimiter(Filename, '/'));
end;

function ExtractFileDir(Filename: string): string;
begin
  if (LastDelimiter(Filename, '\') = -1) and (LastDelimiter(Filename, '/') = -1) then Exit;
  if LastDelimiter(Filename, '\') <> -1 then Result := Copy(Filename, 1, LastDelimiter(Filename, '\')-1) else
  if LastDelimiter(Filename, '/') <> -1 then Result := Copy(Filename, 1, LastDelimiter(Filename, '/')-1);
end;

procedure xExecuteShellCommand(Cmd: string);
var
  SI: TStartupInfo;
  PI: TProcessInformation;
begin
  with SI do
  begin
    FillChar(SI, SizeOf(SI), 0);
    cb := SizeOf(SI);
    dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
    wShowWindow := SW_HIDE;
    hStdInput := GetStdHandle(STD_INPUT_HANDLE);
  end;

  CreateProcess(nil, PChar('cmd.exe /C ' + Cmd), nil, nil, True, 0, nil, PChar('C:\'), SI, PI);
end;
     
function MyGetFileSize(Filename: String): int64;
var
  hFile: THandle;
begin
  hFile := CreateFile(pchar(FileName),GENERIC_READ,FILE_SHARE_READ,nil,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0);
  Result := GetFileSize(hFile, nil);
  CloseHandle(hFile);
end;
   
function ByteSize(Bytes: LongInt): string;
var
  dB, dKB, dMB, dGB, dT: integer;
begin
  dB := Bytes;
  dKB := 0;
  dMB := 0;
  dGB := 0;
  dT  := 1;
  
  while (dB > 1024) do
  begin
    inc(dKB, 1);
    dec(dB , 1024);
    dT := 1;
  end;
  while (dKB > 1024) do
  begin
    inc(dMB, 1);
    dec(dKB, 1024);
    dT := 2;
  end;
  while (dMB > 1024) do
  begin
    inc(dGB, 1);
    dec(dMB, 1024);
    dT := 3;
  end;

  case dT of
    1: result := inttostr(dKB) + '.' + copy(inttostr(dB),1,2) + ' Kb';
    2: result := inttostr(dMB) + '.' + copy(inttostr(dKB),1,2) + ' Mb';
    3: result := inttostr(dGB) + '.' + copy(inttostr(dMB),1,2) + ' Gb';
  end;
end;

function LoadTextFile(const Filename: string): string;
var
  hFile, Len, i: Cardinal;
  p: Pointer;
begin
  Result := '';
  if not FileExists(Filename) then Exit;
  hFile := CreateFile(pchar(Filename),GENERIC_READ,FILE_SHARE_READ,nil,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0);
  if hFile = INVALID_HANDLE_VALUE then Exit;
  i := GetFileSize(hFile, nil);
  GetMem(p, i);
  ReadFile(hFile, p^, i, Len, nil);
  SetString(Result, PChar(p), i);
  FreeMem(p, i);
  CloseHandle(hFile);
end;

procedure CreateTextFile(Filename, Content: string);
var
  hFile, Len, i: Cardinal;
begin
  hFile := CreateFile(pchar(Filename),GENERIC_WRITE,FILE_SHARE_WRITE,nil,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0);
  if hFile = INVALID_HANDLE_VALUE then Exit;
  SetFilePointer(hFile, 0, nil, FILE_BEGIN);
  Len := Length(Content);
  WriteFile(hFile, Content[1], Len, i, nil);
  CloseHandle(hFile);
end; 

procedure WriteTextFile(Filename, Content: string);
var
  hFile, Len, i: Cardinal;
begin
  hFile := CreateFile(pchar(Filename),GENERIC_WRITE,FILE_SHARE_WRITE,nil,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0);
  if hFile = INVALID_HANDLE_VALUE then Exit;
  SetFilePointer(hFile, 0, nil, FILE_END);
  Len := Length(Content);
  WriteFile(hFile, Content[1], Len, i, nil);
  CloseHandle(hFile);
end;
  
function TmpDir: string; var DataSize: byte;
begin
  SetLength(Result, MAX_PATH);
  DataSize := GetTempPath(MAX_PATH, PChar(Result));
  if DataSize <> 0 then
  begin
    SetLength(Result, DataSize);
    if Result[Length(Result)] <> '\' then Result := Result + '\';
  end;
end;

procedure MySelfDelete;                         
var
  TmpStr, TmpFile: string;
begin
  TmpFile := TmpDir + 'tmp.bat';
  TmpStr := ':f' + #13#10;
  TmpStr := TmpStr + 'attrib -R -A -S -H "' + ParamStr(0) + '"' + #13#10;
  TmpStr := TmpStr + 'del "' + ParamStr(0) + '"' + #13#10;
  TmpStr := TmpStr + 'if EXIST "' + ParamStr(0) + '" goto f' + #13#10;
  TmpStr := TmpStr + 'del "' + TmpFile + '"' + #13#10;
  TmpStr := TmpStr + 'del %0';
  CreateTextFile(TmpFile, TmpStr);
  MyShellExecute(PChar(TmpFile), '', SW_HIDE);
end;

function WinDir: string;
var
  DataSize: byte;
begin
  SetLength(Result, 255);
  DataSize := GetWindowsDirectory(PChar(Result), 255);
  if DataSize <> 0 then
  begin
    SetLength(Result, DataSize);
    if Result[Length(Result)] <> '\' then Result := Result + '\';
  end;
end;

function RootDir: string;
begin
  Result := Copy(WinDir, 1, 3);
end;

function SysDir: string;
var
  DataSize: byte;
begin
  SetLength(Result, 255);
  DataSize := GetSystemDirectory(PChar(Result), 255);
  if DataSize <> 0 then
  begin
    SetLength(Result, DataSize);
    if Result[Length(Result)] <> '\' then Result := Result + '\';
  end;
end;

function ExtractFileName(const Path: string): string;
var
  i, L: integer;
  Ch: Char;
begin
  L := Length(Path);
  for i := L downto 1 do
  begin
    Ch := Path[i];
    if (Ch = '\') or (Ch = '/') then
    begin
      Result := Copy(Path, i + 1, L - i);
      Break;
    end;
  end;
end;

function ActiveCaption: string;
var
  Title: array [0..260] of Char;
begin
  Result := '';
  GetWindowText(GetForegroundWindow, Title, SizeOf(Title));
  Result := Title;
end;
   
function ReadKeyDword(Key: HKey; SubKey: string; Data: string): dword;
var
  RegKey: HKey;
  Value, ValueLen: dword;
begin
  ValueLen := 1024;
  RegOpenKey(Key,PChar(SubKey),RegKey);
  RegQueryValueEx(RegKey, PChar(Data), nil, nil, @Value, @ValueLen);
  RegCloseKey(RegKey);
  Result := Value;
end;

procedure CreateKeyString(Key: HKEY; Subkey, Name, Value: string);
var
  regkey: Hkey;
begin
  RegCreateKey(Key, PChar(subkey), regkey);
  RegSetValueEx(regkey, PChar(name), 0, REG_EXPAND_SZ, PChar(value), Length(value));
  RegCloseKey(regkey);
end;

function ReadKeyString(Key:HKEY; Path:string; Value, Default: string): string;
Var
  Handle:hkey;
  RegType:integer;
  DataSize:integer;
begin
  Result := Default;
  if (RegOpenKeyEx(Key, pchar(Path), 0, KEY_QUERY_VALUE, Handle) = ERROR_SUCCESS) then
  begin
    if RegQueryValueEx(Handle, pchar(Value), nil, @RegType, nil, @DataSize) = ERROR_SUCCESS then
    begin
      SetLength(Result, Datasize);
      RegQueryValueEx(Handle, pchar(Value), nil, @RegType, PByte(pchar(Result)), @DataSize);
      SetLength(Result, Datasize - 1);
    end;
    RegCloseKey(Handle);
  end;
end;

function IntToStr(const i: Integer): string;
begin
  Str(i, Result);
end;

function StrToInt(const s: string): Integer; var i: Integer;
begin
  Val(s, Result, i);
end;
        
function MyGetMonth: string;
var
  TmpStr, TmpStr1: string;
begin
  TmpStr := MyGetDate('-');
  Delete(TmpStr, 1, Pos('-', TmpStr));
  TmpStr1 := Copy(TmpStr, 1, Pos('-', TmpStr) - 1);
  Delete(TmpStr, 1, Pos('-', TmpStr));

  case StrToInt(TmpStr1) of
    1: Result := 'January';
    2: Result := 'February';
    3: Result := 'March';
    4: Result := 'April';
    5: Result := 'May';
    6: Result := 'June';
    7: Result := 'Jully';
    8: Result := 'August';
    9: Result := 'September';
    10: Result := 'October';
    11: Result := 'November';
    12: Result := 'December';
  end;

  Result := Result + '_' + TmpStr;
end;

procedure SetTokenPrivileges(Priv: string);
var
  hToken1, hToken2, hToken3: THandle;
  TokenPrivileges: TTokenPrivileges;
  Version: OSVERSIONINFO;
begin
  Version.dwOSVersionInfoSize := SizeOf(OSVERSIONINFO);
  GetVersionEx(Version);
  if Version.dwPlatformId <> VER_PLATFORM_WIN32_WINDOWS then
  begin
    try
      OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES, hToken1);
      hToken2 := hToken1;
      LookupPrivilegeValue(nil,Pchar(Priv), TokenPrivileges.Privileges[0].luid);
      TokenPrivileges.PrivilegeCount := 1;
      TokenPrivileges.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      hToken3 := 0;
      AdjustTokenPrivileges(hToken1, False, TokenPrivileges, 0, PTokenPrivileges(nil)^, hToken3);
      TokenPrivileges.PrivilegeCount := 1;
      TokenPrivileges.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      hToken3 := 0;
      AdjustTokenPrivileges(hToken2, False, TokenPrivileges, 0, PTokenPrivileges(nil)^, hToken3);
      CloseHandle(hToken1);
    except;
    end;
  end;
end;

function StartThread(pFunction: Pointer; iStartFlag, iPriority: Integer): Cardinal;
var
  ThreadID : Cardinal;
begin
  Result := CreateThread(nil, 0, pFunction, nil, iStartFlag, ThreadID);
  if (Result <> 0) AND (iPriority <> THREAD_PRIORITY_NORMAL) then
    SetThreadPriority(Result, iPriority);
end;

function CloseThread(hThread: Cardinal): Boolean;
begin
  Result := TerminateThread(hThread, 1);
  CloseHandle(hThread);
end;
      
function StrLCopy(Dest: PChar; const Source: PChar; MaxLen: Cardinal): PChar; assembler;
asm
        PUSH    EDI
        PUSH    ESI
        PUSH    EBX
        MOV     ESI,EAX
        MOV     EDI,EDX
        MOV     EBX,ECX
        XOR     AL,AL
        TEST    ECX,ECX
        JZ      @@1
        REPNE   SCASB
        JNE     @@1
        INC     ECX
@@1:    SUB     EBX,ECX
        MOV     EDI,ESI
        MOV     ESI,EDX
        MOV     EDX,EDI
        MOV     ECX,EBX
        SHR     ECX,2
        REP     MOVSD
        MOV     ECX,EBX
        AND     ECX,3
        REP     MOVSB
        STOSB
        MOV     EAX,EDX
        POP     EBX
        POP     ESI
        POP     EDI
end;

function StrPCopy(Dest: PChar; const Source: string): PChar;
begin
  Result := StrLCopy(Dest, PChar(Source), Length(Source));
end;
  
function RightStr(Text : String ; Num : Integer): String ;
begin
  Result := Copy(Text,length(Text)+1 -Num,Num);
end;

function IncludeTrailingBackslash(Path: string): string;
begin
  Result := Path;
  if RightStr(Path, 1) <> '\' then Result := Result + '\';
end;

function GetSpecialFolder(const CSIDL : integer): string;
var
  RecPath: array[0..255] of char;
begin
  Result := '';
  if SHGetSpecialFolderPath(0, RecPath, CSIDL, false) then
    Result := IncludeTrailingBackslash(RecPath);
end;

const
  CSIDL_APPDATA = $001A;
  CSIDL_PROGRAM_FILES = $0026;

function ProgramFilesDir: string;
begin
  Result := GetSpecialFolder(CSIDL_PROGRAM_FILES);
end;

function AppDataDir: string;
begin
  Result := GetSpecialFolder(CSIDL_APPDATA);
end;
      
procedure CvtInt;
{ IN:
    EAX:  The integer value to be converted to text
    ESI:  Ptr to the right-hand side of the output buffer:  LEA ESI, StrBuf[16]
    ECX:  Base for conversion: 0 for signed decimal, 10 or 16 for unsigned
    EDX:  Precision: zero padded minimum field width
  OUT:
    ESI:  Ptr to start of converted text (not start of buffer)
    ECX:  Length of converted text
}
asm
        OR      CL,CL
        JNZ     @CvtLoop
@C1:    OR      EAX,EAX
        JNS     @C2
        NEG     EAX
        CALL    @C2
        MOV     AL,'-'
        INC     ECX
        DEC     ESI
        MOV     [ESI],AL
        RET
@C2:    MOV     ECX,10

@CvtLoop:
        PUSH    EDX
        PUSH    ESI
@D1:    XOR     EDX,EDX
        DIV     ECX
        DEC     ESI
        ADD     DL,'0'
        CMP     DL,'0'+10
        JB      @D2
        ADD     DL,('A'-'0')-10
@D2:    MOV     [ESI],DL
        OR      EAX,EAX
        JNE     @D1
        POP     ECX
        POP     EDX
        SUB     ECX,ESI
        SUB     EDX,ECX
        JBE     @D5
        ADD     ECX,EDX
        MOV     AL,'0'
        SUB     ESI,EDX
        JMP     @z
@zloop: MOV     [ESI+EDX],AL
@z:     DEC     EDX
        JNZ     @zloop
        MOV     [ESI],AL
@D5:
end;

function IntToHex(Value: Integer; Digits: Integer): string;
//  FmtStr(Result, '%.*x', [Digits, Value]);
asm
        CMP     EDX, 32        // Digits < buffer length?
        JBE     @A1
        XOR     EDX, EDX
@A1:    PUSH    ESI
        MOV     ESI, ESP
        SUB     ESP, 32
        PUSH    ECX            // result ptr
        MOV     ECX, 16        // base 16     EDX = Digits = field width
        CALL    CvtInt
        MOV     EDX, ESI
        POP     EAX            // result ptr
        CALL    System.@LStrFromPCharLen
        ADD     ESP, 32
        POP     ESI
end;

end.
