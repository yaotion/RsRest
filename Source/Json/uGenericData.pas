unit uGenericData;

interface
uses
  Contnrs,superobject,Classes,EncdDecd;
type
////////////////////////////////////////////////////////////////////////////////
/// TGenericData  通用数据定义
////////////////////////////////////////////////////////////////////////////////
  TGenericData = class
  public
    constructor Create();
  private
    {JSON字符串}
    m_strJSON: string;
  private
    {功能:获取整型字段值}
    function GetIntField(FieldName: string): Integer;
    {功能:获取字符串字段值}
    function GetStrField(FieldName: string): string;
    {功能:获取时间类型字段值}
    function GetDtField(FieldName: string): TDateTime;
    {功能:获取布尔类型字段值}    
    function GetBooleanField(FieldName: string): Boolean;
    {功能:设置整型字段值}
    procedure SetIntField(FieldName: string; const Value: Integer);
    {功能:设置字符串字段值}
    procedure SetStrField(FieldName: string; const Value: string);
    {功能:设置时间类型字段值}
    procedure SetDtField(FieldName: string; const Value: TDateTime);
    {功能:设置布尔类型字段值}
    procedure SetBooleanField(FieldName: string; const Value: Boolean);
    {功能:获取对象类型字段值}
    function GetObjectField(FieldName: string): ISuperObject;
    {功能:设置对象类型字段值}
    procedure SetObjectField(FieldName: string; const Value: ISuperObject);
    {功能:获取JSON}
    function GetJSON: string;
    {功能:设置JSON}
    procedure SetJson(const Value: string);
  public
    {功能:保存二进制数据}
    procedure SetBlobField(FieldName: string;Mem: TStream);
    {功能:取出二进制数据}
    procedure GetBlobField(FieldName: string;Mem: TStream);
  public
    property JSON: string read GetJSON write SetJson;
    property IntField[FieldName: string]: Integer read GetIntField write SetIntField;
    property StrField[FieldName: string]: string read GetStrField write SetStrField;
    property dtField[FieldName: string]: TDateTime read GetDtField write SetDtField;
    property bField[FieldName: string]: Boolean read GetBooleanField write SetBooleanField;
    property ObjectField[FieldName: string]: ISuperObject read GetObjectField write SetObjectField;
  end;

  {TGenericDataList  通用数据列表}
  TGenericDataList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TGenericData;
    procedure SetItem(Index: Integer; AObject: TGenericData);
    function GetJSON: string;
    procedure SetJSON(const Value: string);
  public
    property Items[Index: Integer]: TGenericData read GetItem write SetItem; default;
    property JSON: string read GetJSON write SetJSON;
  end;

implementation
{ TGenericDataList }

function TGenericDataList.GetItem(Index: Integer): TGenericData;
begin
  Result := TGenericData(inherited GetItem(Index));
end;

function TGenericDataList.GetJSON: string;
var
  iJson: ISuperObject;
  iTemp: ISuperObject;
  i: Integer;
begin
  iJson := SO('[]');
  for I := 0 to Count - 1 do
  begin
    iTemp := SO(Items[i].JSON);
    iJson.AsArray.Add(iTemp);
    iTemp := nil;
  end;
  Result := iJson.AsString;
  iJson := nil;  
end;


procedure TGenericDataList.SetItem(Index: Integer; AObject: TGenericData);
begin
  inherited SetItem(Index,AObject);
end;
procedure TGenericDataList.SetJSON(const Value: string);
var
  iJson: ISuperObject;
  i: Integer;
  TFMessage: TGenericData;
begin
  Clear;
  iJson := SO(Value);

  for I := 0 to iJson.AsArray.Length - 1 do
  begin
    TFMessage := TGenericData.Create;
    TFMessage.JSON := iJson.AsArray.O[i].AsString;
    Add(TFMessage);
  end;
  iJson := nil;  
end;


{ TGenericData }

constructor TGenericData.Create;
begin
  m_strJSON := '{}';
end;


function TGenericData.GetBooleanField(FieldName: string): Boolean;
var
  iJson: ISuperObject;
begin
  iJson := SO(m_strJSON);
  Result := iJson.B[FieldName];
  iJson := nil;  
end;

function TGenericData.GetDtField(FieldName: string): TDateTime;
var
  iJson: ISuperObject;
begin
  iJson := SO(m_strJSON);
  Result := JavaToDelphiDateTime(iJson.I[FieldName]);
  iJson := nil;  
end;


function TGenericData.GetIntField(FieldName: string): Integer;
var
  iJson: ISuperObject;
begin
  iJson := SO(m_strJSON);
  Result := iJson.I[FieldName];
  iJson := nil;
end;


function TGenericData.GetJSON: string;
begin
  Result := m_strJSON;
end;

function TGenericData.GetObjectField(FieldName: string): ISuperObject;
begin
  Result := SO(m_strJSON).O[FieldName];
end;

function TGenericData.GetStrField(FieldName: string): string;
var
  iJson: ISuperObject;
begin
  iJson := SO(m_strJSON);
  Result := iJson.S[FieldName];
  iJson := nil;  
end;


procedure TGenericData.SetBooleanField(FieldName: string; const Value: Boolean);
var
  iJson: ISuperObject;
begin
  iJson := SO(m_strJSON);
  iJson.B[FieldName] := Value;
  m_strJSON := iJson.AsString;
  iJson := nil;  
end;

procedure TGenericData.SetDtField(FieldName: string; const Value: TDateTime);
var
  iJson: ISuperObject;
begin
  iJson := SO(m_strJSON);
  iJson.I[FieldName] := DelphiToJavaDateTime(Value);
  m_strJSON := iJson.AsString;
  iJson := nil;  
end;


procedure TGenericData.SetIntField(FieldName: string; const Value: Integer);
var
  iJson: ISuperObject;
begin
  iJson := SO(m_strJSON);
  iJson.I[FieldName] := Value;
  m_strJSON := iJson.AsString;
  iJson := nil;
end;


procedure TGenericData.SetJson(const Value: string);
begin
  m_strJSON := Value;
end;

procedure TGenericData.SetObjectField(FieldName: string;
  const Value: ISuperObject);
var
  iJson: ISuperObject;
begin
  iJson := SO(m_strJSON);
  iJson.O[FieldName] := Value;
  m_strJSON := iJson.AsString;
  iJson := nil;
end;

procedure TGenericData.SetStrField(FieldName: string; const Value: string);
var
  iJson: ISuperObject;
begin
  iJson := SO(m_strJSON);
  iJson.S[FieldName] := Value;
  m_strJSON := iJson.AsString;
  iJson := nil;  
end;


procedure TGenericData.SetBlobField(FieldName: string; Mem: TStream);
var
  StrMem: TStringStream;
begin
  StrMem := TStringStream.Create('');
  try
    Mem.Position := 0;
    EncodeStream(Mem,StrMem);
    StrField[FieldName] := StrMem.DataString;
  finally
    StrMem.Free;
  end;
end;



procedure TGenericData.GetBlobField(FieldName: string; Mem: TStream);
var
  StrMem: TStringStream;
begin
  StrMem := TStringStream.Create(StrField[FieldName]);
  try
    //如果有Clear方法，则调用Clear.以防外部忘记先清除原有内容;
    if Mem is TMemoryStream then
    begin
      (Mem as TMemoryStream).Clear;
    end;
    
    DecodeStream(StrMem,Mem);
  finally
    StrMem.Free;
  end;
end;

end.
