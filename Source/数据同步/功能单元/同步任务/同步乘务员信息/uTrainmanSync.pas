unit uTrainmanSync;

interface
uses ADODB,DB,SysUtils,CustomProperties,Contnrs,Classes,DateUtils,
  uTFSystem,uSerializable,superobject,uSaftyEnum;

  
type

  //获取指纹特征的返回信息 {“result”:0,”resultStr”:”返回成功”,”signature”:”XXXXXXX”}
  RRltSignature = record
    //返回结果ID
    result : integer;
    //返回结果描述
    resultStr : string;
    //特征码
    signature : string;
  end;

   //获取乘务员信息选项
  TRltTrainmanOption = (rlttoData{不要照片指纹},rlttoPhoto{要照片不要指纹},rlttoFinger{要指纹不要照片},rlttoAll{指纹照片都要});
  //人员列表返回信息中单个乘务信息结构
  RRltTrainman = record
    nID:Integer;
    trainmanid : string;
    trainmanNumber : string;
    trainmanName : string;
    finger1 : OleVariant;
    finger2 : OleVariant;
    pic : OleVariant;
  end;
  TRltTrainmanArray = array of RRltTrainman;

  //获取乘务员列表信息事件
  TWebAPITrainmanListEvent = procedure(Index : integer;totalCount:integer;
    MaxID : integer;RltTrainmanArray :TRltTrainmanArray) of object;

    
  TTrainManList = class;
  //////////////////////////////////////////////////////////////////////////////
  /// TTrainmanFingerPrint 司机指纹信息
  //////////////////////////////////////////////////////////////////////////////
  TTrainmanFingerPrint = class(TSerializable)
  public
    constructor Create();override;
    destructor Destroy();override;
  private
    {指纹1}
    m_FingerPrint1 : TMemoryStream;
    {指纹2}
    m_FingerPrint2 : TMemoryStream;
  protected
    {功能:准备JSON字符串}
    procedure PrepareData();override;
    {功能:从JSON字符串反序列化数据}
    procedure LoadData();override;
  public
    {功能:判断指纹1是否为空}
    function Finger1IsNull():Boolean;
    {功能:判断指纹2是否为空}
    function Finger2IsNull():Boolean;
    property FingerPrint1: TMemoryStream read m_FingerPrint1;
    property FingerPrint2: TMemoryStream read m_FingerPrint2;
  end;

  //////////////////////////////////////////////////////////////////////////////
  /// TTrainmanFingerPrintList 司机指纹列表
  //////////////////////////////////////////////////////////////////////////////
  TTrainmanFingerPrintList = class(TSerializableList)
  protected
    function GetItem(Index: Integer): TTrainmanFingerPrint;
    procedure SetItem(Index: Integer; TrainmanFingerPrint: TTrainmanFingerPrint);
  public
    procedure SetString(strJson: string);overload;override;
    procedure SetJson(IJson: ISuperObject);overload;override;
    function Add(TrainmanFingerPrint: TTrainmanFingerPrint): Integer;
    property Items[Index: Integer]: TTrainmanFingerPrint read GetItem write SetItem; default;
  end;

  //////////////////////////////////////////////////////////////////////////////
  /// TTrainMan 司机数据操作管理类
  //////////////////////////////////////////////////////////////////////////////
  TTrainMan = class(TSerializable)
  public
    constructor Create();override;
    destructor Destroy; override;
  private
    {照片}
    m_Picture : TMemoryStream;
    {指纹对象}
    m_TrainmanFingerPrint: TTrainmanFingerPrint;
    {乘务员ID}
    m_strID : String;
    {乘务员姓名}
    m_strName : String;
    {乘务员工号}
    m_strNumber : String;
    {工作流程ID}
    m_strFlowID: string;
    {登陆验证方式}
    m_nVerify: TRsRegisterFlag;
  protected
    {功能:准备JSON字符串}
    procedure PrepareData();override;
    {功能:从JSON字符串反序列化数据}
    procedure LoadData();override;
  public
    procedure Clone(Source: TTrainMan);
    property strID: string read m_strID write m_strID;
    property Name: string read m_strName write m_strName;
    property Number: string read m_strNumber write m_strNumber;
    property FingerPrint: TTrainmanFingerPrint read m_TrainmanFingerPrint;
    property Picture: TMemoryStream read m_Picture;
    property FlowID: string read m_strFlowID write m_strFlowID;
    property Verify: TRsRegisterFlag read m_nVerify write m_nVerify;
  end;


  
  {乘务员对象列表}
  TTrainManList = class(TSerializableList)
  protected
    function GetItems(Index: Integer): TTrainMan;
    procedure SetItems(Index: Integer; TrainMan: TTrainMan);
  public
    procedure SetString(strJson: string);overload;override;
    procedure SetJson(IJson: ISuperObject);overload;override;    
    function Add(TrainMan: TTrainMan): Integer;
    function Remove(TrainMan: TTrainMan): Integer;
    function IndexOf(TrainMan: TTrainMan): Integer;overload;
    function IndexOf(strNumber : String): Integer;overload;
    procedure Insert(Index: Integer; TrainMan: TTrainMan);
    property Items[Index: Integer]: TTrainMan read GetItems write SetItems; default;
  end;


implementation
procedure TTrainMan.Clone(Source: TTrainMan);
begin
  SetString(Source.AsString);
end;

constructor TTrainMan.Create();
begin
  inherited;
  m_Picture := TMemoryStream.Create;
  m_TrainmanFingerPrint := TTrainmanFingerPrint.Create;
end;

destructor TTrainMan.Destroy;
begin
  m_Picture.Free;
  m_TrainmanFingerPrint.Free;
  inherited;
end;


procedure TTrainMan.LoadData;
begin
  m_strID := m_GenericData.StrField['strid'];
  Name := m_GenericData.StrField['name'];
  Number := m_GenericData.StrField['number'];
  m_strFlowID := m_GenericData.StrField['flowID'];
  m_nVerify := TRsRegisterFlag(m_GenericData.IntField['verify']);

  m_Picture.Clear;
  m_GenericData.GetBlobField('picture',m_Picture);
  m_TrainmanFingerPrint.SetString(m_GenericData.ObjectField['finger'].AsString);
end;

procedure TTrainMan.PrepareData;
begin
  m_GenericData.StrField['strid'] := m_strID;
  m_GenericData.StrField['name'] := Name;
  m_GenericData.StrField['number'] := Number;
  m_GenericData.SetBlobField('picture',m_Picture);
  m_GenericData.ObjectField['finger'] := m_TrainmanFingerPrint.IJson;

  m_GenericData.StrField['flowID'] := m_strFlowID;
  m_GenericData.IntField['verify'] := Ord(m_nVerify);
end;


{ TTrainManList }

function TTrainManList.Add(TrainMan: TTrainMan): Integer;
begin
  Result := inherited Add(TrainMan);
end;


function TTrainManList.GetItems(Index: Integer): TTrainMan;
begin
  Result := TTrainMan(inherited Items[Index]);
end;

function TTrainManList.IndexOf(TrainMan: TTrainMan): Integer;
begin
  Result := inherited IndexOf(TrainMan);
end;

function TTrainManList.IndexOf(strNumber : String): Integer;
var
  i : integer;
begin
  Result := -1;
  for I := 0 to Count - 1 do
  begin
    if Items[i].Number = strNumber then
    begin
      Result := i;
      Break;
    end;
  end;
end;

procedure TTrainManList.Insert(Index: Integer; TrainMan: TTrainMan);
begin
  inherited Insert(Index, TrainMan);
end;

function TTrainManList.Remove(TrainMan: TTrainMan): Integer;
begin
  Result := inherited Remove(TrainMan);
end;

procedure TTrainManList.SetItems(Index: Integer; TrainMan: TTrainMan);
begin
  inherited Items[Index] := TrainMan;
end;

procedure TTrainManList.SetJson(IJson: ISuperObject);
begin
  SetJson(IJson,TTrainMan);
end;

procedure TTrainManList.SetString(strJson: string);
begin
  SetString(strJson,TTrainMan);
end;

{ TGanBuDBManage }

{ TTrainmanFingerPrint }

constructor TTrainmanFingerPrint.Create;
begin
  inherited;
  m_FingerPrint1 := TMemoryStream.Create;
  m_FingerPrint2 := TMemoryStream.Create;
end;

destructor TTrainmanFingerPrint.Destroy;
begin
  m_FingerPrint1.Free;
  m_FingerPrint2.Free;
  inherited;
end;

function TTrainmanFingerPrint.Finger1IsNull: Boolean;
begin
  Result := m_FingerPrint1.Size = 0;
end;

function TTrainmanFingerPrint.Finger2IsNull: Boolean;
begin
  Result := m_FingerPrint2.Size = 0;
end;

procedure TTrainmanFingerPrint.LoadData;
begin
  m_GenericData.GetBlobField('Finger1',m_FingerPrint1);
  m_GenericData.GetBlobField('Finger2',m_FingerPrint2);
end;

procedure TTrainmanFingerPrint.PrepareData;
begin
  m_FingerPrint1.Clear;
  m_FingerPrint2.Clear;
  m_GenericData.SetBlobField('Finger1',m_FingerPrint1);
  m_GenericData.SetBlobField('Finger2',m_FingerPrint2);
end;

{ TTrainmanFingerPrintList }

function TTrainmanFingerPrintList.Add(
  TrainmanFingerPrint: TTrainmanFingerPrint): Integer;
begin
  Result := inherited Add(TrainmanFingerPrint);
end;

function TTrainmanFingerPrintList.GetItem(
  Index: Integer): TTrainmanFingerPrint;
begin
  Result := TTrainmanFingerPrint(inherited GetItem(Index));
end;

procedure TTrainmanFingerPrintList.SetItem(Index: Integer;
  TrainmanFingerPrint: TTrainmanFingerPrint);
begin
  inherited SetItem(Index,TrainmanFingerPrint);
end;

procedure TTrainmanFingerPrintList.SetJson(IJson: ISuperObject);
begin
  SetJson(IJson,TTrainmanFingerPrint);
end;

procedure TTrainmanFingerPrintList.SetString(strJson: string);
begin
  SetString(strJson,TTrainmanFingerPrint);
end;

end.
