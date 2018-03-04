unit uSerializable;

interface
uses
  superobject,uGenericData,Contnrs,SysUtils,uSaftyEnum;
type
////////////////////////////////////////////////////////////////////////////////
/// TSerializable 可序列化对象基类
////////////////////////////////////////////////////////////////////////////////
  TSerializable = class
  public
    constructor Create();virtual;
    destructor Destroy; override;
  private
    function GetIJson: ISuperObject;
  protected
    {JSON数据操作}
    m_GenericData: TGenericData;
    {功能:准备JSON字符串}
    procedure PrepareData();virtual;
    {功能:从JSON字符串反序列化数据}
    procedure LoadData();virtual;
  public
    {功能:序列化为字符串}
    function AsString(): string;
    {功能:反序列化字符串}
    procedure SetString(strJson: string);
    property IJson: ISuperObject read GetIJson;
    property GenericData: TGenericData read m_GenericData;
  end;


  TSerializableClass = class of TSerializable;

////////////////////////////////////////////////////////////////////////////////
/// TSerializableList 可序列化列表对象基类
////////////////////////////////////////////////////////////////////////////////
  TSerializableList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TSerializable;
    procedure SetItem(Index: Integer; AObject: TSerializable);
    function GetIJson: ISuperObject;
  public
    {功能:序列化为字符串}
    function AsString: string;
    {功能:反序列化字符串}
    procedure SetString(strJson: string;ItemClass: TSerializableClass{生成对象使用的类});overload;
    procedure SetJson(IJson: ISuperObject;ItemClass: TSerializableClass{生成对象使用的类});overload;
    procedure SetString(strJson: string);overload;virtual;
    procedure SetJson(IJson: ISuperObject);overload;virtual;
    function Add(AObject: TSerializable): Integer;
    procedure Insert(Index: Integer; AObject: TSerializable);
    property Items[Index: Integer]: TSerializable read GetItem write SetItem; default;
    property IJson: ISuperObject read GetIJson;
  end;
implementation


{ TSerializable }

constructor TSerializable.Create;
begin
  m_GenericData := TGenericData.Create;
end;

destructor TSerializable.Destroy;
begin
  m_GenericData.Free;
  inherited;
end;

function TSerializable.GetIJson: ISuperObject;
begin
  PrepareData();
  Result :=so(m_GenericData.JSON);
end;

procedure TSerializable.LoadData;
begin

end;

procedure TSerializable.PrepareData;
begin

end;

procedure TSerializable.SetString(strJson: string);
begin
  m_GenericData.JSON :=strJson;
  LoadData();
end;


function TSerializable.AsString: string;
begin
  PrepareData();
  Result := m_GenericData.JSON;
end;

{ TSerializableList }

function TSerializableList.Add(AObject: TSerializable): Integer;
begin
  Result := inherited Add(AObject);
end;

function TSerializableList.AsString: string;
var
  iJSON: ISuperObject;
  I: Integer;
begin
  iJSON := SO('[]');
  try
    for I := 0 to Count - 1 do
    begin
      Items[i].PrepareData();
      iJSON.AsArray.Add(SO(Items[i].m_GenericData.JSON));
    end;

    Result := iJSON.AsString;
  finally
    iJSON := nil;
  end;
end;

procedure TSerializableList.SetString(strJson: string;ItemClass: TSerializableClass);
var
  iJSON: ISuperObject;
begin
  iJSON := SO(strJson);
  try
    SetJson(iJSON,ItemClass);
  finally
    iJSON := nil;
  end;
end;


function TSerializableList.GetIJson: ISuperObject;
var
  iJSON: ISuperObject;
  I: Integer;
begin
  iJSON := SO('[]');
  for I := 0 to Count - 1 do
  begin
    Items[i].PrepareData();
    iJSON.AsArray.Add(SO(Items[i].m_GenericData.JSON));
  end;

  Result := iJSON;
end;

function TSerializableList.GetItem(Index: Integer): TSerializable;
begin
  Result := TSerializable(inherited GetItem(Index));
end;

procedure TSerializableList.Insert(Index: Integer; AObject: TSerializable);
begin
  inherited Insert(Index,AObject);
end;

procedure TSerializableList.SetItem(Index: Integer; AObject: TSerializable);
begin
  inherited SetItem(Index,AObject);
end;

procedure TSerializableList.SetJson(IJson: ISuperObject);
begin
  SetJson(IJson,TSerializable);
end;

procedure TSerializableList.SetJson(IJson: ISuperObject;
  ItemClass: TSerializableClass);
var
  I: Integer;
  Obj: TSerializable;
begin
  if iJSON = nil then
    raise Exception.Create('无效的JSON字符串!');
  if iJSON.DataType <> stArray  then
      raise Exception.Create('JSON字符串不是ARRAY类型无法转化为ObjectList');

  Clear();

  for I := 0 to iJSON.AsArray.Length - 1 do
  begin
    Obj := ItemClass.Create;
    Obj.SetString(iJSON.AsArray.O[i].AsString);
    Add(Obj);
  end;
end;


procedure TSerializableList.SetString(strJson: string);
begin
  SetString(strJson,TSerializable);
end;

end.
