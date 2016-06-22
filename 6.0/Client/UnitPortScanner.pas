unit UnitPortScanner;

interface

uses
  Windows, WinSock, ThreadUnit, UnitVariables, UnitConstants, UnitFunctions,
  UnitConnection;

type
  TScannerThread = class(TThread)
  private
    Host: string;
    pBegin, pEnd: Word;
    function hConnect(hHost: string; hPort: Word): Boolean;
    function PortToService(Port: Word): string;
  protected
    procedure Execute; override;
  public
    StopScanning: Boolean;
    constructor Create(CreateSuspended: Boolean = True);
    procedure SetOptions(_Host: string; _pBegin, _pEnd: Word);
  end;

var
  ScannerThread: TScannerThread;

implementation

constructor TScannerThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  StopScanning := False;
end;

procedure TScannerThread.SetOptions(_Host: string; _pBegin, _pEnd: Word);
begin
  Host := _Host;
  pBegin := _pBegin;
  pEnd := _pEnd;
end;

function TScannerThread.hConnect(hHost: string; hPort: Word): Boolean;
var
  hSock: TSocket;
  wsa: TWSAData;
  Addr: TSockAddrIn;
begin
  WSAStartup($0101, wsa);
  try
    hSock := socket(AF_INET, SOCK_STREAM, 0);
    Addr.sin_family := AF_INET;
    Addr.sin_addr.S_addr := inet_addr(PChar(ResolveIP(hHost)));
    Addr.sin_port := htons(hPort);
    if connect(hSock, Addr, SizeOf(Addr)) = 0 then Result := True else Result := False;
  finally
    closesocket(hSock);
    WSACleanup();
  end;
end;

function TScannerThread.PortToService(Port: Word): string;
begin
  if Port = 20 then Result := IntToStr(Port) + ': FTP(File Transfer Protocol)' else
  if Port = 21 then Result := IntToStr(Port) + ': FTP(File Transfer Protocol)'else
  if Port = 22 then Result := IntToStr(Port) + ': SSH(Secure Shell)' else
  if Port = 23 then Result := IntToStr(Port) + ': TELNET' else
  if Port = 25 then Result := IntToStr(Port) + ': SMTP(Send Mail Transfer Protocol)' else
  if Port = 43 then Result := IntToStr(Port) + ': WHOIS' else
  if Port = 53 then Result := IntToStr(Port) + ': DNS(Domain name service)' else
  if Port = 68 then Result := IntToStr(Port) + ': DHCP(Dynamic Host Control Protocol)' else
  if (Port = 80) or (Port = 8080) then  Result := IntToStr(Port) + ': HTTP(HyperText Transfer Protocol)' else
  if Port = 110 then Result := IntToStr(Port) + ': POP3(Post Office Protocol 3)' else
  if Port = 137 then Result := IntToStr(Port) + ': NETBIOS-ns' else
  if Port = 138 then Result := IntToStr(Port) + ': NETBIOS-dgm' else
  if Port = 139 then Result := IntToStr(Port) + ': NETBIOS' else
  if Port = 143 then Result := IntToStr(Port) + ': IMAP(Internet Message Access Protocol)' else
  if Port = 161 then Result := IntToStr(Port) + ': SNMP(Simple Network Management Protocol)' else
  if Port = 194 then Result := IntToStr(Port) + ': IRC(Internet Relay Chat)' else
  if Port = 220 then Result := IntToStr(Port) + ': IMAP(Internet Message Access Protocol 3)' else
  if Port = 443 then Result := IntToStr(Port) + ': SSL(Secure Socket Layer)' else
  if Port = 445 then Result := IntToStr(Port) + ': SMB(Netbios over TCP)' else
  if Port = 1352 then Result := IntToStr(Port) + ': LOTUS NOTES' else
  if Port = 1433 then Result := IntToStr(Port) + ': MICROSOFT SQL SERVER' else
  if Port = 1521 then Result := IntToStr(Port) + ': ORACLE SQL' else
  if Port = 2049 then Result := IntToStr(Port) + ': NFS(Network File System)' else
  if Port = 3306 then Result := IntToStr(Port) + ': MySQL' else
  if Port = 4000 then Result := IntToStr(Port) + ': ICQ' else
  if (Port = 5800) or (Port = 5900) then Result := IntToStr(Port) + ': VNC' else 
    Result := IntToStr(Port) + ': Unknow service port.';
end;

procedure TScannerThread.Execute;
var
  TmpStr: string;
begin
  while (pBegin <> pEnd) and (StopScanning = False) do
  begin
    if hConnect(Host, pBegin) then
      TmpStr := Host + '|' + PortToService(pBegin) + '|' + 'OPEN|'
    else TmpStr := Host + '|' + PortToService(pBegin) + '|' + 'CLOSED|';

    SendDatas(MainConnection, PORTSCANNERRESULTS  + '|' + TmpStr);
    Inc(pBegin);
  end;
end;

end.
