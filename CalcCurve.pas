unit CalcCurve;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, TeeProcs, TeEngine, Chart, Series, Menus;

type
  TFrmCurves = class(TForm)
    ChartCurves: TChart;
    MenuCurves: TMainMenu;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N1: TMenuItem;
    Origin1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ChartCurvesClickSeries(Sender: TCustomChart;
      Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N4Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure Origin1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function RecalcTemperarureCurves():boolean;
  end;

var
  FrmCurves: TFrmCurves;

implementation

uses SpectrCalc, Settings, Math;

{$R *.dfm}

function TFrmCurves.RecalcTemperarureCurves():boolean;
var
 i,j: integer;
 line : TLineSeries;
 t_y: real;
 curp: PCurvePeaks;
 n: integer;
 k_j: integer;
begin
 ChartCurves.SeriesList.Clear;
 if PeakList.Count=0 then
  begin
   Result:=false;
   Exit;
  end;
 for i:=0 to PeakList.Count-1 do
  begin
   line:=TLineSeries.Create(nil);
   line.Clear;
   curp:=PeakList[i];
   line.Title:=curp^.Title;
   line.LinePen.Color:=curp^.color;
   line.Pointer.Visible:=true;
   n:= Min(High(curp^.points),High(CoeffData));
   for j:=0 to n do
    begin
     k_j:=j+mFrom-1;
     t_y:=LogN(2.718281828,CoeffData[k_j].k*curp^.points[j].y/CoeffData[k_j].S/(2*(K_first+k_j-0.5)+1));
     //t_Y:=LnXP1(CoeffData[j].k*curp^.points[j].y/CoeffData[j].S/(2*(K_first+j-0.5)+1));
     //t_Y:=CoeffData[j].k*curp^.points[j].y/CoeffData[j].S/(2*(K_first+j-0.5)+1);
     line.AddXY(CoeffData[k_j].F,t_y);
    end;
   line.ParentChart:=ChartCurves;
  end;
 ChartCurves.Repaint;
 Result:=true;
end;

procedure TFrmCurves.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action:=caHide;
end;

procedure TFrmCurves.ChartCurvesClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 if (Button=mbRight) then Series.Free;
end;

procedure TFrmCurves.N4Click(Sender: TObject);
begin
 Close();
end;

procedure TFrmCurves.N6Click(Sender: TObject);
begin
 FrmMain.SaveChartDialog.FileName:='ChartTemperatureCurves';
 if FrmMain.SaveChartDialog.Execute then
  begin
   case FrmMain.SaveChartDialog.FilterIndex of
    1: ChartCurves.SaveToBitmapFile(FrmMain.SaveChartDialog.FileName);
    2: ChartCurves.SaveToMetafileEnh(FrmMain.SaveChartDialog.FileName);
    3: ChartCurves.SaveToMetafile(FrmMain.SaveChartDialog.FileName);
    else MessageDlg('Сохранение не произведено!',mtInformation,[mbOK],0);
   end;
  end
 else MessageDlg('Сохранение не произведено!',mtInformation,[mbOK],0);
end;

procedure TFrmCurves.Origin1Click(Sender: TObject);
var
 i,j : integer;
 f : TextFile;
 line: TChartSeries;
begin
 if ChartCurves.SeriesCount=0 then Exit;
 FrmMain.SaveDataDialog.FileName:='Curves.txt';
 if (FrmMain.SaveDataDialog.Execute) then
  begin
   AssignFile(f,FrmMain.SaveDataDialog.FileName);
   Rewrite(f);
   Write(f,'F(K)');
   for i:=1 to ChartCurves.SeriesCount-1 do
     Write(f,#9,'LnZ':10,i);
   Writeln(f);
   line:=ChartCurves.Series[0];
   for j:=0 to line.Count-1 do
    begin
     Write(f,line.XValue[j]:5:2);
     for i:=1 to ChartCurves.SeriesCount-1 do
      begin
       line:=ChartCurves.Series[i];
       Write(f,#9,line.YValue[j]:10:4);
      end;
     Writeln(f);
     line:=ChartCurves.Series[0];
    end;
   CloseFile(f);
  end
 else MessageDlg('Сохранение не произведено!',mtInformation,[mbOK],0);
end;

end.
