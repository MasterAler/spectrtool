unit Chooser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Spin, FloatSpinEdit;

type
  TFrmChooser = class(TForm)
    bbOK: TBitBtn;
    bbCancel: TBitBtn;
    cbOne: TComboBox;
    cbTwo: TComboBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    rbST: TRadioButton;
    Label3: TLabel;
    Label4: TLabel;
    rbF: TRadioButton;
    cbFunction: TComboBox;
    fseCoeff: TFloatSpinEdit;
    Label5: TLabel;
    procedure rbFClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bbOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmChooser: TFrmChooser;

implementation

{$R *.dfm}

uses SpectrCalc;

procedure TFrmChooser.rbFClick(Sender: TObject);
var
 i: integer;
begin
  for i:=0 to ComponentCount-1 do
    if (Components[i] as TControl).Parent.Name='GroupBox1' then
     (Components[i] as TControl).Enabled:=not rbF.Checked;
end;

procedure TFrmChooser.FormShow(Sender: TObject);
var
 i: integer;
begin
 cbOne.Items.Clear;
 cbTwo.Items.Clear;
 for i:=1 to PeakList.Count do
  begin
   cbOne.Items.Add(inttostr(i));
   cbTwo.Items.Add(inttostr(i));
  end;
 cbOne.ItemIndex:=0;
 cbTwo.ItemIndex:=0;
end;

procedure TFrmChooser.bbOKClick(Sender: TObject);
begin
 if rbF.Checked then statTypeData:=cbFunction.Text
 else  statTypeData:=FloatToStr(fseCoeff.Value)+'*'+
      '['+cbOne.Items[cbOne.ItemIndex]+']/['+
      cbTwo.Items[cbTwo.ItemIndex]+']';
end;

end.
