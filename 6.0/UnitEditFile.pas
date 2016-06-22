unit UnitEditFile;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, UnitConnection, Menus, IniFiles;

type
  TFormEditFile = class(TForm)
    stat1: TStatusBar;
    redt1: TRichEdit;
    pm1: TPopupMenu;
    C1: TMenuItem;
    C2: TMenuItem;
    P1: TMenuItem;
    S1: TMenuItem;
    N1: TMenuItem;
  protected
    procedure CreateParams(var Params: TCreateParams) ; override;
  private
    { Private declarations }
    Client: PConnectionDatas;
  public
    { Public declarations }
    constructor Create(aOwner: TComponent; ConnDatas: PConnectionDatas;
      TmpStr: string);
  end;

var
  FormEditFile: TFormEditFile;

implementation

{$R *.dfm}
       
procedure TFormEditFile.CreateParams(var Params: TCreateParams) ;
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := 0;
end;

constructor TFormEditFile.Create(aOwner: TComponent; ConnDatas: PConnectionDatas;
  TmpStr: string);
begin
  inherited Create(aOwner);
  stat1.Panels.Items[0].Text := Copy(TmpStr, 1, Pos('|', TmpStr)-1);
  Delete(TmpStr, 1, Pos('|', TmpStr));
  redt1.Text := TmpStr;
end;

end.
