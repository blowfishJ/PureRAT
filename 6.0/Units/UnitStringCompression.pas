unit UnitStringCompression;

interface

uses
  ZLibEx, Classes;

function CompressString(Str: string): string;
function DecompressString(Str: string): string;   
function StreamToStr(Stream: TStream): string;
procedure StrToStream(S: string; Stream: TStream);

implementation
        
function StreamToStr(Stream: TStream): string;
var i: Int64;
begin
  Stream.Position := 0;
  i := Stream.Size;
  SetLength(Result, i);
  Stream.Read(Result[1], i);
end;

procedure StrToStream(S: string; Stream: TStream);
begin
  Stream.Position := 0;
  Stream.Write(S[1], Length(S));
end;

function CompressString(Str: string): string;
var zCompression: TZCompressionStream;
    inStream, outStream: TMemoryStream;
begin
  Result := '';
  inStream := TMemoryStream.Create;
  outStream := TMemoryStream.Create;
  StrToStream(Str, inStream);
  inStream.Position := 0;
  zCompression := TZCompressionStream.Create(outStream, zcFastest);
  zCompression.CopyFrom(inStream, inStream.Size);
  zCompression.Free;
  Result := StreamToStr(outStream);
  inStream.Free;
  outStream.Free;
end;

function DecompressString(Str: string): string;
const BufferSize = 4096;
var zDecompression: TZDecompressionStream;
    inStream, outStream: TMemoryStream;
    Buffer: array[0..BufferSize-1] of Byte;
    Count: Integer;
begin
  Result := '';
  inStream := TMemoryStream.Create;
  outStream := TMemoryStream.Create;
  StrToStream(Str, inStream);
  inStream.Position := 0;
  zDecompression := TZDecompressionStream.Create(inStream);
  while True do
  begin
    Count := zDecompression.Read(Buffer, BufferSize);
    if Count <> 0 then outStream.WriteBuffer(Buffer, Count) else Break;
  end;
  zDecompression.Free;
  Result := StreamToStr(outStream);
  inStream.Free;
  outStream.Free;
end;

end.
