unit Settings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids;

type
    TCoeffInfo=record
     k, S, F : real;
    end;
  TFrmSettings = class(TForm)
    SGSettings: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    procedure LoadCoeffData(filename: string);
    procedure SaveCoeffData(filename: string);
  public
    { Public declarations }
  end;

var
  FrmSettings: TFrmSettings;
  N_Coeff: integer;
  CoeffData: array of TCoeffInfo;

implementation

uses SpectrCalc;

{$R *.dfm}

procedure TFrmSettings.LoadCoeffData(filename: string);
var
 i: integer;
 f: TextFile;
begin
 if not FileExists(filename) then
  begin
  SetLength(CoeffData,N_Coeff);
  for i:=0 to N_Coeff-1 do
   begin
    CoeffData[i].k:=0;
    CoeffData[i].S:=0;
    CoeffData[i].F:=0;
   end;
   Exit;
  end;
 AssignFile(f,filename);
 Reset(f);
 try
  Readln(f,N_Coeff);
  SetLength(CoeffData,N_Coeff);
  for i:=0 to N_Coeff-1 do
   begin
    Read(f,CoeffData[i].k);
    Read(f,CoeffData[i].S);
    Readln(f,CoeffData[i].F);
   end;
 finally
  CloseFile(f);
 end;
end;

procedure TFrmSettings.SaveCoeffData(filename: string);
var
 i: integer;
 f: TextFile;
begin
 AssignFile(f,filename);
 Rewrite(f);
 Writeln(f,N_Coeff);
 for i:=0 to N_Coeff-1 do
  begin
   Write(f,CoeffData[i].k:10:2); Write(f,#9);
   Write(f,CoeffData[i].S:10:3);  Write(f,#9);
   Writeln(f,CoeffData[i].F:10:0);
  end;
 CloseFile(f);
end;

procedure TFrmSettings.FormCreate(Sender: TObject);
var
 i: integer;
begin
 N_Coeff:=24;
 SGSettings.Cells[0,0]:='K';
 SGSettings.Cells[1,0]:='k(вес линии)';
 SGSettings.Cells[2,0]:='S';
 SGSettings.Cells[3,0]:='F(K)';
 for i:=1 to N_Coeff do
  begin
   SGSettings.Cells[0,i]:=floattostr(K_first+i-1);
  end;
 LoadCoeffData(SettingFile);
 for i:=1 to N_Coeff do
  begin
   SGSettings.Cells[1,i]:=floattostr(CoeffData[i-1].k);
   SGSettings.Cells[2,i]:=floattostr(CoeffData[i-1].S);
   SGSettings.Cells[3,i]:=floattostr(CoeffData[i-1].F);
  end;
end;

procedure TFrmSettings.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
 i: integer;
begin
 Action:=caHide;
 for i:=1 to N_Coeff do
  begin
   CoeffData[i-1].k:=strtofloat(SGSettings.Cells[1,i]);
   CoeffData[i-1].S:=strtofloat(SGSettings.Cells[2,i]);
   CoeffData[i-1].F:=strtofloat(SGSettings.Cells[3,i]);
  end;
end;

procedure TFrmSettings.FormDestroy(Sender: TObject);
begin
 SaveCoeffData(SettingFile);
end;

end.
