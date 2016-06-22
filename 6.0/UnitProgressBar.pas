unit UnitProgressBar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, UnitConnection;

type
  TFormProgressBar = class(TForm)
    pb1: TProgressBar;
    btn1: TButton;
    procedure btn1Click(Sender: TObject);  
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
  FormProgressBar: TFormProgressBar;

implementation

uses
  UnitTransfersManager;

{$R *.dfm}

constructor TFormProgressBar.Create(aOwner: TComponent; ConnDatas: PConnectionDatas);
begin
  inherited Create(aOwner);
  Client := ConnDatas;
end;

procedure TFormProgressBar.CreateParams(var Params: TCreateParams) ;
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := 0;
end;

procedure TFormProgressBar.btn1Click(Sender: TObject);
var
  FileTransfer: TTransfersManager;
  i: Integer;
begin
  for i := 0 to FormTransfersManager.lvTransfers.Items.Count - 1 do
  begin
    FileTransfer := TTransfersManager(FormTransfersManager.lvTransfers.Items.Item[i].Data);
    if FileTransfer.Client = Client then FileTransfer.CancelTransfer;
    Break;
  end;
end;

end.
