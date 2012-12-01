unit savgol;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, ap, densesolver, Math;
  {requires ALGLIB}

type
 // Types for simplifying params passing
 TIntVector = array of integer;
 TDoubleVector = array of double;
 TPointVector = array of TPointFloat;
 TDoubleMatrix = array of array of double;

{
  from -'nl' to 'nr' (in data points) generates SG coeffs
  for polynomial of 'degree'
  for approximation of derivative of 'order'
  Default 0 means smoothing without derivation
}
function calcSGCoeffs(nl, nr : integer; degree: integer; order: integer = 0): TDoubleVector;
function ApplySGFilterToData(data: TPointVector; window_size, degree: integer; order: integer = 0): TDoubleVector;

implementation

function calcSGCoeffs(nl, nr : integer; degree: integer; order: integer = 0): TDoubleVector;
var
 i, j, k, m, n : integer;
 matrix: TReal2DArray;
 b, X : TReal1DArray;
 sum: double;
 Info, Num: AlglibInteger;
 Rep: DenseSolverReport;
 coeffs: TDoubleVector;
begin
  if (nl < 0) or (nr < 0) or ((nl + nr) < degree) then
    raise Exception.Create('Bad arguments');
  if order > 5 then
    raise Exception.Create('I''m aint'' sure this thing handles derivatives higher than 5. No way, I suppose.');

 Num := degree + 1;
 SetLength(matrix, Num, Num);
 
 for i := 0 to degree do
  begin
   for j := 0 to degree do
    begin
      if (i = 0) and (j = 0) then sum := 1
      else sum := 0;

      for k := 1 to nr do sum:= sum + Power(k, i + j);
      for k := 1 to nl do sum:= sum + Power(-k, i + j);

      matrix[i, j] := sum;
    end;
  end;

 SetLength(b, Num);
 b[order] := 1;
 RMatrixSolve(matrix, Num, b, Info, Rep, X);   //Solving simple dense matrix

 if (Info < 0) then raise Exception.Create('Troubles with matrix solving! :((');

 SetLength(coeffs, nr + nl + 1);
 for n := -nl to nr do
  begin
    sum := X[0];

    for m := 1 to degree do
      sum := sum + X[m] * Power(n, m);

    coeffs[n + nl] := sum;
  end;

 Result := coeffs;  
end;

function ApplySGFilterToData(data: TPointVector; window_size, degree: integer; order: integer = 0): TDoubleVector;
var
 i, j, N : integer;
 coeffs: TDoubleVector;
 h, tempSum: Double;
 half : integer;
 smoothed: TDoubleVector;
begin
 half := window_size div 2;  // Ну да, нелогично с этим в целом, но мне так удобнее
 N := Length(data);
 coeffs := calcSGCoeffs(half, half, degree, order);

 SetLength(smoothed, N);
 for i := half to N - half - 1 do
  begin
    tempSum := 0;
    h := (data[i + half].x - data[i - half].x) / (2 * half);

    for j := 0 to window_size - 1 do
      tempSum := tempSum + coeffs[j] * data[i - half + j].y;

    smoothed[i]:= 2 * tempSum /h /h;
  end;

 //Края, хер знает, что тут делать
 for I := 0 to half - 1 do smoothed[i]:=smoothed[half];
 for I := N - half to N - 1 do smoothed[i]:=smoothed[N - half - 1];

 {
    Можно было бы под каждую точку расчитать отдельный набор
    коэффициентов, но это неоптимально и будет подтормаживать.
    Можно снизить размер окна, но будет стыковаться хуже.
    В общем, пока не критично.
 }

 Result := smoothed;
end;

end.
