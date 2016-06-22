unit UnitWindowProc;

interface

uses
  Windows, WebcamAPI, uCamHelper, UnitVariables, UnitWebcamCapture;

function ClientWindowProc(hWnd: HWND; Msg: UINT; wParam: WPARAM;
  lParam: LPARAM): LRESULT; stdcall;

implementation
      
function ClientWindowProc(hWnd: HWND; Msg: UINT; wParam: WPARAM;
  lParam: LPARAM): LRESULT; stdcall;
begin
  if Msg = WM_WEBCAMDIRECTX then
  begin
    CamHelper.GetCams;
    if CamHelper.CamCount > 0 then Result := 1 else Result := 0;
    Exit;
  end
  else

  if Msg = WM_WEBCAMLIST then
  begin
    WebcamList := WideString(CamHelper.GetCams);
    if CamHelper.CamCount <= 0 then WebcamList := ListarDispositivosWebCam('|');
  end
  else

  if Msg = WM_WEBCAMSTART then
  begin
    if WebcamType = 0 then CamHelper.StartCam(WebcamId + 1);
    WebcamThread := TWebcamThread.Create;
    WebcamThread.Resume;
  end
  else Result := DefWindowProc(HWND, Msg, wParam, lParam);
end;

end.
