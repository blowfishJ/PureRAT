unit UnitNotification;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, acImage, UnitMain;

type
  TFormNotification = class(TForm)
    pnl1: TPanel;
    img1: TsImage;
    lblTitle: TLabel;
    lblIp: TLabel;
    lblId: TLabel;
    lblCountry: TLabel;
    lblWindows: TLabel;
    img2: TImage;
    tmr1: TTimer;
    procedure tmr1Timer(Sender: TObject);
    procedure img1Click(Sender: TObject);
  private            
    { Private declarations }
  public
    { Public declarations }  
    Active: Boolean;
    PosY: Integer;
    constructor Create(aOwner: TComponent; Infos: string);
  end;

var
  FormNotification: TFormNotification;

implementation

{$R *.dfm}

constructor TFormNotification.Create(aOwner: TComponent; Infos: string);
var
  TmpInt: Integer;
begin
  inherited Create(aOwner);
  
  while Infos <> '' do
  begin
    lblTitle.Caption := Copy(Infos, 1, Pos('|', Infos)-1);
    Delete(Infos, 1, Pos('|', Infos));

    lblIp.Caption := 'Ip: ' + Copy(Infos, 1, Pos('|', Infos)-1);
    Delete(Infos, 1, Pos('|', Infos));

    lblId.Caption := 'User: ' + Copy(Infos, 1, Pos('|', Infos)-1);
    Delete(Infos, 1, Pos('|', Infos));

    lblCountry.Caption := 'Country: ' + Copy(Infos, 1, Pos('|', Infos)-1);
    Delete(Infos, 1, Pos('|', Infos));

    lblWindows.Caption := 'Windows: ' + Copy(Infos, 1, Pos('|', Infos)-1);
    Delete(Infos, 1, Pos('|', Infos));

    TmpInt := StrToInt(Copy(Infos, 1, Pos('|', Infos)-1));
    Delete(Infos, 1, Pos('|', Infos));
  end;

  FormMain.ilFlags.GetBitmap(TmpInt, img2.Picture.Bitmap);
end;
   
procedure TFormNotification.tmr1Timer(Sender: TObject);
begin
  if Active = True then
  begin
    if Top > PosY + 1 then Top := Top - 8 else
    begin
      Active := False;
      tmr1.Interval := 4000;
    end;
  end
  else
  begin
    tmr1.Interval := 1;
    if Top < (PosY + 105) then Top := Top + 8 else Free;
  end;
end;

procedure TFormNotification.img1Click(Sender: TObject);
begin
  if img1.Grayed = True then Exit;
end;

end.
