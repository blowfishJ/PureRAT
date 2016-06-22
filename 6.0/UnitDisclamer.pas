unit UnitDisclamer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFormDisclamer = class(TForm)
    pnl1: TPanel;
    btn1: TButton;
    btn2: TButton;
    chk1: TCheckBox;
    mmo1: TMemo;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormDisclamer: TFormDisclamer;

implementation

{$R *.dfm}

procedure TFormDisclamer.btn1Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFormDisclamer.btn2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;
     
procedure TimeRemaining;
var
  i: Integer;
begin
  i := 10;
  for i := 10 downto 1 do
  begin
    FormDisclamer.btn1.Caption := 'I Agree (' + IntToStr(i) + ')';
    sleep(1000);
  end;
  
  FormDisclamer.btn1.Caption := 'I Agree';
  FormDisclamer.btn1.Enabled := True;
end;

procedure TFormDisclamer.FormShow(Sender: TObject);
var
  TmpHandle: THandle;
begin
  btn1.Enabled := False;
  CreateThread(nil, 0, @TimeRemaining, nil, 0, TmpHandle);
end;

end.
