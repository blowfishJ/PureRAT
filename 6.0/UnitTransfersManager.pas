unit UnitTransfersManager;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, Menus, ComCtrls, ListViewEx, UnitConnection, IdTCPServer,
  UnitProgressBar, ShellAPI, UnitMain, IniFiles;

type
  TFormTransfersManager = class(TForm)
    lvTransfers: TListViewEx;
    pm1: TPopupMenu;
    C1: TMenuItem;
    R1: TMenuItem;
    N1: TMenuItem;
    E1: TMenuItem;
    O1: TMenuItem;
    il1: TImageList;
    R2: TMenuItem;
    procedure lvTransfersContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure R2Click(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure R1Click(Sender: TObject);
    procedure lvTransfersEndColumnResize(sender: TCustomListView;
      columnIndex, columnWidth: Integer);
    procedure E1Click(Sender: TObject);
    procedure O1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams) ; override;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TCallbackProcedure = procedure(Sender: Tobject) of object;

  TTransfersManager = class(TObject)
  private
    Item: TListItem;
    ListView: TListViewEx;
    ProgressBar2: TProgressBar;
    Tickbefore, Ticknow: Extended;
    i: Int64;
    Status: string;
    TmpForm: TFormProgressBar;
    Speed: Extended;
    procedure InitTransfer;
    procedure UpdateTransfer;
    procedure UpdateSpeed;            
    function TimeLeft: string;
  public
    Athread: TIdPeerThread;
    Filesize: Int64;
    Filename, Destination: string;
    FileDownload: Boolean;
    Recv: Int64;
    Callback: TCallbackProcedure;
    Transfering, Cancelled, Terminated: Boolean;
    Client: PConnectionDatas;
    ProgressBar: TProgressBar;
    constructor Create(xAthread: TIdPeerThread; xFilename: string; xFilesize: Integer;
      xDestination: string; xFileDownload: Boolean; xClient: PConnectionDatas);
    procedure DownloadFile;
    procedure UploadFile;
    procedure ResumeTransfer;
    procedure CancelTransfer;
  end;

var
  FormTransfersManager: TFormTransfersManager;

implementation

uses
  UnitConstants, UnitFunctions, UnitRepository;

{$R *.dfm}

constructor TTransfersManager.Create(xAthread: TIdPeerThread; xFilename: string; xFilesize: Integer;
      xDestination: string; xFileDownload: Boolean; xClient: PConnectionDatas);
begin
  Athread := xAthread;
  Filename := xFilename;
  Filesize := xFilesize;
  ListView := FormTransfersManager.lvTransfers;
  Destination := xDestination;
  FileDownload := xFileDownload;
  Client := xClient;
  Transfering := False;
  Cancelled := False;
  Terminated := False;
  ProgressBar := TProgressBar.Create(nil);
  ProgressBar.Max := xFilesize;
  if Athread <> nil then AThread.Synchronize(Self.InitTransfer) else Self.InitTransfer;
end;
  
procedure TTransfersManager.InitTransfer;
var
  rect: TRect;
begin
  Item := ListView.Items.Add;
  Item.Caption := Filename;         
  Item.SubItems.Add('');
  Item.SubItems.Add(FileSizeToStr(Self.Filesize));
  Item.SubItems.Add('-');
  Item.SubItems.Add('0 Kb/s');
  Item.SubItems.Add('Waiting...');
  Item.SubItems.Add(Client.Identification);

  Item.Data := Self;
  Item.SubItems.Objects[0] := ProgressBar;

  rect := Item.DisplayRect(drBounds);
  rect.Left := rect.Left + ListView.Columns[0].Width;
  rect.Right := rect.Left + ListView.Columns[1].Width;

  ProgressBar.BoundsRect := rect;
  ProgressBar.Parent := ListView;

  TmpForm := TFormProgressBar.Create(nil, Client);
  TmpForm.Caption := ExtractFileName(Filename);
  ProgressBar2 := TmpForm.pb1;
  ProgressBar2.Max := Self.Filesize;
  TmpForm.Show;
end;

procedure TTransfersManager.CancelTransfer;
begin
  Cancelled := True;
  Terminated := False;
  Transfering := False;

  Item.ImageIndex := 2;
  Status := 'Cancelled';
end;

procedure TTransfersManager.UpdateSpeed;
begin
  Speed := (Recv - i)/((Ticknow - Tickbefore)/1000);
  Item.SubItems[2] := TimeLeft;
  Item.SubItems[3] := FileSizeToStr(Round(Speed)) + '/s';
end;

procedure TTransfersManager.UpdateTransfer;
begin
  ProgressBar.Position := Self.Recv;
  ProgressBar2.Position := Self.Recv;
  
  if Item.SubItems[4] <> Status then Item.SubItems[4] := Status;
  Item.SubItems[1] := FileSizeToStr(Self.Filesize);
end;

function TTransfersManager.TimeLeft: string;
var
  dDay, dHour, dMin,
  dSec, dTmp, dTmp2 :Integer;
begin
  Result := '-';

  if (Speed = 0) or (Recv = 0) then Exit;
  dDay := 0; dHour := 0; dMin := 0;
  dTmp2 := 0; dTmp := 0;

  while dTmp2 <= (Self.Filesize - Recv) do
  begin
    Inc(dTmp2, Round(Speed));
    Inc(dTmp, 1);
  end;

  dSec := dTmp;
  if dSec > 60 then
  repeat
    Dec(dSec, 60);
    Inc(dMin, 1);
  until dSec < 60;

  if dMin > 60 then
  repeat
    Dec(dMin, 60);
    Inc(dHour, 1);
  until dMin < 60;

  if dHour > 24 then
  repeat
    Dec(dHour, 24);
    Inc(dDay, 1);
  until dHour < 24;

  Result := IntToStr(dDay) + 'd '+ IntToStr(dHour) + 'h '+ IntToStr(dMin) + 'm '+ IntToStr(dSec) + 's';
end;

procedure TTransfersManager.DownloadFile;
var
  Buffer: array[0..32768] of Byte;
  F: file;
  iRecv, sRecv, j: Integer;
  TmpStr: string;
begin
  Transfering := True;
  Status := 'Downloading...';
  Item.ImageIndex := 0;

  AssignFile(F, Destination);
  Rewrite(F, 1);
  iRecv := 0;
  sRecv := 0;
  Ticknow := GetTickCount;
  Tickbefore := GettickCount;
  i := 0;
  j := SizeOf(Buffer);

  try
    while (iRecv<Filesize) and (Athread.Connection.Connected = True) and (not Cancelled) do
    begin
      if (Filesize - iRecv) >= j then sRecv := j else sRecv := (Filesize - iRecv);
      Athread.Connection.ReadBuffer(Buffer, sRecv);
      iRecv := iRecv + sRecv;
      Ticknow := GetTickCount;
      if (Ticknow - Tickbefore >= 1000) then
      begin
        Athread.Synchronize(UpdateSpeed);
        Tickbefore := Ticknow;
        i := Recv;
      end;

      SetLength(TmpStr, sRecv);
      CopyMemory(@Tmpstr[1], @Buffer, sRecv);
      BlockWrite(F, Tmpstr[1], sRecv);
      sRecv := 0;
      Recv := iRecv;
      Athread.Synchronize(UpdateTransfer);
    end;
  finally
    CloseFile(F);
    Athread.Connection.Disconnect;
    Transfering := False;
    if iRecv <> Filesize then
    begin
      Cancelled := True;
      Transfering := False;
      TmpForm.Close;
    end
    else
    begin
      Status := 'Downloaded';
      Terminated := True;
      Transfering := False;
      Item.ImageIndex := 3;
      TmpForm.Close; 
    end;
    Athread.Synchronize(UpdateTransfer);
    if @Callback <> nil then Callback(Self);
  end;

  ListView.Refresh;
end;
        
procedure TTransfersManager.ResumeTransfer;
var
  Buffer: array[0..32768] of Byte;
  F: file;
  iRecv, sRecv, j: Integer;
  TmpStr: string;
begin
  Transfering := True; 
  Cancelled := False;
  Status := 'Downloading...';
  Item.ImageIndex := 0;

  if FileExists(Destination) then
  begin
    AssignFile(F, Destination);
    Reset(F, 1);
  end
  else
  begin
    AssignFile(F, Destination);
    Rewrite(F, 1);
  end;

  Seek(F, Recv);
  iRecv := Recv;
  sRecv := 0;
  Ticknow := GetTickCount;
  Tickbefore := GetTickCount;
  i := 0;
  j := SizeOf(Buffer);
  
  try
    while (iRecv < Filesize) and (Athread.Connection.Connected = True) and (not Cancelled) do
    begin
      if (Filesize - iRecv) >= j then sRecv := j else sRecv := (Filesize - iRecv);
      Athread.Connection.ReadBuffer(Buffer, sRecv);
      iRecv := iRecv + sRecv;
      Ticknow := GetTickCount;
      if (Ticknow - Tickbefore >= 1000) then
      begin
        Athread.Synchronize(UpdateSpeed);
        Tickbefore := Ticknow;
        i := Recv;
      end;

      SetLength(TmpStr, sRecv);
      CopyMemory(@Tmpstr[1], @Buffer, sRecv);
      BlockWrite(F, Tmpstr[1], sRecv);
      sRecv := 0;
      Recv := iRecv;
      Athread.Synchronize(UpdateTransfer);
    end;
  finally
    CloseFile(F);
    Athread.Connection.Disconnect;
    Transfering := False;
    if iRecv <> Filesize then
    begin
      Cancelled := True;
      Transfering := False;
    end
    else
    begin
      Status := 'Downloaded';
      Terminated := True;
      Transfering := False;
      Item.ImageIndex := 3;
    end;
    Athread.Synchronize(UpdateTransfer);     
    if @Callback <> nil then Callback(Self);
  end;

  ListView.Refresh;
end;
     
procedure TTransfersManager.UploadFile;
var
  Buffer: array[0..32767] of Byte;
  F: file;
  Count, Sent, j: Integer;
  TmpStr: string;
begin
  Transfering := True;
  Cancelled := False;
  Status := 'Uploading...';
  Item.ImageIndex := 1;   

  try
    FileMode := $0000;
    AssignFile(F, Filename);
    Reset(F, 1);
    Sent := 0;
    i := 0;
    Tickbefore := GetTickCount;

    while not EOF(F) and Athread.Connection.Connected and not Cancelled do
    begin
      Sleep(1);

      BlockRead(F, Buffer, 32768, Count);
      SetLength(TmpStr, Count);
      CopyMemory(@TmpStr[1], @Buffer, Count);
      Sent := Sent + AThread.Connection.Socket.Send(TmpStr[1], Count);

      Ticknow := GetTickCount;
      if (Ticknow - Tickbefore >= 1000) then
      begin
        Athread.Synchronize(UpdateSpeed);
        Tickbefore := Ticknow;
        i := Recv;
      end;
      Recv := Sent;
      Athread.Synchronize(UpdateTransfer);
    end;
  finally
    CloseFile(F);
    Transfering := False;

    if Sent <> Filesize then
    begin
      Cancelled := True;
      Transfering := False;
      TmpForm.Close;
    end
    else
    begin
      Status := 'Uploaded';
      Terminated := True;
      Transfering := False;
      Item.ImageIndex := 3; 
      TmpForm.Close;
    end;

    Athread.Synchronize(UpdateTransfer);
  end;

  ListView.Refresh;
end;

procedure TFormTransfersManager.CreateParams(var Params: TCreateParams) ;
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := 0;
end;

procedure TFormTransfersManager.lvTransfersContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  i: Integer;
begin
  if not Assigned(lvTransfers.Selected) then
    for i := 0 to pm1.Items.Count - 1 do pm1.Items[i].Enabled := False
  else for i := 0 to pm1.Items.Count - 1 do pm1.Items[i].Enabled := True;
end;
      
procedure TFormTransfersManager.lvTransfersEndColumnResize(
  sender: TCustomListView; columnIndex, columnWidth: Integer);
var
  lv : TListViewEx;
  idx : integer;
  pb : TProgressBar;
begin
  lv := lvTransfers;

  //first column
  if columnIndex = 0 then
  begin
    for idx := 0 to -1 + lv.Items.Count do
    begin
      // o objeto zero foi porque eu salvei o progressbar na unittransfer como zero
      pb := TProgressBar(lv.Items[idx].SubItems.Objects[0]);
      pb.Left := columnWidth;
    end;
  end;

  //progress bar column
  if columnIndex = 1 then
  begin
    for idx := 0 to -1 + lv.Items.Count do
    begin
      pb := TProgressBar(lv.Items[idx].SubItems.Objects[0]);
      pb.Width := columnWidth;
    end;
  end;
end;

procedure TFormTransfersManager.R2Click(Sender: TObject);
var
  FileTransfer: TTransfersManager;
begin
  FileTransfer := TTransfersManager(lvTransfers.Selected.Data);
  if FileTransfer.Status <> 'Cancelled' then Exit;

  if FileTransfer.Recv = 0 then
    SendDatas(FileTransfer.Client.AThread, FILESRESUMEDOWNLOAD + '|' +
              FileTransfer.Filename + '|0|')
  else SendDatas(FileTransfer.Client.AThread, FILESRESUMEDOWNLOAD + '|' +
                FileTransfer.Filename + '|' + IntToStr(FileTransfer.Recv) + '|');
end;

procedure TFormTransfersManager.C1Click(Sender: TObject);
var
  FileTransfer: TTransfersManager;
begin
  FileTransfer := TTransfersManager(lvTransfers.Selected.Data);
  if (FileTransfer.Status = 'Cancelled') or (FileTransfer.Status = 'Downloaded') or
    (FileTransfer.Status = 'Uploaded')
  then Exit;

  FileTransfer.CancelTransfer;
end;

procedure TFormTransfersManager.R1Click(Sender: TObject);
var
  FileTransfer: TTransfersManager;
  i, j: Integer;
begin
  for i := 0 to lvTransfers.Items.Count - 1 do
  begin
    FileTransfer := TTransfersManager(lvTransfers.Items.Item[i].Data);
    if FileTransfer.Terminated then
    begin
      FileTransfer.ProgressBar.Free;
      lvTransfers.Items[i].Delete;
      for j := i to lvTransfers.Items.Count-1 do
      begin
        if lvTransfers.Items.Item[j].Data <> nil then
        begin
          FileTransfer := TTransfersManager(lvTransfers.Items.Item[j].Data);
          FileTransfer.ProgressBar.Top := FileTransfer.ProgressBar.Top -
                                          (FileTransfer.ProgressBar.BoundsRect.Bottom -
                                          FileTransfer.ProgressBar.BoundsRect.Top);
        end;
      end;
    end;
  end;
end;

procedure TFormTransfersManager.E1Click(Sender: TObject);
var
  TmpStr: string;
begin
  TmpStr := GetDownloadsFolder(lvTransfers.Selected.SubItems[5]);
  TmpStr := TmpStr + '\' + ExtractFileName(lvTransfers.Selected.Caption);
  if FileExists(TmpStr) = False then Exit;
  ShellExecute(Handle, 'open', PChar(TmpStr), nil, nil, SW_SHOWNORMAL);
end;

procedure TFormTransfersManager.O1Click(Sender: TObject);
var
  TmpStr: string;
begin
  TmpStr := GetDownloadsFolder(lvTransfers.Selected.SubItems[5]);
  ShellExecute(Handle, 'open', PChar(TmpStr), nil, nil, SW_SHOWNORMAL);
end;

procedure TFormTransfersManager.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  TmpStr: string;
  IniFile: TIniFile;
begin
  TmpStr := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
  IniFile := TIniFile.Create(TmpStr);
  IniFile.WriteInteger('Files transfer', 'Height', Height);
  IniFile.WriteInteger('Files transfer', 'Left', Left);
  IniFile.WriteInteger('Files transfer', 'Top', Top);
  IniFile.WriteInteger('Files transfer', 'Width', Width);
  IniFile.Free;
end;

procedure TFormTransfersManager.FormCreate(Sender: TObject);
var
  TmpStr: string;
  IniFile: TIniFile;
begin
  TmpStr := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
  IniFile := TIniFile.Create(TmpStr);
  Height := IniFile.ReadInteger('Files transfer', 'Height', 360);
  Left := IniFile.ReadInteger('Files transfer', 'Left', 195);
  Top := IniFile.ReadInteger('Files transfer', 'Top', 136);
  Width := IniFile.ReadInteger('Files transfer', 'Width', 760);
  IniFile.Free;
end;

end.
