unit UnitRepository;

interface

uses
  SysUtils;
               
function GetUserFolder(UserId: string): string;
function GetDesktopFolder(UserId: string): string;
function GetWebcamFolder(UserId: string): string;
function GetMicrophoneFolder(UserId: string): string;
function GetKeyloggerFolder(UserId: string): string;
function GetPasswordsFolder(UserId: string): string;
function GetDownloadsFolder(UserId: string): string;

implementation
        
function GetUserFolder(UserId: string): string;
var
  TmpStr: string;
begin
  TmpStr := ExtractFilePath(ParamStr(0)) + 'Users';
  if not DirectoryExists(TmpStr) then CreateDir(TmpStr);
  TmpStr := TmpStr + '\' + UserId;
  if not DirectoryExists(TmpStr) then CreateDir(TmpStr);
  Result := TmpStr;
end;

function GetDesktopFolder(UserId: string): string;
var
  TmpStr: string;
begin
  TmpStr := GetUserFolder(UserId);
  TmpStr := TmpStr + '\Desktop';
  if not DirectoryExists(TmpStr) then CreateDir(TmpStr);
  Result := TmpStr;
end;

function GetWebcamFolder(UserId: string): string;
var
  TmpStr: string;
begin
  TmpStr := GetUserFolder(UserId);
  TmpStr := TmpStr + '\Webcam';
  if not DirectoryExists(TmpStr) then CreateDir(TmpStr);
  Result := TmpStr;
end;

function GetMicrophoneFolder(UserId: string): string;
var
  TmpStr: string;
begin
  TmpStr := GetUserFolder(UserId);
  TmpStr := TmpStr + '\Microphone';
  if not DirectoryExists(TmpStr) then CreateDir(TmpStr);
  Result := TmpStr;
end;

function GetPasswordsFolder(UserId: string): string;
var
  TmpStr: string;
begin
  TmpStr := GetUserFolder(UserId);
  TmpStr := TmpStr + '\Passwords';
  if not DirectoryExists(TmpStr) then CreateDir(TmpStr);
  Result := TmpStr;
end;

function GetKeyloggerFolder(UserId: string): string;
var
  TmpStr: string;
begin
  TmpStr := GetUserFolder(UserId);
  TmpStr := TmpStr + '\Keylogger';
  if not DirectoryExists(TmpStr) then CreateDir(TmpStr);   
  Result := TmpStr;
  
  TmpStr := TmpStr + '\Offline keylogger';
  if not DirectoryExists(TmpStr) then CreateDir(TmpStr);
end;

function GetDownloadsFolder(UserId: string): string;
var
  TmpStr: string;
begin
  TmpStr := GetUserFolder(UserId);
  TmpStr := TmpStr + '\Downloads';
  if not DirectoryExists(TmpStr) then CreateDir(TmpStr);
  Result := TmpStr;
end;

end.
