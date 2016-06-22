unit UnitConnectionsLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls;

type
  TFormConnectionsLog = class(TForm)
    lv1: TListView;
  private
    { Private declarations }
  public
    { Public declarations }                            
    function RetrieveLogs: string;
  end;

var
  FormConnectionsLog: TFormConnectionsLog;

implementation

{$R *.dfm}

function TFormConnectionsLog.RetrieveLogs;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to lv1.Items.Count-1 do
  begin
    Result := Result + lv1.Items.Item[i].Caption + ': ' + lv1.Items.Item[i].SubItems.Strings[0];
    Result := Result + #13#10;
  end;
end;

end.
