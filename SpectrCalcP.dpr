program SpectrCalcP;

uses
  Forms,
  SpectrCalc in 'SpectrCalc.pas' {FrmMAIN},
  CalcCurve in 'CalcCurve.pas' {FrmCurves},
  Settings in 'Settings.pas' {FrmSettings},
  Chooser in 'Chooser.pas' {FrmChooser},
  SpectrsReader in 'SpectrsReader.pas',
  VAH_tool in 'VAH_tool.pas' {FrmVAH},
  IntervalSetter in 'IntervalSetter.pas' {FrmIntervals};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'SpectrTool Utility';
  Application.HelpFile := 'D:\ALL_DATA\Delphi_Projects\SpectrTool\SpectrHelp.chm';
  Application.CreateForm(TFrmMAIN, FrmMAIN);
  Application.CreateForm(TFrmCurves, FrmCurves);
  Application.CreateForm(TFrmSettings, FrmSettings);
  Application.CreateForm(TFrmChooser, FrmChooser);
  Application.CreateForm(TFrmVAH, FrmVAH);
  Application.CreateForm(TFrmIntervals, FrmIntervals);
  Application.Run;
end.
