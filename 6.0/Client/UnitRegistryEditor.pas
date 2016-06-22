unit UnitRegistryEditor;

interface

uses
  Windows, SysUtils, Registry;

function ListKeys(Clave: String): String;
function ListValues(Clave: String): String;
function AddRegValue(kPath, RegName, RegType, RegValue: String): Boolean;
function AddRegKey(kPath: string):Boolean;
function DeleteRegkey(kPath, RegName: String; DeleteKey: Boolean): Boolean;
function RenameRegistryItem(Old, New: String): boolean;

implementation

var
  rKey: HKEY;

//From SSRAT
//----
function ToKey(Clave: String):HKEY;
begin
  if Clave='HKEY_CLASSES_ROOT' then Result:=HKEY_CLASSES_ROOT else
  if Clave='HKEY_CURRENT_CONFIG' then Result:=HKEY_CURRENT_CONFIG else
  if Clave='HKEY_CURRENT_USER' then Result:=HKEY_CURRENT_USER else
  if Clave='HKEY_LOCAL_MACHINE' then Result:=HKEY_LOCAL_MACHINE else
  if Clave='HKEY_USERS' then Result:=HKEY_USERS else Result:=0;
end;

function ListValues(Clave: String): String;
var
  phkResult: HKEY;
  dwIndex, lpcbValueName,lpcbData: Cardinal;
  lpData: PChar;
  lpType: DWORD;
  lpValueName: PChar;
  strTipo, strDatos, Nombre: String;
  j, Resultado: integer;
  DValue: PDWORD;
  Temp:string;
begin
  Result := '';
  if RegOpenKeyEx(ToKey(Copy(Clave, 1, Pos('\', Clave) - 1)),PChar(Copy(Clave, Pos('\', Clave) + 1, Length(Clave))),0, KEY_QUERY_VALUE, phkResult) <> ERROR_SUCCESS then exit;
  dwIndex := 0;
  GetMem(lpValueName, 16383);
  Resultado := ERROR_SUCCESS;
  while (Resultado = ERROR_SUCCESS) do
  begin
    Resultado := RegEnumValue(phkResult, dwIndex, lpValueName, lpcbValueName, nil, @lpType, nil, @lpcbData);
    GetMem(lpData,lpcbData);
    lpcbValueName := 16383;
    Resultado := RegEnumValue(phkResult, dwIndex, lpValueName, lpcbValueName, nil, @lpType, PByte(lpData), @lpcbData);
    if Resultado = ERROR_SUCCESS then
    begin
      strDatos := '';

      if lpType = REG_DWORD  then
      begin
        DValue := PDWORD(lpData);
        strDatos := '0x'+ IntToHex(DValue^, 8) + ' (' + IntToStr(DValue^) + ')'; //0xHexValue (IntValue)
      end
      else
      if lpType = REG_BINARY then
      begin
        if lpcbData = 0 then strDatos := '(No Data)' else
          for j := 0 to lpcbData - 1 do strDatos := strDatos + IntToHex(Ord(lpData[j]), 2) + ' ';
      end
      else
      if lpType = REG_MULTI_SZ then
      begin
        for j := 0 to lpcbData - 1 do if lpData[j] = #0 then lpData[j] := ' ';
        strDatos := lpData;
      end
      else strDatos := lpData;

      if lpValueName[0] = #0 then Nombre := '(End)' else Nombre := lpValueName;

      case lpType of
        REG_BINARY: strTipo := 'REG_BINARY';
        REG_DWORD: strTipo := 'REG_DWORD';
        REG_DWORD_BIG_ENDIAN: strTipo := 'REG_DWORD_BIG_ENDIAN';
        REG_EXPAND_SZ: strTipo := 'REG_EXPAND_SZ';
        REG_LINK: strTipo := 'REG_LINK';
        REG_MULTI_SZ: strTipo := 'REG_MULTI_SZ';
        REG_NONE: strTipo := 'REG_NONE';
        REG_SZ: strTipo := 'REG_SZ';
      end;

      if strDatos = '' then strdatos := '(No Data)';
      Temp := Temp + Nombre + '|' + strTipo + '|' + strDatos + '|' + #13#10;
      Inc(dwIndex);
    end;
    FreeMem(lpData);
  end;
  If Temp <> '' then Result := Temp;
  FreeMem(lpValueName);
  RegCloseKey(phkResult);
end;

function ListKeys(Clave: String): String;
var
  phkResult: HKEY;
  lpName: PChar;
  lpcbName, dwIndex: Cardinal;
  lpftLastWriteTime: FileTime;
  Temp:string;
begin
  Temp := '';
  RegOpenKeyEx(ToKey(Copy(Clave, 1, Pos('\', Clave) - 1)),PChar(Copy(Clave, Pos('\', Clave) + 1, Length(Clave))), 0,KEY_ENUMERATE_SUB_KEYS,phkResult);
  lpcbName := 255;
  GetMem(lpName, lpcbName);
  dwIndex := 0;
  while RegEnumKeyEx(phkResult, dwIndex, @lpName[0] , lpcbName, nil, nil, nil, @lpftLastWriteTime) = ERROR_SUCCESS do
  begin
    temp := temp + lpName + '|';
    Inc(dwIndex);
    lpcbName := 255;
  end;
  Result := temp;
  RegCloseKey(phkResult);
end;
//-----

function StrToKeyType(sKey: wideString): integer;
begin
  if sKey = 'REG_DWORD' then Result := REG_DWORD;
  if sKey = 'REG_BINARY' then Result := REG_BINARY;
  if sKey = 'REG_EXPAND_SZ' then Result := REG_EXPAND_SZ;
  if sKey = 'REG_MULTI_SZ' then Result := REG_MULTI_SZ;
  if sKey = 'REG_SZ' then Result := REG_SZ;
end;

function AddRegValue(kPath, RegName, RegType, RegValue: String):Boolean;
var
  RegKey: string;
begin
  RegKey := Copy(kPath, 1, Pos('\', kPath)-1);
  Delete(kPath, 1, Pos('\', kPath));
  RegCreateKey(ToKey(RegKey), PChar(kPath), rKey);
  Result := RegSetValueEx(rKey, PChar(string(RegName)), 0, StrToKeyType(RegType), PChar(RegValue), Length(PChar(RegValue))) = 0;
  RegCloseKey(rKey);
end;

function AddRegKey(kPath: string):Boolean;
var
  RegKey, KeyName: string;
begin
  RegKey := Copy(kPath, 1, Pos('\', kPath)-1);
  Delete(kPath, 1, Pos('\', kPath));

  KeyName := Copy(kPath, LastDelimiter('\', kPath)+1, Length(kPath));
  Delete(kPath, LastDelimiter('\', kPath), Length(kPath));

  RegOpenKeyEx(ToKey(RegKey), PChar(kPath), 0, KEY_CREATE_SUB_KEY, rKey);
  Result := RegCreateKey(rKey, PChar(KeyName), rKey) = 0;
  RegCloseKey(rKey);
end;

function Removekey(const hRootKey: HKey; const strKey, strName: String; bolKeyValue: Boolean): Boolean;
begin
  with TRegistry.Create do
  try
    RootKey := hRootKey;
    OpenKey(strKey, True);
    if bolKeyValue then if DeleteValue(strName) then Result := True else Result := False else
    if DeleteKey(strName) then Result := True else Result := False;
  finally
    CloseKey;
    Free;
  end;
end;

function DeleteRegkey(kPath, RegName: String; DeleteKey: Boolean):boolean;
var
  RegKey: string;
begin
  RegKey := Copy(kPath, 1, Pos('\', kPath)-1);
  Delete(kPath, 1, Pos('\', kPath));
  Result := Removekey(ToKey(RegKey), kPath, RegName, DeleteKey);
end;
     
function AllocMem(Size: Cardinal): Pointer;
begin
  GetMem(Result, Size);
  FillChar(Result^, Size, 0);
end;

function CopyRegistryKey(Source, Dest: HKEY): boolean;
const
  DefValueSize  = 512;
  DefBufferSize = 8192;
var
  Status      : Integer;
  Key         : Integer;
  ValueSize,
  BufferSize  : Cardinal;
  KeyType     : Integer;
  ValueName   : String;
  Buffer      : Pointer;
  NewTo, NewFrom     : HKEY;
begin
  result := false;
  SetLength(ValueName,DefValueSize);
  Buffer := AllocMem(DefBufferSize);
  try
    Key := 0;
    repeat
      ValueSize := DefValueSize;
      BufferSize := DefBufferSize;
      Status := RegEnumValue(Source,Key,PChar(ValueName),ValueSize,nil,@KeyType,Buffer,@BufferSize);
      if Status = ERROR_SUCCESS then
      begin
        Status := RegSetValueEx(Dest,PChar(ValueName),0,KeyType,Buffer,BufferSize);
        RegDeleteValue(Source,PChar(ValueName));
      end;
    until Status <> ERROR_SUCCESS;

    Key := 0;
    repeat
      ValueSize := DefValueSize;
      BufferSize := DefBufferSize;
      Status := RegEnumKeyEx(Source,Key,PChar(ValueName),ValueSize,nil,Buffer,@BufferSize,nil);
      if Status = ERROR_SUCCESS then
      begin
        Status := RegCreateKey(Dest,PChar(ValueName),NewTo);
        if Status = ERROR_SUCCESS then
        begin
          Status := RegCreateKey(Source,PChar(ValueName),NewFrom);
          if Status = ERROR_SUCCESS then
          begin
            CopyRegistryKey(NewFrom,NewTo);
            RegCloseKey(NewFrom);
            RegDeleteKey(Source,PChar(ValueName));
          end;
          RegCloseKey(NewTo);
        end;
      end;
    until Status <> ERROR_SUCCESS;
  finally
    FreeMem(Buffer);
  end;
end;

function RegKeyExists(const RootKey: HKEY; Key: String): Boolean;
var
  Handle : HKEY;
begin
  if RegOpenKeyEx(RootKey, PChar(Key), 0, KEY_ENUMERATE_SUB_KEYS, Handle) = ERROR_SUCCESS then
  begin
    Result := True;
    RegCloseKey(Handle);
  end
  else Result := False;
end;

procedure RenRegItem(AKey: HKEY; Old, New: String);
var
  OldKey,
  NewKey  : HKEY;
  Status  : Integer;
begin
  Status := RegOpenKey(AKey,PChar(Old),OldKey);
  if Status = ERROR_SUCCESS then
  begin
    Status := RegCreateKey(AKey,PChar(New),NewKey);
    if Status = ERROR_SUCCESS then CopyRegistryKey(OldKey,NewKey);
    RegCloseKey(OldKey);
    RegCloseKey(NewKey);
    RegDeleteKey(AKey,PChar(Old));
  end;
end;

function RenameRegistryItem(Old, New: String): boolean;
var
  AKey  : HKEY;
  ClaveBase: string;
begin
  ClaveBase := Copy(Old, 1, Pos('\', Old) - 1);
  AKey := ToKey(ClaveBase);
  delete(new, 1, pos('\', new));
  delete(Old, 1, pos('\', Old));
  if RegKeyExists(AKey, New) = true then
  begin
    result := false;
    exit;
  end;
  RenRegItem(AKey, old, new);
  if RegKeyExists(AKey, old) = true then
  begin
    result := false;
    exit;
  end;
  result := RegKeyExists(AKey, new);
end;

end.





