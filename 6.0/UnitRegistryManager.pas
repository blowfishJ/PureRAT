unit UnitRegistryManager;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFormRegistryManager = class(TForm)
    lbl1: TLabel;
    edtName: TEdit;
    rgType: TRadioGroup;
    lbl2: TLabel;
    mmoData: TMemo;
    btn1: TButton;
    btn2: TButton;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormRegistryManager: TFormRegistryManager;

implementation

{$R *.dfm}

procedure TFormRegistryManager.btn1Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFormRegistryManager.btn2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
