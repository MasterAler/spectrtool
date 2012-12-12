unit CalcCurve;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, TeeProcs, TeEngine, Chart, Series, Menus, ap, lsfit, IntervalSetter,
  toolUtils ;

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
    N2: TMenuItem;
    N7: TMenuItem;
    N1910231: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ChartCurvesClickSeries(Sender: TCustomChart;
      Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N4Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure Origin1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ChartCurvesMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure N7Click(Sender: TObject);
    procedure N1910231Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function RecalcTemperarureCurves():boolean;
  end;

var
  FrmCurves: TFrmCurves;
  TraceCurves: boolean;
  first, second : TNumInterval;

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
   line.Color:=curp^.color;
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

procedure TFrmCurves.ChartCurvesMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
 i: integer;
 xval,yval: double;
begin
 if (ChartCurves.SeriesCount=0) or (not TraceCurves) then Exit;
 ChartCurves.Repaint;
 for i:=0 to ChartCurves.SeriesCount-1 do
  begin
   if ChartCurves.Series[i].GetCursorValueIndex<>-1 then
    begin
     with ChartCurves.Canvas do
      begin
       Pen.Color:=clBlue;
       Pen.Style:=psDash;
       Font.Color:=clBlue;
       Line(ChartCurves.ChartRect.Left,Y,ChartCurves.ChartRect.Right,Y);
       Line(X,ChartCurves.ChartRect.Top,X,ChartCurves.ChartRect.Bottom);
       ChartCurves.Series[i].GetCursorValues(xval,yval);
       TextOut(X+7,Y-TextHeight('X')-3,'X= '+FloatToStrF(xval,ffGeneral,6,2)+'  Y= '+FloatToStrF(yval,ffGeneral,4,2));
      end;
    end;
  end;
end;

procedure TFrmCurves.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action:=caHide;
end;

procedure TFrmCurves.FormCreate(Sender: TObject);
begin
 TraceCurves:=false;
 first._from := 1;
 first._to := 9;
 second._from := 10;
 second._to := 23;
end;

procedure TFrmCurves.ChartCurvesClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 if (Button=mbRight) then Series.Free;
end;

procedure TFrmCurves.N10Click(Sender: TObject);
begin
 ClearFastlines(ChartCurves);
 ChartCurves.Repaint;
end;

procedure TFrmCurves.N11Click(Sender: TObject);
begin
 ChartCurves.PrintLandscape;
end;

procedure TFrmCurves.N1910231Click(Sender: TObject);
var
 i,j: integer;
 res1, res2: TLinearCoeffs;
 linearfit1, linearfit2 : TFastLineSeries;
 x,y: double;
begin
  ClearFastlines(ChartCurves, ltStantard);

 {
  Тут, кстати, в 2 местах написан лютый адъ : цикл идет по размеру
  списка, который в Delphi записывается границей 1 раз. При этом серии,
  добавляемые в конец, не попадут в обработку. Так-то :))
 }
 for I := 0 to ChartCurves.SeriesList.Count - 1 do
  begin
   if (ChartCurves.Series[i] is TFastLineSeries) then Continue;
   linearfit1:=TFastLineSeries.Create(nil);
   linearfit2:=TFastLineSeries.Create(nil);
   try
     res1:=CalcLSforCurvePart(ChartCurves, i, first._from, first._to);
     res2:=CalcLSforCurvePart(ChartCurves, i, second._from, second._to);
   except
    MessageDlg('Исправьте диапазоны',mtError,[mbOK],0);
    Break;
   end;
   for J := first._from to first._to do
    begin
     x:=ChartCurves.Series[i].XValue[J-1];
     y:=res1.A*x+res1.B;
     linearfit1.AddXY(x,y);
    end;
   for J := second._from to second._to do
    begin
     x:=ChartCurves.Series[i].XValue[J-1];
     y:=res2.A*x+res2.B;
     linearfit2.AddXY(x,y);
    end;
   linearfit1.Tag := 12; // а вот потому что
   linearfit2.Tag := 12;
   linearfit1.Color:=ChartCurves.Series[i].Color;
   linearfit2.Color:=ChartCurves.Series[i].Color;
   linearfit1.Title:='I : y=-Ax+B; 1/A= '+FloatToStrF(-1/res1.A,ffGeneral,4,5)+
     '  B= '+FloatToStrF(res1.B,ffGeneral,4,5)+' err= '+FloatToStrF(res1.err,ffGeneral,4,5);
   linearfit2.Title:='II : y=-Ax+B; 1/A= '+FloatToStrF(-1/res2.A,ffGeneral,4,5)+
     '  B= '+FloatToStrF(res2.B,ffGeneral,4,5)+' err= '+FloatToStrF(res2.err,ffGeneral,4,5);
   linearfit1.ParentChart:=ChartCurves;
   linearfit2.ParentChart:=ChartCurves;
  end;
end;

procedure TFrmCurves.N2Click(Sender: TObject);
begin
 TraceCurves:= not TraceCurves;
 N2.Checked:=TraceCurves;
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

procedure TFrmCurves.N7Click(Sender: TObject);
var
 i,j: integer;
 res: TLinearCoeffs;
 linearfit: TFastLineSeries;
 x,y: double;
begin
 ClearFastlines(ChartCurves, ltEntire);

 for I := 0 to ChartCurves.SeriesList.Count - 1 do
  begin
   if (ChartCurves.Series[i] is TFastLineSeries) then Continue;
   linearfit:=TFastLineSeries.Create(nil);
   res:=CalcLSforCurve(ChartCurves, i);
   for J := 0 to ChartCurves.Series[i].Count - 1 do
    begin
     x:=ChartCurves.Series[i].XValue[J];
     y:=res.A*x+res.B;
     linearfit.AddXY(x,y);
    end;
   linearfit.Tag := Integer(ltEntire); // а вот потому что
   linearfit.Color:=ChartCurves.Series[i].Color;
   linearfit.Title:='y=-Ax+B; 1/A= '+FloatToStrF(-1/res.A,ffGeneral,4,5)+
     '  B= '+FloatToStrF(res.B,ffGeneral,4,5)+' err= '+FloatToStrF(res.err,ffGeneral,4,5);
   linearfit.ParentChart:=ChartCurves;
  end;
end;

procedure TFrmCurves.N8Click(Sender: TObject);
begin
 if (FrmIntervals.ShowModal = mrOk) then
      MessageDlg('Диапазоны изменены', mtInformation,[mbOK],0)
 else
      MessageDlg('Ввод отменен или данные не годятся', mtWarning,[mbOK],0);
end;

procedure TFrmCurves.N9Click(Sender: TObject);
var
 i,j: integer;
 res2: TLinearCoeffs;
 linearfit2 : TFastLineSeries;
 x,y: double;
begin
  ClearFastlines(ChartCurves, ltHot);
 {
  Тут, кстати, в 2 местах написан лютый адъ : цикл идет по размеру
  списка, который в Delphi записывается границей 1 раз. При этом серии,
  добавляемые в конец, не попадут в обработку. Так-то :))
 }
 for I := 0 to ChartCurves.SeriesList.Count - 1 do
  begin
   if (ChartCurves.Series[i] is TFastLineSeries) then Continue;
   linearfit2:=TFastLineSeries.Create(nil);
   try
     res2:=CalcLSforCurvePart(ChartCurves, i, second._from, second._to);
   except
    MessageDlg('Исправьте диапазоны',mtError,[mbOK],0);
    Break;
   end;
   for J := second._from to second._to do
    begin
     x:=ChartCurves.Series[i].XValue[J-1];
     y:=res2.A*x+res2.B;
     linearfit2.AddXY(x,y);
    end;
   linearfit2.Tag := 3; // а вот потому что
   linearfit2.Color:=ChartCurves.Series[i].Color;
   linearfit2.Title:='II : y=-Ax+B; 1/A= '+FloatToStrF(-1/res2.A,ffGeneral,4,5)+
     '  B= '+FloatToStrF(res2.B,ffGeneral,4,5)+' err= '+FloatToStrF(res2.err,ffGeneral,4,5);
   linearfit2.ParentChart:=ChartCurves;
  end;
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
   for i:=1 to ChartCurves.SeriesCount do
     if not (ChartCurves.Series[i-1] is TFastLineSeries) then Write(f,#9,'LnZ':10,i);
   Writeln(f);
   line:=ChartCurves.Series[0];
   for j:=0 to line.Count-1 do
    begin
     Write(f,line.XValue[j]:5:2);
     for i:=0 to ChartCurves.SeriesCount-1 do
      begin
       if (ChartCurves.Series[i] is TFastLineSeries) then Continue;
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
