unit UnitVariables;

interface

uses
  UnitObjeto, SocketUnit;

var                                 
  MainConnection: TClientSocket;
  MainHost: string;
  MainPort: Word;
  Nickname: string;
  ClientPath, Pluginfile: string;
  WebcamType: Integer = 0;
  WebcamId: Integer = 0;
  WebcamList: WideString = '';
  ClientObject: TMyObject;
  InstalledDate: string = 'Not installed';
  NewIdentification: string = '';
  FirstExecution: Boolean = False;     
  ProxyMutex: THandle;
  Sqlite3file, KeylogsPath: string;
  WebcamInterval, WebcamQuality: Integer;
  WM_WEBCAMLIST, WM_WEBCAMDIRECTX, WM_WEBCAMSTART: Cardinal;

implementation
         
end.
