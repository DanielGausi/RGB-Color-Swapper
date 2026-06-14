program ColorSwapper;

uses
  Vcl.Forms,
  MainForm in 'MainForm.pas' {ColorSwapMainForm},
  ColorSwap.Images in 'ColorSwap.Images.pas',
  FSettings in 'FSettings.pas' {FormSettings},
  ColorSwap.Settings in 'ColorSwap.Settings.pas',
  FAbout in 'FAbout.pas' {FormAbout};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TColorSwapMainForm, ColorSwapMainForm);
  Application.CreateForm(TFormAbout, FormAbout);
  Application.Run;
end.
