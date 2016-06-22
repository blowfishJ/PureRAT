unit UnitServicesManager;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TFormServicesManager = class(TForm)
    lbl1: TLabel;
    edtName: TEdit;
    lbl3: TLabel;
    edtFilename: TEdit;
    lbl4: TLabel;
    edtDescription: TEdit;
    lbl5: TLabel;
    cbbStartup: TComboBoxEx;
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
  FormServicesManager: TFormServicesManager;

implementation

{$R *.dfm}

procedure TFormServicesManager.btn1Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFormServicesManager.btn2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
