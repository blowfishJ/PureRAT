unit UnitFunctions;

interface

uses
  Windows, SysUtils, StrUtils, ShellAPI;

function JustL(S: string; Size: integer) : string;
function MyBoolToStr(TmpBool: Boolean): string;
function MyStrToBool(TmpStr: string): Boolean;
function FileSizeToStr(Bytes: LongInt): string;
function FileIconInit(FullInit: BOOL): BOOL; stdcall;
function GetImageIndex(FileName: string): integer;
procedure SetClipboardText(Const S: widestring);
function TmpDir: string;
function ReadKeyString(Key:HKEY; Path:string; Value, Default: string): string;
procedure CreateKeyString(Key: HKEY; Subkey, Name, Value: string);
function MyGetFileSize(Filename: String): Int64;
function MyGetTime(Separator: string): string;
function MyGetDate(Separator: string): string;
procedure CreateTextFile(Filename, Content: string);
procedure WriteTextFile(Filename, Content: string);
function LoadTextFile(Filename: string): string;
function FileToStr(sPath: string; var sFile: string): Boolean;
function WriteResData(sServerFile: string; pFile: pointer; Size: Integer; Name: String): Boolean;

implementation
      
//P0ke
function WriteResData(sServerFile: string; pFile: pointer; Size: Integer; Name: String): Boolean;
var
  hResourceHandle: THandle;
  pwServerFile: PWideChar;
  pwName: PWideChar;
begin
  GetMem(pwServerFile, (Length(sServerFile) + 1) *2);
  GetMem(pwName, (Length(Name) + 1) *2);
  try
    StringToWideChar(sServerFile, pwServerFile, Length(sServerFile) * 2);
    StringToWideChar(Name, pwName, Length(Name) * 2);
    hResourceHandle := BeginUpdateResourceW(pwServerFile, False);
    Result := UpdateResourceW(hResourceHandle, MakeIntResourceW(10), pwName, 0, pFile, Size);
    EndUpdateResourceW(hResourceHandle, False);
  finally
    FreeMem(pwServerFile);
    FreeMem(pwName);
  end;
end;
     
//steve10120
function FileToStr(sPath: string; var sFile: string): Boolean;
var
  hFile:    THandle;
  dSize:    DWORD;
  dRead:    DWORD;
begin
  Result := FALSE;
  hFile := CreateFile(PChar(sPath), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
  if hFile <> 0 then
  begin
    dSize := GetFileSize(hFile, nil);
    if dSize <> 0 then
    begin
      SetFilePointer(hFile, 0, nil, FILE_BEGIN);
      SetLength(sFile, dSize);
      if ReadFile(hFile, sFile[1], dSize, dRead, nil) then Result := TRUE;
      CloseHandle(hFile);
    end;
  end;
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

function LoadTextFile(Filename: string): string;
var
  hFile, Len, i: Cardinal;
  p: Pointer;
begin
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

function MyGetFileSize(Filename: string): Int64;
var hFile: THandle;
begin
  hFile := CreateFile(pchar(FileName), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL,0);
  Result := GetFileSize(hFile, nil);
  CloseHandle(hFile);
end;

procedure CreateKeyString(Key: HKEY; Subkey, Name, Value: string);
var regkey: Hkey;
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

function TmpDir: string;
var
  DataSize: byte;
begin
  SetLength(Result, MAX_PATH);
  DataSize := GetTempPath(MAX_PATH, PChar(Result));
  if DataSize <> 0 then
  begin
    SetLength(Result, DataSize);
    if Result[Length(Result)] <> '\' then Result := Result + '\';
  end;
end;

procedure SetClipboardText(Const S: widestring);
var
  Data: THandle;
  DataPtr: Pointer;
  Size: integer;
begin
  Size := length(S);
  OpenClipboard(0);
  try
    Data := GlobalAlloc(GMEM_MOVEABLE + GMEM_DDESHARE, (Size * 2) + 2);
    try
      DataPtr := GlobalLock(Data);
      try
        Move(S[1], DataPtr^, Size * 2);
        SetClipboardData(CF_UNICODETEXT{CF_TEXT}, Data);
      finally
        GlobalUnlock(Data);
      end;
    except
      GlobalFree(Data);
      raise;
    end;
  finally
    CloseClipboard;
  end;
end;

function GetImageIndex(FileName: string): integer;
var
  SHFileInfo: TSHFileInfo;
begin
  result := - 1;
  try
    SHGetFileInfo(PChar(FileName), FILE_ATTRIBUTE_NORMAL, SHFileInfo,
      SizeOf(SHFileInfo), SHGFI_SMALLICON or SHGFI_USEFILEATTRIBUTES or SHGFI_SYSICONINDEX);
    Result := SHFileInfo.iIcon;
  finally
    if Result <= 0 then result := - 1;
  end;
end;

function FileIconInit(FullInit: BOOL): BOOL; stdcall;
type
  TFileIconInit = function(FullInit: BOOL): BOOL; stdcall;
var
  PFileIconInit: TFileIconInit;
  ShellDLL: integer;
begin
  //this forces winNT to load all the icons

  Result := False;
  if (Win32Platform = VER_PLATFORM_WIN32_NT) then
  begin
    ShellDLL := LoadLibrary('Shell32.dll');
    PFileIconInit := GetProcAddress(ShellDLL, PChar(660));
    if (Assigned(PFileIconInit)) then Result := PFileIconInit(FullInit);
  end;
end;

function JustL(S: string; Size: integer) : string;
var
  i : integer;
begin
  i := Size - Length(S);
  if i > 0 then S := S + DupeString('.', i);
  JustL := S;
end;
      
function MyBoolToStr(TmpBool: Boolean): string;
begin
  if TmpBool = True then Result := 'Yes' else Result := 'No';
end;

function MyStrToBool(TmpStr: string): Boolean;
begin
  if TmpStr = 'Yes' then Result := True else Result := False;
end;
    
function FileSizeToStr(Bytes: LongInt): string;
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
    1: result := inttostr(dKB) + '.' + copy(inttostr(dB ),1,2) + ' Kb';
    2: result := inttostr(dMB) + '.' + copy(inttostr(dKB),1,2) + ' Mb';
    3: result := inttostr(dGB) + '.' + copy(inttostr(dMB),1,2) + ' Gb';
  end;
end;

end.
