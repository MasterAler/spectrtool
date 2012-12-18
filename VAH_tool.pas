unit VAH_tool;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, TeeProcs, TeEngine, Series, Chart,
  savgol, toolUtils;

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
    SaveDialogCSV: TSaveDialog;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N21: TMenuItem;
    procedure N2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure N17Click(Sender: TObject);
    procedure N19Click(Sender: TObject);
    procedure N18Click(Sender: TObject);
    procedure ChartVAHAfterDraw(Sender: TObject);
    procedure ChartVAHMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ChartVAHMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ChartVAHMouseLeave(Sender: TObject);
    procedure ChartVAHMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure N20Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N16Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N21Click(Sender: TObject);
    procedure ChartVAHClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    function GetCut1(): integer;
    function GetCut2(): integer;
    procedure AddSeriesFromFilteredFile(filename: string);
    procedure SavePointClassList(list: TStringList; filename: string);
    function LoadAndFilterData(filename: string): TStringList;
    procedure AddSeries( X,Y : TDoublrArr; title: string );  overload;
    procedure AddSeries(list: TStringList; title: string); overload;
    //--- Долбаный Savitzky-Golay, всё-таки побежал----
    function SGFilterAndSecondDerive(series: TChartSeries; window_size: integer = 500; degree: integer = 3; order: integer = 2): TFastLineSeries;
  end;

var
  FrmVAH: TFrmVAH;
  was_processed: boolean;
  processed : TProcessType;
  //-----------------
  show_cuts: boolean;
  isDraggingCut1, isDraggingCut2 : boolean;
  cut_pos1, cut_pos2 : double;
  prev_xpos: integer;

implementation

uses SpectrCalc;

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
 title: string;
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
 title := ExtractFileName(filename);
 if (Pos('.csv', title)<>0) or (Pos('.CSV', title)<>0) then
   Delete(title, Length(title)-3, 4);
 line.Title := title;
 line.Tag := Integer(ltData);
 line.ParentChart := ChartVAH;
 ChartVAH.Repaint;
end;

procedure TFrmVAH.ChartVAHAfterDraw(Sender: TObject);
var
 x1, x2 : integer;
begin
 if show_cuts then
  begin
   x1:= GetCut1;
   x2:= GetCut2;
   with ChartVAH.Canvas do
    begin
     Pen.Width := 2;
     Pen.Color := clBlue;
     MoveTo(x1, ChartVAH.ChartRect.Top);
     LineTo(x1, ChartVAH.ChartRect.Bottom);
     MoveTo(x2, ChartVAH.ChartRect.Top);
     LineTo(x2, ChartVAH.ChartRect.Bottom);
    end;
  end;
end;

procedure TFrmVAH.ChartVAHClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 if (Button=mbRight) then Series.Free;
end;

procedure TFrmVAH.ChartVAHMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
const
 Eps = 5;
var
 x1, x2 : integer;
begin
 x1:= GetCut1;
 x2:= GetCut2;
 if show_cuts and ( (Abs(X - x1) < Eps) or (Abs(X - x2) < Eps) ) then
  begin
   prev_xpos:= X;
   if Abs(X - x1) < Eps then
    begin
     isDraggingCut1:=true;
     Exit;
    end;
   if Abs(X - x2) < Eps then isDraggingCut2:=true;
   ChartVAH.AllowZoom:=false;
  end;
end;

procedure TFrmVAH.ChartVAHMouseLeave(Sender: TObject);
begin
 isDraggingCut1:=false;
 isDraggingCut2:=false;
 ChartVAH.AllowZoom:=true;
end;

procedure TFrmVAH.ChartVAHMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 if isDraggingCut1 or isDraggingCut2 then
  begin
   if (X > ChartVAH.ChartRect.Right) or (X < ChartVAH.ChartRect.Left) then
    begin
     isDraggingCut1:=false;
     isDraggingCut2:=false;
     ChartVAH.AllowZoom:=true;
     Exit;
    end;
   if (isDraggingCut1)  then
    begin
     cut_pos1 := cut_pos1 + (X - prev_xpos) / (ChartVAH.ChartRect.Right - ChartVAH.ChartRect.Left);
    end;
   if (isDraggingCut2)  then
    begin
     cut_pos2 := cut_pos2 + (X - prev_xpos) / (ChartVAH.ChartRect.Right - ChartVAH.ChartRect.Left);
    end;
   prev_xpos := X;
   ChartVAH.Repaint;
  end;
end;

procedure TFrmVAH.ChartVAHMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 isDraggingCut1:=false;
 isDraggingCut2:=false;
 ChartVAH.AllowZoom:=true;
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
 if was_processed then
  begin
    ChartVAH.SeriesList.Clear;
    was_processed:=false;
    processed := ptNone;
  end;
 if OpenDialogCSV.Execute then
    AddSeriesFromFilteredFile(OpenDialogCSV.FileName)
 else MessageDlg('Файл не выбран!',mtInformation,[mbOK],0);
end;

procedure TFrmVAH.N12Click(Sender: TObject);
var
 i,j: integer;
 res: TLinearCoeffs;
 linearfit: TFastLineSeries;
 x,y: double;
begin
 if ChartVAH.SeriesList.Count = 0 then Exit;

 ClearFastlines(ChartVAH, ltEntire);

 for I := 0 to ChartVAH.SeriesList.Count - 1 do
  begin
   linearfit:=TFastLineSeries.Create(nil);
   res:=CalcLSforCurve(ChartVAH, i);
   for J := 0 to ChartVAH.Series[i].Count - 1 do
    begin
     x:=ChartVAH.Series[i].XValue[J];
     y:=res.A*x+res.B;
     linearfit.AddXY(x,y);
    end;
   linearfit.Tag := Integer(ltEntire); // а вот потому что
   linearfit.Color:=ChartVAH.Series[i].Color;
   linearfit.Pen.Width:=2;
   linearfit.Title:='y=Ax+B; A= '+FloatToStrF(res.A,ffGeneral,4,5)+
     '  B= '+FloatToStrF(res.B,ffGeneral,4,5)+' err= '+FloatToStrF(res.err,ffGeneral,4,5);
   linearfit.ParentChart:=ChartVAH;
  end;
 was_processed:=true;
 processed := ptMNK;
end;

procedure TFrmVAH.N13Click(Sender: TObject);
begin
 FrmMain.SaveChartDialog.FileName:='ChartVAHCurves';
 if FrmMain.SaveChartDialog.Execute then
  begin
   case FrmMain.SaveChartDialog.FilterIndex of
    1: ChartVAH.SaveToBitmapFile(FrmMain.SaveChartDialog.FileName);
    2: ChartVAH.SaveToMetafileEnh(FrmMain.SaveChartDialog.FileName);
    3: ChartVAH.SaveToMetafile(FrmMain.SaveChartDialog.FileName);
    else MessageDlg('Сохранение не произведено!',mtInformation,[mbOK],0);
   end;
  end
 else MessageDlg('Сохранение не произведено!',mtInformation,[mbOK],0);
end;

procedure TFrmVAH.N14Click(Sender: TObject);
const
 Eps = 1E-6;
var
 i, j : integer;
 r_pos: double;
 diffs: array of TFastLineSeries;
 series: TChartSeries;
begin
 if ChartVAH.SeriesCount = 0 then Exit;
 
 if was_processed then
  begin

   SetLength(diffs, ChartVAH.SeriesCount);
   for i := 0 to ChartVAH.SeriesCount - 1 do
     begin
      series := ChartVAH.Series[i];

      j := series.Count - 1;
      while (series.YValue[j] < 0) and (j>0) do
       begin
        series.Delete(j);
        Dec(j);
       end;
      r_pos := series.XValue[j];



      diffs[i] := TFastLineSeries.Create(nil);
      for j := series.Count - 1 downto 0 do
       begin
         diffs[i].AddXY(r_pos - series.XValue[j], series.YValue[j]);
       end;
        
      diffs[i].Title := series.Title;

     end;

   ChartVAH.SeriesList.Clear;
   for I := 0 to Length(diffs) - 1 do
    begin
     ChartVAH.AddSeries(diffs[i]);
    end;

   processed := ptInvert;
  end;
end;

procedure TFrmVAH.N16Click(Sender: TObject);
const
 fTag = '_SVD';
begin
 if ChartVAH.SeriesCount = 0 then Exit;

 SaveSeriesToCSVs(ChartVAH, fTag);
end;

procedure TFrmVAH.N17Click(Sender: TObject);
var
 i: integer;
 diffs: array of TFastLineSeries;
begin
 if ChartVAH.SeriesList.Count = 0 then Exit;
 
 SetLength(diffs, ChartVAH.SeriesCount);
 for I := 0 to ChartVAH.SeriesCount - 1 do
  begin
    diffs[i] := SGFilterAndSecondDerive(ChartVAH.Series[i], 500, 3, 1);
    diffs[i].Title := ChartVAH.Series[i].Title;
  end;
 ChartVAH.SeriesList.Clear;
 for I := 0 to Length(diffs) - 1 do
  begin
   ChartVAH.AddSeries(diffs[i]);
  end;
 ChartVAH.Repaint;
 was_processed := true;
 processed := ptDiff1;
end;

procedure TFrmVAH.N18Click(Sender: TObject);
begin
 N18.Checked := not N18.Checked;
 show_cuts:= not show_cuts;
 ChartVAH.View3D:= not show_cuts;
 N19.Checked:= show_cuts;
 ChartVAH.Repaint;
end;

procedure TFrmVAH.N19Click(Sender: TObject);
begin
 N19.Checked:= not N19.Checked;
 ChartVAH.View3D:= not ChartVAH.View3D;
end;


procedure TFrmVAH.N20Click(Sender: TObject);
var
 i : integer;
 x_left, x_right: double;
 tmp : double;
begin
 if (ChartVAH.SeriesCount = 0) or (not show_cuts)  then Exit;

 //для порядка
 if cut_pos1 > cut_pos2 then
  begin
    tmp:=cut_pos1;
    cut_pos1 := cut_pos2;
    cut_pos2 := tmp;
  end;

 x_left := ChartVAH.BottomAxis.CalcPosPoint(GetCut1);
 x_right := ChartVAH.BottomAxis.CalcPosPoint(GetCut2);

 for I := 0 to ChartVAH.SeriesCount - 1 do
  begin
    while ChartVAH.Series[i].XValue[0] < x_left do
     ChartVAH.Series[i].Delete(0);

    while ChartVAH.Series[i].XValue[ChartVAH.Series[i].Count-1] > x_right do
     ChartVAH.Series[i].Delete(ChartVAH.Series[i].Count-1);
  end;

 cut_pos1:=0;
 cut_pos2:=1;
 ChartVAH.Repaint;
end;

procedure TFrmVAH.N21Click(Sender: TObject);
const
 SCurve: array [1..33, 1..2] of real =
 (
(9,	0),
(10, 1.87),
(12.5, 7.33),
(15,	9.19),
(17.5,	9.32),
(20 ,	9.11) ,
(22.5,	8.45),
(25,	7.97),
(27.5,	7.67),
(30,	7.45),
(35,	6.98),
(40,	6.63),
(50,	6.03),
(60,	5.66),
(70,	5.35),
(80,	5.08),
(90,	4.83),
(100,	4.64),
(120,	4.32),
(140,	4 ),
(170,	3.64 ),
(200,	3.39),
(250,	2.97),
(300,	2.66),
(350,	2.4 ),
(400,	2.24 ),
(450,	2.06),
(500,	1.96),
(600,	1.79),
(700,	1.58 ),
(800,	1.49 ),
(900,	1.31),
(1000,	1.21)
 );
var
 i, j: integer;
 line : TFastLineSeries;
 sr: TChartSeries;
 y_norm_coeff: double;
 x_max: double;
begin
 if (ChartVAH.SeriesCount = 0) or (not was_processed) then Exit;

 //В плоском виде гораздо нагляднее
 ChartVAH.View3D := false;
 N19.Checked := false;

 line:=TFastLineSeries.Create(nil);
 line.Title:= 'Theory';
 line.Color:= clBlue;
 line.Pen.Width :=3;
 for i := 1 to 33 do
    line.AddXY(SCurve[i,1], SCurve[i, 2]);

 x_max:=ChartVAH.Series[0].MaxXValue;
 for i := 0 to ChartVAH.SeriesCount - 1 do
  begin
   sr := ChartVAH.Series[i];
   y_norm_coeff := line.MaxYValue / sr.MaxYValue;
   for j := 0 to sr.Count - 1 do
     sr.YValues[j] := sr.YValues[j] * y_norm_coeff;

   if sr.MaxXValue > x_max then x_max := sr.MaxXValue;
  end;

 while line.XValue[line.Count-2] > x_max do
      line.Delete(line.Count-1);

 ChartVAH.AddSeries(line);
 ChartVAH.Repaint;

 was_processed:=true;
 // Не обязательно, скорее напоминалка, что такая не стоит при двойном дифференцировании
 processed:=ptTheory;
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

procedure TFrmVAH.FormCreate(Sender: TObject);
begin
 was_processed:=false;
 processed := ptNone;
 show_cuts:=false;
 isDraggingCut1:=false;
 isDraggingCut2:=false;
 cut_pos1:=0.1;
 cut_pos2:=0.9;
end;

function TFrmVAH.GetCut1: integer;
begin
 Result:= Round(ChartVAH.ChartRect.Left +
    cut_pos1 * (ChartVAH.ChartRect.Right - ChartVAH.ChartRect.Left));
end;

function TFrmVAH.GetCut2: integer;
begin
 Result:= Round(ChartVAH.ChartRect.Left +
    cut_pos2 * (ChartVAH.ChartRect.Right - ChartVAH.ChartRect.Left));
end;

function TFrmVAH.LoadAndFilterData(filename: string): TStringList;
{ Написано через ОЧЕНЬ кривую жопу, но пусть работает
   нормально для начала}
var
 f : TextFile;
 list: TStringList;
 x_mark, y_mark : string;
 parts: TParam3;
 val, next, proxy : TPointFloat_cl;
 str: string;
 t_min, t_max, x_min, x_max : Double;
 xx, tt: Double;
begin
 if  not FileExists(filename) then raise Exception.Create('File not found');
 AssignFile(f, filename);


 //-----Ищем габариты----
 Reset(f);
 Readln(f, str); //шапка
 Readln(f, str);
 parts := Parse3Params(str);
 tt := strtofloat(parts.var1);
 t_min := tt;
 t_max := tt;
 x_min := strtofloat(parts.var2);
 x_max := strtofloat(parts.var2);
 while not Eof(f) do
  begin
   Readln(f, str);
   parts := Parse3Params(str);
   xx := strtofloat(parts.var2);
   tt := strtofloat(parts.var1);
   if (xx > x_max) then
    begin
     t_max:=tt;
     x_max:=xx;
    end;
   if (xx < x_min) then
    begin
     t_min:=tt;
     x_min:=xx;
    end;
  end;
 CloseFile(f);
 //----------------------

 Reset(f);
 Readln(f, str);
 //---шапка----
 parts := Parse3Params(str);
 x_mark:=parts.var2;
 y_mark:=parts.var3;
 //------сначала с повторениями-----
 list:=TStringList.Create;
 val := TPointFloat_cl.Create;
 next := TPointFloat_cl.Create;
 // первый
 repeat
   Readln(f,str);
   parts := Parse3Params(str);
   val.x := StrToFloat(parts.var2);
   val.y := StrToFloat(parts.var3);
 until (StrToFloat(parts.var1) >= t_min);

 while not Eof(f) do
  begin
   Readln(f,str);
   parts := Parse3Params(str);
   next.x := StrToFloat(parts.var2);
   next.y := StrToFloat(parts.var3);
   if(StrToFloat(parts.var1)>= t_max) then Break;

    proxy := TPointFloat_cl.Create;
    proxy.x := val.x;
    proxy.y := val.y;
    list.AddObject(floattostr(val.x), TObject(proxy) );
    val.x := next.x;
    val.y := next.y;

  end;
 CloseFile(f);
 
 Result := list;
end;

procedure TFrmVAH.N6Click(Sender: TObject);
var
 i: integer;
 diffs: array of TFastLineSeries;
begin
 if ChartVAH.SeriesList.Count = 0 then Exit;

 SetLength(diffs, ChartVAH.SeriesCount);
 for I := 0 to ChartVAH.SeriesCount - 1 do
  begin
    diffs[i] := SGFilterAndSecondDerive(ChartVAH.Series[i], 500, 3, 2);
    diffs[i].Title := ChartVAH.Series[i].Title;
  end;
 ChartVAH.SeriesList.Clear;
 for I := 0 to Length(diffs) - 1 do
  begin
   ChartVAH.AddSeries(diffs[i]);
  end;
 ChartVAH.Repaint;
 was_processed := true;
 processed := ptDiff2;
end;

procedure TFrmVAH.N7Click(Sender: TObject);
var
 i: integer;
 list : TStringList;
 fn: string;
begin
 if was_processed then
  begin
    ChartVAH.SeriesList.Clear;
    was_processed:=false;
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
   if (Pos('.csv', fn)<>0) or (Pos('.CSV', fn)<>0) then
     Delete(fn, Length(fn)-3, 4);
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
   processed := ptNone;
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
