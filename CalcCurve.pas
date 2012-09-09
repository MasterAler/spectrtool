unit CalcCurve;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, TeeProcs, TeEngine, Chart, Series, Menus,ap, lsfit ;

type
  TLinearCoeffs=record
     A,B: double;
     err: double;
  end;
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
  private
    { Private declarations }
    function CalcLSforCurve(seriesnum: integer):TLinearCoeffs;
  public
    { Public declarations }
    function RecalcTemperarureCurves():boolean;
  end;

var
  FrmCurves: TFrmCurves;
  TraceCurves: boolean;

implementation

uses SpectrCalc, Settings, Math;

{$R *.dfm}

function TFrmCurves.CalcLSforCurve(seriesnum: integer) :TLinearCoeffs;
var
 M : AlglibInteger;
 N : AlglibInteger;
 Y : TReal1DArray;
 FMatrix : TReal2DArray;
 Rep : LSFitReport;
 Info : AlglibInteger;
 C : TReal1DArray;
 I : AlglibInteger;
 J : AlglibInteger;
 X : Double;
 curve: TLineSeries;
begin
 if (seriesnum<0) or (seriesnum>=ChartCurves.SeriesList.Count) then Exit;

 curve:=TLineSeries(ChartCurves.Series[seriesnum]);
 M := 2;
 N := curve.Count;

 SetLength(Y, N);
 SetLength(FMatrix, N, M);
 I:=0;
 while I<=N-1 do
  begin
   X :=  curve.XValue[i];
   Y[I] := curve.YValue[i];
   FMatrix[I,0] := 1.0;
   J:=1;
   while J<=M-1 do
    begin
     FMatrix[I,J] := X*FMatrix[I,J-1];
     Inc(J);
    end;
   Inc(I);
 end;

 LSFitLinear(Y, FMatrix, N, M, Info, C, Rep);

 Result.A:=C[1];
 Result.B:=C[0];
 Result.err:=Rep.AvgRelError;
end;

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
end;

procedure TFrmCurves.ChartCurvesClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 if (Button=mbRight) then Series.Free;
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
 b : boolean;
 k: integer;
begin
 b:=false; k:=0;
 while not b do
  begin
   if (ChartCurves.Series[k] is TFastLineSeries) then
    begin
     ChartCurves.SeriesList.Delete(k);
     k:=0;
    end;
   Inc(k);
   if (k=ChartCurves.SeriesList.Count) then b:=true;
  end;

 for I := 0 to ChartCurves.SeriesList.Count - 1 do
  begin
   linearfit:=TFastLineSeries.Create(nil);
   res:=CalcLSforCurve(i);
   for J := 0 to ChartCurves.Series[i].Count - 1 do
    begin
     x:=ChartCurves.Series[i].XValue[J];
     y:=res.A*x+res.B;
     linearfit.AddXY(x,y);
    end; 
   linearfit.Color:=ChartCurves.Series[i].Color;
   linearfit.Title:='y=-Ax+B; 1/A= '+FloatToStrF(-1/res.A,ffGeneral,4,5)+
     '  B= '+FloatToStrF(res.B,ffGeneral,4,5)+' err= '+FloatToStrF(res.err,ffGeneral,4,5);
   linearfit.ParentChart:=ChartCurves;
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
     Write(f,#9,'LnZ':10,i);
   Writeln(f);
   line:=ChartCurves.Series[0];
   for j:=0 to line.Count-1 do
    begin
     Write(f,line.XValue[j]:5:2);
     for i:=0 to ChartCurves.SeriesCount-1 do
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
