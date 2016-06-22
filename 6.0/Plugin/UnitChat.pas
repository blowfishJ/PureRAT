unit UnitChat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Controls, Forms, StdCtrls,
  sEdit, ComCtrls, SocketUnit, UnitConstants, UnitStringCompression,
  UnitStringEncryption;

type
  TFormChat = class(TForm)
    redt1: TRichEdit;
    edt1: TsEdit;
    procedure edt1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    ClientSocket: TClientSocket;
    Nickname: string;
  public
    { Public declarations }
    procedure SetInfos(_ClientSocket: TClientSocket; _Nickname: string);
    procedure SendDatas(Datas: string);
    procedure WriteMessage(TmpMsg: string);
  end;

var
  FormChat: TFormChat;

implementation

{$R *.dfm}

procedure TFormChat.edt1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Char(VK_RETURN) then
  begin
    FormChat.redt1.Text := FormChat.redt1.Text + '[' + TimeToStr(Time) + '] You: ' + FormChat.edt1.Text + #13#10;
    FormChat.redt1.SelStart := Length(FormChat.redt1.Text);
    SendMessage(FormChat.redt1.handle, EM_SCROLLCARET, 0, 0);
    SendDatas(FormChat.edt1.Text);
    edt1.Text := '';
  end;
end;
   
procedure TFormChat.SetInfos(_ClientSocket: TClientSocket; _Nickname: string);
begin
  ClientSocket := _ClientSocket;
  Nickname := _Nickname;
end;
    
procedure TFormChat.SendDatas(Datas: string);
begin
  if ClientSocket.Connected = False then Exit;
  Datas := CHATTEXT + '|' + Datas;
  Datas := CompressString(Datas);
  Datas := EnDecryptString(Datas, PROGRAMPASSWORD);
  if ClientSocket.SendString(IntToStr(Length(Datas)) + '|' + #10) <= 0 then Exit;
  ClientSocket.SendBuffer(Pointer(Datas)^, Length(Datas));
end;

procedure TFormChat.WriteMessage(TmpMsg: string);
begin
  FormChat.redt1.Text := FormChat.redt1.Text + '[' + TimeToStr(Time) + '] ' + Nickname + ': ' + TmpMsg + #13#10;
  FormChat.redt1.SelStart := Length(FormChat.redt1.Text);
  SendMessage(FormChat.redt1.handle, EM_SCROLLCARET, 0, 0);
end;

end.
