unit FSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin,
  Vcl.ComCtrls, Vcl.ExtCtrls,
  ColorSwap.Settings;

type
  TFormSettings = class(TForm)
    tbJpegQuality: TTrackBar;
    grpJpegQuality: TGroupBox;
    lblBestCompression: TLabel;
    lblBestQuality: TLabel;
    grpBoxFileOptions: TGroupBox;
    rbReplaceOriginal: TRadioButton;
    rbRenameEdited: TRadioButton;
    rbSaveDifferentDirectory: TRadioButton;
    edtSaveDirectory: TEdit;
    btnSelectDir: TButton;
    btnOk: TButton;
    btnCancel: TButton;
    cbSaveAsJpeg: TCheckBox;
    SelectSaveDirDialog: TFileOpenDialog;
    procedure tbJpegQualityChange(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnSelectDirClick(Sender: TObject);
  private
    { Private declarations }
    fColorSwapSettings: TColorSwapSettings;

    procedure ApplySettingsToGUI;
    procedure ApplyGUIToSettings;
    procedure SetColorSwapSettings(const Value: TColorSwapSettings);
  public
    { Public declarations }

    property ColorSwapSettings: TColorSwapSettings read fColorSwapSettings write SetColorSwapSettings;
  end;

var
  FormSettings: TFormSettings;

implementation

{$R *.dfm}

procedure TFormSettings.SetColorSwapSettings(const Value: TColorSwapSettings);
begin
  fColorSwapSettings := Value;
  ApplySettingsToGUI;
end;

procedure TFormSettings.tbJpegQualityChange(Sender: TObject);
begin
  grpJpegQuality.Caption := Format('Jpeg quality settings (%d)', [tbJpegQuality.Position]);
end;
         
procedure TFormSettings.ApplySettingsToGUI;
begin
  edtSaveDirectory.Text := fColorSwapSettings.SaveDirectory;
  case self.fColorSwapSettings.FileMode of
    fmReplace: rbReplaceOriginal.Checked := True;
    fmRename: rbRenameEdited.Checked := True;
    fmDifferentDirectory: rbSaveDifferentDirectory.Checked := True;
  end;

  tbJpegQuality.Position := fColorSwapSettings.JpegQuality;
  cbSaveAsJpeg.Checked := fColorSwapSettings.SaveAsJpeg;
end;

procedure TFormSettings.btnOkClick(Sender: TObject);
begin
  ApplyGUIToSettings;
  fColorSwapSettings.SaveToIni;
end;

procedure TFormSettings.btnSelectDirClick(Sender: TObject);
begin
  if SelectSaveDirDialog.Execute then
    edtSaveDirectory.Text := SelectSaveDirDialog.FileName;
    
end;

procedure TFormSettings.ApplyGUIToSettings;
begin
  fColorSwapSettings.SaveDirectory := edtSaveDirectory.Text;
  if rbReplaceOriginal.Checked then fColorSwapSettings.FileMode := fmReplace;
  if rbRenameEdited.Checked then fColorSwapSettings.FileMode := fmRename;
  if rbSaveDifferentDirectory.Checked then fColorSwapSettings.FileMode := fmDifferentDirectory;
  fColorSwapSettings.JpegQuality := tbJpegQuality.Position;
  fColorSwapSettings.SaveAsJpeg := cbSaveAsJpeg.Checked;
end;

end.
