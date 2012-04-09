program SpectrCalcP;

uses
  Forms,
  SpectrCalc in 'SpectrCalc.pas' {FrmMAIN},
  CalcCurve in 'CalcCurve.pas' {FrmCurves},
  Settings in 'Settings.pas' {FrmSettings};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMAIN, FrmMAIN);
  Application.CreateForm(TFrmCurves, FrmCurves);
  Application.CreateForm(TFrmSettings, FrmSettings);
  Application.Run;
end.
