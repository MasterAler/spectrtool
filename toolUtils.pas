unit toolUtils;

interface

uses
 Windows, Dialogs, SysUtils, Variants, Classes, ShellAPI, ShlObj, Math,
  TeeProcs, TeEngine, Chart, Series, ap, lsfit, savgol ;

const
 ERROR_DIR = '#?:ERROR_DIR:?#';
type
  TLineType = (ltAll = -1, ltHot = 3, ltEntire = 9, ltStantard = 12, ltData = 15 );
  TProcessType = (ptNone = -1, ptMNK, ptDiff1, ptDiff2, ptInvert, ptTheory);
  TNumInterval = record
    _from: integer;
    _to: integer;
  end;
  TPointArr = array of TPointFloat;
  TLinearCoeffs = record
     A,B: double;
     err: double;
  end;

function SelectFolder(parent: THandle = 0): string;
procedure SaveSeriesToCSVs(chart: TChart; ftag: string = '');
procedure SaveSeriesPointsCSV(points: TPointVector; filename: string; fTag: string = '_SVD');
procedure ClearFastlines(chart: TChart; tag : TLineType = ltAll);
function CalcLSforData(data : TPointArr):TLinearCoeffs;
function SeriesToPointArr(series: TChartSeries): TPointArr;
function SeriesPartToPointArr(series: TChartSeries; left, right: integer): TPointArr;
//обертки
function CalcLSforCurve(chart: TChart; seriesnum: integer): TLinearCoeffs;
function CalcLSforCurvePart(chart: TChart; seriesnum, left, right: integer): TLinearCoeffs;

implementation


procedure ClearFastlines(chart: TChart; tag : TLineType = ltAll);
  {
   Защищает от многократных нажатий на обработки кривых,
   график не засоряется,а пересчитывается. Сходу хрен поймешь, но
   идея в том, что данные - это TLineSeries, а МНК - TFastLineSeries.
   Для разных МНК придется обходиться опознавательными значениями Tag.
  }
var
 b : boolean;
 k: integer;
begin
 b:=false; k:=0;
 if tag=ltAll then
  begin
   //--------
   while not b do
    begin
     if (chart.Series[k] is TFastLineSeries) then
      begin
       chart.SeriesList.Delete(k);
       k:=0;
      end;
     Inc(k);
     if (k=chart.SeriesList.Count) then b:=true;
    end;
   //-----------
  end
 else
  begin
  //-----
   while not b do
    begin
     if (chart.Series[k] is TFastLineSeries) and (chart.Series[k].Tag = Integer(tag) ) then
      begin
       chart.SeriesList.Delete(k);
       k:=0;
      end;
     Inc(k);
     if (k=chart.SeriesList.Count) then b:=true;
    end;
   //---------
  end;
end;

function CalcLSforData(data: TPointArr): TLinearCoeffs;
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
begin
 if (Length(data) <= 0) then Exit;

 M := 2;
 N := Length(data);

 SetLength(Y, N);
 SetLength(FMatrix, N, M);
 I:=0;
 while I<=N-1 do
  begin
   X :=  data[i].X;
   Y[I] := data[i].Y;
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

function SeriesToPointArr(series: TChartSeries): TPointArr;
var
 res: TPointArr;
 i: integer;
begin
 SetLength(res, series.Count);
 for I := 0 to series.Count - 1 do
  begin
    res[i].X := series.XValue[i];
    res[i].Y := series.YValue[i];
  end;
 Result:=res;
end;

function SeriesPartToPointArr(series: TChartSeries; left,
  right: integer): TPointArr;
var
 res: TPointArr;
 i: integer;
begin
 Result := nil;
 if (left > right) or (left <= 0) or (right > series.Count)  then Exit;

 SetLength(res, right - left + 1);
  for I := left to right do
  begin
    res[i - left].X := series.XValue[i-1];
    res[i - left].Y := series.YValue[i-1];
  end;
 Result:=res;
end;

function CalcLSforCurve(chart: TChart; seriesnum: integer): TLinearCoeffs;
begin
 if (seriesnum<0) or (seriesnum>=chart.SeriesList.Count) then Exit;

 Result := CalcLSforData( SeriesToPointArr(chart.Series[seriesnum]) );
end;

function CalcLSforCurvePart(chart: TChart; seriesnum, left, right: integer): TLinearCoeffs;
{
  Ахтунг!! считается, что на графике значащих точек по числу пиков,
  отсчитываем их по штукам, без операций с координатами.
  Нумерация от 1 начинается.
}
begin
 if (seriesnum < 0) or (seriesnum >= chart.SeriesList.Count)
  or (left > right) or (left <= 0) or (right > chart.Series[seriesnum].Count)
    then raise Exception.Create('bad borders');

 Result := CalcLSforData( SeriesPartToPointArr(chart.Series[seriesnum], left, right) );
end;

procedure SaveSeriesPointsCSV(points: TPointVector; filename: string; fTag: string = '_SVD');
var
 f: TextFile;
 I : integer;
begin
 AssignFile(f, filename + fTag + '.csv');
 Rewrite(f);
 for I := 0 to Length(points) - 1 do
   begin
    Writeln(f, points[i].x, ',',  points[i].y);
   end;
 Closefile(f);
end;

function SelectFolder(parent: THandle = 0): string;
var
 dir: string;
 TitleName: string;
 lpItemID: PItemIDList;
 BrowseInfo: TBrowseInfo;
 DisplayName: array[0..MAX_PATH] of char;
begin
 FillChar(BrowseInfo, sizeof(TBrowseInfo), #0);
 BrowseInfo.hwndOwner := parent;
 BrowseInfo.pszDisplayName := @DisplayName;
 TitleName := 'Выберите папку для сохранения данных';
 BrowseInfo.lpszTitle := PChar(TitleName);
 BrowseInfo.ulFlags := BIF_RETURNONLYFSDIRS;
 lpItemID := SHBrowseForFolder(BrowseInfo);

 if lpItemId = nil then
  begin
    Result:=ERROR_DIR;
    Exit;
  end;

 SetLength(dir, MAX_PATH);
 SHGetPathFromIDList(lpItemID, PChar(dir));
 GlobalFreePtr(lpItemID);
 SetLength(dir, Pos(#0, dir) -1);

 Result:=dir;
end;

procedure SaveSeriesToCSVs(chart: TChart; ftag: string = '');
var
 i, j : integer;
 points: TPointVector;
 dir: string;
begin

 dir:=SelectFolder;

 if dir = ERROR_DIR then
  begin
   MessageDlg('Не выбрана папка для сохранения файлов!', mtInformation, [mbOK], 0);
   Exit;
  end;
 

 for i := 0 to chart.SeriesCount - 1 do
   begin
    SetLength(points, chart.Series[i].Count);
    for j := 0 to chart.Series[i].Count - 1 do
      begin
        points[j].x := chart.Series[i].XValue[j];
        points[j].y := chart.Series[i].YValue[j];
      end;
    SaveSeriesPointsCSV(points, dir + '\' + chart.Series[i].Title, fTag);
   end;

 MessageDlg('Данные успешно сохранены!', mtInformation, [mbOK], 0);
end;

end.
