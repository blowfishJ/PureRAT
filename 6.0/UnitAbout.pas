unit UnitAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, acImage, sLabel;

type
  TFormAbout = class(TForm)
    lbl4: TsLabel;
    lbl3: TsLabel;
    lblVersion: TsLabel;
    lbl1: TsLabel;
    img1: TsImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAbout: TFormAbout;

implementation

{$R *.dfm}

end.
