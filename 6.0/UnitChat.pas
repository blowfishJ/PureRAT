unit UnitChat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitConnection, IniFiles, StdCtrls, ExtCtrls, ComCtrls, IdTCPServer;

type
  TFormChat = class(TForm)
    redt1: TRichEdit;
    pnl1: TPanel;
    edt1: TEdit;
    btn1: TButton;
    dlgSave1: TSaveDialog;
    procedure edt1KeyPress(Sender: TObject; var Key: Char);
    procedure btn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  protected
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
  FormChat: TFormChat;

implementation

uses
  UnitConstants, UnitFunctions, UnitRepository;

{$R *.dfm}
        
constructor TFormChat.Create(aOwner: TComponent; ConnDatas: PConnectionDatas);
begin
  inherited Create(aOwner);
  Client := ConnDatas;
end;

procedure TFormChat.CreateParams(var Params: TCreateParams) ;
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := 0;
end;

procedure TFormChat.OnRead(AThread: TIdPeerThread; ReceivedDatas: string);
begin
  redt1.Lines.Add('[' + TimeToStr(Time) + '] ' + Client.Identification + ': ' + ReceivedDatas);
  redt1.SelStart := Length(redt1.Text);
  SendMessage(redt1.Handle, EM_SCROLLCARET, 0, 0);
end;

procedure TFormChat.edt1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Char(VK_RETURN) then
  begin
    redt1.Lines.Add('[' + TimeToStr(Time) + '] You: ' + edt1.Text);
    redt1.SelStart := Length(redt1.Text);
    SendMessage(redt1.Handle, EM_SCROLLCARET, 0, 0);
    SendDatas(Client.AThread, CHATTEXT + '|' + edt1.Text);
    edt1.Text := '';
  end;
end;

procedure TFormChat.btn1Click(Sender: TObject);
var
  TmpStr: string;
begin
  TmpStr := GetUserFolder(Client.Identification);
  dlgSave1.Title := PROGRAMNAME + ' ' + PROGRAMVERSION;
  dlgSave1.InitialDir := TmpStr;
  dlgSave1.FileName := 'ChatSession_' + MyGetDate('') + '.txt';
  dlgSave1.Filter := '(*.txt)|*.txt';
  dlgSave1.DefaultExt := 'txt';
  if (not dlgSave1.Execute) and (not FileExists(dlgSave1.FileName)) then Exit;
  CreateTextFile(dlgSave1.FileName, redt1.Text);
end;

procedure TFormChat.FormClose(Sender: TObject; var Action: TCloseAction);
var
  IniFile: TIniFile;
  TmpStr: string;
begin
  SendDatas(Client.AThread, CHATSTOP + '|');
  
  TmpStr := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
  IniFile := TIniFile.Create(TmpStr);
  IniFile.WriteInteger('Chat', 'Left', Left);
  IniFile.WriteInteger('Chat', 'Top', Top);
  IniFile.WriteInteger('Chat', 'Width', Width);
  IniFile.WriteInteger('Chat', 'Height', Height);
  IniFile.Free;
end;

procedure TFormChat.FormCreate(Sender: TObject);
var
  TmpStr: string;
  IniFile: TIniFile;
begin
  TmpStr := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
  IniFile := TIniFile.Create(TmpStr);
  Left := IniFile.ReadInteger('Chat', 'Left', 326);
  Top := IniFile.ReadInteger('Chat', 'Top', 131);
  Width := IniFile.ReadInteger('Chat', 'Width', 503);
  Height := IniFile.ReadInteger('Chat', 'Height', 286);
  IniFile.Free;
end;

procedure TFormChat.FormShow(Sender: TObject);
var
  TmpStr: string;
begin
  if not InputQuery(PROGRAMNAME + ' ' + PROGRAMVERSION, 'Nickname', TmpStr) then
  TmpStr := PROGRAMNAME + ' ' + PROGRAMVERSION;
  SendDatas(Client.AThread, CHATSTART + '|' + TmpStr);
end;

end.
