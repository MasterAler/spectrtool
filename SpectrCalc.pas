unit SpectrCalc;

interface

{
  К черту хороший стиль, утилита пишется раз и надолго, для подручных средств.
  Программирование на уровне структурного для существенных блоков кода,
  остальное - по обработчикам. При желании можно вынести логику, но главное -
  обработка работы с графиками. Здесь везде удобные фишки куда важнее стиля.
}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ExtCtrls, TeeProcs, TeEngine, Chart, StdCtrls,
  Grids, ValEdit, ShellAPI, Series, ExtDlgs, CalcCurve, Settings, Chooser, Contnrs, XPMan;

const
 TableFile='TableValues.txt';
 SettingFile='Coeffs.txt';
 CHMHelpFile='\SpectrHelp.chm';
 AddColSign=' +';
 StatActionArray: array [1..1] of string[7] = ('Average');
 //список команд статистики можно расширять
type
    TVLEDragType=(vleFrom,vleTo,vleNone);
    PeakPos=packed record
     x,y: real;
    end;
    CurvePeaks=record
     points: array of PeakPos;
     Title: string;
     color: TColor;
    end;
    PeakData=record
     MaxList: TStringList;
     ID: integer;
    end;
    PFastLineSeries= ^TFastLineSeries;
    PPeakData= ^PeakData;
    PCurvePeaks= ^CurvePeaks;
    //---------------------------
     TSortPair=record
      key: integer;
      row: TStringList;
     end;
     PSortPair=^TSortPair;
  TFrmMAIN = class(TForm)
    MainMenu: TMainMenu;
    Af1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    OpenFileDialog: TOpenDialog;
    StatusMain: TStatusBar;
    N8: TMenuItem;
    Panel1: TPanel;
    ChartOut: TChart;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    SaveChartDialog: TSavePictureDialog;
    N14: TMenuItem;
    N15: TMenuItem;
    SaveDataDialog: TSaveDialog;
    N16: TMenuItem;
    N17: TMenuItem;
    Panel2: TPanel;
    Separator: TSplitter;
    N18: TMenuItem;
    SGStats: TStringGrid;
    PopupMenuStats: TPopupMenu;
    N19: TMenuItem;
    N20: TMenuItem;
    ValueListSpectr: TValueListEditor;
    N21: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    Origin1: TMenuItem;
    N24: TMenuItem;
    Origin2: TMenuItem;
    procedure N1Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure ValueListSpectrValidate(Sender: TObject; ACol, ARow: Integer;
      const KeyName, KeyValue: String);
    procedure ValueListSpectrEditButtonClick(Sender: TObject);
    procedure ValueListSpectrKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure ChartOutClickLegend(Sender: TCustomChart;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure N10Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure ChartOutClickSeries(Sender: TCustomChart;
      Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N13Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure N15Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N17Click(Sender: TObject);
    procedure N16Click(Sender: TObject);
    procedure N18Click(Sender: TObject);
    procedure SGStatsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure N20Click(Sender: TObject);
    procedure N19Click(Sender: TObject);
    procedure ValueListSpectrDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure ValueListSpectrMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ChartOutMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure N21Click(Sender: TObject);
    procedure ValueListSpectrMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ValueListSpectrMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure SGStatsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N22Click(Sender: TObject);
    procedure N23Click(Sender: TObject);
    procedure OpenFileDialogTypeChange(Sender: TObject);
    procedure Origin1Click(Sender: TObject);
    procedure N24Click(Sender: TObject);
    procedure SGStatsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Origin2Click(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateNums();
    procedure LoadDataFromTxt(filename : string);
    procedure LoadDataFromSpectrs(filename : string);
    //procedure AddSeries();
    function  GenerateColor(Color:TColor):TColor;
    procedure LoadTableValues();
    procedure SaveTableValues();
    procedure ClearMarkData();
    procedure ClearPeakData();
    procedure FindPeakValues();
    procedure UpdateSpectrStats();
    procedure FillCombo();
    procedure CheckStatsValid();
    procedure CMMouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
  public
    { Public declarations }
   procedure OnGetMarkText(Sender: TChartSeries; ValueIndex: Integer; var MarkText: String);
   procedure ComboNChange(Sender: TObject);
   procedure ComboNExit(Sender: TObject);
  end;

var
  FrmMAIN: TFrmMAIN;
  NextColor: TColor;
  delta : double;
  MarkList: TList;    // хранит PeakData, по этому можно расставить метки над пиками
  PeakList: TList;    // хранит CurvePeaks, по этому можно строить кривые
  s_tag : integer;
  K_first: single;
  GridComboN: TComboBox;
  mFrom,mTo : integer;
  TraceChart: boolean;
  isVLEdragging: boolean;
  //кривой избыточный костыль, но так понятнее, где
  //таскание и его проверки выглядят оптимальнее
  VLEdrag: TVLEDragType; //чего тащим
  vlePrevPos: integer;
  NAddStats: integer;
  //------------------------------
  //-------Буферные переменные----
  statTypeData: string;
  //------------------------------
  HRow,HCol : integer;

implementation

{
    Ну да, если бы я не был ленивым мудилой, то отнаследовался бы в компонентах,
    добавил туда методы, а логику вынес в человеческие классы и события...но увы,
    изначально многое из функционала не подразумевалось, да и делается по-прежнему
    на один раз, пускай пока так остается, а то Афонин О.Н. не дождется софта))
}

uses Math, IniFiles, TeCanvas, SpectrsReader;

{$R *.dfm}

procedure TFrmMAIN.LoadDataFromSpectrs(filename: string);
var
 i,j,k : integer;
 reader: TSpectrsReader;
 iCurveInfo: TCurveInfo;
 x,y: real;
 line : TFastLineSeries;
begin
 reader:=TSpectrsReader.Create;
try
 reader.Read(filename);
 for i:=0 to reader.CurveCount-1 do
  begin
   iCurveInfo:=reader.GetCurveInfo(i);
   //------непосредственно добавление точек-------------
   for k:=0 to Length(iCurveInfo.PointsData.YValues)-1 do
    begin
     line:=TFastLineSeries.Create(nil);
     line.Clear;
     line.Title:=iCurveInfo.AttributeText;
     for j:=0 to Length(iCurveInfo.PointsData.XValues)-1 do
      begin
        x:=iCurveInfo.PointsData.XValues[j];
        y:=iCurveInfo.PointsData.YValues[k][j];
        line.AddXY(x,y);
      end;
     line.Marks.Visible:=true;
     line.OnGetMarkText:=OnGetMarkText;
     line.Marks.Font.Size:=8;
     line.Tag:=s_tag;
     Inc(s_tag);
     line.ParentChart:=ChartOut;
     if (line.Color=clWhite) then line.Color:=clBlack;
     if (line.Color=clBlack) and (line.Tag>0) then line.Color:=GenerateColor(line.Color);
    end;
   //---------------------------------------------------
  end;
finally
 reader.Free;
 ChartOut.Repaint;
end;
end;

procedure TFrmMAIN.CMMouseLeave(var Msg: TMessage);
begin
  if (Msg.LParam = Integer(ValueListSpectr)) then
   if isVLEdragging then
    begin
     if (VLEdrag=vleFrom) then mFrom:=vlePrevPos
      else mTo:=vlePrevPos;
     isVLEdragging:=false;
     vlePrevPos:=-1;
     VLEdrag:=vleNone;
     ValueListSpectr.Invalidate;
    end;
end;

//----------------------Combo handlers-----------------------------------------
procedure TFrmMAIN.ComboNChange(Sender: TObject);
begin
 if (PeakList.Count=0) then Exit; 
 SGStats.Cells[0,SGStats.RowCount-1]:=GridComboN.Items[GridComboN.ItemIndex];
 GridComboN.Visible:=false;
 SGStats.SetFocus;
end;

procedure TFrmMAIN.ComboNExit(Sender: TObject);
begin
 if (PeakList.Count=0) then Exit;
 SGStats.Cells[0,SGStats.RowCount-1]:=GridComboN.Items[GridComboN.ItemIndex];
 GridComboN.Visible:=false;
 SGStats.SetFocus;
 SGStats.RowCount:=SGStats.RowCount+1;
 UpdateSpectrStats;
end;

procedure TFrmMAIN.FillCombo();
var
 i: integer;
begin
 GridComboN.Items.Clear;
 for i:=mFrom to mTo do
   GridComboN.Items.Add(inttostr(i));
end;
//-----------------------------------------------------------------------------

procedure TFrmMAIN.CheckStatsValid();
var
 i,j: integer;
 val: integer;
begin
 if (SGStats.Cells[0,1]='') then Exit;
 i:=1;
 while (i<SGStats.RowCount-1) do
  begin
   val:=StrToInt(SGStats.Cells[0,i]);
   if not (val in [mFrom..mTo]) then
    begin
     for j:=i to SGStats.RowCount-1 do
      SGStats.Rows[j]:=SGStats.Rows[j+1];
     SGStats.RowCount:=SGStats.RowCount-1;
    end
   else Inc(i);
  end;
end;

function RowAverage(row: TStrings; datalen: integer): real;
var
 i: integer;
 avg: real;
begin
 avg:=0;
 for i:=1 to datalen do
   avg:= avg+StrToFloat(row[i]);
 avg:=avg / datalen;
 Result:=avg;
end;

procedure ParseSimpleFormula(formula: string; var A,B:integer; var K: real);
var                 // simpleformula -  K*[A]/[B]
 ps: Smallint;
 buf: string;
begin
 ps:=Pos('[',formula);
 buf:=Copy(formula,1,ps-2);
 K:=StrToFloat(buf);
 //---
 Delete(formula,1,ps);
 ps:=Pos(']',formula);
 buf:=Copy(formula,1,ps-1);
 A:=StrToInt(buf);
 //---
 ps:=Pos('[',formula);
 Delete(formula,1,ps);
 ps:=Pos(']',formula);
 buf:=Copy(formula,1,ps-1);
 B:=StrToInt(buf);
end;

procedure TFrmMAIN.UpdateSpectrStats();
var
 i,j,l: integer;
 curp: PCurvePeaks;
 n_ln : integer;
 actionstring: string;
 a_i: integer;
 aval,bval,k: real;
 a,b : integer;
begin
 if (PeakList.Count=0) or (SGStats.Cells[0,1]='') then Exit;
 SGStats.ColCount:=PeakList.Count+2+NAddStats;
 SGStats.Cells[SGStats.ColCount-1,0]:=AddColSign;
 for i:=0 to PeakList.Count-1 do
  begin
   curp:=PeakList[i];
   //SGStats.Cells[i+1,0]:=curp^.Title;
   SGStats.Cells[i+1,0]:='   ['+inttostr(i+1)+']';
   for j:=1 to SGStats.RowCount-2 do
    begin
     n_ln:=strtoint(SGStats.Cells[0,j]);
     //floattostrf(curp^.points[n_ln-1].y,ffGeneral,1,10)
     SGStats.Cells[i+1,j]:=inttostr(Round(curp^.points[n_ln-1].y));
    end;
  end;
 //-----------Заполнение колонок статистики-----------------
 //Система на данный момент с захардкоденными case-ветками, вариантов обрабатываемых
 //действий ибо совсем мало и не ясно, будуь ли ещё
 for i:=PeakList.Count+1 to SGStats.ColCount-2 do  //Для каждого стат-столбика
  begin
     //Ищем команду
     a_i:=-1;
     actionstring:=Trim(SGStats.Cells[i,0]);
     for l:=Low(StatActionArray) to High(StatActionArray) do
      if (actionstring=StatActionArray[l]) then
       begin
        a_i:=l; Break;
       end;
   for j:=1 to SGStats.RowCount-2 do   //По строчкам, кроме последней
    begin
     //Варианты
     case a_i of
      1:  //Average
       begin
        SGStats.Cells[i,j]:=IntToStr(Round(RowAverage(SGStats.Rows[j],SGStats.ColCount-NAddStats-2)));
       end;
      else // Formula
       begin
        ParseSimpleFormula(actionstring,a,b,k);
        aval:=strtofloat(SGStats.Cells[a,j]);
        bval:=strtofloat(SGStats.Cells[b,j]);
        if bval<MinSingle then SGStats.Cells[i,j]:='NaN'
        //Если  формула усложнится, проверку заменить на try-except
        //Сравнивать real с нулем напрямую очкую :))
        else SGStats.Cells[i,j]:=FloatToStrF(k*aval/bval,ffGeneral,5,10);
       end;
     end;
       //----Конец перебора строчек----
    end;
   //----Конец перебора столбиков----
  end;
end;

procedure TFrmMAIN.FindPeakValues();
var
 i,j,k : integer;
 lst: TStringList;
 line: TFastLineSeries;
 poses: PCurvePeaks;
begin
   PeakList.Clear;
   for i:=0 to MarkList.Count-1 do
    begin
     for j:=0 to ChartOut.SeriesList.Count-1 do
      begin
       line := TFastLineSeries(ChartOut.SeriesList[j]);
       if (line.Tag=PPeakData(MarkList[i])^.ID) then
        begin
          lst:=PPeakData(MarkList[i])^.MaxList;
          if lst=nil then continue;

          New(poses);
          poses^.title:=line.Title;
          poses^.color:=line.LinePen.Color;
          SetLength(poses^.points,lst.Count);

          for k:=0 to lst.Count-1 do
           begin
            poses^.points[k].x:=line.XValue[strtoint(lst[k])];
            poses^.points[k].y:=line.YValue[strtoint(lst[k])];
           end;

          PeakList.Add(poses);

        end;
      end;
    end;
end;

procedure TFrmMAIN.ClearMarkData;
var
 i:integer;
begin
 for i:=0 to MarkList.Count-1 do
  begin
   PPeakData(MarkList[i])^.MaxList.Free;
   Dispose(MarkList.Items[i]);
  end;
 MarkList.Clear;
end;

procedure TFrmMAIN.ClearPeakData;
var
 i:integer;
begin
 for i:=0 to PeakList.Count-1 do
  begin
   SetLength(PCurvePeaks(PeakList.Items[i])^.points,0);
   Dispose(PCurvePeaks(PeakList.Items[i]));
  end;
 PeakList.Clear;
end;

procedure TFrmMAIN.SaveTableValues;
var
 f:TextFile;
 i: integer;
begin
 AssignFile(f,TableFile);
 Rewrite(f);
 for i:=1 to ValueListSpectr.RowCount-1 do
  begin
   Writeln(f,ValueListSpectr.Cells[1,i]);
  end;
 CloseFile(f);
end;

procedure TFrmMAIN.LoadTableValues;
var
 f: TextFile;
 r: real;
 n: integer;
begin
 if (not FileExists(TableFile)) then Exit;
 AssignFile(f,TableFile);
 Reset(f);
 n:=1;
 try
  while not Eof(f) do
   begin
    Readln(f,r);
    DecimalSeparator:='.';
    ValueListSpectr.InsertRow(inttostr(n),floattostr(r),true);
    Inc(n);
   end;
 finally
  CloseFile(f);
 end;
end;

function TFrmMAIN.GenerateColor(Color:TColor):TColor;
var r, g, b: Byte;
begin
   Randomize;
   Color:=ColorToRGB(Color);
   r:=GetRValue(Color);
   g:=GetGValue(Color);    
   b:=GetBValue(Color);
   r:=r+Random(2*MAXBYTE)-MAXBYTE;
   g:=g+Random(2*MAXBYTE)-MAXBYTE;
   b:=b+Random(2*MAXBYTE)-MAXBYTE;
   result:=RGB(r,g,b);
end;

procedure TFrmMAIN.OnGetMarkText(Sender: TChartSeries; ValueIndex: Integer; var MarkText: String);
var
 i: integer;
 lst: TStringList;
begin
 MarkText:='';
 for i:=0 to MarkList.Count-1 do
  begin
   if (PPeakData(MarkList[i])^.ID=Sender.Tag) then
    begin
     lst:=PPeakData(MarkList[i])^.MaxList;
     if lst=nil then continue;
     if (lst.IndexOf(inttostr(ValueIndex))<>-1) then
       MarkText:=floattostr(Round(Sender.YValue[ValueIndex]));
    end;
  end;
end;

procedure TFrmMAIN.OpenFileDialogTypeChange(Sender: TObject);
begin
 Assert((OpenFileDialog.FilterIndex>0) and (OpenFileDialog.FilterIndex<3));
end;

procedure TFrmMAIN.Origin1Click(Sender: TObject);
var
 i,j : integer;
 f : TextFile;
 curp: PCurvePeaks;
begin
 if PeakList.Count=0 then Exit;
 SaveDataDialog.FileName:='PeaksForOrigin.txt';
 if (SaveDataDialog.Execute) then
  begin
   AssignFile(f,SaveDataDialog.FileName);
   Rewrite(f);
   Write(f,'lambda');
   for i:=0 to PeakList.Count-1 do
     Write(f,#9,'I',i+1);
   Writeln(f);
   curp:=PeakList[0];
   for j:=0 to High(curp^.points)-1 do
    begin
     Write(f,curp^.points[j].x:5:2);
     for i:=0 to PeakList.Count-1 do
      begin
       curp:=PeakList[i];
       Write(f,#9,curp^.points[j].y:10:4);
      end;
     Writeln(f);
     curp:=PeakList[0];
    end;
   CloseFile(f);
  end
 else MessageDlg('Сохранение не произведено!',mtInformation,[mbOK],0);
end;

procedure TFrmMAIN.Origin2Click(Sender: TObject);
var
 i,j : integer;
 f: TextFile;
begin
 SaveDataDialog.FileName:='Stats.txt';
 if SaveDataDialog.Execute then
  begin
   AssignFile(f,SaveDataDialog.FileName);
   Rewrite(f);
   for i:= 0 to SGStats.RowCount - 2 do
    begin
      for j := 0 to SGStats.ColCount - 3 do
       Write(f,SGStats.Cells[j,i],#9);
      Write(f,SGStats.Cells[SGStats.ColCount - 2,i]);
      Writeln(f);
    end;
   CloseFile(f);
  end;
end;

procedure TFrmMAIN.LoadDataFromTxt(filename : string);
var
 f: TextFile;
 x,y: real;
 line : TFastLineSeries;
begin
 if (not FileExists(filename)) then Exit;
 AssignFile(f,filename);
 //---------------
 line:=TFastLineSeries.Create(nil);
 line.Clear;
 line.Title:=ExtractFileName(filename);
 Reset(f);
 while (not Eof(f) )  do
  begin
   Read(f,x); Read(f,y);
   line.AddXY(x,y);
  end;
 line.Delete(0);
 line.Marks.Visible:=true;
 line.OnGetMarkText:=OnGetMarkText;
 line.Marks.Font.Size:=8;
 line.Tag:=s_tag;
 Inc(s_tag);
 CloseFile(f);
 line.ParentChart:=ChartOut;
 if (line.Color=clWhite) then line.Color:=clBlack;
 if (line.Color=clRed) and (line.Tag>0) then line.Color:=GenerateColor(line.Color);
 ChartOut.Repaint;
end;

procedure TFrmMAIN.UpdateNums;
var
 i: integer;
begin
 for i:=1 to ValueListSpectr.RowCount-1 do
  begin
   ValueListSpectr.Cells[0,i]:=inttostr(i);
  end;
end;  

procedure TFrmMAIN.N1Click(Sender: TObject);
begin
 Close;
end;

procedure TFrmMAIN.N7Click(Sender: TObject);
var
 path: string;
begin
 path:=GetCurrentDir+CHMHelpFile;
 if not FileExists(path) then
  MessageDlg('TODO: впишите что хотите, или что надо',mtInformation,[mbOK],0)
 else
  ShellExecute(0,'open',PChar(path),nil,nil,SW_SHOWNORMAL);
end;

procedure TFrmMAIN.N8Click(Sender: TObject);
var
 syspath: array[1..50] of char;
 path: string;
begin
 GetSystemDirectory(@syspath,sizeof(syspath));
 StrCat(@syspath,PChar('\calc.exe'));
 path:=syspath;
 if FileExists(path) then
  ShellExecute(0,'open',PChar(path),nil,nil,SW_SHOW);
end;

procedure TFrmMAIN.ValueListSpectrValidate(Sender: TObject; ACol,
  ARow: Integer; const KeyName, KeyValue: String);
var
 i: integer;
begin
 for i:=1 to ValueListSpectr.RowCount-1 do
  begin
   ValueListSpectr.Cells[0,i]:=inttostr(i);
  end;
end;

procedure TFrmMAIN.ValueListSpectrEditButtonClick(Sender: TObject);
var
 i: integer;
begin
 for i:=1 to ValueListSpectr.RowCount-1 do
  begin
   ValueListSpectr.Cells[0,i]:=inttostr(i);
  end;
end;

procedure TFrmMAIN.ValueListSpectrKeyPress(Sender: TObject; var Key: Char);
begin
 case Key of
  '1'..'9','0','.',',': ;
  #13: UpdateNums;
  #8: if ValueListSpectr.Selection.Left=0 then
    ValueListSpectr.DeleteRow(ValueListSpectr.Selection.Top);
  else Key:=Char(0);
 end;
end;

procedure TFrmMAIN.FormCreate(Sender: TObject);
begin
 NextColor:=clRed;
 LoadTableValues;
 delta:=0.075;
 MarkList:=TList.Create;
 PeakList:=TList.Create;
 s_tag:=0;
 K_first:=1.5;
 StatusMain.Panels[0].Text:='Погрешность: '+floattostr(delta);
 StatusMain.Panels[1].Text:='Спектров загружено: 0';
 //-----------------
 SGStats.Cells[0,0]:=' N линии';
 GridComboN:=TComboBox.Create(Panel2);
 GridComboN.Parent:=Panel2;
 GridComboN.Font.Size:=12;
 SGStats.DefaultRowHeight:=GridComboN.Height;
 GridComboN.Visible:=false;
 GridComboN.Style:=csDropDown;
 GridComboN.ItemIndex:=0;
 GridComboN.OnChange:=ComboNChange;
 GridComboN.OnExit:=ComboNExit;
 //----------
 mFrom:=1;
 mTo:=ValueListSpectr.RowCount-1;
 FillCombo;
 TraceChart:=false;
 isVLEdragging:=false;
 VLEdrag:=vleNone;
 vlePrevPos:=-1;
 NAddStats:=0;
 HRow:=0;
 HCol:=0;
end;

procedure TFrmMAIN.N3Click(Sender: TObject);
begin
 if OpenFileDialog.Execute then
  begin
   N24.Click;
   ChartOut.SeriesList.Clear;
   if (OpenFileDialog.FilterIndex=1) then LoadDataFromTxt(OpenFileDialog.FileName)
   else LoadDataFromSpectrs(OpenFileDialog.FileName);
   UpdateSpectrStats;
   StatusMain.Panels[1].Text:='Спектров загружено: '+inttostr(ChartOut.SeriesCount);
  end
 else MessageDlg('Файл не выбран!',mtInformation,[mbOK],0);
end;

procedure TFrmMAIN.N9Click(Sender: TObject);
begin
 if ValueListSpectr.Visible then N9.Caption:='Показать таблицу'
 else N9.Caption:='Скрыть таблицу';
 ValueListSpectr.Visible:=not ValueListSpectr.Visible;
end;

procedure TFrmMAIN.ChartOutClickLegend(Sender: TCustomChart;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 if (Button=mbRight) then
  begin
   if ChartOut.Legend.Alignment=laTop then
    ChartOut.Legend.Alignment:=laRight
   else ChartOut.Legend.Alignment:=laTop;
  end;
end;

procedure TFrmMAIN.N10Click(Sender: TObject);
begin
 if ValueListSpectr.Visible then N10.Caption:='Показать легенду'
 else N10.Caption:='Скрыть легенду';
 ChartOut.Legend.Visible:= not ChartOut.Legend.Visible;
end;

procedure TFrmMAIN.N12Click(Sender: TObject);
begin
 ChartOut.SeriesList.Clear;
 ChartOut.Repaint;
 s_tag:=0;
 NAddStats:=0;
 ClearMarkData;
 StatusMain.Panels[1].Text:='Спектров загружено: 0';
end;

procedure TFrmMAIN.N11Click(Sender: TObject);
begin
 if OpenFileDialog.Execute then
  begin
   ClearMarkData;
   if (OpenFileDialog.FilterIndex=1) then   LoadDataFromTxt(OpenFileDialog.FileName)
   else LoadDataFromSpectrs(OpenFileDialog.FileName);
   if SGStats.Cells[1,0]<>'' then N14.Click;
   UpdateSpectrStats;
   StatusMain.Panels[1].Text:='Спектров загружено: '+inttostr(ChartOut.SeriesCount);
  end
 else MessageDlg('Файл не выбран!',mtInformation,[mbOK],0);
end;

procedure TFrmMAIN.ChartOutClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
 i: integer;
begin
 if (Button=mbRight) then
  begin
   for i:=0 to MarkList.Count-1 do
    begin
     if (PPeakData(MarkList[i])^.ID=Series.Tag) then
      begin
       MarkList.Remove(MarkList[i]);
       Break;
      end;
    end;
   Series.Free;
   StatusMain.Panels[1].Text:='Спектров загружено: '+inttostr(ChartOut.SeriesCount);
  end;
end;

procedure TFrmMAIN.N13Click(Sender: TObject);
begin
 SaveChartDialog.FileName:='ChartSpectrumCurves';
 if SaveChartDialog.Execute then
  begin
   case SaveChartDialog.FilterIndex of
    1: ChartOut.SaveToBitmapFile(SaveChartDialog.FileName);
    2: ChartOut.SaveToMetafileEnh(SaveChartDialog.FileName);
    3: ChartOut.SaveToMetafile(SaveChartDialog.FileName);
    else MessageDlg('Сохранение не произведено!',mtInformation,[mbOK],0);
   end;
  end
 else MessageDlg('Сохранение не произведено!',mtInformation,[mbOK],0);
end;

procedure TFrmMAIN.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 SaveTableValues;
 ClearMarkData;
 ClearPeakData;
 FreeAndNil(MarkList);
 FreeAndNil(PeakList);
 ChartOut.SeriesList.Clear;
 FrmCurves.ChartCurves.SeriesList.Clear;
end;

procedure TFrmMAIN.N15Click(Sender: TObject);
var
 Sdelta: string;
begin
 Sdelta:=Floattostr(delta);
 if InputQuery('Погрешность определения пика','Введите используемую погрешность',Sdelta) then
  MessageDlg('Успешно изменено',mtInformation,[mbOK],0)
 else  MessageDlg('Ввод отменен',mtInformation,[mbOK],0);
 delta:= StrToFloatDef(Sdelta,delta);
 StatusMain.Panels[0].Text:='Погрешность: '+floattostr(delta);
end;

procedure TFrmMAIN.N14Click(Sender: TObject);
var
 i,j,k: integer;
 ser: TFastLineSeries;
 maxpos,maxval: double;
 maxn:integer;
 lst: TStringList;
 info : PPeakData;
 up,prevup: boolean;
 prevval: double;
begin
 ClearMarkData;
 if ValueListSpectr.RowCount<2 then Exit;
 for i:=0 to ChartOut.SeriesList.Count-1 do
  begin
   ser:=TFastLineSeries(ChartOut.Series[i]);
   lst:=TStringList.Create;
   New(info);
   for j:=mFrom to mTo do
    begin
      maxpos:=StrToFloat(ValueListSpectr.Cells[1,j]);
      maxn:=-1;
      maxval:=-42.0;

      prevval:=Math.MaxDouble;
      prevup:=false;
      for k:=0 to ser.Count-1 do
       begin
        if (ser.XValue[k]>maxpos-delta) then
         begin                  
          up:=ser.YValue[k]>prevval;
          if ((not up) and prevup and (ser.YValue[k-1]>maxval)) then
           begin
            maxn:=k-1;
            maxval:=ser.YValue[k-1];
           end;
          prevup:=up;
          prevval:=ser.YValue[k];
         end;
        if (ser.XValue[k]>maxpos+delta) then Break;
       end;

      //Если  косяк - пробуем старым способом
      if (maxn=-1) then
       begin
        for k:=0 to ser.Count-1 do
         begin
          if (ser.XValue[k]>maxpos-delta) and (ser.XValue[k]<maxpos+delta) and
           (ser.YValue[k]>maxval) then
           begin
            maxn:=k;
            maxval:=ser.YValue[k];
           end;
         end;
       end;  

      //----поиск пиков
      if (maxn<>-1) then lst.Add(inttostr(maxn));
    end;
   //---наполнение пиков серии
   info^.MaxList:=lst;
   info^.ID:=ser.Tag;
   MarkList.Add(PPeakData(info));
  // lst.Free;
  end;
 //---для всех серий
 ChartOut.Repaint;
 FindPeakValues; //Уже конкретно точки
 CheckStatsValid;
 UpdateSpectrStats;
end;

procedure TFrmMAIN.N4Click(Sender: TObject);
var
 i,j : integer;
 f : TextFile;
 curp: PCurvePeaks;
begin
 if PeakList.Count=0 then Exit;
 SaveDataDialog.FileName:='Peaks.txt';
 if (SaveDataDialog.Execute) then
  begin
   AssignFile(f,SaveDataDialog.FileName);
   Rewrite(f);
   for i:=0 to PeakList.Count-1 do
    begin
     curp:=PeakList[i];
     Write(f,'//--------------------');
     Write(f,curp^.Title);
     Write(f,'--------------------\\');
     Writeln(f);
     for j:=0 to High(curp^.points)-1 do
      begin
       Write(f,curp^.points[j].x:5:2);
       Write(f,#9);
       Writeln(f,curp^.points[j].y:10:4);
      end;
     Writeln(f,'//----------------------------------------\\');
    end;
   CloseFile(f);
  end
 else MessageDlg('Сохранение не произведено!',mtInformation,[mbOK],0);
end;

procedure TFrmMAIN.N17Click(Sender: TObject);
begin
 FrmSettings.Show;
end;

procedure TFrmMAIN.N16Click(Sender: TObject);
begin
 FrmCurves.Show;
 if not FrmCurves.RecalcTemperarureCurves() then
  begin
   FrmCurves.Hide;
   MessageDlg('Отсутствуют данные пиков',mtInformation,[mbOK],0);
  end;
end;

procedure TFrmMAIN.N18Click(Sender: TObject);
begin
 if N18.Caption='Скрыть статистику' then N18.Caption:='Показать статистику'
  else N18.Caption:='Скрыть статистику';
 Panel2.Visible:= not Panel2.Visible;
 Separator.Visible:=not Separator.Visible;
end;

procedure TFrmMAIN.SGStatsSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var
 R: TRect;
begin
 if ((ACol=0) and (ARow=SGStats.RowCount-1)) then
  begin
    {Ширина и положение ComboBox должно соответствовать ячейке StringGrid}
    R := SGStats.CellRect(ACol, ARow); R.Left := R.Left + SGStats.Left;
    R.Right := R.Right + SGStats.Left;
    R.Top := R.Top + SGStats.Top;
    R.Bottom := R.Bottom + SGStats.Top;
    FillCombo;
    GridComboN.Left := R.Left + 2;
    GridComboN.Top := R.Top + 1;
    GridComboN.Width := (R.Right + 1) - R.Left;
    GridComboN.Height := (R.Bottom + 1) - R.Top; {Покажем combobox}
    GridComboN.Visible := True; GridComboN.SetFocus;
  end;
 CanSelect:=true;
end;

procedure TFrmMAIN.N20Click(Sender: TObject);
begin
 UpdateSpectrStats;
end;

procedure TFrmMAIN.N19Click(Sender: TObject);
var
 i,k:integer;
begin
 k:=SGStats.Selection.Top;
 if (k<1) then Exit;
 for i:=k to SGStats.RowCount-2 do
  begin
   SGStats.Rows[i]:=SGStats.Rows[i+1];
  end;
 SGStats.RowCount:=SGStats.RowCount-1;
end;

procedure TFrmMAIN.ValueListSpectrDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
 if (ACol=0) and ((ARow=mFrom) or (ARow=mTo))  then
  begin
   ValueListSpectr.Canvas.Brush.Color:=clGray;
   ValueListSpectr.Canvas.Pen.Color:=clWhite;
   ValueListSpectr.Canvas.Font.Color:=clWhite;
   ValueListSpectr.Canvas.FillRect(Rect);
   ValueListSpectr.Canvas.TextOut(Rect.Left+3,Rect.Top+2,ValueListSpectr.Cells[ACol,ARow]);
  end;
end;

procedure TFrmMAIN.ValueListSpectrMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
 cy: integer;
begin
 ValueListSpectr.Invalidate;
 cy:=ValueListSpectr.MouseCoord(X,Y).Y;
 if (Button=mbLeft) and ((cy=mFrom) or (cy=mTo)) then
    begin
     isVLEdragging:=true;
     if (cy=mFrom) then VLEdrag:=vleFrom
     else VLEdrag:=vleTo;
     vlePrevPos:=cy;
    end;
end;

procedure TFrmMAIN.ChartOutMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
 i: integer;
 xval,yval: double;
begin
 if (ChartOut.SeriesCount=0) or (not TraceChart) then Exit;
 ChartOut.Repaint;
 for i:=0 to ChartOut.SeriesCount-1 do
  begin
   if ChartOut.Series[i].GetCursorValueIndex<>-1 then
    begin
     with ChartOut.Canvas do
      begin
       Pen.Color:=clBlue;
       Pen.Style:=psDash;
       Font.Color:=clBlue;
       Line(ChartOut.ChartRect.Left,Y,ChartOut.ChartRect.Right,Y);
       Line(X,ChartOut.ChartRect.Top,X,ChartOut.ChartRect.Bottom);
       ChartOut.Series[i].GetCursorValues(xval,yval);
       TextOut(X+7,Y-TextHeight('X')-3,'X= '+FloatToStrF(xval,ffGeneral,6,2)+'  Y= '+{FloatToStrF(yval,ffGeneral,5,0));} inttostr(Round(yval)));
      end;
    end;
  end;
end;

procedure TFrmMAIN.N21Click(Sender: TObject);
begin
 TraceChart:= not TraceChart;
 N21.Checked:=TraceChart;
end;

procedure TFrmMAIN.ValueListSpectrMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
 cy, tmp1, tmp2: integer;
begin
 if isVLEdragging then
  begin
   isVLEdragging:=false;
   cy:=ValueListSpectr.MouseCoord(X,Y).Y;
   if (cy<=0) or (cy>=ValueListSpectr.RowCount) or (mFrom=mTo) then
    begin
     if (VLEdrag=vleFrom) then mFrom:=vlePrevPos
      else mTo:=vlePrevPos;
     isVLEdragging:=false;
     vlePrevPos:=-1;
     VLEdrag:=vleNone;
     Exit;
    end;
   if (VLEdrag=vleFrom) then mFrom:=cy
   else mTo:=cy;
   vlePrevPos:=-1;
   VLEdrag:=vleNone;
   tmp1:=Max(mFrom,mTo);
   tmp2:=Min(mFrom,mTo);
   mFrom:=tmp2; mTo:=tmp1;
   ValueListSpectr.Invalidate;
   N14.Click;
  end;
end;

procedure TFrmMAIN.ValueListSpectrMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
 cy: integer;
begin
 if isVLEdragging then
  begin
   cy:=ValueListSpectr.MouseCoord(X,Y).Y;
   if (cy<=0) or (cy>=ValueListSpectr.RowCount) then
    begin
     if (VLEdrag=vleFrom) then mFrom:=vlePrevPos
      else mTo:=vlePrevPos;
     isVLEdragging:=false;
     vlePrevPos:=-1;
     VLEdrag:=vleNone;
     Exit;
    end;
   if (VLEdrag=vleFrom) then mFrom:=cy
   else mTo:=cy;
   ValueListSpectr.Invalidate;
  end;
end;

procedure TFrmMAIN.SGStatsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
 ACol, ARow: integer;
begin
 SGStats.MouseToCell(X,Y,ACol,ARow);
 if (ACol=-1) or (ARow=-1) then Exit;
 if SGStats.Cells[ACol,ARow]=AddColSign then
   if FrmChooser.ShowModal=mrOK then
    begin
     Inc(NAddStats);
     SGStats.ColCount:=SGStats.ColCount+1;
     SGStats.Cells[SGStats.ColCount-2,0]:=' '+statTypeData;
     SGStats.Cells[SGStats.ColCount-1,0]:=AddColSign;
     UpdateSpectrStats;
    end
   else MessageDlg('Ввод отменен',mtInformation,[mbOK],0);
end;


procedure TFrmMAIN.SGStatsMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
 r,c,spn : integer;
 title: string;
begin
 SGStats.MouseToCell(X, Y, C, R);
 if ((HCol <> c) or (HRow<>r)) then
 begin
  HRow:=r; HCol:=c;
  SGStats.Hint:='';
  Application.CancelHint;
  if (R=0) and (C in [1..SGStats.ColCount-NAddStats-1])  then
   begin
     title:=Trim(SGStats.Cells[C,R]);
     Delete(title,1,1);
     Delete(title,length(title),1);
     spn:=StrToIntDef(title,-1)-1;
     if (ChartOut.SeriesCount=0)  or (spn>=ChartOut.SeriesCount) then Exit;
     if spn>=0 then SGStats.Hint:=ChartOut.Series[spn].Title;
  end;
 end;
end;

function ComparePairIntegers(Item1 : Pointer; Item2 : Pointer) : Integer;
 var
   num1, num2 : PSortPair;
 begin
   num1 := PSortPair(Item1);
   num2 := PSortPair(Item2);

  // Теперь сравнение строк
   if      num1^.key > num2^.key
   then Result := 1
   else if num1^.key = num2^.key
   then Result := 0
   else Result := -1;
 end;

procedure GridSort(aSg : TStringGrid; const aCol : Integer);
var
  {SlSort,} SlRow : TStringList;
  i, j : Integer;
  item: PSortPair;
  SlSort: TList;
begin
  //Сортируемый список.
  SlSort := TList.Create;
  //Добавляем в сортируемый список пары: "строка - объект".
  for i := aSg.FixedRows to aSg.RowCount - 2 do begin
    SlRow := TStringList.Create;
    SlRow.Assign(aSg.Rows[i]);
    //---------------
    New(item);
    item^.key:=strtoint(aSg.Cells[aCol, i]);
    item^.row:=SlRow;
    SlSort.Add(item);
  end;
  //Сортируем столбец.
  SlSort.Sort(ComparePairIntegers);
  j := 0;
  for i := aSg.FixedRows to aSg.RowCount - 2 do
   begin
    SlRow := PSortPair(SlSort[j]).row;
    aSg.Rows[i].Assign(SlRow);
    SlRow.Free;
    Dispose(PSortPair(SlSort[j]));
    //Следующий индекс списка.
    Inc(j);
  end;   
 SlSort.Free;
end;

procedure TFrmMAIN.N22Click(Sender: TObject);
begin
 GridSort(SGStats,0);
end;

procedure TFrmMAIN.N23Click(Sender: TObject);
begin
 ChartOut.View3D:=not ChartOut.View3D;
 N23.Checked:=not ChartOut.View3D;
end;

procedure TFrmMAIN.N24Click(Sender: TObject);
var
 i,j: integer;
begin
 ClearPeakData;
 N12.Click;
 mFrom:=1;
 mTo:=ValueListSpectr.RowCount-1;
 ValueListSpectr.Invalidate;
 SGStats.RowCount:=2;
 SGStats.ColCount:=5;
 for j := 0 to 1 do
  for i := 0 to 4 do
   SGStats.Cells[i,j]:='';
 SGStats.Cells[0,0]:=' N линии';
end;

end.
