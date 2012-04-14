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
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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

procedure TFrmChooser.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 ModalResult:=mrCancel;
end;

end.
