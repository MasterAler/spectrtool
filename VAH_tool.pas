unit VAH_tool;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, TeeProcs, TeEngine, Series, Chart, ShellAPI, ShlObj,
  savgol;

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
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N15: TMenuItem;
    SaveDialogCSV: TSaveDialog;
    N14: TMenuItem;
    N16: TMenuItem;
    procedure N2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N16Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AddSeriesFromFilteredFile(filename: string);
    procedure SavePointClassList(list: TStringList; filename: string);
    procedure SaveSeriesPointsCSV(points: TPointVector; filename: string);
    function LoadAndFilterData(filename: string): TStringList;
    procedure AddSeries( X,Y : TDoublrArr; title: string );  overload;
    procedure AddSeries(list: TStringList; title: string); overload;
    function DifferentiateSeries(series: TChartSeries): TFastLineSeries;
    //--- Долбаный Savitzky-Golay, всё-таки побежал----
    function SGFilterAndSecondDerive(series: TChartSeries; window_size: integer = 500; degree: integer = 3; order: integer = 2): TFastLineSeries;
  end;

var
  FrmVAH: TFrmVAH;
  was_differentiated: boolean;
  perc : double;

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

procedure TFrmVAH.N11Click(Sender: TObject);
begin
 if (ChartVAH.SeriesCount > 1) or (ChartVAH.SeriesCount = 0) then
  MessageDlg('Работает только для одной кривой!', mtWarning, [mbOK], 0);
end;

procedure TFrmVAH.N12Click(Sender: TObject);
var
 line: TFastLineSeries;
begin
 if (ChartVAH.SeriesCount > 1) or (ChartVAH.SeriesCount = 0) then Exit;

 line:=TFastLineSeries(ChartVAH.Series[0]);
 while (line.Count > 2) and (line.YValue[line.Count-2] > line.YValue[line.Count-1]) do
  line.Delete(line.Count-1);
end;

procedure TFrmVAH.N13Click(Sender: TObject);
var
 top, bottom, tail: double;
 line: TFastLineSeries;
begin
 if (ChartVAH.SeriesCount > 1) or (ChartVAH.SeriesCount = 0) then Exit;

 line:=TFastLineSeries(ChartVAH.Series[0]);
 top:=line.MaxYValue;
 bottom:=line.MinYValue;
 tail:=  bottom + (top - bottom)*perc;
 while (line.Count > 0) and (line.YValue[0] < tail) do
  line.Delete(0);
end;

procedure TFrmVAH.N14Click(Sender: TObject);
var
 Sperc: string;
begin
 Sperc:=Floattostr(perc);
 if InputQuery('Порог отрезания хвоста','Введите порог (от 0 до 1)',Sperc) then
  MessageDlg('Успешно изменено',mtInformation,[mbOK],0)
 else  MessageDlg('Ввод отменен',mtInformation,[mbOK],0);
 perc:= StrToFloatDef(Sperc, perc);
end;

procedure TFrmVAH.N15Click(Sender: TObject);
var
 i: integer;
 line: TFastLineSeries;
 list: TStringList;
 pt: TPointFloat_cl;
begin
  if (ChartVAH.SeriesCount > 1) or (ChartVAH.SeriesCount = 0) then   Exit;

   if SaveDialogCSV.Execute then
    begin
      line:=TFastLineSeries(ChartVAH.Series[0]);
      list:=TStringList.Create;
      for I := 0 to line.Count - 1 do
       begin
        pt:=TPointFloat_cl.Create;
        pt.x := line.XValue[i];
        pt.y := line.YValue[i];
        list.AddObject(FloatToStr(line.XValue[i]), pt);
       end;
      SavePointClassList(list, SaveDialogCSV.FileName+'.csv');
      list.Free;
    end
  else MessageDlg('Файл не выбран!',mtInformation,[mbOK],0);
end;

procedure TFrmVAH.N16Click(Sender: TObject);
const
 fTag = '_SVD';
var
 i, j : integer;
 points: TPointVector;
 dir: string;
 //--------
 TitleName: string;
 lpItemID: PItemIDList;
 BrowseInfo: TBrowseInfo;
 DisplayName: array[0..MAX_PATH] of char;
begin
 if ChartVAH.SeriesCount = 0 then Exit;
 
 FillChar(BrowseInfo, sizeof(TBrowseInfo), #0);
 BrowseInfo.hwndOwner := Self.Handle;
 BrowseInfo.pszDisplayName := @DisplayName;
 TitleName := 'Выберите папку для сохранения данных';
 BrowseInfo.lpszTitle := PChar(TitleName);
 BrowseInfo.ulFlags := BIF_RETURNONLYFSDIRS;
 lpItemID := SHBrowseForFolder(BrowseInfo);

 if lpItemId = nil {not SelectDirectory('Выберите папку для сохранения данных', GetCurrentDir(), dir )} then
  begin
    MessageDlg('Путь сохранения не выбран!', mtInformation, [mbOK], 0);
    Exit;
  end;

 SetLength(dir, MAX_PATH);
 SHGetPathFromIDList(lpItemID, PChar(dir));
 GlobalFreePtr(lpItemID);
 SetLength(dir, Pos(#0, dir) -1);

 //----------------------
 
 for i := 0 to ChartVAH.SeriesCount - 1 do
   begin
    SetLength(points, ChartVAH.Series[i].Count);
    for j := 0 to ChartVAH.Series[i].Count - 1 do
      begin
        points[j].x := ChartVAH.Series[i].XValue[j];
        points[j].y := ChartVAH.Series[i].YValue[j];
      end;
    SaveSeriesPointsCSV(points, dir + '\' + ChartVAH.Series[i].Title + fTag);
   end;
 MessageDlg('Данные успешно сохранены!', mtInformation, [mbOK], 0);
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
 perc := 0.03;
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
    diffs[i] := SGFilterAndSecondDerive(ChartVAH.Series[i], 500, 3, 2);
 //  diffs[i] := SG_get_second_derivative(ChartVAH.Series[i], 12 );
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
 ChartVAH.Repaint;
end;

procedure TFrmVAH.N9Click(Sender: TObject);
begin
 ChartVAH.SeriesList.Clear;
 N10.Click;
end;

procedure TFrmVAH.SavePointClassList(list: TStringList; filename : string);
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

procedure TFrmVAH.SaveSeriesPointsCSV(points: TPointVector; filename: string);
var
 f: TextFile;
 I : integer;
begin
 AssignFile(f, filename + '.csv');
 Rewrite(f);
 for I := 0 to Length(points) - 1 do
   begin
    Writeln(f, points[i].x, ',',  points[i].y);
   end;
 Closefile(f);
end;

function TFrmVAH.SGFilterAndSecondDerive(series: TChartSeries; window_size,
  degree, order: integer): TFastLineSeries;
var
 i : integer;
 line, newline: TFastLineSeries;
 input: TPointVector;
 output: TDoubleVector;
begin
 line:=TFastLineSeries(series);
 newline:=TFastLineSeries.Create(nil);

 SetLength(input, line.Count);
 for i := 0 to line.Count - 1 do
  begin
    input[i].x := line.XValues[i];
    input[i].y := line.YValues[i];
  end;

 output := ApplySGFilterToData(input, window_size, degree, order);

 newline.Color:=line.Color;
 newline.Title:=line.Title;
 for i := 0 to Length(output) - 1 do
  newline.AddXY(line.XValue[i], output[i]);

 Result := newline;
end;

end.
