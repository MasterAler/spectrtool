program SpectrCalcP;

uses
  {FastMM4, }
  Forms,
  SpectrCalc in 'SpectrCalc.pas' {FrmMAIN},
  CalcCurve in 'CalcCurve.pas' {FrmCurves},
  Settings in 'Settings.pas' {FrmSettings},
  Chooser in 'Chooser.pas' {FrmChooser},
  SpectrsReader in 'SpectrsReader.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMAIN, FrmMAIN);
  Application.CreateForm(TFrmCurves, FrmCurves);
  Application.CreateForm(TFrmSettings, FrmSettings);
  Application.CreateForm(TFrmChooser, FrmChooser);
  Application.Run;
end.
