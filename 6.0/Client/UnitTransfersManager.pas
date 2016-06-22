unit UnitTransfersManager;

interface

uses
  Windows, SocketUnit, UnitConstants, UnitVariables, UnitFunctions, UnitConfiguration,
  UnitInformations, UnitConnection;
           
procedure SendFile(Filename: string; Filesize, Begining: Int64);
function ReceiveFile(Filename, Destination: string; Filesize: Int64; ToSend: string): Boolean;

implementation
 
procedure SendFile(Filename: string; Filesize, Begining: Int64);
var
  Buffer: array[0..32767] of Byte;
  F: file;
  Count: Integer;
  TmpStr: string;
  ClientSocket: TClientSocket;
begin
  _SendDatas(ClientSocket, FILESMANAGER + '|' + FILESDOWNLOADFILE + '|' +
             Filename + '|' + IntToStr(Filesize) + '|');

  try
    FileMode := $0000;
    AssignFile(F, Filename);
    Reset(F, 1);
    if Begining > 0 then Seek(F, Begining);

    while not EOF(F) and ClientSocket.Connected do
    begin
      BlockRead(F, Buffer, 32768, Count);
      ClientSocket.SendBuffer(Buffer, Count);
    end;
  finally
    CloseFile(F);
  end;
end;
   
function ReceiveFile(Filename, Destination: string; Filesize: Int64; ToSend: string): Boolean;
var
  Buffer: array[0..32768] of Byte;
  F: file;
  iRecv, sRecv, j: Integer;
  TmpStr: string;
  ClientSocket: TClientSocket;
begin
  Result := False;
  _SendDatas(ClientSocket, ToSend + '|' + Filename);

  try
    AssignFile(F, Destination);
    Rewrite(F, 1);
    iRecv := 0;
    sRecv := 0;

    while (iRecv < Filesize) and (ClientSocket.Connected) do
    begin
      sRecv := ClientSocket.ReceiveBuffer(Buffer, SizeOf(Buffer));
      iRecv := iRecv + sRecv;
      BlockWrite(F, Buffer, sRecv, j);
      j := sRecv;
    end;
  except
    CloseFile(F);
    Exit;
  end;

  CloseFile(F);
  Result := True;
end;

end.
