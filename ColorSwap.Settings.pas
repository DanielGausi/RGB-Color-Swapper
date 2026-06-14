unit ColorSwap.Settings;

interface

uses
  System.SysUtils, System.IniFiles, Vcl.Forms;

type

  teFileMode = (fmReplace, fmRename, fmDifferentDirectory);
  teSwapRGBMode = (smNone, smRBG, smBGR, smBRG, smGBR, smGRB);

const
  cSwapRGBModes: Array[teSwapRGBMode] of string = ('None (original)', 'R-B-G', 'B-G-R', 'B-R-G', 'G-B-R', 'G-R-B' );

type
  TColorSwapSettings = class
  private
    fSaveAsJpeg: Boolean;
    fJpegQuality: Integer;
    fSaveDirectory: string;
    fFileMode: teFileMode;
    fSwapMode: teSwapRGBMode;

    procedure SetJpegQuality(const Value: Integer);

  public
    property SaveAsJpeg: Boolean read fSaveAsJpeg write fSaveAsJpeg;
    property JpegQuality: Integer read fJpegQuality write SetJpegQuality;
    property SaveDirectory: string read fSaveDirectory write fSaveDirectory;
    property FileMode: teFileMode read fFileMode write fFileMode; // replace, rename, different Directory
    property SwapMode: teSwapRGBMode read fSwapMode write fSwapMode;

    constructor Create;
    destructor Destroy; override;

    procedure SaveToIni;
    procedure LoadFromIni;
  end;

implementation

{ TColorSwapSettings }

constructor TColorSwapSettings.Create;
begin

end;

destructor TColorSwapSettings.Destroy;
begin

  inherited;
end;

procedure TColorSwapSettings.LoadFromIni;
var
  ini: TMemIniFile;
begin
  ini := TMemIniFile.Create(ExtractFilePath(Application.ExeName) + 'settings.ini');
  try
    fSaveAsJpeg := ini.readBool('jpeg', 'savAsJpg', False);
    JpegQuality := ini.ReadInteger('jpeg', 'jpegQuality', 95);
    fSaveDirectory := ini.ReadString('file', 'saveDirectory', '');
    fFileMode := teFileMode(ini.ReadInteger('file', 'fileMode', Integer(fmRename))) ;
    fSwapMode := teSwapRGBMode(ini.ReadInteger('file', 'swapMode', Integer(smNone)));
  finally
    ini.Free;
  end;
end;

procedure TColorSwapSettings.SaveToIni;
var
  ini: TMemIniFile;
begin
  ini := TMemIniFile.Create(ExtractFilePath(Application.ExeName) + 'settings.ini');
  try
    ini.WriteBool('jpeg', 'savAsJpg', fSaveAsJpeg);
    ini.WriteInteger('jpeg', 'jpegQuality', JpegQuality);
    ini.WriteString('file', 'saveDirectory', fSaveDirectory);
    ini.WriteInteger('file', 'fileMode', Integer(fFileMode));
    ini.WriteInteger('file', 'swapMode', Integer(fSwapMode));
  finally
    ini.UpdateFile;
    ini.Free;
  end;
end;

procedure TColorSwapSettings.SetJpegQuality(const Value: Integer);
begin
  if Value < 0 then
    fJpegQuality := 0
  else
    if Value > 100 then
      fJpegQuality := 100
    else
      fJpegQuality := Value;
end;

end.
