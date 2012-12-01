unit SpectrsReader;

interface

{
    ‘ормат данных и принципы работы с ними вз€ты из исходников разработчиков
    фирмы LOMOPHOTONICS, предоставивших свои классы на —++, реализующие работу
    с их собственным форматом файлов. ≈сли что-то в организации чтени€-записи
    либо типах данных кажетс€ странным - дело, скорее всего, в первоисточнике :)) 
}

{
    ѕока везде только чтение, запись можно потом добавить, сейчас не нужна по сути
}

uses
 Windows, Contnrs, Messages, SysUtils;

const
 MAX_PLUGIN_COUNT=10;
 MAX_ATTR_COUNT=255;

 ATTR_OPT_ANY=$FFFFFFFF;
 ATTR_OPT_NORMAL=$00000000;
 ATTR_OPT_SYSTEM=$00000001;
 ATTR_OPT_HIDDEN=$00000002;
 ATTR_OPT_READONLY=$00000004;

 CURVE_SET_X=$00000001;
 CURVE_SET_Y=$00000002;
 CURVE_SET_BOTH=(CURVE_SET_X or CURVE_SET_Y);

 CURVE_TRUNC_BEGIN=$00000001;
 CURVE_TRUNC_END=$00000002;
 CURVE_TRUNC_BOTH=(CURVE_TRUNC_BEGIN or CURVE_TRUNC_END);

 CURVE_NORMAL_DIR=$00000001;
 CURVE_BACK_DIR=$00000002;
 CURVE_UNKNOWN_DIR=$00000003;

 //FILE_ATTRIBUTE_NORMAL=$80;  //≈сли что...

type
 TAttrType=(   ATTR_TYPE_ANY            = -1,
               ATTR_TYPE_INTEGER        =  0,
               ATTR_TYPE_FLOAT          =  1,
               ATTR_TYPE_STRING         =  2,
               ATTR_TYPE_DATE           =  3,
               ATTR_TYPE_TIME           =  4,
               ATTR_TYPE_USER           =  5);
 //---------------------------------------------------------
 ICurveReader=interface(IInterface)
  ['{5E0E4383-60B2-4506-9E1B-6A3FBAF58698}']
  procedure Read(handle: Cardinal);
  procedure Clear();
 end;
 ICurvesDataProvider=interface(IInterface)
  ['{DD2EDE4B-19F8-4B77-813F-7115461E6A59}']
  procedure Read(filename: string);
  procedure Clear();
 end;

 TSingleArray=array of Single;
 TNx2SingleArray=array of array of Single;
 TXYSpectrData=packed record
  XValues: TSingleArray;
  YValues: TNx2SingleArray;
 end;
 TCurveData=class(TInterfacedObject,ICurveReader)
 private
  XValues: array of Single;
  YValues: array of array of Single;
  dwSize, dwCount, dwLayers: DWORD;
 public
  function GetPointsData(): TXYSpectrData;
  procedure Read(handle: Cardinal);
  procedure Clear;
  constructor Create;
  destructor Destroy; override;
 end;

 TStringAttribute=class(TInterfacedObject,ICurveReader)
 private
  Name: string;
  saType: TAttrType;
  dwFlags, dwSize: Cardinal;
  pData: PChar;
  //потом можно вставить string, тогда
  //светла€ маги€ Delphi поможет))
 public
  procedure Clear;
  procedure Read(handle: Cardinal);
  constructor Create;
  destructor Destroy; override;
  function ToString():string;
 end;

 TAttribs=class(TInterfacedObject,ICurveReader)
 protected
  StringAttribs: array [1..MAX_ATTR_COUNT] of TStringAttribute;
  _count: LongInt;
  function GetCount(): LongInt;
 public
  property Count: LongInt read GetCount;
  function GetAttributesString(): string; virtual;
  procedure Read(handle: Cardinal);
  procedure Clear;
  constructor Create;
  destructor Destroy; override;
 end;

 TStringPlugin=class(TInterfacedObject,ICurveReader)
 protected
  Name: string;
  pData: PChar;
  dwSize: DWORD;
 public
  procedure Read(handle: Cardinal);
  procedure Clear;
  constructor Create;
  destructor Destroy; override;
 end;

 TPlugins=class(TInterfacedObject,ICurveReader)
 protected
  StringPlugins: array [1..MAX_PLUGIN_COUNT] of TStringAttribute;
  _count: Longint;
  function GetCount(): LongInt;
 public
  property Count : LongInt read GetCount;
  procedure Read(handle: Cardinal);
  procedure Clear;
  constructor Create;
  destructor Destroy; override;
 end;

 TCurveInfo=record
  PointsData: TXYSpectrData;
  AttributeText: string;
 end;
 TCurve=class(TInterfacedObject,ICurveReader)
 private    //ќбертка 3 в 1, не структура, так удобнее
  data: TCurveData;
  plugins: TPlugins;
  attribs: TAttribs;
 public
  function GetCurveData(): TCurveInfo;
  procedure Read(handle: Cardinal);
  procedure Clear;
  constructor Create;
  destructor Destroy; override;
 end;
 //---------------------------------------------------------
 TSpectrsReader=class(TInterfacedObject,ICurvesDataProvider)
 private
  Curves: TObjectList;
 public
  function CurveCount: integer;
  function GetCurveInfo(curveID: integer): TCurveInfo;
  procedure Read(filename: string);
  procedure Clear;
  constructor Create;
  destructor Destroy; override;
 end;

implementation

{
  ≈сть подозрение, что переопредел€ть все Free не надо, но провер€ть уже нет
  сил, потом их поубивать стоит все нахрен.
}

uses Math;

constructor TSpectrsReader.Create;
begin
 inherited;
 Curves:=TObjectList.Create(true);
end;

destructor TSpectrsReader.Destroy;
begin
 Curves.Clear;
 FreeAndNil(Curves);
 inherited;
end;

procedure TSpectrsReader.Read(filename: string);
var
 i: integer;
 Handle: Cardinal;
 buf: array [0..4] of AnsiChar;
 dwRead: DWORD;
 curlen : Longint;
 newCurve : TCurve;
begin
 //FILE_ATTRIBUTE_NORMAL=$80
 Handle:=CreateFile(PChar(filename),GENERIC_READ,0,nil,OPEN_EXISTING,$80,0);
 if (Handle=INVALID_HANDLE_VALUE) then raise Exception.Create('File not found or not opened, sorry:((');
 ReadFile(Handle,buf,4,dwRead,nil);
 buf[4]:=Char(0);
 if (StrComp(buf,'SPCS')<>0) then
  begin
   CloseHandle(Handle);
   raise Exception.Create('Wrong file format');
  end;
 ReadFile(Handle,curlen,4,dwRead,nil);
 for i:=0 to curlen-1 do
  begin
   newCurve:=TCurve.Create;
   newCurve.Read(Handle);
   Curves.Add(newCurve);
  end;
 //MessageBox(0,PChar('Yeahh!!'),PChar('Reader'),MB_OK);
 CloseHandle(Handle);
end;

procedure TSpectrsReader.Clear;
begin
 Curves.Clear;
end;

function TSpectrsReader.CurveCount: integer;
begin
 Result:=Curves.Count;
end;

function TSpectrsReader.GetCurveInfo(curveID:integer):TCurveInfo;
begin
 Result:=TCurve(Curves[curveID]).GetCurveData;
end;

//----------------TCurve-----------------

function TCurve.GetCurveData: TCurveInfo;
var
 info: TCurveInfo;
begin
 info.PointsData:=data.GetPointsData;
 info.AttributeText:=attribs.GetAttributesString;
 Result:=info;
end;

constructor TCurve.Create;
begin
 inherited;
 data:=TCurveData.Create;
 plugins:=TPlugins.Create;
 attribs:=TAttribs.Create;
end;

destructor TCurve.Destroy;
begin
 data.Clear;
 plugins.Clear;
 attribs.Clear;
 data.Free;
  plugins.Free;
  attribs.Free;
end;

procedure TCurve.Read(handle: Cardinal);
begin
 Clear;
 attribs.Read(handle);
 plugins.Read(handle);
 data.Read(handle);
end;

procedure TCurve.Clear;
begin
 data.Clear;
 plugins.Clear;
 attribs.Clear;
end;

//--------------TPluginAttribute---------------

procedure TStringPlugin.Read(handle: Cardinal);
var
 dwRead: DWORD;
begin
 ReadFile(handle,dwSize,4,dwRead,nil);
 if (dwSize<>0) then
  begin
   GetMem(pData,dwSize);
   ReadFile(handle,pData,dwSize,dwRead,nil);
  end;
end;

constructor TStringPlugin.Create;
begin
 inherited;
 pData:=nil;
 dwSize:=0;
end;

destructor TStringPlugin.Destroy;
begin
 Clear;
 inherited;
end;

procedure TStringPlugin.Clear;
begin
 if (pData<>nil) then
  begin
   FreeMem(pData);
   pData:=nil;
  end;
 dwSize:=0;
end;

//------------TPlugins--------------------

function TPlugins.GetCount: LongInt;
begin
 Result:=_count;
end;

constructor TPlugins.Create;
begin
 inherited;
 _count:=0;
end;

destructor TPlugins.Destroy;
begin
 Clear;
 inherited;
end;

procedure TPlugins.Read(handle: Cardinal);
var
 i: integer;
 dwRead: DWORD;
begin
 Clear;
 ReadFile(handle,_Count,4,dwRead,nil);
 for i:=1 to _count do
  begin
   StringPlugins[i]:=TStringAttribute.Create;
   StringPlugins[i].Read(handle);
  end;
end;

procedure TPlugins.Clear;
var
 i: integer;
begin
 for i:=1 to MAX_PLUGIN_COUNT do
  if (StringPlugins[i]<>nil) then
   begin
    StringPlugins[i].Clear;
    StringPlugins[i].Free;
   end;
  _count:=0;
end;

//--------------TStringAttribute---------------

function TStringAttribute.ToString():string;
type
 PSingle=^Single;
 PDWORD=^DWORD;
var
 res : string;
 y,m,d: integer;
 h,mn,s: integer;
 dt: TDateTime;
begin
 case saType of
  ATTR_TYPE_INTEGER: res:=Inttostr(Integer(pData^));
  ATTR_TYPE_FLOAT: res:=floattostr(PSingle(pData)^);
  ATTR_TYPE_STRING: res:=String(pData);
  ATTR_TYPE_DATE:
   begin
    y:=Integer((PDWORD(pData)^ and $FFFF0000)) shr 16;
    m:=(PDWORD(pData)^ and $0000FF00) shr 8;
    d:=PDWORD(pData)^ and $000000FF;
    dt:=EncodeDate(y,m,d);
    res:=DateToStr(dt);
   end;
  ATTR_TYPE_TIME:
   begin
    h:=Integer((PDWORD(pData)^ and $FFFF0000)) shr 16;
    mn:=(PDWORD(pData)^ and $0000FF00) shr 8;
    s:=PDWORD(pData)^ and $000000FF;
    dt:=EncodeTime(h,mn,s,0);
    res:=TimeToStr(dt);
   end
 else res:='';
 end;
 Result:=res;
end;

procedure TStringAttribute.Read(handle: Cardinal);
var
 dwRead,dwStrSize: DWORD;
 pName: array [1..70] of Char;
begin
 Clear;
 ReadFile(handle,saType,4,dwRead,nil);
 ReadFile(handle,dwStrSize,4,dwRead,nil);
 ReadFile(handle,pName[1],dwStrSize,dwRead,nil);
 pName[dwStrSize+1]:=Char(0);
 Name:=String(pName);
 ReadFile(handle,dwFlags,4,dwRead,nil);
 ReadFile(handle,dwSize,4,dwRead,nil);
 if (dwSize<>0) then
  begin
   if  Pos(' омментарий',Name)<>0 then
    begin
     GetMem(pData,dwSize+1);
     ReadFile(handle,pData[0],dwSize,dwRead,nil);
     pData[dwSize]:=Char(0);
    end
   else
    begin
     GetMem(pData,dwSize);
     ReadFile(handle,pData[0],dwSize,dwRead,nil);
    end;
  end;
end;

procedure TStringAttribute.Clear;
begin
 Name:='';
 dwFlags:=ATTR_OPT_ANY;
 saType:=ATTR_TYPE_ANY;
 if (pData<>nil) then
  begin
   FreeMem(pData);
   pData:=nil;
  end;
 dwSize:=0;
end;

constructor TStringAttribute.Create;
begin
 inherited;
 Name:='';
 dwFlags:=ATTR_OPT_ANY;
 saType:=ATTR_TYPE_ANY;
 dwSize:=0;
 pData:=nil;
end;

destructor TStringAttribute.Destroy;
begin
 Clear;
 inherited;
end;

//--------------TAttribs---------------

function TAttribs.GetAttributesString: string;
var
 aText: string;
begin
 aText:='';
 if (StringAttribs[10]<>nil) then aText:=aText+StringAttribs[10].ToString()+'  ƒата:';
 if (StringAttribs[11]<>nil) then  aText:=aText+StringAttribs[11].ToString()+'  ¬рем€:';
 if (StringAttribs[12]<>nil) then  aText:=aText+StringAttribs[12].ToString();
 Result:=aText;
end;

function TAttribs.GetCount(): LongInt;
begin
 Result:=_count;
end;

procedure TAttribs.Read(handle: Cardinal);
var
 i: integer;
 dwRead: DWORD;
begin
 Clear;
 ReadFile(handle,_count,4,dwRead,nil);
 for i:=1 to _count do
  begin
   StringAttribs[i]:=TStringAttribute.Create;
   StringAttribs[i].Read(handle);
  end;
end;

procedure TAttribs.Clear;
var
 i: integer;
begin
 for i:=1 to MAX_ATTR_COUNT do
   if (StringAttribs[i]<>nil) then
    begin
     StringAttribs[i].Clear;
     FreeAndNil(StringAttribs[i]);
     //StringAttribs[i].Free;
    end;

 _count:=0;
end;

constructor TAttribs.Create;
begin
 inherited;
 _count:=0;
end;

destructor TAttribs.Destroy;
begin
 Clear;
 inherited;
end;

//-----------TCurveData----------------

function TCurveData.GetPointsData: TXYSpectrData;
var
 data: TXYSpectrData;
begin
 data.XValues:=TSingleArray(XValues);
 data.YValues:=TNx2SingleArray(YValues);
 Result:=data;
end;

constructor TCurveData.Create;
begin
 inherited;
 XValues:=nil;
 YValues:=nil;
 dwSize:=0;
 dwCount:=0;
 dwLayers:=0;
end;

destructor TCurveData.Destroy;
var
 i: integer;
begin
 if (XValues<>nil) then SetLength(XValues,0);
 if (YValues<>nil) then
  begin
   for i:=0 to dwLayers-1 do
    SetLength(YValues[i],0);
   SetLength(YValues,0);
  end;
end;

procedure TCurveData.Read(handle: Cardinal);
var
 i: integer;
 dwRead: DWORD;
begin
 ReadFile(handle,dwSize,4,dwRead,nil);
 ReadFile(handle,dwCount,4,dwRead,nil);
 ReadFile(handle,dwLayers,4,dwRead,nil);
 SetLength(XValues,dwSize);
 ReadFile(handle,XValues[0],4 * dwSize,dwRead,nil);
 SetLength(YValues,dwLayers);
 for i:=0 to dwLayers-1 do
  begin
   SetLength(YValues[i],dwSize);
   ReadFile(handle,YValues[i][0],dwSize * 4,dwRead,nil);
  end;
end;

procedure TCurveData.Clear;
var
 i:integer;
begin
 if (dwSize>0) then
  begin
   SetLength(XValues,0);
   XValues:=nil;
   for i:=0 to dwLayers-1 do
    SetLength(YValues[i],0);
   SetLength(YValues,0);
   YValues:=nil;
   dwSize:=0;
   dwCount:=0;
   dwLayers:=0;
  end;
end;

end.
