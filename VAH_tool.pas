unit VAH_tool;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, TeeProcs, TeEngine, Series, Chart,
  SDL_math2, SDL_vector;

type
    TPointFloat_cl = class
      x: Double;
      y: Double;
    end;
    TParam3 = record
      var1, var2, var3: string;
    end;
    TTitles = record
      Xtitle, Ytitle : string;
    end;
    TDoublrArr = array of Double;
  TFrmVAH = class(TForm)
    MenuVAH: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    OpenDialogCSV: TOpenDialog;
    ChartVAH: TChart;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    SDLtrial1: TMenuItem;
    procedure N2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SDLtrial1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AddSeriesFromFilteredFile(filename: string);
    procedure SavePointclassList(list: TStringList; filename: string);
    function LoadAndFilterData(filename: string): TStringList;
    procedure AddSeries( X,Y : TDoublrArr; title: string );  overload;
    procedure AddSeries(list: TStringList; title: string); overload;
    function DifferentiateSeries(series: TChartSeries): TFastLineSeries;
    //--- Сраный Savitzky-Golay сделаю, используя готовые коэффициенты ----
    function SG_get_second_derivative(series: TChartSeries; Degree: integer = 2): TFastLineSeries;
    function SavGolSecondDerivativeSDL(series: TChartSeries; WindowSize: integer = 5): TFastLineSeries;
  end;

var
  FrmVAH: TFrmVAH;
  was_differentiated: boolean;

implementation

{$R *.dfm}

function ParsePointf(line: string): TPointFloat;
var
 delim: integer;
 x: string;
begin
 delim := pos(',',line);
 x:=Copy(line,1, delim - 1);
 Delete(line, 1, delim);
 Result.x := StrtoFloat(x);
 Result.y := StrtoFloat(line);
end;

function Parse3Params(line: string) : Tparam3;
var
 res: Tparam3;
 ind: integer;
begin
 ind := Pos(',', line);
 res.var1 := Copy(line, 1, ind - 1);
 Delete(line, 1, ind);
 ind := Pos(',', line);
 res.var2 := Copy(line, 1 , ind - 1);
 Delete(line, 1, ind);
 res.var3 := line;
 Result := res;
end;

procedure TFrmVAH.AddSeries(list: TStringList; title: string );
var
 I : integer;
 line : TFastLineSeries;
begin
 line:=TFastLineSeries.Create(ChartVAH);
 for I := 0 to List.Count - 1 do
   begin
    line.AddXY(TPointFloat_cl(list.Objects[i]).x, TPointFloat_cl(list.Objects[i]).y);
   end;
 line.Title := title;
 ChartVAH.AddSeries(line);
 ChartVAH.Repaint;
end;

procedure TFrmVAH.AddSeriesFromFilteredFile(filename: string);
var
 f : TextFile;
 line: TFastLineSeries;
 str: string;
 pt : TPointFloat;
begin
 if  not FileExists(filename) then
  begin
    MessageDlg('Файл не найден!',mtError,[mbOK],0);
    Exit;
  end;

 AssignFile(f, filename);
 Reset(f);
 line:=TFastLineSeries.Create(nil);
 Readln(f, str);
 while not Eof(f) do
  begin
   Readln(f, str);
   pt := ParsePointf(str);
   line.AddXY(pt.x, pt.y);
  end;
 CloseFile(f);
 line.Title := ExtractFileName(filename);
 line.ParentChart := ChartVAH;
 ChartVAH.Repaint;
end;

procedure TFrmVAH.AddSeries( X, Y : TDoublrArr; title: string );
var
 i: integer;
 line: TFastLineSeries;
begin
 line:=TFastLineSeries.Create(ChartVAH);
 for I := Low(X) to High(X) do
   begin
    line.AddXY(X[i], Y[i]);
   end;
 line.Title:=title;
 ChartVAH.AddSeries(line);
 ChartVAH.Repaint;
end;

procedure TFrmVAH.N10Click(Sender: TObject);
begin
 if was_differentiated then
  begin
    ChartVAH.SeriesList.Clear;
    was_differentiated:=false;
  end;
 if OpenDialogCSV.Execute then
    AddSeriesFromFilteredFile(OpenDialogCSV.FileName)
 else MessageDlg('Файл не выбран!',mtInformation,[mbOK],0);
end;

procedure TFrmVAH.N2Click(Sender: TObject);
begin
 Close;
end;

procedure TFrmVAH.N4Click(Sender: TObject);
begin
 ChartVAH.SeriesList.Clear;
 N7.Click;
end;

function TFrmVAH.DifferentiateSeries(series: TChartSeries): TFastLineSeries;
var
 i : integer;
 new_series: TFastLineSeries;
 h1, h2 : Double;
 x,y : Double;
begin
 new_series:=TFastLineSeries.Create(nil);
 new_series.Title:=series.Title;
 //-----понеслась-------------
 h1 := series.XValue[1] - series.XValue[0];
 h2 := series.XValue[2] - series.XValue[1];
// ShowMessage(floattostr(series.XValue[2])+#13#10+floattostr(series.XValue[1])
//  +#13#10+floattostr(series.XValue[0]));
 x := series.XValue[0];
 y := (series.YValue[2] - 2*series.YValue[1] + series.YValue[0]) / (h1 * h2);
 new_series.AddXY(x,y);
 for I := 1 to series.Count - 2 do
  begin
   h1 := series.XValue[i] - series.XValue[i-1];
   h2 := series.XValue[i+1] - series.XValue[i];
   x := series.XValue[i];
   y := (series.YValue[i+1] - 2*series.YValue[i] + series.YValue[i-1]) / (h1 * h2);
   new_series.AddXY(x,y);
  end;
 h1 := series.XValue[series.Count-2] - series.XValue[series.Count-3];
 h2 := series.XValue[series.Count-1] - series.XValue[series.Count-2];
 x := series.XValue[series.Count-1];
 y := (series.YValue[series.Count-1] - 2*series.YValue[series.Count-2] + series.YValue[series.Count-3]) / (h1 * h2);
 new_series.AddXY(x,y);
 //---------------------------
 //new_series.ParentChart:=series.ParentChart;
 Result:=new_series;
end;

procedure TFrmVAH.FormCreate(Sender: TObject);
begin
 was_differentiated:=false;
end;

function TFrmVAH.LoadAndFilterData(filename: string): TStringList;
var
 f: TextFile;
 list: TStringList;
 x_mark, y_mark : string;
 parts: TParam3;
 val, next, proxy : TPointFloat_cl;
 str: string;
begin
 if  not FileExists(filename) then raise Exception.Create('File not found');
 AssignFile(f, filename);
 Reset(f);
 Readln(f, str);
 //--шапка----
 parts := Parse3Params(str);
 x_mark:=parts.var2;
 y_mark:=parts.var3;
 //------сначала с повторениями-----
 list:=TStringList.Create;
 val := TPointFloat_cl.Create;
 next := TPointFloat_cl.Create;
 // первый
 Readln(f,str);
 parts := Parse3Params(str);
 val.x := StrToFloat(parts.var2);
 val.y := StrToFloat(parts.var3);
 while not Eof(f) do
  begin
   Readln(f,str);
   parts := Parse3Params(str);
   next.x := StrToFloat(parts.var2);
   next.y := StrToFloat(parts.var3);
   if next.x > val.x then
     begin
      proxy := TPointFloat_cl.Create;
      proxy.x := val.x;
      proxy.y := val.y;
      list.AddObject(parts.var2, TObject(proxy) );
      val.x := next.x;
      val.y := next.y;
     end;
  end;
 CloseFile(f);
 list.Delete(0);
 Result := list;
end;

procedure TFrmVAH.N6Click(Sender: TObject);
var
 i: integer;
 diffs: array of TFastLineSeries;
begin
 SetLength(diffs, ChartVAH.SeriesCount);
 for I := 0 to ChartVAH.SeriesCount - 1 do
  begin
   diffs[i] := SG_get_second_derivative(ChartVAH.Series[i], 12 );
 //  diffs[i] := SavGolSecondDerivativeSDL(ChartVAH.Series[i], 25);
   diffs[i].Title := ChartVAH.Series[i].Title;
  end;
 ChartVAH.SeriesList.Clear;
 for I := 0 to Length(diffs) - 1 do
  begin
   ChartVAH.AddSeries(diffs[i]);
  end;
 ChartVAH.Repaint;
 was_differentiated := true;
end;

procedure TFrmVAH.N7Click(Sender: TObject);
var
 i: integer;
 list : TStringList;
 fn: string;
begin
 if was_differentiated then
  begin
    ChartVAH.SeriesList.Clear;
    was_differentiated:=false;
  end;
 if OpenDialogCSV.Execute then
  begin
     try
      list := LoadAndFilterData(OpenDialogCSV.FileName);
     except
      MessageDlg('Файл не найден!',mtError,[mbOK],0);
      Exit;
     end;
   fn :=  ExtractFileName(OpenDialogCSV.FileName);
   AddSeries(list, fn);
   //-------Сохраняем чистенькое-------
   Delete(fn,Length(fn)-3, 4);
   SavePointclassList(list,
     ExtractFilePath(OpenDialogCSV.FileName) + fn + ' - filtered.csv' );
   //-------и прибираем за собой----
   for I := 0 to List.Count - 1 do
   begin
     list.Objects[i].Free;
   end;
   list.Clear;
   list.Free;
  end
 else MessageDlg('Файл не выбран!',mtInformation,[mbOK],0);
end;

procedure TFrmVAH.N8Click(Sender: TObject);
begin
 ChartVAH.SeriesList.Clear;
end;

procedure TFrmVAH.N9Click(Sender: TObject);
begin
 ChartVAH.SeriesList.Clear;
 N10.Click;
end;

procedure TFrmVAH.SavePointclassList(list: TStringList; filename : string);
var
 f: TextFile;
 I : integer;
begin
 AssignFile(f, filename);
 Rewrite(f);
 Writeln(f,'CH1,CH2');
 for I := 0 to List.Count - 1 do
   begin
    Writeln(f,TPointFloat_cl(List.Objects[i]).x,',', TPointFloat_cl(List.Objects[i]).y);
   end;
 Closefile(f);
end;


function TFrmVAH.SavGolSecondDerivativeSDL(series: TChartSeries; WindowSize: integer): TFastLineSeries;
var
 i: integer;
 line: TFastLineSeries;
 in_vector, out_vector: TVector;
 N : integer;
begin
 line:=TFastLineSeries.Create(nil);
 in_vector:=TVector.Create(nil);
 out_vector:=TVector.Create(nil);
 N := series.Count;
 in_vector.NrOfElem := N;
 out_vector.NrOfElem := N;
 for I := 0 to N - 1 do
   begin
     in_vector.Elem[i+1] := series.YValue[i];
   end;
 SecondDeriv(in_vector, 1, N, out_vector, WindowSize);
  for I := 0 to N - 1 do
   begin
     line.AddXY(series.XValue[i], out_vector.Elem[i+1]);
   end;
 Result := line;
 
 in_vector.Free;
 out_vector.Free;
end;


procedure TFrmVAH.SDLtrial1Click(Sender: TObject);
var
 i: integer;
 diffs: array of TFastLineSeries;
begin
 SetLength(diffs, ChartVAH.SeriesCount);
 for I := 0 to ChartVAH.SeriesCount - 1 do
  begin
  // diffs[i] := SG_get_second_derivative(ChartVAH.Series[i], 12 );
   diffs[i] := SavGolSecondDerivativeSDL(ChartVAH.Series[i], 25);
   diffs[i].Title := ChartVAH.Series[i].Title;
  end;
 ChartVAH.SeriesList.Clear;
 for I := 0 to Length(diffs) - 1 do
  begin
   ChartVAH.AddSeries(diffs[i]);
  end;
 ChartVAH.Repaint;
 was_differentiated := true;
end;

function TFrmVAH.SG_get_second_derivative(series: TChartSeries; Degree: integer): TFastLineSeries;
 (*
   Смотрел дико кривой исходник на VB, потому здесь тоже будет кривовато.
   В душе пока не ебу, что за CumulativeSmooth такой, википедия в методе
   про такие особенности не говорит. Ещё можно логарифмировать данные на время
   обработки, но это уже точно от лукавого.
   Вроде как для наложения сглаживаний.

   'Degree 2 = 5 point
   'Degree 3 = 7 point ...etc
 *)
var
 SGCoef : array [1..11, 0..13] of integer;
 i, j : integer;
 tempSum : Double;
 temp : array of double;
 smoothed: array of double;
 line: TFastLineSeries;
 N : integer;
 h : Double;
begin
 //----------------------------------
 {$REGION 'Savizky-Golay coefficients'}

  SGCoef[1, 1] := -2;
  SGCoef[1, 2] := -1;
  SGCoef[1, 3] := 2;
  SGCoef[1, 0] := 7;

  SGCoef[2, 1] := -4;
  SGCoef[2, 2] := -3;
  SGCoef[2, 3] := 0;
  SGCoef[2, 4] := 5;
  SGCoef[2, 0] := 42;

  SGCoef[3, 1] := -20;
  SGCoef[3, 2] := -17;
  SGCoef[3, 3] := -8;
  SGCoef[3, 4] := 7;
  SGCoef[3, 5] := 28;
  SGCoef[3, 0] := 462;

  SGCoef[4, 1] := -10;
  SGCoef[4, 2] := -9;
  SGCoef[4, 3] := -6;
  SGCoef[4, 4] := -1;
  SGCoef[4, 5] := 6 ;
  SGCoef[4, 6] := 15;
  SGCoef[4, 0] := 429 ;


  SGCoef[5, 1] := -14;
  SGCoef[5, 2] := -13;
  SGCoef[5, 3] := -10;
  SGCoef[5, 4] := -5;
  SGCoef[5, 5] := 2;
  SGCoef[5, 6] := 11;
  SGCoef[5, 7] := 22;
  SGCoef[5, 0] := 1001 ;

  SGCoef[6, 1] := -56;
  SGCoef[6, 2] := -53;
  SGCoef[6, 3] := -44;
  SGCoef[6, 4] := -29;
  SGCoef[6, 5] := -8;
  SGCoef[6, 6] := 19;
  SGCoef[6, 7] := 52;
  SGCoef[6, 8] := 91;
  SGCoef[6, 0] := 6188;

  SGCoef[7, 1] := -24;
  SGCoef[7, 2] := -23;
  SGCoef[7, 3] := -20;
  SGCoef[7, 4] := -15;
  SGCoef[7, 5] := -8;
  SGCoef[7, 6] := 1;
  SGCoef[7, 7] := 12;
  SGCoef[7, 8] := 25;
  SGCoef[7, 9] := 40;
  SGCoef[7, 0] := 3876;

  SGCoef[8, 1] := -30;
  SGCoef[8, 2] := -29;
  SGCoef[8, 3] := -26;
  SGCoef[8, 4] := -21;
  SGCoef[8, 5] := -14;
  SGCoef[8, 6] := -5;
  SGCoef[8, 7] := 6;
  SGCoef[8, 8] := 19;
  SGCoef[8, 9] := 34;
  SGCoef[8, 10] := 51;
  SGCoef[8, 0] := 6783;

  SGCoef[9, 1] := -110;
  SGCoef[9, 2] := -107;
  SGCoef[9, 3] := -98;
  SGCoef[9, 4] := -83;
  SGCoef[9, 5] := -62;
  SGCoef[9, 6] := -35;
  SGCoef[9, 7] := -2;
  SGCoef[9, 8] := 37;
  SGCoef[9, 9] := 82;
  SGCoef[9, 10] := 133;
  SGCoef[9, 11] := 190;
  SGCoef[9, 0] := 33649;

  SGCoef[10, 1] := -44;
  SGCoef[10, 2] := -43;
  SGCoef[10, 3] := -40;
  SGCoef[10, 4] := -35;
  SGCoef[10, 5] := -28;
  SGCoef[10, 6] := -19;
  SGCoef[10, 7] := -8;
  SGCoef[10, 8] := 5;
  SGCoef[10, 9] := 20;
  SGCoef[10, 10] := 37;
  SGCoef[10, 11] := 56;
  SGCoef[10, 12] := 77;
  SGCoef[10, 0] := 17710;

  SGCoef[11, 1] := -52;
  SGCoef[11, 2] := -51;
  SGCoef[11, 3] := -48;
  SGCoef[11, 4] := -43;
  SGCoef[11, 5] := -36;
  SGCoef[11, 6] := -27;
  SGCoef[11, 7] := -16;
  SGCoef[11, 8] := -3;
  SGCoef[11, 9] := 12;
  SGCoef[11, 10] := 29;
  SGCoef[11, 11] := 48;
  SGCoef[11, 12] := 69;
  SGCoef[11, 13] := 92;
  SGCoef[11, 0] := 26910;

 {$ENDREGION}
 //----------------------------------
 line := TFastLineSeries.Create(nil);

 N:= series.Count;
 SetLength(temp, N );
 SetLength(smoothed, N);

 h := series.XValue[12] - series.XValue[11]; // предположим, шаг равномерный

 for I := Degree to N - Degree - 1 do
  begin
   TempSum := series.YValue[i] * SGCoef[Degree - 1, 1];
   for J := 1 to Degree do
    begin
      TempSum := TempSum + series.YValue[i-j] * SGCoef[Degree - 1, J + 1];
      TempSum := TempSum + series.YValue[i+j] * SGCoef[Degree - 1, J + 1];
    end;
   smoothed[i] := TempSum / SGCoef[Degree - 1, 0];
   smoothed[i] := 2 * smoothed[i] / (h * h);
  end;

 for I := 0 to Degree - 1 do
   begin
    smoothed[i] := smoothed[Degree];
   end;
 for I := N - Degree to N - 1 do
   begin
    smoothed[i] := smoothed[N - Degree - 1];
   end;

 //-------------------------------
 for I := 0 to N - 1 do
  begin
    line.AddXY(series.XValue[i],  smoothed[i]);
  end;
 Result := line;
end;

end.
