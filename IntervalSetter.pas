unit IntervalSetter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, Buttons;

type
  TFrmIntervals = class(TForm)
    bbOK: TBitBtn;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    se1From: TSpinEdit;
    se1To: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    se2From: TSpinEdit;
    se2To: TSpinEdit;
    bbCancel: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure bbOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmIntervals: TFrmIntervals;

implementation

{$R *.dfm}

uses CalcCurve;

procedure TFrmIntervals.bbOKClick(Sender: TObject);
var
 nf1,nt1,nf2,nt2,len : integer;
begin
 nf1 := se1From.Value;
 nt1 := se1To.Value;
 nf2 := se2From.Value;
 nt2 := se2To.Value;
 // по идее, вызвать окно с температурными кривыми
 //  пустым и без данных невозможно
 len := FrmCurves.ChartCurves.Series[0].Count;

 if (nf1 > nt1) or (nf2 > nt2) or (nt1 > len) or (nt2 > len) then
   ModalResult:=mrCancel
 else
  begin
    first._from := nf1;
    first._to := nt1;
    second._from := nf2;
    second._to := nt2;
    FrmCurves.N1910231.Click;
  end;
end;

procedure TFrmIntervals.FormShow(Sender: TObject);
begin
 se1From.Value:=first._from;
 se1To.Value:=first._to;
 se2From.Value:=second._from;
 se2To.Value:=second._to;
end;

end.
