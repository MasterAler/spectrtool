unit VAH_tool;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, TeeProcs, TeEngine, Series, Chart;

type
    Tparam3 = record
      var1, var2, var3: string;
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
    SaveDialogCSV: TSaveDialog;
    procedure N2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AddSeries( X,Y : TDoublrArr; title: string );
    function CountTextFileLength(filename: string) : integer;
    function DifferentiateSeries(series: TChartSeries): TFastLineSeries;
  end;

var
  FrmVAH: TFrmVAH;

implementation

{$R *.dfm}

function TFrmVAH.CountTextFileLength(filename: string) : integer;
var
 f : TextFile;
 N : integer;
begin
 if not FileExists(filename) then
   begin
     Result:=-1;
     Exit;
   end;
 AssignFile(f, filename);
 Reset(f);
 N := 0;
 while not Eof(f) do
  begin
    Readln(f); Inc(N);
  end;
 CloseFile(f);
 Result := N;
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

procedure TFrmVAH.N6Click(Sender: TObject);
var
 i: integer;
 diffs: array of TFastLineSeries;
begin
 SetLength(diffs, ChartVAH.SeriesCount);
 for I := 0 to ChartVAH.SeriesCount - 1 do
  begin
   diffs[i] := DifferentiateSeries(ChartVAH.Series[i]);
  end;
 ChartVAH.SeriesList.Clear;
 for I := 0 to Length(diffs) - 1 do
  begin
   ChartVAH.AddSeries(diffs[i]);
  end;
 ChartVAH.Repaint;
end;

procedure TFrmVAH.N7Click(Sender: TObject);
var
 f: TextFile;
 str: string;
 parts: Tparam3;
 Xarr, Yarr : TDoublrArr;
 n, k: integer;
begin
 if OpenDialogCSV.Execute then
  begin
   n := CountTextFileLength(OpenDialogCSV.FileName);
   SetLength(Xarr, n-1);
   SetLength(Yarr, n-1);
   AssignFile(f, OpenDialogCSV.FileName);
     try
      Reset(f);
      try
        Readln(f,str);
        parts := Parse3Params(str);
        ChartVAH.LeftAxis.Title.Caption := parts.var2;
        ChartVAH.BottomAxis.Title.Caption := parts.var3;
        k := 0;
        while not Eof(f) do
         begin
          Readln(f, str);
          parts := Parse3Params(str);
          Xarr[k]:=StrToFloatDef(parts.var2, k);
          Yarr[k]:=StrToFloatDef(parts.var3, 0);
          Inc(k);
         end;
        AddSeries(Xarr, Yarr, ExtractFileName(OpenDialogCSV.FileName) );
      except
       MessageDlg('Что-то не так с файлом!',mtError,[mbOK],0);
      end;
     finally
      CloseFile(f);
     end;
  end
 else MessageDlg('Файл не выбран!',mtInformation,[mbOK],0);
end;

procedure TFrmVAH.N8Click(Sender: TObject);
begin
 ChartVAH.SeriesList.Clear;
end;

procedure TFrmVAH.N9Click(Sender: TObject);
var
 list: TStringList;
 i: integer;
 f,g : TextFile;
 str: string;
 key, value : string;
begin
 if OpenDialogCSV.Execute then
  begin
   if SaveDialogCSV.Execute then
    begin
     AssignFile(f,OpenDialogCSV.FileName);
     AssignFile(g, SaveDialogCSV.FileName+'.csv');
     if LowerCase(OpenDialogCSV.FileName) = LowerCase(SaveDialogCSV.FileName) then
       begin
        MessageDlg('Не выбирайте тот же файл!',mtWarning,[mbOK],0);
       end;
     Reset(f);
     Rewrite(g);
     list:=TStringList.Create;
     list.Duplicates:=dupIgnore;
     //list.Sorted:=true;
     Readln(f,str);
     Writeln(g,str);
     try
       while not Eof(f) do
        begin
         Readln(f,str);
         Delete(str,1,Pos(',',str));
         key := Copy(str,1, Pos(',',str) -1);
         Delete(str,1, Pos(',',str));
         value := str;
         list.Values[key]:=value
      //   list.AddObject(key, TObject(value));
        end;
        for I := 0 to List.Count - 1 do
         Writeln(g, i+1, ',', List.Names[i],',',List.ValueFromIndex[i]);
     finally
      list.Free;
     end;
     CloseFile(f);
     CloseFile(g);
    end
   else MessageDlg('Файл не выбран!',mtInformation,[mbOK],0);
  end
 else MessageDlg('Файл не выбран!',mtInformation,[mbOK],0);
end;

end.
