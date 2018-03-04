unit uGenericData;

interface
uses
  Contnrs,superobject,Classes,EncdDecd;
type
////////////////////////////////////////////////////////////////////////////////
/// TGenericData  ͨ�����ݶ���
////////////////////////////////////////////////////////////////////////////////
  TGenericData = class
  public
    constructor Create();
  private
    {JSON�ַ���}
    m_strJSON: string;
  private
    {����:��ȡ�����ֶ�ֵ}
    function GetIntField(FieldName: string): Integer;
    {����:��ȡ�ַ����ֶ�ֵ}
    function GetStrField(FieldName: string): string;
    {����:��ȡʱ�������ֶ�ֵ}
    function GetDtField(FieldName: string): TDateTime;
    {����:��ȡ���������ֶ�ֵ}    
    function GetBooleanField(FieldName: string): Boolean;
    {����:���������ֶ�ֵ}
    procedure SetIntField(FieldName: string; const Value: Integer);
    {����:�����ַ����ֶ�ֵ}
    procedure SetStrField(FieldName: string; const Value: string);
    {����:����ʱ�������ֶ�ֵ}
    procedure SetDtField(FieldName: string; const Value: TDateTime);
    {����:���ò��������ֶ�ֵ}
    procedure SetBooleanField(FieldName: string; const Value: Boolean);
    {����:��ȡ���������ֶ�ֵ}
    function GetObjectField(FieldName: string): ISuperObject;
    {����:���ö��������ֶ�ֵ}
    procedure SetObjectField(FieldName: string; const Value: ISuperObject);
    {����:��ȡJSON}
    function GetJSON: string;
    {����:����JSON}
    procedure SetJson(const Value: string);
  public
    {����:�������������}
    procedure SetBlobField(FieldName: string;Mem: TStream);
    {����:ȡ������������}
    procedure GetBlobField(FieldName: string;Mem: TStream);
  public
    property JSON: string read GetJSON write SetJson;
    property IntField[FieldName: string]: Integer read GetIntField write SetIntField;
    property StrField[FieldName: string]: string read GetStrField write SetStrField;
    property dtField[FieldName: string]: TDateTime read GetDtField write SetDtField;
    property bField[FieldName: string]: Boolean read GetBooleanField write SetBooleanField;
    property ObjectField[FieldName: string]: ISuperObject read GetObjectField write SetObjectField;
  end;

  {TGenericDataList  ͨ�������б�}
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
    //�����Clear�����������Clear.�Է��ⲿ���������ԭ������;
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
