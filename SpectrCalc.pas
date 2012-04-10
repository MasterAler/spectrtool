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
  Grids, ValEdit, ShellAPI, Series, ExtDlgs, CalcCurve, Settings, XPMan;

const
 TableFile='TableValues.txt';
 SettingFile='Coeffs.txt';
 CHMHelpFile='.\SpectrHelp.chm';
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
    Splitter1: TSplitter;
    N18: TMenuItem;
    SGStats: TStringGrid;
    PopupMenuStats: TPopupMenu;
    N19: TMenuItem;
    N20: TMenuItem;
    ValueListSpectr: TValueListEditor;
    N21: TMenuItem;
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
    procedure FormDestroy(Sender: TObject);
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
    procedure SGStatsDblClick(Sender: TObject);
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
  private
    { Private declarations }
    procedure UpdateNums();
    procedure LoadDataFromTxt(filename : string);
    procedure AddSeries();
    procedure LoadTableValues();
    procedure SaveTableValues();
    procedure ClearMarkData();
    procedure FindPeakValues();
    procedure UpdateSpectrStats();
     procedure CMMouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
  public
    { Public declarations }
   procedure OnGetMarkText(Sender: TChartSeries; ValueIndex: Integer; var MarkText: String);
   procedure ComboNChange(Sender: TObject);
   procedure ComboNExit(Sender: TObject);
  end;

var
  FrmMAIN: TFrmMAIN;
  Curves: TList;
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

implementation

uses Math, IniFiles, TeCanvas;

{$R *.dfm}

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
 SGStats.Cells[0,SGStats.RowCount-1]:=GridComboN.Items[GridComboN.ItemIndex];
 GridComboN.Visible:=false;
 SGStats.SetFocus;
end;

procedure TFrmMAIN.ComboNExit(Sender: TObject);
begin
 SGStats.Cells[0,SGStats.RowCount-1]:=GridComboN.Items[GridComboN.ItemIndex];
 GridComboN.Visible:=false;
 SGStats.SetFocus;
 SGStats.RowCount:=SGStats.RowCount+1;
 UpdateSpectrStats;
end;
//-----------------------------------------------------------------------------

procedure TFrmMAIN.UpdateSpectrStats();
var
 i,j: integer;
 curp: PCurvePeaks;
 n_ln : integer;
begin
 if (PeakList.Count=0) or (SGStats.Cells[0,1]='') then Exit;
 SGStats.ColCount:=PeakList.Count+1;
 for i:=0 to PeakList.Count-1 do
  begin
   curp:=PeakList[i];
   SGStats.Cells[i+1,0]:=curp^.Title;
   for j:=1 to SGStats.RowCount-2 do   
    begin
     n_ln:=strtoint(SGStats.Cells[0,j]);
     SGStats.Cells[i+1,j]:=floattostr(curp^.points[n_ln-1].y);
    end;
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

function GenerateColor(Color:TColor):TColor;
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

procedure TFrmMAIN.AddSeries();
var
 i: integer;
 ser: TFastLineSeries;
begin
 for i:=0 to Curves.Count-1 do
  begin
   ser:=PFastLineSeries(Curves.Items[i])^;
   ser.ParentChart:=ChartOut;
  end;
 ChartOut.Repaint;
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

procedure TFrmMAIN.LoadDataFromTxt(filename : string);
var
 f: TextFile;
 x,y: real;
 line : TFastLineSeries;
begin
 if (not FileExists(filename)) then Exit;
 AssignFile(f,filename);
 Reset(f);
 while (not Eof(f) ) do
  begin
   Readln(f);
  end;
 CloseFile(f);
 //---------------
 line:=TFastLineSeries.Create(nil);
 line.Clear;
 line.Title:=ExtractFileName(filename);
 line.LinePen.Color:=NextColor;
 NextColor:=GenerateColor(NextColor);
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
 Curves.Add(@line);
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
begin
 if not FileExists(CHMHelpFile) then
  MessageDlg('TODO: впишите что хотите, или что надо',mtInformation,[mbOK],0)
 else
  ShellExecute(0,'open',PChar(CHMHelpFile),nil,nil,SW_SHOWNORMAL);
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
var
 i:integer;
begin
 Curves:=TList.Create;
 NextColor:=clRed;
 LoadTableValues;
 delta:=0.07;
 MarkList:=TList.Create;
 PeakList:=TList.Create;
 s_tag:=0;
 K_first:=1.5;
 StatusMain.Panels[0].Text:='Погрешность: '+floattostr(delta);
 //-----------------
 SGStats.Cells[0,0]:=' N линии';
 GridComboN:=TComboBox.Create(Panel2);
 GridComboN.Parent:=Panel2;
 GridComboN.Font.Size:=12;
 SGStats.DefaultRowHeight:=GridComboN.Height;
 GridComboN.Visible:=false;
 GridComboN.Style:=csDropDown;
 for i:=1 to ValueListSpectr.RowCount-1 do
  begin
   GridComboN.Items.Add(inttostr(i));
  end;
 GridComboN.ItemIndex:=0;
 GridComboN.OnChange:=ComboNChange;
 GridComboN.OnExit:=ComboNExit;
 //----------
 mFrom:=1;
 mTo:=ValueListSpectr.RowCount-1;
 TraceChart:=false;
 isVLEdragging:=false;
 VLEdrag:=vleNone;
 vlePrevPos:=-1;
end;

procedure TFrmMAIN.N3Click(Sender: TObject);
begin
 if OpenFileDialog.Execute then
  begin
   ClearMarkData;
   ChartOut.SeriesList.Clear;
   Curves.Clear;
   LoadDataFromTxt(OpenFileDialog.FileName);
   AddSeries();
   UpdateSpectrStats;
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
   ChartOut.Legend.Visible:=false;
   N10.Caption:='Показать легенду';
  end;
end;

procedure TFrmMAIN.N10Click(Sender: TObject);
begin
 if ValueListSpectr.Visible then N10.Caption:='Показать легенду'
 else N10.Caption:='Скрыть легенду';
 ChartOut.Legend.Visible:= not ChartOut.Legend.Visible;
end;

procedure TFrmMAIN.FormDestroy(Sender: TObject);
begin
 Curves.Free;
end;

procedure TFrmMAIN.N12Click(Sender: TObject);
begin
 ChartOut.SeriesList.Clear;
 ChartOut.Repaint;
 s_tag:=0;
 ClearMarkData;
end;

procedure TFrmMAIN.N11Click(Sender: TObject);
begin
 if OpenFileDialog.Execute then
  begin
   ClearMarkData;
   LoadDataFromTxt(OpenFileDialog.FileName);
   AddSeries();
   UpdateSpectrStats;
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
 MarkList.Free;
 PeakList.Free;
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
end;

procedure TFrmMAIN.N4Click(Sender: TObject);
var
 i,j : integer;
 f : TextFile;
 curp: PCurvePeaks;
begin
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
 Splitter1.Visible:=not Splitter1.Visible;
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
    GridComboN.Left := R.Left + 2;
    GridComboN.Top := R.Top + 1;
    GridComboN.Width := (R.Right + 1) - R.Left;
    GridComboN.Height := (R.Bottom + 1) - R.Top; {Покажем combobox}
    GridComboN.Visible := True; GridComboN.SetFocus;
  end;
 CanSelect:=true;
end;

procedure TFrmMAIN.SGStatsDblClick(Sender: TObject);
begin
 UpdateSpectrStats;
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
       TextOut(X+7,Y-TextHeight('X')-3,'X= '+FloatToStrF(xval,ffGeneral,6,2)+'  Y= '+inttostr(Round(yval)));
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

end.
