unit ColorSwap.Images;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Classes,
  System.Variants, System.Win.ComObj, Winapi.Wincodec, Winapi.ActiveX,
  System.IOUtils, System.StrUtils, Vcl.Graphics,
  System.Generics.Collections, System.Generics.Defaults,
  ColorSwap.Settings;

type
  TSwapImage = class;

  TSwapImageList = class(TObjectList<TSwapImage>)
    private
    protected
      function ContainsFileName(aFilename: string): Boolean;
    public
      procedure AddDirectory(aPath: string);
      procedure AddImage(aFilename: string);
  end;

  TSwapImage = class
    private
      fFilename: string;
      fPreviewImage: TWICImage;
      fPreviewEdit: TWICImage;
      fPreviewHeight: Integer;
      fPreviewWidth: Integer;
      fSwapMode: teSwapRGBMode;
      fWidth: Integer;
      fHeight: Integer;
      fFileSize: Int64;
      fJpegQuality: Integer;
      fLastModified: TDateTime;

      procedure SetFilename(const Value: string);
      function GetExtension: string;
      function GetPreview: TWICImage;
      function CreateProportionalScaledCopy(SourceImage: TWICImage; MaxWidth, MaxHeight: Integer): TWICImage;
      procedure SwapColors(WICImage: TWICImage);
      procedure SaveWICImageAsJpeg(WICImage: TWICImage; ImageQuality: Single; aFileName: string);
      procedure SetPreviewHeight(const Value: Integer);
      procedure SetPreviewWidth(const Value: Integer);
      procedure SetSwapMode(const Value: teSwapRGBMode);
      function GetPreviewEdit: TWICImage;
      procedure SetJpegQuality(const Value: Integer);

    protected
      procedure InvalidatePreview;
      procedure InvalidatePreviewEdit;
      function CreatePreview(aFilename: string): TWICImage;
      function CreatePreviewEdit: TWICImage;

    public
      property Filename: string read fFilename write SetFilename;
      property Extension: string read GetExtension;
      property PreviewWidth: Integer read fPreviewWidth write SetPreviewWidth;
      property PreviewHeight: Integer read fPreviewHeight write SetPreviewHeight;
      property Height: Integer read fHeight;
      property Width: Integer read fWidth;
      property FileSize: Int64 read fFileSize;
      property LastModified: TDateTime read fLastModified;
      property JpegQuality: Integer read fJpegQuality write SetJpegQuality;
      property SwapMode: teSwapRGBMode read fSwapMode write SetSwapMode;
      property Preview: TWICImage read GetPreview;
      property PreviewEdit: TWICImage read GetPreviewEdit;

      constructor Create(aFilename: string);
      destructor Destroy; override;

      procedure saveAs(aEditFilename: string; asJpeg: Boolean); overload;
      function OriginalEditFilename(asJpeg: Boolean): string;
      function UniqueEditFilename(TargetDir, TargetExtension: string): string;

  end;

  function IsCommonImageFile(aFilename: string): Boolean;


implementation


function IsCommonImageFile(aFilename: string): Boolean;
begin
  Result := MatchText(ExtractFileExt(aFilename),
        ['.jpg', '.jpeg', '.bmp', '.png']);
end;

{ TSwapImage }

constructor TSwapImage.Create(aFilename: string);
begin
  inherited Create;

  fPreviewImage := nil;
  fPreviewWidth := 250;
  fPreviewHeight := 250;
  fFilename := aFilename;

  fFileSize := TFile.GetSize(aFilename);
  fLastModified := TFile.GetLastWriteTime(aFileName);

end;

destructor TSwapImage.Destroy;
begin
  if assigned(fPreviewImage) then
    fPreviewImage.Free;
  inherited;
end;

function TSwapImage.GetPreview: TWICImage;
begin
  if not assigned(fPreviewImage) then
    fPreviewImage := CreatePreview(fFilename);

  result := fPreviewImage;
end;

function TSwapImage.GetPreviewEdit: TWICImage;
begin
  if not assigned(fPreviewEdit) then
    fPreviewEdit := CreatePreviewEdit;
  result := fPreviewEdit;
end;


procedure TSwapImage.SetFilename(const Value: string);
begin
  fFilename := Value;
end;

function TSwapImage.OriginalEditFilename(asJpeg: Boolean): string;
begin
  if asJpeg then
    result := ChangeFileExt(fFilename, '.jpg')
  else
    result := fFilename;
end;

function TSwapImage.UniqueEditFilename(TargetDir, TargetExtension: string): string;
var
  dir, name, ext, rgbAffix: string;
  i: Integer;
begin
  if TargetExtension = '' then
    ext := TPath.GetExtension(fFilename) // including the '.'
  else
    ext := TargetExtension;

  name := TPath.GetFileNameWithoutExtension(fFilename);

  if TargetDir = '' then begin
    rgbAffix := '_rgbSwap';
    dir := IncludeTrailingPathDelimiter(TPath.GetDirectoryName(fFilename));
  end
  else begin
    rgbAffix := '';
    dir := IncludeTrailingPathDelimiter(TargetDir);
  end;

  result := dir + name + rgbAffix + ext;
  i := 1;
  while FileExists(result) do begin
    result := dir + name + Format('%s(%d)', [rgbAffix, i]) + ext;
    inc(i);
  end;
end;

procedure TSwapImage.SetJpegQuality(const Value: Integer);
begin
  if Value < 0 then
    fJpegQuality := 0
  else
    if Value > 100 then
      fJpegQuality := 100
    else
      fJpegQuality := Value;
end;

function TSwapImage.GetExtension: string;
begin
  result := ExtractFileExt(fFilename)
end;

procedure TSwapImage.SetPreviewHeight(const Value: Integer);
begin
  if fPreviewHeight <> Value then begin
    fPreviewHeight := Value;
    InvalidatePreview;
    InvalidatePreviewEdit;
  end;
end;

procedure TSwapImage.SetPreviewWidth(const Value: Integer);
begin
  if fPreviewWidth <> Value then begin
    fPreviewWidth := Value;
    InvalidatePreview;
    InvalidatePreviewEdit;
  end;
end;

procedure TSwapImage.SetSwapMode(const Value: teSwapRGBMode);
begin
  if fSwapMode <> Value then begin
    fSwapMode := Value;
    InvalidatePreviewEdit;
  end;
end;

procedure TSwapImage.InvalidatePreview;
begin
  FreeAndNil(fPreviewImage);
end;

procedure TSwapImage.InvalidatePreviewEdit;
begin
  FreeAndNil(fPreviewEdit);
end;


function TSwapImage.CreatePreview(aFilename: string): TWICImage;
var
  tmp: TWICImage;
begin
  if not FileExists(aFilename) then
    result := nil
  else begin
    tmp := TWICImage.Create;
    try
      try
        tmp.LoadFromFile(aFilename);
        fWidth := tmp.Width;
        fHeight := tmp.Height;
        // fFileSize := TFile.GetSize(aFilename);
        result := CreateProportionalScaledCopy(tmp, fPreviewWidth, fPreviewHeight);
      except
        result := nil
      end;
    finally
      tmp.Free;
    end;
  end;
end;

function TSwapImage.CreateProportionalScaledCopy(SourceImage: TWICImage;
  MaxWidth, MaxHeight: Integer): TWICImage;
var
  ScaleX, ScaleY: Double;
  NewWidth, NewHeight: Integer;
begin
  ScaleX := MaxWidth / SourceImage.Width;
  ScaleY := MaxHeight / SourceImage.Height;

  if ScaleX < ScaleY then begin
    NewWidth := MaxWidth;
    NewHeight := Round(SourceImage.Height * ScaleX);
  end else begin
    NewWidth := Round(SourceImage.Width * ScaleY);
    NewHeight := MaxHeight;
  end;
  Result := SourceImage.CreateScaledCopy(NewWidth, NewHeight, wipmHighQualityCubic);
end;


function TSwapImage.CreatePreviewEdit: TWICImage;
begin
  if not assigned(fPreviewEdit) then
    fPreviewEdit := TWICImage.Create;
  fPreviewEdit.Assign(Preview);
  SwapColors(fPreviewEdit);
  result := fPreviewEdit;
end;

procedure TSwapImage.SwapColors(WICImage: TWICImage);
var
  Bitmap: TBitmap;
  X, Y: Integer;
  Line: PRGBQuad;
  Temp: Byte;
  storeFormat: TWICImageFormat;

begin
  storeFormat := WICImage.ImageFormat;
  Bitmap := TBitmap.Create;
  try
    Bitmap.Assign(WICImage);
    Bitmap.PixelFormat := pf32bit;

    for Y := 0 to Bitmap.Height - 1 do
    begin
      Line := Bitmap.ScanLine[Y];
      for X := 0 to Bitmap.Width - 1 do
      begin
        case self.SwapMode of
          smNone: ;

          smRBG: begin
            // R G B -> R B G, swap B-G
            Temp := Line^.rgbGreen;
            Line^.rgbGreen := Line^.rgbBlue;
            Line^.rgbBlue := Temp;
          end;
          smBGR: begin
            // R G B -> B G R, swap R-B
            Temp := Line^.rgbRed;
            Line^.rgbRed := Line^.rgbBlue;
            Line^.rgbBlue := Temp;
          end;
          smBRG: begin
            // R G B -> B R G
            Temp := Line^.rgbRed;
            Line^.rgbRed := Line^.rgbBlue;
            Line^.rgbBlue := Line^.rgbGreen;
            Line^.rgbGreen := Temp;
          end;
          smGBR: begin
            // R G B -> G B R
            Temp := Line^.rgbRed;
            Line^.rgbRed := Line^.rgbGreen;
            Line^.rgbGreen := Line^.rgbBlue;
            Line^.rgbBlue := Temp;
          end;
          smGRB: begin
            // R G B -> G R B, swap R-G
            Temp := Line^.rgbRed;
            Line^.rgbRed := Line^.rgbGreen;
            Line^.rgbGreen := Temp;
          end;
        end;

        Inc(Line);
      end;
    end;
    WICImage.Assign(Bitmap);
    WICImage.ImageFormat := storeFormat;
  finally
    Bitmap.Free;
  end;
end;

// TWICImage by itself does not allow to set JPEG Quality
// source: https://stackoverflow.com/questions/42225924/twicimage-how-to-set-jpeg-compression-quality
procedure TSwapImage.SaveWICImageAsJpeg(WICImage: TWICImage; ImageQuality: Single; aFileName: string);
const
  PROPBAG2_TYPE_DATA = 1;
var
  ImagingFactory: IWICImagingFactory;
  Width, Height: Integer;
  Stream: IWICStream;
  Encoder: IWICBitmapEncoder;
  Frame: IWICBitmapFrameEncode;
  PropBag: IPropertyBag2;
  PropBagOptions: TPropBag2;
  V: Variant;
  Rect: WICRect;
begin
  Width := WICImage.Width;
  Height := WICImage.Height;
  ImagingFactory := WICImage.ImagingFactory;
  OleCheck(ImagingFactory.CreateStream(Stream));
  OleCheck(Stream.InitializeFromFilename(PChar(aFileName), GENERIC_WRITE));
  OleCheck(ImagingFactory.CreateEncoder(GUID_ContainerFormatJpeg, GUID_NULL, Encoder));
  OleCheck(Encoder.Initialize(Stream, WICBitmapEncoderNoCache));
  OleCheck(Encoder.CreateNewFrame(Frame, PropBag));
  PropBagOptions := Default(TPropBag2);
  PropBagOptions.pstrName := 'ImageQuality';
  PropBagOptions.dwType := PROPBAG2_TYPE_DATA;
  PropBagOptions.vt := VT_R4;
  V := VarAsType(ImageQuality, varSingle);
  OleCheck(PropBag.Write(1, @PropBagOptions, @V));
  OleCheck(Frame.Initialize(PropBag));
  OleCheck(Frame.SetSize(Width, Height));
  Rect.X := 0;
  Rect.Y := 0;
  Rect.Width := Width;
  Rect.Height := Height;
  OleCheck(Frame.WriteSource(WICImage.Handle, @Rect));
  OleCheck(Frame.Commit);
  OleCheck(Encoder.Commit);
end;

procedure TSwapImage.saveAs(aEditFilename: string; asJpeg: Boolean);
var
  origWIC: TWICImage;
begin
  origWIC := TWICImage.Create;
  try
    origWIC.LoadFromFile(fFilename);
    fWidth := origWIC.Width;
    fHeight := origWIC.Height;
    // fFileSize := TFile.GetSize(fFilename);

    SwapColors(origWIC);
    if asJpeg then
      origWIC.ImageFormat := wifJpeg;

    if origWIC.ImageFormat = wifJpeg then
      SaveWICImageAsJpeg(origWIC, fJpegQuality/100, aEditFilename)
    else
      origWIC.SaveToFile(aEditFilename);
  finally
    origWIC.Free;
  end;
end;

{ TSwapImageList }

function TSwapImageList.ContainsFileName(aFilename: string): Boolean;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    if Items[i].Filename = aFilename then
      exit(True);
  Result := False;
end;

procedure TSwapImageList.AddDirectory(aPath: string);
var
  Files: TStringDynArray;
  newSwapImage: TSwapImage;
  i: Integer;
begin
  Files := TDirectory.GetFiles(aPath, '*.*', TSearchOption.soTopDirectoryOnly, // TSearchOption.soAllDirectories for recursive search
    function(const Path: string; const SearchRec: TSearchRec): Boolean
    begin
      Result := IsCommonImageFile(SearchRec.Name);
    end);
  for i := low(Files) to High(Files) do begin
    if not ContainsFileName(Files[i]) then begin
      newSwapImage := TSwapImage.Create(Files[i]);
      Add(newSwapImage);
    end;
  end;
end;

procedure TSwapImageList.AddImage(aFilename: string);
var
  newSwapImage: TSwapImage;
begin
  if not ContainsFileName(aFileName) then begin
    newSwapImage := TSwapImage.Create(aFileName);
    Add(newSwapImage);
  end;
end;

end.
